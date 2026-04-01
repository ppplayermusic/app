import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api/spotify_client.dart';
import '../../core/player/player_provider.dart';
import '../../shared/widgets/banner_ad_widget.dart';
import '../../shared/widgets/track_tile.dart';

final spotifyPlaylistTracksProvider = FutureProvider.family<List<Track>, String>((ref, id) async {
  final client = ref.read(spotifyClientProvider);
  return client.getPlaylistTracks(id, limit: 50);
});

class SpotifyPlaylistScreen extends ConsumerWidget {
  final String playlistId;
  final String? playlistName;

  const SpotifyPlaylistScreen({
    super.key,
    required this.playlistId,
    this.playlistName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracksAsync = ref.watch(spotifyPlaylistTracksProvider(playlistId));

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(playlistName ?? 'Playlist'),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF535353), Color(0xFF121212)],
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.playlist_play, size: 80, color: Colors.white24),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: BannerAdWidget(),
            ),
          ),
          tracksAsync.when(
            data: (tracks) => SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final track = tracks[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 32,
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: 14,
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TrackTile(
                            track: track,
                            onTap: () => ref.read(playerProvider.notifier).playTrack(
                                  track,
                                  queue: tracks,
                                ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                childCount: tracks.length,
              ),
            ),
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => SliverFillRemaining(
              child: Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
      floatingActionButton: tracksAsync.when(
        data: (tracks) => tracks.isEmpty
            ? null
            : FloatingActionButton.extended(
                onPressed: () => ref.read(playerProvider.notifier).playTrack(
                      tracks.first,
                      queue: tracks,
                    ),
                label: const Text('Play All'),
                icon: const Icon(Icons.play_arrow),
                backgroundColor: const Color(0xFF1DB954),
                foregroundColor: Colors.white,
              ),
        loading: () => null,
        error: (_, _) => null,
      ),
    );
  }
}
