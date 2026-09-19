import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ppplayer/core/db/app_database.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

void main() {
  test(
    'V9 to V10 migration correctly adds id to playlist_tracks and preserves relationships',
    () async {
      final sqliteDb = sqlite.sqlite3.openInMemory();

      // Set v9 schema explicitly
      sqliteDb.execute('PRAGMA user_version = 9;');

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
      CREATE TABLE IF NOT EXISTS import_roots (
        id TEXT NOT NULL PRIMARY KEY,
        mechanism TEXT NOT NULL,
        root_locator TEXT NOT NULL,
        display_path TEXT NOT NULL,
        added_at INTEGER NOT NULL
      );
    ''');

      sqliteDb.execute('''
      CREATE TABLE IF NOT EXISTS playlist_tracks (
        playlist_id INTEGER NOT NULL,
        track_spotify_id TEXT NOT NULL,
        local_file_id TEXT,
        position INTEGER NOT NULL,
        added_at INTEGER,
        PRIMARY KEY (playlist_id, track_spotify_id)
      );
    ''');

      sqliteDb.execute('''
      INSERT INTO tracks (spotify_id, name, artist_id, artist_name, play_count, is_favorite)
      VALUES ('track1', 'Track 1', 'art_1', 'Artist 1', 0, 0);
    ''');
      sqliteDb.execute('''
      INSERT INTO tracks (spotify_id, name, artist_id, artist_name, play_count, is_favorite)
      VALUES ('track2', 'Track 2', 'art_2', 'Artist 2', 0, 0);
    ''');

      sqliteDb.execute('''
      INSERT INTO playlists (id, name, created_at)
      VALUES (1, 'My Playlist', 1000);
    ''');

      sqliteDb.execute('''
      INSERT INTO playlist_tracks (playlist_id, track_spotify_id, position, added_at)
      VALUES (1, 'track1', 0, 2000);
    ''');
      sqliteDb.execute('''
      INSERT INTO playlist_tracks (playlist_id, track_spotify_id, position, added_at)
      VALUES (1, 'track2', 1, 3000);
    ''');

      // Migrate to v10
      final db = AppDatabase.forTesting(
        DatabaseConnection(NativeDatabase.opened(sqliteDb)),
      );

      // Force migration by performing a query
      final playlists = await db.select(db.playlists).get();
      expect(playlists.length, 1);

      final pTracks =
          await (db.select(db.playlistTracks)..orderBy([
                (t) => OrderingTerm(
                  expression: t.position,
                  mode: OrderingMode.asc,
                ),
              ]))
              .get();

      // Check that there are two tracks and they have sequential IDs
      expect(pTracks.length, 2);
      expect(pTracks[0].trackSpotifyId, 'track1');
      expect(pTracks[0].id, isNot(equals(0)));
      expect(pTracks[1].trackSpotifyId, 'track2');
      expect(pTracks[1].id, isNot(equals(0)));

      expect(pTracks[0].id, isNot(equals(pTracks[1].id)));

      await db.close();
    },
  );
}
