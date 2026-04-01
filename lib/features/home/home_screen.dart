import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/api/spotify_client.dart';
import '../../core/player/player_provider.dart';
import '../../shared/widgets/banner_ad_widget.dart';
import '../../shared/widgets/promotion_tile.dart';
import '../../shared/widgets/tactile_buttons.dart';
import '../../core/services/ad_service.dart';

final newReleasesProvider = FutureProvider((ref) async {
  final client = ref.watch(spotifyClientProvider);
  return client.getNewReleases(limit: 10);
});

final featuredPlaylistsProvider = FutureProvider((ref) async {
  final client = ref.watch(spotifyClientProvider);
  return client.getFeaturedPlaylists(limit: 10);
});

final marketPopularAlbumsProvider = FutureProvider((ref) async {
  final client = ref.watch(spotifyClientProvider);
  // Get albums from popular tracks to ensure they are relevant to the market
  final tracks = await ref.watch(popularTracksProvider.future);
  final albumIds = tracks.map((t) => t.albumId).where((id) => id != null && id.isNotEmpty).cast<String>().toSet().toList();
  if (albumIds.isEmpty) return <Map<String, dynamic>>[];
  // Limit to top 10 unique albums
  return client.getMultipleAlbums(albumIds.take(10).toList());
});

final popularTracksProvider = FutureProvider((ref) async {
  final client = ref.watch(spotifyClientProvider);
  return client.getPopularTracks(limit: 12);
});

final popularArtistsProvider = FutureProvider((ref) async {
  final client = ref.watch(spotifyClientProvider);
  // Get artists from popular tracks to ensure they are relevant to the market
  final tracks = await ref.watch(popularTracksProvider.future);
  final artistIds = tracks.map((t) => t.artistId).where((id) => id.isNotEmpty).toSet().toList();
  if (artistIds.isEmpty) return <Map<String, dynamic>>[];
  // Limit to top 10 unique artists
  return client.getMultipleArtists(artistIds.take(10).toList());
});

final madeForYouMixesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final artists = await ref.watch(popularArtistsProvider.future);
  final genres = await ref.watch(genresProvider.future);
  
  final mixes = <Map<String, dynamic>>[];
  
  // Daily Mix 1: Top artist focus
  if (artists.isNotEmpty) {
    mixes.add({
      'type': 'artist',
      'id': artists[0]['id'],
      'name': 'Daily Mix 1',
      'subtitle': '${artists[0]['name']} and more',
      'imageUrl': (artists[0]['images'] as List?)?.firstOrNull?['url'] ?? '',
      'title': 'Daily Mix 1',
      'color1': const Color(0xFFE91E63),
      'color2': const Color(0xFF9C27B0),
    });
  }
  
  // Daily Mix 2: Hip hop focus
  if (artists.length > 2) {
    mixes.add({
      'type': 'artist',
      'id': artists[1]['id'],
      'name': 'Daily Mix 2',
      'subtitle': '${artists[1]['name']}, ${artists[2]['name']} and more',
      'imageUrl': (artists[1]['images'] as List?)?.firstOrNull?['url'] ?? '',
      'title': 'Daily Mix 2',
      'color1': const Color(0xFF2196F3),
      'color2': const Color(0xFF00BCD4),
    });
  }

  // Discover Weekly
  if (genres.isNotEmpty) {
    mixes.add({
      'type': 'genre',
      'id': genres.first['id'] as String,
      'name': 'Discover Weekly',
      'subtitle': 'New music based on your listening history.',
      'imageUrl': (genres.first['icons'] as List?)?.firstOrNull?['url'] ?? '',
      'title': 'Discover Weekly',
      'color1': const Color(0xFF4CAF50),
      'color2': const Color(0xFF8BC34A),
    });
  }

  // Release Radar
  mixes.add({
    'type': 'genre',
    'id': 'pop', // fallback
    'name': 'Release Radar',
    'subtitle': 'Catch up on the latest releases from artists you follow.',
    'imageUrl': 'https://t.scdn.co/images/37i9dQZF1DXcBWIGoYBM3M.jpeg', // Pop icon
    'title': 'Release Radar',
    'color1': const Color(0xFFFF9800),
    'color2': const Color(0xFFFFC107),
  });

  // Mood Mix: Chill focus
  mixes.add({
    'type': 'genre',
    'id': 'chill',
    'name': 'Chill Mix',
    'subtitle': 'Vibey, relaxing tracks picked for you.',
    'imageUrl': 'https://t.scdn.co/images/37i9dQZF1DX4WYpdgoIcnm.jpeg',
    'title': 'Chill Mix',
    'color1': const Color(0xFF1E88E5),
    'color2': const Color(0xFF673AB7),
  });

  // Energy Mix: Focus/Study
  mixes.add({
    'type': 'genre',
    'id': 'study',
    'name': 'Focus Mix',
    'subtitle': 'Music to help you concentrate.',
    'imageUrl': 'https://t.scdn.co/images/37i9dQZF1DX8Ueb9C7W3p7.jpeg',
    'title': 'Focus Mix',
    'color1': const Color(0xFF00897B),
    'color2': const Color(0xFF4DB6AC),
  });

  return mixes;
});

final suggestedStationsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final artists = await ref.watch(popularArtistsProvider.future);
  final genres = await ref.watch(genresProvider.future);
  
  final radios = <Map<String, dynamic>>[];
  
  // Add Artist Radios
  for (final artist in artists.skip(2).take(4)) {
    radios.add({
      'type': 'artist',
      'id': artist['id'],
      'name': artist['name'],
      'imageUrl': (artist['images'] as List?)?.firstOrNull?['url'] ?? '',
      'title': '${artist['name']} Radio',
    });
  }
  
  // Add some Genre Radios with valid seeds
  final genreSeeds = {
    'Rock': 'rock',
    'Pop': 'pop',
    'Hip-Hop': 'hip-hop',
    'Hip Hop': 'hip-hop',
    'Jazz': 'jazz',
    'Dance': 'dance',
    'Electronic': 'electronic',
    'R&B': 'r-n-b',
    'Acoustic': 'acoustic',
    'Country': 'country',
    'Metal': 'metal',
    'Classical': 'classical',
    'Lo-Fi': 'study',
  };
  
  for (final genre in genres) {
    final name = genre['name'] as String;
    final id = genre['id'] as String;
    
    // Check by name or ID
    String? matchedSeed;
    if (genreSeeds.containsKey(name)) {
      matchedSeed = genreSeeds[name];
    } else if (genreSeeds.values.contains(id)) {
      matchedSeed = id;
    }

    if (matchedSeed != null) {
      radios.add({
        'type': 'genre',
        'id': matchedSeed,
        'name': name,
        'imageUrl': (genre['icons'] as List?)?.firstOrNull?['url'] ?? '',
        'title': '$name Radio',
      });
    }
  }
  
  // If no genre radios matched, add some defaults to avoid empty state
  if (radios.length < 6) {
    final defaults = [
      {'name': 'Pop', 'seed': 'pop'},
      {'name': 'Rock', 'seed': 'rock'},
      {'name': 'Jazz', 'seed': 'jazz'},
    ];
    for (final d in defaults) {
      if (!radios.any((r) => r['name'] == d['name'])) {
        radios.add({
          'type': 'genre',
          'id': d['seed'],
          'name': d['name'],
          'imageUrl': 'https://t.scdn.co/images/37i9dQZF1DXcBWIGoYBM3M.jpeg',
          'title': '${d['name']} Radio',
        });
      }
    }
  }
  
  return radios;
});

