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
  String _searchQuery = '';
  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  Future<void> _toggleLike(List<Track> tracks, bool currentIsLiked) async {
    final database = ref.read(db.appDatabaseProvider);
    final newV = !currentIsLiked;
    
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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: tracksAsync.when(
        loading: () => Center(
            child: CircularProgressIndicator(color: colorScheme.primary)),
        error: (e, _) => Center(
            child: Text('Error: $e',
                style: TextStyle(color: colorScheme.onSurfaceVariant))),
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
                  color: colorScheme.onSurface,
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
                    color: colorScheme.onSurface,
                  ),
                  TactileIconButton(
                    icon: Icons.more_vert_rounded,
                    onTap: () {},
                    color: colorScheme.onSurface,
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
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 18,
                                    letterSpacing: -0.5,
                                    color: colorScheme.onSurface,
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
                              colorScheme.primary.withValues(alpha: 0.8),
                              colorScheme.primary.withValues(alpha: 0.4),
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
                                  colorScheme.primary,
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
                              colorScheme.surface.withValues(alpha: 0.2),
                              Colors.transparent,
                              colorScheme.surface.withValues(alpha: 0.5),
                              colorScheme.surface,
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
                                  boxShadow: [
                                    BoxShadow(
                                      color: colorScheme.shadow.withValues(alpha: 0.3),
                                      blurRadius: 30,
                                      offset: const Offset(0, 10),
                                    ),
                                    BoxShadow(
                                      color: colorScheme.primary.withValues(alpha: 0.2),
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
                                          color: colorScheme.surfaceContainer,
                                          child: Icon(Icons.playlist_play,
                                              size: 80, color: colorScheme.onSurfaceVariant.withValues(alpha: 0.2)),
                                        ),
                                ),
                              ),
                            ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.9, 0.9)),
                            const SizedBox(height: 24),
                            Text(
                              'SPOTIFY PLAYLIST',
                              style: TextStyle(
                                color: colorScheme.onSurfaceVariant,
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2,
                              ),
                            ).animate().fadeIn(delay: 200.ms),
                            const SizedBox(height: 8),
                            Text(
                              widget.playlistName ?? 'Playlist',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: colorScheme.onSurface,
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
                                color: colorScheme.onSurfaceVariant,
                                fontSize: 13,
                                fontWeight: FontWeight.w400),
                          ).animate().fadeIn(duration: 400.ms),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                             Row(
                               children: [
                                 StreamBuilder<bool>(
                                   stream: ref.read(db.appDatabaseProvider).watchPlaylistIsFavorite(widget.playlistId),
                                   builder: (context, snap) {
                                     final isLiked = snap.data ?? false;
                                     return TactileTap(
                                       onTap: () => _toggleLike(tracks, isLiked),
                                       child: Container(
                                         padding: const EdgeInsets.symmetric(
                                             horizontal: 18, vertical: 8),
                                         decoration: BoxDecoration(
                                           color: isLiked ? colorScheme.primary : Colors.transparent,
                                           border: Border.all(
                                               color: isLiked ? colorScheme.primary : colorScheme.onSurfaceVariant.withValues(alpha: 0.3), width: 0.8),
                                           borderRadius: BorderRadius.circular(20),
                                         ),
                                         child: Text(isLiked ? 'Following' : 'Follow',
                                             style: TextStyle(
                                               color: isLiked ? colorScheme.onPrimary : colorScheme.onSurface,
                                               fontWeight: FontWeight.bold,
                                               fontSize: 13,
                                             )),
                                       ),
                                     );
                                   }
                                 ),
                                 const SizedBox(width: 8),
                                TactileIconButton(
                                  icon: Icons.more_vert,
                                  color: colorScheme.onSurfaceVariant,
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
                        Icon(Icons.search_off,
                            size: 48, color: colorScheme.onSurfaceVariant.withValues(alpha: 0.2)),
                        const SizedBox(height: 16),
                        Text(
                          'No tracks found for "$_searchQuery"',
                          style: TextStyle(color: colorScheme.onSurfaceVariant),
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
                                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
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
