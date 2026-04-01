import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/api/spotify_client.dart';
import '../../core/player/player_provider.dart';
import '../../shared/widgets/track_tile.dart';
import '../../shared/widgets/tactile_buttons.dart';

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
                expandedHeight: _isSearching ? kToolbarHeight : 340,
                pinned: true,
                stretch: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                leading: _isSearching
                    ? TactileIconButton(
                        icon: Icons.arrow_back,
                        onTap: () {
                          setState(() {
                            _isSearching = false;
                            _searchQuery = '';
                            _searchController.clear();
                          });
                        },
                      )
                    : TactileIconButton(
                        icon: Icons.arrow_back_ios_new,
                        size: 20,
                        onTap: () => context.pop(),
                      ),
                title: _isSearching
                    ? TextField(
                        controller: _searchController,
                        autofocus: true,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                        cursorColor: const Color(0xFF1DB954),
                        decoration: InputDecoration(
                          hintText: 'Search in playlist...',
                          hintStyle: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5)),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value.toLowerCase();
                          });
                        },
                      )
                    : null,
                actions: [
                  if (!_isSearching)
                    TactileIconButton(
                      icon: Icons.search,
                      onTap: () {
                        setState(() {
                          _isSearching = true;
                        });
                      },
                    )
                  else if (_searchQuery.isNotEmpty)
                    TactileIconButton(
                      icon: Icons.clear,
                      onTap: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                    ),
                  const SizedBox(width: 8),
                ],
                flexibleSpace: _isSearching
                    ? ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                          child: Container(
                            color: Colors.black.withValues(alpha: 0.7),
                          ),
                        ),
                      )
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          final isCollapsed = constraints.maxHeight <=
                              kToolbarHeight +
                                  MediaQuery.of(context).padding.top +
                                  10;
                          return ClipRect(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: isCollapsed ? 15 : 0,
                                sigmaY: isCollapsed ? 15 : 0,
                              ),
                              child: FlexibleSpaceBar(
                                stretchModes: const [
                                  StretchMode.zoomBackground,
                                  StretchMode.blurBackground,
                                ],
                                titlePadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                title: AnimatedOpacity(
                                  duration: const Duration(milliseconds: 200),
                                  opacity: 1.0,
                                  child: Text(
                                    widget.playlistName ?? 'Playlist',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: isCollapsed ? 18 : 32,
                                      letterSpacing: -0.8,
                                      color: Colors.white,
                                      shadows: [
                                        if (!isCollapsed)
                                          const Shadow(
                                              color: Colors.black,
                                              blurRadius: 20,
                                              offset: Offset(0, 4)),
                                      ],
                                    ),
                                  ),
                                ),
                                background: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color(0xFF535353),
                                            Color(0xFF1DB954),
                                            Color(0xFF121212)
                                          ],
                                          stops: [0.0, 0.5, 1.0],
                                        ),
                                      ),
                                      child: const Center(
                                        child: Icon(Icons.playlist_play,
                                            size: 120, color: Colors.white12),
                                      ),
                                    ),
                                    // Modern Premium Gradient Overlay
                                    const DecoratedBox(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            Color(0x33000000),
                                            Color(0x99000000),
                                            Colors.black,
                                          ],
                                          stops: [0.0, 0.4, 0.7, 1.0],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
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
                                  onTap: () {},
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18, vertical: 8),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.white30, width: 0.8),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Text('Follow',
                                        style: TextStyle(
                                          color: Colors.white,
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
