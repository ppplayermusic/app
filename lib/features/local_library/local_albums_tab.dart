import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'local_library_providers.dart';
import 'local_album_detail_screen.dart';

class LocalAlbumsTab extends ConsumerWidget {
  const LocalAlbumsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final albumsAsync = ref.watch(localAlbumsProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return albumsAsync.when(
      data: (albums) {
        if (albums.isEmpty) {
          final isSearching = ref.watch(localSearchQueryProvider).isNotEmpty;
          return Center(
            child: Text(
              isSearching ? 'No albums found' : 'No local albums',
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16).copyWith(bottom: 120),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.8, // Adjust for text below image
          ),
          itemCount: albums.length,
          itemBuilder: (context, index) {
            final album = albums[index];
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LocalAlbumDetailScreen(
                      albumGroupKey: album.albumGroupKey,
                      albumTitle: album.title,
                    ),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.album_rounded,
                        size: 64,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    album.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${album.trackCount} tracks',
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error: $e')),
    );
  }
}