final genresProvider = FutureProvider((ref) async {
  final client = ref.watch(spotifyClientProvider);
  return client.getBrowseCategories(limit: 12);
});

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newReleases = ref.watch(newReleasesProvider);
    final recentlyPlayed = ref.watch(recentlyPlayedProvider);
    final popularAlbums = ref.watch(marketPopularAlbumsProvider);
    final featuredPlaylists = ref.watch(featuredPlaylistsProvider);
    final popularTracks = ref.watch(popularTracksProvider);
    final popularArtists = ref.watch(popularArtistsProvider);
    final madeForYouMixes = ref.watch(madeForYouMixesProvider);
    final suggestedStations = ref.watch(suggestedStationsProvider);
    final genres = ref.watch(genresProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.asset(
                    'assets/logo.png',
                    height: 32,
                    width: 32,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Good morning',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
              ],
            ),
            actions: [
              TactileIconButton(
                icon: Icons.history,
                onTap: () => context.push('/recently-played'),
              ),
              TactileIconButton(
                icon: Icons.settings,
                onTap: () => context.push('/settings'),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('Jump Back In'),
                  const SizedBox(height: 16),
                  recentlyPlayed.when(
                    data: (tracks) {
                      if (tracks.isEmpty) return const SizedBox.shrink();
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 3,
                        ),
                        itemCount: tracks.length.clamp(0, 6),
                        itemBuilder: (context, index) {
                          final track = tracks[index];
                          return _HistoryCard(
                            track: track,
                            onTap: () => ref.read(playerProvider.notifier).playTrack(track, queue: tracks),
                          );
                        },
                      );
                    },
                    loading: () => const _LoadingPlaceholder(height: 100),
                    error: (e, _) => Text('Error: $e'),
                  ),
                  const SizedBox(height: 32),
                  _buildSectionHeader('Popular Artists'),
                  const SizedBox(height: 16),
                  popularArtists.when(
                    data: (artists) {
                      if (artists.isEmpty) return const SizedBox.shrink();
                      return SizedBox(
                        height: 160,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: artists.length,
                          itemBuilder: (context, index) {
                            final artist = artists[index];
                            final imageUrl = (artist['images'] as List?)?.firstOrNull?['url'] ?? '';
                            return _ArtistCircle(
                              name: artist['name'],
                              imageUrl: imageUrl,
                              onTap: () => context.push('/artist/${artist['id']}'),
                            );
                          },
                        ),
                      );
                    },
                    loading: () => const _LoadingPlaceholder(height: 160),
                    error: (e, _) => Text('Error: $e'),
                  ),
                  const SizedBox(height: 32),
                  const SizedBox(height: 32),
                  _buildSectionHeader('Made For You'),
                  const SizedBox(height: 16),
                  madeForYouMixes.when(
                    data: (mixes) {
                      if (mixes.isEmpty) return const SizedBox.shrink();
                      return SizedBox(
                        height: 220,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: mixes.length,
                          itemBuilder: (context, index) {
                            final mix = mixes[index];
                            return _SpotifyMixCard(
                              title: mix['title'],
                              subtitle: mix['subtitle'],
                              imageUrl: mix['imageUrl'],
                              color1: mix['color1'] as Color,
                              color2: mix['color2'] as Color,
                                onTap: () => context.push(
                                  Uri(
                                    path: '/radio/${mix['type']}/${mix['id']}',
                                    queryParameters: {
                                      'title': mix['title'],
                                      'imageUrl': mix['imageUrl'],
                                      'subtitle': mix['subtitle'] ?? '',
                                    },
                                  ).toString(),
                                  extra: <String, dynamic>{
                                    'color1': mix['color1'],
                                    'color2': mix['color2'],
                                  },
                                ),
                            );
                          },
                        ),
                      );
                    },
                    loading: () => const _LoadingPlaceholder(height: 220),
                    error: (e, _) => Text('Error: $e'),
                  ),
                  const SizedBox(height: 32),
                  _buildSectionHeader('Suggested Stations'),
                  const SizedBox(height: 16),
                  suggestedStations.when(
                    data: (radios) {
                      if (radios.isEmpty) return const SizedBox.shrink();
                      return SizedBox(
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: radios.length,
                          itemBuilder: (context, index) {
                            final radio = radios[index];
                            return _RadioCard(
                              title: radio['title'],
                              imageUrl: radio['imageUrl'],
                              onTap: () => context.push(
                                Uri(
                                  path: '/radio/${radio['type']}/${radio['id']}',
                                  queryParameters: {
                                    'title': radio['title'],
                                    'imageUrl': radio['imageUrl'],
                                  },
                                ).toString(),
                              ),
                            );
                          },
                        ),
                      );
                    },
                    loading: () => const _LoadingPlaceholder(height: 180),
                    error: (e, _) => Text('Error: $e'),
                  ),
                  const SizedBox(height: 32),
                  _buildSectionHeader('Popular Albums'),
                  const SizedBox(height: 16),
                  popularAlbums.when(
                    data: (albums) => _HorizontalList(
                      items: albums,
                      onTap: (item) => context.push("/album/${item['id']}"),
                    ),
                    loading: () => const _LoadingPlaceholder(height: 200),
                    error: (e, _) => Text('Error: $e'),
                  ),
                  const SizedBox(height: 32),
                  _buildSectionHeader('Popular Genres'),
                  const SizedBox(height: 16),
                  genres.when(
                    data: (items) => SizedBox(
                      height: 120,
                      child: GridView.builder(
                        scrollDirection: Axis.horizontal,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 0.4,
                        ),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final category = items[index];
                          final imageUrl = (category['icons'] as List?)?.firstOrNull?['url'] ?? '';
                          return _GenreCard(
                            name: category['name'],
                            imageUrl: imageUrl,
                            onTap: () => context.push("/genre/${category['name']}"),
                          );
                        },
                      ),
                    ),
                    loading: () => const _LoadingPlaceholder(height: 120),
                    error: (e, _) => Text('Error: $e'),
                  ),
                  const SizedBox(height: 32),
                  const BannerAdWidget(),
                  const SizedBox(height: 32),
                  _buildSectionHeader('New Releases'),
                  const SizedBox(height: 16),
                  newReleases.when(
                    data: (items) => _HorizontalList(
                      items: items,
                      onTap: (item) => context.push("/album/${item['id']}"),
                    ),
                    loading: () => const _LoadingPlaceholder(height: 200),
                    error: (e, _) => Text('Error: $e'),
                  ),
                  const SizedBox(height: 32),
                  _buildSectionHeader('Featured Playlists'),
                  const SizedBox(height: 16),
                  featuredPlaylists.when(
                    data: (items) => _HorizontalList(
                      items: items,
                      onTap: (item) => context.push(
                        Uri(
                          path: '/spotify-playlist/${item['id']}',
                          queryParameters: {'name': item['name']},
                        ).toString(),
                      ),
                    ),
                    loading: () => const _LoadingPlaceholder(height: 200),
                    error: (e, _) => Text('Error: $e'),
                  ),
                  const SizedBox(height: 32),
                  _buildSectionHeader('Popular Tracks'),
                  const SizedBox(height: 16),
                  popularTracks.when(
                    data: (tracks) => SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: tracks.length + 1,
                        itemBuilder: (context, index) {
                          if (index == 4) {
                            final promo = ref.read(adServiceProvider).getPromoData()[0];
                            return PromotionTile(
                              title: promo['title']!,
                              subtitle: promo['subtitle']!,
                              imageUrl: promo['image'],
                              ctaText: promo['cta']!,
                              type: PromotionType.horizontal,
                            );
                          }
                          
                          final trackIndex = index > 4 ? index - 1 : index;
                          final track = tracks[trackIndex];
                          return _AlbumCard(
                            title: track.name,
                            subtitle: track.artistName,
                            imageUrl: track.albumImage ?? '',
                            onTap: () => ref.read(playerProvider.notifier).playTrack(track, queue: tracks),
                            artistId: track.artistId,
                          );
                        },
                      ),
                    ),
                    loading: () => const _LoadingPlaceholder(height: 200),
                    error: (e, _) => Text('Error: $e'),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}

