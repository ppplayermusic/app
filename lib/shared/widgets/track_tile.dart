import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../shared/widgets/tactile_buttons.dart';
import '../../shared/widgets/premium_modals.dart';
import '../../core/player/player_provider.dart';
import '../../core/db/app_database.dart' as db;
import '../../core/models/track.dart' as model;
import 'package:flutter_animate/flutter_animate.dart';

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
                            width: 48, height: 48, color: Theme.of(context).colorScheme.surfaceContainerHighest),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.music_note, color: Theme.of(context).colorScheme.onSurfaceVariant),
                      )
                    : Container(
                        width: 48,
                        height: 48,
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        child: Icon(Icons.music_note,
                            color: Theme.of(context).colorScheme.onSurfaceVariant),
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
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
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
                        color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
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
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                  size: 20,
                  onTap: () {
                    ref.read(playerProvider.notifier).toggleFavorite(track);
                  },
                ).animate(target: track.isFavorite ? 1 : 0).scale(
                  begin: const Offset(1, 1),
                  end: const Offset(1.2, 1.2),
                  duration: 200.ms,
                  curve: Curves.easeOutBack,
                ).then().scale(
                  begin: const Offset(1.2, 1.2),
                  end: const Offset(1, 1),
                  duration: 150.ms,
                ),
                trailing ??
                    TactileIconButton(
                      icon: Icons.more_vert,
                      color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
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
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.1)),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  ListTile(
                    leading:
                        Icon(Icons.playlist_add, color: Theme.of(context).colorScheme.onSurfaceVariant),
                    title: Text('Add to Playlist',
                        style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                    onTap: () {
                      Navigator.of(context).pop();
                      TrackTile.showPlaylistPicker(context, ref, track);
                    },
                  ),
                  ListTile(
                    leading:
                        Icon(Icons.person_outline, color: Theme.of(context).colorScheme.onSurfaceVariant),
                    title: Text('Go to Artist',
                        style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                    onTap: () {
                      Navigator.of(context).pop();
                      context.push('/artist/${track.artistId}');
                    },
                  ),
                  if (track.albumId != null)
                    ListTile(
                      leading: Icon(Icons.album_outlined,
                          color: Theme.of(context).colorScheme.onSurfaceVariant),
                      title: Text('Go to Album',
                          style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                      onTap: () {
                        Navigator.of(context).pop();
                        context.push('/album/${track.albumId}');
                      },
                    ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
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
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) => Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.1)),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Consumer(
                builder: (context, ref, child) =>
                    FutureBuilder<List<db.Playlist>>(
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
                              color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                              'Add to Playlist',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                              child: Icon(Icons.add, color: Theme.of(context).colorScheme.onSurface),
                            ),
                            title: Text('Create New Playlist',
                                style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                            onTap: () {
                              Navigator.of(context).pop();
                              _showCreatePlaylistDialog(
                                  context, database, track);
                            },
                          ),
                          Divider(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.1)),
                          if (playlists.isEmpty)
                            Padding(
                              padding: const EdgeInsets.all(32),
                              child: Text(
                                'No playlists yet.',
                                style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
                              ),
                            ),
                          Flexible(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: playlists.length,
                              itemBuilder: (context, i) => ListTile(
                                leading: Icon(Icons.playlist_play,
                                    color: Theme.of(context).colorScheme.onSurfaceVariant),
                                title: Text(playlists[i].name,
                                    style:
                                        TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                                onTap: () async {
                                  await database.addToPlaylist(
                                      playlists[i].id, track.spotifyId);
                                  if (context.mounted) Navigator.of(context).pop();
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor:
                                            Theme.of(context).colorScheme.surfaceContainerHighest,
                                        content: Text(
                                            'Added to ${playlists[i].name}',
                                            style: TextStyle(
                                                color: Theme.of(context).colorScheme.onSurface)),
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
            ),
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
    showPremiumModal<void>(
      context: context,
      title: 'New Playlist',
      child: Builder(
        builder: (dialogContext) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              autofocus: true,
              style: TextStyle(color: Theme.of(dialogContext).colorScheme.onSurface, fontSize: 18),
              decoration: InputDecoration(
                hintText: 'My Awesome Playlist',
                hintStyle: TextStyle(color: Theme.of(dialogContext).colorScheme.onSurfaceVariant.withValues(alpha: 0.3)),
                filled: true,
                fillColor: Theme.of(dialogContext).colorScheme.onSurface.withValues(alpha: 0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: TactileTap(
                    onTap: () => Navigator.pop(dialogContext),
                    child: Container(
                      height: 54,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Theme.of(dialogContext).colorScheme.outlineVariant),
                      ),
                      child: Text('Cancel', style: TextStyle(color: Theme.of(dialogContext).colorScheme.onSurfaceVariant, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TactileTap(
                    onTap: () async {
                      final name = controller.text.trim();
                      if (name.isNotEmpty) {
                        final id = await database.createPlaylist(name);
                        await database.addToPlaylist(id, track.spotifyId);
                        if (dialogContext.mounted) {
                          Navigator.pop(dialogContext);
                        }
                      }
                    },
                    child: Container(
                      height: 54,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(dialogContext).colorScheme.primary,
                            Theme.of(dialogContext).colorScheme.primary.withValues(alpha: 0.7),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text('Create', style: TextStyle(color: Theme.of(dialogContext).colorScheme.onPrimary, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
