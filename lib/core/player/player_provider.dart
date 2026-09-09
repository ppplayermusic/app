import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:convert';
import 'package:hive_ce/hive_ce.dart';
import '../models/track.dart';
import '../models/playback_queue.dart';
import '../playback/playback_providers.dart';
import '../playback/youtube_id_validator.dart';
import '../metrics/cache_metrics.dart';
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
    this.volume = 1.0,
  });

  final PlaybackQueue playbackQueue;
  final bool isPlaying;
  final String? videoId;
  final bool isLoadingVideo;
  final String? loadError;
  final Duration position;
  final Duration duration;
  final double volume;

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
    double? volume,
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
      volume: volume ?? this.volume,
    );
  }
}

const Object _sentinel = Object();

class PlayerNotifier extends Notifier<PlayerState> {
  int _playGeneration = 0;
  bool _skipDebounce = false;
  Timer? _saveTimer;
  bool _forcedResolutionAttemptedForCurrentLoad = false;
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

    return const PlayerState();
  }

  void _syncFromStatus(PlaybackStatus status) {
    String? displayError = status.error;
    
    if (status.state == PlaybackState.error && status.error != null) {
      if (status.error!.startsWith('unavailable_media:')) {
        if (!_forcedResolutionAttemptedForCurrentLoad) {
          _forcedResolutionAttemptedForCurrentLoad = true;
          _handleUnavailableMedia();
          return; // Skip setting error state, we are retrying
        } else {
          displayError = 'Media unavailable after retry';
        }
      } else if (status.error!.startsWith('transient:')) {
        return; // Ignore transient errors
      }
    }

    state = state.copyWith(
      isPlaying: status.isPlaying,
      isLoadingVideo: status.state == PlaybackState.preparing || status.state == PlaybackState.buffering,
      loadError: displayError,
      videoId: status.activeVideoId,
      position: status.position,
      duration: status.duration,
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

  Future<void> _handleUnavailableMedia() async {
    final track = state.currentTrack;
    if (track == null) return;
    
    debugPrint('PlayerNotifier: Unavailable media. Invalidating cached YouTube ID for ${track.name}');
    ref.read(cacheMetricsProvider).youtubeForcedReresolutions++;
    final service = ref.read(playbackServiceProvider);
    
    // Invalidate the cache (which sets it to null in the database)
    await service.cacheYoutubeId(track.spotifyId, null);
    
    final invalidatedTrack = track.copyWith(youtubeVideoId: null);
    
    final newQueue = List<Track>.from(state.playbackQueue.tracks);
    final idx = state.playbackQueue.currentIndex;
    if (idx >= 0 && idx < newQueue.length) {
      newQueue[idx] = invalidatedTrack;
      state = state.copyWith(
        playbackQueue: state.playbackQueue.copyWith(tracks: newQueue)
      );
    }
    
    await playTrack(invalidatedTrack, queue: newQueue, isRetry: true);
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

  Future<void> playTrack(Track track, {List<Track>? queue, bool isRetry = false}) async {
    if (!isRetry) {
      _forcedResolutionAttemptedForCurrentLoad = false;
      _prefetchedNextTrackForCurrentLoad = false;
      if (queue != null) {
        _autoplaySeenTrackIds.clear();
      }
    }
    _playGeneration++;
    final myGen = _playGeneration;

    final timestamp = DateTime.now().microsecondsSinceEpoch;
    
    // Ensure every track in the upcoming queue has a unique occurrence ID
    final q = (queue ?? [track]).asMap().entries.map((e) {
      final t = e.value;
      if (t.queueItemId != null) return t; // Already has ID
      return t.copyWith(queueItemId: '${t.spotifyId}_${timestamp}_${e.key}');
    }).toList();

    final targetTrack = q.firstWhere((t) => t.spotifyId == track.spotifyId && t.name == track.name);
    final idx = q.indexOf(targetTrack);

    debugPrint('PlayerNotifier: Playing track ${track.name}');

    state = state.copyWith(
      playbackQueue: state.playbackQueue.copyWith(
        tracks: q,
        currentIndex: idx < 0 ? 0 : idx,
      ),
      clearLoadError: true,
    );
    _scheduleSaveState();
    _evaluateAutoplay();

    Track finalTrack = targetTrack;
    
    // Resolve YouTube ID if missing or invalid
    final currentYtId = finalTrack.youtubeVideoId;
    final needsResolution = !YoutubeIdValidator.isValid(
      currentYtId, 
      spotifyId: finalTrack.spotifyId
    );

    if (needsResolution) {
      state = state.copyWith(isLoadingVideo: true);
      try {
        final service = ref.read(playbackServiceProvider);
        final candidates = await service.resolveCandidates(finalTrack, null);
        
        if (myGen != _playGeneration) return;

        if (candidates.isNotEmpty) {
          final resolvedId = candidates.first;
          if (YoutubeIdValidator.isValid(resolvedId, spotifyId: finalTrack.spotifyId)) {
            finalTrack = finalTrack.copyWith(youtubeVideoId: resolvedId);
            await service.cacheYoutubeId(finalTrack.spotifyId, resolvedId);
            
            // Update queue with resolved track
            final newQueue = List<Track>.from(state.playbackQueue.tracks);
            newQueue[idx] = finalTrack;
            state = state.copyWith(
              playbackQueue: state.playbackQueue.copyWith(tracks: newQueue)
            );
          } else {
            state = state.copyWith(
              isLoadingVideo: false,
              loadError: 'Resolved invalid YouTube ID: $resolvedId',
            );
            return;
          }
        } else {
          state = state.copyWith(
            isLoadingVideo: false,
            loadError: 'No YouTube video found for this track',
          );
          return;
        }
      } catch (e) {
        if (myGen != _playGeneration) return;
        debugPrint('Failed to resolve YouTube ID for ${finalTrack.name}: $e');
        state = state.copyWith(
          isLoadingVideo: false,
          loadError: 'Failed to resolve YouTube ID: $e',
        );
        return;
      }
    }

    if (myGen != _playGeneration) return;

    // Delegate to the new playback controller
    await _controller.play(finalTrack.toPlaybackTrack());
    _controller.setVolume(state.volume); // Apply current volume
    
    await ref.read(playbackServiceProvider).recordPlay(finalTrack);
  }

  Future<void> playTracks(List<Track> tracks, {int initialIndex = 0}) async {
    if (tracks.isEmpty) return;
    final track = (initialIndex >= 0 && initialIndex < tracks.length) ? tracks[initialIndex] : tracks.first;
    await playTrack(track, queue: tracks);
  }

  Future<void> shuffleAndPlay(List<Track> tracks) async {
    if (tracks.isEmpty) return;
    final shuffled = [...tracks]..shuffle();
    state = state.copyWith(
      playbackQueue: state.playbackQueue.copyWith(
        tracks: shuffled,
        currentIndex: 0,
        isShuffled: true,
      ),
    );
    await playTrack(shuffled.first, queue: shuffled);
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
      
      final cacheResult = await spotifyRepo.watchRecommendations(
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
