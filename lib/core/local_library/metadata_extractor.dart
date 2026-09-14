// lib/core/local_library/metadata_extractor.dart
//
// Wraps audiotags 1.4.5 (flutter_rust_bridge / Rust lofty) for audio metadata.
//
// Verified API (audiotags 1.4.5):
//   Tag? tag = await AudioTags.read(absolutePath);
//   tag.title, trackArtist, albumArtist, album, genre, year,
//   trackNumber, trackTotal, discNumber, discTotal, duration (seconds, double)
//   List<Picture>? tag.pictures — each Picture: .bytes (Uint8List), .mimeType (String?)
//
// flutter_rust_bridge isolate note: audiotags' async methods dispatch to a
// Rust thread pool via flutter_rust_bridge; they are safe to call from the
// main isolate and do NOT support compute() (no SendPort). We bound concurrency
// with a simple semaphore to avoid saturating the Rust thread pool.

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:metadata_god/metadata_god.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

// ---------------------------------------------------------------------------
// Constants
// ---------------------------------------------------------------------------

/// Max artwork byte size we cache. Preserves the detected format rather than
/// re-encoding. Files above this threshold are dropped (not silently truncated).
const int _kMaxArtworkBytes = 600 * 1024;

/// Maximum concurrent audiotags reads (Rust thread pool limit guard).
const int _kMaxConcurrency = 3;

// ---------------------------------------------------------------------------
// Concurrency semaphore
// ---------------------------------------------------------------------------

int _activeCalls = 0;
final List<Completer<void>> _waiters = [];

Future<T> _throttled<T>(Future<T> Function() fn) async {
  if (_activeCalls >= _kMaxConcurrency) {
    final c = Completer<void>();
    _waiters.add(c);
    await c.future;
  }
  _activeCalls++;
  try {
    return await fn();
  } finally {
    _activeCalls--;
    if (_waiters.isNotEmpty) {
      _waiters.removeAt(0).complete();
    }
  }
}

// ---------------------------------------------------------------------------
// Result type
// ---------------------------------------------------------------------------

class ExtractedMetadata {
  final String title;
  final String artistName;
  final String albumArtist;
  final String albumName;

  /// Stable album grouping key: sha1(normalise(album+albumArtist))[0:16].
  /// Prevents albums with identical titles from merging across artists.
  final String albumGroupKey;

  final int? year;
  final String? genre;
  final int? trackNumber;
  final int? trackTotal;
  final int? discNumber;
  final int? discTotal;

  /// Duration in milliseconds (from tag); null if not present.
  final int? durationMs;

  /// Absolute path to the cached artwork file preserving original format.
  final String? artworkPath;
  final String? artworkMimeType;

  const ExtractedMetadata({
    required this.title,
    required this.artistName,
    required this.albumArtist,
    required this.albumName,
    required this.albumGroupKey,
    this.year,
    this.genre,
    this.trackNumber,
    this.trackTotal,
    this.discNumber,
    this.discTotal,
    this.durationMs,
    this.artworkPath,
    this.artworkMimeType,
  });
}

// ---------------------------------------------------------------------------
// Public API
// ---------------------------------------------------------------------------

/// Extracts metadata from [filePath] (absolute path, not content URI).
///
/// For Android content URIs, call [copyContentUriToTempFile] first, then
/// pass the temp path here.
Future<ExtractedMetadata> extractMetadata(String filePath) {
  return _throttled(() => _doExtract(filePath));
}

/// Copies an Android content:// URI to a temp file and returns the absolute
/// path. The caller must delete the temp file after extraction.
Future<String?> copyContentUriToTempFile(
  String contentUri,
  String displayName,
) async {
  try {
    const ch = MethodChannel('com.ppplayer.app/local_files');
    return await ch.invokeMethod<String>(
      'copyToTemp',
      {'uri': contentUri, 'name': displayName},
    );
  } catch (_) {
    return null;
  }
}

// ---------------------------------------------------------------------------
// Internal implementation
// ---------------------------------------------------------------------------

