import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/widgets/pp_image.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/api/spotify_client.dart';
import '../../core/player/player_provider.dart';
import '../../shared/widgets/track_tile.dart';
import '../../shared/widgets/tactile_buttons.dart';
import '../../core/services/favorites_provider.dart';

final radioTracksProvider = FutureProvider.family<List<Track>, ({String type, String id})>((ref, arg) async {
  final client = ref.watch(spotifyClientProvider);
  try {
    final tracks = await client.getRecommendations(
      seedArtistId: arg.type == 'artist' ? arg.id : null,
      seedTrackId: arg.type == 'track' ? arg.id : null,
      seedGenres: arg.type == 'genre' ? arg.id : null,
      limit: 50,
    );
    
    if (tracks.isNotEmpty) return tracks;
    
    // Fallback 1: Try a safe genre seed
    final fallbackTracks = await client.getRecommendations(
      seedGenres: 'pop',
      limit: 50,
    );
    
    if (fallbackTracks.isNotEmpty) return fallbackTracks;

    // Fallback 2: Ultimate fallback to popular tracks
    return client.getPopularTracks(limit: 50);
  } catch (e) {
    // If targeted recommendation fails, return popular tracks as ultimate fallback
    return client.getPopularTracks(limit: 50);
  }
});

class RadioDetailsScreen extends ConsumerWidget {
  final String seedType;
  final String seedId;
  final String title;
  final String imageUrl;
  final String? subtitle;
  final String? artistId;
  final String? artistName;
  final Color? color1;
  final Color? color2;

