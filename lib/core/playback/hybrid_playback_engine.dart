import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import 'package:pp_playback_engine/pp_playback_engine.dart';
import 'pip_handler.dart';

enum EngineOwner { foreground, background }

class HybridPlaybackEngine implements PlaybackController {
  final PlaybackController _foregroundEngine;
  final PlaybackController _backgroundEngine;

  EngineOwner _owner = EngineOwner.foreground;
  bool _isTransferring = false;
  int _handoffGeneration = 0;

  // True when a background handoff was requested but deferred because the app
  // was entering or already in PiP. Flushed when PiP exits while the activity
  // remains stopped.
  bool _backgroundHandoffDeferred = false;

  final _statusController = StreamController<PlaybackStatus>.broadcast();
  final _eventController = StreamController<PlaybackEvent>.broadcast();

  PlaybackStatus _currentStatus = const PlaybackStatus();
  PlaybackState _intendedState = PlaybackState.idle;
  PlaybackTrack? _currentTrack;
  PlaybackTrack? _prewarmedTrack; // track currently cued in the inactive engine
  bool _disposed = false;
  int _playGeneration = 0;
  int _lastCompletedGeneration = -1;
  Timer? _handoffTimeout;

  // Exposed for testing only.
  @visibleForTesting
  EngineOwner get owner => _owner;

  HybridPlaybackEngine({
    PlaybackController? foregroundEngine,
    PlaybackController? backgroundEngine,
  }) : _foregroundEngine = foregroundEngine ?? MediaKitPlaybackEngine(),
       _backgroundEngine = backgroundEngine ?? NativeServicePlaybackEngine() {
    _foregroundEngine.statusStream.listen((status) {
      _handleSubStatus(EngineOwner.foreground, status);
    });

    _foregroundEngine.eventStream.listen((event) {
      _handleSubEvent(EngineOwner.foreground, event);
    });

    _backgroundEngine.statusStream.listen((status) {
      _handleSubStatus(EngineOwner.background, status);
    });

    _backgroundEngine.eventStream.listen((event) {
      _handleSubEvent(EngineOwner.background, event);
    });

    PipHandler.addActivityStoppedListener(_onActivityStopped);
    PipHandler.addActivityStartedListener(_onActivityStarted);
    PipHandler.addPipModeListener(_onPipModeChanged);
    PipHandler.addPipEntryFailedListener(_onPipEntryFailed);
  }

  // ---------------------------------------------------------------------------
  // Lifecycle callbacks
  // ---------------------------------------------------------------------------

  void _onActivityStopped() {
    // Guard against the ordering race:
    //   onActivityStopped fires BEFORE onPipModeChanged(true)
    // Both isPipRequestPending (set before the native call) and isInPipMode
    // (confirmed by Android) can protect this window.
    if (PipHandler.isPipRequestPending || PipHandler.isInPipMode) {
      _backgroundHandoffDeferred = true;
      _log(
        'Background handoff deferred: '
        'pipRequestPending=${PipHandler.isPipRequestPending} '
        'inPip=${PipHandler.isInPipMode} '
        'owner=$_owner gen=$_handoffGeneration',
      );
      return;
    }
    _initiateHandoff(EngineOwner.background);
  }

  void _onActivityStarted() {
    _backgroundHandoffDeferred = false;
    // Only initiate if we are not already on foreground and not already
    // mid-transfer toward foreground, to avoid redundant handoffs.
    if (_owner == EngineOwner.foreground && !_isTransferring) return;
    _initiateHandoff(EngineOwner.foreground);
  }

  // SAFETY NET: onPipModeChanged(true) is the authoritative confirmation that
  // PiP is active. It also recovers from the race where onActivityStopped
  // arrived before this event and a background handoff slipped through.
  void _onPipModeChanged(bool inPip) {
    if (inPip) {
      // PiP is now confirmed active. Clear the deferred flag (already on
      // foreground, or about to recover to it).
      _backgroundHandoffDeferred = false;
      if (_owner != EngineOwner.foreground) {
        _log(
          'SAFETY NET: PiP confirmed active but owner=$_owner; '
          'recovering to foreground. gen=$_handoffGeneration',
        );
        _initiateHandoff(EngineOwner.foreground);
      } else {
        _log(
          'PiP confirmed active; owner already foreground. gen=$_handoffGeneration',
        );
      }
    } else {
      // PiP ended. The correct action depends solely on whether the Activity
      // is currently stopped — not on the deferred flag, which may be stale.
      //
      // PiP false + Activity stopped  → background (user dismissed PiP window)
      // PiP false + Activity visible  → foreground (user expanded PiP; already owner)
      //
      // Snapshot isActivityStopped before clearing the deferred flag so the
      // decision is based on current state rather than a potentially stale bool.
      final shouldBackground = PipHandler.isActivityStopped;
      _backgroundHandoffDeferred = false;

      if (shouldBackground) {
        _log(
          'PiP exited while activity stopped; initiating background handoff. '
          'gen=$_handoffGeneration',
        );
        _initiateHandoff(EngineOwner.background);
      }
      // If activity is running (user expanded PiP → fullscreen), foreground
      // is already owner; nothing to do.
    }
  }

