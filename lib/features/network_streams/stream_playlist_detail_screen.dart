import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/db/app_database.dart';
import '../../core/network_streams/network_stream_service.dart';
import '../../core/player/player_provider.dart';
import '../../core/models/track.dart';

class StreamPlaylistDetailScreen extends ConsumerWidget {
  final int playlistId;

  const StreamPlaylistDetailScreen({super.key, required this.playlistId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.watch(networkStreamServiceProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Network Stream')),
      body: StreamBuilder<List<StreamChannel>>(
        stream: service.watchChannelsForPlaylist(playlistId),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final channels = snap.data ?? [];
          if (channels.isEmpty) {
            return const Center(child: Text('No channels found.'));
          }

          return ListView.builder(
            itemCount: channels.length,
            itemBuilder: (context, index) {
              final channel = channels[index];
              return ListTile(
                leading: channel.logo != null
                    ? Image.network(
                        channel.logo!,
                        width: 48,
                        height: 48,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.connected_tv),
                      )
                    : const Icon(Icons.connected_tv),
                title: Text(channel.title),
                subtitle: channel.groupTitle != null
                    ? Text(channel.groupTitle!)
                    : null,
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
              );
            },
          );
        },
      ),
    );
  }
}
