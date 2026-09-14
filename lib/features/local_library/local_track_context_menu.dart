import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/track.dart' as model;
import '../../core/player/player_provider.dart';
import 'local_artist_detail_screen.dart';
import 'local_album_detail_screen.dart';

void showLocalTrackContextMenu(BuildContext context, WidgetRef ref, model.Track track) {
  final colorScheme = Theme.of(context).colorScheme;
  
  showModalBottomSheet(
    context: context,
    backgroundColor: colorScheme.surfaceContainerHighest,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Icon(Icons.audio_file_outlined, size: 48, color: colorScheme.primary),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          track.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          track.artistName,
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.playlist_play_rounded),
              title: const Text('Play Next'),
              onTap: () {
                Navigator.pop(context);
                ref.read(playerProvider.notifier).playNext(track);
              },
            ),
            ListTile(
              leading: const Icon(Icons.queue_music_rounded),
              title: const Text('Add to Queue'),
              onTap: () {
                Navigator.pop(context);
                ref.read(playerProvider.notifier).addToQueue(track);
              },
            ),
            if (track.artistName.isNotEmpty)
              ...track.artistName.split(', ').map((artist) => ListTile(
                leading: const Icon(Icons.person_outline_rounded),
                title: Text('Go to $artist'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LocalArtistDetailScreen(artistName: artist),
                    ),
                  );
                },
              )),
            if (track.albumName?.isNotEmpty == true)
              ListTile(
                leading: const Icon(Icons.album_outlined),
                title: const Text('Go to Album'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LocalAlbumDetailScreen(
                        albumGroupKey: track.localAlbumGroupKey ?? track.albumName!,
                        albumTitle: track.albumName!,
                      ),
                    ),
                  );
                },
              ),
            const SizedBox(height: 16),
          ],
        ),
      );
    },
  );
}
