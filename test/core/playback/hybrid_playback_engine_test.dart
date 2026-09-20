import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:pp_playback_engine/pp_playback_engine.dart';
import 'package:ppplayer/core/playback/hybrid_playback_engine.dart';
import 'package:ppplayer/core/playback/pip_handler.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

// ---------------------------------------------------------------------------
// Controllable fake engine — lets tests pause/resume play/pause at will.
// ---------------------------------------------------------------------------
class FakeEngine implements PlaybackController {
  @override
  bool get supportsSpeed => true;
  @override
  bool get supportsVideoFitMode => false;

  final String name;
  FakeEngine(this.name);

  final _statusCtrl = StreamController<PlaybackStatus>.broadcast();
  final _eventCtrl = StreamController<PlaybackEvent>.broadcast();
  PlaybackStatus _status = const PlaybackStatus();
  bool isDisposed = false;

  // Per-call completers — set before triggering the action to block it.
  Completer<void>? prepareCompleter;
  Completer<void>? playCompleter;
  Completer<void>? pauseCompleter;

  // Counters for assertion
  int playCalls = 0;
  int pauseCallsFromHandoff = 0;
  int resumeCalls = 0;
  final List<String> callLog = [];

  @override
  Stream<PlaybackStatus> get statusStream => _statusCtrl.stream;
  @override
  Stream<PlaybackEvent> get eventStream => _eventCtrl.stream;
  @override
  PlaybackStatus get currentStatus => _status;

  void emit(PlaybackStatus s) {
    _status = s;
    _statusCtrl.add(s);
  }

  void emitEvent(PlaybackEvent e) => _eventCtrl.add(e);

  @override
  Future<void> prepare(PlaybackTrack track, {Duration? position}) async {
    callLog.add('prepare(${track.id})');
    emit(_status.copyWith(state: PlaybackState.preparing));
    if (prepareCompleter != null) await prepareCompleter!.future;
    emit(_status.copyWith(state: PlaybackState.paused));
  }

  @override
  Future<void> play(
    PlaybackTrack track, {
    Duration startAt = Duration.zero,
  }) async {
    playCalls++;
    callLog.add('play(${track.id})');
    emit(_status.copyWith(state: PlaybackState.buffering));
    if (playCompleter != null) await playCompleter!.future;
    emit(_status.copyWith(state: PlaybackState.playing));
  }

  @override
  Future<void> pause({
    String caller = 'user',
    bool failOnTimeout = false,
  }) async {
    callLog.add('pause(caller: $caller)');
    if (caller == 'handoff') pauseCallsFromHandoff++;
    if (pauseCompleter != null) await pauseCompleter!.future;
    emit(_status.copyWith(state: PlaybackState.paused));
  }

  @override
  Future<void> resume() async {
    resumeCalls++;
    callLog.add('resume()');
    emit(_status.copyWith(state: PlaybackState.playing));
  }

  @override
  Future<void> stop() async {
    callLog.add('stop()');
    emit(_status.copyWith(state: PlaybackState.idle, track: null));
  }

  @override
  Future<void> seekTo(Duration position) async {
    callLog.add('seekTo(${position.inMilliseconds})');
    emit(_status.copyWith(position: position));
  }

  @override
  Future<void> setVolume(double volume) async =>
      callLog.add('setVolume($volume)');
  @override
  Future<void> setSpeed(double speed) async => callLog.add('setSpeed($speed)');

  @override
  Future<void> dispose() async {
    isDisposed = true;
    _statusCtrl.close();
    _eventCtrl.close();
  }

  @override
  dynamic get renderer => null;
  @override
  YoutubePlayerController? get youtubeController => null;
  @override
  Future<void> setSubtitleTrack(String? uri) async {}

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
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------
const _track = PlaybackTrack(id: 'vid1', title: 'Test', artist: 'Test');
const _track2 = PlaybackTrack(id: 'vid2', title: 'Test2', artist: 'Test');

Future<void> pump([int ms = 50]) => Future.delayed(Duration(milliseconds: ms));

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late HybridPlaybackEngine engine;
  late FakeEngine fg;
  late FakeEngine bg;

  setUp(() {
    PipHandler.resetForTest();
    fg = FakeEngine('fg');
    bg = FakeEngine('bg');
    engine = HybridPlaybackEngine(foregroundEngine: fg, backgroundEngine: bg);
  });

