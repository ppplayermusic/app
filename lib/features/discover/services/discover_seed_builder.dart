import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/db/app_database.dart' as db;
import '../../../core/models/artist.dart';
import '../../../core/models/track.dart';

class DiscoverSeedContext {
  final List<Track> recentTracks;
  final List<Track> favoriteTracks;
  final List<Artist> followedArtists;

  DiscoverSeedContext({
    required this.recentTracks,
    required this.favoriteTracks,
    required this.followedArtists,
  });

  bool get hasData =>
      recentTracks.isNotEmpty ||
      favoriteTracks.isNotEmpty ||
      followedArtists.isNotEmpty;
  bool get hasRichData =>
      recentTracks.length >= 3 &&
      (favoriteTracks.isNotEmpty || followedArtists.isNotEmpty);
}

class DiscoverSeedBuilder {
  final db.AppDatabase _db;

  DiscoverSeedBuilder(this._db);

  Future<DiscoverSeedContext> getContext() async {
    final recentTracks = await _db.getRecentlyPlayedAppTracks(limit: 20);
    final favoriteTracks = await _db.getFavoriteAppTracks();
    final artistsDb = await _db.getFollowedArtists();
    return DiscoverSeedContext(
      recentTracks: recentTracks,
      favoriteTracks: favoriteTracks,
      followedArtists: artistsDb
          .map(
            (a) => Artist(
              spotifyId: a.spotifyId,
              name: a.name,
              imageUrl: a.imageUrl,
              imageSmall: a.imageSmall,
              followers: a.followers,
            ),
          )
          .toList(),
    );
  }

  // Pick deterministic but rotating seeds
  List<String> getMixedSeeds(DiscoverSeedContext ctx, {int maxSeeds = 5}) {
    final List<String> seeds = [];
    final random = Random(DateTime.now().hour); // Rotates every hour

    // Attempt to mix 2 recent, 2 fav, 1 artist
    final recentPool = ctx.recentTracks.map((t) => t.spotifyId).toList()
      ..shuffle(random);
    final favPool = ctx.favoriteTracks.map((t) => t.spotifyId).toList()
      ..shuffle(random);
    final artistPool = ctx.followedArtists.map((a) => a.spotifyId).toList()
      ..shuffle(random);

    if (recentPool.isNotEmpty) seeds.addAll(recentPool.take(2));
    if (favPool.isNotEmpty) seeds.addAll(favPool.take(2));
    if (artistPool.isNotEmpty) seeds.addAll(artistPool.take(1));

    // If we don't have enough, fill with whatever is left
    if (seeds.length < maxSeeds) {
      final remaining = [
        ...recentPool.skip(2),
        ...favPool.skip(2),
        ...artistPool.skip(1),
      ];
      remaining.shuffle(random);
      seeds.addAll(remaining.take(maxSeeds - seeds.length));
    }

    return seeds.take(maxSeeds).toList();
  }
}

final discoverSeedBuilderProvider = Provider(
  (ref) => DiscoverSeedBuilder(ref.watch(db.appDatabaseProvider)),
);
