import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:pp_playback_engine/pp_playback_engine.dart';

class PipHandler {
  static const _channel = MethodChannel('com.ppplayer.app/pip');

  // --- State ---
  static bool _isInPipMode = false;
  static bool _isActivityStopped = false;

  // Set to true immediately before the native PiP request is issued and
  // cleared as soon as Android confirms either outcome (entered or rejected).
  // This is a narrow, short-lived guard for the ordering race:
  //
  //   onActivityStopped      ← arrives BEFORE onPipModeChanged(true)
  //   onPipModeChanged(true) ← arrives AFTER onActivityStopped
  //
  // It intentionally differs from a long-lived "isEnteringPip" concept: it is
  // cleared by the first Android lifecycle event that resolves the request, so
  // it cannot persist across an unrelated screen-lock.
  static bool _pipRequestPending = false;

  // Independent watchdog timer that guarantees _pipRequestPending has a bounded
  // lifetime even when enterPip() returns true immediately but Android never
  // delivers onPictureInPictureModeChanged. A Future.timeout() on invokeMethod
  // cannot cover this case — the future completes as soon as the method
  // returns, and the watchdog must keep running independently afterward.
  static Timer? _pipRequestWatchdog;

  static bool get isActivityStopped => _isActivityStopped;
  static bool get isInPipMode => _isInPipMode;
  static bool get isPipRequestPending => _pipRequestPending;

  // --- Listener lists ---
  static final List<void Function(bool)> _pipModeListeners = [];
  static final List<void Function()> _activityStoppedListeners = [];
  static final List<void Function()> _activityStartedListeners = [];
  static final List<void Function()> _pipEntryFailedListeners = [];
  static final List<void Function()> _pipEntryRequestedListeners = [];

  static void addPipModeListener(void Function(bool) listener) =>
      _pipModeListeners.add(listener);
  static void removePipModeListener(void Function(bool) listener) =>
      _pipModeListeners.remove(listener);

  static void addActivityStoppedListener(void Function() listener) =>
      _activityStoppedListeners.add(listener);
  static void removeActivityStoppedListener(void Function() listener) =>
      _activityStoppedListeners.remove(listener);

  static void addActivityStartedListener(void Function() listener) =>
      _activityStartedListeners.add(listener);
  static void removeActivityStartedListener(void Function() listener) =>
      _activityStartedListeners.remove(listener);

  static void addPipEntryFailedListener(void Function() listener) =>
      _pipEntryFailedListeners.add(listener);
  static void removePipEntryFailedListener(void Function() listener) =>
      _pipEntryFailedListeners.remove(listener);

  static void addPipEntryRequestedListener(void Function() listener) =>
      _pipEntryRequestedListeners.add(listener);
  static void removePipEntryRequestedListener(void Function() listener) =>
      _pipEntryRequestedListeners.remove(listener);

