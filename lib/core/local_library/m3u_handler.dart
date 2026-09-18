import 'dart:convert';
import 'package:path/path.dart' as p;
import '../models/track.dart';

class M3uEntry {
  final String pathOrUri;
  final String? title;
  final int? durationSeconds;

  const M3uEntry({required this.pathOrUri, this.title, this.durationSeconds});
}

class M3uExportResult {
  final String content;
  final int skippedCount;

  const M3uExportResult(this.content, this.skippedCount);
}

class M3uException implements Exception {
  final String message;
  M3uException(this.message);

  @override
  String toString() => "M3uException: $message";
}

class M3uHandler {
  static const _utf8Bom = [0xEF, 0xBB, 0xBF];

  /// Parses M3U content. [sourceLocation] is used to resolve relative paths.
  /// Throws [M3uException] on non-UTF-8 content or HLS playlists.
  static Future<List<M3uEntry>> parse(List<int> bytes, {String? sourceLocation}) async {
    // Check BOM and decode UTF-8
    String content;
    try {
      if (bytes.length >= 3 && 
          bytes[0] == _utf8Bom[0] && 
          bytes[1] == _utf8Bom[1] && 
          bytes[2] == _utf8Bom[2]) {
        content = utf8.decode(bytes.sublist(3));
      } else {
        content = utf8.decode(bytes);
      }
    } catch (e) {
      throw M3uException('Playlist is not valid UTF-8. Only UTF-8 M3U8 playlists are supported.');
    }

    final lines = content.split(RegExp(r'\r\n|\r|\n'));
    final entries = <M3uEntry>[];
    
    String? currentTitle;
    int? currentDuration;

    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) continue;

      if (trimmed.startsWith('#')) {
        if (trimmed.startsWith('#EXT-X-')) {
          throw M3uException('HLS network playlists are not supported for local import.');
        } else if (trimmed.startsWith('#EXTINF:')) {
          // #EXTINF:123, Sample artist - Sample title
          // #EXTINF:-1, Unknown duration
          final parts = trimmed.substring(8).split(',');
          if (parts.isNotEmpty) {
            final durationStr = parts[0].trim();
            final duration = int.tryParse(durationStr);
            if (duration != null && duration > 0) {
              currentDuration = duration;
            } else {
              currentDuration = null; // -1 or invalid means unknown
            }
            if (parts.length > 1) {
              currentTitle = parts.sublist(1).join(',').trim();
            }
          }
        }
        continue;
      }

      // It's a path or URI
      if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
        continue;
      }
      final resolvedPath = _resolvePath(trimmed, sourceLocation);
      entries.add(M3uEntry(
        pathOrUri: resolvedPath, 
        title: currentTitle, 
        durationSeconds: currentDuration,
      ));

      // Reset EXTINF state for next entry
      currentTitle = null;
      currentDuration = null;
    }

    return entries;
  }

  static String _resolvePath(String entryPath, String? sourceLocation) {
    if (sourceLocation == null) return entryPath;
    
    // Check if entry is already an absolute URI or path
    if (Uri.tryParse(entryPath)?.hasScheme == true) {
      if (entryPath.startsWith('file://')) {
        return Uri.parse(entryPath).toFilePath();
      }
      return entryPath;
    }
    
    // Check if absolute path (Windows drive letter or UNIX root)
    if (p.isAbsolute(entryPath)) return entryPath;
    if (RegExp(r'^[a-zA-Z]:\\').hasMatch(entryPath)) return entryPath;
    if (entryPath.startsWith(r'\\')) return entryPath;

    // Resolve relative to sourceLocation
    final isWindows = RegExp(r'^[a-zA-Z]:[\\/]|^\\[\\]').hasMatch(sourceLocation);
    final context = isWindows ? p.windows : p.posix;
    
    if (sourceLocation.startsWith('file://')) {
        final filePath = Uri.parse(sourceLocation).toFilePath();
        final dir = context.dirname(filePath);
        return context.normalize(context.join(dir, entryPath));
    }

    final dir = context.dirname(sourceLocation);
    return context.normalize(context.join(dir, entryPath));
  }

  /// Generates a UTF-8 M3U8 string from a list of tracks.
  static M3uExportResult generate(List<Track> queue, {String? exportDestinationDir}) {
    final buffer = StringBuffer();
    buffer.writeln('#EXTM3U');

    int skippedCount = 0;
    final dest = exportDestinationDir ?? '';
    final isWindows = RegExp(r'^[a-zA-Z]:[\\/]|^\\[\\]').hasMatch(dest);
    final context = isWindows ? p.windows : p.posix;

    for (final track in queue) {
      final path = track.localFilePath;
      if (path == null) {
         skippedCount++;
         continue;
      }
      
      // Skip non-portable paths
      if (path.startsWith('content://') || 
          path.startsWith('http') || 
          path.contains('SecurityBookmark') || 
          path.contains('com.apple.FileProvider')) {
        skippedCount++;
        continue;
      }
      
      String outPath = path;
      
      // Attempt relative path if export destination is known and the path is on the same file system
      if (exportDestinationDir != null && context.isAbsolute(path) && context.isAbsolute(exportDestinationDir)) {
         try {
             outPath = context.relative(path, from: exportDestinationDir);
         } catch (_) {
             // Keep absolute if relative fails
         }
      }

      final duration = track.durationMs != null ? (track.durationMs! ~/ 1000) : -1;
      final safeTitle = track.name.replaceAll('\n', ' ').replaceAll('\r', ' ');
      final safeArtist = track.artistName.replaceAll('\n', ' ').replaceAll('\r', ' ');
      
      buffer.writeln('#EXTINF:$duration,$safeArtist - $safeTitle');
      buffer.writeln(outPath);
    }

    return M3uExportResult(buffer.toString(), skippedCount);
  }
}
