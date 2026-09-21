import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ppplayer/core/db/app_database.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

void main() {
  test(
    'V11 to V12 migration creates stream_playlists and stream_channels',
    () async {
      final sqliteDb = sqlite.sqlite3.openInMemory();

      // Set v11 schema explicitly
      sqliteDb.execute('PRAGMA user_version = 11;');

      // Simulate v11 tracks table
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
        last_played_at INTEGER,
        source_type TEXT NOT NULL DEFAULT 'spotify'
      );
    ''');

      // Create Drift database on top of this connection
      final db = AppDatabase.forTesting(NativeDatabase.opened(sqliteDb));

      // Let the migration run (invoked when the first query is made)
      await db.customSelect('SELECT 1').get();

      // Verify user_version is updated
      final versionResult = sqliteDb.select('PRAGMA user_version;');
      expect(versionResult.first.values.first, greaterThanOrEqualTo(12));

      // Verify stream_playlists table exists
      final playlistTableInfo = sqliteDb.select(
        "PRAGMA table_info('stream_playlists');",
      );
      expect(playlistTableInfo, isNotEmpty);
      final playlistCols = playlistTableInfo
          .map((row) => row['name'] as String)
          .toList();
      expect(
        playlistCols,
        containsAll([
          'id',
          'title',
          'source_kind',
          'source_uri',
          'last_refreshed',
        ]),
      );

      // Verify stream_channels table exists
      final channelTableInfo = sqliteDb.select(
        "PRAGMA table_info('stream_channels');",
      );
      expect(channelTableInfo, isNotEmpty);
      final channelCols = channelTableInfo
          .map((row) => row['name'] as String)
          .toList();
      expect(
        channelCols,
        containsAll([
          'id',
          'playlist_id',
          'title',
          'stream_url',
          'tvg_id',
          'logo',
          'group_title',
          'position',
        ]),
      );

      await db.close();
    },
  );
}
