import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

import '../../core/db/app_database.dart';
import '../../core/models/track.dart' as model;
import '../../shared/widgets/tactile_buttons.dart';
import '../../shared/widgets/track_tile.dart';
import '../../core/player/player_provider.dart';

final localFolderContentsProvider = FutureProvider.family<List<model.Track>, String>((ref, rootLocator) async {
  return ref.watch(appDatabaseProvider).getFolderAppTracks(rootLocator);
});

class LocalFolderDetailScreen extends ConsumerWidget {
  final String rootLocator;
  final String currentPath;

  const LocalFolderDetailScreen({
    super.key,
    required this.rootLocator,
    required this.currentPath,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contentsAsync = ref.watch(localFolderContentsProvider(rootLocator));
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final folderUri = Uri.tryParse(currentPath) ?? Uri.file(currentPath);
    final folderName = folderUri.pathSegments.isNotEmpty ? folderUri.pathSegments.last : currentPath;

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
                      folderName,
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
              child: contentsAsync.when(
                data: (tracks) {
                  // Filter and organize items for currentPath
                  final Set<String> subfolders = {};
                  final List<model.Track> directTracks = [];
                  
                  for (final track in tracks) {
                    final filePath = track.localFilePath; // absolute path
                    if (filePath == null) continue;
                    
                    if (filePath.startsWith(currentPath)) {
                      final relativePath = filePath.substring(currentPath.length);
                      // Remove leading slash if any
                      final cleanRelative = relativePath.startsWith('/') || relativePath.startsWith(Platform.pathSeparator) 
                          ? relativePath.substring(1) 
                          : relativePath;
                          
                      final segments = cleanRelative.split(Platform.pathSeparator);
                      
                      if (segments.length == 1) {
                        // Direct file
                        directTracks.add(track);
                      } else {
                        // In a subfolder
                        subfolders.add(segments.first);
                      }
                    }
                  }

                  final subfolderList = subfolders.toList()..sort();
                  directTracks.sort((a, b) => a.name.compareTo(b.name));

                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 120),
                    itemCount: subfolderList.length + directTracks.length,
                    itemBuilder: (context, index) {
                      if (index < subfolderList.length) {
                        final subfolderName = subfolderList[index];
                        final subfolderPath = '$currentPath${Platform.pathSeparator}$subfolderName';
                        return ListTile(
                          leading: Icon(Icons.folder_outlined, color: colorScheme.primary),
                          title: Text(subfolderName, style: TextStyle(color: colorScheme.onSurface)),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => LocalFolderDetailScreen(
                                  rootLocator: rootLocator,
                                  currentPath: subfolderPath,
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        final trackIndex = index - subfolderList.length;
                        final track = directTracks[trackIndex];
                        return TrackTile(
                          index: trackIndex + 1,
                          track: track,
                          onTap: () {
                            ref.read(playerProvider.notifier).playTracks(
                              directTracks,
                              initialIndex: trackIndex,
                            );
                          },
                        );
                      }
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
