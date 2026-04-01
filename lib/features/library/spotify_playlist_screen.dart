import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/api/spotify_client.dart';
import '../../core/player/player_provider.dart';
import '../../shared/widgets/track_tile.dart';
import '../../shared/widgets/tactile_buttons.dart';
import '../../core/db/app_database.dart' as db;

final spotifyPlaylistTracksProvider =
    FutureProvider.family<List<Track>, String>((ref, id) async {
  final client = ref.read(spotifyClientProvider);
  return client.getPlaylistTracks(id, limit: 50);
});

class SpotifyPlaylistScreen extends ConsumerStatefulWidget {
  final String playlistId;
  final String? playlistName;

  const SpotifyPlaylistScreen({
    super.key,
    required this.playlistId,
    this.playlistName,
  });

  @override
  ConsumerState<SpotifyPlaylistScreen> createState() =>
      _SpotifyPlaylistScreenState();
}

class _SpotifyPlaylistScreenState extends ConsumerState<SpotifyPlaylistScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final String _searchQuery = '';
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _checkLikedState();
  }

  Future<void> _checkLikedState() async {
    final database = ref.read(db.appDatabaseProvider);
    final playlist = await (database.select(database.playlists)
          ..where((p) => p.spotifyId.equals(widget.playlistId)))
        .getSingleOrNull();
    if (mounted) {
      setState(() {
        _isLiked = playlist != null;
      });
    }
  }

  Future<void> _toggleLike(List<Track> tracks) async {
    final database = ref.read(db.appDatabaseProvider);
    final newV = !_isLiked;
    setState(() => _isLiked = newV);
    
    await database.togglePlaylistLike(
      widget.playlistId,
      newV,
      name: widget.playlistName,
      imageUrl: tracks.isNotEmpty ? tracks.first.albumImage : null,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tracksAsync = ref.watch(spotifyPlaylistTracksProvider(widget.playlistId));

    return Scaffold(
      backgroundColor: Colors.black,
      body: tracksAsync.when(
        loading: () => const Center(
            child: CircularProgressIndicator(color: Color(0xFF1DB954))),
        error: (e, _) => Center(
            child: Text('Error: $e',
                style: const TextStyle(color: Colors.white54))),
        data: (tracks) {
          var filteredTracks = tracks;
          if (_searchQuery.isNotEmpty) {
            filteredTracks = tracks
                .where((t) =>
                    t.name.toLowerCase().contains(_searchQuery) ||
                    t.artistName.toLowerCase().contains(_searchQuery))
                .toList();
          }

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: 400,
                pinned: true,
                stretch: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: TactileIconButton(
                  icon: Icons.arrow_back_ios_new_rounded,
                  onTap: () => context.pop(),
                  color: Colors.white,
                  size: 20,
                ),
                actions: [
                  TactileIconButton(
                    icon: _isSearching ? Icons.close_rounded : Icons.search_rounded,
                    onTap: () {
                      setState(() {
                        _isSearching = !_isSearching;
                        if (!_isSearching) {
                          _searchController.clear();
                        }
                      });
                    },
                    color: Colors.white,
                  ),
                  TactileIconButton(
                    icon: Icons.more_vert_rounded,
                    onTap: () {},
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const [
                    StretchMode.zoomBackground,
                    StretchMode.blurBackground,
                  ],
                  titlePadding: EdgeInsets.zero,
                  centerTitle: true,
                  title: LayoutBuilder(
                    builder: (context, constraints) {
                      final isCollapsed =
                          constraints.maxHeight <= kToolbarHeight + 80;
                      
                      if (isCollapsed) {
                        return ClipRRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                            child: Container(
                              height: kToolbarHeight + 40,
                              alignment: Alignment.bottomCenter,
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Text(
                                widget.playlistName ?? 'Playlist',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 18,
                                  letterSpacing: -0.5,
                                  color: Colors.white,
                                ),
                              ).animate().fadeIn(duration: 200.ms),
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Base Background Color
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFF1DB954).withValues(alpha: 0.8),
                              const Color(0xFF1DB954).withValues(alpha: 0.4),
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

                      // Dark Overlay for readability
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.2),
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.5),
                              Colors.black,
                            ],
                            stops: const [0.0, 0.4, 0.7, 1.0],
                          ),
                        ),
                      ),

                      // Hero Content
                      Positioned(
                        left: 20,
                        right: 20,
                        bottom: 40,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Hero(
                              tag: 'playlist_art_${widget.playlistId}',
                              child: Container(
                                width: 180,
                                height: 180,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black54,
                                      blurRadius: 30,
                                      offset: Offset(0, 10),
                                    ),
                                    BoxShadow(
                                      color: Color(0x441DB954),
                                      blurRadius: 40,
                                      spreadRadius: -5,
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: tracks.isNotEmpty && tracks.first.albumImage != null
                                      ? Image.network(
                                          tracks.first.albumImage!,
                                          fit: BoxFit.cover,
                                        )
                                      : Container(
                                          color: Colors.white10,
                                          child: const Icon(Icons.playlist_play,
                                              size: 80, color: Colors.white24),
                                        ),
                                ),
                              ),
                            ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.9, 0.9)),
                            const SizedBox(height: 24),
                            const Text(
                              'SPOTIFY PLAYLIST',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2,
                              ),
                            ).animate().fadeIn(delay: 200.ms),
                            const SizedBox(height: 8),
                            Text(
                              widget.playlistName ?? 'Playlist',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 48,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -2,
                                height: 1,
                              ),
                            ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, end: 0),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!_isSearching) ...[
                        Text(
                          '${tracks.length} tracks',
                          style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.4),
                              fontSize: 13,
                              fontWeight: FontWeight.w400),
                        ).animate().fadeIn(duration: 400.ms),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                TactileTap(
                                  onTap: () => _toggleLike(tracks),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: _isLiked ? const Color(0xFF1DB954) : Colors.transparent,
                                      border: Border.all(
                                          color: _isLiked ? const Color(0xFF1DB954) : Colors.white30, width: 0.8),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(_isLiked ? 'Following' : 'Follow',
                                        style: TextStyle(
                                          color: _isLiked ? Colors.black : Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        )),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                TactileIconButton(
                                  icon: Icons.more_vert,
                                  color: Colors.white70,
                                  padding: const EdgeInsets.all(10),
                                  onTap: () {},
                                ),
                              ],
                            ),
                            TactileActionPlayButton(
                              size: 64,
                              onTap: () {
                                if (filteredTracks.isNotEmpty) {
                                  ref
                                      .read(playerProvider.notifier)
                                      .playTrack(filteredTracks.first,
                                          queue: filteredTracks);
                                }
                              },
                            ).animate().scale(
                                delay: 200.ms,
                                duration: 400.ms,
                                curve: Curves.easeOutBack),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                    ],
                  ),
                ),
              ),
              if (filteredTracks.isEmpty && _searchQuery.isNotEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off,
                            size: 48, color: Colors.white24),
                        const SizedBox(height: 16),
                        Text(
                          'No tracks found for "$_searchQuery"',
                          style: const TextStyle(color: Colors.white54),
                        ),
                      ],
                    ),
                  ),
                ),
              SliverPadding(
                padding: const EdgeInsets.only(bottom: 32),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final track = filteredTracks[index];
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
                                onTap: () => ref
                                    .read(playerProvider.notifier)
                                    .playTrack(
                                      track,
                                      queue: filteredTracks,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      )
                          .animate(delay: (index * 30).ms)
                          .fadeIn(duration: 400.ms)
                          .slideX(begin: 0.05, end: 0);
                    },
                    childCount: filteredTracks.length,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          );
        },
      ),
    );
  }
}
