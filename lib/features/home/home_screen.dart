import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../shared/widgets/pp_image.dart';
import '../../shared/widgets/playlist_cover.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/api/spotify_client.dart';
import '../../core/player/player_provider.dart';
import '../../core/playback/playback_service.dart';
import '../../shared/widgets/banner_ad_widget.dart';
import '../../shared/widgets/promotion_tile.dart';
import '../../shared/widgets/tactile_buttons.dart';
import '../../shared/widgets/adaptive_blur.dart';
import '../../core/services/ad_service.dart';
import '../../core/providers/genre_providers.dart';
import '../../shared/widgets/section_wrapper.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/settings_provider.dart';
import '../../shared/widgets/profile_modal.dart';
import '../../shared/widgets/user_avatar.dart';

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
  final client = ref.watch(spotifyClientProvider);
  final artists = await ref.watch(popularArtistsProvider.future);
  final genres = await ref.watch(browseCategoriesProvider.future);
  
  // Get valid recommendation seeds to ensure mixes aren't empty
  final validSeeds = await client.getAvailableGenreSeeds();
  
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
      'color1': AppTheme.themeColors[0],
      'color2': AppTheme.themeColors[1],
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
      'color1': AppTheme.themeColors[2],
      'color2': AppTheme.themeColors[3],
    });
  }

  // Discover Weekly
  String discoverSeed = 'pop';
  String discoverImageUrl = 'asset:assets/images/mix_covers/discover_weekly.png';
  
  for (final genre in genres) {
    final id = genre['id'] as String;
    if (validSeeds.contains(id)) {
      discoverSeed = id;
      // We still try to use the genre icon if available from Spotify, but default to our asset
      final iconUrl = (genre['icons'] as List?)?.firstOrNull?['url'];
      if (iconUrl != null) {
        discoverImageUrl = iconUrl;
      }
      break;
    }
  }

  mixes.add({
    'type': 'genre',
    'id': discoverSeed,
    'name': 'Discover Weekly',
    'subtitle': 'New music based on your favorite genres.',
    'imageUrl': discoverImageUrl,
    'title': 'Discover Weekly',
    'color1': AppTheme.themeColors[4],
    'color2': AppTheme.themeColors[5],
  });

  // Release Radar
  mixes.add({
    'type': 'genre',
    'id': 'new-release',
    'name': 'Release Radar',
    'subtitle': 'Catch up on the latest releases.',
    'imageUrl': 'asset:assets/images/mix_covers/discover_weekly.png',
    'title': 'Release Radar',
    'color1': AppTheme.themeColors[6],
    'color2': AppTheme.themeColors[7],
  });

  // Mood Mix: Chill focus
  mixes.add({
    'type': 'genre',
    'id': 'chill',
    'name': 'Chill Mix',
    'subtitle': 'Vibey, relaxing tracks picked for you.',
    'imageUrl': 'asset:assets/images/mix_covers/chill_mix.png',
    'title': 'Chill Mix',
    'color1': AppTheme.themeColors[8],
    'color2': AppTheme.themeColors[9],
  });

  // Energy Mix: Focus/Study
  mixes.add({
    'type': 'genre',
    'id': 'study',
    'name': 'Focus Mix',
    'subtitle': 'Music to help you concentrate.',
    'imageUrl': 'asset:assets/images/mix_covers/focus_mix.png',
    'title': 'Focus Mix',
    'color1': AppTheme.themeColors[10],
    'color2': AppTheme.themeColors[11],
  });

  return mixes;
});

final suggestedStationsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final artists = await ref.watch(popularArtistsProvider.future);
  final genres = await ref.watch(browseCategoriesProvider.future);
  
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
          'imageUrl': 'asset:assets/images/mix_covers/discover_weekly.png',
          'title': '${d['name']} Radio',
        });
      }
    }
  }
  
  return radios;
});



