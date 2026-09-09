import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/track.dart';
import '../services/settings_provider.dart';
import '../metrics/cache_metrics.dart';
import 'spotify_auth.dart';

class SpotifyClient {
  SpotifyClient(this._dio, this._authHandler, {this.market = 'US'});

  final Dio _dio;
  final SpotifyAuthHandler _authHandler;
  final String market;

  static const _baseUrl = 'https://api.spotify.com/v1';

  Future<Map<String, String>> _authHeaders() async {
    final token = await _authHandler.getAccessToken();
    return {'Authorization': 'Bearer $token'};
  }

  // --- Search ---
  Future<Map<String, dynamic>> search(String query, {int limit = 20}) async {
    final response = await _dio.get(
      '$_baseUrl/search',
      queryParameters: {
        'q': query,
        'type': 'track,artist,album,playlist',
        'limit': limit,
        'market': market,
      },
      options: Options(headers: await _authHeaders()),
    );
    return response.data as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> _paginatedSearch(
    String query,
    String type,
    String resultKey, {
    int limit = 20,
  }) async {
    final items = <Map<String, dynamic>>[];
    final seenIds = <String>{};
    int offset = 0;

    while (items.length < limit) {
      final fetchLimit = (limit - items.length).clamp(1, 10);
      int rateLimitRetries = 0;
      int transientRetries = 0;
      late Response response;
      
      while (true) {
        try {
          response = await _dio.get(
            '$_baseUrl/search',
            queryParameters: {
              'q': query,
              'type': type,
              'limit': fetchLimit,
              'offset': offset,
              'market': market,
            },
            options: Options(headers: await _authHeaders()),
          );
          break; // success
        } on DioException catch (e) {
          final status = e.response?.statusCode;
          if (status == 401) {
            throw SpotifyAuthException('Auth failed (401) in paginated search', e);
          }
          if (status == 429) {
            if (rateLimitRetries >= 1) rethrow; // bound rate limit retries
            final retryStr = e.response?.headers.value('retry-after');
            final retryAfter = int.tryParse(retryStr ?? '1') ?? 1;
            if (retryAfter > 5) rethrow; // cap pathological wait times
            rateLimitRetries++;
            await Future.delayed(Duration(seconds: retryAfter));
            continue;
          }
          if (status == 502 || status == 503 || status == 504) {
            if (transientRetries >= 1) rethrow; // bound transient retries
            transientRetries++;
            await Future.delayed(const Duration(milliseconds: 500));
            continue;
          }
          rethrow; // 403, 404, etc. -> let caller track the failure
        }
      }

      final fetched = (response.data[resultKey]?['items'] as List?) ?? [];
      if (fetched.isEmpty) break;

      for (final item in fetched.whereType<Map<String, dynamic>>()) {
        final id = item['id'] as String?;
        if (id != null && seenIds.add(id)) {
          items.add(item);
        }
      }
      offset += fetched.length; // Spotify offset advances by fetched length
      if (fetched.length < fetchLimit) break;
    }
    return items;
  }

  Future<List<Track>> searchTracks(String query, {int limit = 20}) async {
    final items = await _paginatedSearch(query, 'track', 'tracks', limit: limit);
    return items.map((j) => Track.fromSpotify(j)).toList();
  }

  Future<List<Map<String, dynamic>>> searchPlaylists(String query, {int limit = 20}) async {
    return _paginatedSearch(query, 'playlist', 'playlists', limit: limit);
  }

  // --- Artist ---
  Future<Map<String, dynamic>> getArtist(String artistId) async {
    final response = await _dio.get(
      '$_baseUrl/artists/$artistId',
      options: Options(headers: await _authHeaders()),
    );
    return response.data as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> getMultipleArtists(List<String> ids) async {
    if (ids.isEmpty) return [];
    final response = await _dio.get(
      '$_baseUrl/artists',
      queryParameters: {'ids': ids.join(',')},
      options: Options(headers: await _authHeaders()),
    );
    final items = (response.data['artists'] as List?) ?? [];
    return items.whereType<Map<String, dynamic>>().toList();
  }

  Future<List<dynamic>> getArtistTopTracks(String artistId) async {
    final response = await _dio.get(
      '$_baseUrl/artists/$artistId/top-tracks',
      queryParameters: {'market': market},
      options: Options(headers: await _authHeaders()),
    );
    final items = (response.data['tracks'] as List?) ?? [];
    return items;
  }

  Future<List<dynamic>> getArtistAlbums(String artistId,
      {int limit = 20}) async {
    final response = await _dio.get(
      '$_baseUrl/artists/$artistId/albums',
      queryParameters: {
        'include_groups': 'album,single',
        'limit': limit,
        'market': market,
      },
      options: Options(headers: await _authHeaders()),
    );
    final items = (response.data['items'] as List?) ?? [];
    return items;
  }

  // --- Track ---
  Future<Track> getTrack(String trackId) async {
    final response = await _dio.get(
      '$_baseUrl/tracks/$trackId',
      queryParameters: {'market': market},
      options: Options(headers: await _authHeaders()),
    );
    return Track.fromSpotify(response.data as Map<String, dynamic>);
  }

  // --- Album ---
  Future<Map<String, dynamic>> getAlbum(String albumId) async {
    final response = await _dio.get(
      '$_baseUrl/albums/$albumId',
      queryParameters: {'market': market},
      options: Options(headers: await _authHeaders()),
    );
    return response.data as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> getMultipleAlbums(List<String> ids) async {
    if (ids.isEmpty) return [];
    final response = await _dio.get(
      '$_baseUrl/albums',
      queryParameters: {
        'ids': ids.join(','),
        'market': market,
      },
      options: Options(headers: await _authHeaders()),
    );
    final items = (response.data['albums'] as List?) ?? [];
    return items.whereType<Map<String, dynamic>>().toList();
  }

  Future<List<Track>> getAlbumTracks(String albumId) async {
    final album = await getAlbum(albumId);
    final imageUrl = ((album['images'] as List?)?.firstOrNull?['url'] as String?);
    final response = await _dio.get(
      '$_baseUrl/albums/$albumId/tracks',
      queryParameters: {'market': market},
      options: Options(headers: await _authHeaders()),
    );
    final items = (response.data['items'] as List?) ?? [];
    return items.map((j) {
      final map = j as Map<String, dynamic>;
      // Inject album info since simplified tracks don't have it
      return Track.fromSpotify({
        ...map,
        'album': {
          'id': albumId,
          'name': album['name'],
          'images': [{'url': imageUrl}],
        },
      });
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getNewReleases({int limit = 10}) async {
    final year = DateTime.now().year;
    final items = await _paginatedSearch('year:${year - 1}-$year', 'album', 'albums', limit: limit);
    
    items.sort((a, b) {
      final dateA = a['release_date'] as String? ?? '';
      final dateB = b['release_date'] as String? ?? '';
      return dateB.compareTo(dateA);
    });
    
    return items;
  }

  Future<List<Track>> getRecommendations({
    String? seedTrackId,
    String? seedArtistId,
    String? seedGenres,
    int limit = 50,
  }) async {
    try {
      String? targetArtistId = seedArtistId?.split(',').first;
      
      if (targetArtistId == null && seedTrackId != null && seedTrackId.isNotEmpty) {
        final track = await getTrack(seedTrackId.split(',').first);
        targetArtistId = track.artistId.split(',').first;
      }

      if (targetArtistId != null && targetArtistId.isNotEmpty) {
        final List<Track> artistTracks = [];
        
        // Tier 1: Original Artist
        try {
          final topTracksData = await getArtistTopTracks(targetArtistId);
          final topTracks = topTracksData
              .map((t) => Track.fromSpotify(t as Map<String, dynamic>))
              .where((t) => t.artistId.split(',').contains(targetArtistId));
          artistTracks.addAll(topTracks);
          
          final albumsData = await getArtistAlbums(targetArtistId, limit: 3);
          final albumFutures = albumsData.map((a) {
            final albumId = (a as Map<String, dynamic>)['id'] as String;
            return getAlbumTracks(albumId);
          });
          
          final albumsTracks = await Future.wait(albumFutures);
          for (final tracks in albumsTracks) {
            artistTracks.addAll(tracks.where((t) => t.artistId.split(',').contains(targetArtistId)));
          }
        } catch (e) {
          debugPrint('Failed to fetch artist tracks: $e');
        }
        
        artistTracks.shuffle();
        
        final List<Track> allTracks = [...artistTracks];
        
        // Tier 2: Related Artists
        if (allTracks.length < limit * 2) {
          try {
             final relatedArtists = await getRelatedArtists(targetArtistId);
             final relatedFutures = relatedArtists.take(5).map((a) => getArtistTopTracks(a['id'] as String));
             final relatedTracksData = await Future.wait(relatedFutures);
             
             final List<Track> relatedTracks = [];
             for (final data in relatedTracksData) {
                relatedTracks.addAll(data.map((t) => Track.fromSpotify(t as Map<String, dynamic>)));
             }
             relatedTracks.shuffle();
             allTracks.addAll(relatedTracks);
          } catch (e) {
            debugPrint('Failed to fetch related artist tracks: $e');
          }
        }
        
        final uniqueTracks = <String, Track>{};
        for (final t in allTracks) {
          if (!uniqueTracks.containsKey(t.spotifyId)) {
             uniqueTracks[t.spotifyId] = t;
          }
        }
        
        final results = uniqueTracks.values.take(limit).toList();
        if (results.isNotEmpty) return results;
      } else if (seedGenres != null && seedGenres.isNotEmpty) {
        final items = await searchTracks('genre:${seedGenres.split(',').first}', limit: limit);
        if (items.isNotEmpty) return items;
      }
    } catch (e) {
      if (e is SpotifyAuthException) rethrow;
    }
    return getPopularTracks(limit: limit);
  }

  // --- Playlists ---
  Future<List<Map<String, dynamic>>> getFeaturedPlaylists({int limit = 20}) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/browse/featured-playlists',
        queryParameters: {
          'limit': limit,
          'country': market,
        },
        options: Options(headers: await _authHeaders()),
      );
      final items = (response.data['playlists']['items'] as List?) ?? [];
      final sanitizedItems = _filterAndSanitizeItems(items);
      return _enrichPlaylistsWithCollage(sanitizedItems);
    } catch (e) {
      if (e is SpotifyAuthException) rethrow;
      // /browse/featured-playlists is deprecated. Fallback to search.
      try {
        final response = await _dio.get(
          '$_baseUrl/search',
          queryParameters: {
            'q': 'Top Hits',
            'type': 'playlist',
            'limit': limit,
            'market': market,
          },
          options: Options(headers: await _authHeaders()),
        );
        final items = (response.data['playlists']['items'] as List?) ?? [];
        final sanitizedItems = _filterAndSanitizeItems(items);
        return _enrichPlaylistsWithCollage(sanitizedItems);
      } catch (_) {
        throw Exception('Failed to load featured playlists.');
      }
    }
  }

  Future<List<Track>> getPlaylistTracks(String playlistId, {int limit = 20}) async {
    final response = await _dio.get(
      '$_baseUrl/playlists/$playlistId/tracks',
      queryParameters: {
        'limit': limit,
        'market': market,
      },
      options: Options(headers: await _authHeaders()),
    );
    final items = (response.data['items'] as List?) ?? [];
    final tracks = <Track>[];
    for (final j in items) {
      if (j is! Map<String, dynamic>) continue;
      final trackData = j['track'];
      if (trackData is! Map<String, dynamic>) continue;
      if (trackData['id'] == null || trackData['name'] == null) continue;
      try {
        tracks.add(Track.fromSpotify(_sanitizeData(Map<String, dynamic>.from(trackData))));
      } catch (e) {
        debugPrint('SpotifyClient: Skipped invalid track: $e');
      }
    }
    return tracks;
  }

  static const List<CategoryDefinition> _ppplayerCategories = [
    CategoryDefinition(
      id: 'toplists',
      label: 'Top Lists',
      searchQueries: ['top hits', 'viral 50', 'global top 50'],
      iconUrl: 'https://t.scdn.co/images/4eb37cb6a0af436bb4ea5bd1ab411d87.jpg',
    ),
    CategoryDefinition(
      id: 'pop',
      label: 'Pop',
      searchQueries: ['genre:pop', 'pop', 'dance pop'],
      iconUrl: 'https://t.scdn.co/media/derived/pop-274x274_447148649685019f5e2a03a39e78ba52_0_0_274_274.jpg',
    ),
    CategoryDefinition(
      id: 'hiphop',
      label: 'Hip-Hop',
      searchQueries: ['genre:hip-hop', 'hip hop', 'rap', 'trap'],
      iconUrl: 'https://t.scdn.co/images/051790cb90104e138a0c20a40d5885c4.jpg',
    ),
    CategoryDefinition(
      id: 'rock',
      label: 'Rock',
      searchQueries: ['genre:rock', 'rock', 'alternative rock'],
      iconUrl: 'https://t.scdn.co/images/99245151528b49e69eeec5a676722d3b.jpeg',
    ),
    CategoryDefinition(
      id: 'mood',
      label: 'Mood',
      searchQueries: ['mood', 'feel good', 'sad'],
      iconUrl: 'https://t.scdn.co/media/original/mood-274x274_976986a31ac8c49794cbdc7246fd5ad7_274x274.jpg',
    ),
    CategoryDefinition(
      id: 'workout',
      label: 'Workout',
      searchQueries: ['workout', 'gym', 'running'],
      iconUrl: 'https://t.scdn.co/media/derived/workout-274x274_62db200ee12fbe9bdf9753df28d65a88_0_0_274_274.jpg',
    ),
    CategoryDefinition(
      id: 'chill',
      label: 'Chill',
      searchQueries: ['chill', 'relax', 'lo-fi'],
      iconUrl: 'https://t.scdn.co/media/derived/chill-274x274_4c46374f007813dd10b37e8d8fd35b4b_0_0_274_274.jpg',
    ),
  ];

  Future<List<Map<String, dynamic>>> getBrowseCategories({int limit = 20, int offset = 0}) async {
    // PPPlayer owns the categories to prevent reliance on removed Spotify endpoints
    return _ppplayerCategories.map((c) => c.toJson()).toList();
  }

  Future<List<Map<String, dynamic>>> getCategoryPlaylists(String categoryId, {int limit = 20, int offset = 0}) async {
    final category = _ppplayerCategories.firstWhere(
      (c) => c.id == categoryId,
      orElse: () => _ppplayerCategories.first,
    );

    final playlists = <Map<String, dynamic>>[];
    final seenIds = <String>{};
    final fetchLimit = (limit / category.searchQueries.length).ceil().clamp(5, 10);

    for (final q in category.searchQueries) {
      if (playlists.length >= limit) break;
      try {
        final items = await searchPlaylists(q, limit: fetchLimit);
        for (final p in items) {
          final id = p['id'] as String?;
          if (id != null && seenIds.add(id)) {
            playlists.add(p);
          }
        }
      } catch (e) {
        if (e is SpotifyAuthException) rethrow;
      }
    }

    final sanitized = _filterAndSanitizeItems(playlists.take(limit).toList());
    return sanitized;
  }

  Future<List<Track>> getPopularTracks({int limit = 12}) async {
    final year = DateTime.now().year;
    final queries = [
      'year:$year',
      'year:${year - 1}',
      'genre:pop',
      'genre:hip-hop',
      'genre:rock',
      'genre:latin',
      'genre:electronic',
    ];
    queries.shuffle();

    final tracks = <Track>[];
    final seenIds = <String>{};
    bool allFailed = true;

    // Fetch a small chunk from multiple queries to ensure variety
    final fetchLimit = (limit / 2).ceil().clamp(5, 10);

    for (final q in queries) {
      if (tracks.length >= limit) break;
      try {
        final results = await searchTracks(q, limit: fetchLimit);
        allFailed = false;
        for (final t in results) {
          if (t.spotifyId.isNotEmpty && seenIds.add(t.spotifyId)) {
            tracks.add(t);
          }
        }
      } catch (e) {
        if (e is SpotifyAuthException) rethrow;
      }
    }

    if (allFailed) {
      throw Exception('Failed to load popular tracks after trying all queries.');
    }

    return tracks.take(limit).toList();
  }

  Future<List<String>> getAvailableMarkets() async {
    final response = await _dio.get(
      '$_baseUrl/markets',
      options: Options(headers: await _authHeaders()),
    );
    return (response.data['markets'] as List).cast<String>();
  }

  // --- New Enhancements ---
  Future<List<Map<String, dynamic>>> getRelatedArtists(String artistId) async {
    final response = await _dio.get(
      '$_baseUrl/artists/$artistId/related-artists',
      options: Options(headers: await _authHeaders()),
    );
    final items = (response.data['artists'] as List?) ?? [];
    return items.whereType<Map<String, dynamic>>().toList();
  }


  Future<List<String>> getAvailableGenreSeeds() async {
    try {
      final response = await _dio.get(
        '$_baseUrl/recommendations/available-genre-seeds',
        options: Options(headers: await _authHeaders()),
      );
      return (response.data['genres'] as List).cast<String>();
    } catch (e) {
      if (e is SpotifyAuthException) rethrow;
      // Fallback to a set of universally safe seeds
      return const [
        'pop', 'rock', 'hip-hop', 'edm', 'indie', 'alternative', 
        'chill', 'dance', 'electronic', 'jazz', 'classical', 
        'r-n-b', 'country', 'metal', 'funk', 'soul', 'reggae'
      ];
    }
  }

  List<Map<String, dynamic>> _filterAndSanitizeItems(List<dynamic> items) {
    return items.whereType<Map<String, dynamic>>().where((item) {
      final id = item['id'];
      final name = (item['name'] as String?)?.toLowerCase() ?? '';
      
      // Filter out invalid items (like null placeholders from Spotify API)
      if (id == null || name.trim().isEmpty) return false;
      
      return !name.contains('spotify sessions') && !name.contains('spotify singles');
    }).map(_sanitizeData).toList();
  }

  Map<String, dynamic> _sanitizeData(Map<String, dynamic> data) {
    final sanitized = Map<String, dynamic>.from(data);
    
    if (sanitized['name'] is String) {
      sanitized['name'] = (sanitized['name'] as String).replaceAll(RegExp(r'Spotify', caseSensitive: false), 'PPPlayer');
    }
    if (sanitized['description'] is String) {
      sanitized['description'] = (sanitized['description'] as String)
          .replaceAll(RegExp(r'Spotify', caseSensitive: false), 'PPPlayer')
          .replaceAll(RegExp(r'<[^>]*>', multiLine: true), '');
    }
    if (sanitized['message'] is String) {
      sanitized['message'] = (sanitized['message'] as String).replaceAll(RegExp(r'Spotify', caseSensitive: false), 'PPPlayer');
    }
    
    return sanitized;
  }

  Future<List<Map<String, dynamic>>> _enrichPlaylistsWithCollage(List<Map<String, dynamic>> playlists) async {
    return await Future.wait(playlists.map((playlist) async {
      try {
        final ownerId = playlist['owner']?['id'] as String?;
        if (ownerId == 'spotify') {
          final playlistId = playlist['id'] as String;
          // Fetch up to 3 tracks to create a collage cover
          final tracks = await getPlaylistTracks(playlistId, limit: 3);
          final trackImages = tracks
              .map((t) => t.albumImage)
              .whereType<String>()
              .take(3)
              .toList();
              
          if (trackImages.isNotEmpty) {
            playlist['images'] = trackImages.map((url) => {'url': url}).toList();
          }
        }
      } catch (e) {
        if (e is SpotifyAuthException) rethrow;
        // Fallback to original image
      }
      return playlist;
    }));
  }
}

final spotifyClientProvider = Provider<SpotifyClient>((ref) {
  final market = ref.watch(selectedCountryProvider);
  final dio = Dio();
  
  if (kDebugMode) {
    dio.interceptors.add(LogInterceptor(
      requestHeader: true,
      requestBody: false, // Security: redact credentials
      responseHeader: false,
      responseBody: false, // Security: redact tokens
      error: true,
    ));
  }
  
  final metrics = ref.watch(cacheMetricsProvider);
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      metrics.spotifyRequests++;
      handler.next(options);
    }
  ));
  
  final authHandler = ref.watch(spotifyAuthHandlerProvider(dio));
  return SpotifyClient(dio, authHandler, market: market);
});

class CategoryDefinition {
  const CategoryDefinition({
    required this.id,
    required this.label,
    required this.searchQueries,
    required this.iconUrl,
  });
  
  final String id;
  final String label;
  final List<String> searchQueries;
  final String iconUrl;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': label,
    'icons': [{'url': iconUrl}],
  };
}
