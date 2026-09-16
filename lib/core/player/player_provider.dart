import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:convert';
import 'package:hive_ce/hive_ce.dart';
import '../models/track.dart';
import '../models/playback_queue.dart';
import '../models/resolved_video_candidate.dart';
import '../playback/playback_providers.dart';
import '../playback/pip_handler.dart';
import '../api/spotify_repository.dart';
import '../services/settings_provider.dart';

export '../models/track.dart' show Track;
export '../models/playback_queue.dart' show PlaybackQueue, RepeatMode;

class PlayerState {
  const PlayerState({
    this.playbackQueue = const PlaybackQueue(),
    this.isPlaying = false,
    this.videoId,
    this.isLoadingVideo = false,
    this.loadError,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.buffered = Duration.zero,
    this.volume = 1.0,
    this.isPipMode = false,
    this.isPipRequestPending = false,
  });

  final PlaybackQueue playbackQueue;
  final bool isPlaying;
  final String? videoId;
  final bool isLoadingVideo;
  final String? loadError;
  final Duration position;
  final Duration duration;
  final Duration buffered;
  final double volume;
  final bool isPipMode;
  final bool isPipRequestPending;

  // Shortcuts to avoid breaking UI that expects these on state
  List<Track> get queue => playbackQueue.tracks;
  int get currentIndex => playbackQueue.currentIndex;
  RepeatMode get repeatMode => playbackQueue.repeatMode;
  bool get isShuffled => playbackQueue.isShuffled;
  Track? get currentTrack => playbackQueue.currentTrack;

  PlayerState copyWith({
    PlaybackQueue? playbackQueue,
    bool? isPlaying,
    Object? videoId = _sentinel,
    bool? isLoadingVideo,
    Object? loadError = _sentinel,
    Duration? position,
    Duration? duration,
    Duration? buffered,
    double? volume,
    bool? isPipMode,
    bool? isPipRequestPending,
    bool clearLoadError = false,
  }) {
    return PlayerState(
      playbackQueue: playbackQueue ?? this.playbackQueue,
      isPlaying: isPlaying ?? this.isPlaying,
      videoId:
          identical(videoId, _sentinel) ? this.videoId : videoId as String?,
      isLoadingVideo: isLoadingVideo ?? this.isLoadingVideo,
      loadError:
          clearLoadError
              ? null
              : (identical(loadError, _sentinel)
                  ? this.loadError
                  : loadError as String?),
      position: position ?? this.position,
      duration: duration ?? this.duration,
      buffered: buffered ?? this.buffered,
      volume: volume ?? this.volume,
      isPipMode: isPipMode ?? this.isPipMode,
      isPipRequestPending: isPipRequestPending ?? this.isPipRequestPending,
    );
  }
}

const Object _sentinel = Object();

class PlayerNotifier extends Notifier<PlayerState> {
  int _playbackGeneration = 0;
  int _consecutiveTrackFailures = 0;
  List<ResolvedVideoCandidate> _currentCandidates = [];
  int _currentCandidateIndex = 0;
  bool _isRecovering = false;
  bool _skipDebounce = false;
  bool _lastPipEnabled = false;
  Timer? _saveTimer;
  bool _disposed = false;
  Future<void> _persistenceWork = Future.value();

  /// Allows shutdown/tests to wait for already started disk operations.
  Future<void> get persistenceSettled => _persistenceWork;
  bool _prefetchedNextTrackForCurrentLoad = false;

  bool _isFetchingAutoplay = false;
  final Set<String> _autoplaySeenTrackIds = {};

  /// True while the startup restore is cuing the saved track in the background.
  /// External play commands (e.g. from macOS media session) are ignored during
  /// this window to prevent auto-play on launch.
  bool _restoringState = false;
  Timer? _restoreTimeout;

