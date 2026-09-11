import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';
import 'package:ppplayer/core/playback/media_handler.dart';
import 'package:ppplayer/core/playback/media_sync_service.dart';
import 'package:ppplayer/core/playback/playback_providers.dart';
import 'package:ppplayer/core/player/player_provider.dart';
import 'package:ppplayer/core/services/settings_provider.dart';
import 'package:ppplayer/core/models/resolved_video_candidate.dart';
// ignore: depend_on_referenced_packages
import 'package:youtube_player_iframe/youtube_player_iframe.dart' as yt;
// Shared test fixture lives in the nested engine package.
// ignore: avoid_relative_lib_imports
import '../../../lib/core/playback/packages/pp_playback_engine/test/fake_youtube_controller.dart';
import '../player/player_notifier_retry_test.dart' as fakes;

class EntryService extends fakes.FakePlaybackService {
  @override
  Future<List<ResolvedVideoCandidate>> resolveCandidates(
    Track track,
    String? regionCode,
  ) async => [
    ResolvedVideoCandidate(
      videoId: track.youtubeVideoId!,
      title: track.name,
      channel: 'test',
      confidenceScore: 1,
    ),
  ];
}

void main() {
  for (final entry in ['selection', 'retry', 'queue', 'restore']) {
    test(
      '$entry prepares while stopped and foreground resume dispatches current video',
      () async {
        final directory = await Directory.systemTemp.createTemp(
          'ppplayer-entry-',
        );
        Hive.init(directory.path);
        final box = await Hive.openBox('player_state');
        final first = fakes.trackWith(youtubeVideoId: 'videoAAAAAA');
        final second = fakes.trackWith(
          youtubeVideoId: 'videoBBBBBB',
          spotifyId: 'second',
        );
        if (entry == 'restore') {
          await box.put(
            'queue',
            jsonEncode(PlaybackQueue(tracks: [first]).toJson()),
          );
          await box.put('positionMs', 5000);
        }
        final renderer = FakeYoutubeController();
        final engine = MediaKitPlaybackEngine(
          youtubeControllerFactory: (_, _) => renderer,
        );
        final container = ProviderContainer(
          overrides: [
            playbackControllerProvider.overrideWithValue(engine),
            playbackServiceProvider.overrideWithValue(EntryService()),
            settingsProvider.overrideWith(fakes.FakeSettingsNotifier.new),
          ],
        );
        final subscription = container.listen(playerProvider, (_, _) {});
        final notifier = container.read(playerProvider.notifier);
        MediaKitPlaybackEngine.isActivityStopped = true;
        try {
          await notifier.persistenceSettled;
          if (entry == 'restore') {
            notifier.resume();
            await Future<void>(() {});
          } else {
            await notifier.playTrack(first, queue: [first, second]);
            if (entry == 'retry') await notifier.retryLoad();
            if (entry == 'queue') {
              notifier.skipNext();
              await Future<void>(() {});
            }
          }
          final expectedId = entry == 'queue' ? 'videoBBBBBB' : 'videoAAAAAA';
          expect(renderer.count('cue'), 0);
          expect(renderer.count('load'), 0);
          expect(renderer.count('play'), 0);

          MediaKitPlaybackEngine.isActivityStopped = false;
          notifier.resume();
          await Future<void>(() {});

          expect(
            renderer.commands
                .where((c) => c.name == 'load')
                .last
                .parameters['videoId'],
            expectedId,
          );

          if (entry == 'restore') {
            expect(
              renderer.commands
                  .where((c) => c.name == 'load')
                  .last
                  .parameters['startSeconds'],
              5.0,
            );
          }
          expect(renderer.count('play'), 0);
        } finally {
          subscription.close();
          container.dispose();
          await notifier.persistenceSettled;
          engine.dispose();
          MediaKitPlaybackEngine.isActivityStopped = false;
          await Hive.close();
          await directory.delete(recursive: true);
        }
      },
    );
  }

  test(
    'engine pause propagates through player and handler while bridge is pending; stale states cannot restore playing',
    () async {
      final directory = await Directory.systemTemp.createTemp('ppplayer-sync-');
      Hive.init(directory.path);
      await Hive.openBox('player_state');
      final renderer = FakeYoutubeController();
      final engine = MediaKitPlaybackEngine(
        youtubeControllerFactory: (_, _) => renderer,
      );
      late ProviderContainer container;
      final handler = PpPlayerAudioHandler(() => container);
      container = ProviderContainer(
        overrides: [
          playbackControllerProvider.overrideWithValue(engine),
          playbackServiceProvider.overrideWithValue(
            fakes.FakePlaybackService(),
          ),
          settingsProvider.overrideWith(fakes.FakeSettingsNotifier.new),
          audioHandlerProvider.overrideWithValue(handler),
        ],
      );
      final notifier = container.read(playerProvider.notifier);
      final playerSubscription = container.listen(playerProvider, (_, _) {});
      final syncSubscription = container.listen(
        mediaSyncServiceProvider,
        (_, _) {},
      );
      try {
        await notifier.persistenceSettled;
        await engine.play(const PlaybackTrack(id: 'videoAAAAAA', title: 'A'));
        renderer.emitState('videoAAAAAA', yt.PlayerState.cued);
        renderer.emitState('videoAAAAAA', yt.PlayerState.playing);
        await Future<void>(() {});
        expect(container.read(playerProvider).isPlaying, true);
        expect(handler.playbackState.value.playing, true);
        renderer.pauseCompletion = Completer<void>();
        final paused = engine.pause();
        expect(engine.currentStatus.state, PlaybackState.paused);
        await Future<void>(() {});
        expect(renderer.pauseCompletion!.isCompleted, false);
        expect(container.read(playerProvider).isPlaying, false);
        expect(handler.playbackState.value.playing, false);
        renderer.emitState('videoAAAAAA', yt.PlayerState.playing);
        renderer.emitState('videoAAAAAA', yt.PlayerState.buffering);
        await Future<void>(() {});
        expect(handler.playbackState.value.playing, false);
        renderer.pauseCompletion!.complete();
        await paused;
        expect(handler.playbackState.value.playing, false);
      } finally {
        syncSubscription.close();
        playerSubscription.close();
        container.dispose();
        await notifier.persistenceSettled;
        engine.dispose();
        await Hive.close();
        await directory.delete(recursive: true);
      }
    },
  );
}
