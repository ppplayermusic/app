import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../models/playback_status.dart';
import '../models/playback_event.dart';
import '../models/playback_track.dart';
import 'playback_controller.dart';

class NativeServicePlaybackEngine implements PlaybackController {
  static const _channel = MethodChannel('com.ppplayer.app/headless_webview');

  final _statusController = StreamController<PlaybackStatus>.broadcast();
  final _eventController = StreamController<PlaybackEvent>.broadcast();
  PlaybackStatus _currentStatus = const PlaybackStatus();
  bool _disposed = false;

  /// Monotonically increasing command ID. Incremented by every play() call.
  /// Passed to the JS layer so stale cueVideo calls from pre-warms are rejected.
  int _commandId = 0;

  NativeServicePlaybackEngine() {
    _channel.setMethodCallHandler(_handleMethodCall);
    _startService();
  }

  Future<void> _startService() async {
    try {
      await _channel.invokeMethod('startService');
    } catch (e) {
      debugPrint('NativeServicePlaybackEngine: Error starting service: $e');
    }
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onReady':
        debugPrint('NativeServicePlaybackEngine: Headless WebView Ready');
        break;
      case 'onStateChange':
        final args = call.arguments as Map<dynamic, dynamic>;
        final state = args['state'] as int;
        final commandId = args['commandId'] as int;
        final newState = _mapYtState(state);
        _updateStatus(
          _currentStatus.copyWith(state: newState, generation: commandId),
        );
        if (newState == PlaybackState.ended && !_disposed) {
          _eventController.add(
            PlaybackEvent(
              type: PlaybackEventType.trackEnded,
              track: _currentStatus.track,
              generation: commandId,
            ),
          );
        }
        break;
      case 'onError':
        final error = call.arguments as int;
        _updateStatus(
          _currentStatus.copyWith(
            state: PlaybackState.error,
            error: 'YouTube Error $error',
          ),
        );
        break;
      case 'onPosition':
        final map = call.arguments as Map;
        final currentTime = (map['currentTime'] as num?)?.toDouble() ?? 0.0;
        final duration = (map['duration'] as num?)?.toDouble() ?? 0.0;
        _updateStatus(
          _currentStatus.copyWith(
            position: Duration(milliseconds: (currentTime * 1000).toInt()),
            duration: Duration(milliseconds: (duration * 1000).toInt()),
          ),
        );
        break;
    }
  }

  PlaybackState _mapYtState(int state) {
    switch (state) {
      case 1:
        return PlaybackState.playing;
      case 2:
        return PlaybackState.paused;
      case 3:
        return PlaybackState.buffering;
      case 0:
        return PlaybackState.ended;
      default:
        return _currentStatus.state;
    }
  }

  void _updateStatus(PlaybackStatus status) {
    if (_disposed) return;
    _currentStatus = status;
    _statusController.add(status);
  }

  @override
  Stream<PlaybackStatus> get statusStream => _statusController.stream;

  @override
  Stream<PlaybackEvent> get eventStream => _eventController.stream;

  @override
  PlaybackStatus get currentStatus => _currentStatus;

  @override
  dynamic get renderer => null; // No UI renderer for headless

  @override
  YoutubePlayerController? get youtubeController => null; // No iframe controller

  @override
  Future<void> prepare(PlaybackTrack track, {Duration? position}) async {
    // Capture commandId before awaiting — pre-warm uses current value.
    // When play() later increments commandId, the JS-side cueVideo is rejected.
    final id = _commandId;
    _updateStatus(
      _currentStatus.copyWith(
        track: track,
        state: PlaybackState.preparing,
        isIFrameMode: true,
      ),
    );
    try {
      await _channel.invokeMethod('prepareVideo', {
        'videoId': track.id,
        'startSeconds':
            position != null ? (position.inMilliseconds / 1000.0) : 0.0,
        'commandId': id,
      });
    } catch (e) {
      debugPrint('Error preparing video: $e');
    }
  }

  @override
  Future<void> play(
    PlaybackTrack track, {
    Duration startAt = Duration.zero,
  }) async {
    // Increment commandId BEFORE dispatching — invalidates any pending pre-warm cue.
    final id = ++_commandId;
    _updateStatus(
      _currentStatus.copyWith(
        track: track,
        state: PlaybackState.preparing,
        isIFrameMode: true,
      ),
    );
    try {
      await _channel.invokeMethod('loadVideo', {
        'videoId': track.id,
        'startSeconds': startAt.inMilliseconds / 1000.0,
        'commandId': id,
      });
    } catch (e) {
      debugPrint('Error playing video: $e');
    }
  }

  /// Starts playback at a specific [position]. Delegates to play() with startAt.
  Future<void> playAt(PlaybackTrack track, Duration position) =>
      play(track, startAt: position);

  @override
  Future<void> pause({
    String caller = 'user',
    bool failOnTimeout = false,
  }) async {
    if (_currentStatus.state == PlaybackState.paused ||
        _currentStatus.state == PlaybackState.idle) {
      return;
    }

    // Subscribe BEFORE sending the command so a fast acknowledgment is not missed.
    final pauseAck = statusStream
        .firstWhere(
          (s) =>
              s.state == PlaybackState.paused || s.state == PlaybackState.idle,
        )
        .timeout(const Duration(seconds: 2));

    try {
      await _channel
          .invokeMethod('pauseVideo')
          .timeout(const Duration(seconds: 2));
    } catch (e) {
      debugPrint('Error pausing video: $e');
      if (failOnTimeout) {
        throw TimeoutException(
          'Source pause failed (platform error)',
          const Duration(seconds: 2),
        );
      }
      _updateStatus(_currentStatus.copyWith(state: PlaybackState.paused));
      return;
    }

    try {
      await pauseAck;
    } catch (e) {
      // TimeoutException: ack didn't arrive within 2 s.
      // StateError ("No element"): engine disposed while pause was pending.
      debugPrint(
        'NativeService: pause ack timeout/close (caller=$caller, failOnTimeout=$failOnTimeout): $e',
      );
      if (failOnTimeout && e is TimeoutException) {
        throw TimeoutException(
          'Source pause unconfirmed by WebView',
          const Duration(seconds: 2),
        );
      }
      // Non-handoff callers get the optimistic fallback (user-facing pause, lock screen etc.)
      _updateStatus(_currentStatus.copyWith(state: PlaybackState.paused));
    }
  }

  @override
  Future<void> resume() async {
    // Do NOT emit playing optimistically — state must come from WebView onStateChange.
    // The handoff coordinator's firstWhere(playing) requires real WebView confirmation.
    try {
      await _channel.invokeMethod('playVideo');
    } catch (e) {
      debugPrint('Error resuming video: $e');
    }
  }

  @override
  Future<void> stop() async {
    _updateStatus(
      _currentStatus.copyWith(state: PlaybackState.idle, track: null),
    );
    try {
      await _channel.invokeMethod('pauseVideo');
    } catch (e) {
      debugPrint('Error stopping video: $e');
    }
  }

  @override
  Future<void> seekTo(Duration position) async {
    try {
      await _channel.invokeMethod('seekTo', {
        'seconds': position.inMilliseconds / 1000.0,
      });
    } catch (e) {
      debugPrint('Error seeking video: $e');
    }
  }

  @override
  Future<void> setVolume(double volume) async {
    try {
      await _channel.invokeMethod('setVolume', {
        'volume': (volume * 100).toInt(),
      });
    } catch (e) {
      debugPrint('Error setting volume: $e');
    }
  }

  @override
  bool get supportsSpeed => true;

  @override
  bool get supportsTrackSelection => false;

  @override
  bool get supportsExternalSubtitles => false;

  @override
  bool get supportsSubtitleDelay => false;

  @override
  bool get supportsSubtitleTextSize => false;

  @override
  bool get supportsSubtitleBackgroundStyling => false;

  /// Always false: NativeServicePlaybackEngine is a headless audio service
  /// that has no visible UI rendering surface and cannot apply fit/fill scaling.
  @override
  bool get supportsVideoFitMode => false;

  @override
  Future<void> setSpeed(double speed) async {
    if (_disposed) return;
    try {
      await _channel.invokeMethod('setSpeed', {'speed': speed});
    } catch (e) {
      debugPrint('NativeServicePlaybackEngine: setSpeed error: $e');
    }
  }

  @override
  Future<void> setSubtitleTrack(String? uri) async {
    // Subtitles are not rendered in headless service mode.
  }

  @override
  Future<void> setSubtitleDelay(Duration delay) async {
    // Delay adjustment not supported in headless mode.
  }

  @override
  Future<void> setSubtitleAppearance({double? textSize, int? backgroundColor}) async {
    // Subtitles are not rendered in headless service mode.
  }

  @override
  Future<void> dispose() async {
    _disposed = true;
    try {
      await _channel
          .invokeMethod('stopService')
          .timeout(const Duration(seconds: 2));
    } catch (_) {}
    _channel.setMethodCallHandler(null);
    _statusController.close();
    _eventController.close();
  }
}
