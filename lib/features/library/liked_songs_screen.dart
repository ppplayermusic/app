import 'package:flutter/material.dart';
import 'package:ppplayer/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import '../../core/db/app_database.dart' as db;
import '../../core/models/track.dart' as model;
import '../../core/player/player_provider.dart';
import '../../shared/widgets/track_tile.dart';
import '../../shared/widgets/tactile_buttons.dart';

class LikedSongsScreen extends ConsumerStatefulWidget {
  const LikedSongsScreen({super.key});

  @override
  ConsumerState<LikedSongsScreen> createState() => _LikedSongsScreenState();
}

class _LikedSongsScreenState extends ConsumerState<LikedSongsScreen> {
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
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: _isSearching ? kToolbarHeight : 300,
            pinned: true,
            stretch: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading:
                _isSearching
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
                    ).animate().fadeIn(duration: 400.ms),
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
            title:
                _isSearching
                    ? Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.05),
                        ),
                      ),
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 16,
                        ),
                        cursorColor: Theme.of(context).colorScheme.primary,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.searchLikedSongs,
                          hintStyle: TextStyle(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                            fontSize: 15,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value.toLowerCase();
                          });
                        },
                      ),
                    ).animate().fadeIn().scale(begin: const Offset(0.95, 1))
                    : null,
            flexibleSpace:
                _isSearching
                    ? ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                        child: Container(
                          color: Theme.of(
                            context,
                          ).colorScheme.surface.withValues(alpha: 0.6),
                        ),
                      ),
                    )
                    : LayoutBuilder(
                      builder: (context, constraints) {
                        final colorScheme = Theme.of(context).colorScheme;
                        final isCollapsed =
                            constraints.maxHeight <=
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
                                horizontal: 16,
                                vertical: 12,
                              ),
                              title: AnimatedOpacity(
                                duration: const Duration(milliseconds: 200),
                                opacity: 1.0,
                                child: Text(
                                  'Liked Songs',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: isCollapsed ? 18 : 32,
                                    letterSpacing: -1.0,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    shadows: [
                                      if (!isCollapsed)
                                        Shadow(
                                          color: colorScheme.scrim.withValues(
                                            alpha: 0.8,
                                          ),
                                          blurRadius: 20,
                                          offset: const Offset(0, 4),
                                        ),
                                    ],
                                  ),
                                ),
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
                                          Theme.of(context).colorScheme.primary,
                                          Theme.of(
                                            context,
                                          ).colorScheme.primaryContainer,
                                          Theme.of(context).colorScheme.surface,
                                        ],
                                        stops: const [0.0, 0.4, 1.0],
                                      ),
                                    ),
                                    child: Center(
                                      child: Icon(
                                            Icons.favorite,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withValues(alpha: 0.1),
                                            size: 140,
                                          )
                                          .animate(
                                            onPlay:
                                                (controller) => controller
                                                    .repeat(reverse: true),
                                          )
                                          .scale(
                                            begin: const Offset(1, 1),
                                            end: const Offset(1.15, 1.15),
                                            duration: 3.seconds,
                                            curve: Curves.easeInOut,
                                          )
                                          .blurXY(
                                            begin: 0,
                                            end: 10,
                                            duration: 3.seconds,
                                          ),
                                    ),
                                  ),
                                  // Lush Premium Gradient Overlay
                                  DecoratedBox(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Theme.of(context).colorScheme.surface
                                              .withValues(alpha: 0.2),
                                          Theme.of(context).colorScheme.surface
                                              .withValues(alpha: 0.6),
                                          Theme.of(context).colorScheme.surface,
                                        ],
                                        stops: const [0.0, 0.4, 0.7, 1.0],
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
                    StreamBuilder<List<model.Track>>(
                      stream: database.watchFavoriteAppTracks(),
                      builder: (context, snap) {
                        final count = snap.data?.length ?? 0;
                        return Text(
                          '$count tracks stored locally',
                          style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                            fontSize: 12,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      },
                    ).animate().fadeIn(duration: 400.ms),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: TactileTap(
                            onTap: () async {
                              final tracks = await database.getFavoriteAppTracks();
                              if (tracks.isNotEmpty && context.mounted) {
                                ref
                                    .read(playerProvider.notifier)
                                    .playTracks(tracks);
                              }
                            },
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Theme.of(context).colorScheme.primary,
                                    Theme.of(context).colorScheme.tertiary,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context).colorScheme.primary
                                        .withValues(alpha: 0.3),
                                    blurRadius: 15,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.play_arrow_rounded,
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onPrimary,
                                      size: 32,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'PLAY ALL',
                                      style: TextStyle(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.onPrimary,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 1.5,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        TactileTap(
                          onTap: () async {
                            final tracks = await database.getFavoriteAppTracks();
                            if (tracks.isNotEmpty && context.mounted) {
                              final notifier = ref.read(
                                playerProvider.notifier,
                              );

                              if (!ref.read(playerProvider).isShuffled) {
                                notifier.toggleShuffle();
                              }

                              // Shuffle the list locally or just play with shuffle enabled
                              final List<model.Track> shuffledList = List.from(
                                tracks,
                              )..shuffle();
                              notifier.playTracks(shuffledList);
                            }
                          },
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.outlineVariant,
                              ),
                            ),
                            child: Icon(
                              Icons.shuffle_rounded,
                              color: Theme.of(context).colorScheme.onSurface,
                              size: 24,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        TactileIconButton(
                          icon: Icons.more_vert_rounded,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.05),
                          size: 24,
                          onTap: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ],
              ),
            ),
          ),
          StreamBuilder<List<model.Track>>(
            stream: database.watchFavoriteAppTracks(),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting &&
                  !snap.hasData) {
                return SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                );
              }
              var dbTracks = snap.data ?? [];

              if (_searchQuery.isNotEmpty) {
                dbTracks =
                    dbTracks.where((t) {
                      final name = t.name.toLowerCase();
                      final artist = t.artistName.toLowerCase();
                      return name.contains(_searchQuery) ||
                          artist.contains(_searchQuery);
                    }).toList();
              }

              if (dbTracks.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.03),
                              ),
                              child: Icon(
                                _searchQuery.isNotEmpty
                                    ? Icons.search_off_rounded
                                    : Icons.favorite_rounded,
                                size: 64,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.1),
                              ),
                            )
                            .animate(onPlay: (c) => c.repeat(reverse: true))
                            .scale(
                              begin: const Offset(1, 1),
                              end: const Offset(1.1, 1.1),
                              duration: 2.seconds,
                            )
                            .fadeIn(duration: 600.ms),
                        const SizedBox(height: 32),
                        Text(
                              _searchQuery.isNotEmpty
                                  ? 'Nothing matches your vibe'
                                  : 'Your collection is quiet',
                              style: TextStyle(
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.5,
                              ),
                            )
                            .animate()
                            .fadeIn(delay: 200.ms)
                            .slideY(begin: 0.1, end: 0),
                        const SizedBox(height: 8),
                        Text(
                              _searchQuery.isNotEmpty
                                  ? 'Try searching for something else'
                                  : 'Save tracks to see them here',
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.2),
                                fontSize: 14,
                              ),
                            )
                            .animate()
                            .fadeIn(delay: 400.ms)
                            .slideY(begin: 0.1, end: 0),
                      ],
                    ),
                  ),
                );
              }

              final tracks = dbTracks;

              return SliverPadding(
                padding: const EdgeInsets.only(bottom: 120),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, i) {
                    final track = tracks[i];
                    return TrackTile(
                          index: i + 1,
                          track: track,
                          onTap:
                              () => ref
                                  .read(playerProvider.notifier)
                                  .playTrack(track, queue: tracks),
                        )
                        .animate(delay: (i * 40).ms)
                        .fadeIn(duration: 600.ms)
                        .slideX(
                          begin: 0.08,
                          end: 0,
                          curve: Curves.easeOutCubic,
                        );
                  }, childCount: tracks.length),
                ),
              );
            },
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}