class _HorizontalList extends ConsumerWidget {
  const _HorizontalList({required this.items, required this.onTap});
  final List<Map<String, dynamic>> items;
  final Function(Map<String, dynamic>) onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length + 1,
        itemBuilder: (context, index) {
          if (index == 3) {
            final promo = ref.read(adServiceProvider).getPromoData()[1];
            return PromotionTile(
              title: promo['title']!,
              subtitle: promo['subtitle']!,
              imageUrl: promo['image'],
              ctaText: promo['cta']!,
              type: PromotionType.horizontal,
            );
          }
          
          final itemIndex = index > 3 ? index - 1 : index;
          if (itemIndex >= items.length) return const SizedBox.shrink();
          
          final item = items[itemIndex];
          final imageUrl = (item['images'] as List?)?.firstOrNull?['url'] ?? '';
          final artists = (item['artists'] as List?) ?? [];
          final artistName = artists.isNotEmpty ? artists[0]['name'] : (item['publisher'] ?? '');
          final artistId = artists.isNotEmpty ? artists[0]['id'] : null;

          return _AlbumCard(
            title: item['name'],
            subtitle: artistName,
            imageUrl: imageUrl,
            onTap: () => onTap(item),
            artistId: artistId,
          );
        },
      ),
    );
  }
}

