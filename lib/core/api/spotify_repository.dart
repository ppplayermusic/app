import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/track.dart';
import '../cache/cache_config.dart';
import '../cache/catalog_cache_repository.dart';
import 'spotify_client.dart';

class SpotifyRepository {
  final SpotifyClient _client;
  final CatalogCacheRepository _cache;

  SpotifyRepository(this._client, this._cache);

  String get market => _client.market;

  // --- Artist ---
  Stream<CacheResult<Map<String, dynamic>>> watchArtist(String artistId) {
    return _cache.watchOrFetch(
      key: CacheKeyBuilder.artist(artistId),
      resourceType: ResourceType.artist,
      fetch: () => _client.getArtist(artistId),
      decode: (json) => jsonDecode(json) as Map<String, dynamic>,
      encode: (data) => jsonEncode(data),
    );
  }

  Stream<CacheResult<List<dynamic>>> watchArtistTopTracks(String artistId) {
    return _cache.watchOrFetch(
      key: CacheKeyBuilder.artistTopTracks(artistId, market),
      resourceType: ResourceType.artistTopTracks,
      fetch: () => _client.getArtistTopTracks(artistId),
      decode: (json) => jsonDecode(json) as List<dynamic>,
      encode: (data) => jsonEncode(data),
    );
  }

  Stream<CacheResult<List<dynamic>>> watchArtistAlbums(String artistId) {
    return _cache.watchOrFetch(
      key: CacheKeyBuilder.artistAlbums(artistId, market),
      resourceType: ResourceType.artistAlbums,
      fetch: () => _client.getArtistAlbums(artistId),
      decode: (json) => jsonDecode(json) as List<dynamic>,
      encode: (data) => jsonEncode(data),
    );
  }

  Stream<CacheResult<List<Map<String, dynamic>>>> watchRelatedArtists(
    String artistId,
  ) {
    return _cache.watchOrFetch(
      key: CacheKeyBuilder.relatedArtists(artistId),
      resourceType: ResourceType.relatedArtists,
      fetch: () => _client.getRelatedArtists(artistId),
      decode: (json) => (jsonDecode(json) as List).cast<Map<String, dynamic>>(),
      encode: (data) => jsonEncode(data),
    );
  }

  // --- Album ---
  Stream<CacheResult<Map<String, dynamic>>> watchAlbum(String albumId) {
    return _cache.watchOrFetch(
      key: CacheKeyBuilder.album(albumId, market),
      resourceType: ResourceType.album,
      fetch: () => _client.getAlbum(albumId),
      decode: (json) => jsonDecode(json) as Map<String, dynamic>,
      encode: (data) => jsonEncode(data),
    );
  }

  // --- Playlist ---
  Stream<CacheResult<List<Map<String, dynamic>>>> watchFeaturedPlaylists() {
    return _cache.watchOrFetch(
      key: CacheKeyBuilder.featuredPlaylists(market),
      resourceType: ResourceType.featuredPlaylists,
      fetch: () => _client.getFeaturedPlaylists(),
      decode: (json) => (jsonDecode(json) as List).cast<Map<String, dynamic>>(),
      encode: (data) => jsonEncode(data),
    );
  }

  Stream<CacheResult<List<Track>>> watchPlaylistTracks(String playlistId) {
    return _cache.watchOrFetch(
      key: CacheKeyBuilder.playlistTracks(playlistId, market),
      resourceType: ResourceType.playlistTracks,
      fetch: () => _client.getPlaylistTracks(playlistId),
      decode: (json) => (jsonDecode(json) as List)
          .map((e) => Track.fromJson(e as Map<String, dynamic>))
          .toList(),
      encode: (data) => jsonEncode(data.map((t) => t.toJson()).toList()),
    );
  }

  // --- Browse ---
  Stream<CacheResult<List<Map<String, dynamic>>>> watchNewReleases() {
    return _cache.watchOrFetch(
      key: CacheKeyBuilder.newReleases(market),
      resourceType: ResourceType.newReleases,
      fetch: () => _client.getNewReleases(),
      decode: (json) => (jsonDecode(json) as List).cast<Map<String, dynamic>>(),
      encode: (data) => jsonEncode(data),
    );
  }

  Stream<CacheResult<List<Map<String, dynamic>>>> watchBrowseCategories({
    int limit = 20,
    int offset = 0,
  }) {
    return _cache.watchOrFetch(
      key: CacheKeyBuilder.browseCategories(
        market,
        limit: limit,
        offset: offset,
      ),
      resourceType: ResourceType.browseCategories,
      fetch: () => _client.getBrowseCategories(limit: limit, offset: offset),
      decode: (json) => (jsonDecode(json) as List).cast<Map<String, dynamic>>(),
      encode: (data) => jsonEncode(data),
    );
  }

