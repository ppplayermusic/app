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
        if (call.method == 'onPipModeChanged') {
          _isInPipMode = call.arguments as bool;
          debugPrint('PipHandler: onPipModeChanged = $_isInPipMode');
          onPipModeChanged?.call(_isInPipMode);
        } else if (call.method == 'onActivityStopped') {
          debugPrint('PipHandler: onActivityStopped');
          _isActivityStopped = true;
          MediaKitPlaybackEngine.isActivityStopped = true;
          onActivityStopped?.call();
        } else if (call.method == 'onActivityStarted') {
          debugPrint('PipHandler: onActivityStarted');
          _isActivityStopped = false;
          MediaKitPlaybackEngine.isActivityStopped = false;
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
