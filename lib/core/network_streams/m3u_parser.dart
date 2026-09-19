import 'dart:convert';
import 'package:http/http.dart' as http;

class M3uChannel {
  final String title;
  final String url;
  final String? tvgId;
  final String? tvgLogo;
  final String? groupTitle;

  M3uChannel({
    required this.title,
    required this.url,
    this.tvgId,
    this.tvgLogo,
    this.groupTitle,
  });
}

enum M3uType {
  channelList,
  hlsManifest,
  unknown,
}

class M3uParseResult {
  final M3uType type;
  final List<M3uChannel> channels;

  M3uParseResult({
    required this.type,
    this.channels = const [],
  });
}

class M3uParser {
  /// Normalizes GitHub preview links to raw links.
  static String normalizeUrl(String url) {
    if (url.startsWith('https://github.com/') && url.contains('/blob/')) {
      return url
          .replaceFirst('https://github.com/', 'https://raw.githubusercontent.com/')
          .replaceFirst('/blob/', '/');
    }
    return url;
  }

  /// Parses M3U content directly from a string.
  static M3uParseResult parseString(String content) {
    if (!content.trimLeft().startsWith('#EXTM3U')) {
      return M3uParseResult(type: M3uType.unknown);
    }

    // Distinguish HLS manifest from channel list
    if (content.contains('#EXT-X-STREAM-INF') ||
        content.contains('#EXT-X-TARGETDURATION')) {
      return M3uParseResult(type: M3uType.hlsManifest);
    }

    final channels = <M3uChannel>[];
    final lines = content.split(RegExp(r'\r?\n'));
    
    String? currentTitle;
    String? currentTvgId;
    String? currentTvgLogo;
    String? currentGroupTitle;

    for (var line in lines) {
      line = line.trim();
      if (line.isEmpty) continue;

      if (line.startsWith('#EXTINF:')) {
        // Parse metadata
        // Example: #EXTINF:-1 tvg-id="id" tvg-logo="url" group-title="group",Channel Name
        
        // Extract title
        final commaIndex = line.lastIndexOf(',');
        if (commaIndex != -1) {
          currentTitle = line.substring(commaIndex + 1).trim();
        } else {
          currentTitle = 'Unknown Channel';
        }

        // Extract tvg-id
        final tvgIdMatch = RegExp(r'tvg-id="([^"]*)"').firstMatch(line);
        currentTvgId = tvgIdMatch?.group(1);

        // Extract tvg-logo
        final tvgLogoMatch = RegExp(r'tvg-logo="([^"]*)"').firstMatch(line);
        currentTvgLogo = tvgLogoMatch?.group(1);

        // Extract group-title
        final groupTitleMatch = RegExp(r'group-title="([^"]*)"').firstMatch(line);
        currentGroupTitle = groupTitleMatch?.group(1);
      } else if (!line.startsWith('#')) {
        // This is a URL line
        if (currentTitle != null) {
          channels.add(M3uChannel(
            title: currentTitle,
            url: normalizeUrl(line),
            tvgId: currentTvgId,
            tvgLogo: currentTvgLogo,
            groupTitle: currentGroupTitle,
          ));
        }
        
        // Reset state for next channel
        currentTitle = null;
        currentTvgId = null;
        currentTvgLogo = null;
        currentGroupTitle = null;
      }
    }

    return M3uParseResult(
      type: M3uType.channelList,
      channels: channels,
    );
  }

  /// Fetches and parses a remote M3U playlist or stream.
  /// Bounded response bytes are used for checking if it's an HLS stream vs M3U playlist.
  static Future<M3uParseResult> fetchAndParse(String rawUrl, {int maxBytes = 5 * 1024 * 1024, http.Client? client}) async {
    final url = normalizeUrl(rawUrl);
    final internalClient = client ?? http.Client();
    
    try {
      final request = http.Request('GET', Uri.parse(url));
      final response = await internalClient.send(request);

      if (response.statusCode != 200) {
        throw Exception('Failed to load URL: ${response.statusCode}');
      }

      final contentType = response.headers['content-type']?.toLowerCase() ?? '';
      
      // If it's a known stream type (not a playlist), return it as a direct stream
      if (contentType.contains('video/mp2t') || 
          contentType.contains('audio/') && !contentType.contains('mpegurl')) {
        return M3uParseResult(
          type: M3uType.unknown, 
          // Will be handled as direct stream later
        );
      }

      int bytesReceived = 0;
      final bytes = <int>[];

      await for (final chunk in response.stream) {
        bytesReceived += chunk.length;
        if (bytesReceived > maxBytes) {
          throw Exception('File too large (exceeds ${maxBytes / 1024 / 1024}MB bound)');
        }
        bytes.addAll(chunk);
      }

      return parseString(utf8.decode(bytes, allowMalformed: true));
    } finally {
      if (client == null) {
        internalClient.close();
      }
    }
  }
}
