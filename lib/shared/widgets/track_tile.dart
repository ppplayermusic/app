import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../shared/widgets/tactile_buttons.dart';
import '../../core/player/player_provider.dart';
import '../../core/db/app_database.dart' as db;
import '../../core/models/track.dart' as model;

class TrackTile extends ConsumerWidget {
  const TrackTile({
    super.key,
    required this.track,
    required this.onTap,
    this.trailing,
    this.showImage = true,
    this.showSubtitle = true,
  });

  final model.Track track;
  final VoidCallback onTap;
  final Widget? trailing;
  final bool showImage;
  final bool showSubtitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TactileTap(
      onTap: onTap,
      scaleDown: 0.98,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
        child: Row(
          children: [
            if (showImage) ...[
              const SizedBox(width: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: track.albumImage != null
                    ? CachedNetworkImage(
                        imageUrl: track.albumImage!,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                            width: 48, height: 48, color: const Color(0xFF2A2A2A)),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.music_note, color: Color(0xFF6A6A6A)),
                      )
                    : Container(
                        width: 48,
                        height: 48,
                        color: const Color(0xFF2A2A2A),
                        child: const Icon(Icons.music_note,
                            color: Color(0xFF6A6A6A)),
                      ),
              ),
              const SizedBox(width: 16),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    track.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.2,
                    ),
                  ),
                  if (showSubtitle) ...[
                    const SizedBox(height: 4),
                    Text(
                      track.artistName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TactileIconButton(
                  icon: track.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: track.isFavorite
                      ? const Color(0xFF1DB954)
                      : Colors.white.withValues(alpha: 0.3),
                  size: 20,
                  onTap: () {
                    ref.read(playerProvider.notifier).toggleFavorite(track);
                  },
                ),
                trailing ??
                    TactileIconButton(
                      icon: Icons.more_vert,
                      color: Colors.white.withValues(alpha: 0.3),
                      size: 20,
                      onTap: () {
                        _showMoreMenu(context, ref);
                      },
                    ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showMoreMenu(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1F1F1F),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.all(8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.playlist_add, color: Colors.white70),
              title: const Text('Add to Playlist', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                TrackTile.showPlaylistPicker(context, ref, track);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_outline, color: Colors.white70),
              title: const Text('Go to Artist', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                context.push('/artist/${track.artistId}');
              },
            ),
            if (track.albumId != null)
              ListTile(
                leading: const Icon(Icons.album_outlined, color: Colors.white70),
                title: const Text('Go to Album', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  context.push('/album/${track.albumId}');
                },
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  static Future<void> showPlaylistPicker(
    BuildContext context,
    WidgetRef ref,
    model.Track track,
  ) async {
    final database = ref.read(db.appDatabaseProvider);

    if (context.mounted) {
      showModalBottomSheet(
        context: context,
        backgroundColor: const Color(0xFF1F1F1F),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) => Consumer(
          builder: (context, ref, child) => FutureBuilder<List<db.Playlist>>(
            future: database.getPlaylists(),
            builder: (context, snap) {
              final playlists = snap.data ?? [];
              return SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(8),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        'Add to Playlist',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Color(0xFF2A2A2A),
                        child: Icon(Icons.add, color: Colors.white),
                      ),
                      title: const Text('Create New Playlist',
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        Navigator.pop(context);
                        _showCreatePlaylistDialog(context, database, track);
                      },
                    ),
                    const Divider(color: Colors.white10),
                    if (playlists.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(32),
                        child: Text(
                          'No playlists yet.',
                          style: TextStyle(color: Colors.white54),
                        ),
                      ),
                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: playlists.length,
                        itemBuilder: (context, i) => ListTile(
                          leading: const Icon(Icons.playlist_play, color: Colors.white70),
                          title: Text(playlists[i].name,
                              style: const TextStyle(color: Colors.white)),
                          onTap: () async {
                            await database.addToPlaylist(playlists[i].id, track.spotifyId);
                            if (context.mounted) Navigator.pop(context);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: const Color(0xFF282828),
                                  content: Text('Added to ${playlists[i].name}',
                                      style: const TextStyle(color: Colors.white)),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    }
  }

  static Future<void> _showCreatePlaylistDialog(
    BuildContext context,
    db.AppDatabase database,
    model.Track track,
  ) async {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF282828),
        title: const Text('New Playlist', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'My Awesome Playlist',
            hintStyle: TextStyle(color: Colors.white24),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white24),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF1DB954)),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () async {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                final id = await database.createPlaylist(name);
                await database.addToPlaylist(id, track.spotifyId);
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: const Color(0xFF282828),
                      content: Text('Created $name and added track',
                          style: const TextStyle(color: Colors.white)),
                    ),
                  );
                }
              }
            },
            child: const Text('Create', style: TextStyle(color: Color(0xFF1DB954))),
          ),
        ],
      ),
    );
  }
}
