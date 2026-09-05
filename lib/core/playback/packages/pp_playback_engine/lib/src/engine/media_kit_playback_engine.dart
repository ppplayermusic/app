import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:media_kit/media_kit.dart' hide Track;
import 'package:media_kit_video/media_kit_video.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart' as yt;

import '../models/playback_status.dart';
import '../models/playback_event.dart';
import '../models/playback_track.dart';
import 'playback_controller.dart';

class MediaKitPlaybackEngine implements PlaybackController {
  final Player _player = Player();
  late final VideoController _videoController;
  yt.YoutubePlayerController? _youtubeController;

  int _playGeneration = 0;
  int _lastPlayedGeneration = 0;
  Timer? _watchdogTimer;
  Timer? _iframePositionTimer;

  final _statusController = StreamController<PlaybackStatus>.broadcast();
  final _eventController = StreamController<PlaybackEvent>.broadcast();


  PlaybackStatus _currentStatus = const PlaybackStatus();

  MediaKitPlaybackEngine() {
    _videoController = VideoController(_player);

    _player.stream.position.listen((pos) {
      if (!_currentStatus.isIFrameMode) {
        _updateStatus(_currentStatus.copyWith(position: pos));
      }
    });

    _player.stream.duration.listen((dur) {
      if (!_currentStatus.isIFrameMode) {
        _updateStatus(_currentStatus.copyWith(duration: dur));
      }
    });

    _player.stream.buffer.listen((buf) {
      if (!_currentStatus.isIFrameMode) {
        _updateStatus(_currentStatus.copyWith(buffered: buf));
      }
    });

    _player.stream.playing.listen((playing) {
      if (!_currentStatus.isIFrameMode) {
        _updateStatus(_currentStatus.copyWith(
          state: playing ? PlaybackState.playing : PlaybackState.paused,
        ));
      }
    });

    _player.stream.error.listen((err) {
      if (!_currentStatus.isIFrameMode) {
        _updateStatus(_currentStatus.copyWith(
          state: PlaybackState.error,
          error: err,
        ));
      }
    });

    _player.stream.completed.listen((completed) {
      if (completed && !_currentStatus.isIFrameMode) {
        _updateStatus(_currentStatus.copyWith(state: PlaybackState.ended));
      }
    });

    _player.stream.buffering.listen((buffering) {
      if (!_currentStatus.isIFrameMode) {
        _updateStatus(_currentStatus.copyWith(
          state: buffering ? PlaybackState.buffering : _currentStatus.state,
        ));
      }
    });
  }

  @override
  Stream<PlaybackStatus> get statusStream => _statusController.stream;

  @override
  Stream<PlaybackEvent> get eventStream => _eventController.stream;

  @override
  PlaybackStatus get currentStatus => _currentStatus;

  @override
  VideoController get renderer => _videoController;

  @override
  yt.YoutubePlayerController? get youtubeController => _youtubeController;

  @override
  Future<void> play(PlaybackTrack track) async {
    _playGeneration++;
    final myGen = _playGeneration;

    debugPrint('ENGINE: play called for track ${track.id} (gen: $myGen)');
    
    String testVideoId = track.id; 

    debugPrint('MediaKitPlaybackEngine: Playing track $testVideoId (original: ${track.id})');
    
    // 1. Cleanup previous state but keep IFrame controller if possible
    _watchdogTimer?.cancel();
    if (!_currentStatus.isIFrameMode) {
      await stop();
    } else {
      // If already in IFrame mode, just stop the current video
      try {
        await _youtubeController?.pauseVideo().timeout(const Duration(seconds: 1));
      } catch (e) {
        debugPrint('MediaKitPlaybackEngine: pauseVideo failed/timed out: $e');
      }
    }

    if (myGen != _playGeneration) return;

    _updateStatus(_currentStatus.copyWith(
      track: track,
      state: PlaybackState.preparing,
      clearError: true,
      activeVideoId: testVideoId,
      hasVideo: true,
      // Pivot immediately so the UI builds the platform view
      isIFrameMode: true,
    ));

    // 2. Initialize or reuse IFrame controller
    await _enterIFrameMode(testVideoId, generation: myGen);
  }

