import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/db/app_database.dart';
import '../../core/network_streams/network_stream_service.dart';
import '../../core/player/player_provider.dart';
import '../../core/models/track.dart';
import '../../shared/widgets/pp_logo_loader.dart';

class StreamPlaylistDetailScreen extends ConsumerWidget {
  final int playlistId;

  const StreamPlaylistDetailScreen({super.key, required this.playlistId});

  void _editPlaylist(BuildContext context, WidgetRef ref, StreamPlaylist playlist) {
    final controller = TextEditingController(text: playlist.title);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Playlist'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Title'),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                ref.read(networkStreamServiceProvider).updatePlaylist(playlistId, controller.text.trim());
              }
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deletePlaylist(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Playlist'),
        content: const Text('Are you sure you want to delete this playlist?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
            onPressed: () {
              ref.read(networkStreamServiceProvider).deletePlaylist(playlistId);
              Navigator.pop(ctx);
              if (context.mounted) {
                context.pop();
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _editChannel(BuildContext context, WidgetRef ref, StreamChannel channel) {
    final titleController = TextEditingController(text: channel.title);
    final urlController = TextEditingController(text: channel.streamUrl);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Stream Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: urlController,
              decoration: const InputDecoration(labelText: 'Stream URL'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              if (titleController.text.trim().isNotEmpty && urlController.text.trim().isNotEmpty) {
                ref.read(networkStreamServiceProvider).updateChannel(
                      channel.id,
                      titleController.text.trim(),
                      urlController.text.trim(),
                    );
              }
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.watch(networkStreamServiceProvider);

    return StreamBuilder<StreamPlaylist>(
      stream: service.watchPlaylist(playlistId),
      builder: (context, playlistSnap) {
        final playlist = playlistSnap.data;
        if (playlist == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Network Stream')),
            body: const Center(child: PPLogoLoader()),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(playlist.title),
            actions: [
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    _editPlaylist(context, ref, playlist);
                  } else if (value == 'delete') {
                    _deletePlaylist(context, ref);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 20),
                        SizedBox(width: 8),
                        Text('Edit Playlist'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 20, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete Playlist', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: StreamBuilder<List<StreamChannel>>(
            stream: service.watchChannelsForPlaylist(playlistId),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: PPLogoLoader());
              }
              final channels = snap.data ?? [];
              if (channels.isEmpty) {
                return const Center(child: Text('No channels found.'));
              }

              return ListView.builder(
                itemCount: channels.length,
                itemBuilder: (context, index) {
                  final channel = channels[index];
                  return Dismissible(
                    key: ValueKey(channel.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (direction) {
                      service.deleteChannel(channel.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Deleted ${channel.title}')),
                      );
                    },
                    child: ListTile(
                      leading: channel.logo != null
                          ? Image.network(
                              channel.logo!,
                              width: 48,
                              height: 48,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.connected_tv),
                            )
                          : const Icon(Icons.connected_tv),
                      title: Text(channel.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: channel.groupTitle != null
                          ? Text(channel.groupTitle!, maxLines: 1, overflow: TextOverflow.ellipsis)
                          : null,
                      trailing: IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        onPressed: () => _editChannel(context, ref, channel),
                      ),
                      onTap: () {
                        final track = Track.fromNetworkStream(
                          streamUrl: channel.streamUrl,
                          title: channel.title,
                          liveStatus: StreamLiveStatus.fromValue(
                            channel.liveStatus,
                          ), // Don't assume live
                          groupTitle: channel.groupTitle ?? 'IPTV',
                          logoUrl: channel.logo,
                        );

                        ref
                            .read(playerProvider.notifier)
                            .playTrack(track, queue: [track]);
                      },
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
