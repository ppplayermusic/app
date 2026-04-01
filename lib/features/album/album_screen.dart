import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/api/spotify_client.dart';
import '../../core/player/player_provider.dart';
import '../../shared/widgets/track_tile.dart';
import '../../shared/widgets/tactile_buttons.dart';

final _albumProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, id) {
  return ref.read(spotifyClientProvider).getAlbum(id);
});

class AlbumScreen extends ConsumerStatefulWidget {
  const AlbumScreen({super.key, required this.albumId});
  final String albumId;

  @override
  ConsumerState<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends ConsumerState<AlbumScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final albumAsync = ref.watch(_albumProvider(widget.albumId));

    return Scaffold(
      backgroundColor: Colors.black,
      body: albumAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF1DB954))),
        error: (e, _) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.white54))),
        data: (album) {
          final images = (album['images'] as List?) ?? [];
          final imageUrl =
              images.isNotEmpty ? images[0]['url'] as String : null;
          final rawTracks = (album['tracks']?['items'] as List?) ?? [];
          final tracks = rawTracks.map((j) {
            final map = Map<String, dynamic>.from(j as Map<String, dynamic>);
            map['album'] = {
              'id': album['id'],
              'name': album['name'],
              'images': images,
            };
            return Track.fromSpotify(map);
          }).toList();

          final artistName =
              (album['artists'] as List).firstOrNull?['name'] ?? '';
          final artistId = (album['artists'] as List).firstOrNull?['id'];
          final albumName = album['name'] as String;
          var filteredTracks = tracks;
          if (_searchQuery.isNotEmpty) {
            filteredTracks = tracks.where((t) {
              return t.name.toLowerCase().contains(_searchQuery) ||
                  t.artistName.toLowerCase().contains(_searchQuery);
            }).toList();
          }

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: _isSearching ? kToolbarHeight + MediaQuery.of(context).padding.top : 420,
                pinned: true,
                stretch: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _isSearching
                      ? TactileIconButton(
                          icon: Icons.arrow_back_rounded,
                          onTap: () {
                            setState(() {
                              _isSearching = false;
                              _searchQuery = '';
                              _searchController.clear();
                            });
                          },
                        )
                      : TactileIconButton(
                          icon: Icons.arrow_back_ios_new_rounded,
                          size: 18,
                          onTap: () => context.pop(),
                        ),
                ),
                title: _isSearching
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            height: 42,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.1),
                                width: 0.5,
                              ),
                            ),
                            child: TextField(
                              controller: _searchController,
                              autofocus: true,
                              decoration: InputDecoration(
                                hintText: 'Search in album...',
                                prefixIcon: Icon(Icons.search_rounded, color: Colors.white.withValues(alpha: 0.3), size: 20),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                                hintStyle: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  fontSize: 14,
                                ),
                              ),
                              style: const TextStyle(color: Colors.white, fontSize: 14),
                              onChanged: (value) {
                                setState(() {
                                  _searchQuery = value.toLowerCase();
                                });
                              },
                            ),
                          ),
                        ),
                      ).animate().fadeIn(duration: 300.ms).scale(begin: const Offset(0.95, 0.95))
                    : null,
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: !_isSearching
                        ? TactileIconButton(
                            icon: Icons.search_rounded,
                            onTap: () {
                              setState(() {
                                _isSearching = true;
                              });
                            },
                          )
                        : _searchQuery.isNotEmpty
                            ? TactileIconButton(
                                icon: Icons.clear_rounded,
                                onTap: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = '';
                                  });
                                },
                              )
                            : const SizedBox(width: 40),
                  ),
                  const SizedBox(width: 4),
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
                      titlePadding: EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: isCollapsed ? 14 : 20,
                      ),
                      title: _isSearching
                          ? null
                          : AnimatedContainer(
                              duration: 200.ms,
                              child: Text(
                                albumName,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: isCollapsed ? 18 : 28,
                                  letterSpacing: isCollapsed ? 0 : -1.0,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withValues(alpha: 0.5),
                                      blurRadius: 10,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      background: _isSearching ? null : Stack(
                        fit: StackFit.expand,
                        children: [
                          if (imageUrl != null)
                            CachedNetworkImage(
                              imageUrl: imageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              placeholder: (context, url) =>
                                  Container(color: const Color(0xFF121212)),
                            )
                          else
                            Container(color: const Color(0xFF121212)),
                          
                          // Cinematic Ambient Overlays
                          Positioned.fill(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.black.withValues(alpha: 0.4),
                                    Colors.transparent,
                                    Colors.black.withValues(alpha: 0.8),
                                    Colors.black,
                                  ],
                                  stops: const [0.0, 0.4, 0.8, 1.0],
                                ),
                              ),
                            ),
                          ),
                          
                          // Animated Inner Glow for depth
                          if (!isCollapsed)
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              height: 200,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: RadialGradient(
                                    center: Alignment.bottomCenter,
                                    radius: 1.2,
                                    colors: [
                                      const Color(0xFF1DB954).withValues(alpha: 0.15),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ).animate(onPlay: (controller) => controller.repeat(reverse: true))
                             .fadeIn(duration: 2.seconds, curve: Curves.easeInOut),

                          // Header Glassmorphic Panel when collapsed
                          if (isCollapsed)
                            Positioned.fill(
                              child: ClipRect(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                                  child: Container(
                                    color: Colors.black.withValues(alpha: 0.4),
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
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      TactileTap(
                        onTap: () {
                          if (artistId != null) {
                            context.push('/artist/$artistId');
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.03),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const CircleAvatar(
                                radius: 10,
                                backgroundColor: Colors.white10,
                                child: Icon(Icons.person, size: 12, color: Colors.white70),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                artistName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(Icons.arrow_forward_ios_rounded, size: 10, color: Colors.white.withValues(alpha: 0.3)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Text(
                          'Album • ${album['release_date']?.toString().substring(0, 4) ?? ''}',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.4),
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          TactileIconButton(
                            icon: Icons.favorite_border_rounded,
                            color: Colors.white70,
                            padding: const EdgeInsets.all(12),
                            onTap: () {},
                          ),
                          TactileIconButton(
                            icon: Icons.download_for_offline_outlined,
                            color: Colors.white70,
                            padding: const EdgeInsets.all(12),
                            onTap: () {},
                          ),
                          TactileIconButton(
                            icon: Icons.more_vert_rounded,
                            color: Colors.white70,
                            padding: const EdgeInsets.all(12),
                            onTap: () {},
                          ),
                          const Spacer(),
                          TactileIconButton(
                            icon: Icons.shuffle_rounded,
                            color: Colors.white70,
                            size: 26,
                            padding: const EdgeInsets.all(12),
                            onTap: tracks.isNotEmpty
                                ? () {
                                    final shuffled = [...tracks]..shuffle();
                                    ref.read(playerProvider.notifier).playTrack(shuffled[0], queue: shuffled);
                                  }
                                : null,
                          ),
                          const SizedBox(width: 12),
                          TactileActionPlayButton(
                            size: 68,
                            onTap: tracks.isNotEmpty
                                ? () => ref.read(playerProvider.notifier).playTrack(tracks[0], queue: tracks)
                                : null,
                          ),
                        ],
                      ).animate().fadeIn(duration: 600.ms, delay: 200.ms).slideY(begin: 0.1, end: 0),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
              if (filteredTracks.isEmpty && _searchQuery.isNotEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off_rounded, size: 48, color: Colors.white.withValues(alpha: 0.1)),
                        const SizedBox(height: 16),
                        Text(
                          'No tracks found matching "$_searchQuery"',
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
                        ),
                      ],
                    ),
                  ),
                ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, i) {
                      final track = filteredTracks[i];
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.03),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.05),
                                width: 0.5,
                              ),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white.withValues(alpha: 0.05),
                                  Colors.white.withValues(alpha: 0.01),
                                ],
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 28,
                                    child: Text(
                                      '${i + 1}',
                                      style: TextStyle(
                                        color: Colors.white.withValues(alpha: 0.2),
                                        fontSize: 12,
                                        fontFamily: 'monospace',
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: TrackTile(
                                      track: track,
                                      showImage: false,
                                      onTap: () => ref
                                          .read(playerProvider.notifier)
                                          .playTrack(track, queue: filteredTracks),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                          .animate(delay: (300 + 40 * i).ms)
                          .fadeIn(duration: 500.ms)
                          .slideY(begin: 0.1, end: 0, curve: Curves.easeOutBack);
                    },
                    childCount: filteredTracks.length,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${album['release_date']} • ${tracks.length} songs',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.3),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (album['copyrights'] != null)
                        ... (album['copyrights'] as List).map((c) => Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            c['text'] as String,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.15),
                              fontSize: 11,
                              height: 1.4,
                            ),
                          ),
                        )),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

