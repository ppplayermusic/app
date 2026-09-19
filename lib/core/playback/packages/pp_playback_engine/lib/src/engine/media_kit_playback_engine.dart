import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:media_kit/media_kit.dart' hide Track;
import 'package:media_kit_video/media_kit_video.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart' as yt;

import '../models/playback_status.dart';
import '../models/playback_event.dart';
import '../models/playback_track.dart';
import 'playback_controller.dart';
import 'background_playback_experiment.dart';

/// Returns an ISO-8601-like timestamp for diagnostic log lines.
String _ts() {
  final now = DateTime.now();
  return '${now.hour.toString().padLeft(2, '0')}:'
      '${now.minute.toString().padLeft(2, '0')}:'
      '${now.second.toString().padLeft(2, '0')}.'
      '${now.millisecond.toString().padLeft(3, '0')}';
}

/// Tagged diagnostic print — always present regardless of experiment flag.
void _diag(String msg) =>
    debugPrint('${_ts()} ${BackgroundPlaybackExperiment.tag} $msg');

class MediaKitPlaybackEngine implements PlaybackController {
  final yt.YoutubePlayerController Function(String, yt.YoutubePlayerParams)?
  youtubeControllerFactory;

  MediaKitPlaybackEngine({
    this.youtubeControllerFactory,
    Player? nativePlayer,
  }) {
    _player = nativePlayer;
    _ensureMediaKitInitialized();
  }

  /// Informs the engine that the host activity is stopped (e.g., screen locked).
  /// Used to block IFrame playback dispatches when the WebView is frozen.
  static bool isActivityStopped = false;

  Player? _player;
  VideoController? _videoController;
  yt.YoutubePlayerController? _youtubeController;

  int _playGeneration = 0;
  int _lastPlayedGeneration = 0;
  int _intentRevision = 0;
  bool _disposed = false;
  bool _attemptActive = false;
  bool _recoveryUsed = false;
  bool _ready = false;
  int? _latePauseGeneration;

  bool _valid(int generation) =>
      !_disposed && _attemptActive && generation == _playGeneration;

  // The startSeconds used for the current load attempt — preserved for watchdog recovery.
  double? _currentStartSeconds;

  // Confirmed playback position observed during the current generation's playing state.
  // Only updated while _attemptActive && state==playing for this generation.
  // Used by watchdog recovery to retry from where audio actually was, not from start.
  Duration? _confirmedPlaybackPosition;
  int _confirmedPositionGeneration = -1;

  void _failAttempt(int generation, String error) {
    if (!_valid(generation)) return;
    _attemptActive = false;
    _watchdogTimer?.cancel();
    _updateStatus(
      _currentStatus.copyWith(state: PlaybackState.error, error: error),
    );
  }

  // Loading measures bridge readiness; start measures an accepted play command.
  // The single recovery budget is shared by both phases of one attempt.
  void _armWatchdog(int generation, {required bool loading}) {
    _watchdogTimer?.cancel();
    _watchdogTimer = Timer(Duration(seconds: _recoveryUsed ? 10 : 20), () {
      if (!_valid(generation) || _intendedState != PlaybackState.playing) {
        return;
      }
      if (_currentStatus.state == PlaybackState.playing) return;
      if (!BackgroundPlaybackExperiment.enabled && isActivityStopped) return;
      if (_recoveryUsed) {
        _failAttempt(
          generation,
          loading
              ? 'error: YouTube loading timed out (gen=$generation)'
              : 'error: YouTube playback start timed out (gen=$generation)',
        );
        return;
      }
      _recoveryUsed = true;
      _ready = false;
      _lastPlayedGeneration = -1;
      if (!_valid(generation)) return;
      _armWatchdog(generation, loading: true);
      // Use the latest confirmed position for the current generation, falling back to
      // the original start offset when no position has been observed yet.
      final recoveryStart =
          (_confirmedPositionGeneration == generation &&
                  _confirmedPlaybackPosition != null)
              ? _confirmedPlaybackPosition!.inMilliseconds / 1000.0
              : _currentStartSeconds;
      unawaited(
        _load(
          generation,
          _currentStatus.track!.id,
          startSeconds: recoveryStart,
        ),
      );
    });
  }

  Timer? _watchdogTimer;
  Timer? _iframePositionTimer;
  final List<StreamSubscription<dynamic>> _subscriptions = [];

  final _statusController = StreamController<PlaybackStatus>.broadcast();
  final _eventController = StreamController<PlaybackEvent>.broadcast();

  PlaybackStatus _currentStatus = const PlaybackStatus(supportsSpeed: true);
  PlaybackState? _intendedState;

