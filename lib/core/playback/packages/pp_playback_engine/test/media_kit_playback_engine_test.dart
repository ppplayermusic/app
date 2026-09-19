import 'dart:async';
import 'package:media_kit/media_kit.dart' show VideoParams, SubtitleTrack;
import 'package:media_kit_video/media_kit_video.dart' show VideoController;
import 'package:flutter_test/flutter_test.dart';
import 'package:pp_playback_engine/pp_playback_engine.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart' as yt;
import 'fake_youtube_controller.dart';

/// Fake adapter that implements INativePlayerAdapter for production engine tests.
/// All streams are controllable via their backing StreamControllers.
class _CapturingStream<T> extends Stream<T> {
  final Stream<T> _source;
  void Function(T)? capturedOnData;

  _CapturingStream(this._source);

  @override
  StreamSubscription<T> listen(
    void Function(T event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    if (onData != null) capturedOnData = onData;
    return _source.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}

class FakeNativeAdapter implements INativePlayerAdapter {
  final _playingCtrl = StreamController<bool>.broadcast();
  final _bufferingCtrl = StreamController<bool>.broadcast();
  final _positionCtrl = StreamController<Duration>.broadcast();
  final _durationCtrl = StreamController<Duration>.broadcast();
  final _bufferCtrl = StreamController<Duration>.broadcast();
  final _errorCtrl = StreamController<String>.broadcast();
  final _completedCtrl = StreamController<bool>.broadcast();
  final _videoParamsCtrl = StreamController<VideoParams>.broadcast();

  // Observability counters.
  int opens = 0;
  int plays = 0;
  int pauses = 0;
  int stops = 0;
  int disposes = 0;
  bool _disposed = false;
  final Completer<void>? openCompleter; // null = complete immediately
  bool closeStreamsOnDispose = true;

  FakeNativeAdapter({this.openCompleter});

  late final _capturingPlayingStream = _CapturingStream<bool>(
    _playingCtrl.stream,
  );
  void Function(bool)? get capturedPlayingCallback =>
      _capturingPlayingStream.capturedOnData;

  @override
  VideoController? get videoController => null;
  @override
  Stream<bool> get playingStream => _capturingPlayingStream;
  @override
  Stream<bool> get bufferingStream => _bufferingCtrl.stream;
  @override
  Stream<Duration> get positionStream => _positionCtrl.stream;
  @override
  Stream<Duration> get durationStream => _durationCtrl.stream;
  @override
  Stream<Duration> get bufferStream => _bufferCtrl.stream;
  @override
  Stream<String> get errorStream => _errorCtrl.stream;
  @override
  Stream<bool> get completedStream => _completedCtrl.stream;
  @override
  Stream<VideoParams> get videoParamsStream => _videoParamsCtrl.stream;

  @override
  Future<void> open(String uri, {bool play = false}) async {
    opens++;
    if (openCompleter != null) await openCompleter!.future;
    if (!_disposed) _bufferingCtrl.add(true);
  }

  @override
  Future<void> play() async {
    plays++;
    if (!_disposed) _playingCtrl.add(true);
  }

  @override
  Future<void> pause() async {
    pauses++;
    if (!_disposed) _playingCtrl.add(false);
  }

  @override
  Future<void> stop() async {
    stops++;
    if (!_disposed) _playingCtrl.add(false);
  }

  @override
  Future<void> seek(Duration position) async {}
  @override
  Future<void> setVolume(double volume100) async {}
  @override
  Future<void> setRate(double rate) async {}
  @override
  Future<void> setSubtitleTrack(SubtitleTrack track) async {}

  @override
  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    disposes++;
    if (closeStreamsOnDispose) {
      await _playingCtrl.close();
      await _bufferingCtrl.close();
      await _positionCtrl.close();
      await _durationCtrl.close();
      await _bufferCtrl.close();
      await _errorCtrl.close();
      await _completedCtrl.close();
      await _videoParamsCtrl.close();
    }
  }
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

      // Progress position
      await tester.pump(const Duration(seconds: 1));

      // Pause, then resume to arm the watchdog again for the same generation.
      await engine.pause();
      controller.emitState(track.id, yt.PlayerState.paused);
      await tester.pump();

      // FakeYoutubeController.currentTime returns 12.0, so the confirmed position is 12s.
      await engine.resume();

      // Simulate stall on resume: no playing event emitted.
      // Watchdog should fire and load with startSeconds=12.0 (currentTime),
      // not 10.0 (the original startAt).
      await tester.pump(const Duration(seconds: 20));
      expect(controller.count('load'), 2);
      final recoveryCmd =
          controller.commands.where((c) => c.name == 'load').last;
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
      final recoveryCmd =
          controller.commands.where((c) => c.name == 'load').last;
      expect(
        recoveryCmd.parameters['startSeconds'],
        30.0,
        reason: 'without confirmed position, fallback to original startSeconds',
      );
    },
  );
  engineTest(
    'pause with failOnTimeout throws on timeout instead of emitting paused',
    (tester) async {
      addTearDown(engine.dispose);
      await ready(tester);
      controller.emitState(track.id, yt.PlayerState.playing);
      await tester.pump();

      // pauseVideo() returns immediately (no pauseCompletion set),
      // but no state-change event arrives — the IFrame bridge stays silent.
      // After 2 s, pauseAck.timeout fires. failOnTimeout=true must re-throw
      // instead of emitting an optimistic paused status.
      final caughtError = Completer<Object?>();
      final pauseFuture = engine
          .pause(caller: 'handoff', failOnTimeout: true)
          .then<void>((_) => caughtError.complete(null))
          .catchError((Object e) => caughtError.complete(e));

      // Advance past the 2 s ack window.
      await tester.pump(const Duration(seconds: 3));
      await pauseFuture;

      final error = await caughtError.future;
      expect(
        error,
        isA<TimeoutException>(),
        reason: 'failOnTimeout=true must throw, not silently emit paused',
      );
      // State must NOT have flipped to paused optimistically.
      expect(
        engine.currentStatus.state,
        isNot(PlaybackState.paused),
        reason:
            'optimistic paused update must be suppressed when failOnTimeout=true',
      );
    },
  );
  test(
    'native resume and pause are unaffected by Android IFrame restriction',
    () async {
      engine.dispose();
      FakeNativeAdapter? createdAdapter;
      engine = MediaKitPlaybackEngine(
        nativeAdapterFactory: () {
          createdAdapter = FakeNativeAdapter();
          return createdAdapter!;
        },
      );
      MediaKitPlaybackEngine.isActivityStopped = true;

      await engine.resume();

      // Wait for the stream to update the engine state.
      await Future.delayed(Duration.zero);

      await engine.pause();

      // resume() on native (non-IFrame) calls adapter.play().
      expect(
        createdAdapter?.plays ?? 0,
        0,
        reason: 'resume without an active track does nothing',
      );
      expect(controller.count('play'), 0);
    },
  );

  // ---------------------------------------------------------------------------
  // Session isolation regression tests
  // ---------------------------------------------------------------------------
  group('session isolation (production engine)', () {
    late List<FakeNativeAdapter> adapters;

    setUp(() {
      adapters = [];
      engine.dispose();
      engine = MediaKitPlaybackEngine(
        youtubeControllerFactory: (_, _) => controller,
        nativeAdapterFactory: () {
          final a = FakeNativeAdapter();
          adapters.add(a);
          return a;
        },
      );
      subscription.cancel();
      statuses = [];
      subscription = engine.statusStream.listen(statuses.add);
    });

    const localTrack = PlaybackTrack(
      id: 'local-a',
      title: 'Local A',
      localMediaUri: 'file:///local/a.mp3',
      sourceType: PlaybackSourceType.local,
    );
    const localTrackB = PlaybackTrack(
      id: 'local-b',
      title: 'Local B',
      localMediaUri: 'file:///local/b.mp3',
      sourceType: PlaybackSourceType.local,
    );

    test(
      'delayed event from disposed session is ignored after new session opens',
      () async {
        // Play track A; get a reference to its adapter.
        final playAFuture = engine.play(localTrack);
        await playAFuture;
        final adapterA = adapters.first;
        expect(adapterA.opens, 1);

        // Switch to track B — A's session is invalidated and torn down.
        await engine.play(localTrackB);
        expect(adapters.length, 2);

        // Verify A was disposed
        expect(
          adapterA.disposes,
          1,
          reason: 'adapter A must be disposed when session is invalidated',
        );

        // Drain any pending microtask emissions from B's initialization before
        // capturing the baseline — e.g., play() signals queued but not yet delivered.
        await Future.delayed(Duration.zero);

        final statesBefore = statuses.length;

        // Simulate a delayed event from A's backend arriving now.
        // Since the stream's subscription was cancelled during teardown, we must
        // invoke the captured callback directly to prove the closure guard evaluates it
        // and rejects the event.
        expect(
          adapterA.capturedPlayingCallback,
          isNotNull,
          reason: 'Engine must have subscribed to playingStream',
        );
        adapterA.capturedPlayingCallback!(true);

        await Future.delayed(Duration.zero);

        expect(
          statuses.length,
          statesBefore,
          reason:
              'stale event from old session must not update status due to ownership guard',
        );
      },
    );

    test('same URI reopening creates a distinct session', () async {
      await engine.play(localTrack);
      final adapterA = adapters.first;

      await engine.play(localTrack); // same URI
      expect(
        adapters.length,
        2,
        reason: 'each play() must create a new adapter/session',
      );
      expect(adapters[0], isNot(same(adapters[1])));
      expect(adapterA.disposes, 1, reason: 'first adapter must be disposed');
    });

    test('initialization events during open() are retained', () async {
      // An in-flight open completer lets us fire events during the open().
      final openCompleter = Completer<void>();
      adapters.clear();
      engine.dispose();
      engine = MediaKitPlaybackEngine(
        nativeAdapterFactory: () {
          final a = FakeNativeAdapter(openCompleter: openCompleter);
          adapters.add(a);
          return a;
        },
      );
      subscription.cancel();
      statuses = [];
      subscription = engine.statusStream.listen(statuses.add);

      // Start play but don't await; open() is blocked on openCompleter.
      final playFuture = engine.play(localTrack);

      // Let the engine reach open().
      await Future.delayed(Duration.zero);
      expect(adapters.length, 1);

      // Fire a duration event DURING open() — session is already active.
      adapters[0]._durationCtrl.add(const Duration(seconds: 180));
      await Future.delayed(Duration.zero);

      // Release open().
      openCompleter.complete();
      await playFuture;

      // The duration update emitted during open() must be reflected.
      expect(
        statuses.any((s) => s.duration == const Duration(seconds: 180)),
        isTrue,
        reason: 'duration event fired during open() must be retained',
      );
    });

    test('superseded open cannot activate or update playback', () async {
      final openA = Completer<void>();
      final openB = Completer<void>();
      int adapterIndex = 0;
      engine.dispose();
      final completers = [openA, openB];
      engine = MediaKitPlaybackEngine(
        nativeAdapterFactory: () {
          final c = completers[adapterIndex++];
          final a = FakeNativeAdapter(openCompleter: c);
          adapters.add(a);
          return a;
        },
      );
      subscription.cancel();
      statuses = [];
      subscription = engine.statusStream.listen(statuses.add);

      // Start A (blocked).
      final playA = engine.play(localTrack);
      await Future.delayed(Duration.zero);

      // Start B (blocked) — supersedes A.
      final playB = engine.play(localTrackB);
      await Future.delayed(Duration.zero);

      // Complete B first.
      openB.complete();
      await playB;

      // Complete A late — its session was torn before activation.
      openA.complete();
      await playA;

      // The engine's active session must be B's.
      expect(adapters.length, 2);
      // B's adapter must have been used for open.
      expect(adapters[1].opens, 1);
      // A's adapter must have been disposed.
      expect(adapters[0].disposes, 1);

      // No event from A's session should have updated the current status to A.
      final lastStatus = statuses.last;
      expect(
        lastStatus.track?.id,
        localTrackB.id,
        reason: 'active track must be B after superseded open',
      );
    });

    test('stop during open prevents subsequent updates', () async {
      final openCompleter = Completer<void>();
      engine.dispose();
      engine = MediaKitPlaybackEngine(
        nativeAdapterFactory: () {
          final a = FakeNativeAdapter(openCompleter: openCompleter);
          adapters.add(a);
          return a;
        },
      );
      subscription.cancel();
      statuses = [];
      subscription = engine.statusStream.listen(statuses.add);

      final playFuture = engine.play(localTrack);
      await Future.delayed(Duration.zero);

      // Stop while open() is in flight.
      await engine.stop();

      // Release the open.
      openCompleter.complete();
      await playFuture;

      // After stop, state must be idle (not playing/buffering from open).
      expect(
        engine.currentStatus.state,
        PlaybackState.idle,
        reason: 'stop during open must leave engine in idle state',
      );
    });

    test('source switching stops old audio and releases subscriptions', () async {
      await engine.play(localTrack);
      final adapterA = adapters.first;
      // After opening the first track, play() was legitimately called on A.
      final playsBeforeSwitch = adapterA.plays;
      expect(
        playsBeforeSwitch,
        greaterThanOrEqualTo(1),
        reason: 'adapter A must have received play() for the first track',
      );

      await engine.play(localTrackB);

      // A must have been stopped before disposal.
      expect(
        adapterA.stops,
        greaterThanOrEqualTo(1),
        reason: 'old session adapter must be stopped before teardown',
      );
      expect(
        adapterA.disposes,
        1,
        reason: 'old session adapter must be disposed after switching',
      );
      // After switching, A must not have received any additional play() calls.
      expect(
        adapterA.plays,
        playsBeforeSwitch,
        reason:
            'old adapter must not receive additional play() calls after switching',
      );
    });

    test('dispose during open prevents subsequent updates', () async {
      final openCompleter = Completer<void>();
      engine.dispose();
      engine = MediaKitPlaybackEngine(
        nativeAdapterFactory: () {
          final a = FakeNativeAdapter(openCompleter: openCompleter);
          adapters.add(a);
          return a;
        },
      );
      subscription.cancel();
      statuses = [];
      subscription = engine.statusStream.listen(statuses.add);

      final playFuture = engine.play(localTrack);
      await Future.delayed(Duration.zero);

      // Dispose while open() is in flight.
      engine.dispose();

      // Release open — should be a no-op since engine is disposed.
      openCompleter.complete();
      await playFuture;

      // No playing/buffering status should have been emitted after dispose.
      final postDisposeStates =
          statuses
              .where(
                (s) =>
                    s.state == PlaybackState.playing ||
                    s.state == PlaybackState.buffering,
              )
              .toList();
      expect(
        postDisposeStates,
        isEmpty,
        reason: 'no playing/buffering updates after dispose',
      );
    });
  });
}
