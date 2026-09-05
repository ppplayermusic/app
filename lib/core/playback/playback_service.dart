import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' show Value;
import '../models/track.dart';
import '../db/app_database.dart' as db;
import '../api/spotify_client.dart';
import '../api/youtube_resolver.dart';

class PlaybackService {
  final Ref ref;

  PlaybackService(this.ref);

  db.AppDatabase get _db => ref.read(db.appDatabaseProvider);
  SpotifyClient get _spotify => ref.read(spotifyClientProvider);
  YoutubeResolver get _resolver => ref.read(youtubeResolverProvider);

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

  /// Gets recommendations for high-level radio.
  Future<List<Track>> getRadioTracks(String artistId) async {
    try {
      return await _spotify.getRecommendations(seedArtistId: artistId);
    } catch (_) {
      return [];
    }
  }

  /// Resolves video candidates for a track.
  Future<List<String>> resolveCandidates(Track track, String? regionCode) async {
    return await _resolver.resolve(
      track.artistName,
      track.name,
      regionCode: regionCode,
    );
  }

  /// Caches a resolved YouTube ID.
  Future<void> cacheYoutubeId(String spotifyId, String? youtubeId) async {
    await _db.cacheYoutubeId(spotifyId, youtubeId);
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
