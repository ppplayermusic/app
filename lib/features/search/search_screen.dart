import 'dart:async';
import 'package:flutter/material.dart';
import '../../shared/widgets/pp_image.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/player/player_provider.dart';
import '../../shared/widgets/track_tile.dart';
import '../../shared/widgets/banner_ad_widget.dart';
import '../../shared/widgets/promotion_tile.dart';
import '../../shared/widgets/tactile_buttons.dart';
import '../../core/services/ad_service.dart';
import '../../core/providers/genre_providers.dart';
import '../home/genre_details_screen.dart';
import '../../shared/widgets/shimmer_placeholder.dart';
import '../../shared/widgets/adaptive_blur.dart';
import '../../shared/widgets/context_menu/content_context_menu.dart';
import 'package:ppplayer/core/providers/recent_searches_provider.dart';
import 'package:ppplayer/core/providers/search_provider.dart';
import 'package:ppplayer/core/api/spotify_repository.dart';

final searchResultsProvider = StreamProvider.autoDispose.family<
  Map<String, dynamic>,
  String
>((ref, query) async* {
  if (query.isEmpty) {
    yield {};
    return;
  }

  bool didDispose = false;
  ref.onDispose(() => didDispose = true);

  // Debounce for 800ms to avoid spamming the API and to only save actual searches
  await Future.delayed(const Duration(milliseconds: 800));

  if (didDispose) {
    return;
  }

  // Automatically save to recent searches since the user paused typing
  if (query.trim().isNotEmpty) {
    ref.read(recentSearchesProvider.notifier).addSearch(query);
  }

  yield* ref
      .read(spotifyRepositoryProvider)
      .watchSearch(query)
      .map((res) => res.data);
});

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _ctrl;
  late final TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController();
    _tabCtrl = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(searchQueryProvider);
    final results = ref.watch(searchResultsProvider(query));
    final colorScheme = Theme.of(context).colorScheme;
    final isDesktop = MediaQuery.sizeOf(context).width >= 600;

    ref.listen<String>(searchQueryProvider, (prev, next) {
      if (_ctrl.text != next) {
        _ctrl.text = next;
        _ctrl.selection = TextSelection.fromPosition(
          TextPosition(offset: next.length),
        );
      }
    });

    final searchTabs = TabBar(
      controller: _tabCtrl,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: colorScheme.primary, width: 3),
        insets: const EdgeInsets.symmetric(horizontal: 16),
      ),
      indicatorSize: TabBarIndicatorSize.tab,
      labelColor: colorScheme.onSurface,
      unselectedLabelColor: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
      labelStyle: const TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: 13,
        letterSpacing: 1.0,
      ),
      unselectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: 13,
        letterSpacing: 1.0,
      ),
      dividerColor: Colors.transparent,
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      labelPadding: const EdgeInsets.symmetric(horizontal: 8),
      tabs: const [
        Tab(text: 'TRACKS'),
        Tab(text: 'ARTISTS'),
        Tab(text: 'ALBUMS'),
        Tab(text: 'PLAYLISTS'),
      ],
    );

    return Scaffold(
      appBar:
          isDesktop
              ? null
              : AppBar(
                elevation: 0,
                backgroundColor: colorScheme.surface.withValues(alpha: 0.1),
                flexibleSpace: AdaptiveBlur(
                  sigmaX: 25,
                  sigmaY: 25,
                  child: Container(
                    color: colorScheme.surface.withValues(alpha: 0.2),
                  ),
                ),
                title: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurface.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: colorScheme.primary.withValues(alpha: 0.15),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.scrim.withValues(alpha: 0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                      BoxShadow(
                        color: colorScheme.primary.withValues(alpha: 0.15),
                        blurRadius: 20,
                        spreadRadius: -5,
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _ctrl,
                    autofocus: false,
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 16,
                    ),
                    cursorColor: colorScheme.primary,
                    decoration: InputDecoration(
                      hintText: 'What do you want to listen to?',
                      hintStyle: TextStyle(
                        color: colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.4,
                        ),
                        fontSize: 15,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.6,
                        ),
                        size: 22,
                      ),
                      suffixIcon:
                          _ctrl.text.isNotEmpty
                              ? TactileIconButton(
                                icon: Icons.close_rounded,
                                onTap: () {
                                  _ctrl.clear();
                                  ref
                                      .read(searchQueryProvider.notifier)
                                      .updateQuery('');
                                  setState(() {});
                                },
                                size: 20,
                                color: colorScheme.onSurfaceVariant,
                              )
                              : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 13),
                    ),
                    onChanged: (val) {
                      ref.read(searchQueryProvider.notifier).updateQuery(val);
                    },
                    onSubmitted: (val) {
                      if (val.trim().isNotEmpty) {
                        ref
                            .read(recentSearchesProvider.notifier)
                            .addSearch(val);
                      }
                    },
                  ),
                ),
                bottom:
                    query.isEmpty
                        ? null
                        : PreferredSize(
                          preferredSize: const Size.fromHeight(48),
                          child: searchTabs,
                        ),
              ),
      body:
          query.isEmpty
              ? _EmptySearch()
              : Column(
                children: [
                  if (isDesktop) SizedBox(height: 48, child: searchTabs),
                  Expanded(
                    child: results.when(
                      loading:
                          () => const CustomScrollView(
                            slivers: [
                              SliverSectionShimmer(count: 12, isGrid: false),
                            ],
                          ),
                      error: (e, _) => Center(child: Text('Error: $e')),
                      data:
                          (data) => TabBarView(
                            controller: _tabCtrl,
                            children: [
                              _TrackResults(data['tracks']?['items'] ?? []),
                              _ArtistResults(data['artists']?['items'] ?? []),
                              _AlbumResults(data['albums']?['items'] ?? []),
                              _PlaylistResults(
                                data['playlists']?['items'] ?? [],
                              ),
                            ],
                          ),
                    ),
                  ),
                ],
              ),
    );
  }
}