String _titleFallback(String filePath) {
  final name = p.basenameWithoutExtension(filePath);
  final stripped = name.replaceAll(RegExp(r'^\d+[\s.\-_]+'), '').trim();
  return stripped.isNotEmpty ? stripped : name;
}

String _albumGroupKey(String album, String albumArtist) {
  final key =
      '${album.trim().toLowerCase()}|${albumArtist.trim().toLowerCase()}';
  return sha1.convert(utf8.encode(key)).toString().substring(0, 16);
}

String _extForMime(String? mime) => switch (mime?.toLowerCase()) {
      'image/jpeg' || 'image/jpg' => '.jpg',
      'image/png' => '.png',
      'image/gif' => '.gif',
      'image/webp' => '.webp',
      'image/bmp' => '.bmp',
      _ => '.jpg',
    };

bool _metadataGodInitialized = false;

Future<ExtractedMetadata> _doExtract(String filePath) async {
  if (!_metadataGodInitialized) {
    MetadataGod.initialize();
    _metadataGodInitialized = true;
  }

  Metadata? tag;
  try {
    tag = await MetadataGod.readMetadata(file: filePath);
  } catch (_) {
    // Tag read failure — return filename fallback, never crash.
  }

  if (tag == null) return _buildFallback(filePath);

  final title = _notEmpty(tag.title) ?? _titleFallback(filePath);
  final artist = _notEmpty(tag.artist) ?? 'Unknown Artist';
  final albumArtist = _notEmpty(tag.albumArtist) ?? artist;
  final album = _notEmpty(tag.album) ?? 'Unknown Album';

  // duration is a Duration? in metadata_god.
  final durationMs = tag.duration?.inMilliseconds;

  // Artwork: preserve detected MIME type; skip oversized blobs.
  String? artworkPath;
  String? artworkMimeType;
  final pic = tag.picture;
  if (pic != null) {
    if (pic.data.isNotEmpty && pic.data.length <= _kMaxArtworkBytes) {
      final saved = await _saveArtwork(pic.data, pic.mimeType, filePath);
      artworkPath = saved?.path;
      artworkMimeType = saved?.mime;
    }
    // >_kMaxArtworkBytes: skip without error — do not truncate raw bytes.
  }

  return ExtractedMetadata(
    title: title,
    artistName: artist,
    albumArtist: albumArtist,
    albumName: album,
    albumGroupKey: _albumGroupKey(album, albumArtist),
    year: tag.year,
    genre: _notEmpty(tag.genre),
    trackNumber: tag.trackNumber,
    trackTotal: tag.trackTotal,
    discNumber: tag.discNumber,
    discTotal: tag.discTotal,
    durationMs: durationMs,
    artworkPath: artworkPath,
    artworkMimeType: artworkMimeType,
  );
}

ExtractedMetadata _buildFallback(String filePath) => ExtractedMetadata(
      title: _titleFallback(filePath),
      artistName: 'Unknown Artist',
      albumArtist: 'Unknown Artist',
      albumName: 'Unknown Album',
      albumGroupKey: _albumGroupKey('Unknown Album', 'Unknown Artist'),
    );

String? _notEmpty(String? s) {
  if (s == null) return null;
  final t = s.trim();
  return t.isEmpty ? null : t;
}

class _SavedArtwork {
  final String path;
  final String mime;
  _SavedArtwork({required this.path, required this.mime});
}

Future<_SavedArtwork?> _saveArtwork(
  Uint8List bytes,
  String? mimeType,
  String audioFilePath,
) async {
  try {
    final cacheDir = await getApplicationCacheDirectory();
    final dir = Directory(p.join(cacheDir.path, 'local_artwork'));
    await dir.create(recursive: true);

    final hash = sha1
        .convert(utf8.encode(audioFilePath))
        .toString()
        .substring(0, 16);
    final ext = _extForMime(mimeType);
    final resolved = mimeType ?? 'image/jpeg';
    final file = File(p.join(dir.path, '$hash$ext'));

    if (!await file.exists()) {
      await file.writeAsBytes(bytes, flush: true);
    }
    return _SavedArtwork(path: file.path, mime: resolved);
  } catch (_) {
    return null;
  }
}
