import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/track.dart';
import '../services/settings_provider.dart';

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
    final response = await _dio.get(
      '$_baseUrl/browse/new-releases',
      queryParameters: {'limit': limit, 'country': market},
      options: Options(headers: await _authHeaders()),
    );
    final items = (response.data['albums']['items'] as List?) ?? [];
    return items.whereType<Map<String, dynamic>>().toList();
  }

  Future<List<Track>> getRecommendations({
    String? seedTrackId,
    String? seedArtistId,
    String? seedGenres,
    int limit = 50,
  }) async {
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
  }

  // --- Playlists ---
  Future<List<Map<String, dynamic>>> getFeaturedPlaylists({int limit = 20}) async {
    final response = await _dio.get(
      '$_baseUrl/browse/featured-playlists',
      queryParameters: {
        'limit': limit,
        'country': market,
      },
      options: Options(headers: await _authHeaders()),
    );
    final rawItems = (response.data['playlists']['items'] as List?) ?? [];
    final items = _filterAndSanitizeItems(rawItems);
    
    // Replace the Spotify branded cover with a composite 3-track cover for Spotify-owned playlists
    return _enrichPlaylistsWithCollage(items);
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

  Future<List<Map<String, dynamic>>> getBrowseCategories({int limit = 20}) async {
    final response = await _dio.get(
      '$_baseUrl/browse/categories',
      queryParameters: {
        'limit': limit,
        'country': market,
      },
      options: Options(headers: await _authHeaders()),
    );
    final items = (response.data['categories']['items'] as List?) ?? [];
    return _filterAndSanitizeItems(items);
  }

  Future<List<Map<String, dynamic>>> getCategoryPlaylists(String categoryId, {int limit = 20}) async {
    final response = await _dio.get(
      '$_baseUrl/browse/categories/$categoryId/playlists',
      queryParameters: {
        'limit': limit,
        'country': market,
      },
      options: Options(headers: await _authHeaders()),
    );
    final items = (response.data['playlists']['items'] as List?) ?? [];

    return _filterAndSanitizeItems(items);
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
      // Final fallback to Global Top 50 or empty list
      try {
        return await getPlaylistTracks('37i9dQZEVXbMDoHDw22t9N', limit: limit);
      } catch (_) {
        return [];
      }
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
      } catch (_) {
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
  
  final authHandler = ref.watch(spotifyAuthHandlerProvider(dio));
  return SpotifyClient(dio, authHandler, market: market);
});
