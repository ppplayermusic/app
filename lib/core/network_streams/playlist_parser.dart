import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

class PlaylistItem {
  final String title;
  final String url;
  final String? tvgId;
  final String? tvgLogo;
  final String? groupTitle;

  PlaylistItem({
    required this.title,
    required this.url,
    this.tvgId,
    this.tvgLogo,
    this.groupTitle,
  });
}

enum PlaylistType { channelList, hlsManifest, unknown }

class PlaylistParseResult {
  final PlaylistType type;
  final List<PlaylistItem> channels;

  PlaylistParseResult({required this.type, this.channels = const []});
}

class PlaylistParser {
  /// Normalizes GitHub preview links to raw links.
  static String normalizeUrl(String url) {
    if (url.startsWith('https://github.com/') && url.contains('/blob/')) {
      return url
          .replaceFirst(
            'https://github.com/',
            'https://raw.githubusercontent.com/',
          )
          .replaceFirst('/blob/', '/');
    }
    return url;
  }

  /// Parses content directly from a string based on its inferred format.
  static PlaylistParseResult parseString(String content, String url) {
    if (content.trimLeft().startsWith('#EXTM3U')) {
      return _parseM3u(content, url);
    } else if (content.trimLeft().toLowerCase().startsWith('[playlist]')) {
      return _parsePls(content, url);
    } else if (content.trimLeft().startsWith('<')) {
      // Could be XSPF or ASX
      try {
        final document = XmlDocument.parse(content);
        final root = document.rootElement;

        if (root.name.local.toLowerCase() == 'playlist' &&
            root.name.namespaceUri?.contains('xspf') == true) {
          return _parseXspf(document, url);
        } else if (root.name.local.toLowerCase() == 'asx') {
          return _parseAsx(document, url);
        }
      } catch (e) {
        // XML parsing failed
      }
    }

    // Default: could not parse
    return PlaylistParseResult(type: PlaylistType.unknown);
  }

  static PlaylistParseResult _parseM3u(String content, String baseUrl) {
    if (content.contains('#EXT-X-STREAM-INF') ||
        content.contains('#EXT-X-TARGETDURATION')) {
      return PlaylistParseResult(type: PlaylistType.hlsManifest);
    }

    final channels = <PlaylistItem>[];
    final lines = content.split(RegExp(r'\r?\n'));

    String? currentTitle;
    String? currentTvgId;
    String? currentTvgLogo;
    String? currentGroupTitle;

    for (var line in lines) {
      line = line.trim();
      if (line.isEmpty) continue;

      if (line.startsWith('#EXTINF:')) {
        final commaIndex = line.lastIndexOf(',');
        if (commaIndex != -1) {
          currentTitle = line.substring(commaIndex + 1).trim();
        } else {
          currentTitle = 'Unknown Channel';
        }
        currentTvgId = RegExp(r'tvg-id="([^"]*)"').firstMatch(line)?.group(1);
        currentTvgLogo = RegExp(
          r'tvg-logo="([^"]*)"',
        ).firstMatch(line)?.group(1);
        currentGroupTitle = RegExp(
          r'group-title="([^"]*)"',
        ).firstMatch(line)?.group(1);
      } else if (!line.startsWith('#')) {
        if (currentTitle != null) {
          channels.add(
            PlaylistItem(
              title: currentTitle,
              url: _resolveUrl(normalizeUrl(line), baseUrl),
              tvgId: currentTvgId,
              tvgLogo: currentTvgLogo,
              groupTitle: currentGroupTitle,
            ),
          );
        }
        currentTitle = null;
        currentTvgId = null;
        currentTvgLogo = null;
        currentGroupTitle = null;
      }
    }
    return PlaylistParseResult(
      type: PlaylistType.channelList,
      channels: channels,
    );
  }

