import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:media_kit/media_kit.dart' hide Track;
import 'package:media_kit_video/media_kit_video.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart' as yt;

import '../models/playback_status.dart';
import '../models/playback_event.dart';
import '../models/playback_track.dart';
import 'playback_controller.dart';

class MediaKitPlaybackEngine implements PlaybackController {
  
  /// Informs the engine that the host activity is stopped (e.g., screen locked).
  /// Used to block IFrame playback dispatches when the WebView is frozen.
  static bool isActivityStopped = false;

  Player? _player;
  VideoController? _videoController;
  yt.YoutubePlayerController? _youtubeController;

  int _playGeneration = 0;
  int _lastPlayedGeneration = 0;
  Timer? _watchdogTimer;
  Timer? _iframePositionTimer;

  final _statusController = StreamController<PlaybackStatus>.broadcast();
  final _eventController = StreamController<PlaybackEvent>.broadcast();


  PlaybackStatus _currentStatus = const PlaybackStatus();
  PlaybackState? _intendedState;

  MediaKitPlaybackEngine() {
    _ensureMediaKitInitialized();
  }

  void _ensureMediaKitInitialized() {
    if (_player != null) return;
    
    try {
      MediaKit.ensureInitialized();
    } catch (_) {
      // Ignored if already initialized
    }
    
    _player = Player();
    _videoController = VideoController(_player!);

    _player!.stream.position.listen((pos) {
      if (!_currentStatus.isIFrameMode) {
        _updateStatus(_currentStatus.copyWith(position: pos));
      }
    });

    _player!.stream.duration.listen((dur) {
      if (!_currentStatus.isIFrameMode) {
        _updateStatus(_currentStatus.copyWith(duration: dur));
      }
    });

    _player!.stream.buffer.listen((buf) {
      if (!_currentStatus.isIFrameMode) {
        _updateStatus(_currentStatus.copyWith(buffered: buf));
      }
    });

    _player!.stream.playing.listen((playing) {
      if (!_currentStatus.isIFrameMode) {
        _updateStatus(_currentStatus.copyWith(
          state: playing ? PlaybackState.playing : PlaybackState.paused,
        ));
      }
    });

    _player!.stream.error.listen((err) {
      if (!_currentStatus.isIFrameMode) {
        _updateStatus(_currentStatus.copyWith(
          state: PlaybackState.error,
          error: err,
        ));
      }
    });

    _player!.stream.completed.listen((completed) {
      if (completed && !_currentStatus.isIFrameMode) {
        _updateStatus(_currentStatus.copyWith(state: PlaybackState.ended));
      }
    });

    _player!.stream.buffering.listen((buffering) {
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
  dynamic get renderer => _videoController;

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

    _intendedState = PlaybackState.playing;

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

      // ignore: invalid_use_of_internal_member
      _youtubeController!.webViewController.addJavaScriptChannel('NativeLog', onMessageReceived: (msg) {
        debugPrint('MediaKitPlaybackEngine: [NativeLog] ${msg.message}');
      });

      // Persistent generation-aware listener. This is the ONLY place
      // that calls playVideo() in response to a 'cued' state.
      _youtubeController!.listen((ytState) {
        if (!_currentStatus.isIFrameMode) return;
        
        final gen = _playGeneration; // capture
        debugPrint('MediaKitPlaybackEngine: [BRIDGE gen $gen] -> ${ytState.playerState}');

        if (ytState.hasError && ytState.error != yt.YoutubeError.none) {
          debugPrint('MediaKitPlaybackEngine: [ERROR] YouTube IFrame error: ${ytState.error}');
          
          if (_currentStatus.state == PlaybackState.preparing) {
             debugPrint('MediaKitPlaybackEngine: [BRIDGE] Ignoring error event while preparing new track (stale callback guard).');
             return;
          }
          
          if (ytState.error == yt.YoutubeError.videoNotFound ||
              ytState.error == yt.YoutubeError.notEmbeddable ||
              ytState.error == yt.YoutubeError.cannotFindVideo ||
              ytState.error == yt.YoutubeError.sameAsNotEmbeddable ||
              ytState.error == yt.YoutubeError.invalidParam) {
            
            _updateStatus(_currentStatus.copyWith(
              state: PlaybackState.error,
              error: 'unavailable_media:${ytState.error.name}',
            ));
            return; // Stop processing state on fatal error
          }
          // Transient errors are ignored
        }

        switch (ytState.playerState) {
          case yt.PlayerState.cued:
          case yt.PlayerState.unStarted:
            // Video is loaded and ready or hasn't started. Try to play.
            if (_lastPlayedGeneration != gen) {
              _dispatchIFramePlay(gen, ytState.playerState.name);
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

        if (newState == PlaybackState.ended && _currentStatus.state == PlaybackState.preparing) {
          debugPrint('MediaKitPlaybackEngine: [BRIDGE] Ignoring ended event while preparing new track (stale callback guard).');
          return;
        }

        if (newState == PlaybackState.playing && _intendedState == PlaybackState.paused) {
          debugPrint('MediaKitPlaybackEngine: [BRIDGE] Spurious playback detected while intended state is paused. Forcing pause.');
          _youtubeController?.pauseVideo();
          return;
        }

        if (newState == PlaybackState.paused && _intendedState == PlaybackState.playing) {
          debugPrint('MediaKitPlaybackEngine: [BRIDGE] Spurious pause detected while intended state is playing (e.g., PiP transition). Forcing play.');
          _youtubeController?.playVideo();
          // We still allow the state to update to paused momentarily, 
          // as it accurately reflects the IFrame's current state until it resumes.
        }

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

      if (state == PlaybackState.playing ||
          state == PlaybackState.buffering ||
          state == PlaybackState.ended) {
        debugPrint('MediaKitPlaybackEngine: [WATCHDOG] Success. Stopping.');
        timer.cancel();
        return;
      }

      // Recovery: retry after 10 ticks (20s) with no progress.
      // State may be 'preparing' (new track) or 'idle' (reset) — retry both.
      if (timer.tick >= 10 && (state == PlaybackState.idle || state == PlaybackState.preparing)) {
        debugPrint('MediaKitPlaybackEngine: [WATCHDOG] No playback after 20s (state=$state). Retrying loadVideoById.');
        _lastPlayedGeneration = -1; // reset so the listener triggers playVideo() again
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
    _intendedState = PlaybackState.paused;
    if (_currentStatus.isIFrameMode) {
      await _youtubeController?.pauseVideo();
    } else {
      await _player?.pause();
    }
  }

  void _dispatchIFramePlay(int expectedGeneration, String source) {
    if (expectedGeneration != _playGeneration) {
      debugPrint('MediaKitPlaybackEngine: [_dispatchIFramePlay] Stale dispatch from $source (gen $expectedGeneration).');
      return;
    }
    if (isActivityStopped) {
      debugPrint('MediaKitPlaybackEngine: [_dispatchIFramePlay] Blocked IFrame play ($source) because activity is stopped.');
      _intendedState = PlaybackState.paused;
      return;
    }
    if (_intendedState == PlaybackState.paused) {
      debugPrint('MediaKitPlaybackEngine: [_dispatchIFramePlay] Blocked IFrame play ($source) because intended state is paused.');
      return;
    }

    _lastPlayedGeneration = expectedGeneration;
    debugPrint('MediaKitPlaybackEngine: [PLAY gen $expectedGeneration] $source → playVideo()');
    _youtubeController?.setVolume((_currentStatus.volume * 100).toInt());
    _youtubeController?.playVideo();
  }

  @override
  Future<void> resume() async {
    debugPrint('MediaKitPlaybackEngine: resume() called');
    _intendedState = PlaybackState.playing;
    if (_currentStatus.isIFrameMode) {
      _dispatchIFramePlay(_playGeneration, 'resume');
    } else {
      await _player?.play();
    }
  }

  @override
  Future<void> stop() async {
    _intendedState = PlaybackState.paused;
    if (_currentStatus.isIFrameMode) {
      await _youtubeController?.pauseVideo();
      // We keep the controller alive to avoid recreating the platform view
    } else {
      await _player?.stop();
    }
    _updateStatus(_currentStatus.copyWith(
      state: PlaybackState.idle, 
      track: null,
      activeVideoId: null,
    ));
  }

  @override
  Future<void> seekTo(Duration position) async {
    final wasPlaying = _currentStatus.state == PlaybackState.playing;
    
    if (_currentStatus.isIFrameMode) {
      await _youtubeController?.seekTo(
        seconds: position.inSeconds.toDouble(),
        allowSeekAhead: true,
      );
      if (wasPlaying) {
        await _youtubeController?.playVideo();
      }
    } else {
      await _player?.seek(position);
      if (wasPlaying) {
        await _player?.play();
      }
    }
  }

  @override
  Future<void> setVolume(double volume) async {
    if (_currentStatus.isIFrameMode) {
      await _youtubeController?.setVolume((volume * 100).toInt());
    } else {
      await _player?.setVolume(volume * 100);
    }
    _updateStatus(_currentStatus.copyWith(volume: volume));
  }

  @override
  Future<void> setSpeed(double speed) async {
    if (_currentStatus.isIFrameMode) {
      await _youtubeController?.setPlaybackRate(speed);
    } else {
      await _player?.setRate(speed);
    }
  }

  void _updateStatus(PlaybackStatus status) {
    // Only log on meaningful state transitions, not position-polling noise
    if (status.state != _currentStatus.state) {
      debugPrint('MediaKitPlaybackEngine: _updateStatus(${_currentStatus.state} → ${status.state})');
    }
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
    _player?.dispose();
    _watchdogTimer?.cancel();
    _iframePositionTimer?.cancel();
    _youtubeController?.close();
    _statusController.close();
    _eventController.close();
  }
}

