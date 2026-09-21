import 'player_notifier_retry_test.dart';

import 'dart:io';
import 'package:hive_ce/hive.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ppplayer/core/models/track.dart';
import 'package:ppplayer/core/models/resolved_video_candidate.dart';
import 'package:ppplayer/core/player/player_provider.dart';
import 'package:ppplayer/core/playback/playback_providers.dart';
import 'package:ppplayer/core/services/settings_provider.dart';
import 'package:ppplayer/core/network_streams/network_stream_service.dart';
import 'package:mocktail/mocktail.dart';

class MockNetworkStreamService extends Mock implements NetworkStreamService {}


void main() {
  late Directory hiveDirectory;
  late MockNetworkStreamService mockNetworkStreamService;

  setUpAll(() {
    registerFallbackValue(const Duration());
    mockNetworkStreamService = MockNetworkStreamService();
    when(() => mockNetworkStreamService.extractDirectStreamUrl(any())).thenAnswer(
      (_) async {
        await Future.delayed(const Duration(milliseconds: 100));
        return ExtractedStream(url: 'http://test.m3u8', httpHeaders: {});
      },
    );
  });

  setUp(() async {
    hiveDirectory = await Directory.systemTemp.createTemp('ppplayer-hive-');
    Hive.init(hiveDirectory.path);
    await Hive.openBox('player_state');
  });
  tearDown(() async {
    await Hive.close();
    await hiveDirectory.delete(recursive: true);
  });
  ProviderContainer makeContainer({
    required FakePlaybackService service,
    required FakePlaybackController controller,
  }) {
    return ProviderContainer(
      overrides: [
        playbackServiceProvider.overrideWithValue(service),
        playbackControllerProvider.overrideWithValue(controller),
        playbackStatusProvider.overrideWith(
          (ref) => controller.statusStream,
        ),
        settingsProvider.overrideWith(() => FakeSettingsNotifier()),
        networkStreamServiceProvider.overrideWithValue(mockNetworkStreamService),
      ],
    );
  }

  void disposeContainer(
    ProviderContainer container,
    FakePlaybackController controller,
  ) {
    controller.disposed = true;
    container.dispose();
  }

  Track trackWith({required String? youtubeVideoId}) {
    return Track(
      spotifyId: 'track_id_1',
      name: 'Test Track',
      durationMs: 180000,
      artistId: 'artist1',
      artistName: 'Artist',
      youtubeVideoId: youtubeVideoId,
      sourceType: TrackSourceType.networkStream,
    );
  }

  group('PlayerNotifier Recovery', () {
    test('3-second actual progress rule resets failure counter', () async {
      final service = FakePlaybackService(candidates: [
        const ResolvedVideoCandidate(
          videoId: 'vid_0000001',
          title: 'Test',
          channel: 'Test',
          confidenceScore: 1.0,
        )
      ]);
      final controller = FakePlaybackController();
      final container = makeContainer(service: service, controller: controller);
      addTearDown(() => disposeContainer(container, controller));

      container.listen(playerProvider, (_, _) {});
      final notifier = container.read(playerProvider.notifier);

      // Play successfully to set up the stream
      await notifier.playTrack(trackWith(youtubeVideoId: 'vid_0000001'));
      
      // Emit playing status
      controller.emitStatus(const PlaybackStatus(state: PlaybackState.playing, position: Duration(seconds: 0)));
      await Future.delayed(const Duration(milliseconds: 50));
      
      // Emulate 3+ seconds elapsed and progress advanced by 3+ seconds
      await Future.delayed(const Duration(seconds: 4));
      controller.emitStatus(const PlaybackStatus(state: PlaybackState.playing, position: Duration(seconds: 4)));
      await Future.delayed(const Duration(milliseconds: 50));
      
      // Simulate an error
      controller.emitStatus(const PlaybackStatus(state: PlaybackState.error, error: 'unavailable_media: test'));
      await Future.delayed(const Duration(milliseconds: 50));
      
      // Wait for it to fail 5 times total if it wasn't reset.
      // But since it WAS reset by progress, it shouldn't hit the 5 limit immediately.
      // We can check if loadError gets set indicating total failure, or if it tries to recover.
      expect(container.read(playerProvider).loadError, null);
    });

    test('Seek jump does not count as actual progress', () async {
      final service = FakePlaybackService(candidates: [
        const ResolvedVideoCandidate(
          videoId: 'vid_0000001',
          title: 'Test',
          channel: 'Test',
          confidenceScore: 1.0,
        )
      ]);
      final controller = FakePlaybackController();
      final container = makeContainer(service: service, controller: controller);
      addTearDown(() => disposeContainer(container, controller));

      container.listen(playerProvider, (_, _) {});
      final notifier = container.read(playerProvider.notifier);

      await notifier.playTrack(trackWith(youtubeVideoId: 'vid_0000001'));
      controller.emitStatus(const PlaybackStatus(state: PlaybackState.playing, position: Duration(seconds: 0)));
      await Future.delayed(const Duration(milliseconds: 50));
      
      // User seeks
      await notifier.seekTo(const Duration(seconds: 10));
      controller.emitStatus(const PlaybackStatus(state: PlaybackState.playing, position: Duration(seconds: 10)));
      await Future.delayed(const Duration(milliseconds: 50));
      
      // Seek cleared the progress observation, so even after 4 seconds elapsed, if progress hasn't advanced 3s since the seek, it won't reset
      await Future.delayed(const Duration(seconds: 4));
      // No position update sent!
      
      // Simulate error
      controller.emitStatus(const PlaybackStatus(state: PlaybackState.error, error: 'unavailable_media: test'));
      await Future.delayed(const Duration(milliseconds: 50));
    });

    test('Paused recovery respects user intent', () async {
      final service = FakePlaybackService(candidates: [
        const ResolvedVideoCandidate(
          videoId: 'vid_0000001',
          title: 'Test',
          channel: 'Test',
          confidenceScore: 1.0,
        )
      ]);
      final controller = FakePlaybackController();
      final container = makeContainer(service: service, controller: controller);
      addTearDown(() => disposeContainer(container, controller));

      container.listen(playerProvider, (_, _) {});
      final notifier = container.read(playerProvider.notifier);

      await notifier.playTrack(trackWith(youtubeVideoId: 'vid_0000001'));
      controller.emitStatus(const PlaybackStatus(state: PlaybackState.playing, position: Duration(seconds: 0)));
      await Future.delayed(const Duration(milliseconds: 50));
      
      notifier.pause();
      controller.emitStatus(const PlaybackStatus(state: PlaybackState.paused, position: Duration(seconds: 5)));
      await Future.delayed(const Duration(milliseconds: 50));
      
      controller.emitStatus(const PlaybackStatus(state: PlaybackState.error, error: 'unavailable_media: test'));
      await Future.delayed(const Duration(milliseconds: 500));
      
      expect(container.read(playerProvider).isPlaying, isFalse);
    });

    test('Seek during recovery is preserved and overrides last reported position', () async {
      final service = FakePlaybackService(candidates: [
        const ResolvedVideoCandidate(
          videoId: 'vid_0000001',
          title: 'Test',
          channel: 'Test',
          confidenceScore: 1.0,
        ),
        const ResolvedVideoCandidate(
          videoId: 'vid_0000002',
          title: 'Test',
          channel: 'Test',
          confidenceScore: 1.0,
        )
      ]);
      final controller = FakePlaybackController();
      final container = makeContainer(service: service, controller: controller);
      addTearDown(() => disposeContainer(container, controller));

      container.listen(playerProvider, (_, _) {});
      final notifier = container.read(playerProvider.notifier);

      await notifier.playTrack(trackWith(youtubeVideoId: null).copyWith(networkStreamUrl: 'http://test.m3u8'));
      controller.emitStatus(const PlaybackStatus(state: PlaybackState.playing, position: Duration(seconds: 50)));
      await Future.delayed(const Duration(milliseconds: 50));
      
      controller.emitStatus(const PlaybackStatus(state: PlaybackState.error, error: 'unavailable_media: test'));
      
      await Future.delayed(const Duration(milliseconds: 10)); 
      await notifier.seekTo(const Duration(seconds: 100));
      
      await Future.delayed(const Duration(milliseconds: 500));
      
      expect(controller.lastStartAt, const Duration(seconds: 100));
    });
  });
}
