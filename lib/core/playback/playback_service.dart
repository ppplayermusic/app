import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' show Value;
import '../models/track.dart';
import '../db/app_database.dart' as db;
import '../api/spotify_repository.dart';
import '../api/youtube_resolver.dart';
import '../metrics/cache_metrics.dart';

class PlaybackService {
  final Ref ref;

  PlaybackService(this.ref);

  db.AppDatabase get _db => ref.read(db.appDatabaseProvider);
  YoutubeResolver get _resolver => ref.read(youtubeResolverProvider);
  CacheMetrics get _metrics => ref.read(cacheMetricsProvider);

  /// Records a play history entry in the database.
  Future<void> recordPlay(Track track) async {
    await _db.recordPlay(
      db.TracksCompanion(
        spotifyId: Value(track.spotifyId),
        name: Value(track.name),
        artistId: Value(track.artistId),
        artistName: Value(track.artistName),
        albumId: Value(track.albumId),
        albumName: Value(track.albumName),
        albumImage: Value(track.albumImage),
        durationMs: Value(track.durationMs),
        lastPlayedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Fetches tracks for a playlist.
  Future<List<Track>> getPlaylistTracks(int playlistId) async {
    final tracks = await _db.getPlaylistTracks(playlistId);
    return tracks
        .map(
          (t) => Track(
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
          ),
        )
        .toList();
  }

  SpotifyRepository get _spotifyRepo => ref.read(spotifyRepositoryProvider);

  /// Gets recommendations for high-level radio.
  Future<List<Track>> getRadioTracks(String artistId) async {
    try {
      final cacheResult = await _spotifyRepo.watchRecommendations(seedArtistId: artistId).first;
      return cacheResult.data;
    } catch (_) {
      return [];
    }
  }

  final Map<String, DateTime> _negativeCache = {};
  final Map<String, List<String>> _prefetchedCandidates = {};

  /// Resolves video candidates for a track.
  Future<List<String>> resolveCandidates(Track track, String? regionCode) async {
    // Check 10-minute negative cache
    if (_negativeCache.containsKey(track.spotifyId)) {
      if (DateTime.now().difference(_negativeCache[track.spotifyId]!) < const Duration(minutes: 10)) {
        _metrics.youtubeNegativeCacheHits++;
        return [];
      } else {
        _negativeCache.remove(track.spotifyId);
      }
    }

    if (_prefetchedCandidates.containsKey(track.spotifyId)) {
      _metrics.youtubeCachedMappingHits++;
      final cached = _prefetchedCandidates.remove(track.spotifyId)!;
      if (cached.isNotEmpty) return cached;
    }

    _metrics.youtubeResolutionRequests++;
    final candidates = await _resolver.resolve(
      track.artistName,
      track.name,
      regionCode: regionCode,
    );

    if (candidates.isEmpty) {
      _negativeCache[track.spotifyId] = DateTime.now();
    }

    return candidates;
  }

  /// Caches a resolved YouTube ID.
  Future<void> cacheYoutubeId(String spotifyId, String? youtubeId) async {
    await _db.cacheYoutubeId(spotifyId, youtubeId);
  }

  /// Prefetches candidates for a track to populate resolver state.
  Future<void> prefetchNext(Track track, String? regionCode) async {
    if (track.youtubeVideoId != null) return;
    if (_negativeCache.containsKey(track.spotifyId)) return;
    if (_prefetchedCandidates.containsKey(track.spotifyId)) return;

    try {
      final candidates = await _resolver.resolve(
        track.artistName,
        track.name,
        regionCode: regionCode,
      );

      if (candidates.isEmpty) {
        _negativeCache[track.spotifyId] = DateTime.now();
      } else {
        _prefetchedCandidates[track.spotifyId] = candidates;
      }
    } catch (_) {}
  }

  /// Toggles favorite status in the database.
  Future<void> toggleFavorite(Track track, bool isFavorite) async {
    await _db.upsertTrack(
      db.TracksCompanion(
        spotifyId: Value(track.spotifyId),
        name: Value(track.name),
        artistId: Value(track.artistId),
        artistName: Value(track.artistName),
        albumId: Value(track.albumId),
        albumName: Value(track.albumName),
        albumImage: Value(track.albumImage),
        durationMs: Value(track.durationMs),
        isFavorite: Value(isFavorite),
      ),
    );
  }

  /// Fetches recently played tracks.
  Future<List<Track>> getRecentlyPlayed({int limit = 50}) async {
    final tracks = await _db.getRecentlyPlayed(limit: limit);
    return tracks
        .map(
          (t) => Track(
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
          ),
        )
        .toList();
  }
}

final playbackServiceProvider = Provider<PlaybackService>((ref) {
  return PlaybackService(ref);
});

final recentlyPlayedProvider = FutureProvider<List<Track>>((ref) async {
  final service = ref.watch(playbackServiceProvider);
  final tracks = await service.getRecentlyPlayed(limit: 6);
  return tracks;
});
