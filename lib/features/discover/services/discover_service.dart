import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/spotify_client.dart';
import '../../../core/cache/catalog_cache_repository.dart';
import '../../../core/cache/cache_config.dart';
import '../../../core/models/track.dart';
import '../models/discover_models.dart';
import 'discover_seed_builder.dart';

class DiscoverService {
  final SpotifyClient _spotify;
  final DiscoverSeedBuilder _seedBuilder;
  final CatalogCacheRepository _cache;

  DiscoverService(this._spotify, this._seedBuilder, this._cache);

  String _buildFingerprint(DiscoverSeedContext ctx) {
    if (!ctx.hasData) return 'default';
    final recent = ctx.recentTracks.map((t) => t.spotifyId).join(',');
    final favs = (ctx.favoriteTracks.map((t) => t.spotifyId).toList()..sort()).join(',');
    final artists = (ctx.followedArtists.map((a) => a.spotifyId).toList()..sort()).join(',');
    return 'r:$recent|f:$favs|a:$artists';
  }

  Stream<CacheResult<DiscoverContent>> watchDiscoverContent() async* {
    final seedCtx = await _seedBuilder.getContext();
    final fingerprint = _buildFingerprint(seedCtx);

    yield* _cache.watchOrFetch(
      key: CacheKeyBuilder.discover(fingerprint, _spotify.market),
      resourceType: ResourceType.discoverRecommendations,
      fetch: () => _fetchConcurrentDiscoverContent(seedCtx),
      decode: (json) => DiscoverContent.fromJson(jsonDecode(json) as Map<String, dynamic>),
      encode: (data) => jsonEncode(data.toJson()),
    );
  }

