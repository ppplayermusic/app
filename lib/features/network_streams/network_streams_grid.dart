import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/db/app_database.dart';
import '../../core/network_streams/network_stream_service.dart';
import '../../shared/widgets/tactile_buttons.dart';
import '../../core/player/player_provider.dart';
import '../../shared/widgets/pp_image.dart';
import '../../shared/widgets/pp_logo_loader.dart';

class StreamPlaylistsSliverGrid extends ConsumerWidget {
  final bool showHeader;
  final String searchQuery;
  final bool sortByRecent;

  const StreamPlaylistsSliverGrid({
    super.key,
    this.showHeader = false,
    this.searchQuery = '',
    this.sortByRecent = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.watch(networkStreamServiceProvider);

    return StreamBuilder<List<StreamPlaylist>>(
      stream: service.watchPlaylists(),
      builder: (context, snap) {
        final isLoading = snap.connectionState == ConnectionState.waiting;
        var playlists = snap.data ?? [];

        if (searchQuery.isNotEmpty) {
          playlists = playlists
              .where(
                (p) =>
                    p.title.toLowerCase().contains(searchQuery.toLowerCase()),
              )
              .toList();
        }

        if (isLoading) {
          return const SliverToBoxAdapter(
            child: SizedBox(height: 120, child: Center(child: PPLogoLoader())),
          );
        }

        if (playlists.isEmpty) {
          if (searchQuery.isNotEmpty) {
            return const SliverToBoxAdapter(child: SizedBox.shrink());
          }
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        }

        return SliverMainAxisGroup(
          slivers: [
            if (showHeader)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'Network Streams',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ],
                  ),
                ),
              ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                delegate: SliverChildBuilderDelegate((context, i) {
                  final playlist = playlists[i];
                  return _StreamPlaylistCard(playlist: playlist);
                }, childCount: playlists.length),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _StreamPlaylistCard extends ConsumerWidget {
  final StreamPlaylist playlist;
  const _StreamPlaylistCard({required this.playlist});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Semantics(
      button: true,
      label: 'Network Stream: ${playlist.title}',
      hint: 'Double tap to open stream details',
      child: TactileTap(
        onTap: () {
          if (playlist.sourceKind == 'youtube_video' ||
              playlist.sourceKind == 'vimeo_video' ||
              playlist.sourceKind == 'dailymotion_video') {
            String groupTitle = 'Network Video';
            if (playlist.sourceKind == 'youtube_video') groupTitle = 'YouTube';
            if (playlist.sourceKind == 'vimeo_video') groupTitle = 'Vimeo';
            if (playlist.sourceKind == 'dailymotion_video')
              groupTitle = 'Dailymotion';

            final track = Track.fromNetworkStream(
              streamUrl: playlist.sourceUri,
              title: playlist.title,
              groupTitle: groupTitle,
              logoUrl: playlist.imageUrl,
            );
            ref.read(playerProvider.notifier).playTrack(track, queue: [track]);
          } else {
            context.push('/stream_playlist/${playlist.id}');
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(20),
                ),
                child:
                    playlist.imageUrl != null && playlist.imageUrl!.isNotEmpty
                    ? PPImage(
                        imageUrl: playlist.imageUrl!,
                        fit: BoxFit.cover,
                        borderRadius: BorderRadius.circular(20),
                      )
                    : Center(
                        child: Icon(
                          (playlist.sourceKind == 'youtube_video' ||
                                  playlist.sourceKind == 'vimeo_video' ||
                                  playlist.sourceKind == 'dailymotion_video')
                              ? Icons.play_circle_fill_rounded
                              : Icons.connected_tv_rounded,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              playlist.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            ),
            const SizedBox(height: 2),
            Text(
              (playlist.sourceKind == 'youtube_video' ||
                      playlist.sourceKind == 'vimeo_video' ||
                      playlist.sourceKind == 'dailymotion_video')
                  ? '${playlist.sourceKind.split('_').first.replaceFirst(playlist.sourceKind[0], playlist.sourceKind[0].toUpperCase())} Video'
                  : 'IPTV / Stream',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.6),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