  void _ensureMediaKitInitialized() {
    if (_player == null) {
      try {
        MediaKit.ensureInitialized();
        _player = Player();
        _videoController = VideoController(_player!);
      } catch (e) {
        debugPrint(
          'MediaKitPlaybackEngine: Test environment detected, skipping MediaKit Player initialization.',
        );
        return;
      }
    }

    _subscriptions.addAll([
      _player!.stream.position.listen((pos) {
        if (!_currentStatus.isIFrameMode) {
          _updateStatus(_currentStatus.copyWith(
            position: pos,
            isLive: _currentStatus.track?.liveStatus == PlaybackLiveStatus.live,
          ));
        }
      }),
      _player!.stream.duration.listen((dur) {
        if (!_currentStatus.isIFrameMode) {
          final isSeekable = dur > Duration.zero;
          _updateStatus(_currentStatus.copyWith(
            duration: dur,
            isSeekable: isSeekable,
            isLive: _currentStatus.track?.liveStatus == PlaybackLiveStatus.live,
          ));
        }
      }),
      _player!.stream.buffer.listen((buf) {
        if (!_currentStatus.isIFrameMode) {
          _updateStatus(_currentStatus.copyWith(buffered: buf));
        }
      }),
      _player!.stream.playing.listen((playing) {
        if (!_currentStatus.isIFrameMode && _currentStatus.state != PlaybackState.preparing) {
          _updateStatus(
            _currentStatus.copyWith(
              state: playing ? PlaybackState.playing : PlaybackState.paused,
            ),
          );
        }
      }),
      _player!.stream.error.listen((err) {
        if (!_currentStatus.isIFrameMode) {
          final errStr = err.toString().toLowerCase();
          String errorCode = 'error:playback_failed';
          if (errStr.contains('timeout')) {
            errorCode = 'error:playback_timeout';
          } else if (errStr.contains('format') || errStr.contains('codec') || errStr.contains('corrupt')) {
            errorCode = 'error:unsupported_format';
          } else if (errStr.contains('access') || errStr.contains('permission') || errStr.contains('not found')) {
            errorCode = 'error:file_inaccessible';
          }
          _updateStatus(
            _currentStatus.copyWith(state: PlaybackState.error, error: errorCode),
          );
        }
      }),
      _player!.stream.completed.listen((completed) {
        if (completed && !_currentStatus.isIFrameMode) {
          _updateStatus(_currentStatus.copyWith(state: PlaybackState.ended));
        }
      }),
      _player!.stream.buffering.listen((buffering) {
        if (!_currentStatus.isIFrameMode) {
          final isPlaying = _player!.state.playing;
          _updateStatus(
            _currentStatus.copyWith(
              state: buffering 
                  ? PlaybackState.buffering 
                  : (isPlaying ? PlaybackState.playing : PlaybackState.paused),
            ),
          );
        }
      }),
      _player!.stream.videoParams.listen((params) {
        if (!_currentStatus.isIFrameMode) {
          final w = params.w ?? 0;
          final h = params.h ?? 0;
          final hasVideo = w > 0 && h > 0;
          double? ar;
          if (hasVideo) {
            // Handle rotation swapping width/height
            // Not all media_kit platforms expose rotation reliably yet, but if they did we'd swap them.
            // But we can check if it's there. media_kit's VideoParams currently doesn't expose rotation.
            ar = w / h;
          }
          _updateStatus(_currentStatus.copyWith(
            hasVideo: hasVideo,
            videoAspectRatio: ar,
          ));
        }
      }),
    ]);
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
  Future<void> prepare(PlaybackTrack track, {Duration? position}) async {
    if (_disposed) return;
    
    if (track.isLocal || track.sourceType == PlaybackSourceType.networkStream) {
      final uri = track.isLocal ? track.localMediaUri : track.networkMediaUri;
      if (uri == null) {
        _updateStatus(_currentStatus.copyWith(
          track: track,
          state: PlaybackState.error,
          error: 'Media URI is missing for ${track.id}',
        ));
        return;
      }
      _intentRevision++;
      _intendedState = PlaybackState.paused;
      _playGeneration++;
      final myGen = _playGeneration;
      
      _updateStatus(_currentStatus.copyWith(
        track: track,
        state: PlaybackState.preparing,
        isIFrameMode: false,
        activeVideoId: track.id,
        hasVideo: track.isVideo,
        isLive: track.liveStatus == PlaybackLiveStatus.live,
        isSeekable: track.liveStatus != PlaybackLiveStatus.live,
      ));
      
      if (_currentStatus.isIFrameMode) {
        try {
          await _youtubeController?.pauseVideo().timeout(const Duration(seconds: 1));
        } catch (_) {}
      }
      
      try {
        await _player!.open(Media(uri), play: false);
        if (_disposed || _playGeneration != myGen) return;
        
        if (position != null) {
          await _player!.seek(position);
          if (_disposed || _playGeneration != myGen) return;
          _updateStatus(_currentStatus.copyWith(position: position));
        }
        _updateStatus(_currentStatus.copyWith(state: PlaybackState.paused));
      } catch (e) {
        if (_disposed || _playGeneration != myGen) return;
        final errStr = e.toString().toLowerCase();
        String errorCode = 'error:playback_failed';
        if (errStr.contains('format') || errStr.contains('codec')) {
          errorCode = 'error:unsupported_format';
        } else if (errStr.contains('access') || errStr.contains('not found') || errStr.contains('no such file')) {
          errorCode = 'error:file_inaccessible';
        }
        _updateStatus(_currentStatus.copyWith(state: PlaybackState.error, error: errorCode));
      }
      return;
    }

    // _attemptActive must be true so the bridge listener's _valid() check
    // passes and PlayerState.cued / unStarted events are processed.
    // Without this the IFrame events are silently discarded and the video
    // never resolves to PlaybackState.paused after cueVideoById().
    _attemptActive = true;
    _intentRevision++;
    _intendedState = PlaybackState.paused;
    _playGeneration++;
    final myGen = _playGeneration;

    if (!_currentStatus.isIFrameMode) {
      try {
        await _player?.stop();
      } catch (_) {}
    }

    final ss =
        position?.inMilliseconds != null
            ? position!.inMilliseconds / 1000.0
            : null;
    _currentStartSeconds = ss;

    _updateStatus(
      _currentStatus.copyWith(
        track: track,
        state: PlaybackState.preparing,
        isIFrameMode: true,
        // Set hasVideo: true for online tracks, matching what play() does.
        // This ensures a restored/paused YouTube track immediately signals
        // that a video surface should be presented, so the Player Screen
        // can initialize the native window without waiting for Play to be pressed.
        hasVideo: true,
        // Set activeVideoId immediately so PlaybackView renders the YouTube
        // player widget before the IFrame fires its first event.
        activeVideoId: track.id,
      ),
    );

    // Initialize the IFrame controller + bridge listener on first use.
    // _enterIFrameMode also calls _load() at its end, but _load() will bail
    // immediately because _intendedState == paused (not eligible to auto-play),
    // so the side-effect is harmless — we just need the controller ready.
    if (_youtubeController == null) {
      await _enterIFrameMode(track.id, generation: myGen);
    }

    if (_disposed || myGen != _playGeneration) return;

    // Cue the video at the saved position without starting playback.
    // This fires PlayerState.cued / unStarted from the IFrame, which the
    // bridge listener maps to PlaybackState.paused (because _intendedState
    // == paused) and records the correct seek position.
    // We use cueVideoById — not _load() / loadVideoById — because the latter
    // requires _intendedState == playing and auto-starts the video.
    try {
      _diag('PREPARE cueVideoById gen=$myGen videoId=${track.id} ss=$ss');
      await _youtubeController!.cueVideoById(
        videoId: track.id,
        startSeconds: ss,
      );
    } catch (e) {
      debugPrint('MediaKitPlaybackEngine: prepare cueVideoById failed: $e');
    }
  }

  @override
  Future<void> play(
    PlaybackTrack track, {
    Duration startAt = Duration.zero,
  }) async {
    if (_disposed) return;
    _attemptActive = false;
    _intentRevision++;
    _intendedState = PlaybackState.playing;
    _playGeneration++;
    final myGen = _playGeneration;

    debugPrint(
      'ENGINE: play called for track ${track.id} (gen: $myGen, startAt: $startAt)',
    );

    String testVideoId = track.id;

    // 1. Cleanup previous state but keep IFrame controller if possible
    _watchdogTimer?.cancel();
    if (!_currentStatus.isIFrameMode) {
      await _player?.stop();
    } else {
      // If already in IFrame mode, just stop the current video
      try {
        await _youtubeController?.pauseVideo().timeout(
          const Duration(seconds: 1),
        );
      } catch (e) {
        debugPrint('MediaKitPlaybackEngine: pauseVideo failed/timed out: $e');
      }
    }

    if (_disposed || myGen != _playGeneration) return;
    _attemptActive = true;
    _recoveryUsed = false;
    _ready = false;
    _latePauseGeneration = null;

    if (track.isLocal || track.sourceType == PlaybackSourceType.networkStream) {
      final uri = track.isLocal ? track.localMediaUri : track.networkMediaUri;
      if (uri == null) {
        _failAttempt(myGen, 'Media URI is missing for ${track.id}');
        return;
      }
      
      _updateStatus(
        _currentStatus.copyWith(
          track: track,
          state: PlaybackState.preparing,
          clearError: true,
          activeVideoId: testVideoId,
          hasVideo: track.isVideo,
          isIFrameMode: false,
          generation: myGen,
          isLive: track.liveStatus == PlaybackLiveStatus.live,
          isSeekable: track.liveStatus != PlaybackLiveStatus.live,
          position: Duration.zero,
          duration: Duration.zero,
          buffered: Duration.zero,
        ),
      );
      
      try {
        await _player!.open(Media(uri));
        if (_disposed || _playGeneration != myGen) return;
        
        if (startAt > Duration.zero) {
          await _player!.seek(startAt);
          if (_disposed || _playGeneration != myGen) return;
        }
      } catch (e) {
        if (_valid(myGen)) {
          final errStr = e.toString().toLowerCase();
          String errorCode = 'error:playback_failed';
          if (errStr.contains('format') || errStr.contains('codec')) {
            errorCode = 'error:unsupported_format';
          } else if (errStr.contains('access') || errStr.contains('not found') || errStr.contains('no such file')) {
            errorCode = 'error:file_inaccessible';
          }
          _failAttempt(myGen, errorCode);
        }
      }
      return;
    }

    _updateStatus(
      _currentStatus.copyWith(
        track: track,
        state: PlaybackState.preparing,
        clearError: true,
        activeVideoId: testVideoId,
        hasVideo: true,
        // Pivot immediately so the UI builds the platform view
        isIFrameMode: true,
        generation: myGen,
      ),
    );

    // 2. Initialize or reuse IFrame controller
    final ss =
        startAt.inMilliseconds > 0 ? startAt.inMilliseconds / 1000.0 : null;
    _currentStartSeconds = ss;
    await _enterIFrameMode(testVideoId, generation: myGen, startSeconds: ss);
  }

  Future<void> _enterIFrameMode(
    String videoId, {
    required int generation,
    double? startSeconds,
  }) async {
    // Initialization prepares media without implicitly starting playback.
    if (_youtubeController == null) {
      debugPrint(
        'MediaKitPlaybackEngine: [INIT] Creating YoutubePlayerController (persistent singleton)',
      );

      if (youtubeControllerFactory != null) {
        _youtubeController = youtubeControllerFactory!(
          videoId,
          const yt.YoutubePlayerParams(
            showControls: false,
            showFullscreenButton: false,
            mute: false,
            loop: false,
            strictRelatedVideos: true,
            origin: 'https://ppplayer.com',
            pointerEvents: yt.PointerEvents.none,
          ),
        );
      } else {
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
      }

      // ignore: invalid_use_of_internal_member
      _youtubeController!.webViewController.addJavaScriptChannel(
        'NativeLog',
        onMessageReceived: (msg) {
          debugPrint('MediaKitPlaybackEngine: [NativeLog] ${msg.message}');
        },
      );

      // Persistent generation-aware listener. This is the ONLY place
      // that calls playVideo() in response to a 'cued' state.
      _subscriptions.add(
        _youtubeController!.listen((ytState) {
          if (!_currentStatus.isIFrameMode || !_valid(_playGeneration)) return;
          final eventId = ytState.metaData.videoId;
          if (eventId.isNotEmpty && eventId != _currentStatus.track?.id) return;
          // Missing IDs and same-video retries remain ambiguous: metadata and
          // the mutable generation cannot establish event provenance.

          final gen = _playGeneration; // capture
          _diag(
            'BRIDGE gen=$gen iframeState=${ytState.playerState} '
            'engineState=${_currentStatus.state} intended=$_intendedState '
            'activityStopped=$isActivityStopped',
          );

          if (ytState.hasError && ytState.error != yt.YoutubeError.none) {
            debugPrint(
              'MediaKitPlaybackEngine: [ERROR] YouTube IFrame error: ${ytState.error}',
            );

            final eventVideoId = ytState.metaData.videoId;
            final currentVideoId = _currentStatus.track?.id;

            if (eventVideoId.isNotEmpty &&
                currentVideoId != null &&
                eventVideoId != currentVideoId) {
              debugPrint(
                'MediaKitPlaybackEngine: [BRIDGE] Ignoring stale error for $eventVideoId (current: $currentVideoId).',
              );
              return;
            }

            if (ytState.error == yt.YoutubeError.videoNotFound ||
                ytState.error == yt.YoutubeError.notEmbeddable ||
                ytState.error == yt.YoutubeError.cannotFindVideo ||
                ytState.error == yt.YoutubeError.sameAsNotEmbeddable ||
                ytState.error == yt.YoutubeError.invalidParam) {
              _failAttempt(gen, 'unavailable_media:${ytState.error.name}');
              return; // Stop processing state on fatal error
            }
            // Transient errors are ignored
          }

          switch (ytState.playerState) {
            case yt.PlayerState.cued:
            case yt.PlayerState.unStarted:
              _ready = true;
              // Repeated readiness events must not restart the start deadline.
              if (_lastPlayedGeneration != gen) {
                if (_intendedState == PlaybackState.paused) {
                  // prepare() was used (startup restore). Resolve to paused state
                  // with the saved start position — do NOT call playVideo().
                  final savedPos =
                      _currentStartSeconds != null
                          ? Duration(
                              milliseconds:
                                  (_currentStartSeconds! * 1000).toInt(),
                            )
                          : Duration.zero;
                  _updateStatus(
                    _currentStatus.copyWith(
                      state: PlaybackState.paused,
                      position: savedPos,
                      activeVideoId: _currentStatus.track?.id,
                    ),
                  );
                } else {
                  unawaited(_dispatchIFramePlay(gen, ytState.playerState.name));
                }
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
            // A cued video is ready-but-paused. Without this mapping the engine
            // stays stuck in PlaybackState.preparing after a prepare() call.
            yt.PlayerState.cued => PlaybackState.paused,
            _ => _currentStatus.state,
          };

          if (newState == PlaybackState.ended) {
            final eventVideoId = ytState.metaData.videoId;
            final currentVideoId = _currentStatus.track?.id;

            if (eventVideoId.isNotEmpty &&
                currentVideoId != null &&
                eventVideoId != currentVideoId) {
              debugPrint(
                'MediaKitPlaybackEngine: [BRIDGE] Ignoring stale ended event for $eventVideoId (current: $currentVideoId).',
              );
              return;
            }

            _eventController.add(
              PlaybackEvent(
                type: PlaybackEventType.trackEnded,
                track: _currentStatus.track,
                generation: gen,
              ),
            );
          }

          if ((newState == PlaybackState.playing ||
                  newState == PlaybackState.buffering) &&
              _intendedState == PlaybackState.paused) {
            if (!BackgroundPlaybackExperiment.enabled) {
              // [BASELINE] Auto-recovery: if IFrame reports playing while we intend paused,
              // force a pause command to honour user intent.
              _diag(
                'BRIDGE SPURIOUS-PLAY: intendedState=paused. [BASELINE] forcing pauseVideo().',
              );
              unawaited(
                _youtubeController?.pauseVideo().catchError((Object error) {
                  _diag('Corrective pause failed: $error');
                }),
              );
              return;
            } else {
              // [EXPERIMENT] Observe only — do not auto-recover. Let the IFrame play
              // so we can measure whether it actually sustains playback in background.
              _diag(
                'BRIDGE SPURIOUS-PLAY: intendedState=paused. [EXPERIMENT] OBSERVE ONLY — '
                'NOT forcing pauseVideo(). IFrame state will be recorded.',
              );
            }
          }

          if (ytState.playerState == yt.PlayerState.paused &&
              _intendedState == PlaybackState.paused) {
            // The renderer acknowledged this pause before any resume; there is
            // no outstanding pause event to reconcile on a later focus loss.
            _latePauseGeneration = null;
          }
          if (newState == PlaybackState.paused &&
              _intendedState == PlaybackState.playing) {
            // One reconciliation for an outstanding pause command, never a replay
            // loop. Future completion is deliberately unrelated to renderer events.
            if (ytState.playerState == yt.PlayerState.paused &&
                _latePauseGeneration == gen) {
              _latePauseGeneration = null;
              unawaited(_dispatchIFramePlay(gen, 'late-pause'));
            }
            if (ytState.playerState == yt.PlayerState.unStarted) return;
          }
          if (newState == PlaybackState.playing) {
            _watchdogTimer?.cancel();
            // Record the confirmed position for this generation so the watchdog
            // retries from here rather than from the original start offset.
            _confirmedPositionGeneration = gen;
          }

          if (newState != _currentStatus.state) {
            _updateStatus(_currentStatus.copyWith(state: newState));
          }
        }),
      );
    }

    if (generation != _playGeneration) {
      debugPrint(
        'MediaKitPlaybackEngine: Stale enterIFrameMode (gen: $generation). Aborting.',
      );
      return;
    }

    _updateStatus(_currentStatus);
    _armWatchdog(generation, loading: true);
    await _load(generation, videoId, startSeconds: startSeconds);
  }

  Future<void> _load(
    int generation,
    String videoId, {
    double? startSeconds,
  }) async {
    if (!_valid(generation)) return;
    bool eligible() =>
        _valid(generation) &&
        _intendedState == PlaybackState.playing &&
        (BackgroundPlaybackExperiment.enabled || !isActivityStopped);
    try {
      // We must use loadVideoById because cueVideoById throws YoutubeError.unknown
      // for music videos due to YouTube API restrictions.
      // However, loadVideoById starts playback automatically, bypassing our playVideo() guards.
      // Therefore, we must enforce the guard BEFORE loading.
      if (!eligible()) {
        // Not eligible to auto-play. If this is a prepare/restore call
        // (_intendedState == paused), return silently — cueVideoById() will
        // fire the cued event and the bridge listener will set PlaybackState.paused
        // with the correct position. Emitting paused here would clear the restore
        // guard in PlayerNotifier before the video is actually cued.
        if (_intendedState != PlaybackState.paused) {
          _diag('ENGINE _load() BLOCKED: not eligible to play.');
          _updateStatus(_currentStatus.copyWith(state: PlaybackState.paused));
        } else {
          _diag('ENGINE _load() BLOCKED (prepare path): skipping spurious paused emit.');
        }
        return;
      }
      await _youtubeController!.loadVideoById(
        videoId: videoId,
        startSeconds: startSeconds,
      );
    } catch (error) {
      _failAttempt(generation, 'YouTube loading failed: $error');
    }
  }

  @override
  Future<void> pause({
    String caller = 'user',
    bool failOnTimeout = false,
  }) async {
    if (_currentStatus.state == PlaybackState.paused ||
        _currentStatus.state == PlaybackState.idle) {
      return;
    }

    _diag(
      'ENGINE pause() caller=$caller failOnTimeout=$failOnTimeout '
      'intendedWas=$_intendedState gen=$_playGeneration',
    );
    _intentRevision++;
    _watchdogTimer?.cancel();
    _intendedState = PlaybackState.paused;

    final pauseAck = statusStream
        .firstWhere(
          (s) =>
              s.state == PlaybackState.paused || s.state == PlaybackState.idle,
        )
        .timeout(const Duration(seconds: 2));

    if (!failOnTimeout) {
      // Optimistically update the state so the UI and OS MediaSession reflect
      // the paused state immediately, rather than waiting for the JS bridge
      // (which may be suspended by the OS and never fire the event).
      _updateStatus(_currentStatus.copyWith(state: PlaybackState.paused));
    }

    if (_currentStatus.isIFrameMode) {
      _latePauseGeneration = _playGeneration;
      try {
        await _youtubeController?.pauseVideo().timeout(
          const Duration(seconds: 2),
        );
      } catch (e) {
        debugPrint('MediaKitPlaybackEngine: pauseVideo failed/timed out: $e');
        if (failOnTimeout) {
          throw TimeoutException(
            'Source pause failed (IFrame error)',
            const Duration(seconds: 2),
          );
        }
        if (_intendedState == PlaybackState.paused) {
          _updateStatus(_currentStatus.copyWith(state: PlaybackState.paused));
        }
        return;
      }
    } else {
      await _player?.pause();
    }

    try {
      await pauseAck;
    } catch (e) {
      // TimeoutException: ack didn't arrive within 2 s.
      // StateError ("No element"): engine disposed while pause was pending.
      debugPrint(
        'MediaKit: pause ack timeout/close (caller=$caller, failOnTimeout=$failOnTimeout): $e',
      );
      if (failOnTimeout && e is TimeoutException) {
        throw TimeoutException(
          'Source pause unconfirmed by IFrame',
          const Duration(seconds: 2),
        );
      }
      _updateStatus(_currentStatus.copyWith(state: PlaybackState.paused));
    }
  }

  Future<void> _dispatchIFramePlay(
    int expectedGeneration,
    String source,
  ) async {
    bool eligible() =>
        _valid(expectedGeneration) &&
        _intendedState == PlaybackState.playing &&
        (BackgroundPlaybackExperiment.enabled || !isActivityStopped);
    if (!eligible()) {
      if (_valid(expectedGeneration) && isActivityStopped) {
        _watchdogTimer?.cancel();
        _intendedState = PlaybackState.paused;
        _updateStatus(_currentStatus.copyWith(state: PlaybackState.paused));
      }
      return;
    }
    final revision = _intentRevision;
    _lastPlayedGeneration = expectedGeneration;
    try {
      await _youtubeController!.setVolume(
        (_currentStatus.volume * 100).toInt(),
      );
      if (!eligible() || revision != _intentRevision) return;
      _diag('DISPATCH playVideo gen=$expectedGeneration source=$source');
      final command = _youtubeController!.playVideo();
      _armWatchdog(expectedGeneration, loading: false);
      await command;
    } catch (error) {
      if (eligible() && revision == _intentRevision) {
        _failAttempt(
          expectedGeneration,
          'YouTube playback dispatch failed: $error',
        );
      }
    }
  }

  @override
  Future<void> resume() async {
    _intentRevision++;
    _diag(
      'ENGINE resume() iframeMode=${_currentStatus.isIFrameMode} '
      'activityStopped=$isActivityStopped gen=$_playGeneration',
    );

    // --- Activity-stopped guard (baseline only) ---
    if (!BackgroundPlaybackExperiment.enabled &&
        _currentStatus.isIFrameMode &&
        isActivityStopped) {
      _diag(
        'ENGINE resume() BLOCKED [BASELINE guard]: activity stopped. '
        'Setting intendedState=paused, emitting paused.',
      );
      _intendedState = PlaybackState.paused;
      _updateStatus(_currentStatus.copyWith(state: PlaybackState.paused));
      return;
    }

    if (BackgroundPlaybackExperiment.enabled &&
        _currentStatus.isIFrameMode &&
        isActivityStopped) {
      _diag(
        'ENGINE resume() PASS-THROUGH [EXPERIMENT]: activity stopped but guard disabled.',
      );
    }
    // --- End activity-stopped guard ---

    _intendedState = PlaybackState.playing;
    if (_currentStatus.isIFrameMode) {
      if (_ready) {
        // Ensure _attemptActive is set so _valid() passes inside
        // _dispatchIFramePlay. prepare() already sets it to true, but
        // an intermediate pause() call can clear it; reassert here.
        _attemptActive = true;
        await _dispatchIFramePlay(_playGeneration, 'resume');
      } else if (_valid(_playGeneration)) {
        _armWatchdog(_playGeneration, loading: true);
        await _load(
          _playGeneration,
          _currentStatus.track!.id,
          startSeconds: _currentStartSeconds,
        );
      }
    } else {
      await _player?.play();
    }
  }

  @override
  Future<void> stop() async {
    _playGeneration++;
    _intentRevision++;
    _attemptActive = false;
    _latePauseGeneration = null;
    _watchdogTimer?.cancel();
    _stopIFramePolling();
    _intendedState = PlaybackState.paused;

    // Optimistically update the state before awaiting, because if the app is
    // suspended in the background, the JS bridge will hang and timeout after 25s.
    _updateStatus(
      _currentStatus.copyWith(
        state: PlaybackState.idle,
        track: null,
        activeVideoId: null,
      ),
    );

    if (_currentStatus.isIFrameMode) {
      try {
        await _youtubeController?.pauseVideo().timeout(
          const Duration(seconds: 2),
        );
      } catch (e) {
        debugPrint(
          'MediaKitPlaybackEngine: stop() pauseVideo threw/timed out: $e',
        );
      }
      // We keep the controller alive to avoid recreating the platform view
    } else {
      await _player?.stop();
    }
  }

  @override
  Future<void> seekTo(Duration position) async {
    final generation = _playGeneration;
    final revision = _intentRevision;
    final wasPlaying = _currentStatus.state == PlaybackState.playing;

    if (_currentStatus.isIFrameMode) {
      if (!_valid(generation)) {
        return;
      }
      if (!_ready) {
        // If not ready, we must load to prepare the offset.
        await _load(
          generation,
          _currentStatus.track!.id,
          startSeconds: position.inMilliseconds / 1000,
        );
      } else {
        await _youtubeController?.seekTo(
          seconds: position.inMilliseconds / 1000.0,
          allowSeekAhead: true,
        );
        // Seeking a paused video can start it implicitly. Force pause if ineligible.
        if (_intendedState != PlaybackState.playing) {
          unawaited(_youtubeController?.pauseVideo());
        }
      }

      if (_valid(generation)) {
        _currentStartSeconds = position.inMilliseconds / 1000.0;
        _updateStatus(_currentStatus.copyWith(position: position));
      }
      if (wasPlaying && revision == _intentRevision) {
        await _dispatchIFramePlay(generation, 'seek');
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
  bool get supportsSpeed => true;

  /// True only when MediaKit is rendering the video surface (not YouTube iframe).
  /// Derived from the live status so it updates when switching between local
  /// and YouTube mid-session.
  @override
  bool get supportsVideoFitMode =>
      _currentStatus.hasVideo && !_currentStatus.isIFrameMode;

  @override
  Future<void> setSpeed(double speed) async {
    if (_currentStatus.isIFrameMode) {
      await _youtubeController?.setPlaybackRate(speed);
    } else {
      await _player?.setRate(speed);
    }
  }

  @override
  Future<void> setSubtitleTrack(String? uri) async {
    if (_currentStatus.isIFrameMode) return;
    if (uri == null) {
      await _player?.setSubtitleTrack(SubtitleTrack.no());
    } else {
      await _player?.setSubtitleTrack(SubtitleTrack.uri(uri));
    }
  }

  void _updateStatus(PlaybackStatus status) {
    if (_disposed) return;
    // Only log on meaningful state transitions, not position-polling noise
    if (status.state != _currentStatus.state) {
      _diag(
        'STATE ${_currentStatus.state} → ${status.state} '
        'gen=$_playGeneration intended=$_intendedState '
        'activityStopped=$isActivityStopped',
      );
    }
    _currentStatus = status.copyWith(generation: _playGeneration);
    _statusController.add(_currentStatus);

    // Manage IFrame position polling.
    // The timer is kept running when the status becomes playing,
    // and cancelled when the state leaves playing.
    // The synthetic end-of-track detection inside the timer self-cancels.
    if (status.isIFrameMode && status.state == PlaybackState.playing) {
      if (_iframePositionTimer == null) {
        _startIFramePolling();
      }
    } else if (status.state != PlaybackState.playing) {
      _stopIFramePolling();
    }
  }

  // Tracks consecutive ticks where getCurrentTime returned the same frozen value.
  // A position that hasn't advanced for ~2 seconds while >= duration is treated
  // as a synthetic end-of-track signal to advance to the next song.
  double _lastPolledPosition = -1;
  int _frozenPositionTicks = 0;
  static const int _frozenTicksThreshold = 4; // 4 × 500ms = 2 s

  void _startIFramePolling() {
    final generation = _playGeneration;
    _lastPolledPosition = -1;
    _frozenPositionTicks = 0;
    _iframePositionTimer?.cancel();
    _iframePositionTimer = Timer.periodic(const Duration(milliseconds: 500), (
      timer,
    ) async {
      if (_youtubeController == null || !_currentStatus.isIFrameMode) {
        timer.cancel();
        return;
      }

      double currentTime;
      double duration;
      try {
        // Each JS bridge call is individually guarded so a single hung call
        // does not block the timer indefinitely.
        currentTime = await _youtubeController!.currentTime.timeout(
          const Duration(milliseconds: 400),
        );
        duration = await _youtubeController!.duration.timeout(
          const Duration(milliseconds: 400),
        );
      } catch (e) {
        // Bridge call timed out or threw — skip this tick.
        return;
      }

      // ── Synthetic end-of-track detection ────────────────────────────────
      // Once macOS App Nap suspends requestAnimationFrame, YouTube's 'ended'
      // event can never fire. We detect completion by observing:
      //  1. position is within 0.5 s of duration (near-end zone)
      //  2. position hasn't advanced for _frozenTicksThreshold ticks (2 s)
      //  3. the engine still INTENDS to be playing (avoids false skip when
      //     the user deliberately pauses at the very end of a track)
      // This check runs independently of _valid()/_attemptActive so it fires
      // even after the watchdog has killed the attempt flag.
      if (duration > 0 &&
          currentTime >= duration - 0.5 &&
          _intendedState == PlaybackState.playing) {
        final positionFrozen = (currentTime - _lastPolledPosition).abs() < 0.01;
        if (positionFrozen) {
          _frozenPositionTicks++;
        } else {
          _frozenPositionTicks = 0;
        }
        _lastPolledPosition = currentTime;

        if (_frozenPositionTicks >= _frozenTicksThreshold) {
          _diag(
            'RENDERER gen=$generation synthetic end-of-track: '
            'pos=$currentTime dur=$duration frozen=$_frozenPositionTicks ticks',
          );
          timer.cancel();
          _iframePositionTimer = null;
          if (!_disposed) {
            _eventController.add(
              PlaybackEvent(
                type: PlaybackEventType.trackEnded,
                track: _currentStatus.track,
                generation: _playGeneration,
              ),
            );
          }
          _updateStatus(_currentStatus.copyWith(state: PlaybackState.ended));
          return;
        }
      } else {
        _frozenPositionTicks = 0;
        _lastPolledPosition = currentTime;
      }
      // ── End synthetic end-of-track ───────────────────────────────────────

      if (!_valid(generation)) return;

      if (_currentStatus.state == PlaybackState.playing) {
        _diag(
          'RENDERER gen=$generation position=$currentTime duration=$duration',
        );

        final positionDuration = Duration(
          milliseconds: (currentTime * 1000).toInt(),
        );
        // Update the confirmed position for watchdog recovery —
        // validated by generation so stale polling cannot overwrite a newer attempt.
        if (_confirmedPositionGeneration == generation) {
          _confirmedPlaybackPosition = positionDuration;
        }
        _updateStatus(
          _currentStatus.copyWith(
            position: positionDuration,
            duration: Duration(milliseconds: (duration * 1000).toInt()),
          ),
        );
      }
    });
  }

  void _stopIFramePolling() {
    _iframePositionTimer?.cancel();
    _iframePositionTimer = null;
  }

  @override
  void dispose() {
    if (_disposed) return;
    _disposed = true;
    _attemptActive = false;
    _playGeneration++;
    _watchdogTimer?.cancel();
    _iframePositionTimer?.cancel();
    // Cancel all stream subscriptions BEFORE disposing the player.
    // If subscriptions are still active when the native MPV object is freed,
    // a callback fires into a deleted object → SIGABRT in libmpv.
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    _subscriptions.clear();
    _player?.dispose();
    _youtubeController?.close();
    _statusController.close();
    _eventController.close();
  }
}