  @override
  PlayerState build() {
    _persistenceWork = _initRestore();
    ref.onDispose(() {
      _disposed = true;
      _saveTimer?.cancel();
      _restoreTimeout?.cancel();
    });
    // Listen to the playback engine's status and sync it to our state
    ref.listen(playbackStatusProvider, (previous, next) {
      if (next is AsyncData<PlaybackStatus>) {
        final status = next.value;
        if (status.state == PlaybackState.ended) {
          if (!_skipDebounce) {
            _skipDebounce = true;
            skipNext();
            Future.delayed(
              const Duration(milliseconds: 1000),
              () => _skipDebounce = false,
            );
          }
        }
        _syncFromStatus(status);
      }
    });

    PipHandler.addPipModeListener((isPipMode) {
      state = state.copyWith(isPipMode: isPipMode);
    });

    PipHandler.addPipEntryRequestedListener(() {
      state = state.copyWith(isPipRequestPending: true);
    });

    PipHandler.addPipEntryFailedListener(() {
      state = state.copyWith(isPipRequestPending: false);
    });

    PipHandler.addActivityStoppedListener(() {
      final status = ref.read(playbackStatusProvider).value;
      final ts = DateTime.now().toIso8601String();
      debugPrint(
        '$ts PlayerNotifier: onActivityStopped '
        'isPlaying=${state.isPlaying} isIFrameMode=${status?.isIFrameMode} '
        'track=${state.currentTrack?.spotifyId}',
      );
      if (state.isPlaying && status?.isIFrameMode == true) {
        if (!BackgroundPlaybackExperiment.enabled &&
            defaultTargetPlatform != TargetPlatform.android) {
          debugPrint(
            '$ts PlayerNotifier: pausing via onActivityStopped (caller=lifecycle/lock-screen)',
          );
          _controller.pause(caller: 'onActivityStopped/lock-screen');
          state = state.copyWith(isPlaying: false);
        } else {
          debugPrint(
            '$ts PlayerNotifier: NOT pausing onActivityStopped (BackgroundPlaybackExperiment=${BackgroundPlaybackExperiment.enabled}, platform=$defaultTargetPlatform).',
          );
        }
      }
    });

    ref.listen(settingsProvider, (previous, next) {
      if (previous?.continuePlaybackInPip != next.continuePlaybackInPip) {
        PipHandler.setPipEnabled(next.continuePlaybackInPip && state.isPlaying);
      }
    });

    return const PlayerState();
  }

  void _syncFromStatus(PlaybackStatus status) {
    if (_disposed) return;
    debugPrint(
      '${DateTime.now().toIso8601String()} PLAYER status=${status.state}',
    );
    String? displayError = status.error;

    if (status.state == PlaybackState.error && status.error != null) {
      if (status.error!.startsWith('unavailable_media:') ||
          status.error!.startsWith('error:')) {
        _handleCandidateFailure();
        return;
      } else if (status.error!.startsWith('transient:')) {
        return; // Ignore transient errors
      }
    }

    if (status.state == PlaybackState.playing) {
      _consecutiveTrackFailures = 0;
      _isRecovering = false;
    }

    final isPlaying =
        status.state == PlaybackState.playing ||
        status.state == PlaybackState.buffering;
    final pipEnabled = ref.read(settingsProvider).continuePlaybackInPip;
    // Only call setPipEnabled when the desired state changes to avoid calling
    // setPictureInPictureParams during non-foreground states (causes Android
    // ensureValidPictureInPictureActivityParams to throw on Android 12+).
    final wantPip = pipEnabled && isPlaying;
    if (wantPip != _lastPipEnabled) {
      _lastPipEnabled = wantPip;
      PipHandler.setPipEnabled(wantPip);
    }

    // During 'preparing' the engine position/duration are always Duration.zero
    // (no live reading yet). Overwriting state with zeros would erase the saved
    // restore position and cause the wrong startAt on the next playTrack call.
    // Only propagate live timeline data once the engine is past the load phase.
    final hasLivePosition = status.state != PlaybackState.preparing;
    // Only overwrite the restored duration once the engine reports an actual
    // non-zero value. Right after cueVideoById() the IFrame emits
    // PlaybackState.paused with duration=0 (it hasn't read the track length
    // yet). Propagating that zero would overwrite the Hive-restored duration
    // and make the seekbar show 0% (progress = savedPosition / 0).
    final hasLiveDuration = hasLivePosition && status.duration > Duration.zero;
    state = state.copyWith(
      isPlaying: isPlaying,
      isLoadingVideo:
          status.state == PlaybackState.preparing ||
          status.state == PlaybackState.buffering,
      loadError: displayError,
      videoId: status.activeVideoId,
      position: hasLivePosition ? status.position : state.position,
      duration: hasLiveDuration ? status.duration : state.duration,
      buffered: hasLivePosition ? status.buffered : state.buffered,
    );
    _scheduleSaveState();

    // Restore complete: the IFrame fired the cued event and the engine is now
    // paused. Clear the restore guard so normal play commands are honoured.
    if (_restoringState && status.state == PlaybackState.paused) {
      debugPrint('PlayerNotifier: restore complete — guard cleared (engine paused)');
      _restoringState = false;
      _restoreTimeout?.cancel();
    }

    // Trigger prefetch once playback starts successfully
    if (status.state == PlaybackState.playing &&
        !_prefetchedNextTrackForCurrentLoad) {
      _prefetchedNextTrackForCurrentLoad = true;
      _prefetchNextTrack();
    }
  }