  // ---------------------------------------------------------------------------
  // init — wires up the method-channel handler from the native side.
  // ---------------------------------------------------------------------------
  static void init() {
    if (!kIsWeb && Platform.isAndroid) {
      _channel.setMethodCallHandler((call) async {
        final time = DateTime.now().toIso8601String().substring(11, 23);
        if (call.method == 'onPipModeChanged') {
          final inPip = call.arguments as bool;
          final oldMode = _isInPipMode;
          final hadPending = _pipRequestPending;

          // onPipModeChanged is the authoritative confirmation from Android.
          // It clears both the flag and the watchdog timer regardless of
          // whether PiP was confirmed or rejected.
          _resolvePipRequest();
          _isInPipMode = inPip;

          debugPrint(
            '$time [PipDebug][HANDLER] event=onPipModeChanged '
            'old=$oldMode new=$inPip hadPending=$hadPending '
            'activityStopped=$_isActivityStopped',
          );
          for (final l in _pipModeListeners) {
            l(inPip);
          }
        } else if (call.method == 'onPipEntryRequested') {
          // Native side (onUserLeaveHint) notified us that PiP is about to be
          // entered by Android. Arm the pending guard and watchdog NOW — before
          // onActivityStopped arrives — so the handoff engine defers correctly.
          // This covers both Android 12+ auto-enter and Android 8-11 manual entry.
          if (!_pipRequestPending) {
            _pipRequestPending = true;
            _pipRequestWatchdog?.cancel();
            _pipRequestWatchdog = Timer(const Duration(seconds: 3), () {
              if (!_pipRequestPending) return;
              final t = DateTime.now().toIso8601String().substring(11, 23);
              debugPrint(
                '$t [PipDebug][HANDLER] event=pipEntryRequested_watchdog_timeout '
                'activityStopped=$_isActivityStopped',
              );
              _resolvePipRequest();
              notifyPipEntryFailed();
            });
            debugPrint(
              '$time [PipDebug][HANDLER] event=onPipEntryRequested '
              'pendingArmed=true activityStopped=$_isActivityStopped',
            );
            for (final l in _pipEntryRequestedListeners) {
              l();
            }
          }
        } else if (call.method == 'onActivityStopped') {
          final oldState = _isActivityStopped;
          _isActivityStopped = true;
          MediaKitPlaybackEngine.isActivityStopped = true;
          debugPrint(
            '$time [PipDebug][HANDLER] event=onActivityStopped '
            'old=$oldState new=$_isActivityStopped '
            'inPip=$_isInPipMode pipRequestPending=$_pipRequestPending',
          );
          for (final l in _activityStoppedListeners) {
            l();
          }
        } else if (call.method == 'onActivityStarted') {
          final oldState = _isActivityStopped;
          _isActivityStopped = false;
          MediaKitPlaybackEngine.isActivityStopped = false;
          debugPrint(
            '$time [PipDebug][HANDLER] event=onActivityStarted '
            'old=$oldState new=$_isActivityStopped '
            'inPip=$_isInPipMode pipRequestPending=$_pipRequestPending',
          );
          for (final l in _activityStartedListeners) {
            l();
          }
        } else if (call.method == 'onPipEntryFailed') {
          notifyPipEntryFailed();
        }
      });
    }
  }

  // ---------------------------------------------------------------------------
  // setPipEnabled — Android 12+ auto-enter param; Android 8-11 manual entry.
  // ---------------------------------------------------------------------------
  static Future<void> setPipEnabled(
    bool enabled, {
    double aspectRatio = 16 / 9,
  }) async {
    if (!kIsWeb && Platform.isAndroid) {
      try {
        await _channel.invokeMethod('setPipEnabled', {
          'enabled': enabled,
          'aspectRatio': aspectRatio,
        });
      } catch (e) {
        debugPrint('PipHandler: Failed to set PIP enabled: $e');
      }
    }
  }

