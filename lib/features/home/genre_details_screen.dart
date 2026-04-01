import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/api/spotify_client.dart';
import '../../core/player/player_provider.dart';
import '../../shared/widgets/track_tile.dart';
import '../../shared/widgets/tactile_buttons.dart';

final genreArtistsProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, genreName) async {
  final client = ref.watch(spotifyClientProvider);
  final data = await client.search('genre:"$genreName"', limit: 10);
  final items = (data['artists']?['items'] as List?) ?? [];
  return items.cast<Map<String, dynamic>>();
});

final genreTracksProvider = FutureProvider.family<List<Track>, String>((ref, genreName) async {
  final client = ref.watch(spotifyClientProvider);
  final data = await client.search('genre:"$genreName"', limit: 20);
  final items = (data['tracks']?['items'] as List?) ?? [];
  return items.map((j) => Track.fromSpotify(j as Map<String, dynamic>)).toList();
});

final genreAlbumsProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, genreName) async {
  final client = ref.watch(spotifyClientProvider);
  final data = await client.search('genre:"$genreName"', limit: 10);
  final items = (data['albums']?['items'] as List?) ?? [];
  return items.cast<Map<String, dynamic>>();
});

class GenreDetailsScreen extends ConsumerWidget {
  final String genreName;

  const GenreDetailsScreen({super.key, required this.genreName});

  Color _getGenreColor(String name) {
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
    // Simple hash based on name to pick a stable color
    final index = name.length % colors.length;
    return colors[index];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artistsAsync = ref.watch(genreArtistsProvider(genreName));
    final tracksAsync = ref.watch(genreTracksProvider(genreName));
    final albumsAsync = ref.watch(genreAlbumsProvider(genreName));
    final themeColor = _getGenreColor(genreName);

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            stretch: true,
            backgroundColor: Colors.black.withValues(alpha: 0.8),
            elevation: 0,
            leading: TactileIconButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onTap: () => context.pop(),
              color: Colors.white,
            ),
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
              ],
              title: LayoutBuilder(
                builder: (context, constraints) {
                  final isCollapsed =
                      constraints.maxHeight <= kToolbarHeight + 40;
                  return AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: 1.0,
                    child: Text(
                      genreName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: isCollapsed ? 18 : 32,
                        shadows: [
                          if (!isCollapsed)
                            const Shadow(color: Colors.black, blurRadius: 15),
                        ],
                      ),
                    ),
                  );
                },
              ),
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
                          themeColor.withValues(alpha: 0.5),
                          Colors.black,
                        ],
                        stops: const [0.0, 0.4, 1.0],
                      ),
                    ),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black54,
                          Colors.black,
                        ],
                        stops: [0.3, 0.7, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.black,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Popular from this genre',
                        style: TextStyle(color: Colors.white54, fontSize: 13),
                      ),
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
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildSectionHeader('Top Artists'),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          SliverToBoxAdapter(
            child: artistsAsync.when(
              data: (artists) => _ArtistList(artists: artists).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1),
              loading: () => const _LoadingPlaceholder(height: 160),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildSectionHeader('Popular Albums'),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          SliverToBoxAdapter(
            child: albumsAsync.when(
              data: (albums) => _AlbumList(albums: albums).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
              loading: () => const _LoadingPlaceholder(height: 200),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildSectionHeader('Popular Songs'),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 8)),
          tracksAsync.when(
            data: (tracks) => SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 8),
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
                              onTap: () => ref.read(playerProvider.notifier).playTrack(track, queue: tracks),
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: (300 + index * 40).ms).slideX(begin: 0.05);
                  },
                  childCount: tracks.length,
                ),
              ),
            ),
            loading: () => const SliverToBoxAdapter(child: _LoadingPlaceholder(height: 200)),
            error: (e, _) => SliverToBoxAdapter(child: Text('Error: $e')),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}

class _ArtistList extends StatelessWidget {
  final List<Map<String, dynamic>> artists;
  const _ArtistList({required this.artists});

  @override
  Widget build(BuildContext context) {
    if (artists.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: artists.length,
        itemBuilder: (context, index) {
          final artist = artists[index];
          final imageUrl = (artist['images'] as List?)?.firstOrNull?['url'] ?? '';
          return TactileTap(
            onTap: () => context.push('/artist/${artist['id']}'),
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
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    artist['name'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.white),
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

class _AlbumList extends StatelessWidget {
  final List<Map<String, dynamic>> albums;
  const _AlbumList({required this.albums});

  @override
  Widget build(BuildContext context) {
    if (albums.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: albums.length,
        itemBuilder: (context, index) {
          final album = albums[index];
          final imageUrl = (album['images'] as List?)?.firstOrNull?['url'] ?? '';
          return TactileTap(
            onTap: () => context.push('/album/${album['id']}'),
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
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    album['name'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                  ),
                  Text(
                    (album['artists'] as List?)?.firstOrNull?['name'] ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: Colors.white54),
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
