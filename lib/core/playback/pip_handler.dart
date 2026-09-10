import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:pp_playback_engine/pp_playback_engine.dart';

class PipHandler {
  static const _channel = MethodChannel('com.ppplayer.app/pip');
  static bool _isInPipMode = false;
  static bool _isActivityStopped = false;
  static bool get isActivityStopped => _isActivityStopped;
  static bool get isInPipMode => _isInPipMode;
  
  static final List<void Function(bool)> _pipModeListeners = [];
  static final List<void Function()> _activityStoppedListeners = [];
  static final List<void Function()> _activityStartedListeners = [];

  static void addPipModeListener(void Function(bool) listener) => _pipModeListeners.add(listener);
  static void removePipModeListener(void Function(bool) listener) => _pipModeListeners.remove(listener);

  static void addActivityStoppedListener(void Function() listener) => _activityStoppedListeners.add(listener);
  static void removeActivityStoppedListener(void Function() listener) => _activityStoppedListeners.remove(listener);

  static void addActivityStartedListener(void Function() listener) => _activityStartedListeners.add(listener);
  static void removeActivityStartedListener(void Function() listener) => _activityStartedListeners.remove(listener);

  static void init() {
    if (!kIsWeb && Platform.isAndroid) {
      _channel.setMethodCallHandler((call) async {
        final ts = DateTime.now().toIso8601String();
        if (call.method == 'onPipModeChanged') {
          _isInPipMode = call.arguments as bool;
          debugPrint('$ts PipHandler: onPipModeChanged=$_isInPipMode activityStopped=$_isActivityStopped');
          for (final l in _pipModeListeners) l(_isInPipMode);
        } else if (call.method == 'onActivityStopped') {
          _isActivityStopped = true;
          MediaKitPlaybackEngine.isActivityStopped = true;
          debugPrint('$ts PipHandler: onActivityStopped '
                    '(isActivityStopped=$_isActivityStopped isPipMode=$_isInPipMode)');
          for (final l in _activityStoppedListeners) l();
        } else if (call.method == 'onActivityStarted') {
          _isActivityStopped = false;
          MediaKitPlaybackEngine.isActivityStopped = false;
          debugPrint('$ts PipHandler: onActivityStarted '
                    '(isActivityStopped=$_isActivityStopped isPipMode=$_isInPipMode)');
          for (final l in _activityStartedListeners) l();
        }
      });
    }
  }

  static Future<void> setPipEnabled(bool enabled) async {
    if (!kIsWeb && Platform.isAndroid) {
      try {
        await _channel.invokeMethod('setPipEnabled', {'enabled': enabled});
      } catch (e) {
        debugPrint('PipHandler: Failed to set PIP enabled: $e');
      }
    }
  }

  @visibleForTesting
  static void simulateActivityStopped() {
    _isActivityStopped = true;
    for (final l in _activityStoppedListeners) l();
  }

  @visibleForTesting
  static void simulateActivityStarted() {
    _isActivityStopped = false;
    for (final l in _activityStartedListeners) l();
  }
}
