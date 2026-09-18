import 'package:flutter/material.dart';
import 'package:ppplayer/l10n/app_localizations.dart';
import '../../core/api/spotify_repository.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/db/app_database.dart' as db;
import '../../core/models/track.dart' as model;
import '../../core/player/player_provider.dart';
import '../../shared/widgets/track_tile.dart';
import '../../shared/widgets/context_menu/content_context_menu.dart';
import '../../shared/widgets/playlist_cover.dart';
import '../../shared/widgets/tactile_buttons.dart';
import '../../core/services/favorites_provider.dart';
import '../../shared/widgets/adaptive_blur.dart';
import 'package:drift/drift.dart' show Value;

class PlaylistDetailScreen extends ConsumerStatefulWidget {
  const PlaylistDetailScreen({super.key, required this.playlistId});
  final int playlistId;

  @override
  ConsumerState<PlaylistDetailScreen> createState() =>
      _PlaylistDetailScreenState();
}

class _PlaylistDetailScreenState extends ConsumerState<PlaylistDetailScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  bool _isSyncing = false;
  String? _syncError;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {}); // Rebuild to apply filtering in StreamBuilder
  }

  Future<void> _syncTracksIfNeeded(db.Playlist playlist) async {
    if (_isSyncing || _syncError != null) return;

    // Check if it has a spotifyId and tracks but it's empty
    // Actually we should trigger this when allTracks is empty and it has a spotifyId

    setState(() {
      _isSyncing = true;
      _syncError = null;
    });

    try {
      final spotifyId = playlist.spotifyId;
      if (spotifyId == null) {
        setState(() => _isSyncing = false);
        return;
      }

      final repo = ref.read(spotifyRepositoryProvider);
      final cacheResult = await repo.watchPlaylistTracks(spotifyId).first;
      final tracks = cacheResult.data;
      if (tracks.isNotEmpty) {
        final database = ref.read(db.appDatabaseProvider);
        await database.syncPlaylistTracks(
          widget.playlistId,
          tracks
              .map(
                (t) => db.TracksCompanion(
                  spotifyId: Value(t.spotifyId),
                  name: Value(t.name),
                  artistId: Value(t.artistId),
                  artistName: Value(t.artistName),
                  albumId: Value(t.albumId),
                  albumName: Value(t.albumName),
                  albumImage: Value(t.albumImage),
                  durationMs: Value(t.durationMs),
                ),
              )
              .toList(),
        );
      }
    } catch (e) {
      setState(() => _syncError = e.toString());
    } finally {
      if (mounted) {
        setState(() => _isSyncing = false);
      }
    }
  }

  void _onReorder(int oldIndex, int newIndex, List<model.Track> currentTracks) {
    if (_isSearching || _searchController.text.isNotEmpty) return;

    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final updatedTracks = List<model.Track>.from(currentTracks);
    final item = updatedTracks.removeAt(oldIndex);
    updatedTracks.insert(newIndex, item);

    // Persist to DB
    final database = ref.read(db.appDatabaseProvider);
    database.reorderTracks(
      updatedTracks.map((t) => int.parse(t.queueItemId!)).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final database = ref.read(db.appDatabaseProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return StreamBuilder<db.Playlist?>(
      stream:
          (database.select(database.playlists)
            ..where((p) => p.id.equals(widget.playlistId))).watchSingleOrNull(),
      builder: (context, playlistSnapshot) {
        final playlist = playlistSnapshot.data;

        if (playlist == null) {
          if (playlistSnapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              backgroundColor: colorScheme.surface,
              body: Center(
                child: CircularProgressIndicator(color: colorScheme.primary),
              ),
            );
          }
          return Scaffold(
            backgroundColor: colorScheme.surface,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Playlist not found',
                    style: TextStyle(color: colorScheme.onSurface),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.pop(),
                    child: Text(AppLocalizations.of(context)!.goBack),
                  ),
                ],
              ),
            ),
          );
        }

        return StreamBuilder<List<model.Track>>(
          stream: database.watchPlaylistAppTracks(widget.playlistId),
          builder: (context, tracksSnapshot) {
            final allTracks = tracksSnapshot.data ?? [];

            // Trigger sync if empty and has spotifyId
            if (allTracks.isEmpty &&
                playlist.spotifyId != null &&
                !_isSyncing &&
                _syncError == null) {
              WidgetsBinding.instance.addPostFrameCallback(
                (_) => _syncTracksIfNeeded(playlist),
              );
            }

            final query = _searchController.text.toLowerCase();

            final filteredTracks =
                query.isEmpty
                    ? allTracks
                    : allTracks.where((track) {
                      final titleMatch = track.name.toLowerCase().contains(
                        query,
                      );
                      final artistMatch = track.artistName
                          .toLowerCase()
                          .contains(query);
                      return titleMatch || artistMatch;
                    }).toList();

            final modelTracks = filteredTracks;

            return Scaffold(
              backgroundColor: colorScheme.surface,
              body: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  _buildSliverAppBar(context, playlist, allTracks),
                  if (_isSearching) _buildSearchHeader(context),
                  ..._buildBody(context, playlist, allTracks, modelTracks),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSliverAppBar(
    BuildContext context,
    db.Playlist playlist,
    List<model.Track> tracks,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return SliverAppBar(
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
            final isCollapsed = constraints.maxHeight <= kToolbarHeight + 80;

            if (isCollapsed) {
              return AdaptiveBlur(
                sigmaX: 15,
                sigmaY: 15,
                child: Container(
                  height: kToolbarHeight + 40,
                  alignment: Alignment.bottomCenter,
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    playlist.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      letterSpacing: -0.5,
                      color: colorScheme.onSurface,
                    ),
                  ).animate().fadeIn(duration: 200.ms),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorScheme.primary.withValues(alpha: 0.8),
                    colorScheme.primaryContainer.withValues(alpha: 0.4),
                    colorScheme.surface,
                  ],
                  stops: const [0.0, 0.4, 1.0],
                ),
              ),
            ),
            Positioned.fill(
              child: Opacity(
                opacity: 0.6,
                child: Container(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: const Alignment(-0.8, -0.6),
                          radius: 1.5,
                          colors: [colorScheme.primary, Colors.transparent],
                        ),
                      ),
                    )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .scale(
                      begin: const Offset(1, 1),
                      end: const Offset(1.3, 1.3),
                      duration: 10.seconds,
                      curve: Curves.easeInOut,
                    )
                    .move(
                      begin: const Offset(-20, -20),
                      end: const Offset(20, 20),
                      duration: 12.seconds,
                      curve: Curves.easeInOut,
                    ),
              ),
            ),
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
            Positioned(
              left: 20,
              right: 20,
              bottom: 40,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Hero(
                        tag: 'playlist_art_${playlist.id}',
                        child: Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: colorScheme.shadow.withValues(
                                  alpha: 0.5,
                                ),
                                blurRadius: 30,
                                offset: const Offset(0, 10),
                              ),
                              BoxShadow(
                                color: colorScheme.primary.withValues(
                                  alpha: 0.2,
                                ),
                                blurRadius: 40,
                                spreadRadius: -5,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: PlaylistCover(
                              images:
                                  tracks
                                      .take(4)
                                      .map((t) => t.albumImage)
                                      .whereType<String>()
                                      .toList(),
                              size: 180,
                            ),
                          ),
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .scale(begin: const Offset(0.9, 0.9)),
                  const SizedBox(height: 24),
                  Text(
                    'PLAYLIST',
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ).animate().fadeIn(delay: 200.ms),
                  const SizedBox(height: 8),
                  Text(
                    playlist.name,
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
    );
  }

  Widget _buildSearchHeader(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: TextField(
          controller: _searchController,
          autofocus: true,
          style: TextStyle(color: colorScheme.onSurface),
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.searchInPlaylist,
            hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: colorScheme.onSurfaceVariant,
            ),
            filled: true,
            fillColor: colorScheme.onSurface.withValues(alpha: 0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          ),
        ),
      ).animate().fadeIn().slideY(begin: -0.1),
    );
  }

  List<Widget> _buildBody(
    BuildContext context,
    db.Playlist playlist,
    List<model.Track> allTracks,
    List<model.Track> modelTracks,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    if (_isSyncing) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: colorScheme.primary),
                const SizedBox(height: 16),
                Text(
                  'Fetching tracks...',
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ),
      ];
    }

    if (allTracks.isEmpty) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.playlist_add,
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                  size: 80,
                ),
                const SizedBox(height: 16),
                Text(
                  'No tracks in this playlist yet.',
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 24),
                TactileTap(
                  onTap: () => context.go('/search'),
                  hapticType: HapticFeedbackType.medium,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Find Songs',
                      style: TextStyle(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ];
    }

    return [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Playlist • ${allTracks.length} songs',
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  if (playlist.spotifyId != null)
                    Consumer(
                      builder: (context, ref, _) {
                        final statusAsync = ref.watch(
                          favoritesStatusProvider((
                            FavoriteType.playlist,
                            playlist.spotifyId!,
                          )),
                        );
                        final isLiked = statusAsync.value ?? false;

                        return TactileIconButton(
                          icon:
                              isLiked
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                          color:
                              isLiked
                                  ? colorScheme.primary
                                  : colorScheme.onSurfaceVariant,
                          size: 28,
                          onTap: () {
                            ref
                                .read(favoritesControllerProvider.notifier)
                                .togglePlaylistLike(
                                  playlist.spotifyId!,
                                  playlist.name,
                                  playlist.imageUrl,
                                  isLiked,
                                );
                          },
                        );
                      },
                    )
                  else
                    // For local-only playlists, we don't have a "favorite" state in the same way yet
                    // But we can keep the icon for consistency or remove it
                    TactileIconButton(
                      icon: Icons.favorite_border_rounded,
                      color: colorScheme.onSurfaceVariant,
                      size: 28,
                      onTap: () {},
                    ),
                  const SizedBox(width: 8),
                  const SizedBox(width: 8),
                  Builder(
                    builder: (btnContext) => TactileIconButton(
                      icon: Icons.more_vert_rounded,
                      color: colorScheme.onSurfaceVariant,
                      size: 28,
                      onTap: () {
                        final renderBox = btnContext.findRenderObject() as RenderBox?;
                        final offset = renderBox?.localToGlobal(Offset.zero);
                        if (offset == null) return;
                        showContentContextMenu(
                          context,
                          ref,
                          position: offset + Offset(0, renderBox!.size.height),
                          target: PlaylistContextTarget(
                            id: playlist.spotifyId ?? playlist.id.toString(),
                            name: playlist.name,
                            imageUrl: playlist.imageUrl,
                            isLocal: playlist.spotifyId == null,
                            localId: playlist.id,
                          ),
                        );
                      },
                    ),
                  ),
                  const Spacer(),
                  TactileIconButton(
                    icon: Icons.shuffle_rounded,
                    color: colorScheme.onSurfaceVariant,
                    size: 32,
                    onTap: () {
                      if (modelTracks.isNotEmpty) {
                        ref
                            .read(playerProvider.notifier)
                            .shuffleAndPlay(modelTracks);
                      }
                    },
                  ),
                  const SizedBox(width: 16),
                  TactileActionPlayButton(
                    size: 56,
                    onTap: () {
                      if (modelTracks.isNotEmpty) {
                        ref
                            .read(playerProvider.notifier)
                            .playTrack(modelTracks.first, queue: modelTracks);
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
            key: ValueKey(track.queueItemId ?? track.spotifyId),
            index: index,
            child: TrackTile(
              index: index + 1,
              track: track,
              playlistId: playlist.id,
              playlistEntryId: track.queueItemId != null ? int.tryParse(track.queueItemId!) : null,
              onTap:
                  () => ref
                      .read(playerProvider.notifier)
                      .playTrack(track, queue: modelTracks),
            ).animate().fadeIn(delay: (index * 30).ms).slideX(begin: 0.05),
          );
        },
        itemCount: modelTracks.length,
        onReorderItem:
            (oldIndex, newIndex) => _onReorder(
              oldIndex,
              newIndex,
              modelTracks,
            ),
      ),
      const SliverToBoxAdapter(child: SizedBox(height: 120)),
    ];
  }
}
