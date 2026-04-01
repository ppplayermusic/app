import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/player/player_provider.dart';
import '../../shared/widgets/track_tile.dart';
import '../../shared/widgets/tactile_buttons.dart';

import '../../core/providers/genre_providers.dart';

final categoryColorProvider = Provider.family<Color, String>((ref, name) {
  final colors = [
    const Color(0xFFE8115B), // Pink
    const Color(0xFF148A08), // Green
    const Color(0xFFBC59FF), // Purple
    const Color(0xFF8D67AB), // Muted Purple
    const Color(0xFF503750), // Dark Purple
    const Color(0xFF777777), // Grey
    const Color(0xFFFF4632), // Red
    const Color(0xFF006450), // Dark Green
    const Color(0xFF27856A), // Teal
    const Color(0xFF1E3264), // Dark Blue
    const Color(0xFF477D95), // Muted Blue
    const Color(0xFF8C1932), // Maroon
    const Color(0xFFAF2896), // Magenta
    const Color(0xFFE13300), // Bright Orange
    const Color(0xFF509BF5), // Blue
    const Color(0xFF0D73EC), // Bright Blue
  ];
  final index = name.length % colors.length;
  return colors[index];
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
    final themeColor = ref.watch(categoryColorProvider(categoryName));

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            stretch: true,
            elevation: 0,
            backgroundColor: Colors.black.withValues(alpha: 0.1),
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
                              color: Colors.black.withValues(alpha: 0.6),
                              alignment: Alignment.center,
                              child: Text(
                                categoryName.toUpperCase(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 17,
                                  letterSpacing: 2.0,
                                  color: Colors.white,
                                ),
                              ).animate().fadeIn(duration: 200.ms),
                            ),
                          ),
                        )
                      : null,
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              themeColor,
                              themeColor.withValues(alpha: 0.6),
                              Colors.black,
                            ],
                            stops: const [0.0, 0.4, 1.0],
                          ),
                        ),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.1),
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.4),
                              Colors.black.withValues(alpha: 0.9),
                            ],
                            stops: const [0.0, 0.3, 0.7, 1.0],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        right: 20,
                        bottom: 40,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: isCollapsed ? 0.0 : 1.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                      color:
                                          Colors.white.withValues(alpha: 0.2)),
                                ),
                                child: const Text(
                                  'GENRE',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                categoryName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 72,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -4.0,
                                  height: 0.8,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black45,
                                      blurRadius: 40,
                                      offset: Offset(0, 20),
                                    ),
                                  ],
                                ),
                              ).animate().fadeIn(duration: 600.ms).slideY(
                                  begin: 0.1,
                                  end: 0,
                                  curve: Curves.easeOutCubic),
                            ],
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
                  TactileIconButton(
                    icon: Icons.favorite_border_rounded,
                    size: 28,
                    onTap: () {},
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
          _buildSliverSectionHeader('Featured Playlists'),
          SliverToBoxAdapter(
            child: playlistsAsync.when(
              data: (playlists) => _PlaylistList(playlists: playlists)
                  .animate()
                  .fadeIn(delay: 100.ms)
                  .slideY(begin: 0.1),
              loading: () => const _LoadingPlaceholder(height: 220),
              error: (e, _) => Center(
                  child: Text('Error: $e',
                      style: const TextStyle(color: Colors.white54))),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
          _buildSliverSectionHeader('Popular Songs'),
          tracksAsync.when(
            data: (tracks) => SliverPadding(
              padding: const EdgeInsets.only(top: 8, bottom: 120),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final track = tracks[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 2),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 32,
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.4),
                                fontSize: 13,
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Expanded(
                            child: TrackTile(
                              track: track,
                              onTap: () => ref
                                  .read(playerProvider.notifier)
                                  .playTrack(track, queue: tracks),
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: (200 + index * 40).ms).slideX(
                        begin: 0.05, end: 0, curve: Curves.easeOutCubic);
                  },
                  childCount: tracks.length,
                ),
              ),
            ),
            loading: () => const SliverToBoxAdapter(
                child: _LoadingPlaceholder(height: 200)),
            error: (e, _) => SliverToBoxAdapter(
                child: Center(
                    child: Text('Error: $e',
                        style: const TextStyle(color: Colors.white54)))),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverSectionHeader(String title) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.03),
                border: Border.symmetric(
                  horizontal: BorderSide(
                    color: Colors.white.withValues(alpha: 0.05),
                    width: 0.5,
                  ),
                ),
              ),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
            ),
          ),
        ).animate().fadeIn(duration: 400.ms),
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
      height: 220,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: playlists.length,
        itemBuilder: (context, index) {
          final playlist = playlists[index];
          final imageUrl =
              ((playlist['images'] as List?)?.firstOrNull?['url'] as String?) ??
                  '';
          return TactileTap(
            onTap: () => context.push('/playlist/${playlist['id']}'),
            scaleDown: 0.95,
            child: Container(
              width: 160,
              margin: const EdgeInsets.only(right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.4),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              Container(color: Colors.white10),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.white10,
                            child: const Icon(Icons.music_note,
                                color: Colors.white24),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    playlist['name'] ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      color: Colors.white,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    playlist['description'] ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.4),
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}



// _AlbumList removed as it's not used in current GenreDetails redesign

class _LoadingPlaceholder extends StatelessWidget {
  final double height;
  const _LoadingPlaceholder({required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}
