import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/secure_credentials_service.dart';
import '../services/settings_provider.dart';

/// Resolves a YouTube video ID for a given track name + artist.
/// Returns up to 3 candidates — the player rotates through them on error.
class YoutubeResolver {
  YoutubeResolver(this._dio, this._settingsState, this._secureStorage);

  final Dio _dio;
  final SettingsState _settingsState;
  final SecureCredentialsService _secureStorage;

  Future<List<String>> resolve(String artistName, String trackName, {String? regionCode}) async {
    List<String> rawCandidates = [];
    if (_settingsState.youtubeSearchMethod == YoutubeSearchMethod.scraping) {
      rawCandidates = await _viaScraping(artistName, trackName);
    } else {
      rawCandidates = await _viaApi(artistName, trackName, regionCode: regionCode);
    }

    // Harden candidates: YouTube IDs must be exactly 11 chars
    return rawCandidates.where((id) => id.length == 11 && !id.contains('http')).toList();
  }

  Future<List<String>> _viaApi(String artistName, String trackName, {String? regionCode}) async {
    final results = <String>[];
    final queries = [
      '$artistName $trackName official audio',
      '$artistName $trackName official music video',
      '$artistName $trackName audio',
      '$artistName $trackName lyric video',
      '$artistName $trackName',
    ];

    for (final q in queries) {
      try {
        final batch = await _searchYoutubeApi(q, regionCode);
        for (final id in batch) {
          if (!results.contains(id)) {
            results.add(id);
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

  Future<List<String>> _searchYoutubeApi(String query, String? regionCode) async {
    if (_settingsState.youtubeApiProvider == YoutubeApiProviderType.custom) {
      final apiKey = await _secureStorage.readYoutubeApiKey();
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception('Missing Custom YouTube API Key. Please configure it in Settings.');
      }
      
      final response = await _dio.get(
        'https://www.googleapis.com/youtube/v3/search',
        queryParameters: {
          'part': 'snippet',
          'q': query,
          'type': 'video',
          'videoCategoryId': '10', // Music
          'maxResults': 5,
          'key': apiKey,
          if (regionCode != null) 'regionCode': regionCode,
        },
      );

      final items = response.data['items'] as List;
      return items.map((i) => i['id']['videoId'] as String).toList();
    } else {
      final baseUrl = kDebugMode ? 'http://localhost:3000' : 'https://ppplayer.com';
      final searchUrl = '$baseUrl/api/youtube/search';

      final response = await _dio.get(
        searchUrl,
        queryParameters: {
          'q': query,
          if (regionCode != null) 'regionCode': regionCode,
        },
      );

      final ids = (response.data['ids'] as List?) ?? [];
      return ids.cast<String>();
    }
  }

  Future<List<String>> _viaScraping(String artistName, String trackName) async {
    try {
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
      return await compute(_parseYoutubeHtml, html);
    } catch (e) {
      debugPrint('YoutubeResolver: Scraping error: $e');
      return [];
    }
  }

  /// Internal parser for YouTube's initial data HTML blob.
  /// Runs in a background isolate.
  static List<String> _parseYoutubeHtml(String html) {
    try {
      final match = RegExp(r'ytInitialData\s*=\s*(\{.*?\});').firstMatch(html);
      if (match != null) {
        final jsonStr = match.group(1)!;
        final data = json.decode(jsonStr);

        final contents = data['contents']['twoColumnSearchResultsRenderer']
            ['primaryContents']['sectionListRenderer']['contents'] as List;

        final itemSection = contents.firstWhere(
            (c) => c.containsKey('itemSectionRenderer'))['itemSectionRenderer']
            ['contents'] as List;

        final videos = itemSection
            .where((c) => c.containsKey('videoRenderer'))
            // Try up to 10 candidates in case the first few are unembeddable (Error 150)
            .take(10)
            .toList();

        return videos
            .map<String>((v) => v['videoRenderer']['videoId'] as String)
            .toList();
      }
    } catch (e) {
      // Silently fail in isolate, main thread will handle the empty list.
    }
    return [];
  }
}

final youtubeResolverProvider = Provider<YoutubeResolver>((ref) {
  final settings = ref.watch(settingsProvider);
  final secureStorage = ref.watch(secureCredentialsProvider);
  return YoutubeResolver(
    Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    )),
    settings,
    secureStorage,
  );
});