  static PlaylistParseResult _parsePls(String content, String baseUrl) {
    final channels = <PlaylistItem>[];
    final lines = content.split(RegExp(r'\r?\n'));

    final map = <String, String>{};
    for (var line in lines) {
      final eq = line.indexOf('=');
      if (eq != -1) {
        final key = line.substring(0, eq).trim().toLowerCase();
        final val = line.substring(eq + 1).trim();
        map[key] = val;
      }
    }

    // Extract FileN and TitleN
    final entries = <int, Map<String, String>>{};
    for (final entry in map.entries) {
      final key = entry.key;
      final val = entry.value;
      if (key.startsWith('file') || key.startsWith('title')) {
        final match = RegExp(r'^([a-z]+)(\d+)$').firstMatch(key);
        if (match != null) {
          final prefix = match.group(1)!;
          final index = int.parse(match.group(2)!);

          if (!entries.containsKey(index)) {
            entries[index] = {};
          }
          entries[index]![prefix] = val;
        }
      }
    }

    final sortedKeys = entries.keys.toList()..sort();
    for (final index in sortedKeys) {
      final entry = entries[index]!;
      final file = entry['file'];
      if (file != null) {
        channels.add(
          PlaylistItem(
            title: entry['title'] ?? 'Stream $index',
            url: _resolveUrl(normalizeUrl(file), baseUrl),
          ),
        );
      }
    }

    if (channels.isEmpty) {
      return PlaylistParseResult(type: PlaylistType.unknown);
    }

    return PlaylistParseResult(
      type: PlaylistType.channelList,
      channels: channels,
    );
  }

  static PlaylistParseResult _parseXspf(XmlDocument document, String baseUrl) {
    final channels = <PlaylistItem>[];
    final trackList = document.findAllElements('trackList').firstOrNull;
    if (trackList == null)
      return PlaylistParseResult(type: PlaylistType.unknown);

    final tracks = trackList.findElements('track');
    for (final track in tracks) {
      final location = track.findElements('location').firstOrNull?.innerText;
      if (location != null && location.isNotEmpty) {
        final title = track.findElements('title').firstOrNull?.innerText;
        final creator = track.findElements('creator').firstOrNull?.innerText;
        final image = track.findElements('image').firstOrNull?.innerText;

        final resolvedUrl = _resolveUrl(normalizeUrl(location), baseUrl);

        channels.add(
          PlaylistItem(
            title: title ?? creator ?? 'Stream',
            url: resolvedUrl,
            tvgLogo: image,
          ),
        );
      }
    }

    if (channels.isEmpty) {
      return PlaylistParseResult(type: PlaylistType.unknown);
    }

    return PlaylistParseResult(
      type: PlaylistType.channelList,
      channels: channels,
    );
  }

  static PlaylistParseResult _parseAsx(XmlDocument document, String baseUrl) {
    final channels = <PlaylistItem>[];

    // ASX is case-insensitive in Windows Media Player. The xml package is case-sensitive, so we check both.
    Iterable<XmlElement> getElements(XmlElement parent, String name) {
      return parent.children.whereType<XmlElement>().where(
        (e) => e.name.local.toLowerCase() == name.toLowerCase(),
      );
    }

    String? getAttributeCaseInsensitive(XmlElement element, String name) {
      for (final attr in element.attributes) {
        if (attr.name.local.toLowerCase() == name.toLowerCase()) {
          return attr.value;
        }
      }
      return null;
    }

    final entries = getElements(document.rootElement, 'entry');

    for (final entry in entries) {
      final ref = getElements(entry, 'ref').firstOrNull;
      final href = ref != null
          ? getAttributeCaseInsensitive(ref, 'href')
          : null;

      if (href != null && href.isNotEmpty) {
        final title = getElements(entry, 'title').firstOrNull?.innerText;

        final resolvedUrl = _resolveUrl(normalizeUrl(href), baseUrl);

        channels.add(PlaylistItem(title: title ?? 'Stream', url: resolvedUrl));
      }
    }

    if (channels.isEmpty) {
      return PlaylistParseResult(type: PlaylistType.unknown);
    }

    return PlaylistParseResult(
      type: PlaylistType.channelList,
      channels: channels,
    );
  }

  static String _resolveUrl(String url, String baseUrl) {
    if (url.startsWith('http://') || url.startsWith('https://')) return url;
    try {
      final base = Uri.parse(baseUrl);
      final resolved = base.resolve(url);
      return resolved.toString();
    } catch (_) {
      return url;
    }
  }

