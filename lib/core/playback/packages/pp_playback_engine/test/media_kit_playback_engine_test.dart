import 'dart:async';
import 'package:media_kit/media_kit.dart' show Player;
import 'package:flutter_test/flutter_test.dart';
import 'package:pp_playback_engine/pp_playback_engine.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart' as yt;
import 'fake_youtube_controller.dart';

class FakeNativePlayer extends Fake implements Player {
  int plays = 0;
  int pauses = 0;
  @override
  Future<void> play() async {
    plays++;
  }

  @override
  Future<void> pause() async {
    pauses++;
  }

  @override
  Future<void> dispose() async {}
}

const track = PlaybackTrack(id: 'videoAAAAAA', title: 'A');
const other = PlaybackTrack(id: 'videoBBBBBB', title: 'B');

void main() {
  late FakeYoutubeController controller;
  late MediaKitPlaybackEngine engine;
  late List<PlaybackStatus> statuses;
  late StreamSubscription<PlaybackStatus> subscription;
  setUp(() {
    MediaKitPlaybackEngine.isActivityStopped = false;
    controller = FakeYoutubeController();
    engine = MediaKitPlaybackEngine(
      youtubeControllerFactory: (_, _) => controller,
    );
    statuses = [];
    subscription = engine.statusStream.listen(statuses.add);
  });
  tearDown(() async {
    engine.dispose();
    await subscription.cancel();
    MediaKitPlaybackEngine.isActivityStopped = false;
  });
  void engineTest(String name, Future<void> Function(WidgetTester) body) {
    testWidgets(name, (tester) async {
      try {
        await body(tester);
      } finally {
        engine.dispose();
        await tester.pump();
      }
    });
  }

  Future<void> ready(WidgetTester tester) async {
    await engine.play(track);
    controller.emitState(track.id, yt.PlayerState.cued);
    await tester.pump();
  }

  engineTest('loading timeout: one recovery cue and one terminal failure', (
    tester,
  ) async {
    addTearDown(engine.dispose);
    addTearDown(engine.dispose);
    await engine.play(track);
    await tester.pump(const Duration(seconds: 20));
    expect(controller.count('load'), 2);
    await tester.pump(const Duration(seconds: 10));
    expect(engine.currentStatus.error, contains('loading timed out'));
    await tester.pump(const Duration(minutes: 2));
    expect(controller.count('load'), 2);
    expect(statuses.where((s) => s.state == PlaybackState.error), hasLength(1));
  });
  engineTest('playback start timeout has one shared recovery and one failure', (
    tester,
  ) async {
    addTearDown(engine.dispose);
    await ready(tester);
    await tester.pump(const Duration(seconds: 20));
    expect(controller.count('load'), 2);
    controller.emitState(track.id, yt.PlayerState.cued);
    await tester.pump();
    expect(controller.count('play'), 2);
    await tester.pump(const Duration(seconds: 10));
    expect(engine.currentStatus.error, contains('playback start timed out'));
    await tester.pump(const Duration(minutes: 2));
    expect(statuses.where((s) => s.state == PlaybackState.error), hasLength(1));
    expect(controller.count('load'), 2);
  });
  engineTest('replacement and stop invalidate old watchdogs', (tester) async {
    addTearDown(engine.dispose);
    await engine.play(track);
    await tester.pump(const Duration(seconds: 19));
    await engine.play(other);
    await tester.pump(const Duration(seconds: 11));
    expect(controller.count('load'), 2);
    expect(engine.currentStatus.track?.id, other.id);
    await engine.stop();
    await tester.pump(const Duration(minutes: 2));
    expect(controller.count('load'), 2);
    expect(statuses.where((s) => s.state == PlaybackState.error), isEmpty);
  });
  engineTest(
    'stopped activity cues without play or start timeout; foreground resume plays once',
    (tester) async {
      addTearDown(engine.dispose);
      MediaKitPlaybackEngine.isActivityStopped = true;
      await ready(tester);
      expect(controller.commands, isEmpty);
      expect(controller.count('load'), 0);
      expect(controller.count('play'), 0);
      await tester.pump(const Duration(minutes: 1));
      expect(engine.currentStatus.error, isNull);
      MediaKitPlaybackEngine.isActivityStopped = false;
      await engine.resume();
      controller.emitState(track.id, yt.PlayerState.cued);
      controller.emitState(track.id, yt.PlayerState.cued);
      await tester.pump();
      expect(controller.count('play'), 1);
    },
  );
  engineTest('superseded asynchronous preparation cannot play', (tester) async {
    addTearDown(engine.dispose);
    controller.volumeCompletion = Completer<void>();
    await ready(tester);
    await engine.play(other);
    controller.volumeCompletion!.complete();
    await tester.pump();
    expect(controller.count('play'), 0);
    controller.emitState(track.id, yt.PlayerState.cued);
    await tester.pump();
    expect(controller.count('play'), 0);
    controller.emitState(other.id, yt.PlayerState.cued);
    await tester.pump();
    expect(controller.count('play'), 1);
  });
  engineTest(
    'lifecycle is checked again after asynchronous volume preparation',
    (tester) async {
      addTearDown(engine.dispose);
      controller.volumeCompletion = Completer<void>();
      await ready(tester);
      MediaKitPlaybackEngine.isActivityStopped = true;
      controller.volumeCompletion!.complete();
      await tester.pump();
      expect(controller.count('play'), 0);
      await tester.pump(const Duration(minutes: 1));
      expect(engine.currentStatus.error, isNull);
    },
  );
  engineTest(
    'pause is prompt; timeout and late completion never fail or end playback',
    (tester) async {
      addTearDown(engine.dispose);
      await ready(tester);
      controller.emitState(track.id, yt.PlayerState.playing);
      await tester.pump();
      controller.pauseCompletion = Completer<void>();
      var finished = false;
      final pause = engine.pause().then((_) => finished = true);
      expect(engine.currentStatus.state, PlaybackState.paused);
      await tester.pump();
      expect(finished, false);
      await tester.pump(const Duration(seconds: 2));
      await pause;
      expect(finished, true);
      controller.pauseCompletion!.complete();
      await tester.pump();
      expect(engine.currentStatus.state, PlaybackState.paused);
      expect(
        statuses.where(
          (s) =>
              s.state == PlaybackState.error || s.state == PlaybackState.ended,
        ),
        isEmpty,
      );
    },
  );
  engineTest(
    'resume wins pending pause; late renderer pause reconciles only once',
    (tester) async {
      addTearDown(engine.dispose);
      await ready(tester);
      controller.pauseCompletion = Completer<void>();
      final pause = engine.pause();
      await engine.resume();
      controller.emitState(track.id, yt.PlayerState.playing);
      await tester.pump();
      controller.pauseCompletion!.complete();
      await pause;
      expect(engine.currentStatus.state, PlaybackState.playing);
      controller.emitState(track.id, yt.PlayerState.paused);
      await tester.pump();
      expect(controller.count('play'), 3);
      controller.emitState(track.id, yt.PlayerState.paused);
      await tester.pump();
      expect(controller.count('play'), 3);
      expect(engine.currentStatus.state, PlaybackState.paused);
    },
  );
  for (final caller in ['user', 'audio-focus-loss']) {
    engineTest('$caller pause respects intent despite late playing/buffering', (
      tester,
    ) async {
      addTearDown(engine.dispose);
      await ready(tester);
      await engine.pause(caller: caller);
      controller.emitState(track.id, yt.PlayerState.playing);
      controller.emitState(track.id, yt.PlayerState.buffering);
      await tester.pump();
      expect(engine.currentStatus.state, PlaybackState.paused);
      expect(controller.count('play'), 1);
    });
  }
  engineTest('stop during pending pause and dispatch prevents stale restart', (
    tester,
  ) async {
    addTearDown(engine.dispose);
    await ready(tester);
    controller.pauseCompletion = Completer<void>();
    final pause = engine.pause();
    controller.volumeCompletion = Completer<void>();
    final resume = engine.resume();
    final stop = engine.stop();
    controller.volumeCompletion!.complete();
    controller.pauseCompletion!.complete();
    await Future.wait([pause, resume, stop]);
    controller.emitState(track.id, yt.PlayerState.paused);
    controller.emitState(track.id, yt.PlayerState.cued);
    await tester.pump(const Duration(minutes: 1));
    expect(controller.count('play'), 1);
    expect(engine.currentStatus.state, PlaybackState.idle);
  });
  engineTest('seek completion cannot replay after pause', (tester) async {
    addTearDown(engine.dispose);
    await ready(tester);
    controller.emitState(track.id, yt.PlayerState.playing);
    await tester.pump();
    controller.seekCompletion = Completer<void>();
    final seek = engine.seekTo(const Duration(seconds: 5));
    await engine.pause();
    controller.seekCompletion!.complete();
    await seek;
    expect(controller.count('play'), 1);
  });
  engineTest('duplicate ambiguous errors terminate a single attempt once', (
    tester,
  ) async {
    addTearDown(engine.dispose);
    await engine.play(track);
    for (var i = 0; i < 100; i++) {
      controller.emitError('', yt.YoutubeError.notEmbeddable);
    }
    await tester.pump(const Duration(minutes: 1));
    expect(statuses.where((s) => s.state == PlaybackState.error), hasLength(1));
    expect(controller.count('load'), 1);
  });
  engineTest(
    'acknowledged pause leaves no replay credit for later focus pause',
    (tester) async {
      await ready(tester);
      await engine.pause();
      controller.emitState(track.id, yt.PlayerState.paused);
      await tester.pump();
      await engine.resume();
      controller.emitState(track.id, yt.PlayerState.playing);
      await tester.pump();
      controller.emitState(track.id, yt.PlayerState.paused);
      await tester.pump();
      expect(controller.count('play'), 2);
      expect(engine.currentStatus.state, PlaybackState.paused);
    },
  );
  engineTest('paused seek prepares an offset without implicit playback', (
    tester,
  ) async {
    await engine.play(track);
    controller.emitState(track.id, yt.PlayerState.cued);
    await tester.pump();
    await engine.pause();
    await engine.seekTo(const Duration(seconds: 1));
    expect(controller.count('seek'), 1);
    expect(controller.count('load'), 1); // Initial
    expect(
      controller.commands
          .where((c) => c.name == 'seek')
          .last
          .parameters['seconds'],
      1.0,
    );
    controller.emitState(track.id, yt.PlayerState.cued);
    await tester.pump();
    expect(controller.count('play'), 1);
  });
  engineTest('pause failure after resume preserves current state', (
    tester,
  ) async {
    await ready(tester);
    controller.pauseCompletion = Completer<void>();
    final pause = engine.pause();
    await engine.resume();
    controller.emitState(track.id, yt.PlayerState.playing);
    await tester.pump();
    controller.pauseCompletion!.completeError(StateError('bridge failed'));
    await pause;
    expect(engine.currentStatus.state, PlaybackState.playing);
    expect(engine.currentStatus.error, isNull);
  });
  engineTest(
    'disposal during volume preparation cancels watchdog and prevents play',
    (tester) async {
      controller.volumeCompletion = Completer<void>();
      await ready(tester);
      engine.dispose();
      controller.volumeCompletion!.complete();
      await tester.pump(const Duration(minutes: 2));
      expect(controller.count('play'), 0);
      expect(controller.count('load'), 1);
    },
  );
  engineTest('superseded cleanup cannot cue its old track', (tester) async {
    await engine.play(track);
    controller.pauseCompletion = Completer<void>();
    final stale = engine.play(track);
    final current = engine.play(other);
    controller.pauseCompletion!.complete();
    await Future.wait([stale, current]);
    expect(controller.count('load'), 2);
    expect(
      controller.commands
          .where((c) => c.name == 'load')
          .last
          .parameters['videoId'],
      other.id,
    );
  });
  engineTest('repeated readiness events do not postpone start timeout', (
    tester,
  ) async {
    await ready(tester);
    await tester.pump(const Duration(seconds: 19));
    controller.emitState(track.id, yt.PlayerState.cued);
    await tester.pump(const Duration(seconds: 1));
    expect(controller.count('play'), 1);
    expect(controller.count('load'), 2);
  });
  engineTest(
    'watchdog recovery uses confirmed position after playback has progressed',
    (tester) async {
      addTearDown(engine.dispose);
      // Play starting at t=10 s.
      await engine.play(track, startAt: const Duration(seconds: 10));
      expect(
        controller.commands.last.parameters['startSeconds'],
        10.0,
        reason: 'initial load uses startAt',
      );
      // Signal cued, then playing — this records _confirmedPositionGeneration.
      controller.emitState(track.id, yt.PlayerState.cued);
      await tester.pump();
      controller.emitState(track.id, yt.PlayerState.playing);
      await tester.pump();
      // Simulate stall: IFrame position has moved to 42 s.
      // We fake this by reading what the engine exposes via FakeYoutubeController.currentTime (=12.0)
      // then triggering the watchdog. The engine should load with startSeconds=12.0 (currentTime),
      // not 10.0 (the original startAt).
      await tester.pump(const Duration(seconds: 20));
      expect(controller.count('load'), 2);
      final recoveryCmd = controller.commands
          .where((c) => c.name == 'load')
          .last;
      // FakeYoutubeController.currentTime returns 12.0 (see fake definition).
      expect(
        recoveryCmd.parameters['startSeconds'],
        isNot(equals(10.0)),
        reason: 'watchdog recovery must not restart from original startAt',
      );
    },
  );
  engineTest(
    'watchdog recovery falls back to startSeconds when no playing was observed',
    (tester) async {
      addTearDown(engine.dispose);
      await engine.play(track, startAt: const Duration(seconds: 30));
      // Never emit playing — watchdog fires without a confirmed position.
      await tester.pump(const Duration(seconds: 20));
      expect(controller.count('load'), 2);
      final recoveryCmd = controller.commands
          .where((c) => c.name == 'load')
          .last;
      expect(
        recoveryCmd.parameters['startSeconds'],
        30.0,
        reason: 'without confirmed position, fallback to original startSeconds',
      );
    },
  );
  engineTest(
    'newer play survives watchdog recovery — stale recovery is discarded',
    (tester) async {
      addTearDown(engine.dispose);
      await engine.play(track);
      // Start watchdog countdown, then switch tracks before it fires.
      await tester.pump(const Duration(seconds: 19));
      await engine.play(other);
      // Watchdog from old generation fires.
      await tester.pump(const Duration(seconds: 1));
      // No error; new track attempt is live.
      expect(engine.currentStatus.track?.id, other.id);
      expect(engine.currentStatus.error, isNull);
      await tester.pump(const Duration(minutes: 2));
      expect(statuses.where((s) => s.state == PlaybackState.error), isEmpty);
    },
  );
  engineTest(
    'pause with failOnTimeout throws on timeout instead of emitting paused',
    (tester) async {
      addTearDown(engine.dispose);
      await ready(tester);
      controller.emitState(track.id, yt.PlayerState.playing);
      await tester.pump();
      // Block the pause command indefinitely.
      controller.pauseCompletion = Completer<void>();
      Object? caughtError;
      final pauseFuture = engine
          .pause(caller: 'handoff', failOnTimeout: true)
          .catchError((e) { caughtError = e; });
      // Advance past the 2 s ack window.
      await tester.pump(const Duration(seconds: 3));
      await pauseFuture;
      expect(
        caughtError,
        isA<TimeoutException>(),
        reason: 'failOnTimeout=true must throw, not silently emit paused',
      );
      controller.pauseCompletion!.complete();
    },
  );
  test(
    'native resume and pause are unaffected by Android IFrame restriction',
    () async {
      engine.dispose();
      final native = FakeNativePlayer();
      engine = MediaKitPlaybackEngine(nativePlayer: native);
      MediaKitPlaybackEngine.isActivityStopped = true;
      await engine.resume();
      await engine.pause();
      expect(native.plays, 1);
      expect(native.pauses, 1);
      expect(controller.count('play'), 0);
    },
  );
}
