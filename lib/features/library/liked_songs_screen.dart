import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/db/app_database.dart' as db;
import '../../core/models/track.dart' as model;
import '../../core/player/player_provider.dart';
import '../../shared/widgets/track_tile.dart';
import '../../shared/widgets/tactile_buttons.dart';

class LikedSongsScreen extends ConsumerWidget {
  const LikedSongsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final database = ref.watch(db.appDatabaseProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Liked Songs',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF450af5), Color(0xFF121212)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.favorite, color: Colors.white, size: 80),
                      const SizedBox(height: 16),
                      FutureBuilder<List<db.Track>>(
                        future: database.getFavorites(),
                        builder: (context, snap) {
                          final count = snap.data?.length ?? 0;
                          return Text(
                            '$count songs',
                            style: const TextStyle(color: Colors.white70),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                   Text(
                    'Playlist • Favorite Songs',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  TactileIconButton(
                    icon: Icons.shuffle_rounded,
                    color: Colors.white70,
                    size: 24,
                    onTap: () async {
                      final tracks = await database.getFavorites();
                      if (tracks.isNotEmpty && context.mounted) {
                        final modelTracks = tracks.map(model.Track.fromDb).toList()..shuffle();
                        ref.read(playerProvider.notifier).playTrack(modelTracks.first, queue: modelTracks);
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                  TactileActionPlayButton(
                    size: 56,
                    onTap: () async {
                      final tracks = await database.getFavorites();
                      if (tracks.isNotEmpty && context.mounted) {
                        final modelTracks = tracks.map(model.Track.fromDb).toList();
                        ref.read(playerProvider.notifier).playTrack(modelTracks.first, queue: modelTracks);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          FutureBuilder<List<db.Track>>(
            future: database.getFavorites(),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
              }
              final tracks = snap.data ?? [];
              if (tracks.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(
                    child: Text('No liked songs yet.', style: TextStyle(color: Colors.white54)),
                  ),
                );
              }
              return SliverPadding(
                padding: const EdgeInsets.only(bottom: 120),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) {
                      final track = model.Track.fromDb(tracks[i]);
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 32,
                              child: Text(
                                '${i + 1}',
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
                                      queue: tracks.map(model.Track.fromDb).toList(),
                                    ),
                              ),
                            ),
                          ],
                        ),
                      );
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
