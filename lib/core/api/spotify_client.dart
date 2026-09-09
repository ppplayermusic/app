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

  Future<List<Track>> searchTracks(String query, {int limit = 20}) async {
    final data = await search(query, limit: limit);
    final items = (data['tracks']?['items'] as List?) ?? [];
    return items.map((j) => Track.fromSpotify(j as Map<String, dynamic>)).toList();
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
    try {
      final response = await _dio.get(
        '$_baseUrl/browse/new-releases',
        queryParameters: {'limit': limit, 'country': market},
        options: Options(headers: await _authHeaders()),
      );
      final items = (response.data['albums']['items'] as List?) ?? [];
      return items.whereType<Map<String, dynamic>>().toList();
    } catch (e) {
      if (e is SpotifyAuthException) rethrow;
      try {
        final year = DateTime.now().year;
        final response = await _dio.get(
          '$_baseUrl/search',
          queryParameters: {
            'q': 'year:${year - 1}-$year',
            'type': 'album',
            'limit': limit,
            'market': market,
          },
          options: Options(headers: await _authHeaders()),
        );
        final items = (response.data['albums']['items'] as List?) ?? [];
        return items.whereType<Map<String, dynamic>>().toList();
      } catch (_) {
        throw Exception('Failed to load new releases.');
      }
    }
  }

  Future<List<Track>> getRecommendations({
    String? seedTrackId,
    String? seedArtistId,
    String? seedGenres,
    int limit = 50,
  }) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/recommendations',
        queryParameters: {
          if (seedTrackId != null) 'seed_tracks': seedTrackId,
          if (seedArtistId != null) 'seed_artists': seedArtistId,
          if (seedGenres != null) 'seed_genres': seedGenres,
          'limit': limit,
          'market': market,
          'min_popularity': 10,
        },
        options: Options(headers: await _authHeaders()),
      );
      final items = (response.data['tracks'] as List?) ?? [];
      return items.map((j) => Track.fromSpotify(j as Map<String, dynamic>)).toList();
    } catch (e) {
      if (e is SpotifyAuthException) rethrow;
      try {
        if (seedArtistId != null && seedArtistId.isNotEmpty) {
           final items = await getArtistTopTracks(seedArtistId.split(',').first);
           final mapped = items.map((j) => Track.fromSpotify(j as Map<String, dynamic>)).toList();
           if (mapped.isNotEmpty) return mapped;
        } else if (seedGenres != null && seedGenres.isNotEmpty) {
           final items = await searchTracks(seedGenres.split(',').first, limit: limit);
           if (items.isNotEmpty) return items;
        } else if (seedTrackId != null && seedTrackId.isNotEmpty) {
           final items = await getPopularTracks(limit: limit);
           if (items.isNotEmpty) return items;
        }
      } catch (_) {}
      return getPopularTracks(limit: limit);
    }
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

  Future<List<Map<String, dynamic>>> getBrowseCategories({int limit = 20, int offset = 0}) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/browse/categories',
        queryParameters: {
          'limit': limit,
          'offset': offset,
          'country': market,
        },
        options: Options(headers: await _authHeaders()),
      );
      final items = (response.data['categories']['items'] as List?) ?? [];
      return _filterAndSanitizeItems(items);
    } catch (e) {
      if (e is SpotifyAuthException) rethrow;
      // Spotify deprecated the /browse/categories endpoint. Fallback to hardcoded safe categories.
      final fallbackCategories = [
        {'id': 'toplists', 'name': 'Top Lists', 'icons': [{'url': 'https://t.scdn.co/images/4eb37cb6a0af436bb4ea5bd1ab411d87.jpg'}]},
        {'id': 'pop', 'name': 'Pop', 'icons': [{'url': 'https://t.scdn.co/media/derived/pop-274x274_447148649685019f5e2a03a39e78ba52_0_0_274_274.jpg'}]},
        {'id': 'hiphop', 'name': 'Hip-Hop', 'icons': [{'url': 'https://t.scdn.co/images/051790cb90104e138a0c20a40d5885c4.jpg'}]},
        {'id': 'rock', 'name': 'Rock', 'icons': [{'url': 'https://t.scdn.co/images/99245151528b49e69eeec5a676722d3b.jpeg'}]},
        {'id': 'mood', 'name': 'Mood', 'icons': [{'url': 'https://t.scdn.co/media/original/mood-274x274_976986a31ac8c49794cbdc7246fd5ad7_274x274.jpg'}]},
        {'id': 'workout', 'name': 'Workout', 'icons': [{'url': 'https://t.scdn.co/media/derived/workout-274x274_62db200ee12fbe9bdf9753df28d65a88_0_0_274_274.jpg'}]},
        {'id': 'chill', 'name': 'Chill', 'icons': [{'url': 'https://t.scdn.co/media/derived/chill-274x274_4c46374f007813dd10b37e8d8fd35b4b_0_0_274_274.jpg'}]},
      ];
      return fallbackCategories;
    }
  }

  Future<List<Map<String, dynamic>>> getCategoryPlaylists(String categoryId, {int limit = 20, int offset = 0}) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/browse/categories/$categoryId/playlists',
        queryParameters: {
          'limit': limit,
          'offset': offset,
          'country': market,
        },
        options: Options(headers: await _authHeaders()),
      );
      final items = (response.data['playlists']['items'] as List?) ?? [];
      return _filterAndSanitizeItems(items);
    } catch (e) {
      if (e is SpotifyAuthException) rethrow;
      // Fallback to searching for playlists with the category name since the endpoint is deprecated.
      try {
        final response = await _dio.get(
          '$_baseUrl/search',
          queryParameters: {
            'q': categoryId,
            'type': 'playlist',
            'limit': limit,
            'market': market,
          },
          options: Options(headers: await _authHeaders()),
        );
        final items = (response.data['playlists']['items'] as List?) ?? [];
        return _filterAndSanitizeItems(items);
      } catch (_) {
        throw Exception('Failed to load category playlists.');
      }
    }
  }

  Future<List<Track>> getPopularTracks({int limit = 12}) async {
    try {
      // First, try to find the "Top 50 - [Market]" playlist
      final searchResponse = await _dio.get(
        '$_baseUrl/search',
        queryParameters: {
          'q': 'Top 50',
          'type': 'playlist',
          'limit': 5,
          'market': market,
        },
        options: Options(headers: await _authHeaders()),
      );

      final playlists = (searchResponse.data['playlists']?['items'] as List?) ?? [];
      String? playlistId;

      // Try to find a playlist from 'Spotify'
      for (final p in playlists) {
        if (p['owner']?['id'] == 'spotify' && (p['name'] as String).contains('50')) {
          playlistId = p['id'] as String;
          break;
        }
      }

      // Fallback to the first "Top 50" if no Spotify-owned one found
      playlistId ??= playlists.isNotEmpty ? playlists.first['id'] as String : '37i9dQZEVXbMDoHDw22t9N';

      return await getPlaylistTracks(playlistId, limit: limit);
    } catch (e) {
      if (e is SpotifyAuthException) rethrow;
      // Final fallback to Global Top 50 or throw exception
      try {
        final tracks = await getPlaylistTracks('37i9dQZEVXbMDoHDw22t9N', limit: limit);
        if (tracks.isNotEmpty) return tracks;
      } catch (_) {}
      
      throw Exception('Failed to load popular tracks after trying all fallbacks.');
    }
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

  Future<List<Map<String, dynamic>>> searchPlaylists(String query, {int limit = 20}) async {
    final response = await _dio.get(
      '$_baseUrl/search',
      queryParameters: {
        'q': query,
        'type': 'playlist',
        'limit': limit,
        'market': market,
      },
      options: Options(headers: await _authHeaders()),
    );
    final items = (response.data['playlists']?['items'] as List?) ?? [];
    final sanitizedItems = _filterAndSanitizeItems(items);
    return _enrichPlaylistsWithCollage(sanitizedItems);
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
      sanitized['description'] = (sanitized['description'] as String).replaceAll(RegExp(r'Spotify', caseSensitive: false), 'PPPlayer');
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