  void _prefetchNextTrack() {
    final queue = state.playbackQueue;
    final nextIdx = queue.currentIndex + 1;
    if (nextIdx < queue.tracks.length) {
      final nextTrack = queue.tracks[nextIdx];
      ref.read(playbackServiceProvider).prefetchNext(nextTrack, null);
    }
  }

  Future<void> _handleCandidateFailure() async {
    if (_disposed || _isRecovering || _consecutiveTrackFailures >= 5) return;
    _isRecovering = true;
    final track = state.currentTrack;
    if (track == null) {
      _isRecovering = false;
      return;
    }
    final generation = _playbackGeneration;

    debugPrint(
      'PlayerNotifier: Candidate ${track.youtubeVideoId} failed. Trying next candidate.',
    );

    _currentCandidateIndex++;
    if (_currentCandidateIndex < _currentCandidates.length) {
      await _attemptCurrentCandidate(
        _playbackGeneration,
        track,
        List<Track>.from(state.playbackQueue.tracks),
      );
    } else {
      await _controller.stop();
      if (_disposed || generation != _playbackGeneration) return;
      _handleLogicalTrackFailure('Playback failed for all available sources');
    }
    if (!_disposed && generation == _playbackGeneration) _isRecovering = false;
  }

  void _handleLogicalTrackFailure([String? specificError]) {
    _consecutiveTrackFailures++;

    if (_consecutiveTrackFailures < 5) {
      if (specificError != null) {
        state = state.copyWith(loadError: specificError);
      }
      debugPrint(
        'PlayerNotifier: Track exhausted. Auto-skipping to next (failure count: $_consecutiveTrackFailures)',
      );

      var queue = state.playbackQueue;
      if (queue.repeatMode == RepeatMode.one) {
        queue = queue.copyWith(repeatMode: RepeatMode.all);
      }

      final nextQueue = queue.next();
      if (nextQueue.currentIndex < nextQueue.tracks.length) {
        final nextTrack = nextQueue.tracks[nextQueue.currentIndex];
        playTrack(nextTrack, queue: nextQueue.tracks, isRetry: true);
      } else {
        state = state.copyWith(
          loadError: specificError ?? 'Queue ended after consecutive failures.',
          isLoadingVideo: false,
        );
      }
    } else {
      state = state.copyWith(
        loadError:
            specificError ??
            'Excessive consecutive track failures. Playback stopped.',
        isLoadingVideo: false,
      );
      debugPrint(
        'PlayerNotifier: Stopped due to excessive consecutive failures.',
      );
    }
  }

