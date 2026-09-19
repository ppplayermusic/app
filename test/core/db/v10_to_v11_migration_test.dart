import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ppplayer/core/db/app_database.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

void main() {
  test('V10 to V11 migration correctly adds is_video to local_files', () async {
    final sqliteDb = sqlite.sqlite3.openInMemory();

    // Set v10 schema explicitly
    sqliteDb.execute('PRAGMA user_version = 10;');

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
        added_at INTEGER,
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
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        playlist_id INTEGER NOT NULL,
        track_spotify_id TEXT NOT NULL,
        local_file_id TEXT,
        position INTEGER NOT NULL,
        added_at INTEGER,
        UNIQUE (playlist_id, track_spotify_id)
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

    sqliteDb.execute('''
      INSERT INTO local_files (library_id, mechanism, locator, display_path, deduplication_key, availability_status, last_scanned_at, added_at)
      VALUES ('local:uuid1', 'absolutePath', '/tmp/foo.mp3', 'foo.mp3', 'dedup_1', 'available', 1000, 1000);
    ''');

    // Migrate to v11
    final db = AppDatabase.forTesting(
      DatabaseConnection(NativeDatabase.opened(sqliteDb)),
    );

    // Force migration by performing a query
    final localFiles = await db.select(db.localFiles).get();
    expect(localFiles.length, 1);

    // Check that isVideo is false by default
    expect(localFiles.first.isVideo, false);

    // Verify mediaScope persists
    final importRoots = await db.select(db.importRoots).get();
    expect(importRoots.isEmpty, true);

    await db
        .into(db.importRoots)
        .insert(
          ImportRootsCompanion.insert(
            id: 'root_1',
            mechanism: 'absolutePath',
            rootLocator: '/tmp/video',
            displayPath: 'video',
            addedAt: DateTime.now(),
            mediaScope: const Value('video'),
          ),
        );

    final insertedRoots = await db.select(db.importRoots).get();
    expect(insertedRoots.length, 1);
    expect(insertedRoots.first.mediaScope, 'video');

    await db.close();
  });
}
