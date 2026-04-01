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
            expandedHeight: 340,
            pinned: true,
            stretch: true,
            backgroundColor: Colors.black.withValues(alpha: 0.8),
            elevation: 0,
            leading: TactileIconButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onTap: () => context.pop(),
              color: Colors.white,
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
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.only(
                      bottom: isCollapsed ? 12 : 20,
                      left: 16,
                      right: 16,
                    ),
                    child: isCollapsed
                        ? ClipRRect(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Text(
                                _playlist!.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _playlist!.name,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(color: Colors.black45, blurRadius: 20),
                                  ],
                                ),
                              ),
                            ],
                          ),
                  );
                },
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  PlaylistCover(
                    images: _allTracks
                        .take(4)
                        .map((t) => t.albumImage)
                        .whereType<String>()
                        .toList(),
                    size: 380,
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


