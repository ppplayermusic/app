import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/db/app_database.dart' as db;
import '../../core/models/track.dart' as model;
import '../../core/player/player_provider.dart';
import '../../shared/widgets/track_tile.dart';
import '../../shared/widgets/playlist_cover.dart';
import '../../shared/widgets/tactile_buttons.dart';

class PlaylistDetailScreen extends ConsumerStatefulWidget {
  const PlaylistDetailScreen({super.key, required this.playlistId});
  final int playlistId;

  @override
  ConsumerState<PlaylistDetailScreen> createState() =>
      _PlaylistDetailScreenState();
}

class _PlaylistDetailScreenState extends ConsumerState<PlaylistDetailScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<db.Track> _allTracks = [];
  List<db.Track> _filteredTracks = [];
  bool _loading = true;
  db.Playlist? _playlist;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final database = ref.read(db.appDatabaseProvider);
    final playlist = await (database.select(database.playlists)
          ..where((p) => p.id.equals(widget.playlistId)))
        .getSingleOrNull();
    final tracks = await database.getPlaylistTracks(widget.playlistId);

    if (mounted) {
      setState(() {
        _playlist = playlist;
        _allTracks = tracks;
        _filteredTracks = tracks;
        _loading = false;
      });
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredTracks = _allTracks;
      } else {
        _filteredTracks = _allTracks.where((track) {
          final titleMatch = track.name.toLowerCase().contains(query);
          final artistMatch =
              track.artistName.toLowerCase().contains(query);
          return titleMatch || artistMatch;
        }).toList();
      }
    });
  }

  void _onReorder(int oldIndex, int newIndex) {
    if (_isSearching || _searchController.text.isNotEmpty) return;

    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    setState(() {
      final item = _allTracks.removeAt(oldIndex);
      _allTracks.insert(newIndex, item);
      _filteredTracks = _allTracks;
    });

    // Persist to DB
    final database = ref.read(db.appDatabaseProvider);
    database.reorderTracks(
      widget.playlistId,
      _allTracks.map((t) => t.spotifyId).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_playlist == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: Text('Playlist not found')),
      );
    }

    final modelTracks = _filteredTracks.map(model.Track.fromDb).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
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
                            _playlist!.name,
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
                  // Base Background Color (Derived from first track art or default)
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF509BF5).withValues(alpha: 0.8),
                          const Color(0xFF509BF5).withValues(alpha: 0.4),
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
                              Color(0xFF509BF5),
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
                          tag: 'playlist_art_${_playlist!.id}',
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
                                  color: Color(0x44509BF5),
                                  blurRadius: 40,
                                  spreadRadius: -5,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: PlaylistCover(
                                images: _allTracks
                                    .take(4)
                                    .map((t) => t.albumImage)
                                    .whereType<String>()
                                    .toList(),
                                size: 180,
                              ),
                            ),
                          ),
                        ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.9, 0.9)),
                        const SizedBox(height: 24),
                        const Text(
                          'PLAYLIST',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                          ),
                        ).animate().fadeIn(delay: 200.ms),
                        const SizedBox(height: 8),
                        Text(
                          _playlist!.name,
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
          if (_isSearching)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search in playlist',
                    hintStyle: const TextStyle(color: Colors.white38),
                    prefixIcon:
                        const Icon(Icons.search_rounded, color: Colors.white38),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ).animate().fadeIn().slideY(begin: -0.1),
            ),
          if (_allTracks.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.playlist_add,
                        color: Colors.white24, size: 80),
                    const SizedBox(height: 16),
                    const Text('No tracks in this playlist yet.',
                        style: TextStyle(color: Colors.white54)),
                    const SizedBox(height: 24),
                    TactileTap(
                      onTap: () => context.go('/search'),
                      hapticType: HapticFeedbackType.medium,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1DB954),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Find Songs',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Playlist • ${_allTracks.length} songs',
                      style:
                          const TextStyle(color: Colors.white54, fontSize: 13),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        TactileIconButton(
                          icon: Icons.favorite_border_rounded,
                          color: Colors.white54,
                          size: 28,
                          onTap: () {},
                        ),
                        const SizedBox(width: 8),
                        TactileIconButton(
                          icon: Icons.download_for_offline_outlined,
                          color: Colors.white54,
                          size: 28,
                          onTap: () {},
                        ),
                        const SizedBox(width: 8),
                        TactileIconButton(
                          icon: Icons.more_vert_rounded,
                          color: Colors.white54,
                          size: 28,
                          onTap: () {},
                        ),
                        const Spacer(),
                        TactileIconButton(
                          icon: Icons.shuffle_rounded,
                          color: Colors.white54,
                          size: 32,
                          onTap: () {
                            final shuffled =
                                List<model.Track>.from(modelTracks)..shuffle();
                            if (shuffled.isNotEmpty) {
                              ref.read(playerProvider.notifier).playTrack(
                                    shuffled.first,
                                    queue: shuffled,
                                  );
                            }
                          },
                        ),
                        const SizedBox(width: 16),
                        TactileActionPlayButton(
                          size: 56,
                          onTap: () {
                            if (modelTracks.isNotEmpty) {
                              ref.read(playerProvider.notifier).playTrack(
                                    modelTracks.first,
                                    queue: modelTracks,
                                  );
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1),
            ),
            SliverReorderableList(
              itemBuilder: (context, index) {
                final track = modelTracks[index];
                return ReorderableDelayedDragStartListener(
                  key: ValueKey(track.spotifyId),
                  index: index,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 24,
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.3),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TrackTile(
                            track: track,
                            onTap: () =>
                                ref.read(playerProvider.notifier).playTrack(
                                      track,
                                      queue: modelTracks,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: (index * 30).ms).slideX(begin: 0.05),
                );
              },
              itemCount: modelTracks.length,
              onReorder: _onReorder,
            ),
          ],
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }
}


