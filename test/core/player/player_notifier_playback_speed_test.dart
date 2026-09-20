import 'dart:async';
import 'dart:io';
import 'package:hive_ce/hive.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ppplayer/core/models/track.dart';
import 'package:ppplayer/core/player/player_provider.dart';
import 'package:ppplayer/core/models/resolved_video_candidate.dart';
import 'package:ppplayer/core/playback/playback_providers.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart' as yt;
import 'package:ppplayer/core/services/settings_provider.dart';

class FakeSettingsNotifier extends SettingsNotifier {
  @override
  SettingsState build() => SettingsState(
    selectedCountry: 'US',
    autoplayEnabled: false,
    isLoaded: true,
  );
}

class FakePlaybackService implements PlaybackService {
  List<ResolvedVideoCandidate> candidates = [
    const ResolvedVideoCandidate(
      videoId: 'online_vid1',
      title: 'T',
      channel: 'C',
      confidenceScore: 1.0,
    ),
  ];

  @override
  Ref get ref => throw UnimplementedError();

  @override
  Future<List<ResolvedVideoCandidate>> resolveCandidates(
    Track track,
    String? regionCode,
  ) async {
    return candidates;
  }

  @override
  Future<void> cacheYoutubeId(String spotifyId, String? youtubeId) async {}
  @override
  Future<void> recordPlay(Track track) async {}
  Future<void> registerAppTrack(Track track) async {}
  Future<Track?> getTrack(String spotifyId) async => null;

  @override
  Future<List<Track>> getPlaylistTracks(int playlistId) async => [];
  @override
  Future<List<Track>> getRadioTracks(String artistId) async => [];
  @override
  Future<List<Track>> getRecentlyPlayed({int limit = 50}) async => [];
  @override
  Future<void> prefetchNext(Track track, String? regionCode) async {}
  @override
  Future<void> toggleFavorite(Track track, bool isFavorite) async {}
}

class SpeedMockEngine implements PlaybackController {
  bool _supportsSpeed = true;
  final _statusController = StreamController<PlaybackStatus>.broadcast();
  double? lastSetSpeed;

  void setSupportsSpeed(bool val) => _supportsSpeed = val;

  @override
  bool get supportsSpeed => _supportsSpeed;

  @override
  bool get supportsVideoFitMode => false;

  @override
  Stream<PlaybackStatus> get statusStream => _statusController.stream;

  @override
  Stream<PlaybackEvent> get eventStream => const Stream.empty();

  @override
  PlaybackStatus get currentStatus => const PlaybackStatus();

  @override
  Future<void> play(
    PlaybackTrack track, {
    Duration startAt = Duration.zero,
  }) async {
    _statusController.add(const PlaybackStatus(state: PlaybackState.playing));
  }

  @override
  Future<void> pause({
    String caller = 'user',
    bool failOnTimeout = false,
  }) async {}

  @override
  Future<void> prepare(PlaybackTrack track, {Duration? position}) async {}

  @override
  Future<void> resume() async {}

  @override
  Future<void> stop() async {}

  @override
  Future<void> seekTo(Duration position) async {}

  @override
  Future<void> setVolume(double volume) async {}

  @override
  bool get supportsExternalSubtitles => false;

  @override
  bool get supportsSubtitleDelay => false;

  @override
  bool get supportsSubtitleTextSize => false;

  @override
  bool get supportsSubtitleBackgroundStyling => false;

  @override
  bool get supportsTrackSelection => false;

  Future<void> setSubtitleDelay(Duration delay) async {}
  @override
  Future<void> setSubtitleAppearance({double? textSize, int? backgroundColor}) async {}

  @override
  Future<void> setSpeed(double speed) async {
    if (!supportsSpeed) {
      throw UnsupportedError('Speed is not supported');
    }
    lastSetSpeed = speed;
  }

  @override
  dynamic get renderer => null;

  @override
  yt.YoutubePlayerController? get youtubeController => null;

  @override
  Future<void> dispose() async {
    _statusController.close();
  }

  @override
  Future<void> setSubtitleTrack(String? uri) async {}
}

void main() {
  late ProviderContainer container;
  late SpeedMockEngine engine;

  setUp(() {
    Hive.init(Directory.systemTemp.createTempSync('hive_test').path);

    engine = SpeedMockEngine();

    container = ProviderContainer(
      overrides: [
        settingsProvider.overrideWith(() => FakeSettingsNotifier()),
        playbackServiceProvider.overrideWithValue(FakePlaybackService()),
        playbackControllerProvider.overrideWithValue(engine),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('Playback Speed in PlayerNotifier', () {
    test(
      'setSpeed sets state and delegates to local engine when playing local',
      () async {
        final notifier = container.read(playerProvider.notifier);

        // Simulate local playback meaning engine supports speed
        engine.setSupportsSpeed(true);

        const localTrack = Track(
          spotifyId: 'local:1',
          name: 'Local',
          artistId: '1',
          artistName: 'Artist',
          durationMs: 1000,
          sourceType: TrackSourceType.local,
        );

        await notifier.playTrack(localTrack);
        await Future.delayed(Duration.zero);

        await notifier.setSpeed(1.5);

        expect(container.read(playerProvider).speed, 1.5);
        expect(engine.lastSetSpeed, 1.5);
      },
    );

    test('setSpeed throws/ignores or resets when online is playing', () async {
      final notifier = container.read(playerProvider.notifier);

      engine.setSupportsSpeed(false);

      const onlineTrack = Track(
        spotifyId: 'online:1',
        name: 'Online',
        artistId: '1',
        artistName: 'Artist',
        durationMs: 1000,
        sourceType: TrackSourceType.online,
      );

      await notifier.playTrack(onlineTrack);
      await Future.delayed(Duration.zero);

      try {
        await notifier.setSpeed(1.5);
      } catch (e) {
        // Ignored
      }

      expect(container.read(playerProvider).speed, 1.0);
    });

    test(
      'transitions between supported and unsupported tracks reset/preserve speed correctly',
      () async {
        final notifier = container.read(playerProvider.notifier);

        engine.setSupportsSpeed(true);
        const localTrack = Track(
          spotifyId: 'local:1',
          name: 'Local',
          artistId: '1',
          artistName: 'Artist',
          durationMs: 1000,
          sourceType: TrackSourceType.local,
        );

        await notifier.playTrack(localTrack);
        await Future.delayed(Duration.zero);

        await notifier.setSpeed(1.5);
        expect(container.read(playerProvider).speed, 1.5);
        expect(engine.lastSetSpeed, 1.5);

        // Transition to online
        engine.setSupportsSpeed(false);
        const onlineTrack = Track(
          spotifyId: 'online:1',
          name: 'Online',
          artistId: '1',
          artistName: 'Artist',
          durationMs: 1000,
          sourceType: TrackSourceType.online,
        );

        await notifier.playTrack(onlineTrack);
        await Future.delayed(Duration.zero);

        // State should have reset to 1.0
        expect(container.read(playerProvider).speed, 1.0);

        // Transition back to local
        engine.setSupportsSpeed(true);
        await notifier.playTrack(localTrack);
        await Future.delayed(Duration.zero);

        // It should apply the current state speed (which is now 1.0 due to the reset)
        expect(container.read(playerProvider).speed, 1.0);
        expect(engine.lastSetSpeed, 1.0);
      },
    );
  });
}