class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final settings = ref.read(settingsProvider);
      if (settings.userName.isEmpty) {
        showEditProfileModal(context, ref, isDismissible: false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final settings = ref.watch(settingsProvider);
    
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = 'Good morning';
    } else if (hour < 17) {
      greeting = 'Good afternoon';
    } else {
      greeting = 'Good evening';
    }
    final firstName = settings.userName.isNotEmpty ? settings.userName.split(' ').first : '';
    final greetingText = firstName.isNotEmpty ? '$greeting, $firstName' : greeting;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 32.0, top: 56.0, right: 32.0, bottom: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        greetingText,
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -1.5,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your music is waiting.',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                  if (settings.userName.isNotEmpty)
                    TactileTap(
                      onTap: () => context.push('/settings'),
                      child: UserAvatarWidget(
                        settings: settings,
                        size: 48,
                        fontSize: 16,
                      ),
                    ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StaggeredHomeSection<Track>(
                    title: 'Continue Listening',
                    provider: recentlyPlayedProvider,
                    delay: 0.seconds,
                    topPadding: 24,
                    builder: (context, ref, tracks) => SizedBox(
                      height: 220,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: tracks.length.clamp(0, 10),
                        itemBuilder: (context, index) {
                          final track = tracks[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: _HistoryCard(
                              track: track,
                              onTap: () => ref.read(playerProvider.notifier).playTrack(track, queue: tracks),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  StaggeredHomeSection<Map<String, dynamic>>(
                    title: 'Popular Artists',
                    provider: popularArtistsProvider,
                    delay: 500.ms,
                    builder: (context, ref, artists) => SizedBox(
                      height: 170,
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
                          ).animate().fadeIn(delay: (100 + (index * 100)).ms).scale(begin: const Offset(0.8, 0.8));
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  StaggeredHomeSection<Map<String, dynamic>>(
                    title: 'Made For You',
                    provider: madeForYouMixesProvider,
                    delay: 1.seconds,
                    builder: (context, ref, mixes) => SizedBox(
                      height: 160,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: mixes.length,
                        itemBuilder: (context, index) {
                          final mix = mixes[index];
                          return _MixCard(
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
                          ).animate(delay: (index * 100).ms).fadeIn().scale(begin: const Offset(0.8, 0.8));
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  StaggeredHomeSection<Map<String, dynamic>>(
                    title: 'Suggested Stations',
                    provider: suggestedStationsProvider,
                    delay: 1.5.seconds,
                    builder: (context, ref, radios) => SizedBox(
                      height: 230,
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
                          ).animate().fadeIn(delay: (index * 100).ms).scale(begin: const Offset(0.9, 0.9));
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  StaggeredHomeSection<Map<String, dynamic>>(
                    title: 'Popular Albums',
                    provider: marketPopularAlbumsProvider,
                    delay: 2.seconds,
                    builder: (context, ref, albums) => _HorizontalList(
                      items: albums,
                      onTap: (item) => context.push("/album/${item['id']}"),
                    ).animate().fadeIn().slideY(begin: 0.1),
                  ),
                  const SizedBox(height: 32),
                  StaggeredHomeSection<Map<String, dynamic>>(
                    title: 'Popular Genres',
                    provider: browseCategoriesProvider,
                    delay: 2.5.seconds,
                    builder: (context, ref, items) => LayoutBuilder(
                      builder: (context, constraints) {
                        if (constraints.maxWidth >= 600) {
                          final crossAxisCount = (constraints.maxWidth / 160).floor().clamp(2, 6);
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 2.5,
                            ),
                            itemCount: items.length.clamp(0, 12),
                            itemBuilder: (context, index) {
                              final category = items[index];
                              final id = category['id'] as String;
                              final name = category['name'] as String;
                              final imageUrl = (category['icons'] as List?)?.firstOrNull?['url'] ?? '';
                              return _GenreCard(
                                name: name,
                                imageUrl: imageUrl,
                                onTap: () => context.push(
                                  Uri(
                                    path: '/genre/$id',
                                    queryParameters: {'name': name},
                                  ).toString(),
                                ),
                              ).animate().fadeIn(delay: (index * 50).ms).scale(begin: const Offset(0.9, 0.9));
                            },
                          );
                        } else {
                          return SizedBox(
                            height: 140,
                            child: GridView.builder(
                              scrollDirection: Axis.horizontal,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.45,
                              ),
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                final category = items[index];
                                final id = category['id'] as String;
                                final name = category['name'] as String;
                                final imageUrl = (category['icons'] as List?)?.firstOrNull?['url'] ?? '';
                                return _GenreCard(
                                  name: name,
                                  imageUrl: imageUrl,
                                  onTap: () => context.push(
                                    Uri(
                                      path: '/genre/$id',
                                      queryParameters: {'name': name},
                                    ).toString(),
                                  ),
                                ).animate().fadeIn(delay: (index * 50).ms).scale(begin: const Offset(0.9, 0.9));
                              },
                            ),
                          );
                        }
                      },
                    ),
                    loadingWidget: const SectionShimmer(height: 140, childAspectRatio: 0.45, isGrid: true, count: 6),
                  ),
                  const SizedBox(height: 32),
                  const BannerAdWidget(),
                  const SizedBox(height: 32),
                  StaggeredHomeSection<Map<String, dynamic>>(
                    title: 'New Releases',
                    provider: newReleasesProvider,
                    delay: 3.seconds,
                    builder: (context, ref, items) => _HorizontalList(
                      items: items,
                      onTap: (item) => context.push("/album/${item['id']}"),
                    ).animate().fadeIn().slideY(begin: 0.1),
                  ),
                  const SizedBox(height: 32),
                  StaggeredHomeSection<Map<String, dynamic>>(
                    title: 'Featured Playlists',
                    provider: featuredPlaylistsProvider,
                    delay: 3.5.seconds,
                    builder: (context, ref, items) => _HorizontalList(
                      items: items,
                      onTap: (item) => context.push(
                        Uri(
                          path: '/playlist/remote/${item['id']}',
                          queryParameters: {'name': item['name']},
                        ).toString(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  StaggeredHomeSection<Track>(
                    title: 'Popular Tracks',
                    provider: popularTracksProvider,
                    delay: 4.seconds,
                    builder: (context, ref, tracks) => SizedBox(
                      height: 230,
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
                            ).animate().fadeIn(delay: (index * 100).ms).scale(begin: const Offset(0.9, 0.9));
                          }
                          
                          final trackIndex = index > 4 ? index - 1 : index;
                          if (trackIndex >= tracks.length) return const SizedBox.shrink();
                          
                          final track = tracks[trackIndex];
                          return _AlbumCard(
                            title: track.name,
                            subtitle: track.artistName,
                            imageUrl: track.albumImage ?? '',
                            onTap: () => ref.read(playerProvider.notifier).playTrack(track, queue: tracks),
                            artistId: track.artistId,
                          ).animate().fadeIn(delay: (index * 100).ms).slideY(begin: 0.1);
                        },
                      ),
                    ),
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


}

class _HorizontalList extends ConsumerWidget {
  const _HorizontalList({required this.items, required this.onTap});
  final List<Map<String, dynamic>> items;
  final Function(Map<String, dynamic>) onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 600) {
          final crossAxisCount = (constraints.maxWidth / 172).floor().clamp(2, 8);
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 24,
              childAspectRatio: 0.75,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final rawImages = (item['images'] as List?) ?? [];
              final images = rawImages.map((i) => i['url'] as String).toList();
              final imageUrl = images.firstOrNull ?? '';
              final artists = (item['artists'] as List?) ?? [];
              final artistName = artists.isNotEmpty ? artists[0]['name'] : (item['publisher'] ?? '');
              final artistId = artists.isNotEmpty ? artists[0]['id'] : null;

              return _AlbumCard(
                title: item['name'],
                subtitle: artistName,
                imageUrl: imageUrl,
                images: images,
                onTap: () => onTap(item),
                artistId: artistId,
                isGridItem: true,
              );
            },
          );
        } else {
          return SizedBox(
            height: 230,
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
                final rawImages = (item['images'] as List?) ?? [];
                final images = rawImages.map((i) => i['url'] as String).toList();
                final imageUrl = images.firstOrNull ?? '';
                final artists = (item['artists'] as List?) ?? [];
                final artistName = artists.isNotEmpty ? artists[0]['name'] : (item['publisher'] ?? '');
                final artistId = artists.isNotEmpty ? artists[0]['id'] : null;

                return _AlbumCard(
                  title: item['name'],
                  subtitle: artistName,
                  imageUrl: imageUrl,
                  images: images,
                  onTap: () => onTap(item),
                  artistId: artistId,
                );
              },
            ),
          );
        }
      },
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
    final colorScheme = Theme.of(context).colorScheme;
    return TactileTap(
      onTap: onTap,
      scaleDown: 0.98,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.onSurface.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: colorScheme.onSurface.withValues(alpha: 0.1),
            width: 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.scrim.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Background Glow
            Positioned(
              right: -20,
              bottom: -20,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      colorScheme.onSurface.withValues(alpha: 0.05),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            
            if (imageUrl.isNotEmpty)
              Positioned(
                right: -10,
                bottom: -5,
                child: Transform.rotate(
                  angle: 0.4,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.scrim.withValues(alpha: 0.5),
                          blurRadius: 12,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: PPImage(
                        imageUrl: imageUrl,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                      letterSpacing: -0.5,
                      color: colorScheme.onSurface,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryCard extends StatefulWidget {
  const _HistoryCard({required this.track, required this.onTap});
  final Track track;
  final VoidCallback onTap;

  @override
  State<_HistoryCard> createState() => _HistoryCardState();
}

class _HistoryCardState extends State<_HistoryCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: TactileTap(
        onTap: widget.onTap,
        scaleDown: 0.98,
        child: Container(
          width: 160,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: _isHovered ? 0.3 : 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorScheme.onSurface.withValues(alpha: 0.05),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    PPImage(
                      imageUrl: widget.track.albumImage ?? '',
                      fit: BoxFit.cover,
                    ),
                    if (_isHovered)
                      Positioned.fill(
                        child: Container(
                          color: Colors.black.withValues(alpha: 0.4),
                          child: const Center(
                            child: Icon(Icons.play_circle_fill, size: 48, color: Colors.white),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.track.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.track.artistName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AlbumCard extends StatelessWidget {
  const _AlbumCard({
    required this.title,
    required this.subtitle,
    this.imageUrl,
    this.images,
    required this.onTap,
    this.artistId,
    this.isGridItem = false,
  });

  final String title;
  final String subtitle;
  final String? imageUrl;
  final List<String>? images;
  final VoidCallback onTap;
  final String? artistId;
  final bool isGridItem;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    Widget imageWidget;
    if (images != null && images!.length > 1) {
      imageWidget = PlaylistCover(
        images: images!,
        size: isGridItem ? double.infinity : 156,
        borderRadius: 20,
      );
    } else {
      imageWidget = PPImage(
        imageUrl: images?.firstOrNull ?? imageUrl ?? '',
        width: isGridItem ? double.infinity : 156,
        height: isGridItem ? double.infinity : 156,
        fit: BoxFit.cover,
      );
    }

    return TactileTap(
      onTap: onTap,
      scaleDown: 0.95,
      child: Container(
        width: isGridItem ? null : 156,
        margin: isGridItem ? EdgeInsets.zero : const EdgeInsets.only(right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.scrim.withValues(alpha: 0.4),
                    blurRadius: 25,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: HoverPlayOverlay(
                  onPlay: onTap,
                  size: 40,
                  child: Stack(
                    children: [
                      imageWidget,
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: colorScheme.onSurface.withValues(alpha: 0.1),
                              width: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                colorScheme.scrim.withValues(alpha: 0.3),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 15,
                letterSpacing: -0.4,
                height: 1.2,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: colorScheme.onSurface.withValues(alpha: 0.4),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
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
    final colorScheme = Theme.of(context).colorScheme;
    return TactileTap(
      onTap: onTap,
      scaleDown: 0.92,
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
                    color: colorScheme.scrim.withValues(alpha: 0.4),
                    blurRadius: 30,
                    offset: const Offset(0, 12),
                  ),
                ],
                border: Border.all(
                  color: colorScheme.onSurface.withValues(alpha: 0.15),
                  width: 1.5,
                ),
              ),
              child: ClipOval(
                child: HoverPlayOverlay(
                  onPlay: onTap,
                  size: 40,
                  child: PPImage(
                    imageUrl: imageUrl,
                    width: 110,
                    height: 110,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 13,
                color: colorScheme.onSurface,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.2),
                  width: 0.5,
                ),
              ),
              child: Text(
                'ARTIST',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontSize: 8,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// _LoadingPlaceholder class removed as it is replaced by ShimmerPlaceholder

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
    final colorScheme = Theme.of(context).colorScheme;
    return TactileTap(
      onTap: onTap,
      scaleDown: 0.95,
      child: Container(
        width: 156,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: colorScheme.scrim.withValues(alpha: 0.5),
              blurRadius: 30,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: HoverPlayOverlay(
          onPlay: onTap,
          size: 44,
          child: Stack(
            fit: StackFit.expand,
            children: [
            PPImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
            ),
            // Glassmorphic Layer
            Positioned.fill(
              child: AdaptiveBlur(
                sigmaX: 8,
                sigmaY: 8,
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: colorScheme.onSurface.withValues(alpha: 0.1),
                      width: 0.5,
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        colorScheme.scrim.withValues(alpha: 0.8),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Radio Badge
            Positioned(
              top: 14,
              left: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.sensors, size: 12, color: colorScheme.onPrimary),
                    const SizedBox(width: 4),
                    Text(
                      'LIVE',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        color: colorScheme.onPrimary,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Text info
            Positioned(
              bottom: 18,
              left: 18,
              right: 18,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                   Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                     style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      color: colorScheme.onSurface,
                      height: 1.1,
                      letterSpacing: -0.6,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Exclusive Station',
                    style: TextStyle(
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
          ),
        ),
      ),
    );
  }
}

class _MixCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final Color color1;
  final Color color2;
  final VoidCallback onTap;

  const _MixCard({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.color1,
    required this.color2,
    required this.onTap,
  });

  @override
  State<_MixCard> createState() => _MixCardState();
}

class _MixCardState extends State<_MixCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: TactileTap(
        onTap: widget.onTap,
        scaleDown: 0.98,
        child: Container(
          width: 280,
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.color1,
                widget.color2,
              ],
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Abstract background silhouette based on image if available
              if (widget.imageUrl.isNotEmpty)
                Positioned(
                  bottom: -20,
                  right: -20,
                  child: Opacity(
                    opacity: 0.15,
                    child: Image.network(
                      widget.imageUrl,
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                      color: Colors.black,
                      colorBlendMode: BlendMode.srcATop,
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title.replaceAll(' ', '\n'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                        letterSpacing: -1,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      widget.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: Icon(
                  Icons.auto_awesome, 
                  color: Colors.white.withValues(alpha: 0.8), 
                  size: 20,
                ),
              ),
              if (_isHovered)
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(Icons.play_arrow, size: 28, color: Colors.white),
                  ),
                )
              else
                Positioned(
                  bottom: -15,
                  right: -15,
                  child: Transform.rotate(
                    angle: 0.2,
                    child: Opacity(
                      opacity: 0.15,
                      child: Icon(Icons.play_circle_fill, size: 100, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}


class StaggeredHomeSection<T> extends ConsumerStatefulWidget {
  const StaggeredHomeSection({
    super.key,
    required this.title,
    required this.provider,
    required this.builder,
    this.delay = Duration.zero,
    this.topPadding = 0,
    this.loadingWidget,
  });

  final String title;
  final FutureProvider<List<T>> provider;
  final Widget Function(BuildContext context, WidgetRef ref, List<T> data) builder;
  final Duration delay;
  final double topPadding;
  final Widget? loadingWidget;

  @override
  ConsumerState<StaggeredHomeSection<T>> createState() => _StaggeredHomeSectionState<T>();
}

class _StaggeredHomeSectionState<T> extends ConsumerState<StaggeredHomeSection<T>> {
  bool _shouldLoad = false;

  @override
  void initState() {
    super.initState();
    if (widget.delay == Duration.zero) {
      _shouldLoad = true;
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) {
          setState(() {
            _shouldLoad = true;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_shouldLoad) {
      return Padding(
        padding: EdgeInsets.only(top: widget.topPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _StaggeredHeader(title: widget.title),
            const SizedBox(height: 16),
            widget.loadingWidget ?? const SectionShimmer(height: 200),
          ],
        ),
      );
    }

    final asyncValue = ref.watch(widget.provider);

    return SectionWrapper<T>(
      title: widget.title,
      asyncValue: asyncValue,
      topPadding: widget.topPadding,
      builder: (data) => widget.builder(context, ref, data),
      loadingWidget: widget.loadingWidget,
      onRetry: () => ref.invalidate(widget.provider),
    );
  }
}

class _StaggeredHeader extends StatelessWidget {
  final String title;
  const _StaggeredHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 24,
            decoration: BoxDecoration(
              color: const Color(0xFFE50914), // Red vertical line
              borderRadius: BorderRadius.circular(1.5),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Theme.of(context).colorScheme.onSurface,
              letterSpacing: -0.5,
            ),
          ),
          const Spacer(),
          Text(
            'See all >',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
