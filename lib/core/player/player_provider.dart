import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import '../models/track.dart';
import '../models/playback_queue.dart';
import '../playback/playback_providers.dart';
import '../playback/youtube_id_validator.dart';

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

  @override
  PlayerState build() {
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
    state = state.copyWith(
      isPlaying: status.isPlaying,
      isLoadingVideo: status.state == PlaybackState.preparing || status.state == PlaybackState.buffering,
      loadError: status.error,
      videoId: status.activeVideoId,
      position: status.position,
      duration: status.duration,
    );
  }

  // Removed direct service getter to use ref.read inside methods
  PlaybackController get _controller => ref.read(playbackControllerProvider);

  Future<void> playTrack(Track track, {List<Track>? queue}) async {
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
  void resume() => _controller.resume();
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
    state = state.copyWith(playbackQueue: state.playbackQueue.add(track));
  }

  void removeFromQueue(int index) {
    state = state.copyWith(playbackQueue: state.playbackQueue.removeAt(index));
  }

  void toggleShuffle() {
    state = state.copyWith(
      playbackQueue: state.playbackQueue.copyWith(isShuffled: !state.playbackQueue.isShuffled),
    );
  }

  void reorderQueue(int oldIndex, int newIndex) {
    state = state.copyWith(
      playbackQueue: state.playbackQueue.reorder(oldIndex, newIndex),
    );
  }

  Future<void> cycleRepeat() async {
    final nextMode = RepeatMode.values[(state.repeatMode.index + 1) % RepeatMode.values.length];
    state = state.copyWith(playbackQueue: state.playbackQueue.copyWith(repeatMode: nextMode));
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
  }
}

final playerProvider = NotifierProvider<PlayerNotifier, PlayerState>(PlayerNotifier.new);