  tearDown(() {
    engine.dispose();
    PipHandler.resetForTest();
  });

  // =========================================================================
  // Test 1 — PiP active THEN activityStopped: foreground stays owner
  // =========================================================================
  test(
    '1. PiP active → activityStopped: foreground remains owner, background never starts',
    () async {
      await engine.play(_track);

      // PiP enters first (normal ordering)
      PipHandler.simulatePipRequestPending();
      PipHandler.simulatePipModeChanged(true);
      PipHandler.simulateActivityStopped();

      await pump();

      expect(
        engine.owner,
        EngineOwner.foreground,
        reason: 'While in PiP, foreground must remain owner',
      );
      expect(
        bg.playCalls,
        0,
        reason: 'Background engine must never start when PiP is active',
      );
      expect(
        bg.pauseCallsFromHandoff,
        0,
        reason: 'Handoff pause must not be sent to background during PiP',
      );
    },
  );

  // =========================================================================
  // Test 2 — Race: activityStopped BEFORE onPipModeChanged(true)
  //          Background must NEVER start; final owner must be foreground.
  // =========================================================================
  test(
    '2. Race: activityStopped → PiP confirmed: background never starts, owner=foreground',
    () async {
      await engine.play(_track);

      // Set isEnteringPip BEFORE requesting PiP (as the real flow does)
      PipHandler.simulatePipRequestPending();

      // Race: activity stops first, PiP confirmation arrives later
      PipHandler.simulateActivityStopped();

      // Give any async work a chance to run
      await pump();

      // PiP confirmation arrives
      PipHandler.simulatePipModeChanged(true);

      await pump();

      // The core assertion: background was NEVER started
      expect(
        bg.playCalls,
        0,
        reason: 'isEnteringPip flag must prevent any background play call',
      );
      expect(
        bg.pauseCallsFromHandoff,
        0,
        reason: 'No handoff pause should be sent to the foreground engine',
      );
      expect(
        fg.pauseCallsFromHandoff,
        0,
        reason:
            'Foreground must not be paused for a handoff that never happens',
      );
      expect(
        engine.owner,
        EngineOwner.foreground,
        reason: 'Final owner must be foreground',
      );
    },
  );

  // =========================================================================
  // Test 3 — PiP dismissed while Activity still stopped → background becomes owner
  // =========================================================================
  test(
    '3. PiP closes while activity stopped → background becomes owner',
    () async {
      await engine.play(_track);

      // Enter PiP normally
      PipHandler.simulatePipRequestPending();
      PipHandler.simulatePipModeChanged(true);
      PipHandler.simulateActivityStopped();
      await pump();

      expect(engine.owner, EngineOwner.foreground);

      // User swipes PiP away — PiP exits while activity is NOT restarted
      PipHandler.simulatePipModeChanged(false);
      await pump();

      expect(
        engine.owner,
        EngineOwner.background,
        reason:
            'After PiP is dismissed and activity is still stopped, '
            'background must take over',
      );
      expect(
        fg.currentStatus.state,
        isNot(PlaybackState.playing),
        reason: 'Foreground must not be playing after background takes over',
      );
    },
  );

  // =========================================================================
  // Test 4 — PiP dismissed because user expanded it back → foreground stays
  // =========================================================================
  test(
    '4. PiP expanded back to fullscreen → foreground remains owner',
    () async {
      await engine.play(_track);

      PipHandler.simulatePipRequestPending();
      PipHandler.simulatePipModeChanged(true);
      PipHandler.simulateActivityStopped();
      await pump();

      // User taps PiP to expand back to fullscreen: activity is restarted BEFORE
      // pipModeChanged(false) fires.
      PipHandler.simulateActivityStarted();
      PipHandler.simulatePipModeChanged(false);
      await pump();

      expect(
        engine.owner,
        EngineOwner.foreground,
        reason: 'Expanding PiP to fullscreen must keep foreground owner',
      );
      expect(
        bg.playCalls,
        0,
        reason:
            'Background must never start when returning from PiP to fullscreen',
      );
    },
  );

