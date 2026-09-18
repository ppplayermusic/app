import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:drift/drift.dart' as drift;
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';

import 'package:ppplayer/core/db/app_database.dart';
import 'package:ppplayer/core/models/track.dart' show Track;
import 'local_track_source.dart';
import 'metadata_extractor.dart';
import 'local_file_resolver.dart';
import 'audio_format_registry.dart';

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
      type: FileType.custom,
      allowedExtensions: AudioFormatRegistry.importCandidates.map((e) => e.replaceAll('.', '')).toList(),
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

  /// Imports files from specific paths (e.g., via macOS Open With).
  /// Returns the imported tracks.
  Future<List<Track>> importFilesByPaths(List<String> paths) async {
    final importedTracks = <Track>[];
    for (final path in paths) {
      String locator = path;
      TrackSourceType mechanism = TrackSourceType.absolutePath;
      
      if (Platform.isAndroid && locator.contains('/cache/')) {
        // Move temp file to our own managed sandbox so it survives
        final copyPath = await _moveToManagedCopy(locator, path.split('/').last);
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
          mechanism = TrackSourceType.absolutePath;
        }
      }
      
      final track = await _processDiscoveredFile(
        locator: locator,
        displayPath: path.split('/').last,
        mechanism: mechanism,
        importRootLocator: null,
      );
      if (track != null) {
        importedTracks.add(track);
      }
    }
    return importedTracks;
  }

  Future<void> importFolder() async {
    debugPrint('Opening FilePicker for directory...');
    final rootPath = await FilePicker.getDirectoryPath();
    debugPrint('FilePicker returned: $rootPath');
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

  Future<void> rescanLibrary({void Function(String?)? onProgress}) async {
    final existingRoots = await _db.select(_db.importRoots).get();
    final existingFiles = await _db.select(_db.localFiles).get();

    for (final root in existingRoots) {
      onProgress?.call('Scanning folder: ${root.displayPath}...');
      final mechanism = TrackSourceType.values.byName(root.mechanism);
      await _scanRoot(id: root.id, mechanism: mechanism, locator: root.rootLocator);
    }
    
    // Verify standalone files
    int verified = 0;
    for (final file in existingFiles) {
      if (file.importRootLocator != null) continue; // Handled by folder scan
      
      onProgress?.call('Verifying standalone files ($verified/${existingFiles.length})...');
      final mechanism = TrackSourceType.values.byName(file.mechanism);
      
      final source = LocalTrackSource(
        libraryId: file.libraryId,
        locator: file.locator,
        displayPath: file.displayPath,
        mechanism: mechanism,
        deduplicationKey: file.deduplicationKey,
        lastScannedAt: file.lastScannedAt,
        availabilityStatus: TrackAvailabilityStatus.values.firstWhere(
          (e) => e.name == file.availabilityStatus,
          orElse: () => TrackAvailabilityStatus.available,
        ),
        importRootLocator: file.importRootLocator,
      );
      final resolver = LocalFileResolver.forSource(source);
      final status = await resolver.checkAccess(source);
      
      if (status != TrackAvailabilityStatus.available) {
        await _db.update(_db.localFiles)
          .replace(file.copyWith(availabilityStatus: status.name));
      } else {
        await _db.update(_db.localFiles)
          .replace(file.copyWith(availabilityStatus: 'available'));
      }
      verified++;
    }
    onProgress?.call(null);
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
      debugPrint('Scanning directory: $pathToScan, exists: ${await dir.exists()}');
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
                if (AudioFormatRegistry.isRecognizedImportCandidate(ext)) {
                  files.add(entity.path);
                }
              }
            }
          } catch (e) {
            debugPrint('Skipping inaccessible directory \${currentDir.path}: $e');
          }
        }
      }
    }

    debugPrint('Found ${files.length} audio files');
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

  Future<Track?> _processDiscoveredFile({
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
        return null;
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

    return Track(
      spotifyId: libraryId,
      name: metadata.title,
      artistId: 'local',
      artistName: metadata.artistName,
      albumId: metadata.albumGroupKey,
      albumName: metadata.albumName,
      albumImage: metadata.artworkPath,
      durationMs: metadata.durationMs,
    );
  }

  String _hashLocator(String loc) {
    return sha1.convert(utf8.encode(loc)).toString().substring(0, 16);
  }
}
