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
                              color: Colors.black.withValues(alpha: 0.7),
                              alignment: Alignment.center,
                              child: Text(
                                categoryName.toUpperCase(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                  letterSpacing: -0.5,
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
                      // Base Background
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
                              Colors.black.withValues(alpha: 0.1),
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.4),
                              Colors.black.withValues(alpha: 0.9),
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
                                      color: Colors.black.withValues(alpha: 0.3),
                                      borderRadius: BorderRadius.circular(24),
                                      border: Border.all(
                                        color: Colors.white.withValues(alpha: 0.15),
                                        width: 0.5,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'GENRE',
                                          style: TextStyle(
                                            color: Colors.white.withValues(alpha: 0.5),
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
                                          style: const TextStyle(
                                            color: Colors.white,
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
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(child: _buildSectionHeader('Featured Playlists')),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
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
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(child: _buildSectionHeader('Popular Songs')),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
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

  Widget _buildSectionHeader(String title) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: Colors.white.withValues(alpha: 0.1), width: 0.5),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 3,
                height: 14,
                decoration: BoxDecoration(
                  color: const Color(0xFF1DB954),
                  borderRadius: BorderRadius.circular(1),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1DB954).withValues(alpha: 0.5),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title.toUpperCase(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 2.5,
                ),
              ),
            ],
          ),
        ),
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
            onTap: () => context.push('/spotify-playlist/${playlist['id']}?name=${Uri.encodeComponent(playlist['name'] ?? '')}'),
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
