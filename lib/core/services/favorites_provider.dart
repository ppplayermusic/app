import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../db/app_database.dart' as db;
import '../models/track.dart';
import 'package:drift/drift.dart';

enum FavoriteType { track, artist, album, playlist, radio }

final favoritesStatusProvider =
    StreamProvider.family<bool, (FavoriteType, String)>((ref, arg) {
      final database = ref.watch(db.appDatabaseProvider);
      final type = arg.$1;
      final id = arg.$2;

      switch (type) {
        case FavoriteType.track:
          return database.watchTrackFavorite(id);
        case FavoriteType.artist:
          return database.watchArtist(id).map((a) => a?.isFollowed ?? false);
        case FavoriteType.album:
          return database.watchAlbum(id).map((a) => a?.isLiked ?? false);
        case FavoriteType.playlist:
          return database.watchPlaylistIsFavorite(id);
        case FavoriteType.radio:
          final parts = id.split(':');
          if (parts.length < 2) return Stream.value(false);
          return database
              .watchRadio(parts[0], parts[1])
              .map((r) => r?.isFollowed ?? false);
      }
    });

class FavoritesController extends Notifier<void> {
  @override
  void build() {}

  db.AppDatabase get _db => ref.read(db.appDatabaseProvider);

  Future<void> toggleTrackFavorite(
    Track track,
    bool isCurrentlyFavorite,
  ) async {
    final newValue = !isCurrentlyFavorite;
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
        isFavorite: Value(newValue),
      ),
    );
  }

  Future<void> toggleArtistFollow(
    String id,
    String name,
    String? imageUrl,
    bool isCurrentlyFollowed,
  ) async {
    await _db.toggleArtistFollow(
      id,
      !isCurrentlyFollowed,
      name: name,
      imageUrl: imageUrl,
    );
  }

  Future<void> toggleAlbumLike(
    String id,
    String name,
    String artistId,
    String artistName,
    String? imageUrl,
    bool isCurrentlyLiked,
  ) async {
    await _db.toggleAlbumLike(
      id,
      !isCurrentlyLiked,
      name: name,
      artistId: artistId,
      artistName: artistName,
      imageUrl: imageUrl,
    );
  }

  Future<void> togglePlaylistLike(
    String id,
    String name,
    String? imageUrl,
    bool isCurrentlyLiked,
  ) async {
    await _db.togglePlaylistLike(
      id,
      !isCurrentlyLiked,
      name: name,
      imageUrl: imageUrl,
    );
  }

  Future<void> toggleRadioFollow({
    required String seedId,
    required String seedType,
    required String title,
    String? imageUrl,
    required bool isCurrentlyFollowed,
  }) async {
    await _db.toggleRadioFollow(
      seedId,
      seedType,
      !isCurrentlyFollowed,
      title: title,
      imageUrl: imageUrl,
    );
  }

  Future<void> toggleTrackFavoriteById({
    required String id,
    required String name,
    required String artistId,
    required String artistName,
    String? albumId,
    String? albumName,
    String? imageUrl,
    int? durationMs,
    required bool isCurrentlyFavorite,
  }) async {
    final newValue = !isCurrentlyFavorite;
    await _db.upsertTrack(
      db.TracksCompanion(
        spotifyId: Value(id),
        name: Value(name),
        artistId: Value(artistId),
        artistName: Value(artistName),
        albumId: albumId != null ? Value(albumId) : const Value.absent(),
        albumName: albumName != null ? Value(albumName) : const Value.absent(),
        albumImage: imageUrl != null ? Value(imageUrl) : const Value.absent(),
        durationMs: durationMs != null
            ? Value(durationMs)
            : const Value.absent(),
        isFavorite: Value(newValue),
      ),
    );
  }
}

final favoritesControllerProvider = NotifierProvider<FavoritesController, void>(
  FavoritesController.new,
);
