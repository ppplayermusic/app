import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/api/spotify_client.dart';
import '../../core/player/player_provider.dart';
import '../../shared/widgets/track_tile.dart';
import '../../shared/widgets/tactile_buttons.dart';

final radioTracksProvider = FutureProvider.family<List<Track>, ({String type, String id})>((ref, arg) async {
  final client = ref.watch(spotifyClientProvider);
  return client.getRecommendations(
    seedArtistId: arg.type == 'artist' ? arg.id : null,
    seedTrackId: arg.type == 'track' ? arg.id : null,
    seedGenres: arg.type == 'genre' ? arg.id : null,
    limit: 50,
  );
});

class RadioDetailsScreen extends ConsumerWidget {
  final String seedType;
  final String seedId;
  final String title;
  final String imageUrl;
  final String? subtitle;
  final Color? color1;
  final Color? color2;

  const RadioDetailsScreen({
    super.key,
    required this.seedType,
    required this.seedId,
    required this.title,
    required this.imageUrl,
    this.subtitle,
    this.color1,
    this.color2,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracksAsync = ref.watch(radioTracksProvider((type: seedType, id: seedId)));

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            stretch: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TactileIconButton(
                icon: Icons.arrow_back_ios_new_rounded,
                size: 18,
                onTap: () => Navigator.of(context).pop(),
                color: Colors.white,
              ),
            ),
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                final isCollapsed = constraints.maxHeight <= kToolbarHeight + MediaQuery.of(context).padding.top + 10;
                return FlexibleSpaceBar(
                  stretchModes: const [
                    StretchMode.zoomBackground,
                    StretchMode.blurBackground,
                  ],
                  titlePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  title: isCollapsed 
                    ? const Text(
                        'Radio Station',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                          letterSpacing: -1.0,
                          color: Colors.white,
                        ),
                      )
                    : null,
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Base Image
                      CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(color: const Color(0xFF121212)),
                        errorWidget: (context, url, error) => Container(
                          color: const Color(0xFF1E1E1E),
                          child: const Icon(Icons.radio, size: 80, color: Colors.white10),
                        ),
                      ),

                      // Ambient Mesh Pulsing Overlay (Advanced Cinema)
                      Positioned.fill(
                        child: Opacity(
                          opacity: 0.6,
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: RadialGradient(
                                center: Alignment(-0.8, -0.6),
                                radius: 1.5,
                                colors: [
                                  Color(0xFF1DB954),
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

                      // Depth Overlay
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.2),
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.6),
                              Colors.black,
                            ],
                            stops: const [0.0, 0.3, 0.7, 1.0],
                          ),
                        ),
                      ),

                      // Large Title (Non-collapsed)
                      if (!isCollapsed)
                        Positioned(
                          left: 20,
                          right: 20,
                          bottom: 24,
                          child: Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 38,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -1.8,
                              height: 0.9,
                              shadows: [
                                Shadow(
                                  color: Colors.black45,
                                  blurRadius: 20,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                          ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0, curve: Curves.easeOutCubic),
                        ),
                    ],
                  ),
                );
              },
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
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1DB954).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: const Color(0xFF1DB954).withValues(alpha: 0.25),
                            width: 0.5,
                          ),
                        ),
                        child: const Text(
                          'RADIO STATION',
                          style: TextStyle(
                            color: Color(0xFF1DB954),
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Based on your taste',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.3),
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
                      color: Colors.white.withValues(alpha: 0.65),
                      fontSize: 15,
                      height: 1.5,
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.1,
                    ),
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          TactileIconButton(
                            icon: Icons.favorite_border_rounded,
                            size: 28,
                            color: Colors.white70,
                            padding: const EdgeInsets.all(12),
                            onTap: () {},
                          ),
                          const SizedBox(width: 4),
                          TactileIconButton(
                            icon: Icons.download_for_offline_outlined,
                            size: 28,
                            color: Colors.white70,
                            padding: const EdgeInsets.all(12),
                            onTap: () {},
                          ),
                          const SizedBox(width: 4),
                          TactileIconButton(
                            icon: Icons.shuffle_rounded,
                            size: 28,
                            color: Colors.white70,
                            padding: const EdgeInsets.all(12),
                            onTap: () => ref.read(playerProvider.notifier).toggleShuffle(),
                          ),
                        ],
                      ),
                      // Premium Action Button
                      TactileActionPlayButton(
                        size: 64,
                        onTap: () {
                          final tracks = tracksAsync.asData?.value;
                          if (tracks != null && tracks.isNotEmpty) {
                            ref.read(playerProvider.notifier).playTrack(tracks.first, queue: tracks);
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
            data: (tracks) => SliverPadding(
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
                                color: Colors.white.withValues(alpha: 0.2),
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
                      const Icon(Icons.error_outline, size: 48, color: Colors.white24),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading radio results.\nCheck your connection and try again.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white54),
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
}

class _RadioShimmerSliver extends StatelessWidget {
  const _RadioShimmerSliver();

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
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
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 150,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
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
            color: Colors.white.withValues(alpha: 0.05),
          ),
          childCount: 15,
        ),
      ),
    );
  }
}

