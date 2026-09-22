import 'package:flutter/material.dart';
import 'package:ppplayer/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api/spotify_repository.dart';
import 'package:go_router/go_router.dart';
import '../../shared/widgets/pp_image.dart';
import '../../shared/widgets/playlist_cover.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
import '../../shared/widgets/context_menu/content_context_menu.dart';

final newReleasesProvider = StreamProvider((ref) {
  final repo = ref.watch(spotifyRepositoryProvider);
  return repo.watchNewReleases().map((r) => r.data);
});

final featuredPlaylistsProvider = StreamProvider((ref) {
  final repo = ref.watch(spotifyRepositoryProvider);
  return repo.watchFeaturedPlaylists().map((r) => r.data);
});

final popularTracksProvider = StreamProvider((ref) {
  final repo = ref.watch(spotifyRepositoryProvider);
  return repo.watchPopularTracks().map((r) => r.data);
});

final marketPopularAlbumsProvider = StreamProvider((ref) async* {
  final repo = ref.watch(spotifyRepositoryProvider);
  final tracks = await ref.watch(popularTracksProvider.future);
  final albumIds = tracks
      .map((t) => t.albumId)
      .where((id) => id != null && id.isNotEmpty)
      .cast<String>()
      .toSet()
      .toList();
  if (albumIds.isEmpty) {
    yield <Map<String, dynamic>>[];
    return;
  }
  yield* repo.watchPopularAlbums(albumIds.take(10).toList()).map((r) => r.data);
});

final popularArtistsProvider = StreamProvider((ref) async* {
  final repo = ref.watch(spotifyRepositoryProvider);
  final tracks = await ref.watch(popularTracksProvider.future);
  final artistIds = tracks
      .map((t) => t.artistId)
      .where((id) => id.isNotEmpty)
      .toSet()
      .toList();
  if (artistIds.isEmpty) {
    yield <Map<String, dynamic>>[];
    return;
  }
  yield* repo
      .watchPopularArtists(artistIds.take(10).toList())
      .map((r) => r.data);
});

final madeForYouMixesProvider = StreamProvider<List<Map<String, dynamic>>>((
  ref,
) async* {
  final repo = ref.watch(spotifyRepositoryProvider);
  final artists = await ref.watch(popularArtistsProvider.future);
  final genres = await ref.watch(browseCategoriesProvider.future);
  final validSeedsResult = await repo.watchGenreSeeds().first;
  final validSeeds = validSeedsResult.data;
  final mixes = <Map<String, dynamic>>[];

  if (artists.isNotEmpty) {
    mixes.add({
      'type': 'artist',
      'id': artists[0]['id'],
      'title': 'Daily Mix 1',
      'subtitle': 'Your favorites\nand new discoveries',
      'imageAsset': 'assets/images/mix_covers/daily_mix_1.jpg',
      'color1': AppTheme.themeColors[0],
      'color2': AppTheme.themeColors[1],
    });
  }

  if (artists.length > 2) {
    mixes.add({
      'type': 'artist',
      'id': artists[1]['id'],
      'title': 'Daily Mix 2',
      'subtitle': 'Your favorites\nand new discoveries',
      'imageAsset': 'assets/images/mix_covers/daily_mix_2.jpg',
      'color1': AppTheme.themeColors[2],
      'color2': AppTheme.themeColors[3],
    });
  }

  String discoverSeed = 'pop';
  for (final genre in genres) {
    final id = genre['id'] as String;
    if (validSeeds.contains(id)) {
      discoverSeed = id;
      break;
    }
  }

  mixes.add({
    'type': 'genre',
    'id': discoverSeed,
    'title': 'Discover Weekly',
    'subtitle': 'Made for you',
    'imageAsset': 'assets/images/mix_covers/discover_weekly.jpg',
    'color1': AppTheme.themeColors[4],
    'color2': AppTheme.themeColors[5],
  });

  mixes.add({
    'type': 'genre',
    'id': 'new-release',
    'title': 'Release Radar',
    'subtitle': 'New music\njust for you',
    'imageAsset': 'assets/images/mix_covers/release_radar.jpg',
    'color1': AppTheme.themeColors[6],
    'color2': AppTheme.themeColors[7],
  });

  mixes.add({
    'type': 'genre',
    'id': 'chill',
    'title': 'Chill Mix',
    'subtitle': 'Relax and unwind',
    'imageAsset': 'assets/images/mix_covers/chill_mix.jpg',
    'color1': AppTheme.themeColors[8],
    'color2': AppTheme.themeColors[9],
  });

  mixes.add({
    'type': 'genre',
    'id': 'study',
    'title': 'Focus Mix',
    'subtitle': 'Deep focus\nand productivity',
    'imageAsset': 'assets/images/mix_covers/focus_mix.jpg',
    'color1': AppTheme.themeColors[10],
    'color2': AppTheme.themeColors[11],
  });

  yield mixes;
});

