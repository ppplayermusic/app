import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/spotify_client.dart';
import '../../../core/models/track.dart';
import '../models/discover_models.dart';
import 'discover_seed_builder.dart';

class DiscoverService {
  final SpotifyClient _spotify;
  final DiscoverSeedBuilder _seedBuilder;

  DiscoverService(this._spotify, this._seedBuilder);

  Future<DiscoverContent> buildDiscoverContent() async {
    final seedCtx = await _seedBuilder.getContext();
    final sections = <DiscoverSection>[];
    final seenTrackIds = <String>{};

    if (seedCtx.hasRichData) {
      // 1. Made For You (Mixed Seeds)
      final mixedSeeds = _seedBuilder.getMixedSeeds(seedCtx);
      if (mixedSeeds.isNotEmpty) {
        final trackSeeds = mixedSeeds.where((id) => _isTrackId(id, seedCtx)).toList();
        final artistSeeds = mixedSeeds.where((id) => !_isTrackId(id, seedCtx)).toList();
        
        final tracks = await _spotify.getRecommendations(
          seedTrackId: trackSeeds.isNotEmpty ? trackSeeds.join(',') : null,
          seedArtistId: artistSeeds.isNotEmpty ? artistSeeds.join(',') : null,
          limit: 15,
        );
        final uniqueTracks = _dedupe(tracks, seenTrackIds);
        if (uniqueTracks.isNotEmpty) {
          sections.add(DiscoverSection(title: 'Made For You', type: DiscoverSectionType.madeForYou, tracks: uniqueTracks));
        }
      }

      // 2. Because you listened to...
      if (seedCtx.recentTracks.isNotEmpty) {
         final random = Random(DateTime.now().hour + 1);
         final recentSeed = seedCtx.recentTracks[random.nextInt(min(3, seedCtx.recentTracks.length))];
         final tracks = await _spotify.getRecommendations(seedTrackId: recentSeed.spotifyId, limit: 12);
         final uniqueTracks = _dedupe(tracks, seenTrackIds);
         if (uniqueTracks.isNotEmpty) {
           sections.add(DiscoverSection(title: 'Because you listened to', subtitle: recentSeed.name, type: DiscoverSectionType.becauseYouListenedTo, tracks: uniqueTracks));
         }
      }

      // 3. From your favorites
      if (seedCtx.favoriteTracks.isNotEmpty) {
         final random = Random(DateTime.now().hour + 2);
         final favSeed = seedCtx.favoriteTracks[random.nextInt(min(5, seedCtx.favoriteTracks.length))];
         final tracks = await _spotify.getRecommendations(seedTrackId: favSeed.spotifyId, limit: 12);
         final uniqueTracks = _dedupe(tracks, seenTrackIds);
         if (uniqueTracks.isNotEmpty) {
           sections.add(DiscoverSection(title: 'From your favorites', subtitle: 'Inspired by ${favSeed.name}', type: DiscoverSectionType.fromFavorites, tracks: uniqueTracks));
         }
      }

      // 4. Followed Artists
      if (seedCtx.followedArtists.isNotEmpty) {
         final random = Random(DateTime.now().hour + 3);
         final artistSeed = seedCtx.followedArtists[random.nextInt(min(5, seedCtx.followedArtists.length))];
         final tracks = await _spotify.getRecommendations(seedArtistId: artistSeed.spotifyId, limit: 12);
         final uniqueTracks = _dedupe(tracks, seenTrackIds);
         if (uniqueTracks.isNotEmpty) {
           sections.add(DiscoverSection(title: 'Artists you follow', subtitle: 'More like ${artistSeed.name}', type: DiscoverSectionType.followedArtists, tracks: uniqueTracks));
         }
      }

    } else if (seedCtx.hasData) {
       // Light personalization
       final mixedSeeds = _seedBuilder.getMixedSeeds(seedCtx);
       final trackSeeds = mixedSeeds.where((id) => _isTrackId(id, seedCtx)).toList();
       final artistSeeds = mixedSeeds.where((id) => !_isTrackId(id, seedCtx)).toList();
       
       final tracks = await _spotify.getRecommendations(
         seedTrackId: trackSeeds.isNotEmpty ? trackSeeds.join(',') : null,
         seedArtistId: artistSeeds.isNotEmpty ? artistSeeds.join(',') : null,
         limit: 20,
       );
       final uniqueTracks = _dedupe(tracks, seenTrackIds);
       if (uniqueTracks.isNotEmpty) {
         sections.add(DiscoverSection(title: 'Recommended for You', type: DiscoverSectionType.madeForYou, tracks: uniqueTracks));
       }
    }

    // Always add Explore / Featured
    try {
      final popular = await _spotify.getPopularTracks(limit: 15);
      final uniqueTracks = _dedupe(popular, seenTrackIds);
      if (uniqueTracks.isNotEmpty) {
        sections.add(DiscoverSection(title: 'Trending', subtitle: 'Popular hits right now', type: DiscoverSectionType.explore, tracks: uniqueTracks));
      }
      
      final genres = await _spotify.getAvailableGenreSeeds();
      if (genres.isNotEmpty) {
        final random = Random(DateTime.now().hour);
        final genre = genres[random.nextInt(min(10, genres.length))];
        final tracks = await _spotify.getRecommendations(seedGenres: genre, limit: 15);
        final uniqueGenreTracks = _dedupe(tracks, seenTrackIds);
        if (uniqueGenreTracks.isNotEmpty) {
           // Format genre nicely
           final formattedGenre = genre.split('-').map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '').join(' ');
           sections.add(DiscoverSection(title: 'Explore $formattedGenre', type: DiscoverSectionType.explore, tracks: uniqueGenreTracks));
        }
      }
    } catch (e) {
      // Ignored if explore fails but we have other sections
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

final discoverServiceProvider = Provider((ref) => DiscoverService(ref.watch(spotifyClientProvider), ref.watch(discoverSeedBuilderProvider)));
