import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import '../../core/db/app_database.dart' as db;
import '../../core/models/track.dart' as model;
import '../../shared/widgets/playlist_cover.dart';
import '../../shared/widgets/tactile_buttons.dart';
import '../../shared/widgets/premium_modals.dart';
import '../../core/player/player_provider.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
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
    final database = ref.watch(db.appDatabaseProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: _isSearching ? kToolbarHeight : 120,
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: _isSearching
                ? TextField(
                    controller: _searchController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Search playlists...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                    ),
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.toLowerCase();
                      });
                    },
                  )
                : null,
            leading: _isSearching
                ? TactileIconButton(
                    icon: Icons.arrow_back_ios_new,
                    size: 20,
                    onTap: () {
                      setState(() {
                        _isSearching = false;
                        _searchQuery = '';
                        _searchController.clear();
                      });
                    },
                  )
                : null,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.zero,
              title: LayoutBuilder(
                builder: (context, constraints) {
                  final isCollapsed = constraints.maxHeight <= kToolbarHeight + 40;
                  return Stack(
                    children: [
                      if (isCollapsed)
                        Positioned.fill(
                          child: ClipRect(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                              child: Container(
                                color: Colors.black.withValues(alpha: 0.5),
                              ),
                            ),
                          ),
                        ),
                      if (!_isSearching)
                        Container(
                          height: kToolbarHeight + 44,
                          alignment: Alignment.bottomLeft,
                          padding: const EdgeInsets.only(left: 16, bottom: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              if (!isCollapsed) ...[
                                Container(
                                  width: 34,
                                  height: 34,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white.withValues(alpha: 0.15), width: 1),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF450af5).withValues(alpha: 0.4),
                                        blurRadius: 15,
                                        spreadRadius: -2,
                                      ),
                                    ],
                                    image: const DecorationImage(
                                      image: AssetImage('assets/logo.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ).animate().fadeIn().scale(duration: 400.ms, curve: Curves.easeOutBack),
                                const SizedBox(width: 12),
                              ],
                              Text(
                                isCollapsed ? 'Library' : 'Your Library',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: isCollapsed ? 18 : 32,
                                  letterSpacing: isCollapsed ? -0.5 : -1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            actions: _isSearching
                ? [
                    if (_searchQuery.isNotEmpty)
                      TactileIconButton(
                        icon: Icons.clear,
                        onTap: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      ),
                  ]
                : [
                    TactileIconButton(
                      icon: Icons.add_rounded,
                      onTap: () => _showCreatePlaylistDialog(context, database),
                    ),
                    TactileIconButton(
                      icon: Icons.search_rounded,
                      onTap: () {
                        setState(() {
                          _isSearching = true;
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                  ],
          ),
          if (!_isSearching || _searchQuery.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _LikedSongsCard(database: database)
                        .animate()
                        .fadeIn(duration: 400.ms)
                        .slideY(begin: 0.1, end: 0),
                    const SizedBox(height: 32),
                    const Text(
                      'Playlists',
                      style: TextStyle(
                        fontSize: 20, 
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          _PlaylistsGrid(database: database, searchQuery: _searchQuery),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  void _showCreatePlaylistDialog(BuildContext context, db.AppDatabase database) {
    final ctrl = TextEditingController();
    showPremiumModal<void>(
      context: context,
      title: 'New Playlist',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: ctrl,
            autofocus: true,
            style: const TextStyle(color: Colors.white, fontSize: 18),
            decoration: InputDecoration(
              hintText: 'Name your masterpiece...',
              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.05),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: TactileTap(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 54,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: const Text('Cancel', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TactileTap(
                  onTap: () async {
                    if (ctrl.text.isNotEmpty) {
                      await database.createPlaylist(ctrl.text);
                      if (context.mounted) Navigator.pop(context);
                    }
                  },
                  child: Container(
                    height: 54,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF450af5), Color(0xFF2d0087)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text('Create', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LikedSongsCard extends StatelessWidget {
  const _LikedSongsCard({required this.database});
  final db.AppDatabase database;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<db.Track>>(
      future: database.getFavorites(),
      builder: (context, snap) {
        final count = snap.data?.length ?? 0;
        return TactileTap(
          onTap: () => context.push('/liked-songs'),
          child: Container(
            height: 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: const LinearGradient(
                colors: [Color(0xFF2d0087), Color(0xFF1a004d)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                // Mesh Blobs
                Positioned(
                  right: -40,
                  top: -40,
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF450af5).withValues(alpha: 0.4),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ).animate(onPlay: (c) => c.repeat(reverse: true))
                   .move(end: const Offset(20, 20), duration: 4.seconds),
                ),
                Positioned(
                  left: -20,
                  bottom: -20,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF9000ff).withValues(alpha: 0.2),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ).animate(onPlay: (c) => c.repeat(reverse: true))
                   .move(end: const Offset(-10, -10), duration: 3.seconds),
                ),
                // Decorative Heart Background
                // Background Visual Flair
                Positioned(
                  right: -30,
                  top: -20,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF450af5).withValues(alpha: 0.15),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
                      begin: const Offset(1, 1),
                      end: const Offset(1.3, 1.3),
                      duration: 5.seconds,
                      curve: Curves.easeInOut,
                    ),
                Positioned(
                  left: -20,
                  bottom: -30,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF2d0087).withValues(alpha: 0.1),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
                      begin: const Offset(1.2, 1.2),
                      end: const Offset(1, 1),
                      duration: 7.seconds,
                      curve: Curves.easeInOut,
                    ),
                // Content
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Container(
                        width: 92,
                        height: 92,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF450af5),
                              Color(0xFF2d0087),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF450af5).withValues(alpha: 0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Center(
                          child: const Icon(
                            Icons.favorite_rounded,
                            color: Colors.white,
                            size: 42,
                          )
                          .animate(onPlay: (c) => c.repeat(reverse: true))
                          .scale(
                            begin: const Offset(1, 1),
                            end: const Offset(1.15, 1.15),
                            duration: 1200.ms,
                            curve: Curves.easeInOut,
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Liked Songs',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -1.2),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                              ),
                              child: Text(
                                '$count TRACKS',
                                style: const TextStyle(
                                    color: Colors.white70, 
                                    fontSize: 10,
                                    letterSpacing: 1.2,
                                    fontWeight: FontWeight.w800),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Consumer(
                        builder: (context, ref, _) => TactileTap(
                          onTap: () async {
                            final tracks = await database.getFavorites();
                            if (tracks.isNotEmpty) {
                              final modelTracks = tracks.map(model.Track.fromDb).toList();
                              ref.read(playerProvider.notifier).playTracks(modelTracks);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.12),
                              border: Border.all(color: Colors.white10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 32),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PlaylistsGrid extends StatelessWidget {
  const _PlaylistsGrid({required this.database, this.searchQuery = ''});
  final db.AppDatabase database;
  final String searchQuery;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<db.Playlist>>(
      stream: database.select(database.playlists).watch(),
      builder: (context, snap) {
        var playlists = snap.data ?? [];
        if (searchQuery.isNotEmpty) {
          playlists = playlists.where((p) => p.name.toLowerCase().contains(searchQuery)).toList();
        }
        
        if (playlists.isEmpty) {
          return SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Text(searchQuery.isNotEmpty ? 'No playlists found.' : 'No playlists yet.',
                    style: const TextStyle(color: Color(0xFFB3B3B3))),
              ),
            ),
          );
        }
        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, i) {
                final playlist = playlists[i];
                return _PlaylistCard(database: database, playlist: playlist)
                    .animate(delay: (i * 60).ms)
                    .fadeIn(duration: 500.ms)
                    .slideY(begin: 0.15, end: 0, curve: Curves.easeOutQuart);
              },
              childCount: playlists.length,
            ),
          ),
        );
      },
    );
  }
}

class _PlaylistCard extends StatelessWidget {
  const _PlaylistCard({required this.database, required this.playlist});
  final db.AppDatabase database;
  final db.Playlist playlist;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<model.Track>>(
      future: database.getPlaylistTracks(playlist.id).then((list) => list.map(model.Track.fromDb).toList()),
      builder: (context, snap) {
        final tracks = snap.data ?? [];
        final images = tracks
            .map((t) => t.albumImage)
            .whereType<String>()
            .take(4)
            .toList();

        return TactileTap(
          onTap: () => context.push('/playlist/${playlist.id}'),
          onLongPress: () => _confirmDelete(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: PlaylistCover(images: images, size: double.infinity),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                playlist.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold, 
                  fontSize: 14,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${tracks.length} songs',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5), 
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context) {
    showPremiumModal<void>(
      context: context,
      title: 'Delete Playlist',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Are you sure you want to delete "${playlist.name}"?\nThis action cannot be undone.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.6), height: 1.5),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: TactileTap(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 54,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: const Text('Cancel', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TactileTap(
                  onTap: () {
                    database.deletePlaylist(playlist.id);
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 54,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3)),
                    ),
                    child: const Text('Delete', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