class _EmptySearch extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(browseCategoriesProvider);
    final recentSearches = ref.watch(recentSearchesProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return CustomScrollView(
      slivers: [
        if (recentSearches.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
              child: Text(
                    'Recent searches',
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.8,
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .slideX(begin: -0.1, end: 0, curve: Curves.easeOutCubic),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 36,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: recentSearches.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final query = recentSearches[index];
                  return InputChip(
                    label: Text(
                      query,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    onPressed: () {
                      ref.read(searchQueryProvider.notifier).updateQuery(query);
                    },
                    onDeleted: () {
                      ref
                          .read(recentSearchesProvider.notifier)
                          .removeSearch(query);
                    },
                    deleteIconColor: colorScheme.onSurfaceVariant,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              16,
              recentSearches.isNotEmpty ? 32 : 24,
              16,
              16,
            ),
            child: Text(
                  'Browse all',
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.8,
                  ),
                )
                .animate()
                .fadeIn(duration: 600.ms)
                .slideX(begin: -0.1, end: 0, curve: Curves.easeOutCubic),
          ),
        ),
        categoriesAsync.when(
          data:
              (categories) => SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 1.6,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final cat = categories[index];
                    final name = cat['name'] as String;
                    final id = cat['id'] as String;
                    final imageUrl =
                        ((cat['icons'] as List?)?.firstOrNull?['url']
                            as String?) ??
                        '';
                    final color = ref.watch(categoryColorProvider(name));

                    return _CategoryCard(
                          id: id,
                          name: name,
                          color: color,
                          imageUrl: imageUrl,
                        )
                        .animate(delay: (index * 30).ms)
                        .fadeIn(duration: 400.ms)
                        .scale(
                          begin: const Offset(0.95, 0.95),
                          end: const Offset(1, 1),
                        );
                  }, childCount: categories.length),
                ),
              ),
          loading:
              () => const SliverSectionShimmer(
                count: 10,
                isGrid: true,
                crossAxisCount: 2,
                childAspectRatio: 1.6,
              ),
          error:
              (e, _) => SliverToBoxAdapter(
                child: Center(
                  child: Text(
                    'Error loading categories: $e',
                    style: TextStyle(color: colorScheme.error),
                  ),
                ),
              ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    ).animate().fadeIn(duration: 300.ms);
  }
}

class _CategoryCard extends StatelessWidget {
  final String id;
  final String name;
  final Color color;
  final String imageUrl;