  // =========================================================================
  // Test 5 — Home pressed with PiP disabled → normal background handoff
  // =========================================================================
  test(
    '5. Home with PiP disabled → background handoff occurs normally',
    () async {
      await engine.play(_track);

      // PiP is NOT entering (isEnteringPip stays false, isInPipMode stays false)
      PipHandler.simulateActivityStopped();
      await pump();

      expect(
        engine.owner,
        EngineOwner.background,
        reason: 'Without PiP, backgrounding must hand off to background engine',
      );
      expect(bg.playCalls, 1);
      expect(fg.currentStatus.state, isNot(PlaybackState.playing));
    },
  );

  // =========================================================================
  // Test 6 — Rapid: PiP enter → exit → re-enter; latest transition wins.
  //           Uses controllable Completers so handoffs can be interleaved.
  // =========================================================================
  test(
    '6. Rapid PiP enter/exit/re-enter: latest transition wins (generation guard)',
    () async {
      await engine.play(_track);

      // First PiP entry
      PipHandler.simulatePipRequestPending();
      PipHandler.simulatePipModeChanged(true);
      PipHandler.simulateActivityStopped();
      await pump();
      expect(engine.owner, EngineOwner.foreground);

      // PiP exits while stopped → background handoff A starts, but is slow
      bg.playCompleter = Completer();
      PipHandler.simulatePipModeChanged(false);
      await pump(10); // A is in flight

      // Re-enter PiP before A completes
      PipHandler.simulatePipRequestPending();
      PipHandler.simulatePipModeChanged(true);
      await pump(10);

      // Complete the stale handoff A
      bg.playCompleter!.complete();
      bg.playCompleter = null;
      await pump();

      // Re-entry PiP is the latest state; foreground must win
      expect(
        engine.owner,
        EngineOwner.foreground,
        reason:
            'Generation guard must prevent stale handoff A from overwriting the re-enter',
      );
    },
  );

  // =========================================================================
  // Test 7 — PiP active → next track / pause / resume → no duplicate audio
  // =========================================================================
  test(
    '7. PiP active: track change, pause, resume do not cause owner divergence',
    () async {
      await engine.play(_track);

      PipHandler.simulatePipRequestPending();
      PipHandler.simulatePipModeChanged(true);
      PipHandler.simulateActivityStopped();
      await pump();

      expect(engine.owner, EngineOwner.foreground);

      // Play next track while in PiP
      await engine.play(_track2);
      await pump();

      expect(
        engine.owner,
        EngineOwner.foreground,
        reason: 'Changing track during PiP must not switch owner to background',
      );
      expect(bg.playCalls, 0, reason: 'Background must not play while in PiP');

      // Pause then resume in PiP
      await engine.pause();
      await pump();
      expect(engine.currentStatus.state, PlaybackState.paused);
      expect(bg.playCalls, 0);

      await engine.resume();
      await pump();
      expect(engine.currentStatus.state, PlaybackState.playing);
      expect(
        bg.playCalls,
        0,
        reason:
            'Resume in PiP must use foreground engine, not trigger background',
      );
    },
  );

  // =========================================================================
  // Test 8 — PiP requested → activityStopped → PiP entry FAILS
  //          Background must eventually become owner
  // =========================================================================
  test(
    '8. PiP requested → activityStopped → PiP entry fails → background becomes owner',
    () async {
      await engine.play(_track);

      // Set entering flag; activity stops while PiP is being set up
      PipHandler.simulatePipRequestPending();
      PipHandler.simulateActivityStopped();
      await pump();

      // PiP entry failed — Android returned false / threw
      PipHandler.simulatePipEntryFailed();
      await pump();

      expect(
        engine.owner,
        EngineOwner.background,
        reason:
            'After PiP entry fails with activity already stopped, '
            'background must take over',
      );
      expect(bg.playCalls, 1);
    },
  );

  // =========================================================================
  // Legacy tests (preserved, adapted for FakeEngine field names)
  // =========================================================================
  test(
    'Rapid minimize/reopen takes latest transition (generation guard)',
    () async {
      await engine.play(_track);

      bg.playCompleter = Completer();
      PipHandler.simulateActivityStopped();

      // Reopen before background handoff finishes
      PipHandler.simulateActivityStarted();

      bg.playCompleter!.complete();
      bg.playCompleter = null;
      await pump();

      // Background handoff is stale; foreground should be playing
      expect(fg.currentStatus.state, PlaybackState.playing);
    },
  );

