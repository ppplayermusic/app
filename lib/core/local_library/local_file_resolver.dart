// lib/core/local_library/local_file_resolver.dart
//
// Platform-aware file access abstraction.
// - Never constructs media URIs by string interpolation.
// - Uses Uri.file() for absolute paths (handles spaces, Unicode, Windows paths).
// - Passes Android content:// URIs opaquely to libmpv which handles them.
// - iOS security-scoped bookmarks are resolved to absolute paths via MethodChannel.

import 'dart:io';
import 'package:flutter/services.dart';
import 'local_track_source.dart';

/// Sealed result from resolving a local source into a playable URI.
sealed class LocalFileResult {}

class LocalFileReady extends LocalFileResult {
  /// The URI string to pass to media_kit's Media(). Never hand-constructed —
  /// always Uri.file(path).toString() or an opaque content:// URI.
  final String mediaUri;
  final String? artworkAbsolutePath;

  LocalFileReady({required this.mediaUri, this.artworkAbsolutePath});
}

class LocalFileMissing extends LocalFileResult {
  final TrackAvailabilityStatus status;
  final String message;
  LocalFileMissing({required this.status, required this.message});
}

/// Resolves a [LocalTrackSource] to a playable URI using the correct mechanism.
abstract class LocalFileResolver {
  Future<LocalFileResult> resolve(LocalTrackSource source);
  Future<TrackAvailabilityStatus> checkAccess(LocalTrackSource source);

  factory LocalFileResolver.forSource(LocalTrackSource source) {
    return switch (source.mechanism) {
      TrackSourceType.absolutePath => _AbsolutePathResolver(),
      TrackSourceType.managedCopy => _AbsolutePathResolver(),
      TrackSourceType.androidContentUri => _AndroidContentUriResolver(),
      TrackSourceType.iOsSecurityBookmark => _IOsBookmarkResolver(),
    };
  }
}

// ---------------------------------------------------------------------------
// Absolute path resolver (macOS, Windows, Linux, managed copies)
// ---------------------------------------------------------------------------

class _AbsolutePathResolver implements LocalFileResolver {
  @override
  Future<LocalFileResult> resolve(LocalTrackSource source) async {
    final status = await checkAccess(source);
    if (status != TrackAvailabilityStatus.available) {
      return LocalFileMissing(status: status, message: source.displayPath);
    }
    return LocalFileReady(mediaUri: Uri.file(source.locator).toString());
  }

  @override
  Future<TrackAvailabilityStatus> checkAccess(LocalTrackSource source) async {
    try {
      if (await File(source.locator).exists()) {
        return TrackAvailabilityStatus.available;
      }
      return TrackAvailabilityStatus.missing;
    } catch (_) {
      return TrackAvailabilityStatus.permissionRevoked;
    }
  }
}

// ---------------------------------------------------------------------------
// Android content URI resolver
// ---------------------------------------------------------------------------
// media_kit (libmpv) on Android can open content:// URIs directly via its
// Android MediaDataSource binding. We pass the URI string as-is to Media().
// Folder scanning uses the separate LocalFileScanner MethodChannel which calls
// DocumentFile.listFiles() — not Directory.list() which cannot traverse
// document-provider trees.

class _AndroidContentUriResolver implements LocalFileResolver {
  @override
  Future<LocalFileResult> resolve(LocalTrackSource source) async {
    final status = await checkAccess(source);
    if (status != TrackAvailabilityStatus.available) {
      return LocalFileMissing(status: status, message: source.displayPath);
    }
    // Pass content:// URI opaquely; libmpv handles it on Android.
    return LocalFileReady(mediaUri: source.locator);
  }

  @override
  Future<TrackAvailabilityStatus> checkAccess(LocalTrackSource source) async {
    if (!Platform.isAndroid) return TrackAvailabilityStatus.permissionRevoked;
    try {
      final ok = await _LocalFilesChannel.canReadContentUri(source.locator);
      return ok
          ? TrackAvailabilityStatus.available
          : TrackAvailabilityStatus.missing;
    } catch (_) {
      return TrackAvailabilityStatus.permissionRevoked;
    }
  }
}

// ---------------------------------------------------------------------------
// iOS / macOS security-scoped bookmark resolver
// ---------------------------------------------------------------------------
// 1. At import time, UIDocumentPickerViewController returns an NSURL.
//    We obtain NSData bookmark via bookmarkData(options:) and store it base64.
// 2. At access time, we call startAccessingSecurityScopedResource() via
//    MethodChannel and receive the resolved absolute path.
// 3. The path is converted to a URI via Uri.file() for media_kit.

