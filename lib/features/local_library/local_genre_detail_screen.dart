import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/db/app_database.dart';

import '../../core/player/player_provider.dart';
import '../../shared/widgets/tactile_buttons.dart';
import '../../shared/widgets/track_tile.dart';

final localGenreTracksProvider = FutureProvider.family<List<Track>, String>((ref, genre) {
  return ref.watch(appDatabaseProvider).getGenreAppTracks(genre);
});

class LocalGenreDetailScreen extends ConsumerWidget {
  final String genre;

  const LocalGenreDetailScreen({
    super.key,
    required this.genre,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracksAsync = ref.watch(localGenreTracksProvider(genre));
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  TactileIconButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      genre,
                      style: textTheme.titleLarge?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (tracksAsync.value?.isNotEmpty == true)
                    TactileIconButton(
                      icon: Icons.queue_music_rounded,
                      onTap: () {
                        final tracks = tracksAsync.value!;
                        ref.read(playerProvider.notifier).addTracksToQueue(tracks);
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Added to queue'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
            Expanded(
              child: tracksAsync.when(
                data: (tracks) {
                  if (tracks.isEmpty) {
                    return Center(
                      child: Text(
                        'No tracks',
                        style: TextStyle(color: colorScheme.onSurfaceVariant),
                      ),
                    );
                  }
                  
                  return CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                          child: Row(
                            children: [
                              Expanded(
                                child: FilledButton.icon(
                                  onPressed: () {
                                    ref.read(playerProvider.notifier).playTracks(
                                      tracks,
                                      initialIndex: 0,
                                      contextArtistId: 'local_genre_$genre',
                                    );
                                  },
                                  icon: const Icon(Icons.play_arrow_rounded),
                                  label: const Text('Play All'),
                                  style: FilledButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: FilledButton.tonalIcon(
                                  onPressed: () {
                                    ref.read(playerProvider.notifier).shuffleAndPlay(
                                      tracks,
                                      contextArtistId: 'local_genre_$genre',
                                    );
                                  },
                                  icon: const Icon(Icons.shuffle_rounded),
                                  label: const Text('Shuffle'),
                                  style: FilledButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.only(bottom: 120),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return TrackTile(
                                index: index + 1,
                                track: tracks[index],
                                onTap: () {
                                  ref.read(playerProvider.notifier).playTracks(
                                    tracks,
                                    initialIndex: index,
                                    contextArtistId: 'local_genre_$genre',
                                  );
                                },
                              );
                            },
                            childCount: tracks.length,
                          ),
                        ),
                      ),
                    ],
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, st) => Center(child: Text('Error: $e')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