  Future<DiscoverContent> _fetchConcurrentDiscoverContent(DiscoverSeedContext seedCtx) async {
    final futures = <Future<DiscoverSection?>>[];

    if (seedCtx.hasRichData) {
      // 1. Made For You (Mixed Seeds)
      final mixedSeeds = _seedBuilder.getMixedSeeds(seedCtx);
      if (mixedSeeds.isNotEmpty) {
        final trackSeeds = mixedSeeds.where((id) => _isTrackId(id, seedCtx)).toList();
        final artistSeeds = mixedSeeds.where((id) => !_isTrackId(id, seedCtx)).toList();
        
        futures.add(_spotify.getRecommendations(
          seedTrackId: trackSeeds.isNotEmpty ? trackSeeds.join(',') : null,
          seedArtistId: artistSeeds.isNotEmpty ? artistSeeds.join(',') : null,
          limit: 15,
        ).then((tracks) => tracks.isNotEmpty ? DiscoverSection(title: 'Made For You', type: DiscoverSectionType.madeForYou, tracks: tracks) : null));
      }

      // 2. Because you listened to...
      if (seedCtx.recentTracks.isNotEmpty) {
         final random = Random(DateTime.now().hour + 1);
         final recentSeed = seedCtx.recentTracks[random.nextInt(min(3, seedCtx.recentTracks.length))];
         futures.add(_spotify.getRecommendations(seedTrackId: recentSeed.spotifyId, limit: 12)
           .then((tracks) => tracks.isNotEmpty ? DiscoverSection(title: 'Because you listened to', subtitle: recentSeed.name, type: DiscoverSectionType.becauseYouListenedTo, tracks: tracks) : null));
      }

      // 3. From your favorites
      if (seedCtx.favoriteTracks.isNotEmpty) {
         final random = Random(DateTime.now().hour + 2);
         final favSeed = seedCtx.favoriteTracks[random.nextInt(min(5, seedCtx.favoriteTracks.length))];
         futures.add(_spotify.getRecommendations(seedTrackId: favSeed.spotifyId, limit: 12)
           .then((tracks) => tracks.isNotEmpty ? DiscoverSection(title: 'From your favorites', subtitle: 'Inspired by ${favSeed.name}', type: DiscoverSectionType.fromFavorites, tracks: tracks) : null));
      }

      // 4. Followed Artists
      if (seedCtx.followedArtists.isNotEmpty) {
         final random = Random(DateTime.now().hour + 3);
         final artistSeed = seedCtx.followedArtists[random.nextInt(min(5, seedCtx.followedArtists.length))];
         futures.add(_spotify.getRecommendations(seedArtistId: artistSeed.spotifyId, limit: 12)
           .then((tracks) => tracks.isNotEmpty ? DiscoverSection(title: 'Artists you follow', subtitle: 'More like ${artistSeed.name}', type: DiscoverSectionType.followedArtists, tracks: tracks) : null));
      }
    } else if (seedCtx.hasData) {
       // Light personalization
       final mixedSeeds = _seedBuilder.getMixedSeeds(seedCtx);
       final trackSeeds = mixedSeeds.where((id) => _isTrackId(id, seedCtx)).toList();
       final artistSeeds = mixedSeeds.where((id) => !_isTrackId(id, seedCtx)).toList();
       
       futures.add(_spotify.getRecommendations(
         seedTrackId: trackSeeds.isNotEmpty ? trackSeeds.join(',') : null,
         seedArtistId: artistSeeds.isNotEmpty ? artistSeeds.join(',') : null,
         limit: 20,
       ).then((tracks) => tracks.isNotEmpty ? DiscoverSection(title: 'Recommended for You', type: DiscoverSectionType.madeForYou, tracks: tracks) : null));
    }

    // Always add Explore / Featured
    futures.add(_spotify.getPopularTracks(limit: 15)
      .then((popular) => popular.isNotEmpty ? DiscoverSection(title: 'Trending', subtitle: 'Popular hits right now', type: DiscoverSectionType.explore, tracks: popular) : null)
      .catchError((_) => null));
    
    futures.add(() async {
      try {
        final genres = await _spotify.getAvailableGenreSeeds();
        if (genres.isNotEmpty) {
          final random = Random(DateTime.now().hour);
          final genre = genres[random.nextInt(min(10, genres.length))];
          final tracks = await _spotify.getRecommendations(seedGenres: genre, limit: 15);
          if (tracks.isNotEmpty) {
             final formattedGenre = genre.split('-').map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '').join(' ');
             return DiscoverSection(title: 'Explore $formattedGenre', type: DiscoverSectionType.explore, tracks: tracks);
          }
        }
      } catch (_) {}
      return null;
    }());

    final fetchedSections = await Future.wait(futures);
    
    // Process sections and deduplicate tracks globally
    final sections = <DiscoverSection>[];
    final seenTrackIds = <String>{};

    for (final section in fetchedSections) {
      if (section == null) continue;
      final uniqueTracks = _dedupe(section.tracks, seenTrackIds);
      if (uniqueTracks.isNotEmpty) {
        sections.add(DiscoverSection(
          title: section.title, 
          subtitle: section.subtitle, 
          type: section.type, 
          tracks: uniqueTracks,
          artists: section.artists,
        ));
      }
    }

    return DiscoverContent(sections: sections, isPersonalized: seedCtx.hasData);
  }

  bool _isTrackId(String id, DiscoverSeedContext ctx) {
     return ctx.recentTracks.any((t) => t.spotifyId == id) || ctx.favoriteTracks.any((t) => t.spotifyId == id);
  }

  List<Track> _dedupe(List<Track> tracks, Set<String> seenIds) {
    final result = <Track>[];
    for (final t in tracks) {
      if (!seenIds.contains(t.spotifyId)) {
        seenIds.add(t.spotifyId);
        result.add(t);
      }
    }
    return result;
  }
}

final discoverServiceProvider = Provider((ref) => DiscoverService(
  ref.watch(spotifyClientProvider), 
  ref.watch(discoverSeedBuilderProvider),
  ref.watch(catalogCacheRepositoryProvider)
));
