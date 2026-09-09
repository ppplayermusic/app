import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/api/spotify_repository.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../shared/widgets/pp_image.dart';
import '../../shared/widgets/playlist_cover.dart';

import '../../core/player/player_provider.dart';
import '../../shared/widgets/section_wrapper.dart';
import '../../shared/widgets/track_tile.dart';
import '../../shared/widgets/tactile_buttons.dart';
import '../../shared/widgets/context_menu/content_context_menu.dart';

import '../../core/providers/genre_providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/favorites_provider.dart';


final categoryColorProvider = Provider.family<Color, String>((ref, name) {
  final index = name.length % AppTheme.themeColors.length;
  return AppTheme.themeColors[index];
});

class GenreDetailsScreen extends ConsumerWidget {
  final String categoryId;
  final String categoryName;

  const GenreDetailsScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlistsAsync = ref.watch(categoryPlaylistsProvider(categoryId));
    final tracksAsync = ref.watch(categoryTopTracksProvider(categoryId));
    final colorScheme = Theme.of(context).colorScheme;
    final themeColor = ref.watch(categoryColorProvider(categoryName));

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            stretch: true,
            elevation: 0,
            backgroundColor: colorScheme.surface.withValues(alpha: 0.1),
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TactileIconButton(
                icon: Icons.arrow_back_ios_new_rounded,
                size: 18,
                onTap: () => context.pop(),
              ),
            ),
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                final topPadding = MediaQuery.of(context).padding.top;
                final isCollapsed =
                    constraints.maxHeight <= kToolbarHeight + topPadding + 10;

                return FlexibleSpaceBar(
                  stretchModes: const [
                    StretchMode.zoomBackground,
                    StretchMode.blurBackground,
                  ],
                  centerTitle: true,
                  expandedTitleScale: 1.0,
                  titlePadding: EdgeInsets.zero,
                  title: isCollapsed
                      ? ClipRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                            child: Container(
                              width: double.infinity,
                              height: kToolbarHeight + topPadding,
                              padding: EdgeInsets.only(top: topPadding),
                              color: colorScheme.surface.withValues(alpha: 0.7),
                              alignment: Alignment.center,
                              child: Text(
                                categoryName.toUpperCase(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                  letterSpacing: -0.5,
                                  color: colorScheme.onSurface,
                                ),
                              ).animate().fadeIn(duration: 200.ms),
                            ),
                          ),
                        )
                      : null,
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Base Background
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              themeColor,
                              themeColor.withValues(alpha: 0.6),
                              colorScheme.surface,
                            ],
                            stops: const [0.0, 0.4, 1.0],
                          ),
                        ),
                      ),
                      
                      // Cinematic Ambient Mesh Pulsing Overlay
                      Positioned.fill(
                        child: Opacity(
                          opacity: 0.6,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                center: const Alignment(-0.8, -0.6),
                                radius: 1.5,
                                colors: [
                                  themeColor.withValues(alpha: 0.8),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
                            begin: const Offset(1, 1),
                            end: const Offset(1.3, 1.3),
                            duration: 10.seconds,
                            curve: Curves.easeInOut,
                          ).move(
                            begin: const Offset(-20, -20),
                            end: const Offset(20, 20),
                            duration: 12.seconds,
                            curve: Curves.easeInOut,
                          ),
                        ),
                      ),

                      // Dark Gradient Overlay for readability
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              colorScheme.surface.withValues(alpha: 0.1),
                              Colors.transparent,
                              colorScheme.surface.withValues(alpha: 0.4),
                              colorScheme.surface.withValues(alpha: 0.9),
                            ],
                            stops: const [0.0, 0.4, 0.7, 1.0],
                          ),
                        ),
                      ),
                      
                      // Hero Title Container
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 48,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: isCollapsed ? 0.0 : 1.0,
                          child: Center(
                            child: Container(
                              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.85),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: themeColor.withValues(alpha: 0.2),
                                    blurRadius: 40,
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                                    decoration: BoxDecoration(
                                      color: colorScheme.scrim.withValues(alpha: 0.3),
                                      borderRadius: BorderRadius.circular(24),
                                      border: Border.all(
                                        color: colorScheme.onSurface.withValues(alpha: 0.15),
                                        width: 0.5,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'GENRE',
                                          style: TextStyle(
                                            color: colorScheme.onSurface.withValues(alpha: 0.5),
                                            fontSize: 10,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 4.0,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          categoryName,
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: colorScheme.onSurface,
                                            fontSize: 48,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: -2.5,
                                            height: 1.0,
                                          ),
                                        ),
                                      ],
                                    ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.95, 0.95)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
              child: Row(
                children: [
                  TactileActionPlayButton(
                    onTap: () {
                      final tracks = tracksAsync.asData?.value;
                      if (tracks != null && tracks.isNotEmpty) {
                        ref
                            .read(playerProvider.notifier)
                            .playTrack(tracks.first, queue: tracks);
                      }
                    },
                  ),
                  const SizedBox(width: 16),
                  Consumer(
                    builder: (context, ref, _) {
                      final isFavorite = ref.watch(favoritesStatusProvider((FavoriteType.radio, '$categoryId:genre'))).value ?? false;
                      // Get the first playlist's image as a representative icon if available
                      final playlists = playlistsAsync.asData?.value;
                      final iconUrl = (playlists != null && playlists.isNotEmpty && (playlists.first['images'] as List?)?.isNotEmpty == true) ? playlists.first['images'][0]['url'] as String? : null;

                      return TactileIconButton(
                        icon: isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        color: isFavorite ? colorScheme.primary : colorScheme.onSurface,
                        size: 28,
                        onTap: () {
                          ref.read(favoritesControllerProvider.notifier).toggleRadioFollow(
                            seedId: categoryId,
                            seedType: 'genre',
                            title: categoryName,
                            imageUrl: iconUrl,
                            isCurrentlyFollowed: isFavorite,
                          );
                        },
                      );
                    }
                  ),
                  const Spacer(),
                  TactileIconButton(
                    icon: Icons.more_horiz_rounded,
                    size: 28,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SectionWrapper<Map<String, dynamic>>(
              title: 'Featured Playlists',
              asyncValue: playlistsAsync,
              builder: (playlists) => _PlaylistList(playlists: playlists)
                  .animate()
                  .fadeIn(delay: 100.ms)
                  .slideY(begin: 0.1),
              loadingWidget: const SectionShimmer(height: 220),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          SliverToBoxAdapter(
            child: SectionWrapper<Track>(
              title: 'Popular Songs',
              asyncValue: tracksAsync,
              builder: (tracks) => Padding(
                padding: const EdgeInsets.only(bottom: 120),
                child: Column(
                  children: [
                    for (int index = 0; index < tracks.length; index++) ...[
                      TrackTile(
                        index: index + 1,
                        track: tracks[index],
                        onTap: () => ref
                            .read(playerProvider.notifier)
                            .playTrack(tracks[index], queue: tracks),
                      ).animate().fadeIn(delay: (200 + index * 40).ms).slideX(
                          begin: 0.05, end: 0, curve: Curves.easeOutCubic),
                    ],
                  ],
                ),
              ),
              loadingWidget: const SectionShimmer(
                isHorizontal: false,
                height: 72,
                count: 5,
              ),
            ),
          ),
        ],
      ),
    );
  }


}

