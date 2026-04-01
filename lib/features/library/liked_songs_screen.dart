import 'package:flutter/material.dart';
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
      backgroundColor: Colors.black,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: _isSearching ? kToolbarHeight : 300,
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
            title: _isSearching
                ? Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                    ),
                    child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                        cursorColor: Colors.white70,
                        decoration: InputDecoration(
                          hintText: 'Search liked songs...',
                          hintStyle: TextStyle(
                              color: Colors.white.withValues(alpha: 0.4),
                              fontSize: 15),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value.toLowerCase();
                          });
                        },
                      ),
                  ).animate().fadeIn().scale(begin: const Offset(0.95, 1))
                : null,
            flexibleSpace: _isSearching
                ? ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Container(
                        color: Colors.black.withValues(alpha: 0.6),
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
                                'Liked Songs',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: isCollapsed ? 18 : 32,
                                  letterSpacing: -1.0,
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
                                        Color(0xFF450af5),
                                        Color(0xFF2d0087),
                                        Color(0xFF121212)
                                      ],
                                      stops: [0.0, 0.4, 1.0],
                                    ),
                                  ),
                                  child: Center(
                                    child: const Icon(Icons.favorite,
                                            color: Colors.white10, size: 140)
                                        .animate(
                                            onPlay: (controller) =>
                                                controller.repeat(reverse: true))
                                        .scale(
                                            begin: const Offset(1, 1),
                                            end: const Offset(1.15, 1.15),
                                            duration: 3.seconds,
                                            curve: Curves.easeInOut)
                                        .blurXY(begin: 0, end: 10, duration: 3.seconds),
                                  ),
                                ),
                                // Lush Premium Gradient Overlay
                                const DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Color(0x22000000),
                                        Color(0x77000000),
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
                    FutureBuilder<List<db.Track>>(
                      future: database.getFavorites(),
                      builder: (context, snap) {
                        final count = snap.data?.length ?? 0;
                        return Text(
                          '$count tracks stored locally',
                          style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.35),
                              fontSize: 12,
                              letterSpacing: 0.5,
                              fontWeight: FontWeight.w600),
                        );
                      },
                    ).animate().fadeIn(duration: 400.ms),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: TactileTap(
                            onTap: () async {
                              final tracks = await database.getFavorites();
                              if (tracks.isNotEmpty && context.mounted) {
                                final modelTracks =
                                    tracks.map(model.Track.fromDb).toList();
                                ref
                                    .read(playerProvider.notifier)
                                    .playTracks(modelTracks);
                              }
                            },
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF450af5), Color(0xFF2d0087)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF450af5).withValues(alpha: 0.3),
                                    blurRadius: 15,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.play_arrow_rounded,
                                        color: Colors.white, size: 32),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'PLAY ALL',
                                      style: TextStyle(
                                        color: Colors.white,
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
                            final tracks = await database.getFavorites();
                            if (tracks.isNotEmpty && context.mounted) {
                              final modelTracks =
                                  tracks.map(model.Track.fromDb).toList();
                              final notifier = ref.read(playerProvider.notifier);
                              
                              if (!ref.read(playerProvider).isShuffled) {
                                notifier.toggleShuffle();
                              }
                              
                              // Shuffle the list locally or just play with shuffle enabled
                              final List<model.Track> shuffledList = List.from(modelTracks)..shuffle();
                              notifier.playTracks(shuffledList);
                            }
                          },
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.1),
                              ),
                            ),
                            child: const Icon(
                              Icons.shuffle_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        TactileIconButton(
                          icon: Icons.more_vert_rounded,
                          color: Colors.white70,
                          backgroundColor: Colors.white.withValues(alpha: 0.05),
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
          FutureBuilder<List<db.Track>>(
            future: database.getFavorites(),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator(color: Color(0xFF1DB954))));
              }
              var dbTracks = snap.data ?? [];
              
              if (_searchQuery.isNotEmpty) {
                dbTracks = dbTracks.where((t) {
                  final name = t.name.toLowerCase();
                  final artist = t.artistName.toLowerCase();
                  return name.contains(_searchQuery) || artist.contains(_searchQuery);
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
                            color: Colors.white.withValues(alpha: 0.03),
                          ),
                          child: Icon(
                            _searchQuery.isNotEmpty ? Icons.search_off_rounded : Icons.favorite_rounded,
                            size: 64,
                            color: Colors.white10,
                          ),
                        )
                        .animate(onPlay: (c) => c.repeat(reverse: true))
                        .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 2.seconds)
                        .fadeIn(duration: 600.ms),
                        const SizedBox(height: 32),
                        Text(
                          _searchQuery.isNotEmpty 
                            ? 'Nothing matches your vibe'
                            : 'Your collection is quiet',
                          style: const TextStyle(
                            color: Colors.white38,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),
                        const SizedBox(height: 8),
                        Text(
                          _searchQuery.isNotEmpty 
                            ? 'Try searching for something else'
                            : 'Save tracks to see them here',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.2),
                            fontSize: 14,
                          ),
                        ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0),
                      ],
                    ),
                  ),
                );
              }

              final tracks = dbTracks.map(model.Track.fromDb).toList();

              return SliverPadding(
                padding: const EdgeInsets.only(bottom: 120),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) {
                      final track = tracks[i];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 2),
                        child: Row(
                            children: [
                            SizedBox(
                              width: 32,
                              child: Text(
                                '${i + 1}',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  fontSize: 13,
                                  fontFamily: 'monospace',
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -1.0,
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
                                      queue: tracks,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ).animate(delay: (i * 40).ms).fadeIn(duration: 600.ms).slideX(begin: 0.08, end: 0, curve: Curves.easeOutCubic);
                    },
                    childCount: tracks.length,
                  ),
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