  void _scheduleSaveState() {
    if (_saveTimer?.isActive ?? false) return;
    if (_disposed) return;
    _saveTimer = Timer(const Duration(seconds: 2), () {
      _persistenceWork = _saveState();
    });
  }

  Future<void> _saveState() async {
    try {
      if (_disposed) return;
      final snapshot = state;
      final box = await Hive.openBox('player_state');
      if (_disposed) return;
      await box.put('queue', jsonEncode(snapshot.playbackQueue.toJson()));
      await box.put('positionMs', snapshot.position.inMilliseconds);
      await box.put('durationMs', snapshot.duration.inMilliseconds);
    } catch (e) {
      debugPrint('Failed to save player state: $e');
    }
  }

  Future<void> _initRestore() async {
    final generation = _playbackGeneration;
    try {
      final box = await Hive.openBox('player_state');
      if (_disposed || generation != _playbackGeneration) return;
      final queueJson = box.get('queue');
      final posMs = box.get('positionMs');

      if (queueJson != null) {
        final queue = PlaybackQueue.fromJson(jsonDecode(queueJson));
        final position = Duration(milliseconds: posMs ?? 0);
        final durMs = box.get('durationMs');
        final duration =
            durMs != null && durMs > 0
                ? Duration(milliseconds: durMs)
                : (queue.currentTrack?.durationMs != null &&
                        queue.currentTrack!.durationMs! > 0)
                    ? Duration(milliseconds: queue.currentTrack!.durationMs!)
                    : Duration.zero;

        state = state.copyWith(
          playbackQueue: queue,
          position: position,
          duration: duration,
          isPlaying: false,
        );

        // Cue the video silently so the IFrame shows the paused frame.
        // _restoringState blocks macOS from auto-playing via the AudioHandler.
        _restoringState = true;
        unawaited(_prepareRestoredTrack(position));
      }
    } catch (e) {
      debugPrint('Failed to restore player state: $e');
    }
  }


  /// Cues the restored track at [savedPosition] without starting audio.
  /// Runs after startup; sets _restoringState=false when done so
  /// external play commands from macOS are honoured again.
  Future<void> _prepareRestoredTrack(Duration savedPosition) async {
    final track = state.currentTrack;
    if (track == null) {
      _restoringState = false;
      return;
    }

    _playbackGeneration++;
    final myGen = _playbackGeneration;

    try {
      final service = ref.read(playbackServiceProvider);
      Track resolvedTrack = track;
      
      if (!track.isLocal) {
        final candidates = await service.resolveCandidates(track, null);
        if (_disposed || myGen != _playbackGeneration) {
          _restoringState = false;
          return;
        }

        if (candidates.isEmpty) {
          _restoringState = false;
          return;
        }

        final candidate = candidates.first;
        resolvedTrack = track.copyWith(youtubeVideoId: candidate.videoId);
        await service.cacheYoutubeId(resolvedTrack.spotifyId, candidate.videoId);
        if (_disposed || myGen != _playbackGeneration) {
          _restoringState = false;
          return;
        }
      }

      // Update queue entry with resolved video ID.
      final newQueue = List<Track>.from(state.playbackQueue.tracks);
      final idx = state.playbackQueue.currentIndex;
      if (idx >= 0 && idx < newQueue.length) {
        newQueue[idx] = resolvedTrack;
        state = state.copyWith(
          playbackQueue: state.playbackQueue.copyWith(tracks: newQueue),
        );
      }

      // Cue video silently (no audio). Sets intendedState=paused in engine.
      await _controller.prepare(
        resolvedTrack.toPlaybackTrack(),
        position: savedPosition,
      );
      if (_disposed || myGen != _playbackGeneration) {
        _clearRestoreGuard();
        return;
      }
      _controller.setVolume(state.volume);
      // _restoringState stays true here — _syncFromStatus will clear it when
      // the engine reaches PlaybackState.paused (IFrame fired the cued event).
      // _restoreTimeout is a safety net in case the cued event never fires.
      _restoreTimeout?.cancel();
      _restoreTimeout = Timer(const Duration(seconds: 10), _clearRestoreGuard);
    } catch (e) {
      debugPrint('PlayerNotifier: _prepareRestoredTrack failed: $e');
      _clearRestoreGuard();
    }
  }