  test('Track changes during handoff: new track wins on background', () async {
    await engine.play(_track);

    bg.playCompleter = Completer();
    PipHandler.simulateActivityStopped();

    await pump(10);
    // DO NOT await this, as bg.playCompleter is active and it will deadlock!
    engine.play(_track2);

    bg.playCompleter!.complete();
    bg.playCompleter = null;
    await pump();

    // New track must be what background has been asked to play
    expect(bg.callLog, contains('play(${_track2.id})'));
  });

  test('Source pause confirmed before destination starts', () async {
    await engine.play(_track);

    fg.pauseCompleter = Completer();
    PipHandler.simulateActivityStopped();
    await pump(20);

    // Background play must NOT have been called yet
    expect(
      bg.callLog.any((c) => c.startsWith('play')),
      isFalse,
      reason: 'Destination must not start until source pause is confirmed',
    );

    fg.pauseCompleter!.complete();
    fg.pauseCompleter = null;
    await pump();

    expect(bg.callLog, contains('play(${_track.id})'));
  });

  test('Containment: inactive engine emitting playing gets paused', () async {
    await engine.play(_track);

    PipHandler.simulateActivityStopped();
    await pump();

    // Foreground is now inactive. If it spontaneously emits playing, it must
    // be paused by the containment guard.
    fg.emit(const PlaybackStatus(state: PlaybackState.playing));
    await pump();

    expect(fg.callLog.last, 'pause(caller: containment)');
  });

  test('Track ended event deduplicated across source and destination', () async {
    await engine.play(_track);

    bg.playCompleter = Completer();
    PipHandler.simulateActivityStopped();

    int endedCount = 0;
    engine.eventStream.listen((e) {
      if (e.type == PlaybackEventType.trackEnded) endedCount++;
    });

    // Both engines fire trackEnded
    fg.emitEvent(
      const PlaybackEvent(type: PlaybackEventType.trackEnded, track: _track),
    );
    bg.emitEvent(
      const PlaybackEvent(type: PlaybackEventType.trackEnded, track: _track),
    );

    bg.playCompleter!.complete();
    bg.playCompleter = null;
    await pump();

    expect(
      endedCount,
      1,
      reason:
          'Track ended must be emitted exactly once regardless of which engine fires it',
    );
  });

  // ---------------------------------------------------------------------------
  // State model invariant:
  //   Full-screen/visible → foreground
  //   PiP pending         → foreground
  //   PiP active          → foreground
  //   Hidden, no PiP      → background
  // ---------------------------------------------------------------------------

  test(
    'PiP request pending → activity restarts before confirmation → '
    'pending clears, owner stays foreground, late PiP callback is a no-op',
    () async {
      await engine.play(_track);
      expect(engine.owner, EngineOwner.foreground);

      // Simulate the race: PiP was requested (pending=true) but before Android
      // responds, the user immediately returns to the app (activityStarted).
      PipHandler.simulatePipRequestPending();
      expect(PipHandler.isPipRequestPending, isTrue);

      // Activity starts again — the user brought the app back to foreground
      // before Android confirmed PiP entry.
      PipHandler.simulateActivityStarted();
      await pump();

      // Owner must still be foreground. No background handoff should occur.
      expect(
        engine.owner,
        EngineOwner.foreground,
        reason:
            'Returning to foreground before PiP confirmation must not hand off',
      );
      expect(
        bg.playCalls,
        0,
        reason: 'Background engine must not have been asked to play',
      );

      // Now simulate a *late* onPipModeChanged(true) arriving after the user
      // is already back in the foreground. This clears the pending flag.
      // The engine's safety-net should keep owner on foreground; it must NOT
      // initiate any background handoff.
      PipHandler.simulatePipModeChanged(true);
      await pump();

      expect(
        engine.owner,
        EngineOwner.foreground,
        reason:
            'Late PiP confirmation after activity-started must not change owner',
      );
      expect(
        bg.playCalls,
        0,
        reason: 'Background engine must still not have been asked to play',
      );

      // Finally, PiP mode ends (the stale PiP window clears). Since the
      // activity is running (not stopped), no background handoff should follow.
      PipHandler.simulatePipModeChanged(false);
      await pump();

      expect(
        engine.owner,
        EngineOwner.foreground,
        reason:
            'PiP exit while activity is running must leave owner on foreground',
      );
      expect(bg.playCalls, 0);
    },
  );

