import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/app_database.dart';
import '../../core/models/track.dart' as model;
import '../../shared/widgets/tactile_buttons.dart';
import '../../shared/widgets/track_tile.dart';
import '../../core/player/player_provider.dart';

final localArtistTracksProvider = FutureProvider.family<List<model.Track>, String>((ref, artistName) async {
  return ref.watch(appDatabaseProvider).getArtistAppTracks(artistName);
});

class LocalArtistDetailScreen extends ConsumerWidget {
  final String artistName;

  const LocalArtistDetailScreen({
    super.key,
    required this.artistName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracksAsync = ref.watch(localArtistTracksProvider(artistName));
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
                      artistName,
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
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
                          ref.read(playerProvider.notifier).playTracks(
                            tracks,
                            initialIndex: index,
                          );
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
