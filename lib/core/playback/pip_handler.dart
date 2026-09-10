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
  
  static void Function(bool)? onPipModeChanged;
  static void Function()? onActivityStopped;
  static void Function()? onActivityStarted;

  static void init() {
    if (!kIsWeb && Platform.isAndroid) {
      _channel.setMethodCallHandler((call) async {
        final ts = DateTime.now().toIso8601String();
        if (call.method == 'onPipModeChanged') {
          _isInPipMode = call.arguments as bool;
          debugPrint('$ts PipHandler: onPipModeChanged=$_isInPipMode activityStopped=$_isActivityStopped');
          onPipModeChanged?.call(_isInPipMode);
        } else if (call.method == 'onActivityStopped') {
          _isActivityStopped = true;
          MediaKitPlaybackEngine.isActivityStopped = true;
          debugPrint('$ts PipHandler: onActivityStopped '
                    '(isActivityStopped=$_isActivityStopped isPipMode=$_isInPipMode)');
          onActivityStopped?.call();
        } else if (call.method == 'onActivityStarted') {
          _isActivityStopped = false;
          MediaKitPlaybackEngine.isActivityStopped = false;
          debugPrint('$ts PipHandler: onActivityStarted '
                    '(isActivityStopped=$_isActivityStopped isPipMode=$_isInPipMode)');
          onActivityStarted?.call();
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
}
