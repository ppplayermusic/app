import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  List<db.Track> _tracks = [];
  bool _loading = true;
  db.Playlist? _playlist;

  @override
  void initState() {
    super.initState();
    _loadData();
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
        _tracks = tracks;
        _loading = false;
      });
    }
  }

  void _onReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    setState(() {
      final item = _tracks.removeAt(oldIndex);
      _tracks.insert(newIndex, item);
    });

    // Persist to DB
    final database = ref.read(db.appDatabaseProvider);
    database.reorderTracks(
      widget.playlistId,
      _tracks.map((t) => t.spotifyId).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
          backgroundColor: Colors.black,
          body: Center(child: CircularProgressIndicator()));
    }

    if (_playlist == null) {
      return const Scaffold(
          backgroundColor: Colors.black,
          body: Center(child: Text('Playlist not found')));
    }

    final modelTracks = _tracks.map(model.Track.fromDb).toList();

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
                      _playlist!.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: isCollapsed ? 18 : 28,
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
                  PlaylistCover(
                    images: modelTracks
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
          if (_tracks.isEmpty)
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
                    ElevatedButton(
                      onPressed: () => context.go('/search'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1DB954),
                        foregroundColor: Colors.black,
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      child: const Text('Find Songs'),
                    ),
                  ],
                ),
              ),
            )
          else ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Playlist • ${_tracks.length} songs',
                      style:
                          const TextStyle(color: Colors.white54, fontSize: 13),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        TactileIconButton(
                          icon: Icons.favorite_border_rounded,
                          color: Colors.white54,
                          size: 24,
                          onTap: () {},
                        ),
                        const SizedBox(width: 8),
                        TactileIconButton(
                          icon: Icons.more_vert_rounded,
                          color: Colors.white54,
                          size: 24,
                          onTap: () {},
                        ),
                        const Spacer(),
                        TactileIconButton(
                          icon: Icons.shuffle_rounded,
                          color: Colors.white54,
                          size: 24,
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
                        const SizedBox(width: 12),
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
              ),
            ),
            SliverReorderableList(
              itemBuilder: (context, index) {
                final track = modelTracks[index];
                return ReorderableDelayedDragStartListener(
                  key: ValueKey(track.spotifyId),
                  index: index,
                  child: Padding(
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
                            onTap: () => ref.read(playerProvider.notifier).playTrack(
                                  track,
                                  queue: modelTracks,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
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

