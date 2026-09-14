import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:drift/drift.dart' as drift;
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';

import '../db/app_database.dart';
import 'local_track_source.dart';
import 'metadata_extractor.dart';
import 'local_file_resolver.dart';

final localLibraryServiceProvider = Provider<LocalLibraryService>((ref) {
  return LocalLibraryService(ref.watch(appDatabaseProvider));
});

class LocalLibraryService {
  final AppDatabase _db;
  final Uuid _uuid = const Uuid();

  LocalLibraryService(this._db);

  /// Prompts the user to pick audio files and imports them.
  Future<void> importFiles() async {
    final result = await FilePicker.pickFiles(
      type: FileType.audio,
    );

    if (result.isEmpty) return;

    for (final file in result) {
      String locator = file.path!;
      TrackSourceType mechanism = TrackSourceType.absolutePath;
      
      if (Platform.isAndroid && locator.contains('/cache/')) {
        // Move temp file to our own managed sandbox so it survives
        final copyPath = await _moveToManagedCopy(locator, file.name);
        if (copyPath == null) continue;
        locator = copyPath;
        mechanism = TrackSourceType.managedCopy;
      } else if (Platform.isIOS || Platform.isMacOS) {
        // Request a security-scoped bookmark from native
        final bookmark = await createSecurityScopedBookmark(locator);
        if (bookmark != null) {
          locator = bookmark;
          mechanism = TrackSourceType.iOsSecurityBookmark;
        } else {
          // Fallback to absolute path (might not survive app restart on iOS)
          mechanism = TrackSourceType.absolutePath;
        }
      }
      
      await _processDiscoveredFile(
        locator: locator,
        displayPath: file.name,
        mechanism: mechanism,
        importRootLocator: null,
      );
    }
  }

  Future<void> importFolder() async {
    print('Opening FilePicker for directory...');
    final rootPath = await FilePicker.getDirectoryPath();
    print('FilePicker returned: $rootPath');
    if (rootPath == null) return;

    final String rootId = _uuid.v4();
    TrackSourceType rootMechanism = TrackSourceType.absolutePath;
    String rootLocator = rootPath;

    if (Platform.isAndroid) {
      // On Android getDirectoryPath returns the raw content:// tree URI.
      rootMechanism = TrackSourceType.androidContentUri;
      rootLocator = rootPath;
    } else if (Platform.isIOS || Platform.isMacOS) {
      final bookmark = await createSecurityScopedBookmark(rootPath);
      if (bookmark != null) {
        rootLocator = bookmark;
        rootMechanism = TrackSourceType.iOsSecurityBookmark;
      }
    }

    final root = ImportRootsCompanion.insert(
      id: rootId,
      mechanism: rootMechanism.name,
      rootLocator: rootLocator,
      displayPath: rootPath,
      addedAt: DateTime.now(),
    );
    await _db.upsertImportRoot(root);

    await _scanRoot(
      id: rootId,
      mechanism: rootMechanism,
      locator: rootLocator,
    );
  }