  void _clearRestoreGuard() {
    if (_restoringState) {
      debugPrint('PlayerNotifier: restore guard cleared');
      _restoringState = false;
    }
    _restoreTimeout?.cancel();
    _restoreTimeout = null;
  }

  PlaybackController get _controller => ref.read(playbackControllerProvider);

  Future<void> playTrack(
    Track track, {
    List<Track>? queue,
    bool isRetry = false,
    String? contextArtistId,
    Duration? position,
    int? queueIndex,
  }) async {
    if (!isRetry) {
      _prefetchedNextTrackForCurrentLoad = false;
      if (queue != null) {
        _autoplaySeenTrackIds.clear();
      }
      _consecutiveTrackFailures = 0;
    }
    _playbackGeneration++;
    final myGen = _playbackGeneration;
    _isRecovering = false;

    final timestamp = DateTime.now().microsecondsSinceEpoch;

    final q =
        (queue ?? [track]).asMap().entries.map((e) {
          final t = e.value;
          if (t.queueItemId != null) return t;
          return t.copyWith(
            queueItemId: '${t.spotifyId}_${timestamp}_${e.key}',
          );
        }).toList();

    int idx = 0;
    Track targetTrack;
    if (queueIndex != null && queueIndex >= 0 && queueIndex < q.length) {
      idx = queueIndex;
      targetTrack = q[idx];
    } else {
      targetTrack = q.firstWhere(
        (t) {
          if (track.queueItemId != null && t.queueItemId != null) {
            return t.queueItemId == track.queueItemId;
          }
          return t.spotifyId == track.spotifyId && t.name == track.name;
        },
        orElse: () => q.first,
      );
      idx = q.indexOf(targetTrack);
    }

    debugPrint('PlayerNotifier: Resolving track ${track.name}');

    state = state.copyWith(
      playbackQueue: state.playbackQueue.copyWith(
        tracks: q,
        currentIndex: idx < 0 ? 0 : idx,
        contextArtistId:
            contextArtistId ??
            (queue != null ? null : state.playbackQueue.contextArtistId),
      ),
      clearLoadError: true,
      isLoadingVideo: true,
      videoId: null,
      position: Duration.zero,
      duration: Duration.zero,
      buffered: Duration.zero,
    );
    _scheduleSaveState();
    _evaluateAutoplay();

    try {
      final service = ref.read(playbackServiceProvider);
      final candidates = await service.resolveCandidates(targetTrack, null);

      if (_disposed || myGen != _playbackGeneration) return;

      if (candidates.isNotEmpty) {
        _currentCandidates = candidates;
        _currentCandidateIndex = 0;
        await _attemptCurrentCandidate(
          myGen,
          targetTrack,
          q,
          position: position,
        );
      } else {
        await _controller.stop();
        if (_disposed || myGen != _playbackGeneration) return;
        _handleLogicalTrackFailure('No YouTube video found for this track');
        return;
      }
    } catch (e) {
      if (_disposed || myGen != _playbackGeneration) return;
      debugPrint('Failed to resolve YouTube ID for ${targetTrack.name}: $e');
      await _controller.stop();
      if (_disposed || myGen != _playbackGeneration) return;
      _handleLogicalTrackFailure('Failed to resolve YouTube ID');
      return;
    }
  }

