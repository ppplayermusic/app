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

enum LibraryFilter { all, playlists, artists, albums }
enum LibrarySort { recent, alphabetical }

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  static void showCreatePlaylistDialog(BuildContext context, db.AppDatabase database) {
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

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  LibraryFilter _selectedFilter = LibraryFilter.all;
  LibrarySort _selectedSort = LibrarySort.recent;

  void _onFilterSelected(LibraryFilter filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }

  void _onSortSelected(LibrarySort sort) {
    setState(() {
      _selectedSort = sort;
    });
  }

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
            expandedHeight: _isSearching ? kToolbarHeight : 154,
            backgroundColor: Colors.transparent,
            elevation: 0,
            forceMaterialTransparency: true,
            title: _isSearching
                ? TextField(
                    controller: _searchController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Search in library...',
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
                          child: ClipRRect(
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
                                  fontWeight: FontWeight.w900,
                                  fontSize: isCollapsed ? 20 : 36,
                                  letterSpacing: -1.2,
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
                      onTap: () => LibraryScreen.showCreatePlaylistDialog(context, database),
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
            bottom: !_isSearching 
              ? PreferredSize(
                  preferredSize: const Size.fromHeight(48),
                  child: Row(
                    children: [
                      Expanded(
                        child: _FilterBar(
                          selectedFilter: _selectedFilter,
                          onSelected: _onFilterSelected,
                        ),
                      ),
                      _SortToggle(
                        selectedSort: _selectedSort,
                        onSelected: _onSortSelected,
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                )
              : null,
          ),
          if (!_isSearching || _searchQuery.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_selectedFilter == LibraryFilter.all) ...[
                      _LikedSongsCard(database: database)
                          .animate()
                          .fadeIn(duration: 400.ms)
                          .slideY(begin: 0.1, end: 0),
                      const SizedBox(height: 16),
                    ],
                  ],
                ),
              ),
            ),
          if (_selectedFilter == LibraryFilter.all || _selectedFilter == LibraryFilter.playlists) ...[
            _PlaylistsGrid(
              database: database, 
              searchQuery: _searchQuery, 
              sortByRecent: _selectedSort == LibrarySort.recent,
              showHeader: _selectedFilter == LibraryFilter.all && _searchQuery.isEmpty,
            ),
          ],
          
          if (_selectedFilter == LibraryFilter.all || _selectedFilter == LibraryFilter.artists) ...[
            _ArtistsSliverList(
              database: database, 
              searchQuery: _searchQuery,
              sortByRecent: _selectedSort == LibrarySort.recent,
              showHeader: _selectedFilter == LibraryFilter.all && _searchQuery.isEmpty,
            ),
          ],
            
          if (_selectedFilter == LibraryFilter.all || _selectedFilter == LibraryFilter.albums) ...[
            _AlbumsSliverGrid(
              database: database, 
              searchQuery: _searchQuery,
              sortByRecent: _selectedSort == LibrarySort.recent,
              showHeader: _selectedFilter == LibraryFilter.all && _searchQuery.isEmpty,
            ),
          ],
            
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
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
    return StreamBuilder<List<db.Track>>(
      stream: (database.select(database.tracks)..where((t) => t.isFavorite.equals(true))).watch(),
      builder: (context, snap) {
        final count = snap.data?.length ?? 0;
        return TactileTap(
          onTap: () => context.push('/liked-songs'),
          child: Container(
            constraints: const BoxConstraints(minHeight: 140),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF450af5).withValues(alpha: 0.9),
                  const Color(0xFF1a004d).withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF450af5).withValues(alpha: 0.25),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
              border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 0.5),
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
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -1.5),
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
  const _PlaylistsGrid({
    required this.database, 
    this.searchQuery = '', 
    this.sortByRecent = true,
    this.showHeader = false,
  });
  final db.AppDatabase database;
  final String searchQuery;
  final bool sortByRecent;
  final bool showHeader;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<db.Playlist>>(
      stream: database.watchPlaylists(sortByRecent: sortByRecent),
      builder: (context, snap) {
        final isLoading = snap.connectionState == ConnectionState.waiting;
        var playlists = snap.data ?? [];
        if (searchQuery.isNotEmpty) {
          playlists = playlists.where((p) => p.name.toLowerCase().contains(searchQuery.toLowerCase())).toList();
        }
        
        if (isLoading) {
          return const _AlbumsShimmer(); // Reusing Albums shimmer for playlists
        }

        if (playlists.isEmpty) {
          if (searchQuery.isNotEmpty) {
            return const SliverToBoxAdapter(
              child: _EmptyState(
                icon: Icons.search_off_rounded,
                title: 'No results found',
                subtitle: 'Try a different search term',
              ),
            );
          }
          return SliverToBoxAdapter(
            child: _EmptyState(
              icon: Icons.playlist_add_rounded,
              title: 'No playlists yet',
              subtitle: 'Create a playlist to get started',
              buttonText: 'Create Playlist',
              onPressed: () => LibraryScreen.showCreatePlaylistDialog(context, database),
            ),
          );
        }

        return SliverMainAxisGroup(
          slivers: [
            if (showHeader)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 32, 16, 8),
                  child: Text(
                    'Playlists',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            SliverPadding(
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
            ),
          ],
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
          onLongPress: () => _confirmDelete(context, playlist),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: playlist.imageUrl != null 
                        ? Image.network(
                            playlist.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => PlaylistCover(images: images, size: double.infinity),
                          )
                        : PlaylistCover(images: images, size: double.infinity),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                playlist.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  letterSpacing: -0.6,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${tracks.length} tracks'.toUpperCase(),
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.4),
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, db.Playlist playlist) {
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

class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.selectedFilter,
    required this.onSelected,
  });

  final LibraryFilter selectedFilter;
  final ValueChanged<LibraryFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: LibraryFilter.values.map((filter) {
          final isSelected = selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TactileTap(
              onTap: () => onSelected(filter),
              child: AnimatedContainer(
                duration: 250.ms,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF450af5) : Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: isSelected ? Colors.white.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.05),
                  ),
                  boxShadow: isSelected ? [
                    BoxShadow(
                      color: const Color(0xFF450af5).withValues(alpha: 0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ] : [],
                ),
                child: Text(
                  filter.name[0].toUpperCase() + filter.name.substring(1),
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white70,
                    fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                    fontSize: 14,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ArtistsSliverList extends StatelessWidget {
  const _ArtistsSliverList({
    required this.database, 
    this.searchQuery = '',
    this.sortByRecent = true,
    this.showHeader = false,
  });
  final db.AppDatabase database;
  final String searchQuery;
  final bool sortByRecent;
  final bool showHeader;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<db.Artist>>(
      stream: database.watchFollowedArtists(sortByRecent: sortByRecent),
      builder: (context, snap) {
        final isLoading = snap.connectionState == ConnectionState.waiting;
        var artists = snap.data ?? [];
        
        if (searchQuery.isNotEmpty) {
          artists = artists.where((a) => a.name.toLowerCase().contains(searchQuery.toLowerCase())).toList();
        }

        if (isLoading) {
          return const _ArtistsShimmer();
        }

        if (artists.isEmpty) {
          if (searchQuery.isNotEmpty) {
            return const SliverToBoxAdapter(
              child: _EmptyState(
                icon: Icons.search_off_rounded,
                title: 'No results found',
                subtitle: 'Try a different search term',
              ),
            );
          }
          return SliverToBoxAdapter(
            child: _EmptyState(
              icon: Icons.person_add_rounded,
              title: 'No artists followed',
              subtitle: 'Follow artists to see them here',
              buttonText: 'Discover Artists',
              onPressed: () => context.push('/search'),
            ),
          );
        }

        return SliverMainAxisGroup(
          slivers: [
            if (showHeader)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 32, 16, 8),
                  child: Text(
                    'Artists',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    final artist = artists[i];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: TactileTap(
                        onTap: () => context.push('/artist/${artist.spotifyId}'),
                        child: Row(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: artist.imageUrl != null
                                    ? DecorationImage(
                                        image: NetworkImage(artist.imageUrl!),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                                color: Colors.white.withValues(alpha: 0.05),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    blurRadius: 15,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: artist.imageUrl == null
                                  ? const Icon(Icons.person, color: Colors.white24, size: 40)
                                  : null,
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    artist.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Artist',
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.5),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).animate(delay: (i * 60).ms).fadeIn(duration: 500.ms).slideX(begin: 0.1, end: 0, curve: Curves.easeOutQuart);
                  },
                  childCount: artists.length,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _AlbumsSliverGrid extends StatelessWidget {
  const _AlbumsSliverGrid({
    required this.database, 
    this.searchQuery = '',
    this.sortByRecent = true,
    this.showHeader = false,
  });
  final db.AppDatabase database;
  final String searchQuery;
  final bool sortByRecent;
  final bool showHeader;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<db.Album>>(
      stream: database.watchLikedAlbums(sortByRecent: sortByRecent),
      builder: (context, snap) {
        final isLoading = snap.connectionState == ConnectionState.waiting;
        var albums = snap.data ?? [];
        if (searchQuery.isNotEmpty) {
          albums = albums.where((a) => a.name.toLowerCase().contains(searchQuery.toLowerCase())).toList();
        }

        if (isLoading) {
          return const _AlbumsShimmer();
        }

        if (albums.isEmpty) {
          if (searchQuery.isNotEmpty) {
            return const SliverToBoxAdapter(
              child: _EmptyState(
                icon: Icons.search_off_rounded,
                title: 'No results found',
                subtitle: 'Try a different search term',
              ),
            );
          }
          return SliverToBoxAdapter(
            child: _EmptyState(
              icon: Icons.album_rounded,
              title: 'No liked albums',
              subtitle: 'Like albums to see them here',
              buttonText: 'Discover Albums',
              onPressed: () => context.push('/search'),
            ),
          );
        }

        return SliverMainAxisGroup(
          slivers: [
            if (showHeader)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 32, 16, 8),
                  child: Text(
                    'Albums',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 0.75,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    final album = albums[i];
                    return TactileTap(
                      onTap: () => context.push('/album/${album.spotifyId}'),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AspectRatio(
                            aspectRatio: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.4),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                                image: album.imageUrl != null
                                    ? DecorationImage(
                                        image: NetworkImage(album.imageUrl!),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                                color: Colors.white.withValues(alpha: 0.05),
                              ),
                              child: album.imageUrl == null
                                  ? const Icon(Icons.album_rounded, color: Colors.white24, size: 40)
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            album.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            album.artistName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.4),
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ).animate(delay: (i * 60).ms).fadeIn(duration: 500.ms).slideY(begin: 0.15, end: 0, curve: Curves.easeOutQuart);
                  },
                  childCount: albums.length,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SortToggle extends StatelessWidget {
  const _SortToggle({
    required this.selectedSort,
    required this.onSelected,
  });

  final LibrarySort selectedSort;
  final ValueChanged<LibrarySort> onSelected;

  @override
  Widget build(BuildContext context) {
    return TactileIconButton(
      icon: selectedSort == LibrarySort.recent ? Icons.access_time_rounded : Icons.sort_by_alpha_rounded,
      onTap: () {
        if (selectedSort == LibrarySort.recent) {
          onSelected(LibrarySort.alphabetical);
        } else {
          onSelected(LibrarySort.recent);
        }
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.buttonText,
    this.onPressed,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String? buttonText;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.05),
            ),
            child: Icon(icon, size: 48, color: Colors.white24),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.5),
              fontWeight: FontWeight.w500,
            ),
          ),
          if (buttonText != null && onPressed != null) ...[
            const SizedBox(height: 32),
            TactileTap(
              onTap: onPressed!,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF450af5),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF450af5).withValues(alpha: 0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  buttonText!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ArtistsShimmer extends StatelessWidget {
  const _ArtistsShimmer();

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, i) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 150,
                        height: 18,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.white.withValues(alpha: 0.05),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 60,
                        height: 14,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.white.withValues(alpha: 0.05),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1.5.seconds, color: Colors.white.withValues(alpha: 0.05)),
          childCount: 5,
        ),
      ),
    );
  }
}

class _AlbumsShimmer extends StatelessWidget {
  const _AlbumsShimmer();

  @override
  Widget build(BuildContext context) {
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
          (context, i) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: 120,
                height: 16,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: 80,
                height: 12,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
            ],
          ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1.5.seconds, color: Colors.white.withValues(alpha: 0.05)),
          childCount: 4,
        ),
      ),
    );
  }
}
