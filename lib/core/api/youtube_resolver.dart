import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Resolves a YouTube video ID for a given track name + artist.
/// Returns up to 3 candidates — the player rotates through them on error.
class YoutubeResolver {
  YoutubeResolver(this._dio);

  final Dio _dio;
  static const _searchUrl =
      'https://www.googleapis.com/youtube/v3/search';

  String get _apiKey => dotenv.env['YOUTUBE_API_KEY'] ?? '';
  String get _searchMethod => (dotenv.env['YOUTUBE_SEARCH_METHOD'] ?? 'api').toLowerCase();

  Future<List<String>> resolve(String artistName, String trackName, {String? regionCode}) async {
    if (_searchMethod == 'scraping') {
      return _viaScraping(artistName, trackName);
    }
    return _viaApi(artistName, trackName, regionCode: regionCode);
  }

  Future<List<String>> _viaApi(String artistName, String trackName, {String? regionCode}) async {
    try {
      final q = '${artistName.toLowerCase()} ${trackName.toLowerCase()} official audio';
      final response = await _dio.get(
        _searchUrl,
        queryParameters: {
          'q': q,
          'key': _apiKey,
          'part': 'snippet',
          'fields': 'items(id(videoId),snippet(title))',
          'maxResults': 5,
          'type': 'video',
          'videoEmbeddable': 'true',
          'videoSyndicated': 'true',
          if (regionCode != null) 'regionCode': regionCode,
        },
      );

      final items = (response.data['items'] as List?) ?? [];

      // Filter out full-album / playlist results (same logic as PHP backend)
      final barWords = ['full album', 'album playlist'];
      final sorted = items.where((item) {
        final title =
            ((item['snippet']?['title'] as String?) ?? '').toLowerCase();
        return !barWords.any((w) => title.contains(w));
      }).toList();

      return sorted
          .map<String>((item) => item['id']['videoId'] as String)
          .where((id) => id.isNotEmpty)
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<String>> _viaScraping(String artistName, String trackName) async {
    try {
      // Adding "-vevo" to filter out official channels which usually block embedding.
      final query = Uri.encodeComponent('$artistName $trackName lyrics -vevo');
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
      return [];
    }
    return [];
  }
}

final youtubeResolverProvider = Provider<YoutubeResolver>((ref) {
  return YoutubeResolver(Dio());
});