  Future<void> _attemptCurrentCandidate(
    int myGen,
    Track track,
    List<Track> queue, {
    Duration? position,
  }) async {
    final candidate = _currentCandidates[_currentCandidateIndex];
    final service = ref.read(playbackServiceProvider);

    if (_disposed || myGen != _playbackGeneration) return;

    final newTrack = track.copyWith(youtubeVideoId: candidate.videoId);
    await service.cacheYoutubeId(newTrack.spotifyId, candidate.videoId);
    if (_disposed || myGen != _playbackGeneration) return;

    final newQueue = List<Track>.from(state.playbackQueue.tracks);
    final idx = state.playbackQueue.currentIndex;
    if (idx >= 0 && idx < newQueue.length) {
      newQueue[idx] = newTrack;
      state = state.copyWith(
        playbackQueue: state.playbackQueue.copyWith(tracks: newQueue),
        isLoadingVideo: true,
      );
    }

    if (_currentCandidateIndex > 0) {
      state = state.copyWith(loadError: 'Trying another source...');
    } else {
      state = state.copyWith(clearLoadError: true);
    }

    await _controller.stop();
    if (_disposed || myGen != _playbackGeneration) return;

    await _controller.play(
      newTrack.toPlaybackTrack(),
      startAt: position ?? Duration.zero,
    );
    if (_disposed || myGen != _playbackGeneration) return;
    _controller.setVolume(state.volume);

    await service.recordPlay(newTrack);
  }

  Future<void> playTracks(
    List<Track> tracks, {
    int initialIndex = 0,
    String? contextArtistId,
  }) async {
    if (tracks.isEmpty) return;
    final track =
        (initialIndex >= 0 && initialIndex < tracks.length)
            ? tracks[initialIndex]
            : tracks.first;
    await playTrack(track, queue: tracks, contextArtistId: contextArtistId);
  }

  Future<void> shuffleAndPlay(
    List<Track> tracks, {
    String? contextArtistId,
  }) async {
    if (tracks.isEmpty) return;
    final shuffled = [...tracks]..shuffle();
    state = state.copyWith(
      playbackQueue: state.playbackQueue.copyWith(
        tracks: shuffled,
        currentIndex: 0,
        isShuffled: true,
        contextArtistId: contextArtistId,
      ),
    );
    await playTrack(
      shuffled.first,
      queue: shuffled,
      contextArtistId: contextArtistId,
    );
  }

  Future<void> playPlaylist(int playlistId) async {
    final tracks = await ref
        .read(playbackServiceProvider)
        .getPlaylistTracks(playlistId);
    if (tracks.isNotEmpty) {
      await playTracks(tracks);
    }
  }

  Future<void> playRadio(String artistId) async {
    final tracks = await ref
        .read(playbackServiceProvider)
        .getRadioTracks(artistId);
    if (tracks.isNotEmpty) {
      await playTrack(tracks.first, queue: tracks);
    }
  }

  Future<void> retryLoad() async {
    final track = state.currentTrack;
    if (track == null) return;
    // Delegate to the full validated playTrack flow. This ensures:
    //  - YoutubeIdValidator is applied (null/invalid ID → fresh resolution)
    //  - _playGeneration is incremented (stale retry cannot overwrite a newer selection)
    //  - loadError is cleared before the attempt
    // Do NOT call _controller.play() directly here — that bypasses validation.
    await playTrack(track, queue: state.playbackQueue.tracks);
  }

  void pause() => _controller.pause();
  void resume() {
    // Block system-initiated play commands (e.g. macOS media session) while
    // the startup restore is cuing the video. _restoringState is cleared by
    // _prepareRestoredTrack once the IFrame is ready (or on failure).
    if (_restoringState) {
      debugPrint('PlayerNotifier: resume() blocked — restore in progress');
      return;
    }
    final engineState = _controller.currentStatus.state;
    // Route to _resumeRestoredState if the engine is idle (never started) OR
    // still preparing (prepare() was called but hasn't cued yet). In both
    // cases _controller.resume() alone cannot start playback.
    if (state.currentTrack != null &&
        (engineState == PlaybackState.idle ||
            engineState == PlaybackState.preparing)) {
      _resumeRestoredState();
    } else {
      _controller.resume();
    }
  }

