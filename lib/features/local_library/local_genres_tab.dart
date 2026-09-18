import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ppplayer/l10n/app_localizations.dart';
import 'local_library_providers.dart';
import 'local_genre_detail_screen.dart';

class LocalGenresTab extends ConsumerWidget {
  const LocalGenresTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final genresAsync = ref.watch(localGenresProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return genresAsync.when(
      data: (genres) {
        if (genres.isEmpty) {
          return Center(
            child: Text(
              l10n.noLocalGenres,
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 120),
          itemCount: genres.length,
          itemBuilder: (context, index) {
            final genre = genres[index];
            final count = genre.trackCount;
            return ListTile(
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.style_rounded, color: colorScheme.primary),
              ),
              title: Text(genre.name, maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle: Text('$count ${count == 1 ? 'track' : 'tracks'}'),
              trailing: Icon(Icons.chevron_right_rounded, color: colorScheme.onSurfaceVariant),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LocalGenreDetailScreen(
                      genre: genre.name,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error: $e')),
    );
  }
}
