import 'dart:convert';

// ignore_for_file: use_null_aware_elements
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/app_config.dart';
import '../models/resolved_video_candidate.dart';
import '../services/secure_credentials_service.dart';
import '../services/settings_provider.dart';

/// Resolves a YouTube video candidates for a given track name + artist.
class YoutubeResolver {
  YoutubeResolver(this._dio, this._settingsState, this._secureStorage);

  final Dio _dio;
  final SettingsState _settingsState;
  final SecureCredentialsService _secureStorage;

  Future<List<ResolvedVideoCandidate>> resolve(
    String artistName,
    String trackName, {
    String? regionCode,
    int? durationMs,
  }) async {
    List<ResolvedVideoCandidate> rawCandidates = [];

    if (_settingsState.youtubeSearchMethod == YoutubeSearchMethod.scraping) {
      try {
        rawCandidates = await _viaScraping(artistName, trackName, durationMs);
      } catch (e) {
        debugPrint(
          'YoutubeResolver: Scraping failed or returned 0, falling back to API. Error: $e',
        );
      }

      // Fallback to API if scraping returned no candidates or threw an error
      if (rawCandidates.isEmpty) {
        debugPrint(
          'YoutubeResolver: Scraping returned 0 candidates. Falling back to API.',
        );
        rawCandidates = await _viaApi(
          artistName,
          trackName,
          regionCode: regionCode,
          durationMs: durationMs,
        );
      }
    } else {
      rawCandidates = await _viaApi(
        artistName,
        trackName,
        regionCode: regionCode,
        durationMs: durationMs,
      );
    }

    // Harden candidates: YouTube IDs must be exactly 11 chars
    final validCandidates =
        rawCandidates
            .where((c) => c.videoId.length == 11 && !c.videoId.contains('http'))
            .toList();

    // Sort by confidence score descending
    validCandidates.sort(
      (a, b) => b.confidenceScore.compareTo(a.confidenceScore),
    );
    return validCandidates;
  }

  Future<List<ResolvedVideoCandidate>> _viaApi(
    String artistName,
    String trackName, {
    String? regionCode,
    int? durationMs,
  }) async {
    final results = <ResolvedVideoCandidate>[];
    final queries = [
      '$artistName $trackName official audio',
      '$artistName $trackName official music video',
      '$artistName $trackName',
    ];

    for (final q in queries) {
      try {
        final batch = await _searchYoutubeApi(
          q,
          regionCode,
          artistName,
          trackName,
          durationMs,
        );
        for (final candidate in batch) {
          if (!results.any((c) => c.videoId == candidate.videoId)) {
            results.add(candidate);
          }
        }
        // If we have plenty of candidates, stop searching to save quota
        if (results.length >= 10) break;
      } catch (e) {
        debugPrint('YoutubeResolver: API error for query "$q": $e');
      }
    }

    return results;
  }