  const _CategoryCard({
    required this.id,
    required this.name,
    required this.color,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return TactileTap(
      onTap:
          () => context.push(
            Uri(path: '/genre/$id', queryParameters: {'name': name}).toString(),
          ),
      scaleDown: 0.94,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withValues(alpha: 0.8),
              color.withValues(alpha: 0.4),
            ],
          ),
          border: Border.all(
            color: colorScheme.onSurface.withValues(alpha: 0.1),
            width: 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.scrim.withValues(alpha: 0.2),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: AdaptiveBlur(
          sigmaX: 20,
          sigmaY: 20,
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              if (imageUrl.isNotEmpty)
                Positioned(
                  bottom: -15,
                  right: -15,
                  child: Transform.rotate(
                    angle: 0.3,
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.scrim.withValues(alpha: 0.3),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: PPImage(
                        imageUrl: imageUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  name,
                  style: TextStyle(
                    color:
                        colorScheme
                            .onPrimary, // Standard for vibrant cards, semantic value below
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                    shadows: [
                      Shadow(
                        color: colorScheme.scrim.withValues(alpha: 0.3),
                        offset: const Offset(0, 1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().shimmer(
      delay: 5.seconds,
      duration: 2.seconds,
      color: colorScheme.onSurface.withValues(alpha: 0.05),
    );
  }
}

class _TrackResults extends ConsumerWidget {
  const _TrackResults(this.items);
  final List<dynamic> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (items.isEmpty) return const Center(child: Text('No tracks found'));
    final tracks =
        items.map((j) => Track.fromSpotify(j as Map<String, dynamic>)).toList();
    return ListView.builder(
      itemCount: tracks.length + (tracks.length / 8).ceil(),
      itemBuilder: (_, i) {
        if (i % 9 == 0) {
          final promoIndex = (i / 9).floor() % 3;
          final promo = ref.read(adServiceProvider).getPromoData()[promoIndex];
          return PromotionTile(
            title: promo['title']!,
            subtitle: promo['subtitle']!,
            imageUrl: promo['image'],
            ctaText: promo['cta']!,
            type: PromotionType.vertical,
          ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0);
        }

        final trackIndex = i - (i / 9).floor() - 1;
        if (trackIndex >= tracks.length || trackIndex < 0)
          return const SizedBox.shrink();

        return TrackTile(
              track: tracks[trackIndex],
              onTap:
                  () => ref
                      .read(playerProvider.notifier)
                      .playTrack(tracks[trackIndex], queue: tracks),
            )
            .animate(delay: (100 + i % 10 * 40).ms)
            .fadeIn(duration: 500.ms)
            .slideX(begin: 0.05, end: 0, curve: Curves.easeOutCubic);
      },
    );
  }
}

class _ArtistResults extends ConsumerWidget {
  const _ArtistResults(this.items);
  final List<dynamic> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    if (items.isEmpty) return const Center(child: Text('No artists found'));
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: items.length + (items.length / 8).ceil(),
      itemBuilder: (_, i) {
        if (i % 9 == 0 && i != 0) {
          final promoIndex = (i / 9).floor() % 3;
          final promo = ref.read(adServiceProvider).getPromoData()[promoIndex];
          return PromotionTile(
            title: promo['title']!,
            subtitle: promo['subtitle']!,
            imageUrl: promo['image'],
            ctaText: promo['cta']!,
            type: PromotionType.vertical,
          );
        }

        final artistIndex = i - (i / 9).floor();
        if (artistIndex >= items.length || artistIndex < 0)
          return const SizedBox.shrink();

        final a = items[artistIndex] as Map<String, dynamic>;
        final images = (a['images'] as List?) ?? [];
        final imageUrl = images.isNotEmpty ? images[0]['url'] as String : '';

        return ContentContextMenuRegion(
              target: ArtistContextTarget(
                id: a['id'] as String,
                name: a['name'] as String,
                imageUrl: imageUrl.isNotEmpty ? imageUrl : null,
              ),
              child: TactileTap(
                onTap: () => context.push('/artist/${a['id']}'),
                scaleDown: 0.98,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.scrim.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child:
                              imageUrl.isNotEmpty
                                  ? PPImage(
                                    imageUrl: imageUrl,
                                    fit: BoxFit.cover,
                                  )
                                  : Container(
                                    color: colorScheme.surfaceContainerHighest,
                                    child: Icon(
                                      Icons.person,
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              a['name'] as String,
                              style: TextStyle(
                                color: colorScheme.onSurface,
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Artist'.toUpperCase(),
                              style: TextStyle(
                                color: colorScheme.primary.withValues(
                                  alpha: 0.8,
                                ),
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: colorScheme.onSurface.withValues(alpha: 0.24),
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            )
            .animate(delay: (100 + i % 10 * 40).ms)
            .fadeIn(duration: 500.ms)
            .slideX(begin: 0.05, end: 0, curve: Curves.easeOutCubic);
      },
    );
  }
}

class _AlbumResults extends StatelessWidget {
  const _AlbumResults(this.items);
  final List<dynamic> items;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    if (items.isEmpty) return const Center(child: Text('No albums found'));
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: BannerAdWidget(),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 180,
              childAspectRatio: 0.72,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            delegate: SliverChildBuilderDelegate((_, i) {
              final album = items[i] as Map<String, dynamic>;
              final images = (album['images'] as List?) ?? [];
              final imageUrl =
                  images.isNotEmpty ? images[0]['url'] as String : '';

              final artistName =
                  (album['artists'] as List?)?.firstOrNull?['name'] ?? '';
              return ContentContextMenuRegion(
                    target: AlbumContextTarget(
                      id: album['id'] as String,
                      name: album['name'] as String,
                      artistName: artistName,
                      imageUrl: imageUrl.isNotEmpty ? imageUrl : null,
                    ),
                    child: TactileTap(
                      onTap: () => context.push('/album/${album['id']}'),
                      scaleDown: 0.95,
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
                                    color: colorScheme.scrim.withValues(
                                      alpha: 0.5,
                                    ),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child:
                                    imageUrl.isNotEmpty
                                        ? PPImage(
                                          imageUrl: imageUrl,
                                          fit: BoxFit.cover,
                                        )
                                        : Container(
                                          color:
                                              colorScheme
                                                  .surfaceContainerHighest,
                                        ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            album['name'] as String,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: colorScheme.onSurface,
                              fontSize: 15,
                              letterSpacing: -0.4,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            artistName.toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: colorScheme.primary.withValues(alpha: 0.5),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .animate(delay: (100 + i % 10 * 50).ms)
                  .fadeIn(duration: 600.ms)
                  .slideY(
                    begin: 0.1,
                    duration: 600.ms,
                    curve: Curves.easeOutCubic,
                  );
            }, childCount: items.length),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }
}

class _PlaylistResults extends StatelessWidget {
  const _PlaylistResults(this.items);
  final List<dynamic> items;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    if (items.isEmpty) return const Center(child: Text('No playlists found'));
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: BannerAdWidget(),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 180,
              childAspectRatio: 0.72,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            delegate: SliverChildBuilderDelegate((_, i) {
              final playlist = items[i] as Map<String, dynamic>;
              final images = (playlist['images'] as List?) ?? [];
              final imageUrl =
                  images.isNotEmpty ? images[0]['url'] as String : '';
              final ownerName =
                  playlist['owner'] != null
                      ? playlist['owner']['display_name']
                      : '';

              return ContentContextMenuRegion(
                    target: PlaylistContextTarget(
                      id: playlist['id'] as String,
                      name: playlist['name'] as String,
                      imageUrl: imageUrl.isNotEmpty ? imageUrl : null,
                      ownerName: ownerName.isNotEmpty ? ownerName : null,
                    ),
                    child: TactileTap(
                      onTap: () {
                        final encodedName = Uri.encodeComponent(
                          playlist['name'] as String,
                        );
                        context.push(
                          '/playlist/remote/${playlist['id']}?name=$encodedName',
                        );
                      },
                      scaleDown: 0.95,
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
                                    color: colorScheme.scrim.withValues(
                                      alpha: 0.5,
                                    ),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child:
                                    imageUrl.isNotEmpty
                                        ? PPImage(
                                          imageUrl: imageUrl,
                                          fit: BoxFit.cover,
                                        )
                                        : Container(
                                          color:
                                              colorScheme
                                                  .surfaceContainerHighest,
                                        ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            playlist['name'] as String,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: colorScheme.onSurface,
                              fontSize: 15,
                              letterSpacing: -0.4,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            ownerName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .animate(delay: (100 + i % 10 * 50).ms)
                  .fadeIn(duration: 600.ms)
                  .slideY(
                    begin: 0.1,
                    duration: 600.ms,
                    curve: Curves.easeOutCubic,
                  );
            }, childCount: items.length),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }
}
