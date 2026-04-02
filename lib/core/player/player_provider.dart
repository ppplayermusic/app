import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/track.dart';
import 'package:ppplayer/core/services/settings_provider.dart';
import 'package:ppplayer/core/api/spotify_client.dart';
import '../api/youtube_resolver.dart';
import 'package:drift/drift.dart' show Value;
import '../db/app_database.dart' as db;

export '../models/track.dart' show Track;

enum RepeatMode { none, one, all }

class PlayerState {
  const PlayerState({
    this.queue = const [],
    this.currentIndex = 0,
    this.isPlaying = false,
    this.repeatMode = RepeatMode.none,
    this.isShuffled = false,
    this.videoId,
    this.isLoadingVideo = false,
    this.loadError,
    this.candidateIds = const [],
    this.candidateIndex = 0,
    this.position = Duration.zero,
    this.duration = Duration.zero,
  });

  final List<Track> queue;
  final int currentIndex;
  final bool isPlaying;
  final RepeatMode repeatMode;
  final bool isShuffled;
  final String? videoId;
  final bool isLoadingVideo;
  final String? loadError;
  final List<String> candidateIds;
  final int candidateIndex;
  final Duration position;
  final Duration duration;

  Track? get currentTrack =>
      queue.isNotEmpty && currentIndex < queue.length
          ? queue[currentIndex]
          : null;

  PlayerState copyWith({
    List<Track>? queue,
    int? currentIndex,
    bool? isPlaying,
    RepeatMode? repeatMode,
    bool? isShuffled,
    String? videoId,
    bool? isLoadingVideo,
    String? loadError,
    List<String>? candidateIds,
    int? candidateIndex,
    Duration? position,
    Duration? duration,
  }) =>
      PlayerState(
        queue: queue ?? this.queue,
        currentIndex: currentIndex ?? this.currentIndex,
        isPlaying: isPlaying ?? this.isPlaying,
        repeatMode: repeatMode ?? this.repeatMode,
        isShuffled: isShuffled ?? this.isShuffled,
        videoId: videoId ?? this.videoId,
        isLoadingVideo: isLoadingVideo ?? this.isLoadingVideo,
        loadError: loadError ?? this.loadError,
        candidateIds: candidateIds ?? this.candidateIds,
        candidateIndex: candidateIndex ?? this.candidateIndex,
        position: position ?? this.position,
        duration: duration ?? this.duration,
      );
}

class PlayerNotifier extends Notifier<PlayerState> {
  @override
  PlayerState build() => const PlayerState();

  YoutubeResolver get _resolver => ref.read(youtubeResolverProvider);
  db.AppDatabase get _db => ref.read(db.appDatabaseProvider);

  Future<void> playTrack(Track track, {List<Track>? queue}) async {
    final idx = queue?.indexOf(track) ?? 0;
    state = state.copyWith(
      queue: queue ?? [track],
      currentIndex: idx < 0 ? 0 : idx,
      isPlaying: true,
      isLoadingVideo: true,
      loadError: null,
      videoId: null,
      candidateIds: [],
      candidateIndex: 0,
      position: Duration.zero,
      duration: Duration.zero,
    );

    await _resolveVideo(track);
    await _db.recordPlay(db.TracksCompanion(
      spotifyId: Value(track.spotifyId),
      name: Value(track.name),
      artistId: Value(track.artistId),
      artistName: Value(track.artistName),
      albumId: Value(track.albumId),
      albumName: Value(track.albumName),
      albumImage: Value(track.albumImage),
      durationMs: Value(track.durationMs),
      lastPlayedAt: Value(DateTime.now()),
    ));
  }

  Future<void> playTracks(List<Track> tracks, {int initialIndex = 0}) async {
    if (tracks.isEmpty) return;
    final track = (initialIndex >= 0 && initialIndex < tracks.length)
        ? tracks[initialIndex]
        : tracks.first;
    await playTrack(track, queue: tracks);
  }

  Future<void> playPlaylist(int playlistId) async {
    final tracks = await _db.getPlaylistTracks(playlistId);
    if (tracks.isEmpty) return;

    final modelTracks = tracks
        .map((t) => Track(
              spotifyId: t.spotifyId,
              name: t.name,
              artistId: t.artistId,
              artistName: t.artistName,
              albumId: t.albumId,
              albumName: t.albumName,
              albumImage: t.albumImage,
              durationMs: t.durationMs,
              youtubeVideoId: t.youtubeVideoId,
              playCount: t.playCount,
              isFavorite: t.isFavorite,
            ))
        .toList();

    await playTracks(modelTracks);
  }