  Stream<CacheResult<List<Map<String, dynamic>>>> watchCategoryPlaylists(
    String categoryId, {
    int limit = 20,
    int offset = 0,
  }) {
    return _cache.watchOrFetch(
      key: CacheKeyBuilder.categoryPlaylists(
        categoryId,
        market,
        limit: limit,
        offset: offset,
      ),
      resourceType: ResourceType.categoryPlaylists,
      fetch: () => _client.getCategoryPlaylists(
        categoryId,
        limit: limit,
        offset: offset,
      ),
      decode: (json) => (jsonDecode(json) as List).cast<Map<String, dynamic>>(),
      encode: (data) => jsonEncode(data),
    );
  }

  Stream<CacheResult<List<String>>> watchGenreSeeds() {
    return _cache.watchOrFetch(
      key: CacheKeyBuilder.genreSeeds(),
      resourceType: ResourceType.genreSeeds,
      fetch: () => _client.getAvailableGenreSeeds(),
      decode: (json) => (jsonDecode(json) as List).cast<String>(),
      encode: (data) => jsonEncode(data),
    );
  }

  Stream<CacheResult<List<Track>>> watchRecommendations({
    String? seedArtistId,
    String? seedTrackId,
    String? seedGenres,
    int limit = 20,
  }) {
    return _cache.watchOrFetch(
      key: CacheKeyBuilder.recommendations(
        market,
        seedArtistId: seedArtistId,
        seedTrackId: seedTrackId,
        seedGenres: seedGenres,
        limit: limit,
      ),
      resourceType: ResourceType.recommendations,
      fetch: () => _client.getRecommendations(
        seedArtistId: seedArtistId,
        seedTrackId: seedTrackId,
        seedGenres: seedGenres,
        limit: limit,
      ),
      decode: (json) => (jsonDecode(json) as List)
          .map((e) => Track.fromJson(e as Map<String, dynamic>))
          .toList(),
      encode: (data) => jsonEncode(data.map((t) => t.toJson()).toList()),
    );
  }

  // --- Popular / Helpers ---
  Stream<CacheResult<List<Track>>> watchPopularTracks({int limit = 50}) {
    return _cache.watchOrFetch(
      key: CacheKeyBuilder.popularTracks(market, limit: limit),
      resourceType: ResourceType.popularTracks,
      fetch: () => _client.getPopularTracks(limit: limit),
      decode: (json) => (jsonDecode(json) as List)
          .map((e) => Track.fromJson(e as Map<String, dynamic>))
          .toList(),
      encode: (data) => jsonEncode(data.map((t) => t.toJson()).toList()),
    );
  }

  Stream<CacheResult<List<Map<String, dynamic>>>> watchPopularArtists(
    List<String> artistIds,
  ) {
    // We sort the IDs to ensure cache key stability
    final sortedIds = List<String>.from(artistIds)..sort();
    return _cache.watchOrFetch(
      key: 'popular-artists:${sortedIds.join(',')}',
      resourceType: ResourceType.artist,
      fetch: () => _client.getMultipleArtists(sortedIds),
      decode: (json) => (jsonDecode(json) as List).cast<Map<String, dynamic>>(),
      encode: (data) => jsonEncode(data),
    );
  }

  Stream<CacheResult<List<Map<String, dynamic>>>> watchPopularAlbums(
    List<String> albumIds,
  ) {
    final sortedIds = List<String>.from(albumIds)..sort();
    return _cache.watchOrFetch(
      key: 'popular-albums:${sortedIds.join(',')}:$market',
      resourceType: ResourceType.album,
      fetch: () => _client.getMultipleAlbums(sortedIds),
      decode: (json) => (jsonDecode(json) as List).cast<Map<String, dynamic>>(),
      encode: (data) => jsonEncode(data),
    );
  }

  // Categories and search bypass caching if they take a bunch of parameters, but let's cache search if needed.
  // We'll leave `getMultipleAlbums` etc for direct client calls if they don't map cleanly to resources right now.

  // --- Search ---
  Stream<CacheResult<Map<String, dynamic>>> watchSearch(
    String query, {
    int limit = 20,
  }) {
    final normalizedQuery = query.trim().toLowerCase();
    return _cache.watchOrFetch(
      key: CacheKeyBuilder.search(
        normalizedQuery,
        'track,artist,album,playlist',
        market,
        limit: limit,
        offset: 0,
      ),
      resourceType: ResourceType.search,
      fetch: () => _client.search(query.trim(), limit: limit),
      decode: (json) => jsonDecode(json) as Map<String, dynamic>,
      encode: (data) => jsonEncode(data),
    );
  }
}

final spotifyRepositoryProvider = Provider<SpotifyRepository>((ref) {
  final client = ref.watch(spotifyClientProvider);
  final cache = ref.watch(catalogCacheRepositoryProvider);
  return SpotifyRepository(client, cache);
});