  // PiP entry failed — clear deferred flag and, if the activity is already
  // stopped, do the background handoff that was deferred unnecessarily.
  void _onPipEntryFailed() {
    _backgroundHandoffDeferred = false;
    _log('PiP entry failed. activityStopped=${PipHandler.isActivityStopped}');
    if (PipHandler.isActivityStopped) {
      _initiateHandoff(EngineOwner.background);
    }
  }

  void _updateStatus(PlaybackStatus status) {
    if (_disposed) return;
    _currentStatus = status;
    _statusController.add(status);
  }

  void _handleSubStatus(EngineOwner source, PlaybackStatus status) {
    if (source != _owner) {
      if (status.state == PlaybackState.playing) {
        _log(
          'Containment: Inactive engine $source emitted playing, pausing it.',
        );
        final engine =
            source == EngineOwner.foreground
                ? _foregroundEngine
                : _backgroundEngine;
        engine.pause(caller: 'containment');
      }
      return;
    }
    if (_isTransferring) return;
    // Route completion through unified handler; don't let raw 'ended' propagate.
    if (status.state == PlaybackState.ended) {
      _handleTrackCompletion(source, status.track, status.generation);
      return;
    }
    _updateStatus(status);
  }

  void _handleSubEvent(EngineOwner source, PlaybackEvent event) {
    if (event.type == PlaybackEventType.trackEnded) {
      // Route through unified handler — deduplication guards against both
      // the status path (background) and event path (foreground) firing.
      _handleTrackCompletion(source, event.track, event.generation);
      return;
    }
    if (source == _owner) {
      if (_isTransferring) return;
      if (!_disposed) _eventController.add(event);
    }
  }

  /// Single authority for track-completion logic.
  /// Validates: active owner, track identity, and generation deduplication.
  void _handleTrackCompletion(
    EngineOwner source,
    PlaybackTrack? completedTrack,
    int? generation,
  ) {
    if (source != _owner) return;
    if (completedTrack == null || completedTrack.id != _currentTrack?.id) {
      _log(
        'Completion rejected: track mismatch '
        '(completed=${completedTrack?.id}, current=${_currentTrack?.id})',
      );
      return;
    }
    final expectedGen =
        source == EngineOwner.foreground
            ? _activeForegroundGeneration
            : _activeBackgroundGeneration;
    if (generation != null &&
        expectedGen != null &&
        generation != expectedGen) {
      _log(
        'Completion rejected: child generation mismatch (completed=$generation, expected=$expectedGen)',
      );
      return;
    }
    if (_lastCompletedGeneration == _playGeneration) {
      _log('Completion rejected: duplicate for generation $_playGeneration');
      return;
    }
    if (_isTransferring) {
      _log(
        'Completion during transfer — advancing generation and passing through.',
      );
      _handoffGeneration++;
      _isTransferring = false;
    }
    _lastCompletedGeneration = _playGeneration;
    _log('Track completed: ${completedTrack.id} (gen: $_playGeneration)');
    if (!_disposed) {
      _eventController.add(
        PlaybackEvent(
          type: PlaybackEventType.trackEnded,
          track: completedTrack,
        ),
      );
      _updateStatus(_currentStatus.copyWith(state: PlaybackState.ended));
    }
  }

  void _log(String msg) {
    final time = DateTime.now().toIso8601String().substring(11, 23);
    debugPrint('$time [PipDebug][ENGINE] $msg');
  }

  PlaybackController get _activeEngine =>
      _owner == EngineOwner.foreground ? _foregroundEngine : _backgroundEngine;
  PlaybackController get _inactiveEngine =>
      _owner == EngineOwner.foreground ? _backgroundEngine : _foregroundEngine;

  int? _activeForegroundGeneration;
  int? _activeBackgroundGeneration;