class _PlaylistList extends StatelessWidget {
  final List<Map<String, dynamic>> playlists;
  const _PlaylistList({required this.playlists});

  @override
  Widget build(BuildContext context) {
    if (playlists.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 256,
      child: ListView.builder(
        clipBehavior: Clip.none,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: playlists.length,
        itemBuilder: (context, index) {
          return _GenrePlaylistCard(playlist: playlists[index]);
        },
      ),
    );
  }
}

class _GenrePlaylistCard extends ConsumerStatefulWidget {
  final Map<String, dynamic> playlist;
  const _GenrePlaylistCard({required this.playlist});

  @override
  ConsumerState<_GenrePlaylistCard> createState() => _GenrePlaylistCardState();
}

class _GenrePlaylistCardState extends ConsumerState<_GenrePlaylistCard> {
  bool _isHovered = false;

  void _onPlay() async {
    try {
      final cacheResult = await ref
          .read(spotifyRepositoryProvider)
          .watchPlaylistTracks(widget.playlist['id'])
          .first;
      final tracks = cacheResult.data;
      if (tracks.isNotEmpty) {
        ref.read(playerProvider.notifier).playTrack(tracks.first, queue: tracks);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final playlist = widget.playlist;
    final rawImages = (playlist['images'] as List?) ?? [];
    final images = rawImages.map((i) => i['url'] as String).toList();
    final imageUrl = images.firstOrNull ?? '';

    Widget imageWidget;
    if (images.length > 1) {
      imageWidget = PlaylistCover(
        images: images,
        size: double.infinity,
        borderRadius: 16,
      );
    } else {
      imageWidget = PPImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
      );
    }

    return ContentContextMenuRegion(
      target: PlaylistContextTarget(
        id: playlist['id'] as String,
        name: playlist['name'] ?? '',
        imageUrl: imageUrl.isNotEmpty ? imageUrl : null,
      ),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: TactileTap(
          onTap: () => context.push(
              '/playlist/remote/${playlist['id']}?name=${Uri.encodeComponent(playlist['name'] ?? '')}'),
          scaleDown: 0.96,
        child: AnimatedScale(
          scale: _isHovered ? 1.04 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          child: Container(
            width: 160,
            margin: const EdgeInsets.only(right: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOutCubic,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: _isHovered
                              ? colorScheme.primary.withValues(alpha: 0.35)
                              : colorScheme.scrim.withValues(alpha: 0.4),
                          blurRadius: _isHovered ? 26 : 15,
                          spreadRadius: _isHovered ? 2 : 0,
                          offset: Offset(0, _isHovered ? 12 : 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: HoverPlayOverlay(
                        onPlay: _onPlay,
                        isHovered: _isHovered,
                        size: 42,
                        child: imageWidget,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 150),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: _isHovered ? colorScheme.primary : colorScheme.onSurface,
                    letterSpacing: -0.3,
                  ),
                  child: Text(
                    playlist['name'] ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  (playlist['description'] ?? '').replaceAll(RegExp(r'<[^>]*>'), ''),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurface.withValues(alpha: 0.4),
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    );
  }
}



// _AlbumList removed as it's not used in current GenreDetails redesign

// _LoadingPlaceholder class removed as it is replaced by ShimmerPlaceholder
