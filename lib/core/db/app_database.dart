import 'dart:io';
import '../local_library/audio_format_registry.dart' show ImportMediaScope;
import 'package:path/path.dart' as p;
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/track.dart' as model;
import '../models/local_album.dart';
import '../models/local_artist.dart';
import '../models/local_folder.dart';
import '../models/local_genre.dart';

part 'app_database.g.dart';

// --- Tables ---

@DataClassName('TrackEntry')
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
  DateTimeColumn get youtubeResolvedAt => dateTime().nullable()();
  IntColumn get playCount => integer().withDefault(const Constant(0))();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
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
  BoolColumn get isFollowed => boolean().withDefault(const Constant(false))();
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
  BoolColumn get isLiked => boolean().withDefault(const Constant(false))();
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

class Radios extends Table {
  TextColumn get seedId => text()();
  TextColumn get seedType => text()(); // artist, track, genre
  TextColumn get title => text()();
  TextColumn get imageUrl => text().nullable()();
  BoolColumn get isFollowed => boolean().withDefault(const Constant(true))();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {seedId, seedType};
}

class PlaylistTracks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get playlistId => integer()();
  TextColumn get trackSpotifyId => text()();
  IntColumn get position => integer()();
}

class CatalogCacheEntries extends Table {
  TextColumn get key => text()();
  TextColumn get payload => text()();
  DateTimeColumn get fetchedAt => dateTime()();
  DateTimeColumn get lastAccessedAt => dateTime()();
  IntColumn get payloadVersion => integer()();
  TextColumn get resourceType => text()();

  @override
  Set<Column> get primaryKey => {key};
}

/// Persistent access descriptor for each locally imported audio or video file.
/// [spotifyId] in Tracks stores the matching [libraryId] (e.g. 'local:`<uuid>`').
class LocalFiles extends Table {
  // Stable library ID: 'local:<uuid>'. FK → Tracks.spotifyId.
  TextColumn get libraryId => text()();

  // Access mechanism: 'absolutePath' | 'androidContentUri' |
  //                   'iOsSecurityBookmark' | 'managedCopy'
  TextColumn get mechanism => text()();

  // Durable locator — absolute path, content URI, or base64 bookmark.
  TextColumn get locator => text()();

  // Human-readable path for UI only.
  TextColumn get displayPath => text()();

  // sha1 hex of canonical locator bytes — deduplication key.
  TextColumn get deduplicationKey => text()();

  // 'available' | 'missing' | 'permissionRevoked' | 'decodingError'
  TextColumn get availabilityStatus =>
      text().withDefault(const Constant('available'))();

  DateTimeColumn get lastScannedAt => dateTime()();

  // Import root this file came from (rootLocator), if imported via folder.
  TextColumn get importRootLocator => text().nullable()();

  // Enriched metadata fields (beyond what Tracks stores for Spotify tracks).
  TextColumn get albumArtist => text().nullable()();
  TextColumn get albumGroupKey => text().nullable()();
  IntColumn get trackNumber => integer().nullable()();
  IntColumn get trackTotal => integer().nullable()();
  IntColumn get discNumber => integer().nullable()();
  IntColumn get discTotal => integer().nullable()();
  TextColumn get genre => text().nullable()();
  IntColumn get releaseYear => integer().nullable()();

  // Path to cached artwork file preserving original MIME type.
  TextColumn get artworkPath => text().nullable()();
  TextColumn get artworkMimeType => text().nullable()();

  DateTimeColumn get addedAt => dateTime().withDefault(currentDateAndTime)();

  // Whether a video stream was confirmed by VideoProbeService.
  // Default false: existing rows from before v11 are unclassified/pre-probe;
  // false is the safe default so they stay in the music library until a
  // bounded background rescan can confirm their type.
  BoolColumn get isVideo => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {libraryId};
}

/// Persisted import roots so rescan can discover new files.
/// [mediaScope] is an [ImportMediaScope] name ('audio' | 'video' | 'both') and
/// is required so rescans preserve the original scope across restarts.
class ImportRoots extends Table {
  TextColumn get id => text()(); // uuid v4
  TextColumn get mechanism => text()();
  TextColumn get rootLocator => text()();
  TextColumn get displayPath => text()();
  DateTimeColumn get addedAt => dateTime()();
  // Persisted scope — never inferred from file extensions alone.
  // Defaults to 'audio' for rows created before v11 (backward compat).
  TextColumn get mediaScope =>
      text().withDefault(const Constant('audio'))();

