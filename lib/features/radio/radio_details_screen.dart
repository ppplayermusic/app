import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
  final Color? color1;
  final Color? color2;

  const RadioDetailsScreen({
    super.key,
    required this.seedType,
    required this.seedId,
    required this.title,
    required this.imageUrl,
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
            expandedHeight: 340,
            pinned: true,
            stretch: true,
            backgroundColor: Colors.black,
            elevation: 0,
            leading: TactileIconButton(
              icon: Icons.arrow_back_ios_new,
              size: 20,
              onTap: () => Navigator.of(context).pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
              ],
              titlePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              title: LayoutBuilder(
                builder: (context, constraints) {
                  final isCollapsed =
                      constraints.maxHeight <= kToolbarHeight + 40;
                  return AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: 1.0,
                    child: Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: isCollapsed ? 18 : 32,
                        letterSpacing: -0.5,
                        shadows: [
                          if (!isCollapsed)
                            const Shadow(
                                color: Colors.black,
                                blurRadius: 20,
                                offset: Offset(0, 4)),
                        ],
                      ),
                    ),
                  );
                },
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(color: const Color(0xFF121212)),
                    errorWidget: (context, url, error) => Container(
                      color: const Color(0xFF1E1E1E),
                      child: const Icon(Icons.radio, size: 80, color: Colors.white10),
                    ),
                  ),
                  // Modern Gradient Overlay
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          color1?.withValues(alpha: 0.6) ?? Colors.transparent,
                          color2?.withValues(alpha: 0.8) ?? const Color(0x33000000),
                          const Color(0x99000000),
                          Colors.black,
                        ],
                        stops: const [0.0, 0.4, 0.7, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TactileIconButton(
                icon: Icons.more_vert,
                onTap: () {},
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
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1DB954).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: const Color(0xFF1DB954).withValues(alpha: 0.3),
                            width: 0.5,
                          ),
                        ),
                        child: const Text(
                          'RADIO STATION',
                          style: TextStyle(
                            color: Color(0xFF1DB954),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Made for you',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.4),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Recommendations based on $title and other artists you like.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 14,
                      height: 1.5,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          TactileIconButton(
                            icon: Icons.favorite_border,
                            size: 28,
                            color: Colors.white70,
                            padding: const EdgeInsets.all(10),
                            onTap: () {},
                          ),
                          TactileIconButton(
                            icon: Icons.download_for_offline_outlined,
                            size: 28,
                            color: Colors.white70,
                            padding: const EdgeInsets.all(10),
                            onTap: () {},
                          ),
                          TactileIconButton(
                            icon: Icons.shuffle,
                            size: 28,
                            color: Colors.white70,
                            padding: const EdgeInsets.all(10),
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
                      ),
                    ],
                  ),
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
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 32,
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.5),
                                fontSize: 14,
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Expanded(
                            child: TrackTile(
                              track: track,
                              onTap: () => ref.read(playerProvider.notifier).playTrack(track, queue: tracks),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  childCount: tracks.length,
                ),
              ),
            ),
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator(color: Color(0xFF1DB954))),
            ),
            error: (e, _) => SliverFillRemaining(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Center(
                  child: Text(
                    'Error loading radio results.\nCheck your connection and try again.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white54),
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
