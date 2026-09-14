import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'local_library_providers.dart';
import 'local_folder_detail_screen.dart';

class LocalFoldersTab extends ConsumerWidget {
  const LocalFoldersTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foldersAsync = ref.watch(localFoldersProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return foldersAsync.when(
      data: (folders) {
        if (folders.isEmpty) {
          return Center(
            child: Text(
              'No folders imported',
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 120, top: 16),
          itemCount: folders.length,
          itemBuilder: (context, index) {
            final folder = folders[index];
            return ListTile(
              leading: Icon(Icons.folder_rounded, color: colorScheme.primary, size: 40),
              title: Text(
                folder.name,
                style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                folder.path,
                style: TextStyle(color: colorScheme.onSurfaceVariant),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LocalFolderDetailScreen(
                      rootLocator: folder.path,
                      currentPath: folder.path,
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
