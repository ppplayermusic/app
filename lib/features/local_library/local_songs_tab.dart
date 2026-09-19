import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ppplayer/l10n/app_localizations.dart';

import '../../core/player/player_provider.dart';
import '../../shared/widgets/track_tile.dart';
import 'local_library_providers.dart';

class LocalSongsTab extends ConsumerWidget {
  const LocalSongsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songsAsync = ref.watch(sortedLocalSongsProvider);
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return songsAsync.when(
      data: (tracks) {
        if (tracks.isEmpty) {
          final isSearching = ref.watch(localSearchQueryProvider).isNotEmpty;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.audio_file_outlined,
                  size: 64,
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  isSearching ? 'No songs found' : l10n.noLocalSongs,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            _SortHeader(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 120, top: 8),
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
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error: $e')),
    );
  }
}

class _SortHeader extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sortOption = ref.watch(localSortOptionProvider);
    final isAscending = ref.watch(localSortAscendingProvider);
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    String getSortName(LocalSortOption option) {
      switch (option) {
        case LocalSortOption.title:
          return l10n.sortTitle;
        case LocalSortOption.artist:
          return l10n.sortArtist;
        case LocalSortOption.album:
          return l10n.sortAlbum;
        case LocalSortOption.duration:
          return l10n.sortDuration;
        case LocalSortOption.dateAdded:
          return l10n.sortDateAdded;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          PopupMenuButton<LocalSortOption>(
            initialValue: sortOption,
            onSelected: (option) =>
                ref.read(localSortOptionProvider.notifier).update(option),
            color: colorScheme.surfaceContainerHighest,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            itemBuilder: (context) => LocalSortOption.values.map((option) {
              return PopupMenuItem(
                value: option,
                child: Text(getSortName(option)),
              );
            }).toList(),
            child: Row(
              children: [
                const Icon(Icons.sort_rounded, size: 20),
                const SizedBox(width: 8),
                Text(
                  getSortName(sortOption),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          InkWell(
            onTap: () => ref
                .read(localSortAscendingProvider.notifier)
                .update(!isAscending),
            child: Icon(
              isAscending
                  ? Icons.arrow_upward_rounded
                  : Icons.arrow_downward_rounded,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
