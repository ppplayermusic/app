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
    bool clearLoadError = false,
  }) {
    return PlayerState(
      playbackQueue: playbackQueue ?? this.playbackQueue,
      isPlaying: isPlaying ?? this.isPlaying,
      videoId: identical(videoId, _sentinel) ? this.videoId : videoId as String?,
      isLoadingVideo: isLoadingVideo ?? this.isLoadingVideo,
      loadError: clearLoadError ? null : (identical(loadError, _sentinel) ? this.loadError : loadError as String?),
      position: position ?? this.position,
      duration: duration ?? this.duration,
      buffered: buffered ?? this.buffered,
      volume: volume ?? this.volume,
      isPipMode: isPipMode ?? this.isPipMode,
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
  Timer? _saveTimer;
  bool _prefetchedNextTrackForCurrentLoad = false;
  
  bool _isFetchingAutoplay = false;
  final Set<String> _autoplaySeenTrackIds = {};

  @override
  PlayerState build() {
    _initRestore();
    // Listen to the playback engine's status and sync it to our state
    ref.listen(playbackStatusProvider, (previous, next) {
      next.whenData((status) {
        if (status.state == PlaybackState.ended) {
          if (!_skipDebounce) {
            _skipDebounce = true;
            skipNext();
            Future.delayed(const Duration(milliseconds: 1000), () => _skipDebounce = false);
          }
        }
        _syncFromStatus(status);
      });
    });

    ref.listen(settingsProvider, (previous, next) {
      if (previous?.continuePlaybackInPip != next.continuePlaybackInPip) {
        final isPlaying = state.isPlaying;
        PipHandler.setPipEnabled(next.continuePlaybackInPip && isPlaying);
      }
    });

    PipHandler.init();
    PipHandler.onPipModeChanged = (isPipMode) {
      state = state.copyWith(isPipMode: isPipMode);
    };
    PipHandler.onActivityStopped = () {
      // In PiP mode the activity is stopped but playback continues
      // in the floating PiP window — do NOT pause here.
      if (!state.isPipMode) {
        pause();
      }
    };

    ref.listen(settingsProvider, (previous, next) {
      if (previous?.continuePlaybackInPip != next.continuePlaybackInPip) {
        PipHandler.setPipEnabled(next.continuePlaybackInPip && state.isPlaying);
      }
    });

    return const PlayerState();
  }

  void _syncFromStatus(PlaybackStatus status) {
    String? displayError = status.error;
    
    if (status.state == PlaybackState.error && status.error != null) {
      if (status.error!.startsWith('unavailable_media:') || status.error!.startsWith('error:')) {
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

    final isPlaying = status.state == PlaybackState.playing || status.state == PlaybackState.buffering;
    final pipEnabled = ref.read(settingsProvider).continuePlaybackInPip;
    PipHandler.setPipEnabled(pipEnabled && isPlaying);

    state = state.copyWith(
      isPlaying: isPlaying,
      isLoadingVideo: status.state == PlaybackState.preparing || status.state == PlaybackState.buffering,
      loadError: displayError,
      videoId: status.activeVideoId,
      position: status.position,
      duration: status.duration,
      buffered: status.buffered,
    );
    _scheduleSaveState();
    
    // Trigger prefetch once playback starts successfully
    if (status.state == PlaybackState.playing && !_prefetchedNextTrackForCurrentLoad) {
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
    if (_isRecovering) return;
    _isRecovering = true;
    final track = state.currentTrack;
    if (track == null) return;
    
    debugPrint('PlayerNotifier: Candidate ${track.youtubeVideoId} failed. Trying next candidate.');
    
    _currentCandidateIndex++;
    if (_currentCandidateIndex < _currentCandidates.length) {
      await _attemptCurrentCandidate(_playbackGeneration, track, List<Track>.from(state.playbackQueue.tracks));
    } else {
      await _controller.stop();
      _handleLogicalTrackFailure('Playback failed for all available sources');
    }
    _isRecovering = false;
  }

  void _handleLogicalTrackFailure([String? specificError]) {
    _consecutiveTrackFailures++;
    
    if (_consecutiveTrackFailures < 5) {
      if (specificError != null) {
        state = state.copyWith(loadError: specificError);
      }
      debugPrint('PlayerNotifier: Track exhausted. Auto-skipping to next (failure count: $_consecutiveTrackFailures)');
      
      var queue = state.playbackQueue;
      if (queue.repeatMode == RepeatMode.one) {
         queue = queue.copyWith(repeatMode: RepeatMode.all);
      }
      
      final nextQueue = queue.next();
      if (nextQueue.currentIndex < nextQueue.tracks.length) {
        final nextTrack = nextQueue.tracks[nextQueue.currentIndex];
        playTrack(nextTrack, queue: nextQueue.tracks, isRetry: true);
      } else {
        state = state.copyWith(loadError: specificError ?? 'Queue ended after consecutive failures.', isLoadingVideo: false);
      }
    } else {
      state = state.copyWith(loadError: specificError ?? 'Excessive consecutive track failures. Playback stopped.', isLoadingVideo: false);
      debugPrint('PlayerNotifier: Stopped due to excessive consecutive failures.');
    }
  }

  void _scheduleSaveState() {
    if (_saveTimer?.isActive ?? false) return;
    _saveTimer = Timer(const Duration(seconds: 2), _saveState);
  }

  Future<void> _saveState() async {
    try {
      final box = await Hive.openBox('player_state');
      await box.put('queue', jsonEncode(state.playbackQueue.toJson()));
      await box.put('positionMs', state.position.inMilliseconds);
    } catch (e) {
      debugPrint('Failed to save player state: $e');
    }
  }

  Future<void> _initRestore() async {
    try {
      final box = await Hive.openBox('player_state');
      final queueJson = box.get('queue');
      final posMs = box.get('positionMs');
      
      if (queueJson != null) {
        final queue = PlaybackQueue.fromJson(jsonDecode(queueJson));
        final position = Duration(milliseconds: posMs ?? 0);
        
        state = state.copyWith(
          playbackQueue: queue,
          position: position,
          isPlaying: false,
        );
      }
    } catch (e) {
      debugPrint('Failed to restore player state: $e');
    }
  }

  // Removed direct service getter to use ref.read inside methods
  PlaybackController get _controller => ref.read(playbackControllerProvider);

  Future<void> playTrack(Track track, {List<Track>? queue, bool isRetry = false, String? contextArtistId}) async {
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
    
    final q = (queue ?? [track]).asMap().entries.map((e) {
      final t = e.value;
      if (t.queueItemId != null) return t; 
      return t.copyWith(queueItemId: '${t.spotifyId}_${timestamp}_${e.key}');
    }).toList();

    final targetTrack = q.firstWhere((t) => t.spotifyId == track.spotifyId && t.name == track.name);
    final idx = q.indexOf(targetTrack);

    debugPrint('PlayerNotifier: Resolving track ${track.name}');

    state = state.copyWith(
      playbackQueue: state.playbackQueue.copyWith(
        tracks: q,
        currentIndex: idx < 0 ? 0 : idx,
        contextArtistId: contextArtistId ?? (queue != null ? null : state.playbackQueue.contextArtistId),
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
      
      if (myGen != _playbackGeneration) return;

      if (candidates.isNotEmpty) {
        _currentCandidates = candidates;
        _currentCandidateIndex = 0;
        await _attemptCurrentCandidate(myGen, targetTrack, q);
      } else {
        await _controller.stop();
        if (myGen != _playbackGeneration) return;
        _handleLogicalTrackFailure('No YouTube video found for this track');
        return;
      }
    } catch (e) {
      if (myGen != _playbackGeneration) return;
      debugPrint('Failed to resolve YouTube ID for ${targetTrack.name}: $e');
      await _controller.stop();
      if (myGen != _playbackGeneration) return;
      _handleLogicalTrackFailure('Failed to resolve YouTube ID');
      return;
    }
  }

  Future<void> _attemptCurrentCandidate(int myGen, Track track, List<Track> queue) async {
    final candidate = _currentCandidates[_currentCandidateIndex];
    final service = ref.read(playbackServiceProvider);
    
    if (myGen != _playbackGeneration) return;
    
    final newTrack = track.copyWith(youtubeVideoId: candidate.videoId);
    await service.cacheYoutubeId(newTrack.spotifyId, candidate.videoId);
    
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
    if (myGen != _playbackGeneration) return;

    await _controller.play(newTrack.toPlaybackTrack());
    if (myGen != _playbackGeneration) return;
    _controller.setVolume(state.volume);
    
    await service.recordPlay(newTrack);
  }

  Future<void> playTracks(List<Track> tracks, {int initialIndex = 0, String? contextArtistId}) async {
    if (tracks.isEmpty) return;
    final track = (initialIndex >= 0 && initialIndex < tracks.length) ? tracks[initialIndex] : tracks.first;
    await playTrack(track, queue: tracks, contextArtistId: contextArtistId);
  }

  Future<void> shuffleAndPlay(List<Track> tracks, {String? contextArtistId}) async {
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
    await playTrack(shuffled.first, queue: shuffled, contextArtistId: contextArtistId);
  }

  Future<void> playPlaylist(int playlistId) async {
    final tracks = await ref.read(playbackServiceProvider).getPlaylistTracks(playlistId);
    if (tracks.isNotEmpty) {
      await playTracks(tracks);
    }
  }

  Future<void> playRadio(String artistId) async {
    final tracks = await ref.read(playbackServiceProvider).getRadioTracks(artistId);
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
    if (_controller.currentStatus.state == PlaybackState.idle && state.currentTrack != null) {
      _resumeRestoredState();
    } else {
      _controller.resume();
    }
  }

  Future<void> _resumeRestoredState() async {
    final track = state.currentTrack;
    if (track == null) return;
    
    await playTrack(track, queue: state.playbackQueue.tracks);
    if (state.position > Duration.zero) {
      // Seek slightly after to ensure video is loaded
      Future.delayed(const Duration(milliseconds: 500), () {
        _controller.seekTo(state.position);
      });
    }
  }

  void togglePlay() {
    if (state.isPlaying) {
      pause();
    } else {
      resume();
    }
  }

  void skipNext() {
    final nextQueue = state.playbackQueue.next();
    if (nextQueue.currentIndex < nextQueue.tracks.length) {
      final track = nextQueue.tracks[nextQueue.currentIndex];
      playTrack(track, queue: nextQueue.tracks);
    }
    
    // Evaluate autoplay if we didn't play a track but still advanced
    _evaluateAutoplay();
  }

  void skipPrevious() {
    final prevQueue = state.playbackQueue.previous(state.position);
    final track = prevQueue.tracks[prevQueue.currentIndex];
    playTrack(track, queue: prevQueue.tracks);
  }

  void skipTo(int index) {
    if (index >= 0 && index < state.playbackQueue.tracks.length) {
      playTrack(state.playbackQueue.tracks[index], queue: state.playbackQueue.tracks);
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
      playbackQueue: state.playbackQueue.copyWith(isShuffled: !state.playbackQueue.isShuffled),
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
    final nextMode = RepeatMode.values[(state.repeatMode.index + 1) % RepeatMode.values.length];
    state = state.copyWith(playbackQueue: state.playbackQueue.copyWith(repeatMode: nextMode));
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

    final newQueue = state.queue.map((t) {
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
        final contextTracks = queue.tracks.where((t) => t.queueOrigin != QueueItemOrigin.autoplay).toList();
        if (contextTracks.length >= 2) {
          final artistCounts = <String, int>{};
          for (final t in contextTracks) {
            final aId = t.artistId.split(',').first;
            if (aId.isNotEmpty) {
              artistCounts[aId] = (artistCounts[aId] ?? 0) + 1;
            }
          }
          if (artistCounts.isNotEmpty) {
            final dominant = artistCounts.entries.reduce((a, b) => a.value > b.value ? a : b);
            if (dominant.value > contextTracks.length / 2) {
              seedArtistId = dominant.key;
            }
          }
        }
      }
      
      final cacheResult = await spotifyRepo.watchRecommendations(
        seedArtistId: seedArtistId,
        seedTrackId: currentTrack.spotifyId,
        limit: 30,
      ).first;
      final candidates = cacheResult.data;

      final queueIds = queue.tracks.map((t) => t.spotifyId).toSet();
      final newTracks = candidates.where((t) {
        if (queueIds.contains(t.spotifyId)) return false;
        if (t.spotifyId == currentTrack.spotifyId) return false;
        if (_autoplaySeenTrackIds.contains(t.spotifyId)) return false;
        return true;
      }).map((t) => t.copyWith(queueOrigin: QueueItemOrigin.autoplay)).toList();

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

final playerProvider = NotifierProvider<PlayerNotifier, PlayerState>(PlayerNotifier.new);