class _GenreCard extends StatelessWidget {
  const _GenreCard({required this.name, required this.imageUrl, required this.onTap});
  final String name;
  final String imageUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TactileTap(
      onTap: onTap,
      scaleDown: 0.98,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            if (imageUrl.isNotEmpty)
              Positioned(
                right: -10,
                bottom: -10,
                child: Transform.rotate(
                  angle: 0.5,
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.track, required this.onTap});
  final Track track;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TactileTap(
      onTap: onTap,
      scaleDown: 0.98,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: CachedNetworkImage(
                imageUrl: track.albumImage ?? '',
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => const Icon(Icons.music_note),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    track.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                    Text(
                      track.artistName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 4),
          ],
        ),
      ),
    );
  }
}

class _AlbumCard extends StatelessWidget {
  const _AlbumCard({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.onTap,
    this.artistId,
  });

  final String title;
  final String subtitle;
  final String imageUrl;
  final VoidCallback onTap;
  final String? artistId;

  @override
  Widget build(BuildContext context) {
    return TactileTap(
      onTap: onTap,
      scaleDown: 0.95,
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                width: 140,
                height: 140,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(color: Colors.white10),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
          ],
        ),
      ),
    );
  }
}

class _ArtistCircle extends StatelessWidget {
  const _ArtistCircle({
    required this.name,
    required this.imageUrl,
    required this.onTap,
  });

  final String name;
  final String imageUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TactileTap(
      onTap: onTap,
      scaleDown: 0.95,
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[900],
                    child: const Icon(Icons.person, color: Colors.white24, size: 40),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[900],
                    child: const Icon(Icons.person, color: Colors.white24, size: 40),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Colors.white,
              ),
            ),
            const Text(
              'Artist',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingPlaceholder extends StatelessWidget {
  const _LoadingPlaceholder({required this.height});
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}

class _RadioCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final VoidCallback onTap;

  const _RadioCard({
    required this.title,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TactileTap(
      onTap: onTap,
      scaleDown: 0.95,
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: Colors.grey[900]),
              errorWidget: (context, url, error) => Container(
                color: Colors.blueGrey[900],
                child: const Icon(Icons.radio, color: Colors.white24, size: 40),
              ),
            ),
            // Gradient Overlay
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black,
                  ],
                  stops: [0.3, 1.0],
                ),
              ),
            ),
            // Radio Badge
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.white24),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.radio, size: 10, color: Colors.white),
                    SizedBox(width: 4),
                    Text(
                      'RADIO',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Text info
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'Station',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            // Play indicator overlay
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.play_arrow, size: 16, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SpotifyMixCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final Color color1;
  final Color color2;
  final VoidCallback onTap;

  const _SpotifyMixCard({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.color1,
    required this.color2,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TactileTap(
      onTap: onTap,
      scaleDown: 0.96,
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color1, color2],
                ),
                boxShadow: [
                  BoxShadow(
                    color: color2.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          color1,
                          color2,
                        ],
                      ),
                    ),
                  ),
                  if (imageUrl.isNotEmpty)
                    Positioned(
                      bottom: -15,
                      right: -15,
                      child: Transform.rotate(
                        angle: 0.2, // slight rotation for visual interest
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        title.replaceAll(' ', '\n'), // Stack words vertically 
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                          letterSpacing: -1,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Icon(Icons.music_note, color: Colors.white.withValues(alpha: 0.3), size: 36),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 13,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