  // ---------------------------------------------------------------------------
  // Watchdog bounded-lifetime tests
  //
  // These tests verify the invariant:
  //   _pipRequestPending must ALWAYS have a bounded lifetime.
  //
  // A Future.timeout() on invokeMethod cannot guarantee this — the future
  // completes as soon as the method returns (true or false). If enterPip()
  // returns true but Android never delivers onPipModeChanged, the flag would
  // remain set forever without an independent Timer watchdog.
  // ---------------------------------------------------------------------------

  test('15. enterPip returns true, PiP callback never arrives '
      '→ watchdog clears isPipRequestPending '
      '→ stopped activity can hand off to background', () async {
    await engine.play(_track);
    expect(engine.owner, EngineOwner.foreground);

    // Arm the pending guard as enterPip() would — simulates the case where
    // the method call returned true but onPipModeChanged never arrives.
    PipHandler.simulatePipRequestPending();
    expect(PipHandler.isPipRequestPending, isTrue);

    // Activity is stopped (e.g. user pressed Home) while pending.
    // The deferred guard must hold it back.
    PipHandler.simulateActivityStopped();
    await pump();
    expect(
      engine.owner,
      EngineOwner.foreground,
      reason: 'Pending guard must defer the background handoff',
    );

    // Watchdog fires — onPipModeChanged never arrived.
    // This should clear the pending flag and notify entry-failed, which
    // then triggers the deferred background handoff.
    PipHandler.simulateWatchdogExpiry();
    await pump();

    expect(
      PipHandler.isPipRequestPending,
      isFalse,
      reason: 'Watchdog must clear isPipRequestPending',
    );
    expect(
      engine.owner,
      EngineOwner.background,
      reason: 'Background handoff must proceed once pending is cleared',
    );
  });

  test('16. Watchdog expires, then late onPipModeChanged(true) arrives '
      '→ PiP state becomes authoritative '
      '→ safety-net restores foreground ownership', () async {
    await engine.play(_track);
    expect(engine.owner, EngineOwner.foreground);

    // Simulate: enterPip() returned true, activity stopped, watchdog expired.
    PipHandler.simulatePipRequestPending();
    PipHandler.simulateActivityStopped();
    await pump();
    // Watchdog fires — treating this as a failed entry and handing off.
    PipHandler.simulateWatchdogExpiry();
    await pump();

    // At this point the background handoff has completed.
    expect(engine.owner, EngineOwner.background);
    expect(PipHandler.isPipRequestPending, isFalse);

    // Now Android belatedly confirms PiP entry. The Activity IS actually in
    // PiP. The engine's safety-net (onPipModeChanged handler) must detect
    // that owner is not foreground and recover.
    PipHandler.simulatePipModeChanged(true);
    await pump();

    expect(
      engine.owner,
      EngineOwner.foreground,
      reason:
          'Late genuine PiP confirmation must restore foreground ownership '
          '(PiP active → foreground engine is a hard invariant)',
    );

    // When PiP subsequently ends with activity still stopped (user dismisses
    // PiP window), a background handoff should then follow normally.
    PipHandler.simulatePipModeChanged(false);
    await pump();

    expect(
      engine.owner,
      EngineOwner.background,
      reason: 'PiP dismissed while activity stopped → background engine',
    );

    // OPERATIONAL NOTE: If a real device takes close to 3 seconds to deliver
    // onPipModeChanged (e.g. under heavy load or on older hardware), the
    // watchdog may expire and temporarily hand off to background before the
    // safety-net restores foreground ownership. This test confirms the
    // recovery is correct. If that transient blip is observed on device,
    // increase the watchdog duration in PipHandler.enterPip() — do NOT
    // change the state model or remove the safety-net.
  });

  test('17. setSpeed propagates to both underlying engines', () async {
    await engine.setSpeed(1.5);
    expect(fg.callLog, contains('setSpeed(1.5)'));
    expect(bg.callLog, contains('setSpeed(1.5)'));
  });
}