  Future<void> _enterIFrameMode(String videoId, {required int generation}) async {
    // Create the controller once. We do NOT use fromVideoId because that
    // internally schedules cueVideoById which produces 'unStarted' rather
    // than 'cued'. We always want to drive the state via loadVideoById so
    // the listener has a single, predictable trigger ('cued' → playVideo).
    if (_youtubeController == null) {
      debugPrint('MediaKitPlaybackEngine: [INIT] Creating YoutubePlayerController (persistent singleton)');
      
        _youtubeController = yt.YoutubePlayerController(
          params: const yt.YoutubePlayerParams(
            showControls: false,
            showFullscreenButton: false,
            mute: false,
            loop: false,
            strictRelatedVideos: true,
            origin: 'https://ppplayer.com',
            pointerEvents: yt.PointerEvents.none,
          ),
        );

      _youtubeController!.webViewController.addJavaScriptChannel('NativeLog', onMessageReceived: (msg) {
        debugPrint('MediaKitPlaybackEngine: [NativeLog] ${msg.message}');
      });

      // Persistent generation-aware listener. This is the ONLY place
      // that calls playVideo() in response to a 'cued' state.
      _youtubeController!.listen((ytState) {
        if (!_currentStatus.isIFrameMode) return;
        final gen = _playGeneration; // capture
        debugPrint('MediaKitPlaybackEngine: [BRIDGE gen $gen] -> ${ytState.playerState}');

        switch (ytState.playerState) {
          case yt.PlayerState.cued:
            // Video is loaded and ready. Call playVideo once per generation.
            if (_lastPlayedGeneration != gen) {
              _lastPlayedGeneration = gen;
              debugPrint('MediaKitPlaybackEngine: [PLAY gen $gen] cued → playVideo()');
              _youtubeController?.playVideo();
            }
            break;
          case yt.PlayerState.unStarted:
            // YouTube is ready but hasn't started. Try to play.
            if (_lastPlayedGeneration != gen) {
              _lastPlayedGeneration = gen;
              _youtubeController?.playVideo();
            }
            break;
          default:
            break;
        }

        final newState = switch (ytState.playerState) {
          yt.PlayerState.playing => PlaybackState.playing,
          yt.PlayerState.paused => PlaybackState.paused,
          yt.PlayerState.unStarted => PlaybackState.paused,
          yt.PlayerState.buffering => PlaybackState.buffering,
          yt.PlayerState.ended => PlaybackState.ended,
          _ => _currentStatus.state,
        };
        if (newState != _currentStatus.state) {
          _updateStatus(_currentStatus.copyWith(state: newState));
        }
      });
    }

    if (generation != _playGeneration) {
      debugPrint('MediaKitPlaybackEngine: Stale enterIFrameMode (gen: $generation). Aborting.');
      return;
    }

    // Emit status so ScaffoldWithNav rebuilds and mounts YoutubePlayer.
    // The widget mounting will call controller.init() → loadHtmlString →
    // onReady → JS bridge ready → loadVideoById (below or from listener).
    _updateStatus(_currentStatus);

    // Start the watchdog BEFORE issuing loadVideoById so it can observe
    // whether the bridge gets established. The watchdog is a recovery
    // mechanism, not the primary playback driver.
    _watchdogTimer?.cancel();
    _watchdogTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      if (generation != _playGeneration || _youtubeController == null || !_currentStatus.isIFrameMode) {
        timer.cancel();
        return;
      }

      final state = _currentStatus.state;
      debugPrint('MediaKitPlaybackEngine: [WATCHDOG gen $generation] $state tick=${timer.tick}');

      try {
        if (_youtubeController != null) {
          final html = await _youtubeController!.webViewController.runJavaScriptReturningResult('document.documentElement.outerHTML');
          final loc = await _youtubeController!.webViewController.runJavaScriptReturningResult('window.location.href');
          debugPrint('MediaKitPlaybackEngine: [DOM] loc: $loc, html length: ${html.toString().length}, content start: ${html.toString().substring(0, html.toString().length > 100 ? 100 : html.toString().length)}');
          try {
            File('/Users/veneno/Projects/Apps/ppplayer/generated_player.html').writeAsStringSync(html.toString());
          } catch(e) {}
        }
      } catch (e) {
        debugPrint('MediaKitPlaybackEngine: [DOM ERROR] $e');
      }

      if (state == PlaybackState.playing ||
          state == PlaybackState.buffering ||
          state == PlaybackState.ended) {
        debugPrint('MediaKitPlaybackEngine: [WATCHDOG] Success. Stopping.');
        timer.cancel();
        return;
      }

      // Recovery: only after 10 ticks (20s) with no progress
      if (timer.tick >= 10 && state == PlaybackState.idle) {
        debugPrint('MediaKitPlaybackEngine: [WATCHDOG] JS bridge unresponsive after 20s. Retrying loadVideoById.');
        _youtubeController?.loadVideoById(videoId: videoId);
      }

      if (timer.tick >= 15) {
        debugPrint('MediaKitPlaybackEngine: [WATCHDOG gen $generation] Safety cutoff. Cancelling.');
        timer.cancel();
        _updateStatus(_currentStatus.copyWith(
          state: PlaybackState.error,
          error: 'YouTube playback timed out',
        ));
      }
    });

    // Issue loadVideoById explicitly. This is the authoritative command
    // that drives the player to 'cued' state, after which the listener
    // calls playVideo(). On first mount, init() hasn't been called yet
    // so this call queues behind _initCompleter and fires once onReady fires.
    debugPrint('MediaKitPlaybackEngine: [LOAD gen $generation] loadVideoById: $videoId');
    _youtubeController!.loadVideoById(videoId: videoId);
  }


  @override
  Future<void> pause() async {
    debugPrint('MediaKitPlaybackEngine: pause() called');
    if (_currentStatus.isIFrameMode) {
      await _youtubeController?.pauseVideo();
    } else {
      await _player.pause();
    }
  }

  @override
  Future<void> resume() async {
    debugPrint('MediaKitPlaybackEngine: resume() called');
    if (_currentStatus.isIFrameMode) {
      await _youtubeController?.playVideo();
    } else {
      await _player.play();
    }
  }

  @override
  Future<void> stop() async {
    if (_currentStatus.isIFrameMode) {
      await _youtubeController?.pauseVideo();
      // We keep the controller alive to avoid recreating the platform view
    } else {
      await _player.stop();
    }
    _updateStatus(_currentStatus.copyWith(
      state: PlaybackState.idle, 
      track: null,
      activeVideoId: null,
    ));
  }

  @override
  Future<void> seekTo(Duration position) async {
    if (_currentStatus.isIFrameMode) {
      await _youtubeController?.seekTo(seconds: position.inSeconds.toDouble());
    } else {
      await _player.seek(position);
    }
  }

  @override
  Future<void> setVolume(double volume) async {
    if (_currentStatus.isIFrameMode) {
      // youtube_player_iframe volume control is limited
    } else {
      await _player.setVolume(volume * 100);
    }
    _updateStatus(_currentStatus.copyWith(volume: volume));
  }

  @override
  Future<void> setSpeed(double speed) async {
    if (_currentStatus.isIFrameMode) {
      await _youtubeController?.setPlaybackRate(speed);
    } else {
      await _player.setRate(speed);
    }
  }

  void _updateStatus(PlaybackStatus status) {
    debugPrint('MediaKitPlaybackEngine: _updateStatus(${status.state})');
    _currentStatus = status;
    _statusController.add(status);

    // Manage IFrame position polling
    if (status.isIFrameMode && status.state == PlaybackState.playing) {
      if (_iframePositionTimer == null) {
        _startIFramePolling();
      }
    } else if (status.state != PlaybackState.playing) {
      _stopIFramePolling();
    }
  }

  void _startIFramePolling() {
    _iframePositionTimer?.cancel();
    _iframePositionTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) async {
      if (_youtubeController == null || !_currentStatus.isIFrameMode) {
        timer.cancel();
        return;
      }
      
      try {
        final currentTime = await _youtubeController!.currentTime;
        final duration = await _youtubeController!.duration;
        
        if (_currentStatus.state == PlaybackState.playing) {
          _updateStatus(_currentStatus.copyWith(
            position: Duration(seconds: currentTime.toInt()),
            duration: Duration(seconds: duration.toInt()),
          ));
        }
      } catch (e) {
        // Ignore polling errors during transitions
      }
    });
  }

  void _stopIFramePolling() {
    _iframePositionTimer?.cancel();
    _iframePositionTimer = null;
  }

  @override
  void dispose() {
    _player.dispose();
    _watchdogTimer?.cancel();
    _iframePositionTimer?.cancel();
    _youtubeController?.close();
    _statusController.close();
    _eventController.close();
  }
}
