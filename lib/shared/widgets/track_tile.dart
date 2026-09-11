import 'package:flutter/material.dart';
import 'pp_image.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/widgets/tactile_buttons.dart';
import '../../shared/widgets/premium_modals.dart';
import '../../core/db/app_database.dart' as db;
import '../../core/services/favorites_provider.dart';
import '../../core/models/track.dart' as model;
import 'package:flutter_animate/flutter_animate.dart';
import '../../shared/widgets/adaptive_blur.dart';
import '../../shared/widgets/artists_links.dart';
import 'context_menu/content_context_menu.dart';
import '../../core/player/player_provider.dart';
import '../../shared/widgets/animated_equalizer.dart';

class TrackTile extends ConsumerStatefulWidget {
  const TrackTile({
    super.key,
    required this.track,
    required this.onTap,
    this.index,
    this.trailing,
    this.showImage = true,
    this.showSubtitle = true,
    this.showMore = true,
    this.isActive,
    this.margin,
    this.padding,
  });

  final model.Track track;
  final VoidCallback onTap;
  final int? index;
  final Widget? trailing;
  final bool showImage;
  final bool showSubtitle;
  final bool showMore;
  final bool? isActive;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  @override
  ConsumerState<TrackTile> createState() => _TrackTileState();

  static void showMoreMenu(
    BuildContext context,
    WidgetRef ref,
    model.Track track, [
    Offset? position,
  ]) {
    final screenSize = MediaQuery.of(context).size;
    final pos =
        position ??
        Offset(screenSize.width / 2 - 115, screenSize.height / 2 - 150);
    showContentContextMenu(
      context,
      ref,
      position: pos,
      target: TrackContextTarget(track),
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
        builder:
            (context) => Container(
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.surface.withValues(alpha: 0.8),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(32),
                ),
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.outlineVariant.withValues(alpha: 0.1),
                ),
              ),
              child: AdaptiveBlur(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(32),
                ),
                sigmaX: 20,
                sigmaY: 20,
                child: Consumer(
                  builder:
                      (context, ref, child) => FutureBuilder<List<db.Playlist>>(
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
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant
                                        .withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  child: Text(
                                    'Add to Playlist',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                    ),
                                  ),
                                ),
                                ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor:
                                        Theme.of(
                                          context,
                                        ).colorScheme.surfaceContainerHighest,
                                    child: Icon(
                                      Icons.add,
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                    ),
                                  ),
                                  title: Text(
                                    'Create New Playlist',
                                    style: TextStyle(
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    _showCreatePlaylistDialog(
                                      context,
                                      database,
                                      track,
                                    );
                                  },
                                ),
                                Divider(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .outlineVariant
                                      .withValues(alpha: 0.1),
                                ),
                                if (playlists.isEmpty)
                                  Padding(
                                    padding: const EdgeInsets.all(32),
                                    child: Text(
                                      'No playlists yet.',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant
                                            .withValues(alpha: 0.5),
                                      ),
                                    ),
                                  ),
                                Flexible(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: playlists.length,
                                    itemBuilder:
                                        (context, i) => ListTile(
                                          leading: Icon(
                                            Icons.playlist_play,
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.onSurfaceVariant,
                                          ),
                                          title: Text(
                                            playlists[i].name,
                                            style: TextStyle(
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.onSurface,
                                            ),
                                          ),
                                          onTap: () async {
                                            await database.addToPlaylist(
                                              playlists[i].id,
                                              track.spotifyId,
                                            );
                                            if (context.mounted)
                                              Navigator.of(context).pop();
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .surfaceContainerHighest,
                                                  content: Text(
                                                    'Added to ${playlists[i].name}',
                                                    style: TextStyle(
                                                      color:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .onSurface,
                                                    ),
                                                  ),
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
        builder:
            (dialogContext) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                  autofocus: true,
                  style: TextStyle(
                    color: Theme.of(dialogContext).colorScheme.onSurface,
                    fontSize: 18,
                  ),
                  decoration: InputDecoration(
                    hintText: 'My Awesome Playlist',
                    hintStyle: TextStyle(
                      color: Theme.of(
                        dialogContext,
                      ).colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                    ),
                    filled: true,
                    fillColor: Theme.of(
                      dialogContext,
                    ).colorScheme.onSurface.withValues(alpha: 0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
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
                            border: Border.all(
                              color:
                                  Theme.of(
                                    dialogContext,
                                  ).colorScheme.outlineVariant,
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color:
                                  Theme.of(
                                    dialogContext,
                                  ).colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
                                Theme.of(
                                  dialogContext,
                                ).colorScheme.primary.withValues(alpha: 0.7),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            'Create',
                            style: TextStyle(
                              color:
                                  Theme.of(dialogContext).colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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

class _TrackTileState extends ConsumerState<TrackTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final currentTrack = ref.watch(
      playerProvider.select((s) => s.currentTrack),
    );
    final effectiveIsActive =
        widget.isActive ??
        (currentTrack != null &&
            ((currentTrack.spotifyId.isNotEmpty &&
                    currentTrack.spotifyId == widget.track.spotifyId) ||
                (currentTrack.name.toLowerCase() ==
                        widget.track.name.toLowerCase() &&
                    currentTrack.artistName.toLowerCase() ==
                        widget.track.artistName.toLowerCase())));

    return ContentContextMenuRegion(
      target: TrackContextTarget(widget.track),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: TactileTap(
          onTap: widget.onTap,
          scaleDown: 0.98,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            margin:
                widget.margin ??
                const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            padding:
                widget.padding ??
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color:
                  effectiveIsActive
                      ? colorScheme.primary.withValues(alpha: 0.10)
                      : (_isHovered
                          ? colorScheme.onSurface.withValues(alpha: 0.04)
                          : Colors.transparent),
              border: Border.all(
                color:
                    effectiveIsActive
                        ? colorScheme.primary.withValues(alpha: 0.35)
                        : (_isHovered
                            ? colorScheme.onSurface.withValues(alpha: 0.06)
                            : Colors.transparent),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                if (widget.index != null) ...[
                  SizedBox(
                    width: 32,
                    child:
                        effectiveIsActive
                            ? Center(
                              child: AnimatedEqualizer(
                                color: colorScheme.primary,
                              ),
                            )
                            : Text(
                              widget.index.toString().padLeft(2, '0'),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: colorScheme.onSurface.withValues(
                                  alpha: 0.22,
                                ),
                                fontSize: 13,
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                              ),
                            ),
                  ),
                  const SizedBox(width: 8),
                ],
                if (widget.showImage) ...[
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child:
                            widget.track.albumImage != null
                                ? PPImage(
                                  imageUrl: widget.track.albumImage!,
                                  width: 46,
                                  height: 46,
                                  fit: BoxFit.cover,
                                )
                                : Container(
                                  width: 46,
                                  height: 46,
                                  color: colorScheme.surfaceContainerHighest,
                                  child: Icon(
                                    Icons.music_note,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                      ),
                      if (widget.index == null && effectiveIsActive)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.55),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Center(
                              child: AnimatedEqualizer(
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 14),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.track.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color:
                              effectiveIsActive
                                  ? colorScheme.primary
                                  : colorScheme.onSurface,
                          fontSize: 15,
                          fontWeight:
                              effectiveIsActive
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                          letterSpacing: -0.2,
                        ),
                      ),
                      if (widget.showSubtitle) ...[
                        const SizedBox(height: 3),
                        ArtistsLinks(
                          track: widget.track,
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant.withValues(
                              alpha: 0.7,
                            ),
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
                    Consumer(
                      builder: (context, ref, child) {
                        final isFav =
                            ref
                                .watch(
                                  favoritesStatusProvider((
                                    FavoriteType.track,
                                    widget.track.spotifyId,
                                  )),
                                )
                                .value ??
                            widget.track.isFavorite;
                        return TactileIconButton(
                              icon:
                                  isFav
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                              color:
                                  isFav
                                      ? colorScheme.primary
                                      : colorScheme.onSurfaceVariant.withValues(
                                        alpha: 0.4,
                                      ),
                              size: 20,
                              onTap: () {
                                ref
                                    .read(favoritesControllerProvider.notifier)
                                    .toggleTrackFavorite(widget.track, isFav);
                              },
                            )
                            .animate(target: isFav ? 1 : 0)
                            .scale(
                              begin: const Offset(1, 1),
                              end: const Offset(1.2, 1.2),
                              duration: 200.ms,
                              curve: Curves.easeOutBack,
                            )
                            .then()
                            .scale(
                              begin: const Offset(1.2, 1.2),
                              end: const Offset(1, 1),
                              duration: 150.ms,
                            );
                      },
                    ),
                    if (widget.showMore)
                      widget.trailing ??
                          Builder(
                            builder:
                                (btnContext) => TactileIconButton(
                                  icon: Icons.more_vert,
                                  color: colorScheme.onSurfaceVariant
                                      .withValues(alpha: 0.4),
                                  size: 20,
                                  onTap: () {
                                    final renderBox =
                                        btnContext.findRenderObject()
                                            as RenderBox?;
                                    final offset = renderBox?.localToGlobal(
                                      Offset.zero,
                                    );
                                    TrackTile.showMoreMenu(
                                      context,
                                      ref,
                                      widget.track,
                                      offset != null
                                          ? offset +
                                              Offset(0, renderBox!.size.height)
                                          : null,
                                    );
                                  },
                                ),
                          ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
