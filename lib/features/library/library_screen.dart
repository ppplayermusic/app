import 'dart:ui';
import 'package:ppplayer/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/db/app_database.dart' as db;
import '../../core/models/track.dart' as model;
import '../../shared/widgets/playlist_cover.dart';
import '../../shared/widgets/tactile_buttons.dart';
import '../../shared/widgets/premium_modals.dart';
import '../../core/player/player_provider.dart';
import '../../shared/widgets/shimmer_placeholder.dart';
import '../../shared/widgets/adaptive_blur.dart';
import '../../shared/widgets/context_menu/content_context_menu.dart';
import '../../shared/widgets/pp_image.dart';
import 'import_local_modal.dart';

enum LibraryFilter { all, playlists, artists, albums, stations }

enum LibrarySort { recent, alphabetical }

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key, this.initialFilter = LibraryFilter.all});

  final LibraryFilter initialFilter;

  static void showCreatePlaylistDialog(
    BuildContext context,
    db.AppDatabase database,
  ) {
    final ctrl = TextEditingController();
    showPremiumModal<void>(
      context: context,
      title: AppLocalizations.of(context)!.newPlaylist,
      child: Builder(
        builder:
            (dialogContext) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: ctrl,
                  autofocus: true,
                  style: TextStyle(
                    color: Theme.of(dialogContext).colorScheme.onSurface,
                    fontSize: 18,
                  ),
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.nameYourMasterpiece,
                    hintStyle: TextStyle(
                      color: Theme.of(
                        dialogContext,
                      ).colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                    ),
                    filled: true,
                    fillColor: Theme.of(
                      dialogContext,
                    ).colorScheme.onSurface.withValues(alpha: 0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TactileTap(
                        onTap: () => Navigator.pop(dialogContext),
                        child: Container(
                          height: 54,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Theme.of(dialogContext)
                                  .colorScheme
                                  .outlineVariant
                                  .withValues(alpha: 0.5),
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.cancel,
                            style: TextStyle(
                              color:
                                  Theme.of(
                                    dialogContext,
                                  ).colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TactileTap(
                        onTap: () async {
                          if (ctrl.text.isNotEmpty) {
                            await database.createPlaylist(ctrl.text);
                            if (dialogContext.mounted) {
                              Navigator.pop(dialogContext);
                            }
                          }
                        },
                        child: Container(
                          height: 54,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(dialogContext).colorScheme.primary,
                                Theme.of(
                                  dialogContext,
                                ).colorScheme.primaryContainer,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.create,
                            style: TextStyle(
                              color:
                                  Theme.of(dialogContext).colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
      ),
    );
  }

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  late final ScrollController _scrollController;
  bool _isCollapsed = false;
  String _searchQuery = '';
  late LibraryFilter _selectedFilter;
  LibrarySort _selectedSort = LibrarySort.recent;

  @override
  void initState() {
    super.initState();
    _selectedFilter = widget.initialFilter;
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    final collapsed =
        _scrollController.hasClients && _scrollController.offset > 45;
    if (collapsed != _isCollapsed) {
      setState(() {
        _isCollapsed = collapsed;
      });
    }
  }

  @override
  void didUpdateWidget(LibraryScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialFilter != widget.initialFilter) {
      _selectedFilter = widget.initialFilter;
    }
  }

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
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final database = ref.watch(db.appDatabaseProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            pinned: true,
            toolbarHeight: 64,
            expandedHeight: _isSearching ? 64 : 170,
            backgroundColor: Colors.transparent,
            elevation: 0,
            forceMaterialTransparency: true,
            title:
                _isSearching
                    ? TextField(
                      controller: _searchController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.searchInLibrary,
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 18,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value.toLowerCase();
                        });
                      },
                    )
                    : AnimatedOpacity(
                      opacity: _isCollapsed ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 160),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          AppLocalizations.of(context)!.library,
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w900,
                            fontSize: 22,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                    ),
            leading:
                _isSearching
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
            flexibleSpace: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: _isCollapsed ? 20 : 0,
                  sigmaY: _isCollapsed ? 20 : 0,
                ),
                child: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (_isCollapsed)
                        Positioned.fill(
                          child: IgnorePointer(
                            child: Container(
                              decoration: BoxDecoration(
                                color: colorScheme.surface.withValues(
                                  alpha: 0.75,
                                ),
                                border: Border(
                                  bottom: BorderSide(
                                    color: colorScheme.onSurface.withValues(
                                      alpha: 0.08,
                                    ),
                                    width: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (!_isCollapsed)
                        SafeArea(
                          bottom: false,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 16,
                              right: 16,
                              bottom: 60 + 16,
                            ),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: colorScheme.outlineVariant
                                            .withValues(alpha: 0.2),
                                        width: 1.5,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: colorScheme.primary.withValues(
                                            alpha: 0.4,
                                          ),
                                          blurRadius: 20,
                                          spreadRadius: -2,
                                        ),
                                      ],
                                      image: const DecorationImage(
                                        image: AssetImage('assets/logo.png'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ).animate().fadeIn().scale(
                                    duration: 400.ms,
                                    curve: Curves.easeOutBack,
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Text(
                                      AppLocalizations.of(context)!.yourLibrary,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: colorScheme.onSurface,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 34,
                                        letterSpacing: -1.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            actions:
                _isSearching
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
                        onTap:
                            () => LibraryScreen.showCreatePlaylistDialog(
                              context,
                              database,
                            ),
                      ),
                      TactileIconButton(
                        icon: Icons.create_new_folder_rounded,
                        onTap: () => showImportLocalModal(context, ref),
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
            bottom:
                !_isSearching
                    ? PreferredSize(
                      preferredSize: const Size.fromHeight(60),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4, bottom: 10),
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
                      Row(
                        children: [
                          Expanded(
                            child: _LikedSongsCard(database: database)
                                .animate()
                                .fadeIn(duration: 400.ms)
                                .slideY(begin: 0.1, end: 0),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _LocalMusicCard(database: database)
                                .animate()
                                .fadeIn(duration: 400.ms, delay: 100.ms)
                                .slideY(begin: 0.1, end: 0),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ],
                ),
              ),
            ),
          if (_selectedFilter == LibraryFilter.all ||
              _selectedFilter == LibraryFilter.playlists) ...[
            _PlaylistsGrid(
              database: database,
              searchQuery: _searchQuery,
              sortByRecent: _selectedSort == LibrarySort.recent,
              showHeader:
                  _selectedFilter == LibraryFilter.all && _searchQuery.isEmpty,
            ),
          ],

          if (_selectedFilter == LibraryFilter.all ||
              _selectedFilter == LibraryFilter.artists) ...[
            _ArtistsSliverList(
              database: database,
              searchQuery: _searchQuery,
              sortByRecent: _selectedSort == LibrarySort.recent,
              showHeader:
                  _selectedFilter == LibraryFilter.all && _searchQuery.isEmpty,
            ),
          ],

          if (_selectedFilter == LibraryFilter.all ||
              _selectedFilter == LibraryFilter.albums) ...[
            _AlbumsSliverGrid(
              database: database,
              searchQuery: _searchQuery,
              sortByRecent: _selectedSort == LibrarySort.recent,
              showHeader:
                  _selectedFilter == LibraryFilter.all && _searchQuery.isEmpty,
            ),
          ],

          if (_selectedFilter == LibraryFilter.all ||
              _selectedFilter == LibraryFilter.stations) ...[
            _RadiosSliverGrid(
              database: database,
              searchQuery: _searchQuery,
              sortByRecent: _selectedSort == LibrarySort.recent,
              showHeader:
                  _selectedFilter == LibraryFilter.all && _searchQuery.isEmpty,
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
    return StreamBuilder<List<db.TrackEntry>>(
      stream:
          (database.select(database.tracks)
            ..where((t) => t.isFavorite.equals(true))).watch(),
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
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.9),
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.25),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
              border: Border.all(
                color: Theme.of(
                  context,
                ).colorScheme.outlineVariant.withValues(alpha: 0.2),
                width: 0.5,
              ),
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
                              Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.4),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      )
                      .animate(onPlay: (c) => c.repeat(reverse: true))
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
                              Theme.of(
                                context,
                              ).colorScheme.secondary.withValues(alpha: 0.2),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      )
                      .animate(onPlay: (c) => c.repeat(reverse: true))
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
                              Theme.of(
                                context,
                              ).colorScheme.tertiary.withValues(alpha: 0.15),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .scale(
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
                              Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.1),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .scale(
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
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context).colorScheme.primaryContainer,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                                Icons.favorite_rounded,
                                color: Theme.of(context).colorScheme.onPrimary,
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
                            Text(
                              'Liked Songs',
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer
                                    .withValues(alpha: 0.9),
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -1.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onPrimary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.onPrimary
                                      .withValues(alpha: 0.1),
                                ),
                              ),
                              child: Text(
                                '$count TRACKS',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onPrimary
                                      .withValues(alpha: 0.8),
                                  fontSize: 10,
                                  letterSpacing: 1.2,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Consumer(
                        builder:
                            (context, ref, _) => TactileTap(
                              onTap: () async {
                                final tracks = await database.getFavoriteAppTracks();
                                if (tracks.isNotEmpty) {
                                  ref
                                      .read(playerProvider.notifier)
                                      .playTracks(tracks);
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).colorScheme.onPrimary
                                      .withValues(alpha: 0.15),
                                  border: Border.all(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary
                                        .withValues(alpha: 0.1),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context).colorScheme.scrim
                                          .withValues(alpha: 0.2),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.play_arrow_rounded,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  size: 32,
                                ),
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

class _LocalMusicCard extends StatelessWidget {
  const _LocalMusicCard({required this.database});

  final db.AppDatabase database;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<model.Track>>(
      stream: database.watchLocalAppTracks(),
      builder: (context, snap) {
        final count = snap.data?.length ?? 0;
        return TactileTap(
          onTap: () => context.push('/local-library'),
          child: Container(
            constraints: const BoxConstraints(minHeight: 140),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.9),
                  Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.4),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.25),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.2),
                width: 0.5,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                // Content
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.library_music_rounded,
                          color: Theme.of(context).colorScheme.onTertiary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Local Music',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: Theme.of(context).colorScheme.onTertiary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onTertiary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$count TRACKS',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color: Theme.of(context).colorScheme.onTertiary.withValues(alpha: 0.9),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Decorative Play Icon
                Positioned(
                  right: 24,
                  bottom: 24,
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onTertiary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.play_arrow_rounded,
                      color: Theme.of(context).colorScheme.onTertiary.withValues(alpha: 0.5),
                      size: 32,
                    ),
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
          playlists =
              playlists
                  .where(
                    (p) => p.name.toLowerCase().contains(
                      searchQuery.toLowerCase(),
                    ),
                  )
                  .toList();
        }

        if (isLoading) {
          return const _AlbumsShimmer(); // Reusing Albums shimmer for playlists
        }

        if (playlists.isEmpty) {
          if (searchQuery.isNotEmpty) {
            return SliverToBoxAdapter(
              child: _EmptyState(
                icon: Icons.search_off_rounded,
                title: AppLocalizations.of(context)!.noResultsFound,
                subtitle: AppLocalizations.of(context)!.tryADifferentSearchTerm,
              ),
            );
          }
          return SliverToBoxAdapter(
            child: _EmptyState(
              icon: Icons.playlist_add_rounded,
              title: AppLocalizations.of(context)!.noPlaylistsYet,
              subtitle: AppLocalizations.of(context)!.createAPlaylistToGetStarted,
              buttonText: 'Create Playlist',
              onPressed:
                  () =>
                      LibraryScreen.showCreatePlaylistDialog(context, database),
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
                delegate: SliverChildBuilderDelegate((context, i) {
                  final playlist = playlists[i];
                  return _PlaylistCard(database: database, playlist: playlist)
                      .animate(delay: (i * 60).ms)
                      .fadeIn(duration: 500.ms)
                      .slideY(begin: 0.15, end: 0, curve: Curves.easeOutQuart);
                }, childCount: playlists.length),
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
      future: database.getPlaylistAppTracks(playlist.id),
      builder: (context, snap) {
        final tracks = snap.data ?? [];
        final images =
            tracks
                .map((t) => t.albumImage)
                .whereType<String>()
                .take(4)
                .toList();

        return ContentContextMenuRegion(
          target: PlaylistContextTarget(
            id: '${playlist.id}',
            name: playlist.name,
            imageUrl: playlist.imageUrl,
            isLocal: true,
            localId: playlist.id,
          ),
          child: TactileTap(
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
                          color: Theme.of(
                            context,
                          ).colorScheme.scrim.withValues(alpha: 0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child:
                          playlist.imageUrl != null
                              ? PPImage(
                                imageUrl: playlist.imageUrl!,
                                fit: BoxFit.cover,
                              )
                              : PlaylistCover(
                                images: images,
                                size: double.infinity,
                              ),
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
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.4),
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, db.Playlist playlist) {
    showPremiumModal<void>(
      context: context,
      title: AppLocalizations.of(context)!.deletePlaylist,
      child: Builder(
        builder: (dialogContext) {
          final colorScheme = Theme.of(dialogContext).colorScheme;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Are you sure you want to delete "${playlist.name}"?\nThis action cannot be undone.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: TactileTap(
                      onTap: () => Navigator.pop(dialogContext),
                      child: Container(
                        height: 54,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: colorScheme.outlineVariant),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.cancel,
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TactileTap(
                      onTap: () async {
                        await database.deletePlaylist(playlist.id);
                        if (dialogContext.mounted) {
                          Navigator.pop(dialogContext);
                        }
                      },
                      child: Container(
                        height: 54,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: colorScheme.error.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: colorScheme.error.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          'Delete',
                          style: TextStyle(
                            color: colorScheme.error,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.selectedFilter, required this.onSelected});

  final LibraryFilter selectedFilter;
  final ValueChanged<LibraryFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children:
            LibraryFilter.values.map((filter) {
              final isSelected = selectedFilter == filter;
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: _FilterChipItem(
                  filter: filter,
                  isSelected: isSelected,
                  onTap: () => onSelected(filter),
                ),
              );
            }).toList(),
      ),
    );
  }
}

class _FilterChipItem extends StatefulWidget {
  const _FilterChipItem({
    required this.filter,
    required this.isSelected,
    required this.onTap,
  });

  final LibraryFilter filter;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_FilterChipItem> createState() => _FilterChipItemState();
}

class _FilterChipItemState extends State<_FilterChipItem> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = widget.isSelected;

    final bgColor =
        isSelected
            ? colorScheme.primary
            : (_isHovered
                ? colorScheme.onSurface.withValues(alpha: 0.12)
                : colorScheme.onSurface.withValues(alpha: 0.05));

    final borderColor =
        isSelected
            ? colorScheme.onPrimary.withValues(alpha: _isHovered ? 0.35 : 0.20)
            : (_isHovered
                ? colorScheme.outlineVariant.withValues(alpha: 0.30)
                : colorScheme.onSurface.withValues(alpha: 0.05));

    final textColor =
        isSelected
            ? colorScheme.onPrimary
            : (_isHovered
                ? colorScheme.onSurface
                : colorScheme.onSurfaceVariant);

    final scale = _isPressed ? 0.95 : (_isHovered ? 1.04 : 1.0);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: borderColor, width: 1.0),
              boxShadow:
                  isSelected
                      ? [
                        BoxShadow(
                          color: colorScheme.primary.withValues(
                            alpha: _isHovered ? 0.45 : 0.30,
                          ),
                          blurRadius: _isHovered ? 18 : 14,
                          offset: const Offset(0, 4),
                        ),
                      ]
                      : (_isHovered
                          ? [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.20),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ]
                          : []),
            ),
            child: Text(
              widget.filter.name[0].toUpperCase() +
                  widget.filter.name.substring(1),
              style: TextStyle(
                color: textColor,
                fontWeight:
                    isSelected
                        ? FontWeight.w900
                        : (_isHovered ? FontWeight.w700 : FontWeight.w600),
                fontSize: 14,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ),
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
          artists =
              artists
                  .where(
                    (a) => a.name.toLowerCase().contains(
                      searchQuery.toLowerCase(),
                    ),
                  )
                  .toList();
        }

        if (isLoading) {
          return const _ArtistsShimmer();
        }

        if (artists.isEmpty) {
          if (searchQuery.isNotEmpty) {
            return SliverToBoxAdapter(
              child: _EmptyState(
                icon: Icons.search_off_rounded,
                title: AppLocalizations.of(context)!.noResultsFound,
                subtitle: AppLocalizations.of(context)!.tryADifferentSearchTerm,
              ),
            );
          }
          return SliverToBoxAdapter(
            child: _EmptyState(
              icon: Icons.person_add_rounded,
              title: AppLocalizations.of(context)!.noArtistsFollowed,
              subtitle: AppLocalizations.of(context)!.followArtistsToSeeThemHere,
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
                delegate: SliverChildBuilderDelegate((context, i) {
                  final artist = artists[i];
                  return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: ContentContextMenuRegion(
                          target: ArtistContextTarget(
                            id: artist.spotifyId,
                            name: artist.name,
                            imageUrl: artist.imageUrl,
                          ),
                          child: TactileTap(
                            onTap:
                                () =>
                                    context.push('/artist/${artist.spotifyId}'),
                            child: Row(
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image:
                                        artist.imageUrl != null
                                            ? DecorationImage(
                                              image: NetworkImage(
                                                artist.imageUrl!,
                                              ),
                                              fit: BoxFit.cover,
                                            )
                                            : null,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.05),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .scrim
                                            .withValues(alpha: 0.3),
                                        blurRadius: 15,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child:
                                      artist.imageUrl == null
                                          ? Icon(
                                            Icons.person,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant
                                                .withValues(alpha: 0.3),
                                            size: 40,
                                          )
                                          : null,
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        artist.name,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w900,
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.onSurface,
                                          letterSpacing: -0.5,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Artist',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant
                                              .withValues(alpha: 0.7),
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
                        ),
                      )
                      .animate(delay: (i * 60).ms)
                      .fadeIn(duration: 500.ms)
                      .slideX(begin: 0.1, end: 0, curve: Curves.easeOutQuart);
                }, childCount: artists.length),
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
          albums =
              albums
                  .where(
                    (a) => a.name.toLowerCase().contains(
                      searchQuery.toLowerCase(),
                    ),
                  )
                  .toList();
        }

        if (isLoading) {
          return const _AlbumsShimmer();
        }

        if (albums.isEmpty) {
          if (searchQuery.isNotEmpty) {
            return SliverToBoxAdapter(
              child: _EmptyState(
                icon: Icons.search_off_rounded,
                title: AppLocalizations.of(context)!.noResultsFound,
                subtitle: AppLocalizations.of(context)!.tryADifferentSearchTerm,
              ),
            );
          }
          return SliverToBoxAdapter(
            child: _EmptyState(
              icon: Icons.album_rounded,
              title: AppLocalizations.of(context)!.noLikedAlbums,
              subtitle: AppLocalizations.of(context)!.likeAlbumsToSeeThemHere,
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
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                delegate: SliverChildBuilderDelegate((context, i) {
                  final album = albums[i];
                  return ContentContextMenuRegion(
                        target: AlbumContextTarget(
                          id: album.spotifyId,
                          name: album.name,
                          artistName: album.artistName,
                          imageUrl: album.imageUrl,
                        ),
                        child: TactileTap(
                          onTap:
                              () => context.push('/album/${album.spotifyId}'),
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
                                        color: Theme.of(context)
                                            .colorScheme
                                            .scrim
                                            .withValues(alpha: 0.4),
                                        blurRadius: 20,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                    image:
                                        album.imageUrl != null
                                            ? DecorationImage(
                                              image: NetworkImage(
                                                album.imageUrl!,
                                              ),
                                              fit: BoxFit.cover,
                                            )
                                            : null,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surfaceContainerHighest
                                        .withValues(alpha: 0.4),
                                  ),
                                  child:
                                      album.imageUrl == null
                                          ? Icon(
                                            Icons.album_rounded,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant
                                                .withValues(alpha: 0.2),
                                            size: 40,
                                          )
                                          : null,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                album.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                album.artistName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant
                                      .withValues(alpha: 0.7),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .animate(delay: (i * 60).ms)
                      .fadeIn(duration: 500.ms)
                      .slideY(begin: 0.15, end: 0, curve: Curves.easeOutQuart);
                }, childCount: albums.length),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SortToggle extends StatelessWidget {
  const _SortToggle({required this.selectedSort, required this.onSelected});

  final LibrarySort selectedSort;
  final ValueChanged<LibrarySort> onSelected;

  @override
  Widget build(BuildContext context) {
    return TactileIconButton(
      icon:
          selectedSort == LibrarySort.recent
              ? Icons.access_time_rounded
              : Icons.sort_by_alpha_rounded,
      tooltip:
          selectedSort == LibrarySort.recent
              ? 'Sort: Recent'
              : 'Sort: Alphabetical',
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
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.05),
            ),
            child: Icon(
              icon,
              size: 48,
              color: Theme.of(
                context,
              ).colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Theme.of(context).colorScheme.onSurface,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(
                context,
              ).colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
              fontWeight: FontWeight.w500,
            ),
          ),
          if (buttonText != null && onPressed != null) ...[
            const SizedBox(height: 32),
            TactileTap(
              onTap: onPressed!,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  buttonText!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
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
    return const SliverSectionShimmer(
      count: 6,
      isCircular: true,
      tileHeight: 80,
      spacing: 16,
    );
  }
}

class _AlbumsShimmer extends StatelessWidget {
  const _AlbumsShimmer();

  @override
  Widget build(BuildContext context) {
    return const SliverSectionShimmer(
      count: 6,
      isGrid: true,
      crossAxisCount: 2,
      childAspectRatio: 0.75,
      spacing: 16,
    );
  }
}

class _RadiosSliverGrid extends StatelessWidget {
  const _RadiosSliverGrid({
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
    return StreamBuilder<List<db.Radio>>(
      stream: database.watchFollowedRadios(sortByRecent: sortByRecent),
      builder: (context, snap) {
        final isLoading = snap.connectionState == ConnectionState.waiting;
        var radios = snap.data ?? [];
        if (searchQuery.isNotEmpty) {
          radios =
              radios
                  .where(
                    (r) => r.title.toLowerCase().contains(
                      searchQuery.toLowerCase(),
                    ),
                  )
                  .toList();
        }

        if (isLoading) {
          return const _AlbumsShimmer(); // Reuse same grid shimmer
        }

        if (radios.isEmpty) {
          if (searchQuery.isNotEmpty) {
            return SliverToBoxAdapter(
              child: _EmptyState(
                icon: Icons.search_off_rounded,
                title: AppLocalizations.of(context)!.noResultsFound,
                subtitle: AppLocalizations.of(context)!.tryADifferentSearchTerm,
              ),
            );
          }
          return SliverToBoxAdapter(
            child: _EmptyState(
              icon: Icons.radio_rounded,
              title: AppLocalizations.of(context)!.noStationsFollowed,
              subtitle: AppLocalizations.of(context)!.followStationsToSeeThemHere,
              buttonText: 'Discover Music',
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
                    'Radio Stations',
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
                delegate: SliverChildBuilderDelegate((context, i) {
                  final radio = radios[i];
                  return _RadioCard(radio: radio)
                      .animate(delay: (i * 60).ms)
                      .fadeIn(duration: 500.ms)
                      .slideY(begin: 0.15, end: 0, curve: Curves.easeOutQuart);
                }, childCount: radios.length),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _RadioCard extends ConsumerWidget {
  const _RadioCard({required this.radio});
  final db.Radio radio;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ContentContextMenuRegion(
      target: RadioContextTarget(
        seedId: radio.seedId,
        seedType: radio.seedType,
        title: radio.title,
        imageUrl: radio.imageUrl,
      ),
      child: TactileTap(
        onTap: () {
          if (radio.seedType == 'genre') {
            context.push(
              '/genre/${radio.seedId}?name=${Uri.encodeComponent(radio.title)}',
            );
          } else {
            context.push(
              Uri(
                path: '/radio/${radio.seedType}/${radio.seedId}',
                queryParameters: {
                  'title': radio.title,
                  'imageUrl': radio.imageUrl ?? '',
                },
              ).toString(),
            );
          }
        },
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
                      color: Theme.of(
                        context,
                      ).colorScheme.scrim.withValues(alpha: 0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                  image:
                      radio.imageUrl != null
                          ? DecorationImage(
                            image: NetworkImage(radio.imageUrl!),
                            fit: BoxFit.cover,
                          )
                          : null,
                  color: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                ),
                child:
                    radio.imageUrl == null
                        ? Icon(
                          Icons.radio_rounded,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurfaceVariant.withValues(alpha: 0.2),
                          size: 40,
                        )
                        : Stack(
                          children: [
                            Positioned(
                              right: 12,
                              bottom: 12,
                              child: AdaptiveBlur(
                                sigmaX: 8,
                                sigmaY: 8,
                                borderRadius: BorderRadius.circular(100),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.surface
                                        .withValues(alpha: 0.8),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.radio_rounded,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              radio.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 16,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              (radio.seedType == 'genre' ? 'Genre' : 'Radio Station')
                  .toUpperCase(),
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