  @override
  Set<Column> get primaryKey => {id};
}

class StreamPlaylists extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  // 'url' | 'local'
  TextColumn get sourceKind => text()();
  // e.g. "https://raw.github.../fj.m3u" or "/Users/..."
  TextColumn get sourceUri => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get lastRefreshed => dateTime().nullable()();
}

class StreamChannels extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get playlistId => integer()();
  // tvg-id from M3U to preserve identity across refreshes
  TextColumn get tvgId => text().nullable()();
  TextColumn get title => text()();
  TextColumn get logo => text().nullable()();
  TextColumn get groupTitle => text().nullable()();
  TextColumn get streamUrl => text()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  IntColumn get position => integer()();
  // 0: unknown, 1: live, 2: onDemand
  IntColumn get liveStatus => integer().withDefault(const Constant(0))();
}

// --- Database ---

@DriftDatabase(
  tables: [
    Tracks,
    Artists,
    Albums,
    Playlists,
    PlaylistTracks,
    Radios,
    CatalogCacheEntries,
    LocalFiles,
    ImportRoots,
    StreamPlaylists,
    StreamChannels,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(String? dbPath) : super(_openConnection(dbPath));

  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 13;

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
        await customStatement(
          'UPDATE artists SET updated_at = ? WHERE is_followed = 1',
          [DateTime.now().millisecondsSinceEpoch],
        );
        await customStatement(
          'UPDATE albums SET updated_at = ? WHERE is_liked = 1',
          [DateTime.now().millisecondsSinceEpoch],
        );
      }
      if (from < 6) {
        await m.createTable(radios);
      }
      if (from < 7) {
        try {
          await m.createTable(catalogCacheEntries);
        } catch (_) {}
        try {
          await m.addColumn(tracks, tracks.youtubeResolvedAt);
        } catch (_) {}
        try {
          await m.addColumn(tracks, tracks.youtubeVideoId);
        } catch (_) {}
      }
      if (from < 8) {
        await m.createTable(localFiles);
        await m.createTable(importRoots);
      }
      if (from < 9) {
        await m.alterTable(TableMigration(localFiles, newColumns: [localFiles.addedAt]));
        await customStatement('UPDATE local_files SET added_at = last_scanned_at');
      }
      if (from < 10) {
        // Drop the primary key constraint on playlist_tracks by recreating it
        await m.alterTable(TableMigration(playlistTracks, newColumns: [playlistTracks.id]));
      }
      if (from < 11) {
        // Add isVideo to local_files.
        // Backfill: all existing rows are pre-probe / unclassified.
        // is_video defaults to 0 (false), which keeps them in the audio
        // library.  A bounded background rescan can promote confirmed video
        // files after the migration.  No data loss occurs.
        await m.addColumn(localFiles, localFiles.isVideo);
        // Add mediaScope to import_roots.
        // Backfill: all existing roots were audio-only imports, so 'audio' is
        // the correct default value for backward compatibility.
        await m.addColumn(importRoots, importRoots.mediaScope);
      }
      if (from < 12) {
        await m.createTable(streamPlaylists);
        await m.createTable(streamChannels);
      }
      if (from < 13) {
        await m.addColumn(streamChannels, streamChannels.liveStatus);
      }
    },
  );

  // --- Track queries ---

  Future<List<TrackEntry>> getFavorites() =>
      (select(tracks)..where((t) => t.isFavorite.equals(true))).get();

  Future<List<model.Track>> getFavoriteAppTracks() async {
    final query = select(tracks).join([
      leftOuterJoin(localFiles, localFiles.libraryId.equalsExp(tracks.spotifyId))
    ])..where(tracks.isFavorite.equals(true));
    final rows = await query.get();
    return rows.map(_mapTrackWithLocal).toList();
  }

  Future<List<TrackEntry>> getRecentlyPlayed({int limit = 50}) =>
      (select(tracks)
            ..where((t) => t.lastPlayedAt.isNotNull())
            ..orderBy([(t) => OrderingTerm.desc(t.lastPlayedAt)])
            ..limit(limit))
          .get();

  Future<List<model.Track>> getRecentlyPlayedAppTracks({int limit = 50}) async {
    final query = select(tracks).join([
      leftOuterJoin(localFiles, localFiles.libraryId.equalsExp(tracks.spotifyId))
    ])
      ..where(tracks.lastPlayedAt.isNotNull())
      ..orderBy([OrderingTerm.desc(tracks.lastPlayedAt)])
      ..limit(limit);
    final rows = await query.get();
    return rows.map(_mapTrackWithLocal).toList();
  }

  Stream<List<TrackEntry>> watchRecentlyPlayed({int limit = 50}) =>
      (select(tracks)
            ..where((t) => t.lastPlayedAt.isNotNull())
            ..orderBy([(t) => OrderingTerm.desc(t.lastPlayedAt)])
            ..limit(limit))
          .watch();

  model.Track _mapTrackWithLocal(TypedResult row) {
    final t = row.readTable(tracks);
    final lf = row.readTableOrNull(localFiles);
    
    if (lf != null) {
      return model.Track(
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
        
        sourceType: model.TrackSourceType.local,
        localFilePath: lf.locator,
        localArtworkPath: lf.artworkPath,
        localAvailabilityStatus: lf.availabilityStatus,
        localAlbumGroupKey: lf.albumGroupKey,
        localAddedAt: lf.addedAt,
        isVideoFile: lf.isVideo,
      );
    }
    
    return model.Track.fromDb(t);
  }

  Stream<List<model.Track>> watchRecentlyPlayedAppTracks({int limit = 50}) {
    final query = select(tracks).join([
      leftOuterJoin(localFiles, localFiles.libraryId.equalsExp(tracks.spotifyId))
    ])
      ..where(tracks.lastPlayedAt.isNotNull())
      ..orderBy([OrderingTerm.desc(tracks.lastPlayedAt)])
      ..limit(limit);
      
    return query.watch().map((rows) => rows.map(_mapTrackWithLocal).toList());
  }

  Future<void> clearHistory() =>
      (update(tracks)).write(const TracksCompanion(lastPlayedAt: Value(null)));

  Future<void> upsertTrack(TracksCompanion entry) =>
      into(tracks).insertOnConflictUpdate(entry);

  Future<void> cacheYoutubeId(String spotifyId, String? videoId) =>
      (update(tracks)..where(
        (t) => t.spotifyId.equals(spotifyId),
      )).write(TracksCompanion(youtubeVideoId: Value(videoId)));

  Future<void> toggleFavorite(String spotifyId, bool value) => (update(tracks)
    ..where(
      (t) => t.spotifyId.equals(spotifyId),
    )).write(TracksCompanion(isFavorite: Value(value)));

  Stream<bool> watchTrackFavorite(String spotifyId) {
    return (select(tracks)..where(
      (t) => t.spotifyId.equals(spotifyId),
    )).watchSingleOrNull().map((t) => t?.isFavorite ?? false);
  }

  Stream<List<TrackEntry>> watchFavorites() {
    return (select(tracks)..where((t) => t.isFavorite.equals(true))).watch();
  }

  Stream<List<model.Track>> watchFavoriteAppTracks() {
    final query = select(tracks).join([
      leftOuterJoin(localFiles, localFiles.libraryId.equalsExp(tracks.spotifyId))
    ])..where(tracks.isFavorite.equals(true));
    
    return query.watch().map((rows) => rows.map(_mapTrackWithLocal).toList());
  }

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

  Future<void> toggleArtistFollow(
    String spotifyId,
    bool value, {
    String? name,
    String? imageUrl,
  }) async {
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
      (select(artists)
        ..where((a) => a.spotifyId.equals(spotifyId))).watchSingleOrNull();

  Future<List<Artist>> getFollowedArtists() =>
      (select(artists)..where((a) => a.isFollowed.equals(true))).get();

  Stream<List<Artist>> watchFollowedArtists({bool sortByRecent = true}) {
    final query = select(artists)..where((a) => a.isFollowed.equals(true));
    if (sortByRecent) {
      query.orderBy([
        (a) => OrderingTerm.desc(a.updatedAt, nulls: NullsOrder.last),
      ]);
    } else {
      query.orderBy([(a) => OrderingTerm.asc(a.name)]);
    }
    return query.watch();
  }

  // --- Radio queries ---

  Future<void> toggleRadioFollow(
    String seedId,
    String seedType,
    bool value, {
    String? title,
    String? imageUrl,
  }) async {
    final companion = RadiosCompanion(
      seedId: Value(seedId),
      seedType: Value(seedType),
      isFollowed: Value(value),
      title: title != null ? Value(title) : const Value.absent(),
      imageUrl: imageUrl != null ? Value(imageUrl) : const Value.absent(),
      updatedAt: Value(DateTime.now()),
    );
    await into(radios).insertOnConflictUpdate(companion);
  }

  Stream<Radio?> watchRadio(String seedId, String seedType) =>
      (select(radios)..where(
        (r) => r.seedId.equals(seedId) & r.seedType.equals(seedType),
      )).watchSingleOrNull();

  Future<List<Radio>> getFollowedRadios() =>
      (select(radios)..where((r) => r.isFollowed.equals(true))).get();

  Stream<List<Radio>> watchFollowedRadios({bool sortByRecent = true}) {
    final query = select(radios)..where((r) => r.isFollowed.equals(true));
    if (sortByRecent) {
      query.orderBy([
        (r) => OrderingTerm.desc(r.updatedAt, nulls: NullsOrder.last),
      ]);
    } else {
      query.orderBy([(r) => OrderingTerm.asc(r.title)]);
    }
    return query.watch();
  }

  // --- Album queries ---

  Future<void> upsertAlbum(AlbumsCompanion entry) =>
      into(albums).insertOnConflictUpdate(entry);

  Future<void> toggleAlbumLike(
    String spotifyId,
    bool value, {
    String? name,
    String? artistId,
    String? artistName,
    String? imageUrl,
  }) async {
    final companion = AlbumsCompanion(
      spotifyId: Value(spotifyId),
      isLiked: Value(value),
      name: name != null ? Value(name) : const Value.absent(),
      artistId: artistId != null ? Value(artistId) : const Value.absent(),
      artistName: artistName != null ? Value(artistName) : const Value.absent(),
      imageUrl: imageUrl != null ? Value(imageUrl) : const Value.absent(),
      updatedAt: Value(DateTime.now()),
    );
    await into(albums).insertOnConflictUpdate(companion);
  }

  Stream<Album?> watchAlbum(String spotifyId) =>
      (select(albums)
        ..where((a) => a.spotifyId.equals(spotifyId))).watchSingleOrNull();

  Future<List<Album>> getLikedAlbums() =>
      (select(albums)..where((a) => a.isLiked.equals(true))).get();

  Stream<List<Album>> watchLikedAlbums({bool sortByRecent = true}) {
    final query = select(albums)..where((a) => a.isLiked.equals(true));
    if (sortByRecent) {
      query.orderBy([
        (a) => OrderingTerm.desc(a.updatedAt, nulls: NullsOrder.last),
      ]);
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

  Future<List<TrackEntry>> getPlaylistTracks(int playlistId) async {
    final query =
        select(tracks).join([
            innerJoin(
              playlistTracks,
              playlistTracks.trackSpotifyId.equalsExp(tracks.spotifyId),
            ),
          ])
          ..where(playlistTracks.playlistId.equals(playlistId))
          ..orderBy([OrderingTerm.asc(playlistTracks.position)]);

    final rows = await query.get();
    return rows.map((row) => row.readTable(tracks)).toList();
  }

  Future<List<model.Track>> getPlaylistAppTracks(int playlistId) async {
    final query =
        select(tracks).join([
            innerJoin(
              playlistTracks,
              playlistTracks.trackSpotifyId.equalsExp(tracks.spotifyId),
            ),
            leftOuterJoin(
              localFiles,
              localFiles.libraryId.equalsExp(tracks.spotifyId),
            ),
          ])
          ..where(playlistTracks.playlistId.equals(playlistId))
          ..orderBy([OrderingTerm.asc(playlistTracks.position)]);

    final rows = await query.get();
    return rows.map((row) {
      final t = _mapTrackWithLocal(row);
      final pt = row.readTable(playlistTracks);
      return t.copyWith(queueItemId: pt.id.toString());
    }).toList();
  }

  Future<model.Track?> getAppTrack(String id) async {
    final query = select(tracks).join([
      leftOuterJoin(localFiles, localFiles.libraryId.equalsExp(tracks.spotifyId))
    ])..where(tracks.spotifyId.equals(id));
    final row = await query.getSingleOrNull();
    return row == null ? null : _mapTrackWithLocal(row);
  }

  Future<List<model.Track>> getLocalAppTracks() async {
    final query = select(tracks).join([
      innerJoin(localFiles, localFiles.libraryId.equalsExp(tracks.spotifyId))
    ]);
    final rows = await query.get();
    return rows.map(_mapTrackWithLocal).toList();
  }

  /// All local tracks regardless of media type. Used by the unified "local"
  /// badge on the music card (count includes both audio and video).
  Stream<List<model.Track>> watchLocalAppTracks() {
    final query = select(tracks).join([
      innerJoin(localFiles, localFiles.libraryId.equalsExp(tracks.spotifyId))
    ]);
    return query.watch().map((rows) => rows.map(_mapTrackWithLocal).toList());
  }

  /// Audio-only local tracks (is_video = false). Drives all music library
  /// views: songs, albums, artists, genres, folders.
  Stream<List<model.Track>> watchLocalAudioTracks() {
    final query = select(tracks).join([
      innerJoin(localFiles, localFiles.libraryId.equalsExp(tracks.spotifyId))
    ])..where(localFiles.isVideo.equals(false));
    return query.watch().map((rows) => rows.map(_mapTrackWithLocal).toList());
  }

  /// Confirmed video local tracks (is_video = true). Drives the Videos library.
  Stream<List<model.Track>> watchLocalVideoTracks() {
    final query = select(tracks).join([
      innerJoin(localFiles, localFiles.libraryId.equalsExp(tracks.spotifyId))
    ])..where(localFiles.isVideo.equals(true));
    return query.watch().map((rows) => rows.map(_mapTrackWithLocal).toList());
  }

  /// Total count of local video tracks.
  Stream<int> watchLocalVideoTracksCount() {
    final countExp = tracks.spotifyId.count();
    final query = selectOnly(tracks).join([
      innerJoin(localFiles, localFiles.libraryId.equalsExp(tracks.spotifyId))
    ])
      ..addColumns([countExp])
      ..where(localFiles.isVideo.equals(true));
    return query.watchSingle().map((row) => row.read(countExp) ?? 0);
  }


  /// Audio-only tracks in a given album (is_video = false).
  Future<List<model.Track>> getAlbumAppTracks(String albumGroupKey) async {
    final query = select(tracks).join([
      innerJoin(localFiles, localFiles.libraryId.equalsExp(tracks.spotifyId))
    ])
      ..where(localFiles.albumGroupKey.equals(albumGroupKey))
      ..where(localFiles.isVideo.equals(false));
    final rows = await query.get();
    return rows.map(_mapTrackWithLocal).toList()..sort((a, b) => a.name.compareTo(b.name));
  }

  /// Audio-only tracks by a given artist (is_video = false).
  Future<List<model.Track>> getArtistAppTracks(String artistName) async {
    final query = select(tracks).join([
      innerJoin(localFiles, localFiles.libraryId.equalsExp(tracks.spotifyId))
    ])
      ..where(tracks.artistName.equals(artistName))
      ..where(localFiles.isVideo.equals(false));
    final rows = await query.get();
    return rows.map(_mapTrackWithLocal).toList()..sort((a, b) => a.name.compareTo(b.name));
  }

  /// Audio-only tracks in a given import-root folder (is_video = false).
  Future<List<model.Track>> getFolderAppTracks(String rootLocator) async {
    final query = select(tracks).join([
      innerJoin(localFiles, localFiles.libraryId.equalsExp(tracks.spotifyId))
    ])
      ..where(localFiles.importRootLocator.equals(rootLocator))
      ..where(localFiles.isVideo.equals(false));
    final rows = await query.get();
    return rows.map(_mapTrackWithLocal).toList()..sort((a, b) => a.name.compareTo(b.name));
  }

  /// Audio-only albums (is_video = false).
  Stream<List<LocalAlbum>> watchLocalAlbums() {
    final query = select(localFiles).join([
      innerJoin(tracks, tracks.spotifyId.equalsExp(localFiles.libraryId))
    ])
      ..addColumns([localFiles.albumGroupKey.count()])
      ..where(localFiles.isVideo.equals(false))
      ..groupBy([localFiles.albumGroupKey]);

    return query.watch().map((rows) {
      return rows.map((row) {
        final track = row.readTable(tracks);
        final local = row.readTable(localFiles);
        final count = row.read(localFiles.albumGroupKey.count()) ?? 0;
        return LocalAlbum(
          albumGroupKey: local.albumGroupKey ?? track.albumName ?? 'Unknown',
          title: track.albumName ?? 'Unknown Album',
          artist: local.albumArtist ?? track.artistName,
          artworkPath: local.artworkPath,
          trackCount: count,
          releaseYear: local.releaseYear,
        );
      }).toList();
    });
  }

  /// Audio-only artists (is_video = false).
  Stream<List<LocalArtist>> watchLocalArtists() {
    final query = select(tracks).join([
      innerJoin(localFiles, localFiles.libraryId.equalsExp(tracks.spotifyId))
    ])
      ..addColumns([tracks.artistName.count()])
      ..where(localFiles.isVideo.equals(false))
      ..groupBy([tracks.artistName]);

    return query.watch().map((rows) {
      return rows.map((row) {
        final track = row.readTable(tracks);
        final local = row.readTable(localFiles);
        final count = row.read(tracks.artistName.count()) ?? 0;
        return LocalArtist(
          name: track.artistName,
          trackCount: count,
          fallbackArtworkPath: local.artworkPath,
        );
      }).toList();
    });
  }

  /// Audio-only genres (is_video = false).
  Stream<List<LocalGenre>> watchLocalGenres() {
    final query = selectOnly(localFiles)
      ..addColumns([localFiles.genre, localFiles.genre.count()])
      ..where(localFiles.genre.isNotNull())
      ..where(localFiles.genre.equals('').not())
      ..where(localFiles.isVideo.equals(false))
      ..groupBy([localFiles.genre]);

    return query.watch().map((rows) {
      return rows.map((row) => LocalGenre(
        name: row.read(localFiles.genre)!,
        trackCount: row.read(localFiles.genre.count()) ?? 0,
      )).toList();
    });
  }

  /// Audio-only genre tracks (is_video = false).
  Future<List<model.Track>> getGenreAppTracks(String genre) async {
    final query = select(tracks).join([
      innerJoin(localFiles, localFiles.libraryId.equalsExp(tracks.spotifyId))
    ])
      ..where(localFiles.genre.equals(genre))
      ..where(localFiles.isVideo.equals(false));
    final rows = await query.get();
    return rows.map(_mapTrackWithLocal).toList()..sort((a, b) => a.name.compareTo(b.name));
  }

  /// Audio-only folders: roots that contain at least one audio track
  /// (is_video = false).
  Stream<List<LocalFolder>> watchLocalFolders() {
    final query = selectOnly(localFiles)
      ..addColumns([localFiles.importRootLocator])
      ..where(localFiles.isVideo.equals(false))
      ..groupBy([localFiles.importRootLocator]);

    return query.watch().map((rows) {
      return rows.map((row) {
        final locator = row.read(localFiles.importRootLocator);
        if (locator == null) {
          return const LocalFolder(
            path: 'imported',
            name: 'Imported Files',
          );
        }
        // Extract the last part of the path as the name. 
        // We will do a full folder tree in the UI provider, 
        // this is just the root folders for now.
        final uri = Uri.tryParse(locator) ?? Uri.file(locator);
        final name = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : locator;
        
        return LocalFolder(
          path: locator,
          name: name,
        );
      }).toList();
    });
  }

  Stream<List<TrackEntry>> watchPlaylistTracks(int playlistId) {
    final query =
        select(tracks).join([
            innerJoin(
              playlistTracks,
              playlistTracks.trackSpotifyId.equalsExp(tracks.spotifyId),
            ),
          ])
          ..where(playlistTracks.playlistId.equals(playlistId))
          ..orderBy([OrderingTerm.asc(playlistTracks.position)]);

    return query.watch().map(
      (rows) => rows.map((row) => row.readTable(tracks)).toList(),
    );
  }

  Stream<List<model.Track>> watchPlaylistAppTracks(int playlistId) {
    final query =
        select(tracks).join([
            innerJoin(
              playlistTracks,
              playlistTracks.trackSpotifyId.equalsExp(tracks.spotifyId),
            ),
            leftOuterJoin(
              localFiles,
              localFiles.libraryId.equalsExp(tracks.spotifyId),
            ),
          ])
          ..where(playlistTracks.playlistId.equals(playlistId))
          ..orderBy([OrderingTerm.asc(playlistTracks.position)]);

    return query.watch().map(
      (rows) => rows.map((row) {
        final t = _mapTrackWithLocal(row);
        final pt = row.readTable(playlistTracks);
        return t.copyWith(queueItemId: pt.id.toString());
      }).toList(),
    );
  }

  Future<int> createPlaylist(
    String name, {
    String? spotifyId,
    String? imageUrl,
  }) => into(playlists).insert(
    PlaylistsCompanion(
      name: Value(name),
      spotifyId: Value(spotifyId),
      imageUrl: Value(imageUrl),
    ),
  );

  Future<void> togglePlaylistLike(
    String spotifyId,
    bool value, {
    String? name,
    String? imageUrl,
  }) async {
    if (value) {
      // Like: create/add to playlists table if not exists
      final existing =
          await (select(playlists)
            ..where((p) => p.spotifyId.equals(spotifyId))).getSingleOrNull();
      if (existing == null) {
        await createPlaylist(
          name ?? 'Unnamed Playlist',
          spotifyId: spotifyId,
          imageUrl: imageUrl,
        );
      }
    } else {
      // Unlike: remove from playlists table
      await (delete(playlists)
        ..where((p) => p.spotifyId.equals(spotifyId))).go();
    }
  }

  Stream<bool> watchPlaylistIsFavorite(String spotifyId) {
    return (select(playlists)..where(
      (p) => p.spotifyId.equals(spotifyId),
    )).watch().map((list) => list.isNotEmpty);
  }

  Future<void> deletePlaylist(int id) async {
    await (delete(playlists)..where((p) => p.id.equals(id))).go();
    await (delete(playlistTracks)
      ..where((pt) => pt.playlistId.equals(id))).go();
  }

  Future<void> addToPlaylist(int playlistId, String spotifyId) async {
    // Get current max position
    final maxPosQuery =
        selectOnly(playlistTracks)
          ..addColumns([playlistTracks.position.max()])
          ..where(playlistTracks.playlistId.equals(playlistId));
    final maxPos =
        await maxPosQuery
            .map((row) => row.read(playlistTracks.position.max()))
            .getSingleOrNull() ??
        0;

    await into(playlistTracks).insert(
      PlaylistTracksCompanion(
        playlistId: Value(playlistId),
        trackSpotifyId: Value(spotifyId),
        position: Value(maxPos + 1),
      ),
      mode: InsertMode.insertOrIgnore,
    );
  }

  Future<void> syncPlaylistTracks(
    int playlistId,
    List<TracksCompanion> trackCompanions,
  ) async {
    await transaction(() async {
      // 1. Ensure all tracks exist in the main tracks table
      for (final companion in trackCompanions) {
        await into(tracks).insertOnConflictUpdate(companion);
      }

      // 2. Clear existing links for this playlist
      await (delete(playlistTracks)
        ..where((pt) => pt.playlistId.equals(playlistId))).go();

      // 3. Rebuild the playlist structure with correct ordering
      for (int i = 0; i < trackCompanions.length; i++) {
        await into(playlistTracks).insert(
          PlaylistTracksCompanion(
            playlistId: Value(playlistId),
            trackSpotifyId: Value(trackCompanions[i].spotifyId.value),
            position: Value(i),
          ),
        );
      }
    });
  }

  Future<void> reorderTracks(
    List<int> entryIdsInOrder,
  ) async {
    await transaction(() async {
      for (int i = 0; i < entryIdsInOrder.length; i++) {
        await (update(playlistTracks)..where(
          (pt) => pt.id.equals(entryIdsInOrder[i]),
        )).write(PlaylistTracksCompanion(position: Value(i)));
      }
    });
  }

  Future<void> removeFromPlaylist(int entryId) async {
    await (delete(playlistTracks)..where((pt) => pt.id.equals(entryId))).go();
  }

  // --- LocalFiles queries ---

  Future<LocalFile?> getLocalFile(String libraryId) =>
      (select(localFiles)
        ..where((f) => f.libraryId.equals(libraryId))).getSingleOrNull();

  Future<List<LocalFile>> getAllLocalFiles() => select(localFiles).get();

  Stream<List<LocalFile>> watchAllLocalFiles() => select(localFiles).watch();

  Future<LocalFile?> getLocalFileByDeduplicationKey(String key) =>
      (select(localFiles)
        ..where((f) => f.deduplicationKey.equals(key))).getSingleOrNull();

  /// Inserts a new local file record, or updates metadata fields on conflict.
  /// [addedAt] is intentionally excluded from the UPDATE so that re-scanning
  /// a file preserves the original import timestamp used for date-added sorting.
  /// [isVideo] is included: a re-probe during rescan may promote a file from
  /// audio to video (e.g. if it was imported before probing was implemented).
  Future<void> upsertLocalFile(LocalFilesCompanion entry) =>
      into(localFiles).insert(
        entry,
        onConflict: DoUpdate(
          (_) => LocalFilesCompanion(
            mechanism: entry.mechanism,
            locator: entry.locator,
            displayPath: entry.displayPath,
            deduplicationKey: entry.deduplicationKey,
            availabilityStatus: entry.availabilityStatus,
            lastScannedAt: entry.lastScannedAt,
            importRootLocator: entry.importRootLocator,
            albumArtist: entry.albumArtist,
            albumGroupKey: entry.albumGroupKey,
            trackNumber: entry.trackNumber,
            trackTotal: entry.trackTotal,
            discNumber: entry.discNumber,
            discTotal: entry.discTotal,
            genre: entry.genre,
            releaseYear: entry.releaseYear,
            artworkPath: entry.artworkPath,
            artworkMimeType: entry.artworkMimeType,
            isVideo: entry.isVideo,
            // addedAt intentionally absent — preserves the original import timestamp
          ),
          target: [localFiles.libraryId],
        ),
      );

  Future<void> updateLocalFileStatus(
    String libraryId,
    String status,
    DateTime scannedAt,
  ) =>
      (update(localFiles)
        ..where((f) => f.libraryId.equals(libraryId))).write(
        LocalFilesCompanion(
          availabilityStatus: Value(status),
          lastScannedAt: Value(scannedAt),
        ),
      );

  Future<void> deleteLocalFile(String libraryId) async {
    await (delete(localFiles)
      ..where((f) => f.libraryId.equals(libraryId))).go();
    // Also remove from Tracks so it disappears from playlists and history.
    await (delete(tracks)
      ..where((t) => t.spotifyId.equals(libraryId))).go();
  }

  Future<List<LocalFile>> getLocalFilesByImportRoot(String rootLocator) =>
      (select(localFiles)
        ..where((f) => f.importRootLocator.equals(rootLocator))).get();

  // --- ImportRoots queries ---

  Future<List<ImportRoot>> getAllImportRoots() => select(importRoots).get();

  Stream<List<ImportRoot>> watchImportRoots() => select(importRoots).watch();

  /// Inserts or updates an import root.  [mediaScope] is preserved on
  /// conflict — once a root is registered with a scope it keeps that scope
  /// across rescans unless the caller explicitly updates it.
  Future<void> upsertImportRoot(ImportRootsCompanion entry) =>
      into(importRoots).insert(
        entry,
        onConflict: DoUpdate(
          (_) => ImportRootsCompanion(
            mechanism: entry.mechanism,
            rootLocator: entry.rootLocator,
            displayPath: entry.displayPath,
            mediaScope: entry.mediaScope,
            // addedAt intentionally absent — preserves original import date
          ),
          target: [importRoots.id],
        ),
      );

  Future<void> deleteImportRoot(String id) =>
      (delete(importRoots)..where((r) => r.id.equals(id))).go();

  static QueryExecutor _openConnection(String? dbPath) {
    if (!kIsWeb && dbPath != null) {
      final file = File(p.join(dbPath, 'ppplayer_db.sqlite'));
      return NativeDatabase.createInBackground(file);
    }
    return driftDatabase(
      name: 'ppplayer_db',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    );
  }
}

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError('Override in ProviderScope');
});
