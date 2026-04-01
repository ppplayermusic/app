import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/track.dart';
import '../services/settings_provider.dart';

class SpotifyClient {
  SpotifyClient(this._dio, {this.market = 'US'});

  final Dio _dio;
  final String market;
  String? _accessToken;
  DateTime? _tokenExpiry;

  static const _baseUrl = 'https://api.spotify.com/v1';
  static const _tokenUrl = 'https://accounts.spotify.com/api/token';

  String get _clientId => dotenv.env['SPOTIFY_CLIENT_ID'] ?? '';
  String get _clientSecret => dotenv.env['SPOTIFY_CLIENT_SECRET'] ?? '';

  // --- Auth: Client Credentials flow (no user login needed) ---
  Future<void> _ensureToken() async {
    if (_accessToken != null &&
        _tokenExpiry != null &&
        DateTime.now().isBefore(_tokenExpiry!)) {
      return;
    }

    final credentials =
        base64Encode(utf8.encode('$_clientId:$_clientSecret'));
    final response = await _dio.post(
      _tokenUrl,
      data: 'grant_type=client_credentials',
      options: Options(
        headers: {
          'Authorization': 'Basic $credentials',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      ),
    );

    _accessToken = response.data['access_token'] as String;
    final expiresIn = response.data['expires_in'] as int;
    _tokenExpiry = DateTime.now().add(Duration(seconds: expiresIn - 60));
  }

  Future<Map<String, String>> _authHeaders() async {
    await _ensureToken();
    return {'Authorization': 'Bearer $_accessToken'};
  }

  // --- Search ---
  Future<Map<String, dynamic>> search(String query, {int limit = 20}) async {
    final response = await _dio.get(
      '$_baseUrl/search',
      queryParameters: {
        'q': query,
        'type': 'track,artist,album',
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
        'min_popularity': 20,
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
    final items = (response.data['playlists']['items'] as List?) ?? [];
    return items.whereType<Map<String, dynamic>>().toList();
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
    return items.map((j) {
      final map = (j as Map<String, dynamic>)['track'] as Map<String, dynamic>;
      return Track.fromSpotify(map);
    }).toList();
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
    return items.whereType<Map<String, dynamic>>().toList();
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
    return items.whereType<Map<String, dynamic>>().toList();
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
      // Fallback to a set of universally safe seeds
      return const [
        'pop', 'rock', 'hip-hop', 'edm', 'indie', 'alternative', 
        'chill', 'dance', 'electronic', 'jazz', 'classical', 
        'r-n-b', 'country', 'metal', 'funk', 'soul', 'reggae'
      ];
    }
  }
}

final spotifyClientProvider = Provider<SpotifyClient>((ref) {
  final market = ref.watch(selectedCountryProvider);
  final dio = Dio();
  dio.interceptors.add(LogInterceptor(
    requestHeader: true,
    requestBody: true,
    responseHeader: false,
    responseBody: true,
    error: true,
  ));
  return SpotifyClient(dio, market: market);
});