  Future<List<ResolvedVideoCandidate>> _searchYoutubeApi(
    String query,
    String? regionCode,
    String originalArtist,
    String originalTitle,
    int? durationMs,
  ) async {
    if (_settingsState.youtubeApiProvider == YoutubeApiProviderType.custom) {
      final apiKey = await _secureStorage.readYoutubeApiKey();
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception(
          'Missing Custom YouTube API Key. Please configure it in Settings.',
        );
      }

      final response = await _dio.get(
        'https://www.googleapis.com/youtube/v3/search',
        queryParameters: {
          'part': 'snippet',
          'q': query,
          'type': 'video',
          'videoCategoryId': '10', // Music
          'maxResults': 10,
          'key': apiKey,
          if (regionCode != null) 'regionCode': regionCode,
        },
      );

      final items = response.data['items'] as List;
      return items.map((i) {
        final snippet = i['snippet'] as Map<String, dynamic>;
        final title = snippet['title'] as String;
        final channel = snippet['channelTitle'] as String;
        return ResolvedVideoCandidate(
          videoId: i['id']['videoId'] as String,
          title: title,
          channel: channel,
          confidenceScore: calculateConfidence(
            title,
            channel,
            null,
            originalArtist,
            originalTitle,
            durationMs,
          ),
        );
      }).toList();
    } else {
      final searchUrl = '${AppConfig.apiBaseUrl}/api/youtube/search';

      final response = await _dio.get(
        searchUrl,
        queryParameters: {
          'q': query,
          if (regionCode != null) 'regionCode': regionCode,
        },
      );

      final ids = (response.data['ids'] as List?) ?? [];
      // Backend only returns IDs currently, so we use dummy ranking (or we'd need backend to return metadata)
      return ids
          .cast<String>()
          .map(
            (id) => ResolvedVideoCandidate(
              videoId: id,
              title: 'Unknown Title',
              channel: 'Unknown Channel',
              confidenceScore: 0.5, // Default for unknown API results
            ),
          )
          .toList();
    }
  }

  Future<List<ResolvedVideoCandidate>> _viaScraping(
    String artistName,
    String trackName,
    int? durationMs,
  ) async {
    // Use a broad search query to find the best match; we rely on candidate rotation later.
    final query = Uri.encodeComponent('$artistName $trackName');
    final response = await _dio.get(
      'https://www.youtube.com/results?search_query=$query',
      options: Options(
        headers: {
          'User-Agent':
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
          'Accept-Language': 'en-US, en;q=0.5',
        },
      ),
    );

    final html = response.data.toString();

    // Offload heavy JSON parsing and traversal to a background isolate to prevent UI jank.
    return await compute(parseYoutubeHtml, {
      'html': html,
      'artistName': artistName,
      'trackName': trackName,
      'durationMs': durationMs,
    });
  }

  /// Internal parser for YouTube's initial data HTML blob.
  /// Runs in a background isolate.
  @visibleForTesting
  static List<ResolvedVideoCandidate> parseYoutubeHtml(
    Map<String, dynamic> args,
  ) {
    final html = args['html'] as String;
    final originalArtist = args['artistName'] as String;
    final originalTitle = args['trackName'] as String;
    final durationMs = args['durationMs'] as int?;

    try {
      final match = RegExp(r'ytInitialData\s*=\s*(\{.*?\});').firstMatch(html);
      if (match != null) {
        final jsonStr = match.group(1)!;
        final data = json.decode(jsonStr);

        final contents =
            data['contents']['twoColumnSearchResultsRenderer']['primaryContents']['sectionListRenderer']['contents']
                as List;

        final itemSection =
            contents.firstWhere(
                  (c) => c.containsKey('itemSectionRenderer'),
                )['itemSectionRenderer']['contents']
                as List;

        final videos =
            itemSection
                .where((c) => c.containsKey('videoRenderer'))
                .take(15)
                .toList();

        return videos.map<ResolvedVideoCandidate>((v) {
          final vr = v['videoRenderer'];
          final videoId = vr['videoId'] as String;

          String title = '';
          if (vr['title'] != null && vr['title']['runs'] != null) {
            title = (vr['title']['runs'] as List)
                .map((r) => r['text'])
                .join('');
          }

          String channel = '';
          if (vr['ownerText'] != null && vr['ownerText']['runs'] != null) {
            channel = (vr['ownerText']['runs'] as List)
                .map((r) => r['text'])
                .join('');
          }

          int? parsedDurationMs;
          if (vr['lengthText'] != null &&
              vr['lengthText']['simpleText'] != null) {
            final timeStr = vr['lengthText']['simpleText'] as String;
            parsedDurationMs = _parseDurationStr(timeStr);
          }

          return ResolvedVideoCandidate(
            videoId: videoId,
            title: title,
            channel: channel,
            durationMs: parsedDurationMs,
            confidenceScore: calculateConfidence(
              title,
              channel,
              parsedDurationMs,
              originalArtist,
              originalTitle,
              durationMs,
            ),
          );
        }).toList();
      }
    } catch (e) {
      // Silently fail in isolate, main thread will handle the empty list.
    }
    return [];
  }

  static int _parseDurationStr(String timeStr) {
    final parts = timeStr.split(':').reversed.toList();
    int ms = 0;
    if (parts.isNotEmpty) ms += int.parse(parts[0]) * 1000;
    if (parts.length > 1) ms += int.parse(parts[1]) * 60 * 1000;
    if (parts.length > 2) ms += int.parse(parts[2]) * 60 * 60 * 1000;
    return ms;
  }

  @visibleForTesting
  static double calculateConfidence(
    String videoTitle,
    String channelName,
    int? videoDurationMs,
    String originalArtist,
    String originalTitle,
    int? originalDurationMs,
  ) {
    double score = 1.0;

    final normVideoTitle = normalizeString(videoTitle);
    final normOriginalTitle = normalizeString(originalTitle);
    final normChannel = normalizeString(channelName);
    final normArtist = normalizeString(originalArtist);

    // Exact or near-exact match
    if (normVideoTitle.contains(normOriginalTitle)) {
      score += 0.5;
    }

    // Artist match
    if (normVideoTitle.contains(normArtist) ||
        normChannel.contains(normArtist)) {
      score += 0.5;
    }

    // Channel is Topic or Official
    if (normChannel.endsWith('topic')) {
      score += 0.4;
    }
    if (normChannel.contains('official')) {
      score += 0.3;
    }

    // "Official Audio" in title
    if (normVideoTitle.contains('official audio')) {
      score += 0.3;
    }

    // Penalize versions if they are not in the original title
    final penalizeTerms = [
      'live',
      'cover',
      'karaoke',
      'remix',
      'slowed',
      'sped up',
      'reaction',
      'instrumental',
      'acoustic',
    ];
    for (final term in penalizeTerms) {
      if (normVideoTitle.contains(term) && !normOriginalTitle.contains(term)) {
        score -= 0.5;
      }
    }

    // Duration penalty
    if (videoDurationMs != null && originalDurationMs != null) {
      final diffSeconds = (videoDurationMs - originalDurationMs).abs() / 1000;
      if (diffSeconds > 30) {
        // High penalty for significant duration difference
        score -= 0.5;
      } else if (diffSeconds > 10) {
        score -= 0.2;
      } else {
        // Very close duration is a good signal
        score += 0.3;
      }
    }

    return score;
  }

  @visibleForTesting
  static String normalizeString(String input) {
    String s = input.toLowerCase();
    // Remove diacritics
    s = s.replaceAll(RegExp(r'[áàâäãå]'), 'a');
    s = s.replaceAll(RegExp(r'[éèêë]'), 'e');
    s = s.replaceAll(RegExp(r'[íìîï]'), 'i');
    s = s.replaceAll(RegExp(r'[óòôöõ]'), 'o');
    s = s.replaceAll(RegExp(r'[úùûü]'), 'u');
    s = s.replaceAll(RegExp(r'[ç]'), 'c');
    s = s.replaceAll(RegExp(r'[ñ]'), 'n');
    // Remove punctuation
    s = s.replaceAll(RegExp(r'[^\w\s]'), ' ');
    // Remove extra whitespace
    s = s.replaceAll(RegExp(r'\s+'), ' ').trim();
    return s;
  }
}

final youtubeResolverProvider = Provider<YoutubeResolver>((ref) {
  final settings = ref.watch(settingsProvider);
  final secureStorage = ref.watch(secureCredentialsProvider);
  return YoutubeResolver(
    Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    ),
    settings,
    secureStorage,
  );
});
