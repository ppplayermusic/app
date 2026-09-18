// ignore_for_file: depend_on_referenced_packages
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ppplayer/core/db/app_database.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

void main() {
  test('V8 to V9 migration correctly backfills added_at', () async {
    // 1. Set up an authentic v8 database using pure sqlite3
    final sqliteDb = sqlite.sqlite3.openInMemory();
    
    // Set v8 schema explicitly
    sqliteDb.execute('PRAGMA user_version = 8;');

    sqliteDb.execute('''
      CREATE TABLE IF NOT EXISTS tracks (
        spotify_id TEXT NOT NULL PRIMARY KEY,
        name TEXT NOT NULL,
        artist_id TEXT NOT NULL,
        artist_name TEXT NOT NULL,
        album_id TEXT,
        album_name TEXT,
        album_image TEXT,
        duration_ms INTEGER,
        youtube_video_id TEXT,
        youtube_resolved_at INTEGER,
        play_count INTEGER NOT NULL DEFAULT 0,
        is_favorite INTEGER NOT NULL DEFAULT 0,
        last_played_at INTEGER
      );
    ''');

    sqliteDb.execute('''
      CREATE TABLE IF NOT EXISTS local_files (
        library_id TEXT NOT NULL PRIMARY KEY,
        mechanism TEXT NOT NULL,
        locator TEXT NOT NULL,
        display_path TEXT NOT NULL,
        deduplication_key TEXT NOT NULL,
        availability_status TEXT NOT NULL DEFAULT 'available',
        last_scanned_at INTEGER NOT NULL,
        import_root_locator TEXT,
        album_artist TEXT,
        album_group_key TEXT,
        track_number INTEGER,
        track_total INTEGER,
        disc_number INTEGER,
        disc_total INTEGER,
        genre TEXT,
        release_year INTEGER,
        artwork_path TEXT,
        artwork_mime_type TEXT
      );
    ''');

    sqliteDb.execute('''
      CREATE TABLE IF NOT EXISTS playlists (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        spotify_id TEXT,
        image_url TEXT,
        created_at INTEGER NOT NULL
      );
    ''');
    
    sqliteDb.execute('''
      CREATE TABLE IF NOT EXISTS playlist_tracks (
        playlist_id INTEGER NOT NULL,
        track_spotify_id TEXT NOT NULL,
        position INTEGER NOT NULL,
        PRIMARY KEY (playlist_id, track_spotify_id)
      );
    ''');

    sqliteDb.execute('''
      CREATE TABLE IF NOT EXISTS import_roots (
        id TEXT NOT NULL PRIMARY KEY,
        mechanism TEXT NOT NULL,
        root_locator TEXT NOT NULL,
        display_path TEXT NOT NULL,
        added_at INTEGER NOT NULL
      );
    ''');

    // Insert an online track
    sqliteDb.execute('''
      INSERT INTO tracks (spotify_id, name, artist_id, artist_name, play_count, is_favorite)
      VALUES ('online_1', 'Online Track', 'art_1', 'Artist', 0, 0);
    ''');

    // Insert a local track
    final scanTime = DateTime(2023, 1, 1).millisecondsSinceEpoch ~/ 1000;
    sqliteDb.execute('''
      INSERT INTO tracks (spotify_id, name, artist_id, artist_name, play_count, is_favorite)
      VALUES ('local:uuid1', 'Local Track', 'art_2', 'Local Artist', 0, 0);
    ''');

    // Insert v8 local_files record (NO added_at field yet)
    sqliteDb.execute('''
      INSERT INTO local_files (
        library_id, mechanism, locator, display_path, deduplication_key, 
        availability_status, last_scanned_at, genre
      ) VALUES (
        'local:uuid1', 'absolutePath', '/music/track.mp3', 'track.mp3', 'hash123',
        'available', $scanTime, 'Rock'
      );
    ''');

    // Insert playlist and membership
    sqliteDb.execute('''
      INSERT INTO playlists (id, name, created_at)
      VALUES (1, 'My Playlist', $scanTime);
    ''');
    sqliteDb.execute('''
      INSERT INTO playlist_tracks (playlist_id, track_spotify_id, position)
      VALUES (1, 'local:uuid1', 0);
    ''');

    // Insert import root
    sqliteDb.execute('''
      INSERT INTO import_roots (id, mechanism, root_locator, display_path, added_at)
      VALUES ('root1', 'absolutePath', '/music', '/music', $scanTime);
    ''');

    // 2. Wrap it with Drift and let it run migrations to v9
    final db = AppDatabase.forTesting(
      NativeDatabase.opened(sqliteDb, setup: (rawDb) {
        // Drift NativeDatabase might override PRAGMA user_version if we don't return it
        // but it reads it on open to know if it needs to migrate.
      })
    );
    addTearDown(db.close);

    // Give it a moment to run migrations on first query
    final tracks = await db.select(db.tracks).get();
    expect(tracks.length, 2);

    // 3. Verify addedAt backfilled correctly
    final localFiles = await db.select(db.localFiles).get();
    expect(localFiles.length, 1);
    
    final file = localFiles.first;
    expect(file.libraryId, 'local:uuid1');
    expect(file.addedAt, file.lastScannedAt, 
      reason: 'addedAt should be backfilled from lastScannedAt during v8->v9 migration'
    );
    
    // Verify relations survived
    final playlistTracks = await db.select(db.playlistTracks).get();
    expect(playlistTracks.length, 1);
    expect(playlistTracks.first.trackSpotifyId, 'local:uuid1');

    final roots = await db.select(db.importRoots).get();
    expect(roots.length, 1);

    // 4. Emulate a rescan update that changes lastScannedAt
    // The actual rescan path uses upsert, but we can verify at DB level first
    final newScanTime = DateTime(2024, 1, 1);
    await db.into(db.localFiles).insertOnConflictUpdate(
      LocalFilesCompanion.insert(
        libraryId: file.libraryId,
        mechanism: file.mechanism,
        locator: file.locator,
        displayPath: file.displayPath,
        deduplicationKey: file.deduplicationKey,
        lastScannedAt: newScanTime,
        // we deliberately omit addedAt to simulate typical update without overwriting it
      )
    );

    // Validate addedAt remained the original backfilled value, not the new scan time
    final updatedFiles = await db.select(db.localFiles).get();
    expect(updatedFiles.first.lastScannedAt, newScanTime);
    expect(updatedFiles.first.addedAt, file.addedAt, 
      reason: 'addedAt should not be overwritten by subsequent rescans'
    );
  });
}