  Future<void> _resumeRestoredState() async {
    final track = state.currentTrack;
    if (track == null) return;

    // Fast-path: the startup prepare() already cued the video.
    // _controller.resume() calls playVideo() directly — instant audio start.
    final engineState = _controller.currentStatus.state;
    if (engineState == PlaybackState.paused) {
      if (track.isLocal) {
        // media_kit loses the initial cued seek position on resume().
        await _controller.play(
          track.toPlaybackTrack(),
          startAt: state.position,
        );
      } else {
        _controller.resume();
      }
      return;
    }

    // Fallback: engine is idle or still loading — run the full playTrack flow.
    // state.position is always correct here because _syncFromStatus(preparing)
    // no longer overwrites it with Duration.zero.
    final position = state.position;
    final generation = _playbackGeneration;
    await playTrack(
      track,
      queue: state.playbackQueue.tracks,
      position: position,
    );
    if (_disposed || generation != _playbackGeneration) return;
  }

  void togglePlay() {
    if (state.isPlaying) {
      pause();
    } else {
      // User explicitly tapping play always clears the restore guard so the
      // action is never silently swallowed (unlike macOS auto-commands).
      _clearRestoreGuard();
      resume();
    }
  }

  void skipNext() {
    final nextQueue = state.playbackQueue.next();
    if (nextQueue.currentIndex < nextQueue.tracks.length) {
      final track = nextQueue.tracks[nextQueue.currentIndex];
      playTrack(
        track,
        queue: nextQueue.tracks,
        queueIndex: nextQueue.currentIndex,
      );
    }

    // Evaluate autoplay if we didn't play a track but still advanced
    _evaluateAutoplay();
  }

  void skipPrevious() {
    final prevQueue = state.playbackQueue.previous(state.position);
    final track = prevQueue.tracks[prevQueue.currentIndex];
    playTrack(
      track,
      queue: prevQueue.tracks,
      queueIndex: prevQueue.currentIndex,
    );
  }

  void skipTo(int index) {
    if (index >= 0 && index < state.playbackQueue.tracks.length) {
      playTrack(
        state.playbackQueue.tracks[index],
        queue: state.playbackQueue.tracks,
        queueIndex: index,
      );
    }
  }

  void addToQueue(Track track) {
    final t = track.copyWith(queueOrigin: QueueItemOrigin.user);
    state = state.copyWith(playbackQueue: state.playbackQueue.add(t));
    _scheduleSaveState();
    _evaluateAutoplay();
  }

  void addTracksToQueue(List<Track> tracks) {
    var q = state.playbackQueue;
    for (final track in tracks) {
      q = q.add(track.copyWith(queueOrigin: QueueItemOrigin.user));
    }
    state = state.copyWith(playbackQueue: q);
    _scheduleSaveState();
    _evaluateAutoplay();
  }

  void playNext(Track track) {
    final t = track.copyWith(queueOrigin: QueueItemOrigin.user);
    state = state.copyWith(playbackQueue: state.playbackQueue.insertNext(t));
    _scheduleSaveState();
    _evaluateAutoplay();
  }

  void removeFromQueue(int index) {
    state = state.copyWith(playbackQueue: state.playbackQueue.removeAt(index));
    _scheduleSaveState();
    _evaluateAutoplay();
  }

  void toggleShuffle() {
    state = state.copyWith(
      playbackQueue: state.playbackQueue.copyWith(
        isShuffled: !state.playbackQueue.isShuffled,
      ),
    );
    _scheduleSaveState();
  }

  void reorderQueue(int oldIndex, int newIndex) {
    state = state.copyWith(
      playbackQueue: state.playbackQueue.reorder(oldIndex, newIndex),
    );
    _scheduleSaveState();
    _evaluateAutoplay();
  }

