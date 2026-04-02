import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'app_database.g.dart';

// --- Tables ---

class Tracks extends Table {
  TextColumn get spotifyId => text()();
  TextColumn get name => text()();
  TextColumn get artistId => text()();
  TextColumn get artistName => text()();
  TextColumn get albumId => text().nullable()();
  TextColumn get albumName => text().nullable()();
  TextColumn get albumImage => text().nullable()();
  IntColumn get durationMs => integer().nullable()();
  // Cached YouTube video ID after first resolve — avoids re-querying API
  TextColumn get youtubeVideoId => text().nullable()();
  IntColumn get playCount =>
      integer().withDefault(const Constant(0))();
  BoolColumn get isFavorite =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastPlayedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {spotifyId};
}

class Artists extends Table {
  TextColumn get spotifyId => text()();
  TextColumn get name => text()();
  TextColumn get imageUrl => text().nullable()();
  TextColumn get imageSmall => text().nullable()();
  IntColumn get followers => integer().nullable()();
  BoolColumn get isFollowed =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {spotifyId};
}

class Albums extends Table {
  TextColumn get spotifyId => text()();
  TextColumn get name => text()();
  TextColumn get artistId => text()();
  TextColumn get artistName => text()();
  TextColumn get imageUrl => text().nullable()();
  TextColumn get releaseDate => text().nullable()();
  IntColumn get totalTracks => integer().nullable()();
  BoolColumn get isLiked =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {spotifyId};
}

class Playlists extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get spotifyId => text().nullable()();
  TextColumn get imageUrl => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class PlaylistTracks extends Table {
  IntColumn get playlistId => integer()();
  TextColumn get trackSpotifyId => text()();
  IntColumn get position => integer()();

  @override
  Set<Column> get primaryKey => {playlistId, trackSpotifyId};
}

// --- Database ---