  /// Fetches and parses a remote playlist or stream.
  static Future<PlaylistParseResult> fetchAndParse(
    String rawUrl, {
    int maxBytes = 5 * 1024 * 1024,
    http.Client? client,
    Duration timeout = const Duration(seconds: 15),
  }) async {
    final url = normalizeUrl(rawUrl);
    final internalClient = client ?? http.Client();
    StreamSubscription? subscription;

    try {
      final request = http.Request('GET', Uri.parse(url));

      bool timedOut = false;
      final responseFuture = internalClient.send(request);

      // Ensure that if the headers arrive AFTER a timeout threw, we still safely drain and abort the socket.
      // Canceling the stream subscription is the supported package:http mechanism for aborting a transfer.
      responseFuture
          .then((response) {
            if (timedOut) {
              response.stream.listen((_) {}).cancel();
            }
          })
          .catchError((_) {});

      final response = await responseFuture.timeout(
        timeout,
        onTimeout: () {
          timedOut = true;
          throw TimeoutException('Connection timed out');
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to load URL: ${response.statusCode}');
      }

      final contentType = response.headers['content-type']?.toLowerCase() ?? '';

      // If it's a known stream type (not a playlist), return it as a direct stream
      if (contentType.contains('video/mp2t') ||
          contentType.contains('video/mp4') ||
          (contentType.contains('audio/') &&
              !contentType.contains('mpegurl') &&
              !contentType.contains('x-scpls')) ||
          contentType.contains('application/dash+xml')) {
        // Cancel the stream safely without reading
        subscription = response.stream.listen((_) {});
        await subscription.cancel();
        return PlaylistParseResult(type: PlaylistType.unknown);
      }

      int bytesReceived = 0;
      final bytes = <int>[];
      final completer = Completer<List<int>>();

      subscription = response.stream.listen(
        (chunk) {
          bytesReceived += chunk.length;
          if (bytesReceived > maxBytes) {
            subscription?.cancel();
            if (!completer.isCompleted) {
              completer.completeError(
                Exception(
                  'File too large (exceeds ${maxBytes / 1024 / 1024}MB bound)',
                ),
              );
            }
          } else {
            bytes.addAll(chunk);
          }
        },
        onError: (e) {
          if (!completer.isCompleted) completer.completeError(e);
        },
        onDone: () {
          if (!completer.isCompleted) completer.complete(bytes);
        },
        cancelOnError: true,
      );

      final finalBytes = await completer.future.timeout(timeout);
      final finalUrl = response.request?.url.toString() ?? url;

      final decodedString = _decodeBytes(finalBytes, contentType, finalUrl);
      return parseString(decodedString, finalUrl);
    } finally {
      await subscription?.cancel();
      if (client == null) {
        internalClient.close();
      }
    }
  }

  static String _decodeBytes(List<int> bytes, String contentType, String url) {
    bool isM3u8 =
        url.toLowerCase().endsWith('.m3u8') ||
        contentType.contains('application/vnd.apple.mpegurl');

    // Check Content-Type charset
    String? headerCharset;
    final match = RegExp(r'charset=([^\s;]+)').firstMatch(contentType);
    if (match != null) headerCharset = match.group(1)?.toLowerCase();

    // XML encoding declaration check (XSPF, ASX)
    String? xmlCharset;
    if (url.toLowerCase().endsWith('.xspf') ||
        url.toLowerCase().endsWith('.asx') ||
        contentType.contains('xml')) {
      // Decode only first ~200 bytes as ascii to find <?xml ... ?>
      final previewBytes = bytes.take(200).toList();
      final preview = ascii.decode(previewBytes, allowInvalid: true);
      final xmlMatch = RegExp(
        r'<\?xml[^>]+encoding=["'
        "'"
        r']([^"'
        "'"
        r']+)["'
        "'"
        r']',
      ).firstMatch(preview);
      if (xmlMatch != null) {
        xmlCharset = xmlMatch.group(1)?.toLowerCase();
      }
    }

    final targetCharset = xmlCharset ?? headerCharset;

    if (isM3u8) {
      // M3U8 strictly requires UTF-8
      return utf8.decode(bytes); // Will throw FormatException if invalid
    }

    if (targetCharset == 'iso-8859-1' || targetCharset == 'latin1') {
      return latin1.decode(bytes);
    }

    // Default to strict UTF-8
    try {
      return utf8.decode(bytes);
    } catch (e) {
      if (e is FormatException && targetCharset == null) {
        // Fallback to latin1 ONLY if it's an old M3U or unknown text format that didn't specify charset
        return latin1.decode(bytes);
      }
      rethrow;
    }
  }
}