  Future<String?> _moveToManagedCopy(String tempPath, String name) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final targetDir = Directory('${appDir.path}/local_music');
      await targetDir.create(recursive: true);
      final targetPath = '${targetDir.path}/$name';
      await File(tempPath).copy(targetPath);
      return targetPath;
    } catch (_) {
      return null;
    }
  }

  Future<void> _scanRoot({
    required String id,
    required TrackSourceType mechanism,
    required String locator,
  }) async {
    List<String> files = [];

    if (mechanism == TrackSourceType.androidContentUri) {
      files = await listAudioFilesInDocumentTree(locator, recursive: true);
    } else {
      String pathToScan = locator;
      if (mechanism == TrackSourceType.iOsSecurityBookmark) {
        // We'd resolve the bookmark to get the absolute path to scan.
        // For simplicity assuming LocalFileResolver provides a public way, or we just
        // use a platform channel. But for now we only support macOS/Windows/Linux root scanning.
      }
      final dir = Directory(pathToScan);
      print('Scanning directory: $pathToScan, exists: ${await dir.exists()}');
      if (await dir.exists()) {
        final List<Directory> dirsToScan = [dir];
        while (dirsToScan.isNotEmpty) {
          final currentDir = dirsToScan.removeLast();
          try {
            await for (final entity in currentDir.list(recursive: false, followLinks: false)) {
              if (entity is Directory) {
                dirsToScan.add(entity);
              } else if (entity is File) {
                final ext = entity.path.toLowerCase();
                if (ext.endsWith('.mp3') || ext.endsWith('.m4a') || 
                    ext.endsWith('.flac') || ext.endsWith('.wav') ||
                    ext.endsWith('.aac') || ext.endsWith('.ogg')) {
                  files.add(entity.path);
                }
              }
            }
          } catch (e) {
            print('Skipping inaccessible directory \${currentDir.path}: $e');
          }
        }
      }
    }

    print('Found ${files.length} audio files');
    for (final f in files) {
      final fileMechanism = mechanism == TrackSourceType.androidContentUri
          ? TrackSourceType.androidContentUri
          : TrackSourceType.absolutePath;
      
      await _processDiscoveredFile(
        locator: f,
        displayPath: f,
        mechanism: fileMechanism,
        importRootLocator: locator,
      );
    }
  }

  Future<void> _processDiscoveredFile({
    required String locator,
    required String displayPath,
    required TrackSourceType mechanism,
    required String? importRootLocator,
  }) async {
    final dedupeKey = _hashLocator(locator);
    final existing = await _db.getLocalFileByDeduplicationKey(dedupeKey);
    final libraryId = existing?.libraryId ?? 'local:${_uuid.v4()}';
    
    String extractPath = locator;
    bool isTemp = false;
    if (mechanism == TrackSourceType.androidContentUri) {
      final temp = await copyContentUriToTempFile(locator, 'temp.audio');
      if (temp != null) {
        extractPath = temp;
        isTemp = true;
      } else {
        return;
      }
    }
    
    final metadata = await extractMetadata(extractPath);
    
    if (isTemp) {
      try { File(extractPath).deleteSync(); } catch (_) {}
    }
    
    await _db.upsertLocalFile(
      LocalFilesCompanion.insert(
        libraryId: libraryId,
        mechanism: mechanism.name,
        locator: locator,
        displayPath: displayPath,
        deduplicationKey: dedupeKey,
        availabilityStatus: const drift.Value('available'),
        lastScannedAt: DateTime.now(),
        importRootLocator: drift.Value(importRootLocator),
        albumArtist: drift.Value(metadata.albumArtist),
        albumGroupKey: drift.Value(metadata.albumGroupKey),
        trackNumber: drift.Value(metadata.trackNumber),
        trackTotal: drift.Value(metadata.trackTotal),
        discNumber: drift.Value(metadata.discNumber),
        discTotal: drift.Value(metadata.discTotal),
        genre: drift.Value(metadata.genre),
        releaseYear: drift.Value(metadata.year),
        artworkPath: drift.Value(metadata.artworkPath),
        artworkMimeType: drift.Value(metadata.artworkMimeType),
      )
    );
    
    await _db.into(_db.tracks).insertOnConflictUpdate(
      TracksCompanion.insert(
        spotifyId: libraryId,
        name: metadata.title,
        artistId: 'local',
        artistName: metadata.artistName,
        albumId: drift.Value(metadata.albumGroupKey),
        albumName: drift.Value(metadata.albumName),
        albumImage: drift.Value(metadata.artworkPath),
        durationMs: drift.Value(metadata.durationMs),
      )
    );
  }

  String _hashLocator(String loc) {
    return sha1.convert(utf8.encode(loc)).toString().substring(0, 16);
  }
}