@DriftDatabase(tables: [Tracks, Artists, Albums, Playlists, PlaylistTracks])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(playlists);
            await m.createTable(playlistTracks);
          }
          if (from < 3) {
            await m.addColumn(tracks, tracks.lastPlayedAt);
          }
          if (from < 4) {
            await m.addColumn(artists, artists.isFollowed);
            await m.addColumn(albums, albums.isLiked);
            await m.addColumn(playlists, playlists.spotifyId);
            await m.addColumn(playlists, playlists.imageUrl);
          }
          if (from < 5) {
            await m.addColumn(artists, artists.updatedAt);
            await m.addColumn(albums, albums.updatedAt);
            await customStatement('UPDATE artists SET updated_at = ? WHERE is_followed = 1', [DateTime.now().millisecondsSinceEpoch]);
            await customStatement('UPDATE albums SET updated_at = ? WHERE is_liked = 1', [DateTime.now().millisecondsSinceEpoch]);
          }
        },
      );

  // --- Track queries ---

  Future<List<Track>> getFavorites() =>
      (select(tracks)..where((t) => t.isFavorite.equals(true))).get();

  Future<List<Track>> getRecentlyPlayed({int limit = 50}) =>
      (select(tracks)
            ..where((t) => t.lastPlayedAt.isNotNull())
            ..orderBy([(t) => OrderingTerm.desc(t.lastPlayedAt)])
            ..limit(limit))
          .get();

  Stream<List<Track>> watchRecentlyPlayed({int limit = 50}) =>
      (select(tracks)
            ..where((t) => t.lastPlayedAt.isNotNull())
            ..orderBy([(t) => OrderingTerm.desc(t.lastPlayedAt)])
            ..limit(limit))
          .watch();

  Future<void> clearHistory() =>
      (update(tracks)).write(const TracksCompanion(lastPlayedAt: Value(null)));

  Future<void> upsertTrack(TracksCompanion entry) =>
      into(tracks).insertOnConflictUpdate(entry);

  Future<void> cacheYoutubeId(String spotifyId, String? videoId) =>
      (update(tracks)..where((t) => t.spotifyId.equals(spotifyId)))
          .write(TracksCompanion(youtubeVideoId: Value(videoId)));

  Future<void> toggleFavorite(String spotifyId, bool value) =>
      (update(tracks)..where((t) => t.spotifyId.equals(spotifyId)))
          .write(TracksCompanion(isFavorite: Value(value)));

  Future<void> recordPlay(TracksCompanion companion) async {
    // Insert or update basic info, then increment count manually
    await into(tracks).insertOnConflictUpdate(companion);
    await customUpdate(
      'UPDATE tracks SET play_count = play_count + 1 WHERE spotify_id = ?',
      variables: [Variable.withString(companion.spotifyId.value)],
      updates: {tracks},
    );
  }

  // --- Artist queries ---

  Future<void> upsertArtist(ArtistsCompanion entry) =>
      into(artists).insertOnConflictUpdate(entry);

  Future<void> toggleArtistFollow(String spotifyId, bool value, {String? name, String? imageUrl}) async {
    final companion = ArtistsCompanion(
      spotifyId: Value(spotifyId),
      isFollowed: Value(value),
      name: name != null ? Value(name) : const Value.absent(),
      imageUrl: imageUrl != null ? Value(imageUrl) : const Value.absent(),
      updatedAt: Value(DateTime.now()),
    );
    await into(artists).insertOnConflictUpdate(companion);
  }

  Stream<Artist?> watchArtist(String spotifyId) =>
      (select(artists)..where((a) => a.spotifyId.equals(spotifyId)))
          .watchSingleOrNull();

  Future<List<Artist>> getFollowedArtists() =>
      (select(artists)..where((a) => a.isFollowed.equals(true))).get();

  Stream<List<Artist>> watchFollowedArtists({bool sortByRecent = true}) {
    final query = select(artists)..where((a) => a.isFollowed.equals(true));
    if (sortByRecent) {
      query.orderBy([(a) => OrderingTerm.desc(a.updatedAt, nulls: NullsOrder.last)]);
    } else {
      query.orderBy([(a) => OrderingTerm.asc(a.name)]);
    }
    return query.watch();
  }

  // --- Album queries ---

  Future<void> upsertAlbum(AlbumsCompanion entry) =>
      into(albums).insertOnConflictUpdate(entry);

  Future<void> toggleAlbumLike(String spotifyId, bool value, {String? name, String? artistName, String? imageUrl}) async {
    final companion = AlbumsCompanion(
      spotifyId: Value(spotifyId),
      isLiked: Value(value),
      name: name != null ? Value(name) : const Value.absent(),
      artistName: artistName != null ? Value(artistName) : const Value.absent(),
      imageUrl: imageUrl != null ? Value(imageUrl) : const Value.absent(),
      updatedAt: Value(DateTime.now()),
    );
    await into(albums).insertOnConflictUpdate(companion);
  }

  Stream<Album?> watchAlbum(String spotifyId) =>
      (select(albums)..where((a) => a.spotifyId.equals(spotifyId)))
          .watchSingleOrNull();

  Future<List<Album>> getLikedAlbums() =>
      (select(albums)..where((a) => a.isLiked.equals(true))).get();

  Stream<List<Album>> watchLikedAlbums({bool sortByRecent = true}) {
    final query = select(albums)..where((a) => a.isLiked.equals(true));
    if (sortByRecent) {
      query.orderBy([(a) => OrderingTerm.desc(a.updatedAt, nulls: NullsOrder.last)]);
    } else {
      query.orderBy([(a) => OrderingTerm.asc(a.name)]);
    }
    return query.watch();
  }

  // --- Playlist queries ---

  Future<List<Playlist>> getPlaylists() => select(playlists).get();

  Stream<List<Playlist>> watchPlaylists({bool sortByRecent = true}) {
    final query = select(playlists);
    if (sortByRecent) {
      query.orderBy([(p) => OrderingTerm.desc(p.createdAt)]);
    } else {
      query.orderBy([(p) => OrderingTerm.asc(p.name)]);
    }
    return query.watch();
  }

  Future<List<Track>> getPlaylistTracks(int playlistId) async {
    final query = select(tracks).join([
      innerJoin(playlistTracks,
          playlistTracks.trackSpotifyId.equalsExp(tracks.spotifyId)),
    ])
      ..where(playlistTracks.playlistId.equals(playlistId))
      ..orderBy([OrderingTerm.asc(playlistTracks.position)]);

    final rows = await query.get();
    return rows.map((row) => row.readTable(tracks)).toList();
  }

  Future<int> createPlaylist(String name, {String? spotifyId, String? imageUrl}) =>
      into(playlists).insert(PlaylistsCompanion(
        name: Value(name),
        spotifyId: Value(spotifyId),
        imageUrl: Value(imageUrl),
      ));

  Future<void> togglePlaylistLike(String spotifyId, bool value, {String? name, String? imageUrl}) async {
    if (value) {
      // Like: create/add to playlists table if not exists
      final existing = await (select(playlists)..where((p) => p.spotifyId.equals(spotifyId))).getSingleOrNull();
      if (existing == null) {
        await createPlaylist(name ?? 'Unnamed Playlist', spotifyId: spotifyId, imageUrl: imageUrl);
      }
    } else {
      // Unlike: remove from playlists table
      await (delete(playlists)..where((p) => p.spotifyId.equals(spotifyId))).go();
    }
  }

  Future<void> deletePlaylist(int id) async {
    await (delete(playlists)..where((p) => p.id.equals(id))).go();
    await (delete(playlistTracks)..where((pt) => pt.playlistId.equals(id))).go();
  }

  Future<void> addToPlaylist(int playlistId, String spotifyId) async {
    // Get current max position
    final maxPosQuery = selectOnly(playlistTracks)
      ..addColumns([playlistTracks.position.max()])
      ..where(playlistTracks.playlistId.equals(playlistId));
    final maxPos = await maxPosQuery.map((row) => row.read(playlistTracks.position.max())).getSingleOrNull() ?? 0;

    await into(playlistTracks).insert(PlaylistTracksCompanion(
      playlistId: Value(playlistId),
      trackSpotifyId: Value(spotifyId),
      position: Value(maxPos + 1),
    ));
  }

  Future<void> reorderTracks(int playlistId, List<String> trackIdsInOrder) async {
    await transaction(() async {
      for (int i = 0; i < trackIdsInOrder.length; i++) {
        await (update(playlistTracks)
              ..where((pt) =>
                  pt.playlistId.equals(playlistId) &
                  pt.trackSpotifyId.equals(trackIdsInOrder[i])))
            .write(PlaylistTracksCompanion(position: Value(i)));
      }
    });
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'ppplayer_db');
  }
}

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError('Override in ProviderScope');
});