  Future<void> _initiateHandoff(EngineOwner targetOwner) async {
    if (_owner == targetOwner) return;
    if (_disposed) return;
    if (_currentTrack == null) return;
    if (_currentTrack!.isLocal) return;

    _handoffGeneration++;
    final myGen = _handoffGeneration;
    final myPlayGen = _playGeneration;
    final myTrackId = _currentTrack!.id;

    _log(
      'event=handoff_requested '
      'target=$targetOwner ownerBefore=$_owner '
      'inPip=${PipHandler.isInPipMode} '
      'pipRequestPending=${PipHandler.isPipRequestPending} '
      'activityStopped=${PipHandler.isActivityStopped} '
      'deferred=$_backgroundHandoffDeferred '
      'gen=$_handoffGeneration '
      'fg=${_foregroundEngine.currentStatus.state.name} '
      'bg=${_backgroundEngine.currentStatus.state.name} '
      'pos=${_activeEngine.currentStatus.position.inMilliseconds}ms',
    );

    _isTransferring = true;
    _owner = targetOwner;

    final sourceEngine = _inactiveEngine;
    final destEngine = _activeEngine;

    try {
      // Step 1: Pause source and wait for CONFIRMED acknowledgment.
      // failOnTimeout=true: a timeout throws instead of silently faking paused state.
      // If source cannot confirm silence, we cannot safely start the destination.
      try {
        await sourceEngine.pause(caller: 'handoff', failOnTimeout: true);

      } on TimeoutException catch (e) {
        _log('Handoff ABORTED: source pause unconfirmed — $e');
        // Roll back owner; destination was never started, so no audio overlap.
        _owner =
            targetOwner == EngineOwner.foreground
                ? EngineOwner.background
                : EngineOwner.foreground;
        _isTransferring = false;
        return;
      }

      if (_disposed || _handoffGeneration != myGen) return;

      // Step 2: Capture position AFTER source confirms pause — this is the
      // exact timestamp at which audio stopped, giving the tightest position.
      final pos = sourceEngine.currentStatus.position;
      _prewarmedTrack = null;

      // Step 3: Re-validate generation, track identity, and user intent.
      // A newer play() or track-change during the pause await must win.
      if (_currentTrack?.id != myTrackId) {
        _log('Handoff ABORTED: track changed during pause wait');
        _isTransferring = false;
        return;
      }

      if (_intendedState == PlaybackState.playing) {
        _log('Handoff: play(startAt: $pos) on $targetOwner');

        // Step 4: Register the "destination playing" listener BEFORE issuing
        // play() to avoid missing a fast state-change event.
        final playingFuture = destEngine.statusStream
            .firstWhere((s) => s.state == PlaybackState.playing)
            .timeout(const Duration(seconds: 5))
            .catchError((_) => const PlaybackStatus());

        await destEngine.play(_currentTrack!, startAt: pos);

        if (_disposed || _handoffGeneration != myGen) return;
        await destEngine.setVolume(_currentStatus.volume);

        // Step 5: Wait for destination confirmation via the pre-registered future.
        if (destEngine.currentStatus.state != PlaybackState.playing) {
          try {
            final status = await playingFuture;
            if (status.state == PlaybackState.playing) {
              if (targetOwner == EngineOwner.foreground) {
                _activeForegroundGeneration = status.generation;
              } else {
                _activeBackgroundGeneration = status.generation;
              }
            }
          } catch (_) {
            _log('Timeout waiting for destination to play');
            if (_handoffGeneration == myGen) {
              _handoffGeneration++;
              _isTransferring = false;
              // Guard rollback — only update intent if this specific
              // failed transfer is still current (no newer command arrived).
              if (_playGeneration == myPlayGen &&
                  _intendedState == PlaybackState.playing) {
                _intendedState = PlaybackState.paused;
                _updateStatus(
                  _currentStatus.copyWith(state: PlaybackState.paused),
                );
              }
            }
            try {
              await destEngine
                  .pause(caller: 'timeout_cleanup')
                  .timeout(const Duration(seconds: 2));
            } catch (_) {
              _log('Failed to pause destination during timeout cleanup');
            }
            return;
          }
        } else {
          if (targetOwner == EngineOwner.foreground) {
            _activeForegroundGeneration = destEngine.currentStatus.generation;
          } else {
            _activeBackgroundGeneration = destEngine.currentStatus.generation;
          }
        }
      } else {
        // User paused/stopped — source is already paused; set volume on destination.
        await destEngine.setVolume(_currentStatus.volume);
      }
    } catch (e) {
      _log('Handoff failed unexpectedly: $e');
    } finally {
      if (_handoffGeneration == myGen) {
        _isTransferring = false;
        _log('Handoff complete');
        _updateStatus(destEngine.currentStatus);
      }
    }
  }

  @override
  Stream<PlaybackStatus> get statusStream => _statusController.stream;

  @override
  Stream<PlaybackEvent> get eventStream => _eventController.stream;

  @override
  PlaybackStatus get currentStatus => _currentStatus;