  Future<void> playRadio(String artistId) async {
    final client = ref.read(spotifyClientProvider);
    try {
      final tracks = await client.getRecommendations(seedArtistId: artistId);
      if (tracks.isNotEmpty) {
        await playTrack(tracks.first, queue: tracks);
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _resolveVideo(Track track) async {
    // Use cached video ID if available
    if (track.youtubeVideoId != null) {
      state = state.copyWith(
        videoId: track.youtubeVideoId,
        candidateIds: [track.youtubeVideoId!],
        isLoadingVideo: false,
        loadError: null,
      );
      return;
    }

    final regionCode = ref.read(settingsProvider).selectedCountry;
    final candidates =
        await _resolver.resolve(track.artistName, track.name, regionCode: regionCode);

    if (candidates.isEmpty) {
      state = state.copyWith(
        isLoadingVideo: false,
        loadError: 'No video found for this track. Click to retry.',
      );
      return;
    }

    // Cache the first result
    await _db.cacheYoutubeId(track.spotifyId, candidates[0]);

    state = state.copyWith(
      candidateIds: candidates,
      candidateIndex: 0,
      videoId: candidates[0],
      isLoadingVideo: false,
      loadError: null,
    );
  }

  /// Called by the YouTube player when a video fails — try the next candidate
  void onVideoError() {
    final next = state.candidateIndex + 1;
    if (next < state.candidateIds.length) {
      state = state.copyWith(
        candidateIndex: next,
        videoId: state.candidateIds[next],
        loadError: null,
      );
    } else {
      state = state.copyWith(
        loadError: 'Failed to load video. Click to retry.',
      );
    }
  }

  Future<void> retryLoad() async {
    final track = state.currentTrack;
    if (track == null) return;

    state = state.copyWith(
      loadError: null,
      isLoadingVideo: true,
      videoId: null,
      candidateIds: [],
      candidateIndex: 0,
      position: Duration.zero,
      duration: Duration.zero,
    );

    // Clear db cache for this track so we rescan YouTube
    await _db.cacheYoutubeId(track.spotifyId, null);

    // Refresh resolution
    await _resolveVideo(track);
  }

  void pause() => state = state.copyWith(isPlaying: false);
  void resume() => state = state.copyWith(isPlaying: true);
  void togglePlay() => state = state.copyWith(isPlaying: !state.isPlaying);

  void skipNext() {
    if (state.queue.isEmpty) return;

    if (state.repeatMode == RepeatMode.one) {
      // Just re-resolve/play the same track
      playTrack(state.queue[state.currentIndex], queue: state.queue);
      return;
    }

    if (state.isShuffled && state.queue.length > 1) {
      int nextIdx;
      do {
        nextIdx = (DateTime.now().millisecondsSinceEpoch % state.queue.length);
      } while (nextIdx == state.currentIndex);
      playTrack(state.queue[nextIdx], queue: state.queue);
      return;
    }

    int next = state.currentIndex + 1;
    if (next >= state.queue.length) {
      if (state.repeatMode == RepeatMode.all) {
        next = 0;
      } else {
        return; // End of queue
      }
    }
    playTrack(state.queue[next], queue: state.queue);
  }

  void skipPrevious() {
    if (state.queue.isEmpty) return;
    
    // If we are more than 3 seconds into the track, just restart it
    if (state.position.inSeconds > 3) {
      playTrack(state.queue[state.currentIndex], queue: state.queue);
      return;
    }

    int prev = state.currentIndex - 1;
    if (prev < 0) {
      if (state.repeatMode == RepeatMode.all) {
        prev = state.queue.length - 1;
      } else {
        prev = 0;
      }
    }
    playTrack(state.queue[prev], queue: state.queue);
  }

  void skipTo(int index) {
    if (index >= 0 && index < state.queue.length) {
      playTrack(state.queue[index], queue: state.queue);
    }
  }

  void addToQueue(Track track) {
    state = state.copyWith(queue: [...state.queue, track]);
  }

  void removeFromQueue(int index) {
    final newQueue = [...state.queue]..removeAt(index);
    state = state.copyWith(queue: newQueue);
  }

  void toggleShuffle() =>
      state = state.copyWith(isShuffled: !state.isShuffled);

  void reorderQueue(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final queue = [...state.queue];
    final item = queue.removeAt(oldIndex);
    queue.insert(newIndex, item);

    int newCurrentIndex = state.currentIndex;
    if (state.currentIndex == oldIndex) {
      newCurrentIndex = newIndex;
    } else if (oldIndex < state.currentIndex && newIndex >= state.currentIndex) {
      newCurrentIndex--;
    } else if (oldIndex > state.currentIndex && newIndex <= state.currentIndex) {
      newCurrentIndex++;
    }

    state = state.copyWith(
      queue: queue,
      currentIndex: newCurrentIndex,
    );
  }

  void cycleRepeat() {
    final next = RepeatMode.values[
        (state.repeatMode.index + 1) % RepeatMode.values.length];
    state = state.copyWith(repeatMode: next);
  }

  void updatePosition(Duration position, [Duration? duration]) {
    state = state.copyWith(
      position: position,
      duration: (duration != null && duration != Duration.zero) ? duration : state.duration,
    );
  }

  void seekTo(Duration position) {
    // This will be listened to by YoutubePlayerService
    state = state.copyWith(position: position);
  }

  Future<void> toggleFavorite(Track track) async {
    final newValue = !track.isFavorite;
    await _db.toggleFavorite(track.spotifyId, newValue);

    // Update state if the favorited track is in the queue
    final newQueue = state.queue.map((t) {
      if (t.spotifyId == track.spotifyId) {
        return t.copyWith(isFavorite: newValue);
      }
      return t;
    }).toList();

    state = state.copyWith(queue: newQueue);
  }
}

final recentlyPlayedProvider = FutureProvider<List<Track>>((ref) async {
  final database = ref.watch(db.appDatabaseProvider);
  final tracks = await database.getRecentlyPlayed(limit: 6);
  return tracks
      .map((t) => Track(
            spotifyId: t.spotifyId,
            name: t.name,
            artistId: t.artistId,
            artistName: t.artistName,
            albumId: t.albumId,
            albumName: t.albumName,
            albumImage: t.albumImage,
            durationMs: t.durationMs,
            youtubeVideoId: t.youtubeVideoId,
            playCount: t.playCount,
            isFavorite: t.isFavorite,
          ))
      .toList();
});

final playerProvider = NotifierProvider<PlayerNotifier, PlayerState>(
  PlayerNotifier.new,
);
