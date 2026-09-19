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
import 'video_probe_service.dart';
import 'm3u_handler.dart';
import 'package:path/path.dart' as p;
import '../../features/library/video_thumbnail_generator.dart';

final localLibraryServiceProvider = Provider<LocalLibraryService>((ref) {
  return LocalLibraryService(ref.watch(appDatabaseProvider));
});

class LocalLibraryService {
  final AppDatabase _db;
  final Uuid _uuid = const Uuid();

  LocalLibraryService(this._db);

  Future<List<Track>> importFiles() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        ...AudioFormatRegistry.importCandidates,
        ...AudioFormatRegistry.videoImportCandidates,
      ].map((e) => e.replaceAll('.', '')).toSet().toList(),
    );

    if (result.isEmpty) return [];

    final importedTracks = <Track>[];

    for (final file in result) {
      String locator = file.path!;
      TrackSourceType mechanism = TrackSourceType.absolutePath;

      if (Platform.isAndroid && locator.contains('/cache/')) {
        final copyPath = await _moveToManagedCopy(locator, file.name);
        if (copyPath == null) continue;
        locator = copyPath;
        mechanism = TrackSourceType.managedCopy;
      } else if (Platform.isIOS || Platform.isMacOS) {
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
        displayPath: file.name,
        mechanism: mechanism,
        importRootLocator: null,
        scopeHint: ImportMediaScope.both,
      );

      if (track != null) {
        importedTracks.add(track);
      }
    }

    return importedTracks;
  }

  /// Prompts the user to pick video files and imports them.
  /// Files are probed for an actual video stream; audio-only containers will
  /// be imported without [isVideo] set and will not appear in the Videos library.
  Future<void> importVideoFiles() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: AudioFormatRegistry.videoImportCandidates
          .map((e) => e.replaceAll('.', ''))
          .toList(),
    );

    if (result.isEmpty) return;

    for (final file in result) {
      String locator = file.path!;
      TrackSourceType mechanism = TrackSourceType.absolutePath;

      if (Platform.isAndroid && locator.contains('/cache/')) {
        final copyPath = await _moveToManagedCopy(locator, file.name);
        if (copyPath == null) continue;
        locator = copyPath;
        mechanism = TrackSourceType.managedCopy;
      } else if (Platform.isIOS || Platform.isMacOS) {
        final bookmark = await createSecurityScopedBookmark(locator);
        if (bookmark != null) {
          locator = bookmark;
          mechanism = TrackSourceType.iOsSecurityBookmark;
        } else {
          mechanism = TrackSourceType.absolutePath;
        }
      }

      await _processDiscoveredFile(
        locator: locator,
        displayPath: file.name,
        mechanism: mechanism,
        importRootLocator: null,
        scopeHint: ImportMediaScope.video,
      );
    }
  }

  /// Imports files from specific paths (e.g., via macOS Open File command).
  /// [scopeHint] controls whether each file is probed for a video stream.
  /// Pass [ImportMediaScope.audio] for audio paths and [ImportMediaScope.video]
  /// for video paths.  [ImportMediaScope.both] triggers detection by extension.
  /// Returns the imported tracks.
  Future<List<Track>> importFilesByPaths(
    List<String> paths, {
    ImportMediaScope scopeHint = ImportMediaScope.both,
  }) async {
    final importedTracks = <Track>[];
    for (final path in paths) {
      String locator = path;
      TrackSourceType mechanism = TrackSourceType.absolutePath;

      if (Platform.isAndroid && locator.contains('/cache/')) {
        final copyPath = await _moveToManagedCopy(
          locator,
          path.split('/').last,
        );
        if (copyPath == null) continue;
        locator = copyPath;
        mechanism = TrackSourceType.managedCopy;
      } else if (Platform.isIOS || Platform.isMacOS) {
        final bookmark = await createSecurityScopedBookmark(locator);
        if (bookmark != null) {
          locator = bookmark;
          mechanism = TrackSourceType.iOsSecurityBookmark;
        } else {
          mechanism = TrackSourceType.absolutePath;
        }
      }

      // When scope is 'both', detect by extension.
      final resolvedScope = scopeHint == ImportMediaScope.both
          ? (AudioFormatRegistry.isVideoFormatCandidate(
                  AudioFormatRegistry.extensionOf(path),
                )
                ? ImportMediaScope.video
                : ImportMediaScope.audio)
          : scopeHint;

      final track = await _processDiscoveredFile(
        locator: locator,
        displayPath: path.split('/').last,
        mechanism: mechanism,
        importRootLocator: null,
        scopeHint: resolvedScope,
      );
      if (track != null) {
        importedTracks.add(track);
      }
    }
    return importedTracks;
  }

  /// Opens a folder picker and imports all audio files found recursively.
  Future<void> importFolder() async {
    await _pickAndImportFolder(scope: ImportMediaScope.audio);
  }

  /// Opens a folder picker and imports all video candidate files found
  /// recursively.  Each file is probed; audio-only containers are imported
  /// without [isVideo] set.
  Future<void> importVideoFolder() async {
    await _pickAndImportFolder(scope: ImportMediaScope.video);
  }

  Future<void> _pickAndImportFolder({required ImportMediaScope scope}) async {
    debugPrint('Opening FilePicker for directory (scope: ${scope.name})...');
    final rootPath = await FilePicker.getDirectoryPath(
      dialogTitle: 'Select folder to import',
    );
    debugPrint('FilePicker returned: $rootPath');
    if (rootPath == null) return;

    final String rootId = _uuid.v4();
    TrackSourceType rootMechanism = TrackSourceType.absolutePath;
    String rootLocator = rootPath;

    if (Platform.isAndroid) {
      rootMechanism = TrackSourceType.androidContentUri;
      rootLocator = rootPath;
    } else if (Platform.isIOS || Platform.isMacOS) {
      final bookmark = await createSecurityScopedBookmark(rootPath);
      if (bookmark != null) {
        rootLocator = bookmark;
        rootMechanism = TrackSourceType.iOsSecurityBookmark;
      }
    }

    // Check for an existing root at this path to avoid duplicate library records.
    // If one already exists with a different scope, promote it to 'both'.
    final existing = await _db
        .select(_db.importRoots)
        .get()
        .then(
          (roots) =>
              roots.where((r) => r.rootLocator == rootLocator).firstOrNull,
        );

    final String effectiveRootId;
    final ImportMediaScope effectiveScope;

    if (existing != null) {
      effectiveRootId = existing.id;
      final existingScope = ImportMediaScope.values.byName(existing.mediaScope);
      effectiveScope = (existingScope == scope) ? scope : ImportMediaScope.both;
    } else {
      effectiveRootId = rootId;
      effectiveScope = scope;
    }

    final root = ImportRootsCompanion.insert(
      id: effectiveRootId,
      mechanism: rootMechanism.name,
      rootLocator: rootLocator,
      displayPath: rootPath,
      addedAt: existing != null ? existing.addedAt : DateTime.now(),
      mediaScope: drift.Value(effectiveScope.name),
    );
    await _db.upsertImportRoot(root);

    await _scanRoot(
      id: effectiveRootId,
      mechanism: rootMechanism,
      locator: rootLocator,
      scope: effectiveScope,
    );
  }

  Future<void> importPlaylist({void Function(String?)? onProgress}) async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['m3u', 'm3u8'],
    );

    if (result.isEmpty) return;
    final file = result.first;
    await processPlaylistFile(file.path!, file.name, onProgress: onProgress);
  }

  Future<int> processPlaylistFile(
    String filePath,
    String fileName, {
    void Function(String?)? onProgress,
  }) async {
    String locator = filePath;
    TrackSourceType mechanism = TrackSourceType.absolutePath;

    if (Platform.isAndroid && locator.contains('/cache/')) {
      final copyPath = await _moveToManagedCopy(locator, fileName);
      if (copyPath == null) throw Exception('Failed to read playlist from URI');
      locator = copyPath;
      mechanism = TrackSourceType.managedCopy;
    } else if (Platform.isIOS || Platform.isMacOS) {
      final bookmark = await createSecurityScopedBookmark(locator);
      if (bookmark != null) {
        locator = bookmark;
        mechanism = TrackSourceType.iOsSecurityBookmark;
      }
    }

    onProgress?.call('Importing playlist...');

    final bytes = await File(locator).readAsBytes();
    final isTemporary =
        locator.contains('/cache/') ||
        locator.contains('/tmp/') ||
        mechanism == TrackSourceType.managedCopy;
    final sourceLocation = isTemporary ? null : locator;
    final entries = await M3uHandler.parse(
      bytes,
      sourceLocation: sourceLocation,
    );

    onProgress?.call('Scanning ${entries.length} items...');

    final playlistName = fileName.replaceAll(RegExp(r'\.m3u8?$'), '');
    final playlistId = await _db
        .into(_db.playlists)
        .insert(
          PlaylistsCompanion.insert(
            name: playlistName,
            createdAt: drift.Value(DateTime.now()),
          ),
        );

    int processed = 0;
    for (final entry in entries) {
      onProgress?.call('Importing track ${processed + 1}/${entries.length}...');
      final trackMechanism =
          mechanism == TrackSourceType.androidContentUri &&
              entry.pathOrUri.startsWith('content://')
          ? TrackSourceType.androidContentUri
          : TrackSourceType.absolutePath;

      final dedupeKey = _hashLocator(entry.pathOrUri);
      var existingFile = await _db.getLocalFileByDeduplicationKey(dedupeKey);

      if (existingFile == null && isTemporary) {
        final searchPath = entry.pathOrUri.replaceAll('\\', '/');
        final query = _db.select(_db.localFiles)
          ..where((f) => f.locator.like('%$searchPath'));
        final results = await query.get();
        if (results.isNotEmpty) {
          existingFile = results.first;
        }
      }

      String spotifyId;
      if (existingFile != null) {
        spotifyId = existingFile.libraryId;
      } else {
        final track = await _processDiscoveredFile(
          locator: entry.pathOrUri,
          displayPath: entry.pathOrUri.split(Platform.pathSeparator).last,
          mechanism: trackMechanism,
          importRootLocator: null,
        );
        if (track == null) {
          processed++;
          continue;
        }
        spotifyId = track.spotifyId;
      }

      await _db
          .into(_db.playlistTracks)
          .insert(
            PlaylistTracksCompanion.insert(
              playlistId: playlistId,
              trackSpotifyId: spotifyId,
              position: processed,
            ),
          );

      processed++;
    }
    onProgress?.call(null);
    return playlistId;
  }

  Future<M3uExportResult?> exportPlaylist(int playlistId) async {
    final playlistTracks = await _db.getPlaylistAppTracks(playlistId);
    if (playlistTracks.isEmpty) return null;

    final playlist = await (_db.select(
      _db.playlists,
    )..where((p) => p.id.equals(playlistId))).getSingle();

    final destDir = await FilePicker.getDirectoryPath(
      dialogTitle: 'Select export directory',
    );
    if (destDir == null) return null;

    final result = M3uHandler.generate(
      playlistTracks,
      exportDestinationDir: destDir,
    );
    final outputFile = p.join(destDir, '${playlist.name}.m3u8');

    await File(outputFile).writeAsString(result.content);
    return result;
  }

  Future<M3uExportResult?> exportQueue(List<Track> queueTracks) async {
    if (queueTracks.isEmpty) return null;

    final destDir = await FilePicker.getDirectoryPath(
      dialogTitle: 'Select export directory',
    );
    if (destDir == null) return null;

    final result = M3uHandler.generate(
      queueTracks,
      exportDestinationDir: destDir,
    );
    final outputFile = p.join(destDir, 'queue.m3u8');

    await File(outputFile).writeAsString(result.content);
    return result;
  }

  Future<void> rescanLibrary({void Function(String?)? onProgress}) async {
    final existingRoots = await _db.select(_db.importRoots).get();
    final existingFiles = await _db.select(_db.localFiles).get();

    for (final root in existingRoots) {
      onProgress?.call('Scanning folder: ${root.displayPath}...');
      final mechanism = TrackSourceType.values.byName(root.mechanism);
      // Restore persisted scope — never re-infer from extensions.
      final scope = ImportMediaScope.values.byName(root.mediaScope);
      await _scanRoot(
        id: root.id,
        mechanism: mechanism,
        locator: root.rootLocator,
        scope: scope,
      );
    }

    // Verify standalone files
    int verified = 0;
    for (final file in existingFiles) {
      if (file.importRootLocator != null) continue; // Handled by folder scan

      onProgress?.call(
        'Verifying standalone files ($verified/${existingFiles.length})...',
      );
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
        await _db
            .update(_db.localFiles)
            .replace(file.copyWith(availabilityStatus: status.name));
      } else {
        await _db
            .update(_db.localFiles)
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
    ImportMediaScope scope = ImportMediaScope.audio,
  }) async {
    List<String> files = [];

    if (mechanism == TrackSourceType.androidContentUri) {
      // Android: listAudioFilesInDocumentTree already filters by audio extensions.
      // For video scope we'd need a separate call — for now, audio only on Android
      // content URIs (video import via content:// is an edge case).
      files = await listAudioFilesInDocumentTree(locator, recursive: true);
    } else {
      String pathToScan = locator;
      if (mechanism == TrackSourceType.iOsSecurityBookmark) {
        // We'd resolve the bookmark to get the absolute path to scan.
        // For simplicity assuming LocalFileResolver provides a public way, or we just
        // use a platform channel. But for now we only support macOS/Windows/Linux root scanning.
      }
      final dir = Directory(pathToScan);
      debugPrint(
        'Scanning directory: $pathToScan, exists: ${await dir.exists()} scope: ${scope.name}',
      );
      if (await dir.exists()) {
        final List<Directory> dirsToScan = [dir];
        while (dirsToScan.isNotEmpty) {
          final currentDir = dirsToScan.removeLast();
          try {
            await for (final entity in currentDir.list(
              recursive: false,
              followLinks: false,
            )) {
              if (entity is Directory) {
                dirsToScan.add(entity);
              } else if (entity is File) {
                final ext = AudioFormatRegistry.extensionOf(entity.path);
                final isAudioExt =
                    AudioFormatRegistry.isRecognizedImportCandidate(ext);
                final isVideoExt = AudioFormatRegistry.isVideoFormatCandidate(
                  ext,
                );
                final include =
                    (scope.includesAudio && isAudioExt) ||
                    (scope.includesVideo && isVideoExt);
                if (include) {
                  files.add(entity.path);
                }
              }
            }
          } catch (e) {
            debugPrint(
              'Skipping inaccessible directory ${currentDir.path}: $e',
            );
          }
        }
      }
    }

    debugPrint('Found ${files.length} media files (scope: ${scope.name})');
    for (final f in files) {
      final fileMechanism = mechanism == TrackSourceType.androidContentUri
          ? TrackSourceType.androidContentUri
          : TrackSourceType.absolutePath;
      final ext = AudioFormatRegistry.extensionOf(f);
      final fileScope = AudioFormatRegistry.isVideoFormatCandidate(ext)
          ? ImportMediaScope.video
          : ImportMediaScope.audio;
      await _processDiscoveredFile(
        locator: f,
        displayPath: f,
        mechanism: fileMechanism,
        importRootLocator: locator,
        scopeHint: fileScope,
      );
    }
  }

  /// Processes a single discovered file: deduplicates, extracts metadata,
  /// probes for video stream (when [scopeHint] is [ImportMediaScope.video] or
  /// the extension is a video candidate), and upserts to DB.
  ///
  /// [scopeHint] drives probing:
  /// - [ImportMediaScope.audio]: skips video probe entirely.
  /// - [ImportMediaScope.video]: always probes regardless of extension.
  /// - [ImportMediaScope.both]: probes only when extension is a video candidate.
  Future<Track?> _processDiscoveredFile({
    required String locator,
    required String displayPath,
    required TrackSourceType mechanism,
    required String? importRootLocator,
    ImportMediaScope scopeHint = ImportMediaScope.audio,
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

    var metadata = await extractMetadata(extractPath);

    // --- Video probe ---
    // Determine whether to probe based on scope and extension.
    final ext = AudioFormatRegistry.extensionOf(locator);
    final shouldProbe =
        scopeHint == ImportMediaScope.video ||
        (scopeHint == ImportMediaScope.both &&
            AudioFormatRegistry.isVideoFormatCandidate(ext));

    bool isVideo = false;
    if (shouldProbe) {
      // Build a URI suitable for media_kit.
      final probeUri = mechanism == TrackSourceType.androidContentUri
          ? locator // content:// URI passed directly
          : Uri.file(extractPath).toString();

      final probeResult = await VideoProbeService.probe(probeUri);
      switch (probeResult) {
        case VideoProbeResult.hasVideo:
          isVideo = true;
          if (metadata.artworkPath == null) {
            final thumbPath =
                await VideoThumbnailGenerator.generateAndSaveThumbnail(
                  extractPath,
                );
            if (thumbPath != null) {
              metadata = ExtractedMetadata(
                title: metadata.title,
                artistName: metadata.artistName,
                albumArtist: metadata.albumArtist,
                albumName: metadata.albumName,
                albumGroupKey: metadata.albumGroupKey,
                year: metadata.year,
                genre: metadata.genre,
                trackNumber: metadata.trackNumber,
                trackTotal: metadata.trackTotal,
                discNumber: metadata.discNumber,
                discTotal: metadata.discTotal,
                durationMs: metadata.durationMs,
                artworkPath: thumbPath,
                artworkMimeType: 'image/jpeg',
              );
            }
          }
        case VideoProbeResult.audioOnly:
          isVideo = false;
          debugPrint(
            'VideoProbe: $displayPath is audio-only (no video stream)',
          );
        case VideoProbeResult.probeFailed:
          // Failed probe: leave isVideo=false (safe default; will stay in audio
          // library or remain unclassified until a future rescan).
          debugPrint(
            'VideoProbe: $displayPath probe failed/timed out; defaulting to audio',
          );
        case VideoProbeResult.cancelled:
          debugPrint('VideoProbe: $displayPath probe cancelled');
      }
    }

    if (isTemp) {
      try {
        File(extractPath).deleteSync();
      } catch (_) {}
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
        isVideo: drift.Value(isVideo),
      ),
    );

    await _db
        .into(_db.tracks)
        .insertOnConflictUpdate(
          TracksCompanion.insert(
            spotifyId: libraryId,
            name: metadata.title,
            artistId: 'local',
            artistName: metadata.artistName,
            albumId: drift.Value(metadata.albumGroupKey),
            albumName: drift.Value(metadata.albumName),
            albumImage: drift.Value(metadata.artworkPath),
            durationMs: drift.Value(metadata.durationMs),
          ),
        );

    return Track.fromLocalFile(
      libraryId: libraryId,
      name: metadata.title,
      artistName: metadata.artistName,
      albumName: metadata.albumName,
      localFilePath: locator,
      localArtworkPath: metadata.artworkPath,
      durationMs: metadata.durationMs,
      isVideoFile: isVideo,
    );
  }

  String _hashLocator(String loc) {
    return sha1.convert(utf8.encode(loc)).toString().substring(0, 16);
  }
}