  // ---------------------------------------------------------------------------
  // enterPip — explicit manual entry from Flutter.
  //
  // Sets _pipRequestPending BEFORE the native call so that if onActivityStopped
  // arrives in the window between the call and onPipModeChanged(true), the
  // handoff engine sees the pending flag and defers correctly.
  //
  // A separate watchdog Timer runs after the method call returns to guarantee
  // _pipRequestPending is always cleared, even if enterPip() returns true
  // immediately but Android never delivers onPictureInPictureModeChanged.
  // A Future.timeout() on invokeMethod cannot cover this case because the
  // future completes as soon as the method returns — the watchdog is the only
  // mechanism that can bound the flag's lifetime in that scenario.
  //
  // Guaranteed clear paths for _pipRequestPending:
  //   1. Android confirms entry    → onPipModeChanged handler → _resolvePipRequest()
  //   2. Android rejects (false)   → enterPip() call-site     → _resolvePipRequest()
  //   3. Platform exception        → catch block              → _resolvePipRequest()
  //   4. Callback never delivered  → watchdog Timer fires     → _resolvePipRequest()
  // ---------------------------------------------------------------------------
  static Future<bool> enterPip({double aspectRatio = 16 / 9}) async {
    if (kIsWeb || !Platform.isAndroid) return false;

    _pipRequestPending = true;

    // Cancel any stale watchdog from a previous call before arming a new one.
    _pipRequestWatchdog?.cancel();
    _pipRequestWatchdog = Timer(const Duration(seconds: 3), () {
      if (!_pipRequestPending) return; // already resolved
      final t = DateTime.now().toIso8601String().substring(11, 23);
      debugPrint(
        '$t [PipDebug][HANDLER] event=enterPip_watchdog_timeout '
        'activityStopped=$_isActivityStopped',
      );
      _resolvePipRequest();
      // Treat a watchdog expiry as an entry failure so the engine can flush
      // any deferred background handoff if the activity is already stopped.
      notifyPipEntryFailed();
    });

    final time = DateTime.now().toIso8601String().substring(11, 23);
    debugPrint(
      '$time [PipDebug][HANDLER] event=enterPip_requested '
      'inPip=$_isInPipMode activityStopped=$_isActivityStopped',
    );
    for (final l in _pipEntryRequestedListeners) {
      l();
    }

    try {
      final entered =
          await _channel.invokeMethod<bool>('enterPip', {
            'aspectRatio': aspectRatio,
          }) ??
          false;
      if (!entered) {
        // Android rejected the request synchronously; the onPipModeChanged
        // callback will NOT arrive, so we must clear here.
        _resolvePipRequest();
        if (_isActivityStopped) {
          notifyPipEntryFailed();
        }
      }
      // If entered == true, _pipRequestPending is cleared by either
      // onPipModeChanged (normal path) or the watchdog (fallback path).
      return entered;
    } catch (e) {
      _resolvePipRequest();
      debugPrint('PipHandler: enterPip failed: $e');
      if (_isActivityStopped) {
        notifyPipEntryFailed();
      }
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // _resolvePipRequest — single point that clears both the flag and the
  // watchdog timer. All resolution paths (success, rejection, exception,
  // watchdog expiry) funnel through here so there is no way to forget one.
  // ---------------------------------------------------------------------------
  static void _resolvePipRequest() {
    _pipRequestPending = false;
    _pipRequestWatchdog?.cancel();
    _pipRequestWatchdog = null;
  }

  // ---------------------------------------------------------------------------
  // notifyPipEntryFailed — called when Android did NOT enter PiP (e.g. the
  // device doesn't support it, or the call returned false). Clears
  // _pipRequestPending so deferred handoffs are not stuck.
  // ---------------------------------------------------------------------------
  static void notifyPipEntryFailed() {
    _resolvePipRequest();
    final time = DateTime.now().toIso8601String().substring(11, 23);
    debugPrint(
      '$time [PipDebug][HANDLER] event=notifyPipEntryFailed '
      'activityStopped=$_isActivityStopped',
    );
    for (final l in _pipEntryFailedListeners) {
      l();
    }
  }

  // ---------------------------------------------------------------------------
  // Test-only simulation helpers
  // ---------------------------------------------------------------------------
  @visibleForTesting
  static void simulateActivityStopped() {
    _isActivityStopped = true;
    for (final l in _activityStoppedListeners) {
      l();
    }
  }

  @visibleForTesting
  static void simulateActivityStarted() {
    _isActivityStopped = false;
    for (final l in _activityStartedListeners) {
      l();
    }
  }

  @visibleForTesting
  static void simulatePipModeChanged(bool inPip) {
    _resolvePipRequest();
    _isInPipMode = inPip;
    for (final l in _pipModeListeners) {
      l(inPip);
    }
  }

  @visibleForTesting
  static void simulatePipEntryRequested() {
    if (_pipRequestPending) return;
    _pipRequestPending = true;
  }

  @visibleForTesting
  static void simulatePipRequestPending() {
    _pipRequestPending = true;
  }

  @visibleForTesting
  static void simulatePipEntryFailed() {
    notifyPipEntryFailed();
  }

  /// Fires the watchdog immediately — for testing watchdog expiry without
  /// waiting 3 real seconds.
  @visibleForTesting
  static void simulateWatchdogExpiry() {
    _pipRequestWatchdog?.cancel();
    _pipRequestWatchdog = null;
    if (!_pipRequestPending) return;
    final t = DateTime.now().toIso8601String().substring(11, 23);
    debugPrint(
      '$t [PipDebug][HANDLER] event=enterPip_watchdog_timeout '
      'activityStopped=$_isActivityStopped',
    );
    _resolvePipRequest();
    notifyPipEntryFailed();
  }

  /// Resets all static state — call in test tearDown to prevent cross-test pollution.
  @visibleForTesting
  static void resetForTest() {
    _isInPipMode = false;
    _isActivityStopped = false;
    _resolvePipRequest(); // cancels watchdog and clears flag
    _pipModeListeners.clear();
    _activityStoppedListeners.clear();
    _activityStartedListeners.clear();
    _pipEntryFailedListeners.clear();
  }
}