  const RadioDetailsScreen({
    super.key,
    required this.seedType,
    required this.seedId,
    required this.title,
    required this.imageUrl,
    this.subtitle,
    this.artistId,
    this.artistName,
    this.color1,
    this.color2,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracksAsync = ref.watch(radioTracksProvider((type: seedType, id: seedId)));
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            stretch: true,
            backgroundColor: colorScheme.surface.withValues(alpha: 0.1),
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TactileIconButton(
                icon: Icons.arrow_back_ios_new_rounded,
                size: 18,
                onTap: () => context.pop(),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TactileIconButton(
                  icon: Icons.more_vert_rounded,
                  onTap: () {},
                ),
              ),
            ],
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                final topPadding = MediaQuery.of(context).padding.top;
                final isCollapsed = constraints.maxHeight <= kToolbarHeight + topPadding + 10;
                
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
                              color: colorScheme.surface.withValues(alpha: 0.6),
                              alignment: Alignment.center,
                              child: Text(
                                title,
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 17,
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
                      PPImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                      ),
                      
                      // Ambient Mesh Pulsing Overlay
                      Positioned.fill(
                        child: Opacity(
                          opacity: 0.6,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                center: const Alignment(-0.8, -0.6),
                                radius: 1.5,
                                colors: [
                                  Theme.of(context).colorScheme.primary,
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

                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              colorScheme.surface.withValues(alpha: 0.2),
                              Colors.transparent,
                              colorScheme.surface.withValues(alpha: 0.4),
                              colorScheme.surface.withValues(alpha: 0.9),
                            ],
                            stops: const [0.0, 0.4, 0.7, 1.0],
                          ),
                        ),
                      ),

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
                                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                                        blurRadius: 40,
                                        spreadRadius: 0,
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(24),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                                        decoration: BoxDecoration(
                                          color: colorScheme.surface.withValues(alpha: 0.3),
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
                                              'RADIO',
                                              style: TextStyle(
                                                color: colorScheme.onSurface.withValues(alpha: 0.5),
                                                fontSize: 10,
                                                fontWeight: FontWeight.w900,
                                                letterSpacing: 4.0,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              title,
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: colorScheme.onSurface,
                                                fontSize: 48,
                                                fontWeight: FontWeight.w900,
                                                letterSpacing: -2.5,
                                                height: 1.0,
                                                shadows: [
                                                  Shadow(
                                                    color: colorScheme.shadow.withValues(alpha: 0.45),
                                                    blurRadius: 30,
                                                    offset: const Offset(0, 15),
                                                  ),
                                                ],
                                              ),
                                            ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.95, 0.95), curve: Curves.easeOutCubic),
                                          ],
                                        ),
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
            child: Container(
              padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                                width: 0.5,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.radio_rounded, color: Theme.of(context).colorScheme.primary, size: 12),
                                const SizedBox(width: 6),
                                Text(
                                  'RADIO STATION',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 2.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Based on your taste',
                        style: TextStyle(
                          color: colorScheme.onSurface.withValues(alpha: 0.3),
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic),
                  const SizedBox(height: 16),
                  Text(
                    subtitle ?? 'A curated mix featuring $title and other artists you like.',
                    style: TextStyle(
                      color: colorScheme.onSurface.withValues(alpha: 0.65),
                      fontSize: 15,
                      height: 1.5,
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.1,
                    ),
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad),
                  const SizedBox(height: 32),
                  _buildSectionHeader(context, 'CURATED TRACKS'),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const SizedBox(width: 4),
                          // Radio Follow Station Button
                          Consumer(
                            builder: (context, ref, child) {
                              final statusAsync = ref.watch(favoritesStatusProvider((FavoriteType.radio, "$seedId:$seedType")));
                              final isFollowed = statusAsync.value ?? false;
                              
                              return TactileIconButton(
                                icon: isFollowed ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                size: 28,
                                color: isFollowed ? Theme.of(context).colorScheme.primary : colorScheme.onSurfaceVariant,
                                padding: const EdgeInsets.all(12),
                                onTap: () {
                                  ref.read(favoritesControllerProvider.notifier).toggleRadioFollow(
                                    seedId: seedId,
                                    seedType: seedType,
                                    title: title,
                                    imageUrl: imageUrl,
                                    isCurrentlyFollowed: isFollowed,
                                  );
                                },
                              );
                            },
                          ),
                          const SizedBox(width: 4),
                          TactileIconButton(
                            icon: Icons.shuffle_rounded,
                            size: 28,
                            color: colorScheme.onSurfaceVariant,
                            padding: const EdgeInsets.all(12),
                            onTap: () {
                              final tracks = tracksAsync.asData?.value;
                              if (tracks != null && tracks.isNotEmpty) {
                                ref.read(playerProvider.notifier).shuffleAndPlay(tracks);
                              }
                            },
                          ),
                        ],
                      ),
                      // Premium Action Button
                      TactileActionPlayButton(
                        size: 64,
                        onTap: () {
                          final tracks = tracksAsync.asData?.value;
                          if (tracks != null && tracks.isNotEmpty) {
                            ref.read(playerProvider.notifier).playTracks(tracks);
                          }
                        },
                      ).animate().scale(delay: 300.ms, curve: Curves.easeOutBack, duration: 500.ms),
                    ],
                  ).animate(delay: 300.ms).fadeIn(),
                ],
              ),
            ),
          ),
          tracksAsync.when(
            data: (tracks) => tracks.isEmpty 
              ? SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.music_off_rounded, size: 64, color: colorScheme.onSurface.withValues(alpha: 0.1)),
                        const SizedBox(height: 16),
                        Text(
                          'No tracks found for this radio.',
                          style: TextStyle(
                            color: colorScheme.onSurface.withValues(alpha: 0.5),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try another station or check your connection.',
                          style: TextStyle(
                            color: colorScheme.onSurface.withValues(alpha: 0.3),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.only(bottom: 120),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final track = tracks[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 32,
                                child: Text(
                                  (index + 1).toString().padLeft(2, '0'),
                                  style: TextStyle(
                                    color: colorScheme.onSurface.withValues(alpha: 0.2),
                                    fontSize: 13,
                                    fontFamily: 'monospace',
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TrackTile(
                                  track: track,
                                  showMore: false,
                                  onTap: () => ref.read(playerProvider.notifier).playTrack(track, queue: tracks),
                                ),
                              ),
                            ],
                          ),
                        ).animate(delay: (200 + index * 40).ms).fadeIn(duration: 400.ms).slideX(begin: 0.05, end: 0, curve: Curves.easeOutCubic);
                      },
                      childCount: tracks.length,
                    ),
                  ),
                ),
            loading: () => const _RadioShimmerSliver(),
            error: (e, _) => SliverFillRemaining(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 48, color: colorScheme.onSurface.withValues(alpha: 0.24)),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading radio results.\nCheck your connection and try again.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1), width: 0.5),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 3,
                height: 14,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(1),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).colorScheme.onSurface,
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

class _RadioShimmerSliver extends StatelessWidget {
  const _RadioShimmerSliver();

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final colorScheme = Theme.of(context).colorScheme;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 14,
                    decoration: BoxDecoration(
                      color: colorScheme.onSurface.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: colorScheme.onSurface.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 14,
                          decoration: BoxDecoration(
                            color: colorScheme.onSurface.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 150,
                          height: 12,
                          decoration: BoxDecoration(
                            color: colorScheme.onSurface.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate(onPlay: (c) => c.repeat()).shimmer(
              duration: 1200.ms,
              color: colorScheme.onSurface.withValues(alpha: 0.05),
            );
          },
          childCount: 15,
        ),
      ),
    );
  }
}