class _IOsBookmarkResolver implements LocalFileResolver {
  @override
  Future<LocalFileResult> resolve(LocalTrackSource source) async {
    if (!Platform.isIOS && !Platform.isMacOS) {
      return LocalFileMissing(
        status: TrackAvailabilityStatus.permissionRevoked,
        message: 'iOS/macOS bookmark on unsupported platform',
      );
    }
    try {
      final path = await _LocalFilesChannel.resolveBookmark(source.locator);
      if (path == null) {
        return LocalFileMissing(
          status: TrackAvailabilityStatus.missing,
          message: source.displayPath,
        );
      }
      return LocalFileReady(mediaUri: Uri.file(path).toString());
    } on _BookmarkError catch (e) {
      return LocalFileMissing(status: e.status, message: source.displayPath);
    }
  }

  @override
  Future<TrackAvailabilityStatus> checkAccess(LocalTrackSource source) async {
    if (!Platform.isIOS && !Platform.isMacOS) {
      return TrackAvailabilityStatus.permissionRevoked;
    }
    try {
      final path = await _LocalFilesChannel.resolveBookmark(source.locator);
      return path != null
          ? TrackAvailabilityStatus.available
          : TrackAvailabilityStatus.missing;
    } on _BookmarkError catch (e) {
      return e.status;
    }
  }
}

// ---------------------------------------------------------------------------
// MethodChannel stubs — native implementations needed per platform
// ---------------------------------------------------------------------------

class _BookmarkError implements Exception {
  final TrackAvailabilityStatus status;
  _BookmarkError(this.status);
}

/// Single channel used for all local-file platform calls.
class _LocalFilesChannel {
  static const _ch = MethodChannel('com.ppplayer.app/local_files');

  /// Android only: returns whether ContentResolver can open the URI for reading.
  static Future<bool> canReadContentUri(String contentUri) async {
    try {
      return await _ch.invokeMethod<bool>('canReadContentUri', {
            'uri': contentUri,
          }) ??
          false;
    } on PlatformException {
      return false;
    }
  }

  /// iOS / macOS: starts accessing the security-scoped resource described by
  /// [base64Bookmark], resolves it to an absolute path, and returns it.
  /// Returns null if the file is gone.
  /// Throws [_BookmarkError] if the bookmark is stale / revoked.
  static Future<String?> resolveBookmark(String base64Bookmark) async {
    try {
      return await _ch.invokeMethod<String>('resolveBookmark', {
        'bookmark': base64Bookmark,
      });
    } on PlatformException catch (e) {
      if (e.code == 'BOOKMARK_STALE' || e.code == 'BOOKMARK_REVOKED') {
        throw _BookmarkError(TrackAvailabilityStatus.permissionRevoked);
      }
      return null;
    }
  }

  /// Returns the list of audio-file content URIs inside an Android document
  /// tree URI, optionally recursively. Used by LocalLibraryService.importFolder.
  static Future<List<String>> listAudioFiles(
    String treeUri, {
    bool recursive = true,
  }) async {
    try {
      final result = await _ch.invokeListMethod<String>('listAudioFiles', {
        'treeUri': treeUri,
        'recursive': recursive,
      });
      return result ?? [];
    } on PlatformException {
      return [];
    }
  }

  /// Obtains a security-scoped bookmark for a path/URL on iOS/macOS.
  /// Called once at import time; the base64 result is stored as [LocalTrackSource.locator].
  static Future<String?> createBookmark(String absolutePath) async {
    try {
      final bookmark = await _ch.invokeMethod<String>('createBookmark', {
        'path': absolutePath,
      });
      return bookmark;
    } on PlatformException catch (e) {
      if (e.code == 'MissingPluginException' ||
          e.message?.contains('MissingPluginException') == true) {
        return null; // Gracefully degrade if not implemented on this platform
      }
      return null;
    } catch (e) {
      // Also catch the raw MissingPluginException which might not be wrapped in PlatformException
      return null;
    }
  }
}

/// Exposed for use by LocalLibraryService on Android for folder scanning.
Future<List<String>> listAudioFilesInDocumentTree(
  String treeUri, {
  bool recursive = true,
}) {
  return _LocalFilesChannel.listAudioFiles(treeUri, recursive: recursive);
}

/// Exposed for iOS/macOS bookmark creation at import time.
Future<String?> createSecurityScopedBookmark(String absolutePath) {
  return _LocalFilesChannel.createBookmark(absolutePath);
}