  Future<void> cycleRepeat() async {
    final nextMode =
        RepeatMode.values[(state.repeatMode.index + 1) %
            RepeatMode.values.length];
    state = state.copyWith(
      playbackQueue: state.playbackQueue.copyWith(repeatMode: nextMode),
    );
    _scheduleSaveState();
  }

  Future<void> setVolume(double volume) async {
    state = state.copyWith(volume: volume);
    await _controller.setVolume(volume);
  }

  void seekTo(Duration position) => _controller.seekTo(position);

  Future<void> toggleFavorite(Track track) async {
    final newValue = !track.isFavorite;
    await ref.read(playbackServiceProvider).toggleFavorite(track, newValue);

    final newQueue =
        state.queue.map((t) {
          if (t.spotifyId == track.spotifyId) {
            return t.copyWith(isFavorite: newValue);
          }
          return t;
        }).toList();

    state = state.copyWith(
      playbackQueue: state.playbackQueue.copyWith(tracks: newQueue),
    );
    _scheduleSaveState();
  }

  Future<void> _evaluateAutoplay() async {
    final settings = ref.read(settingsProvider);
    if (!settings.autoplayEnabled) return;
    if (state.repeatMode != RepeatMode.none) return;
    if (_isFetchingAutoplay) return;

    final queue = state.playbackQueue;
    if (queue.tracks.isEmpty) return;

    final remainingAfterCurrent = queue.tracks.length - queue.currentIndex - 1;
    if (remainingAfterCurrent > 15) return;

    final currentTrack = queue.currentTrack;
    if (currentTrack == null) return;

    _isFetchingAutoplay = true;
    try {
      final spotifyRepo = ref.read(spotifyRepositoryProvider);

      String? seedArtistId = queue.contextArtistId;

      if (seedArtistId == null) {
        final contextTracks =
            queue.tracks
                .where((t) => t.queueOrigin != QueueItemOrigin.autoplay)
                .toList();
        if (contextTracks.length >= 2) {
          final artistCounts = <String, int>{};
          for (final t in contextTracks) {
            final aId = t.artistId.split(',').first;
            if (aId.isNotEmpty) {
              artistCounts[aId] = (artistCounts[aId] ?? 0) + 1;
            }
          }
          if (artistCounts.isNotEmpty) {
            final dominant = artistCounts.entries.reduce(
              (a, b) => a.value > b.value ? a : b,
            );
            if (dominant.value > contextTracks.length / 2) {
              seedArtistId = dominant.key;
            }
          }
        }
      }

      final cacheResult =
          await spotifyRepo
              .watchRecommendations(
                seedArtistId: seedArtistId,
                seedTrackId: currentTrack.spotifyId,
                limit: 30,
              )
              .first;
      final candidates = cacheResult.data;

      final queueIds = queue.tracks.map((t) => t.spotifyId).toSet();
      final newTracks =
          candidates
              .where((t) {
                if (queueIds.contains(t.spotifyId)) return false;
                if (t.spotifyId == currentTrack.spotifyId) return false;
                if (_autoplaySeenTrackIds.contains(t.spotifyId)) return false;
                return true;
              })
              .map((t) => t.copyWith(queueOrigin: QueueItemOrigin.autoplay))
              .toList();

      if (newTracks.isNotEmpty) {
        _autoplaySeenTrackIds.addAll(newTracks.map((t) => t.spotifyId));
        var newQueue = state.playbackQueue;
        for (final t in newTracks) {
          newQueue = newQueue.add(t);
        }
        state = state.copyWith(playbackQueue: newQueue);
        _scheduleSaveState();
      }
    } catch (e) {
      debugPrint('Failed to fetch autoplay tracks: $e');
    } finally {
      _isFetchingAutoplay = false;
    }
  }
}

final playerProvider = NotifierProvider<PlayerNotifier, PlayerState>(
  PlayerNotifier.new,
);
