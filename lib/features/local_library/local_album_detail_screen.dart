import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/app_database.dart';
import '../../core/models/track.dart' as model;
import '../../shared/widgets/tactile_buttons.dart';
import '../../shared/widgets/track_tile.dart';
import '../../core/player/player_provider.dart';

final localAlbumTracksProvider =
    FutureProvider.family<List<model.Track>, String>((
      ref,
      albumGroupKey,
    ) async {
      return ref.watch(appDatabaseProvider).getAlbumAppTracks(albumGroupKey);
    });

class LocalAlbumDetailScreen extends ConsumerWidget {
  final String albumGroupKey;
  final String albumTitle;

  const LocalAlbumDetailScreen({
    super.key,
    required this.albumGroupKey,
    required this.albumTitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracksAsync = ref.watch(localAlbumTracksProvider(albumGroupKey));
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
                      albumTitle,
                      style: textTheme.titleLarge?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: tracksAsync.when(
                data: (tracks) {
                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 120),
                    itemCount: tracks.length,
                    itemBuilder: (context, index) {
                      final track = tracks[index];
                      return TrackTile(
                        index: index + 1,
                        track: track,
                        onTap: () {
                          ref
                              .read(playerProvider.notifier)
                              .playTracks(tracks, initialIndex: index);
                        },
                      );
                    },
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