final suggestedStationsProvider = StreamProvider<List<Map<String, dynamic>>>((
  ref,
) async* {
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

  yield radios;
});

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _hasCheckedProfile = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final settings = ref.watch(settingsProvider);

    if (!_hasCheckedProfile && settings.isLoaded) {
      _hasCheckedProfile = true;
      if (settings.userName.isEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showEditProfileModal(context, ref, isDismissible: false);
        });
      }
    }

    final l10n = AppLocalizations.of(context)!;
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = l10n.goodMorning;
    } else if (hour < 17) {
      greeting = l10n.goodAfternoon;
    } else {
      greeting = l10n.goodEvening;
    }
    final firstName = settings.userName.isNotEmpty
        ? settings.userName.split(' ').first
        : '';
    final greetingText = firstName.isNotEmpty
        ? l10n.greetingWithName(greeting, firstName)
        : greeting;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 32.0,
                top: 56.0,
                right: 32.0,
                bottom: 24.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
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
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.yourMusicIsWaiting,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  if (MediaQuery.of(context).size.width <
                      600) // Show on mobile/tablet
                    TactileIconButton(
                      icon: Icons.settings_outlined,
                      size: 28,
                      onTap: () => context.push('/settings'),
                      color: Theme.of(context).colorScheme.onSurface,
                      hoverColor: Theme.of(context).colorScheme.primary,
                      tooltip: AppLocalizations.of(context)!.settings,
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
                    title: AppLocalizations.of(context)!.continueListening,
                    provider: recentlyPlayedProvider,
                    delay: 0.seconds,
                    topPadding: 24,
                    builder: (context, ref, tracks) => SizedBox(
                      height: 240,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: tracks.length.clamp(0, 10),
                        itemBuilder: (context, index) {
                          final track = tracks[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: _HistoryCard(
                              track: track,
                              onTap: () => ref
                                  .read(playerProvider.notifier)
                                  .playTrack(track, queue: tracks),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  StaggeredHomeSection<Map<String, dynamic>>(
                    title: AppLocalizations.of(context)!.popularArtists,
                    provider: popularArtistsProvider,
                    delay: 500.ms,
                    builder: (context, ref, artists) => SizedBox(
                      height: 170,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: artists.length,
                        itemBuilder: (context, index) {
                          final artist = artists[index];
                          final imageUrl =
                              (artist['images'] as List?)
                                  ?.firstOrNull?['url'] ??
                              '';
                          return _ArtistCircle(
                                id: artist['id'],
                                name: artist['name'],
                                imageUrl: imageUrl,
                                onTap: () =>
                                    context.push('/artist/${artist['id']}'),
                              )
                              .animate()
                              .fadeIn(delay: (100 + (index * 100)).ms)
                              .scale(begin: const Offset(0.8, 0.8));
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  StaggeredHomeSection<Map<String, dynamic>>(
                    title: AppLocalizations.of(context)!.madeForYou,
                    provider: madeForYouMixesProvider,
                    delay: 1.seconds,
                    builder: (context, ref, mixes) => SizedBox(
                      height: 138,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: mixes.length,
                        itemBuilder: (context, index) {
                          final mix = mixes[index];
                          String mixTitle = mix['title'];
                          if (mixTitle == 'Daily Mix 1') {
                            mixTitle = l10n.dailyMix('1');
                          } else if (mixTitle == 'Daily Mix 2') {
                            mixTitle = l10n.dailyMix('2');
                          } else if (mixTitle == 'Discover Weekly') {
                            mixTitle = l10n.discoverWeekly;
                          } else if (mixTitle == 'Release Radar') {
                            mixTitle = l10n.releaseRadar;
                          } else if (mixTitle == 'Chill Mix') {
                            mixTitle = l10n.chillMix;
                          } else if (mixTitle == 'Focus Mix') {
                            mixTitle = l10n.focusMix;
                          }

                          String mixSubtitle = mix['subtitle'];
                          if (mixSubtitle ==
                              'Your favorites\nand new discoveries') {
                            mixSubtitle = l10n.yourFavoritesAndNewDiscoveries;
                          } else if (mixSubtitle == 'Made for you') {
                            mixSubtitle = l10n.madeForYou;
                          } else if (mixSubtitle == 'New music\njust for you') {
                            mixSubtitle = l10n.newMusicJustForYou;
                          } else if (mixSubtitle == 'Relax and unwind') {
                            mixSubtitle = l10n.relaxAndUnwind;
                          } else if (mixSubtitle ==
                              'Deep focus\nand productivity') {
                            mixSubtitle = l10n.deepFocusAndProductivity;
                          }

                          return _MixCard(
                                title: mixTitle,
                                subtitle: mixSubtitle,
                                imageAsset: mix['imageAsset'] as String,
                                color1: mix['color1'] as Color,
                                color2: mix['color2'] as Color,
                                contextTarget: RadioContextTarget(
                                  seedId: mix['id'],
                                  seedType: mix['type'] ?? 'genre',
                                  title: mixTitle,
                                  imageUrl:
                                      mix['imageUrl'] ?? mix['imageAsset'],
                                ),
                                onTap: () => context.push(
                                  Uri(
                                    path: '/radio/${mix['type']}/${mix['id']}',
                                    queryParameters: {
                                      'title': mix['title'],
                                      'imageUrl':
                                          mix['imageUrl'] ??
                                          mix['imageAsset'] ??
                                          '',
                                      'subtitle': mix['subtitle'] ?? '',
                                    },
                                  ).toString(),
                                  extra: <String, dynamic>{
                                    'color1': mix['color1'],
                                    'color2': mix['color2'],
                                  },
                                ),
                              )
                              .animate(delay: (index * 100).ms)
                              .fadeIn()
                              .scale(begin: const Offset(0.8, 0.8));
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  StaggeredHomeSection<Map<String, dynamic>>(
                    title: AppLocalizations.of(context)!.suggestedStations,
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
                                contextTarget: RadioContextTarget(
                                  seedId: radio['id'],
                                  seedType: radio['type'] ?? 'genre',
                                  title: radio['title'],
                                  imageUrl: radio['imageUrl'],
                                ),
                                onTap: () => context.push(
                                  Uri(
                                    path:
                                        '/radio/${radio['type']}/${radio['id']}',
                                    queryParameters: {
                                      'title': radio['title'],
                                      'imageUrl': radio['imageUrl'],
                                    },
                                  ).toString(),
                                ),
                              )
                              .animate()
                              .fadeIn(delay: (index * 100).ms)
                              .scale(begin: const Offset(0.9, 0.9));
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  StaggeredHomeSection<Map<String, dynamic>>(
                    title: AppLocalizations.of(context)!.popularAlbums,
                    provider: marketPopularAlbumsProvider,
                    delay: 2.seconds,
                    builder: (context, ref, albums) => _HorizontalList(
                      items: albums,
                      onTap: (item) => context.push("/album/${item['id']}"),
                    ).animate().fadeIn().slideY(begin: 0.1),
                  ),
                  const SizedBox(height: 32),
                  StaggeredHomeSection<Map<String, dynamic>>(
                    title: AppLocalizations.of(context)!.popularGenres,
                    provider: browseCategoriesProvider,
                    delay: 2.5.seconds,
                    builder: (context, ref, items) => LayoutBuilder(
                      builder: (context, constraints) {
                        if (constraints.maxWidth >= 600) {
                          final crossAxisCount = (constraints.maxWidth / 160)
                              .floor()
                              .clamp(2, 6);
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: 1.6,
                                ),
                            itemCount: items.length.clamp(0, 12),
                            itemBuilder: (context, index) {
                              final category = items[index];
                              final id = category['id'] as String;
                              final name = category['name'] as String;
                              final imageUrl =
                                  (category['icons'] as List?)
                                      ?.firstOrNull?['url'] ??
                                  '';
                              return _GenreCard(
                                    name: name,
                                    imageUrl: imageUrl,
                                    onTap: () => context.push(
                                      Uri(
                                        path: '/genre/$id',
                                        queryParameters: {'name': name},
                                      ).toString(),
                                    ),
                                  )
                                  .animate()
                                  .fadeIn(delay: (index * 50).ms)
                                  .scale(begin: const Offset(0.9, 0.9));
                            },
                          );
                        } else {
                          return SizedBox(
                            height: 96,
                            child: GridView.builder(
                              scrollDirection: Axis.horizontal,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 1,
                                    mainAxisSpacing: 12,
                                    childAspectRatio: 0.6,
                                  ),
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                final category = items[index];
                                final id = category['id'] as String;
                                final name = category['name'] as String;
                                final imageUrl =
                                    (category['icons'] as List?)
                                        ?.firstOrNull?['url'] ??
                                    '';
                                return _GenreCard(
                                      name: name,
                                      imageUrl: imageUrl,
                                      onTap: () => context.push(
                                        Uri(
                                          path: '/genre/$id',
                                          queryParameters: {'name': name},
                                        ).toString(),
                                      ),
                                    )
                                    .animate()
                                    .fadeIn(delay: (index * 50).ms)
                                    .scale(begin: const Offset(0.9, 0.9));
                              },
                            ),
                          );
                        }
                      },
                    ),
                    loadingWidget: const SectionShimmer(
                      height: 140,
                      childAspectRatio: 0.45,
                      isGrid: true,
                      count: 6,
                    ),
                  ),
                  const SizedBox(height: 32),
                  const BannerAdWidget(),
                  const SizedBox(height: 32),
                  StaggeredHomeSection<Map<String, dynamic>>(
                    title: AppLocalizations.of(context)!.newReleases,
                    provider: newReleasesProvider,
                    delay: 3.seconds,
                    builder: (context, ref, items) => _HorizontalList(
                      items: items,
                      onTap: (item) => context.push("/album/${item['id']}"),
                    ).animate().fadeIn().slideY(begin: 0.1),
                  ),
                  const SizedBox(height: 32),
                  StaggeredHomeSection<Map<String, dynamic>>(
                    title: AppLocalizations.of(context)!.featuredPlaylists,
                    provider: featuredPlaylistsProvider,
                    delay: 3.5.seconds,
                    builder: (context, ref, items) => _HorizontalList(
                      items: items,
                      isPlaylist: true,
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
                    title: AppLocalizations.of(context)!.popularTracks,
                    provider: popularTracksProvider,
                    delay: 4.seconds,
                    builder: (context, ref, tracks) => SizedBox(
                      height: 230,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: tracks.length + 1,
                        itemBuilder: (context, index) {
                          if (index == 4) {
                            final promo = ref
                                .read(adServiceProvider)
                                .getPromoData()[0];
                            return PromotionTile(
                                  title: promo['title']!,
                                  subtitle: promo['subtitle']!,
                                  imageUrl: promo['image'],
                                  ctaText: promo['cta']!,
                                  type: PromotionType.horizontal,
                                )
                                .animate()
                                .fadeIn(delay: (index * 100).ms)
                                .scale(begin: const Offset(0.9, 0.9));
                          }

                          final trackIndex = index > 4 ? index - 1 : index;
                          if (trackIndex >= tracks.length) {
                            return const SizedBox.shrink();
                          }

                          final track = tracks[trackIndex];
                          return _AlbumCard(
                                title: track.name,
                                subtitle: track.artistName,
                                imageUrl: track.albumImage ?? '',
                                contextTarget: TrackContextTarget(track),
                                onTap: () => ref
                                    .read(playerProvider.notifier)
                                    .playTrack(track, queue: tracks),
                                artistId: track.artistId,
                              )
                              .animate()
                              .fadeIn(delay: (index * 100).ms)
                              .slideY(begin: 0.1);
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
  const _HorizontalList({
    required this.items,
    required this.onTap,
    this.isPlaylist = false,
  });
  final List<Map<String, dynamic>> items;
  final Function(Map<String, dynamic>) onTap;
  final bool isPlaylist;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 600) {
          final crossAxisCount = (constraints.maxWidth / 172).floor().clamp(
            2,
            8,
          );
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
              final artistName = artists.isNotEmpty
                  ? artists[0]['name']
                  : (item['publisher'] ?? '');
              final artistId = artists.isNotEmpty ? artists[0]['id'] : null;

              final target = isPlaylist
                  ? PlaylistContextTarget(
                      id: item['id'] as String,
                      name: item['name'] as String,
                      imageUrl: imageUrl,
                    )
                  : AlbumContextTarget(
                      id: item['id'] as String,
                      name: item['name'] as String,
                      artistId: artistId ?? '',
                      artistName: artistName,
                      imageUrl: imageUrl,
                    );

              return _AlbumCard(
                title: item['name'],
                subtitle: artistName,
                imageUrl: imageUrl,
                images: images,
                contextTarget: target,
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
                final images = rawImages
                    .map((i) => i['url'] as String)
                    .toList();
                final imageUrl = images.firstOrNull ?? '';
                final artists = (item['artists'] as List?) ?? [];
                final artistName = artists.isNotEmpty
                    ? artists[0]['name']
                    : (item['publisher'] ?? '');
                final artistId = artists.isNotEmpty ? artists[0]['id'] : null;

                final target = isPlaylist
                    ? PlaylistContextTarget(
                        id: item['id'] as String,
                        name: item['name'] as String,
                        imageUrl: imageUrl,
                      )
                    : AlbumContextTarget(
                        id: item['id'] as String,
                        name: item['name'] as String,
                        artistId: artistId ?? '',
                        artistName: artistName,
                        imageUrl: imageUrl,
                      );

                return _AlbumCard(
                  title: item['name'],
                  subtitle: artistName,
                  imageUrl: imageUrl,
                  images: images,
                  contextTarget: target,
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
  const _GenreCard({
    required this.name,
    required this.imageUrl,
    required this.onTap,
  });
  final String name;
  final String imageUrl;
  final VoidCallback onTap;

  Color _getGenreColor(String name) {
    final int hash = name.hashCode;
    final double hue = (hash % 360).abs().toDouble();
    return HSLColor.fromAHSL(1.0, hue, 0.75, 0.35).toColor();
  }

  IconData _getGenreIcon(String name) {
    final lowerName = name.toLowerCase();
    if (lowerName.contains('top') || lowerName.contains('chart'))
      return Icons.bar_chart_rounded;
    if (lowerName.contains('pop')) return Icons.mic_external_on_rounded;
    if (lowerName.contains('hip-hop') ||
        lowerName.contains('rap') ||
        lowerName.contains('r&b'))
      return Icons.speaker_rounded;
    if (lowerName.contains('rock') || lowerName.contains('metal'))
      return Icons.electric_bolt_rounded;
    if (lowerName.contains('mood')) return Icons.wb_twilight_rounded;
    if (lowerName.contains('workout') || lowerName.contains('fitness'))
      return Icons.monitor_heart_rounded;
    if (lowerName.contains('chill') || lowerName.contains('sleep'))
      return Icons.nightlight_round;
    if (lowerName.contains('party') || lowerName.contains('dance'))
      return Icons.celebration_rounded;
    if (lowerName.contains('focus') || lowerName.contains('study'))
      return Icons.center_focus_strong_rounded;
    if (lowerName.contains('indie') || lowerName.contains('alternative'))
      return Icons.camera_alt_rounded;
    return Icons.music_note_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bgColor = _getGenreColor(name);

    return TactileTap(
      onTap: onTap,
      scaleDown: 0.98,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
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
            // Background Glow / Lighter highlight
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
                      Colors.white.withValues(alpha: 0.15),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: -20,
              right: -20,
              child: Transform.rotate(
                angle: 0.2,
                child: Icon(
                  _getGenreIcon(name),
                  size: 110,
                  color: Colors.white.withValues(alpha: 0.2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      letterSpacing: -0.5,
                      color: Colors.white,
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
    Widget card = MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: TactileTap(
        onTap: widget.onTap,
        scaleDown: 0.98,
        child: Container(
          width: 160,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(
              alpha: _isHovered ? 0.3 : 0.1,
            ),
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
                            child: Icon(
                              Icons.play_circle_fill,
                              size: 48,
                              color: Colors.white,
                            ),
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

    return ContentContextMenuRegion(
      target: TrackContextTarget(widget.track),
      child: card,
    );
  }
}

class _AlbumCard extends ConsumerStatefulWidget {
  const _AlbumCard({
    required this.title,
    required this.subtitle,
    this.imageUrl,
    this.images,
    required this.onTap,
    this.artistId,
    this.isGridItem = false,
    this.contextTarget,
  });

  final String title;
  final String subtitle;
  final String? imageUrl;
  final List<String>? images;
  final VoidCallback onTap;
  final String? artistId;
  final bool isGridItem;
  final ContextMenuTarget? contextTarget;

  @override
  ConsumerState<_AlbumCard> createState() => _AlbumCardState();
}

class _AlbumCardState extends ConsumerState<_AlbumCard> {
  bool _isHovered = false;

  void _onPlay() async {
    final target = widget.contextTarget;
    if (target is PlaylistContextTarget) {
      try {
        final cacheResult = await ref
            .read(spotifyRepositoryProvider)
            .watchPlaylistTracks(target.id)
            .first;
        final rawTracks = cacheResult.data;
        if (rawTracks.isNotEmpty) {
          ref
              .read(playerProvider.notifier)
              .playTrack(rawTracks.first, queue: rawTracks);
        }
      } catch (e) {
        widget.onTap();
      }
    } else if (target is AlbumContextTarget) {
      try {
        final cacheResult = await ref
            .read(spotifyRepositoryProvider)
            .watchAlbum(target.id)
            .first;
        final tracksList = cacheResult.data['tracks']?['items'] as List?;
        if (tracksList != null) {
          final tracks = tracksList
              .map((j) => Track.fromSpotify(j as Map<String, dynamic>))
              .toList();
          if (tracks.isNotEmpty) {
            ref
                .read(playerProvider.notifier)
                .playTrack(tracks.first, queue: tracks);
          }
        }
      } catch (e) {
        widget.onTap();
      }
    } else {
      widget.onTap();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Widget imageWidget;
    if (widget.images != null && widget.images!.length > 1) {
      imageWidget = PlaylistCover(
        images: widget.images!,
        size: widget.isGridItem ? double.infinity : 156,
        borderRadius: 20,
      );
    } else {
      imageWidget = PPImage(
        imageUrl: widget.images?.firstOrNull ?? widget.imageUrl ?? '',
        width: widget.isGridItem ? double.infinity : 156,
        height: widget.isGridItem ? double.infinity : 156,
        fit: BoxFit.cover,
      );
    }

    Widget card = MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: TactileTap(
        onTap: widget.onTap,
        scaleDown: 0.95,
        child: AnimatedScale(
          scale: _isHovered ? 1.03 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          child: Container(
            width: widget.isGridItem ? null : 156,
            margin: widget.isGridItem
                ? EdgeInsets.zero
                : const EdgeInsets.only(right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOutCubic,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: _isHovered
                              ? colorScheme.primary.withValues(alpha: 0.35)
                              : colorScheme.scrim.withValues(alpha: 0.4),
                          blurRadius: _isHovered ? 28 : 25,
                          spreadRadius: _isHovered ? 2 : 0,
                          offset: Offset(0, _isHovered ? 14 : 12),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: HoverPlayOverlay(
                        onPlay: _onPlay,
                        isHovered: _isHovered,
                        size: 40,
                        child: Stack(
                          children: [
                            imageWidget,
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: colorScheme.onSurface.withValues(
                                      alpha: 0.1,
                                    ),
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
                const SizedBox(height: 8),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 150),
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                    letterSpacing: -0.4,
                    height: 1.2,
                    color: _isHovered
                        ? colorScheme.primary
                        : colorScheme.onSurface,
                  ),
                  child: Text(
                    widget.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.subtitle.replaceAll(RegExp(r'<[^>]*>'), ''),
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
        ),
      ),
    );

    if (widget.contextTarget != null) {
      card = ContentContextMenuRegion(
        target: widget.contextTarget!,
        child: card,
      );
    }
    return card;
  }
}

class _ArtistCircle extends ConsumerWidget {
  const _ArtistCircle({
    required this.name,
    required this.imageUrl,
    required this.onTap,
    this.id,
  });

  final String name;
  final String imageUrl;
  final VoidCallback onTap;
  final String? id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    Widget circle = TactileTap(
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
                  onPlay: () async {
                    if (id == null) {
                      onTap();
                      return;
                    }
                    try {
                      final cacheResult = await ref
                          .read(spotifyRepositoryProvider)
                          .watchArtistTopTracks(id!)
                          .first;
                      final rawTracks = cacheResult.data;
                      final tracks = rawTracks
                          .map(
                            (j) => Track.fromSpotify(j as Map<String, dynamic>),
                          )
                          .toList();
                      if (tracks.isNotEmpty) {
                        ref
                            .read(playerProvider.notifier)
                            .playTrack(tracks.first, queue: tracks);
                      } else {
                        onTap();
                      }
                    } catch (e) {
                      debugPrint('Failed to play artist tracks: $e');
                      onTap();
                    }
                  },
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

    if (id != null) {
      circle = ContentContextMenuRegion(
        target: ArtistContextTarget(id: id!, name: name, imageUrl: imageUrl),
        child: circle,
      );
    }
    return circle;
  }
}

// _LoadingPlaceholder class removed as it is replaced by ShimmerPlaceholder

class _RadioCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final VoidCallback onTap;
  final RadioContextTarget? contextTarget;

  const _RadioCard({
    required this.title,
    required this.imageUrl,
    required this.onTap,
    this.contextTarget,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    Widget card = TactileTap(
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
              PPImage(imageUrl: imageUrl, fit: BoxFit.cover),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.4),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.sensors,
                        size: 12,
                        color: colorScheme.onPrimary,
                      ),
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

    if (contextTarget != null) {
      card = ContentContextMenuRegion(target: contextTarget!, child: card);
    }
    return card;
  }
}

class _MixCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String imageAsset;
  final Color color1;
  final Color color2;
  final VoidCallback onTap;
  final RadioContextTarget? contextTarget;

  const _MixCard({
    required this.title,
    required this.subtitle,
    required this.imageAsset,
    required this.color1,
    required this.color2,
    required this.onTap,
    this.contextTarget,
  });

  @override
  State<_MixCard> createState() => _MixCardState();
}

class _MixCardState extends State<_MixCard> {
  bool _isHovered = false;

  String get _formattedTitle {
    if (widget.title.contains('\n')) return widget.title;
    if (widget.title.startsWith('Daily Mix ')) {
      return 'Daily Mix\n${widget.title.substring(10)}';
    }
    final spaceIndex = widget.title.indexOf(' ');
    if (spaceIndex != -1) {
      return '${widget.title.substring(0, spaceIndex)}\n${widget.title.substring(spaceIndex + 1)}';
    }
    return widget.title;
  }

  @override
  Widget build(BuildContext context) {
    Widget card = MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedScale(
        scale: _isHovered ? 1.03 : 1.0,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        child: TactileTap(
          onTap: widget.onTap,
          scaleDown: 0.97,
          child: Semantics(
            label: '${widget.title}, ${widget.subtitle}',
            button: true,
            child: Container(
              width: 190,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: _isHovered
                        ? widget.color1.withValues(alpha: 0.45)
                        : Colors.black.withValues(alpha: 0.25),
                    blurRadius: _isHovered ? 18 : 8,
                    offset: Offset(0, _isHovered ? 4 : 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // 1. High-resolution atmospheric artwork
                    Image.asset(widget.imageAsset, fit: BoxFit.cover),

                    // 2. Soft horizontal scrim for text legibility
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Colors.black.withValues(alpha: 0.45),
                              Colors.black.withValues(alpha: 0.15),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.45, 0.85],
                          ),
                        ),
                      ),
                    ),

                    // 3. Soft bottom scrim for subtitle legibility
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.40),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.55],
                          ),
                        ),
                      ),
                    ),

                    // 4. Subtle brightness sheen on hover
                    AnimatedOpacity(
                      opacity: _isHovered ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 180),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withValues(alpha: 0.10),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),

                    // 5. Razor-sharp vector typography
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _formattedTitle,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              height: 1.15,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            widget.subtitle,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontSize: 10.5,
                              fontWeight: FontWeight.w500,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 6. Sparkle icon top-right
                    Positioned(
                      top: 11,
                      right: 12,
                      child: Icon(
                        Icons.auto_awesome,
                        color: Colors.white.withValues(alpha: 0.75),
                        size: 14,
                      ),
                    ),

                    // 7. Subtle bottom-right PPPlayer logo badge in rest state
                    Positioned(
                      bottom: 9,
                      right: 9,
                      child: AnimatedOpacity(
                        opacity: _isHovered ? 0.0 : 1.0,
                        duration: const Duration(milliseconds: 150),
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.28),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Image.asset(
                              'assets/logo.png',
                              width: 13,
                              height: 13,
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.8),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // 8. Hover play button with glowing PPPlayer red accent
                    Positioned(
                      bottom: 7,
                      right: 7,
                      child: AnimatedOpacity(
                        opacity: _isHovered ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 180),
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withValues(alpha: 0.6),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.play_arrow_rounded,
                            size: 18,
                            color: Theme.of(context).colorScheme.onPrimary,
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
      ),
    );

    if (widget.contextTarget != null) {
      card = ContentContextMenuRegion(
        target: widget.contextTarget!,
        child: card,
      );
    }
    return card;
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
  final dynamic provider;
  final Widget Function(BuildContext context, WidgetRef ref, List<T> data)
  builder;
  final Duration delay;
  final double topPadding;
  final Widget? loadingWidget;

  @override
  ConsumerState<StaggeredHomeSection<T>> createState() =>
      _StaggeredHomeSectionState<T>();
}

class _StaggeredHomeSectionState<T>
    extends ConsumerState<StaggeredHomeSection<T>> {
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
              color: Theme.of(
                context,
              ).colorScheme.primary, // Theme vertical line
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
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
