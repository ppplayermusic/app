import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/db/app_database.dart' as db;
import '../../core/models/track.dart' as model;
import '../../shared/widgets/playlist_cover.dart';

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
                ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      setState(() {
                        _isSearching = false;
                        _searchQuery = '';
                        _searchController.clear();
                      });
                    },
                  )
                : null,
            flexibleSpace: _isSearching
                ? null
                : const FlexibleSpaceBar(
                    title: Text('Your Library',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    centerTitle: false,
                    titlePadding: EdgeInsets.only(left: 16, bottom: 16),
                  ),
            actions: _isSearching
                ? [
                    if (_searchQuery.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      ),
                  ]
                : [
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => _showCreatePlaylistDialog(context, database),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        setState(() {
                          _isSearching = true;
                        });
                      },
                    ),
                  ],
          ),
          if (!_isSearching || _searchQuery.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _LikedSongsCard(database: database),
                    const SizedBox(height: 32),
                    const Text(
                      'Playlists',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Playlist'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Playlist name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (ctrl.text.isNotEmpty) {
                await database.createPlaylist(ctrl.text);
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: const Text('Create'),
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
        return GestureDetector(
          onTap: () => context.push('/liked-songs'),
          child: Container(
            height: 100,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF450af5), Color(0xFFc4efd9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(Icons.favorite, color: Colors.white, size: 32),
                ),
                const SizedBox(width: 16),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Liked Songs',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '$count songs',
                      style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7), fontSize: 14),
                    ),
                  ],
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
          padding: const EdgeInsets.symmetric(horizontal: 16),
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
                return _PlaylistCard(database: database, playlist: playlist);
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

        return GestureDetector(
          onTap: () => context.push('/playlist/${playlist.id}'),
          onLongPress: () => _confirmDelete(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: PlaylistCover(images: images, size: double.infinity),
              ),
              const SizedBox(height: 8),
              Text(
                playlist.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              Text(
                '${tracks.length} songs',
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Playlist'),
        content: Text('Are you sure you want to delete "${playlist.name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              database.deletePlaylist(playlist.id);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
