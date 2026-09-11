class CacheConfig {
  /// Defines the payload version for the serialized JSON cache.
  /// If the cache schema changes, increment this version to invalidate old cache entries
  /// without requiring a Drift database migration.
  static const int catalogPayloadVersion = 1;
}

enum ResourceType {
  artist,
  artistTopTracks,
  artistAlbums,
  relatedArtists,
  album,
  playlist,
  playlistTracks,
  newReleases,
  browseCategories,
  featuredPlaylists,
  genreSeeds,
  search,
  discoverRecommendations,
  categoryPlaylists,
  popularTracks,
  recommendations,
}

class CachePolicy {
  final Duration freshFor;
  final Duration usableFor;

  const CachePolicy({required this.freshFor, required this.usableFor});
}

extension ResourceTypePolicy on ResourceType {
  CachePolicy get policy {
    switch (this) {
      case ResourceType.artist:
        return const CachePolicy(
          freshFor: Duration(hours: 24),
          usableFor: Duration(days: 7),
        );
      case ResourceType.artistTopTracks:
        return const CachePolicy(
          freshFor: Duration(hours: 12),
          usableFor: Duration(days: 3),
        );
      case ResourceType.artistAlbums:
        return const CachePolicy(
          freshFor: Duration(hours: 12),
          usableFor: Duration(days: 3),
        );
      case ResourceType.relatedArtists:
        return const CachePolicy(
          freshFor: Duration(hours: 24),
          usableFor: Duration(days: 7),
        );
      case ResourceType.album:
        return const CachePolicy(
          freshFor: Duration(hours: 24),
          usableFor: Duration(days: 7),
        );
      case ResourceType.playlist:
        return const CachePolicy(
          freshFor: Duration(hours: 6),
          usableFor: Duration(days: 2),
        );
      case ResourceType.playlistTracks:
        return const CachePolicy(
          freshFor: Duration(hours: 6),
          usableFor: Duration(days: 2),
        );
      case ResourceType.newReleases:
        return const CachePolicy(
          freshFor: Duration(hours: 3),
          usableFor: Duration(hours: 24),
        );
      case ResourceType.browseCategories:
        return const CachePolicy(
          freshFor: Duration(hours: 6),
          usableFor: Duration(days: 3),
        );
      case ResourceType.featuredPlaylists:
        return const CachePolicy(
          freshFor: Duration(hours: 2),
          usableFor: Duration(hours: 24),
        );
      case ResourceType.genreSeeds:
        return const CachePolicy(
          freshFor: Duration(hours: 24),
          usableFor: Duration(days: 7),
        );
      case ResourceType.search:
        return const CachePolicy(
          freshFor: Duration(minutes: 30),
          usableFor: Duration(hours: 6),
        );
      case ResourceType.discoverRecommendations:
        return const CachePolicy(
          freshFor: Duration(minutes: 45),
          usableFor: Duration(hours: 6),
        );
      case ResourceType.categoryPlaylists:
        return const CachePolicy(
          freshFor: Duration(hours: 12),
          usableFor: Duration(days: 3),
        );
      case ResourceType.popularTracks:
        return const CachePolicy(
          freshFor: Duration(hours: 12),
          usableFor: Duration(days: 3),
        );
      case ResourceType.recommendations:
        return const CachePolicy(
          freshFor: Duration(hours: 12),
          usableFor: Duration(days: 3),
        );
    }
  }
}

class CacheKeyBuilder {
  static String artist(String id) => 'artist:$id';

  static String artistTopTracks(String artistId, String market) =>
      'artist-top-tracks:$artistId:$market';

  static String artistAlbums(
    String artistId,
    String market, {
    int limit = 20,
    int offset = 0,
  }) => 'artist-albums:$artistId:$market:$limit:$offset';

  static String relatedArtists(String artistId) => 'related-artists:$artistId';

  static String album(String albumId, String market) =>
      'album:$albumId:$market';

  static String playlist(String playlistId, String market) =>
      'playlist:$playlistId:$market';

  static String playlistTracks(
    String playlistId,
    String market, {
    int limit = 100,
    int offset = 0,
  }) => 'playlist-tracks:$playlistId:$market:$limit:$offset';

  static String newReleases(String market) => 'new-releases:$market';

  static String browseCategories(
    String market, {
    int limit = 20,
    int offset = 0,
  }) => 'browse-categories:$market:$limit:$offset';

  static String featuredPlaylists(String market) =>
      'featured-playlists:$market';

  static String genreSeeds() => 'genre-seeds';

  static String search(
    String normalizedQuery,
    String type,
    String market, {
    int limit = 20,
    int offset = 0,
  }) => 'search:$type:$normalizedQuery:$market:$limit:$offset';

  static String discover(String fingerprint, String market) =>
      'discover:$fingerprint:$market';

  static String categoryPlaylists(
    String categoryId,
    String market, {
    int limit = 20,
    int offset = 0,
  }) => 'category-playlists:$categoryId:$market:$limit:$offset';

  static String popularTracks(String market, {int limit = 50}) =>
      'popular-tracks:$market:$limit';

  static String recommendations(
    String market, {
    String? seedArtistId,
    String? seedTrackId,
    String? seedGenres,
    int limit = 20,
  }) => 'recommendations:$market:$seedArtistId:$seedTrackId:$seedGenres:$limit';
}
