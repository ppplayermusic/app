import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:ppplayer/core/db/app_database.dart';
import 'package:ppplayer/core/local_library/local_library_service.dart';
import 'package:ppplayer/core/models/track.dart';
import 'package:path/path.dart' as p;
import 'package:ppplayer/core/local_library/local_track_source.dart' as ls;
import 'package:ppplayer/core/local_library/m3u_handler.dart';
import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';

extension TestLocalLibraryService on LocalLibraryService {
  Future<Track?> testProcessDiscoveredFile({
    required String locator,
    required String displayPath,
    required TrackSourceType mechanism,
    required String? importRootLocator,
  }) async {
    // using reflection or just bypassing private method
    // wait, we can just use importFiles or importFolder, or we can insert directly into DB for testing
    return null;
  }
}

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(drift.DatabaseConnection(NativeDatabase.memory()));
  });

  tearDown(() async {
    await db.close();
  });

  test('Duplicate operations: import, remove, reorder, export', () async {
    final service = LocalLibraryService(db);
    
    // 1. Setup dummy files
    final root = Directory.systemTemp.createTempSync('ppplayer_test_');
    final fileA = File(p.join(root.path, 'A.mp3'))..writeAsBytesSync([1, 2, 3]);
    final fileB = File(p.join(root.path, 'B.mp3'))..writeAsBytesSync([4, 5, 6]);

    // Add to DB manually for test
    final trackAId = 'local:A.mp3';
    final trackBId = 'local:B.mp3';
    await db.into(db.localFiles).insert(LocalFilesCompanion.insert(
      libraryId: trackAId, locator: fileA.path, displayPath: 'A.mp3', deduplicationKey: 'A', lastScannedAt: DateTime.now(), mechanism: ls.TrackSourceType.absolutePath.name,
    ));
    await db.into(db.tracks).insert(TracksCompanion.insert(
      spotifyId: trackAId, name: 'A', artistId: 'Artist', artistName: 'Artist', 
    ));
    
    await db.into(db.localFiles).insert(LocalFilesCompanion.insert(
      libraryId: trackBId, locator: fileB.path, displayPath: 'B.mp3', deduplicationKey: 'B', lastScannedAt: DateTime.now(), mechanism: ls.TrackSourceType.absolutePath.name,
    ));
    await db.into(db.tracks).insert(TracksCompanion.insert(
      spotifyId: trackBId, name: 'B', artistId: 'Artist', artistName: 'Artist',
    ));

    // 2. Create M3U with A, B, A
    final m3uFile = File(p.join(root.path, 'playlist.m3u'));
    m3uFile.writeAsStringSync('${fileA.path}\n${fileB.path}\n${fileA.path}\n');

    final playlistId = await service.processPlaylistFile(m3uFile.path, 'playlist.m3u');

    var tracks = await db.getPlaylistAppTracks(playlistId);
    expect(tracks.length, 3);
    
    final tIdA = tracks[0].spotifyId;
    final tIdB = tracks[1].spotifyId;
    
    expect(tracks[2].spotifyId, tIdA);
    expect(tIdA, isNot(equals(tIdB)));

    // 4. Remove second A
    // We need to remove the playlist track at position 2.
    // In our simplified test, we'll just delete the second occurrence by its playlist track row ID.
    final pTracks = await (db.select(db.playlistTracks)..where((t) => t.playlistId.equals(playlistId))).get();
    expect(pTracks.length, 3);
    await db.delete(db.playlistTracks).delete(pTracks[2]);

    // Verify 2 tracks remain: A, B
    tracks = await db.getPlaylistAppTracks(playlistId);
    expect(tracks.length, 2);
    expect(tracks[0].spotifyId, tIdA);
    expect(tracks[1].spotifyId, tIdB);

    // 5. Reorder B to index 0 -> B, A
    await (db.update(db.playlistTracks)..where((t) => t.id.equals(int.parse(tracks[1].queueItemId!)))).write(const PlaylistTracksCompanion(position: drift.Value(0)));
    await (db.update(db.playlistTracks)..where((t) => t.id.equals(int.parse(tracks[0].queueItemId!)))).write(const PlaylistTracksCompanion(position: drift.Value(1)));

    tracks = await db.getPlaylistAppTracks(playlistId);
    expect(tracks[0].spotifyId, tIdB);
    expect(tracks[1].spotifyId, tIdA);

    // 6. Export
    final destDir = Directory.systemTemp.createTempSync('ppplayer_export_');
    final result = M3uHandler.generate(tracks, exportDestinationDir: destDir.path);
    
    expect(result.content, contains('B.mp3'));
    expect(result.content, contains('A.mp3'));
    expect(result.content.indexOf('B.mp3'), lessThan(result.content.indexOf('A.mp3')));

    root.deleteSync(recursive: true);
    destDir.deleteSync(recursive: true);
  });

  test('Mobile file access: resolve using folder grant', () async {
    final service = LocalLibraryService(db);
    
    // Simulate folder grant by adding file to DB manually
    final displayPath = 'relative/song.mp3';
    final actualPath = '/storage/emulated/0/Music/relative/song.mp3';
    final trackId = 'local:song.mp3';
    
    await db.into(db.localFiles).insert(LocalFilesCompanion.insert(
      libraryId: trackId, locator: actualPath, displayPath: displayPath, deduplicationKey: 'C', lastScannedAt: DateTime.now(), mechanism: ls.TrackSourceType.androidContentUri.name, importRootLocator: const drift.Value('/storage/emulated/0/Music'),
    ));
    await db.into(db.tracks).insert(TracksCompanion.insert(
      spotifyId: trackId, name: 'Song', artistId: 'Artist', artistName: 'Artist',
    ));

    // Simulate picker giving a cache path
    final cacheDir = Directory(p.join(Directory.systemTemp.path, 'cache'));
    cacheDir.createSync();
    final cacheM3u = File(p.join(cacheDir.path, 'cache_playlist.m3u'));
    cacheM3u.writeAsStringSync('relative/song.mp3\n');

    // mechanism == managedCopy simulates temporary /cache/ file via the locator path check inside processPlaylistFile!
    final playlistId = await service.processPlaylistFile(cacheM3u.path, 'cache_playlist.m3u');

    var tracks = await db.getPlaylistAppTracks(playlistId);
    expect(tracks.length, 1);
    expect(tracks.first.spotifyId, trackId);

    cacheM3u.deleteSync();
  });
}
