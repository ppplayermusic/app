import 'dart:convert';
import 'dart:io';


import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:media_kit/media_kit.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class VideoThumbnailGenerator {
  static Future<String?> generateAndSaveThumbnail(String filePath) async {
    final player = Player(
      configuration: const PlayerConfiguration(
        vo: 'null', // Don't try to render to a surface
      ),
    );
    try {
      await player.open(Media(filePath), play: false);
      
      // Wait for it to be ready
      await player.stream.duration.firstWhere((d) => d > Duration.zero).timeout(const Duration(seconds: 3));
      
      // Seek to 10% of duration
      final duration = player.state.duration;
      final seekTo = duration * 0.1;
      await player.seek(seekTo);
      
      // Wait a bit for seek
      await Future.delayed(const Duration(milliseconds: 500));
      
      final bytes = await player.screenshot(format: 'image/jpeg');
      if (bytes != null && bytes.isNotEmpty) {
        return await _saveArtwork(bytes, 'image/jpeg', filePath);
      }
    } catch (e) {
      debugPrint('Thumbnail generation failed: $e');
    } finally {
      await player.dispose();
    }
    return null;
  }

  static Future<String?> _saveArtwork(
    Uint8List bytes,
    String mimeType,
    String filePath,
  ) async {
    try {
      final cacheDir = await getApplicationCacheDirectory();
      final dir = Directory(p.join(cacheDir.path, 'local_artwork'));
      await dir.create(recursive: true);

      final hash = sha1
          .convert(utf8.encode(filePath))
          .toString()
          .substring(0, 16);
      final file = File(p.join(dir.path, '$hash.jpg'));

      if (!await file.exists()) {
        await file.writeAsBytes(bytes, flush: true);
      }
      return file.path;
    } catch (_) {
      return null;
    }
  }
}