  @override
  dynamic get renderer => _foregroundEngine.renderer;

  @override
  YoutubePlayerController? get youtubeController =>
      _foregroundEngine.youtubeController;

  @override
  Future<void> prepare(PlaybackTrack track, {Duration? position}) async {
    _playGeneration++;
    _currentTrack = track;
    _intendedState = PlaybackState.paused;
    await _activeEngine.prepare(track, position: position);
  }

  @override
  Future<void> play(
    PlaybackTrack track, {
    Duration startAt = Duration.zero,
  }) async {
    _playGeneration++;
    _handoffGeneration++;
    _isTransferring = false;
    _currentTrack = track;
    _prewarmedTrack = null; // new track supersedes any prior pre-warm
    _intendedState = PlaybackState.playing;
    _inactiveEngine.stop();

    final playingFuture = _activeEngine.statusStream
        .firstWhere((s) => s.state == PlaybackState.playing)
        .timeout(const Duration(seconds: 5))
        .catchError((_) => const PlaybackStatus());

    await _activeEngine.play(track, startAt: startAt);

    if (_activeEngine.currentStatus.state == PlaybackState.playing) {
      if (_owner == EngineOwner.foreground) {
        _activeForegroundGeneration = _activeEngine.currentStatus.generation;
      } else {
        _activeBackgroundGeneration = _activeEngine.currentStatus.generation;
      }
    } else {
      playingFuture.then((status) {
        if (status.state == PlaybackState.playing) {
          if (_owner == EngineOwner.foreground) {
            _activeForegroundGeneration = status.generation;
          } else {
            _activeBackgroundGeneration = status.generation;
          }
        }
      });
    }

    // Pre-warm the inactive engine so it has the video cued and ready.
    // This drastically reduces handoff latency on minimize.
    _prewarmInactiveEngine(track);
  }

  /// Silently cues the given track on the inactive engine so it is ready
  /// to take over on the next handoff without a full prepare round-trip.
  void _prewarmInactiveEngine(PlaybackTrack track) {
    final inactive = _inactiveEngine;
    _prewarmedTrack = track;
    // Use position=0 for pre-warm; actual position is seeked on handoff.
    inactive.prepare(track, position: Duration.zero).catchError((e) {
      _log('Pre-warm error (ignored): $e');
      if (_prewarmedTrack?.id == track.id) _prewarmedTrack = null;
    });
  }

  @override
  Future<void> pause({
    String caller = 'user',
    bool failOnTimeout = false,
  }) async {
    _intendedState = PlaybackState.paused;
    _updateStatus(_currentStatus.copyWith(state: PlaybackState.paused));
    await _activeEngine.pause(caller: caller, failOnTimeout: failOnTimeout);
  }

  @override
  Future<void> resume() async {
    _intendedState = PlaybackState.playing;
    _updateStatus(_currentStatus.copyWith(state: PlaybackState.playing));
    await _activeEngine.resume();
  }

  @override
  Future<void> stop() async {
    _handoffGeneration++;
    _isTransferring = false;
    _intendedState = PlaybackState.idle;
    _currentTrack = null;
    _updateStatus(
      _currentStatus.copyWith(
        state: PlaybackState.idle,
        track: null,
        activeVideoId: null,
      ),
    );
    await _foregroundEngine.stop();
    await _backgroundEngine.stop();
  }

  @override
  Future<void> seekTo(Duration position) async {
    _updateStatus(_currentStatus.copyWith(position: position));
    await _activeEngine.seekTo(position);
  }

  @override
  Future<void> setVolume(double volume) async {
    _updateStatus(_currentStatus.copyWith(volume: volume));
    await _foregroundEngine.setVolume(volume);
    await _backgroundEngine.setVolume(volume);
  }

  @override
  bool get supportsSpeed => _activeEngine.supportsSpeed;

  @override
  Future<void> setSpeed(double speed) async {
    await _foregroundEngine.setSpeed(speed);
    await _backgroundEngine.setSpeed(speed);
  }

  @override
  Future<void> setSubtitleTrack(String? uri) async {
    await _foregroundEngine.setSubtitleTrack(uri);
    await _backgroundEngine.setSubtitleTrack(uri);
  }

  @override
  void dispose() {
    _disposed = true;
    PipHandler.removeActivityStoppedListener(_onActivityStopped);
    PipHandler.removeActivityStartedListener(_onActivityStarted);
    PipHandler.removePipModeListener(_onPipModeChanged);
    PipHandler.removePipEntryFailedListener(_onPipEntryFailed);
    _handoffTimeout?.cancel();
    _foregroundEngine.dispose();
    _backgroundEngine.dispose();
    _statusController.close();
    _eventController.close();
  }
}
