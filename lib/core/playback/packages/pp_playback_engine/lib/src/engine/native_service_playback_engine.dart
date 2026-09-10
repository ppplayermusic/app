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
        final state = call.arguments as int;
        final newState = _mapYtState(state);
        _updateStatus(_currentStatus.copyWith(state: newState));
        break;
      case 'onError':
        final error = call.arguments as int;
        _updateStatus(_currentStatus.copyWith(
          state: PlaybackState.error, 
          error: 'YouTube Error $error'
        ));
        break;
      case 'onPosition':
        final map = call.arguments as Map;
        final currentTime = (map['currentTime'] as num?)?.toDouble() ?? 0.0;
        final duration = (map['duration'] as num?)?.toDouble() ?? 0.0;
        _updateStatus(_currentStatus.copyWith(
          position: Duration(milliseconds: (currentTime * 1000).toInt()),
          duration: Duration(milliseconds: (duration * 1000).toInt())
        ));
        break;
    }
  }
  
  PlaybackState _mapYtState(int state) {
    switch (state) {
      case 1: return PlaybackState.playing;
      case 2: return PlaybackState.paused;
      case 3: return PlaybackState.buffering;
      case 0: return PlaybackState.ended;
      default: return _currentStatus.state;
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
    _updateStatus(_currentStatus.copyWith(
      track: track,
      state: PlaybackState.preparing,
      isIFrameMode: true
    ));
    try {
      await _channel.invokeMethod('prepareVideo', {
        'videoId': track.id,
        'startSeconds': position != null ? (position.inMilliseconds / 1000.0) : 0.0
      });
    } catch (e) {
      debugPrint('Error preparing video: $e');
    }
  }

  @override
  Future<void> play(PlaybackTrack track, {Duration startAt = Duration.zero}) async {
    _updateStatus(_currentStatus.copyWith(
      track: track,
      state: PlaybackState.preparing,
      isIFrameMode: true
    ));
    try {
      // loadVideo(videoId, startSeconds) both loads AND starts playback.
      // This guarantees the correct video plays even when switching tracks
      // while already in background mode, without a separate prepare() call.
      await _channel.invokeMethod('loadVideo', {
        'videoId': track.id,
        'startSeconds': startAt.inMilliseconds / 1000.0
      });
    } catch (e) {
      debugPrint('Error playing video: $e');
    }
  }

  /// Starts playback at a specific [position]. Delegates to play() with startAt.
  Future<void> playAt(PlaybackTrack track, Duration position) =>
      play(track, startAt: position);

  @override
  Future<void> pause({String caller = 'user'}) async {
    if (_currentStatus.state == PlaybackState.paused || _currentStatus.state == PlaybackState.idle) {
      return;
    }
    
    // Subscribe *before* sending the command so a fast acknowledgment cannot be missed.
    final pauseAck = statusStream
        .firstWhere((s) => s.state == PlaybackState.paused || s.state == PlaybackState.idle)
        .timeout(const Duration(seconds: 2));

    try {
      await _channel.invokeMethod('pauseVideo');
    } catch (e) {
      debugPrint('Error pausing video: $e');
      // Optimistic fallback on platform error
      _updateStatus(_currentStatus.copyWith(state: PlaybackState.paused));
      return;
    }
    
    try {
      await pauseAck;
    } catch (_) {
      debugPrint('Timeout waiting for pause acknowledgment in NativeService');
      // If it times out, we enforce the state so the coordinator can continue with its own timeouts
      _updateStatus(_currentStatus.copyWith(state: PlaybackState.paused));
    }
  }

  @override
  Future<void> resume() async {
    _updateStatus(_currentStatus.copyWith(state: PlaybackState.playing));
    try {
      await _channel.invokeMethod('playVideo');
    } catch (e) {
      debugPrint('Error resuming video: $e');
    }
  }

  @override
  Future<void> stop() async {
    _updateStatus(_currentStatus.copyWith(state: PlaybackState.idle, track: null));
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
        'seconds': position.inMilliseconds / 1000.0
      });
    } catch (e) {
      debugPrint('Error seeking video: $e');
    }
  }

  @override
  Future<void> setVolume(double volume) async {
    try {
      await _channel.invokeMethod('setVolume', {
        'volume': (volume * 100).toInt()
      });
    } catch (e) {
      debugPrint('Error setting volume: $e');
    }
  }

  @override
  Future<void> setSpeed(double speed) async {
    // Not implemented in headless for now
  }

  @override
  void dispose() {
    _disposed = true;
    _channel.invokeMethod('stopService');
    _channel.setMethodCallHandler(null);
    _statusController.close();
    _eventController.close();
  }
}
