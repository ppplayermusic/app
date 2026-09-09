import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/api/spotify_repository.dart';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/db/app_database.dart' as db;
import '../../../core/player/player_provider.dart';
import '../../../core/services/favorites_provider.dart';
import '../premium_modals.dart';
import '../tactile_buttons.dart';
import '../track_tile.dart';

// ==========================================
// 1. CONTEXT MENU TARGET ABSTRACTIONS
// ==========================================

sealed class ContextMenuTarget {
  const ContextMenuTarget();
}

class TrackContextTarget extends ContextMenuTarget {
  final Track track;
  final bool isInQueue;
  final int? queueIndex;

  const TrackContextTarget(
    this.track, {
    this.isInQueue = false,
    this.queueIndex,
  });
}

class AlbumContextTarget extends ContextMenuTarget {
  final String id;
  final String name;
  final String artistId;
  final String artistName;
  final String? imageUrl;

  const AlbumContextTarget({
    required this.id,
    required this.name,
    this.artistId = '',
    required this.artistName,
    this.imageUrl,
  });
}

class PlaylistContextTarget extends ContextMenuTarget {
  final String id;
  final String name;
  final String? imageUrl;
  final bool isLocal;
  final int? localId;
  final String? ownerName;

  const PlaylistContextTarget({
    required this.id,
    required this.name,
    this.imageUrl,
    this.isLocal = false,
    this.localId,
    this.ownerName,
  });
}

class ArtistContextTarget extends ContextMenuTarget {
  final String id;
  final String name;
  final String? imageUrl;

  const ArtistContextTarget({
    required this.id,
    required this.name,
    this.imageUrl,
  });
}

class RadioContextTarget extends ContextMenuTarget {
  final String seedId;
  final String seedType;
  final String title;
  final String? imageUrl;

  const RadioContextTarget({
    required this.seedId,
    required this.seedType,
    required this.title,
    this.imageUrl,
  });
}

// ==========================================
// 2. REUSABLE GESTURE WRAPPER REGION
// ==========================================

/// Transparently wraps any widget and handles right-clicks (`onSecondaryTapDown`)
/// and long-presses to show the type-aware contextual menu.
class ContentContextMenuRegion extends ConsumerWidget {
  const ContentContextMenuRegion({
    super.key,
    required this.target,
    required this.child,
    this.enabled = true,
  });

  final ContextMenuTarget target;
  final Widget child;
  final bool enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!enabled) return child;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onSecondaryTapDown: (details) {
        showContentContextMenu(
          context,
          ref,
          position: details.globalPosition,
          target: target,
        );
      },
      onLongPressStart: (details) {
        showContentContextMenu(
          context,
          ref,
          position: details.globalPosition,
          target: target,
        );
      },
      child: child,
    );
  }
}

// ==========================================
// 3. SHOW CONTEXT MENU PRESENTATION
// ==========================================

void showContentContextMenu(
  BuildContext context,
  WidgetRef ref, {
  required Offset position,
  required ContextMenuTarget target,
}) {
  final container = ProviderScope.containerOf(context);
  final parentContext = context;

  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'ContentContextMenu',
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 120),
    pageBuilder: (dialogContext, anim1, anim2) {
      return _ContentContextMenuOverlay(
        container: container,
        parentContext: parentContext,
        position: position,
        target: target,
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: anim1, curve: Curves.easeOut),
        child: child,
      );
    },
  );
}

// ==========================================
// 4. OVERLAY & MENU ITEMS
// ==========================================

class _ContentContextMenuOverlay extends ConsumerStatefulWidget {
  const _ContentContextMenuOverlay({
    required this.container,
    required this.parentContext,
    required this.position,
    required this.target,
  });

  final ProviderContainer container;
  final BuildContext parentContext;
  final Offset position;
  final ContextMenuTarget target;

  @override
  ConsumerState<_ContentContextMenuOverlay> createState() => _ContentContextMenuOverlayState();
}

class _ContentContextMenuOverlayState extends ConsumerState<_ContentContextMenuOverlay> {
  // Submenu state: null, 'playlist', or 'share'
  String? _activeSubmenu;
  Offset _submenuAnchorOffset = Offset.zero;

  ProviderContainer get _container => widget.container;
  BuildContext get _parentContext => widget.parentContext;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenSize = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;

    const double menuWidth = 240.0;
    final double estimatedHeight = switch (widget.target) {
      TrackContextTarget() => 390.0,
      AlbumContextTarget() => 300.0,
      PlaylistContextTarget() => 300.0,
      ArtistContextTarget() => 260.0,
      RadioContextTarget() => 210.0,
    };

    double left = widget.position.dx;
    double top = widget.position.dy;

    // Flip horizontally if extending beyond right edge
    final bool flipHorizontal = left + menuWidth > screenSize.width - 12;
    if (flipHorizontal) {
      left = left - menuWidth;
    }
    // Flip vertically if extending beyond bottom edge
    final bool flipVertical = top + estimatedHeight > screenSize.height - 12;
    if (flipVertical) {
      top = top - estimatedHeight;
    }

    left = left.clamp(12.0, (screenSize.width - menuWidth - 12.0).clamp(12.0, double.infinity));
    top = top.clamp(padding.top + 8.0, (screenSize.height - estimatedHeight - 12.0).clamp(padding.top + 8.0, double.infinity));

    return Stack(
      children: [
        // Dismiss backdrop area
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.of(context).pop(),
            onSecondaryTap: () => Navigator.of(context).pop(),
            child: const ColoredBox(color: Colors.transparent),
          ),
        ),

        // Context Menu Card (Glassmorphic, Theme-Aware)
        Positioned(
          left: left,
          top: top,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: menuWidth,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHigh.withValues(alpha: 0.94),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.18),
                  width: 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withValues(alpha: 0.35),
                    blurRadius: 30,
                    spreadRadius: 2,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: _buildMenuItems(context, ref),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        // Active Submenu (if open)
        if (_activeSubmenu != null)
          _buildSubmenuOverlay(context, screenSize, left, menuWidth),
      ],
    );
  }

  Widget _buildSubmenuOverlay(
    BuildContext context,
    Size screenSize,
    double parentLeft,
    double parentWidth,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    const double submenuWidth = 220.0;
    double subLeft = parentLeft + parentWidth + 6;
    if (subLeft + submenuWidth > screenSize.width - 12) {
      // Show on the left of parent menu
      subLeft = parentLeft - submenuWidth - 6;
    }
    double subTop = _submenuAnchorOffset.dy - 6;
    if (subTop + 280 > screenSize.height - 12) {
      subTop = (screenSize.height - 290).clamp(12.0, double.infinity);
    }

    return Positioned(
      left: subLeft,
      top: subTop,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: submenuWidth,
          constraints: const BoxConstraints(maxHeight: 290),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHigh.withValues(alpha: 0.94),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.18),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.35),
                blurRadius: 30,
                spreadRadius: 2,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                child: _activeSubmenu == 'playlist'
                    ? _buildPlaylistSubmenuContent(context)
                    : _buildShareSubmenuContent(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // Dynamic Menu Items based on target type
  // -------------------------------------------------------------
  List<Widget> _buildMenuItems(BuildContext context, WidgetRef ref) {
    return switch (widget.target) {
      TrackContextTarget target => _buildTrackMenuItems(context, ref, target),
      AlbumContextTarget target => _buildAlbumMenuItems(context, ref, target),
      PlaylistContextTarget target => _buildPlaylistMenuItems(context, ref, target),
      ArtistContextTarget target => _buildArtistMenuItems(context, ref, target),
      RadioContextTarget target => _buildRadioMenuItems(context, ref, target),
    };
  }

  // --- Track Items ---
  List<Widget> _buildTrackMenuItems(BuildContext context, WidgetRef ref, TrackContextTarget target) {
    final track = target.track;
    final colorScheme = Theme.of(context).colorScheme;
    final isFav = ref.watch(favoritesStatusProvider((FavoriteType.track, track.spotifyId))).value ?? track.isFavorite;

    return [
      _ContextMenuItem(
        icon: Icons.play_arrow_rounded,
        label: 'Play',
        onTap: () {
          Navigator.of(context).pop();
          debugPrint('[ContentContextMenu] Playing track: ${track.name}');
          _container.read(playerProvider.notifier).playTrack(track);
        },
      ),
      _ContextMenuItem(
        icon: Icons.playlist_play_rounded,
        label: 'Play next',
        onTap: () {
          Navigator.of(context).pop();
          _container.read(playerProvider.notifier).playNext(track);
          _showToast('Will play next');
        },
      ),
      _ContextMenuItem(
        icon: Icons.queue_music_rounded,
        label: 'Add to queue',
        onTap: () {
          Navigator.of(context).pop();
          _container.read(playerProvider.notifier).addToQueue(track);
          _showToast('Added to queue');
        },
      ),
      if (target.isInQueue && target.queueIndex != null)
        _ContextMenuItem(
          icon: Icons.remove_circle_outline_rounded,
          iconColor: colorScheme.error,
          label: 'Remove from queue',
          onTap: () {
            Navigator.of(context).pop();
            _container.read(playerProvider.notifier).removeFromQueue(target.queueIndex!);
            _showToast('Removed from queue');
          },
        ),
      const _ContextMenuDivider(),
      _ContextMenuItem(
        icon: isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
        iconColor: isFav ? colorScheme.primary : null,
        label: isFav ? 'Remove from Liked Songs' : 'Save to your Liked Songs',
        onTap: () {
          Navigator.of(context).pop();
          _container.read(favoritesControllerProvider.notifier).toggleTrackFavorite(track, isFav);
          _showToast(isFav ? 'Removed from Liked Songs' : 'Saved to your Liked Songs');
        },
      ),
      _ContextMenuItem(
        icon: Icons.playlist_add_rounded,
        label: 'Add to playlist',
        hasSubmenu: true,
        onHoverTrigger: (offset) {
          setState(() {
            _activeSubmenu = 'playlist';
            _submenuAnchorOffset = offset;
          });
        },
        onTap: () {
          if (_activeSubmenu == 'playlist') {
            setState(() => _activeSubmenu = null);
          } else {
            Navigator.of(context).pop();
            if (_parentContext.mounted) {
              TrackTile.showPlaylistPicker(_parentContext, ref, track);
            }
          }
        },
      ),
      const _ContextMenuDivider(),
      if (track.artistId.isNotEmpty)
        _ContextMenuItem(
          icon: Icons.person_outline_rounded,
          label: 'Go to artist',
          onTap: () {
            Navigator.of(context).pop();
            final firstArtistId = track.artistId.split(',').first.trim();
            if (_parentContext.mounted) {
              _parentContext.push('/artist/$firstArtistId');
            }
          },
        ),
      if (track.albumId != null && track.albumId!.isNotEmpty)
        _ContextMenuItem(
          icon: Icons.album_outlined,
          label: 'Go to album',
          onTap: () {
            Navigator.of(context).pop();
            if (_parentContext.mounted) {
              _parentContext.push('/album/${track.albumId}');
            }
          },
        ),
      _ContextMenuItem(
        icon: Icons.radio_rounded,
        label: 'Go to song radio',
        onTap: () {
          Navigator.of(context).pop();
          final encodedTitle = Uri.encodeComponent(track.name);
          final encodedImage = Uri.encodeComponent(track.albumImage ?? '');
          final encodedArtistName = Uri.encodeComponent(track.artistName);
          if (_parentContext.mounted) {
            _parentContext.push(
              '/radio/track/${track.spotifyId}?title=$encodedTitle&imageUrl=$encodedImage&artistId=${track.artistId}&artistName=$encodedArtistName',
            );
          }
        },
      ),
      const _ContextMenuDivider(),
      _ContextMenuItem(
        icon: Icons.share_outlined,
        label: 'Share',
        hasSubmenu: true,
        onHoverTrigger: (offset) {
          setState(() {
            _activeSubmenu = 'share';
            _submenuAnchorOffset = offset;
          });
        },
        onTap: () {
          _copyToClipboard('https://open.spotify.com/track/${track.spotifyId}');
        },
      ),
    ];
  }

  // --- Album Items ---
  List<Widget> _buildAlbumMenuItems(BuildContext context, WidgetRef ref, AlbumContextTarget target) {
    final colorScheme = Theme.of(context).colorScheme;
    final isLiked = ref.watch(favoritesStatusProvider((FavoriteType.album, target.id))).value ?? false;

    return [
      _ContextMenuItem(
        icon: Icons.play_arrow_rounded,
        label: 'Play',
        onTap: () async {
          Navigator.of(context).pop();
          try {
            debugPrint('[ContentContextMenu] Fetching album tracks for ${target.id} (${target.name})');
            final tracks = (await _container.read(spotifyRepositoryProvider).watchAlbum(target.id).first).data['tracks']?['items']?.map((t) => Track.fromSpotify(t as Map<String,dynamic>))?.toList()?.cast<Track>() ?? <Track>[];
            if (tracks.isNotEmpty) {
              _container.read(playerProvider.notifier).playTrack(tracks.first, queue: tracks);
            } else {
              _showToast('Album has no tracks');
            }
          } catch (e, stack) {
            debugPrint('[ContentContextMenu] Error playing album: $e\n$stack');
            _showToast('Could not play album: $e');
          }
        },
      ),
      _ContextMenuItem(
        icon: Icons.queue_music_rounded,
        label: 'Add to queue',
        onTap: () async {
          Navigator.of(context).pop();
          try {
            final tracks = (await _container.read(spotifyRepositoryProvider).watchAlbum(target.id).first).data['tracks']?['items']?.map((t) => Track.fromSpotify(t as Map<String,dynamic>))?.toList()?.cast<Track>() ?? <Track>[];
            if (tracks.isNotEmpty) {
              _container.read(playerProvider.notifier).addTracksToQueue(tracks);
              _showToast('Added ${tracks.length} tracks to queue');
            }
          } catch (e, stack) {
            debugPrint('[ContentContextMenu] Error adding album to queue: $e\n$stack');
            _showToast('Could not add to queue: $e');
          }
        },
      ),
      const _ContextMenuDivider(),
      _ContextMenuItem(
        icon: isLiked ? Icons.bookmark_added_rounded : Icons.bookmark_add_outlined,
        iconColor: isLiked ? colorScheme.primary : null,
        label: isLiked ? 'Remove from Your Library' : 'Add to Your Library',
        onTap: () {
          Navigator.of(context).pop();
          _container.read(favoritesControllerProvider.notifier).toggleAlbumLike(
                target.id,
                target.name,
                target.artistId,
                target.artistName,
                target.imageUrl,
                isLiked,
              );
          _showToast(isLiked ? 'Removed from Your Library' : 'Saved to Your Library');
        },
      ),
      _ContextMenuItem(
        icon: Icons.playlist_add_rounded,
        label: 'Add to playlist',
        hasSubmenu: true,
        onHoverTrigger: (offset) {
          setState(() {
            _activeSubmenu = 'playlist';
            _submenuAnchorOffset = offset;
          });
        },
        onTap: () {
          setState(() {
            _activeSubmenu = _activeSubmenu == 'playlist' ? null : 'playlist';
          });
        },
      ),
      if (target.artistId.isNotEmpty)
        _ContextMenuItem(
          icon: Icons.person_outline_rounded,
          label: 'Go to artist',
          onTap: () {
            Navigator.of(context).pop();
            if (_parentContext.mounted) {
              _parentContext.push('/artist/${target.artistId}');
            }
          },
        ),
      const _ContextMenuDivider(),
      _ContextMenuItem(
        icon: Icons.share_outlined,
        label: 'Share',
        hasSubmenu: true,
        onHoverTrigger: (offset) {
          setState(() {
            _activeSubmenu = 'share';
            _submenuAnchorOffset = offset;
          });
        },
        onTap: () {
          _copyToClipboard('https://open.spotify.com/album/${target.id}');
        },
      ),
    ];
  }

  // --- Playlist Items ---
  List<Widget> _buildPlaylistMenuItems(BuildContext context, WidgetRef ref, PlaylistContextTarget target) {
    final colorScheme = Theme.of(context).colorScheme;
    final isLiked = target.isLocal
        ? true
        : (ref.watch(favoritesStatusProvider((FavoriteType.playlist, target.id))).value ?? false);

    return [
      _ContextMenuItem(
        icon: Icons.play_arrow_rounded,
        label: 'Play',
        onTap: () async {
          Navigator.of(context).pop();
          try {
            List<Track> tracks;
            if (target.isLocal && target.localId != null) {
              final raw = await _container.read(db.appDatabaseProvider).getPlaylistTracks(target.localId!);
              tracks = raw.map(Track.fromDb).toList();
            } else {
              tracks = (await _container.read(spotifyRepositoryProvider).watchPlaylistTracks(target.id).first).data;
            }
            if (tracks.isNotEmpty) {
              _container.read(playerProvider.notifier).playTrack(tracks.first, queue: tracks);
            } else {
              _showToast('Playlist has no tracks');
            }
          } catch (e, stack) {
            debugPrint('[ContentContextMenu] Error playing playlist: $e\n$stack');
            _showToast('Error playing playlist: $e');
          }
        },
      ),
      _ContextMenuItem(
        icon: Icons.queue_music_rounded,
        label: 'Add to queue',
        onTap: () async {
          Navigator.of(context).pop();
          try {
            List<Track> tracks;
            if (target.isLocal && target.localId != null) {
              final raw = await _container.read(db.appDatabaseProvider).getPlaylistTracks(target.localId!);
              tracks = raw.map(Track.fromDb).toList();
            } else {
              tracks = (await _container.read(spotifyRepositoryProvider).watchPlaylistTracks(target.id).first).data;
            }
            if (tracks.isNotEmpty) {
              _container.read(playerProvider.notifier).addTracksToQueue(tracks);
              _showToast('Added ${tracks.length} tracks to queue');
            }
          } catch (e, stack) {
            debugPrint('[ContentContextMenu] Error adding playlist to queue: $e\n$stack');
            _showToast('Error adding to queue: $e');
          }
        },
      ),
      const _ContextMenuDivider(),
      _ContextMenuItem(
        icon: target.isLocal
            ? Icons.delete_outline_rounded
            : (isLiked ? Icons.bookmark_added_rounded : Icons.bookmark_add_outlined),
        iconColor: target.isLocal
            ? colorScheme.error
            : (isLiked ? colorScheme.primary : null),
        label: target.isLocal
            ? 'Delete playlist'
            : (isLiked ? 'Remove from Your Library' : 'Add to Your Library'),
        onTap: () async {
          Navigator.of(context).pop();
          if (target.isLocal && target.localId != null) {
            await _container.read(db.appDatabaseProvider).deletePlaylist(target.localId!);
            _showToast('Deleted ${target.name}');
          } else {
            await _container.read(favoritesControllerProvider.notifier).togglePlaylistLike(
                  target.id,
                  target.name,
                  target.imageUrl,
                  isLiked,
                );
            _showToast(isLiked ? 'Removed from Your Library' : 'Saved to Your Library');
          }
        },
      ),
      _ContextMenuItem(
        icon: Icons.queue_music_rounded,
        label: 'Go to playlist',
        onTap: () {
          Navigator.of(context).pop();
          if (_parentContext.mounted) {
            if (target.isLocal && target.localId != null) {
              _parentContext.push('/playlist/${target.localId}');
            } else {
              final encodedName = Uri.encodeComponent(target.name);
              _parentContext.push('/playlist/remote/${target.id}?name=$encodedName');
            }
          }
        },
      ),
      const _ContextMenuDivider(),
      _ContextMenuItem(
        icon: Icons.share_outlined,
        label: 'Share',
        hasSubmenu: true,
        onHoverTrigger: (offset) {
          setState(() {
            _activeSubmenu = 'share';
            _submenuAnchorOffset = offset;
          });
        },
        onTap: () {
          _copyToClipboard(
            target.isLocal
                ? 'ppplayer://playlist/${target.localId}'
                : 'https://open.spotify.com/playlist/${target.id}',
          );
        },
      ),
    ];
  }

  // --- Artist Items ---
  List<Widget> _buildArtistMenuItems(BuildContext context, WidgetRef ref, ArtistContextTarget target) {
    final colorScheme = Theme.of(context).colorScheme;
    final isFollowed = ref.watch(favoritesStatusProvider((FavoriteType.artist, target.id))).value ?? false;

    return [
      _ContextMenuItem(
        icon: Icons.play_arrow_rounded,
        label: 'Play',
        onTap: () async {
          Navigator.of(context).pop();
          try {
            debugPrint('[ContentContextMenu] Fetching top tracks for artist ${target.id} (${target.name})');
            final rawTracks = (await _container.read(spotifyRepositoryProvider).watchArtistTopTracks(target.id).first).data;
            final tracks = rawTracks.map((j) => Track.fromSpotify(j as Map<String, dynamic>)).toList();
            if (tracks.isNotEmpty) {
              _container.read(playerProvider.notifier).playTrack(tracks.first, queue: tracks);
            } else {
              _showToast('No tracks found for ${target.name}');
            }
          } catch (e, stack) {
            debugPrint('[ContentContextMenu] Error playing artist ${target.name}: $e\n$stack');
            _showToast('Could not play artist: $e');
          }
        },
      ),
      _ContextMenuItem(
        icon: isFollowed ? Icons.person_remove_outlined : Icons.person_add_outlined,
        iconColor: isFollowed ? colorScheme.primary : null,
        label: isFollowed ? 'Unfollow' : 'Follow',
        onTap: () {
          Navigator.of(context).pop();
          _container.read(favoritesControllerProvider.notifier).toggleArtistFollow(
                target.id,
                target.name,
                target.imageUrl,
                isFollowed,
              );
          _showToast(isFollowed ? 'Unfollowed ${target.name}' : 'Following ${target.name}');
        },
      ),
      _ContextMenuItem(
        icon: Icons.radio_rounded,
        label: 'Go to artist radio',
        onTap: () {
          Navigator.of(context).pop();
          final encodedTitle = Uri.encodeComponent(target.name);
          final encodedImage = Uri.encodeComponent(target.imageUrl ?? '');
          if (_parentContext.mounted) {
            _parentContext.push('/radio/artist/${target.id}?title=$encodedTitle&imageUrl=$encodedImage');
          }
        },
      ),
      _ContextMenuItem(
        icon: Icons.person_outline_rounded,
        label: 'Go to artist',
        onTap: () {
          Navigator.of(context).pop();
          if (_parentContext.mounted) {
            _parentContext.push('/artist/${target.id}');
          }
        },
      ),
      const _ContextMenuDivider(),
      _ContextMenuItem(
        icon: Icons.share_outlined,
        label: 'Share',
        hasSubmenu: true,
        onHoverTrigger: (offset) {
          setState(() {
            _activeSubmenu = 'share';
            _submenuAnchorOffset = offset;
          });
        },
        onTap: () {
          _copyToClipboard('https://open.spotify.com/artist/${target.id}');
        },
      ),
    ];
  }

  // --- Radio Items ---
  List<Widget> _buildRadioMenuItems(BuildContext context, WidgetRef ref, RadioContextTarget target) {
    final colorScheme = Theme.of(context).colorScheme;
    final radioKey = '${target.seedId}:${target.seedType}';
    final isFollowed = ref.watch(favoritesStatusProvider((FavoriteType.radio, radioKey))).value ?? false;

    return [
      _ContextMenuItem(
        icon: Icons.play_arrow_rounded,
        label: 'Play Station',
        onTap: () async {
          Navigator.of(context).pop();
          final parentContext = _parentContext;
          try {
            debugPrint('[ContentContextMenu] Fetching radio station tracks for ${target.seedType}:${target.seedId}');
            final repo = _container.read(spotifyRepositoryProvider);
            final cacheResult = await repo.watchRecommendations(
              seedArtistId: target.seedType == 'artist' ? target.seedId : null,
              seedTrackId: target.seedType == 'track' ? target.seedId : null,
              seedGenres: target.seedType == 'genre' ? target.seedId : null,
            ).first;
            final tracks = cacheResult.data;
            if (tracks.isNotEmpty) {
              _container.read(playerProvider.notifier).playTracks(tracks);
            } else {
              if (parentContext.mounted) {
                final encodedTitle = Uri.encodeComponent(target.title);
                final encodedImage = Uri.encodeComponent(target.imageUrl ?? '');
                parentContext.push('/radio/${target.seedType}/${target.seedId}?title=$encodedTitle&imageUrl=$encodedImage');
              }
            }
          } catch (e, stack) {
            debugPrint('[ContentContextMenu] Error playing radio station: $e\n$stack');
            if (parentContext.mounted) {
              final encodedTitle = Uri.encodeComponent(target.title);
              final encodedImage = Uri.encodeComponent(target.imageUrl ?? '');
              parentContext.push('/radio/${target.seedType}/${target.seedId}?title=$encodedTitle&imageUrl=$encodedImage');
            }
          }
        },
      ),
      _ContextMenuItem(
        icon: isFollowed ? Icons.bookmark_added_rounded : Icons.bookmark_add_outlined,
        iconColor: isFollowed ? colorScheme.primary : null,
        label: isFollowed ? 'Unfollow Station' : 'Follow Station',
        onTap: () {
          Navigator.of(context).pop();
          _container.read(favoritesControllerProvider.notifier).toggleRadioFollow(
                seedId: target.seedId,
                seedType: target.seedType,
                title: target.title,
                imageUrl: target.imageUrl,
                isCurrentlyFollowed: isFollowed,
              );
          _showToast(isFollowed ? 'Station removed from Library' : 'Station saved to Library');
        },
      ),
      const _ContextMenuDivider(),
      _ContextMenuItem(
        icon: Icons.share_outlined,
        label: 'Share',
        onTap: () {
          Navigator.of(context).pop();
          _copyToClipboard('https://ppplayer.com/radio/${target.seedType}/${target.seedId}');
        },
      ),
    ];
  }

  // -------------------------------------------------------------
  // Submenus (Add to Playlist / Share)
  // -------------------------------------------------------------
  Widget _buildPlaylistSubmenuContent(BuildContext context) {
    final database = ref.watch(db.appDatabaseProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return StreamBuilder<List<db.Playlist>>(
      stream: database.watchPlaylists(),
      builder: (context, snapshot) {
        final playlists = snapshot.data ?? [];

        return ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          children: [
            _ContextMenuItem(
              icon: Icons.add_rounded,
              iconColor: colorScheme.primary,
              label: 'New playlist',
              onTap: () async {
                Navigator.of(context).pop();
                await _promptCreatePlaylist();
              },
            ),
            if (playlists.isNotEmpty) const _ContextMenuDivider(),
            ...playlists.map(
              (p) => _ContextMenuItem(
                icon: Icons.music_note_rounded,
                label: p.name,
                onTap: () async {
                  Navigator.of(context).pop();
                  await _addItemToPlaylist(p);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addItemToPlaylist(db.Playlist playlist) async {
    final database = _container.read(db.appDatabaseProvider);
    try {
      if (widget.target case TrackContextTarget target) {
        await database.addToPlaylist(playlist.id, target.track.spotifyId);
        _showToast('Added to ${playlist.name}');
      } else if (widget.target case AlbumContextTarget target) {
        final tracks = (await _container.read(spotifyRepositoryProvider).watchAlbum(target.id).first).data['tracks']?['items']?.map((t) => Track.fromSpotify(t as Map<String,dynamic>))?.toList()?.cast<Track>() ?? <Track>[];
        for (final t in tracks) {
          await database.addToPlaylist(playlist.id, t.spotifyId);
        }
        _showToast('Added ${tracks.length} tracks to ${playlist.name}');
      } else if (widget.target case PlaylistContextTarget target) {
        List<Track> tracks;
        if (target.isLocal && target.localId != null) {
          final raw = await database.getPlaylistTracks(target.localId!);
          tracks = raw.map(Track.fromDb).toList();
        } else {
          tracks = (await _container.read(spotifyRepositoryProvider).watchPlaylistTracks(target.id).first).data;
        }
        for (final t in tracks) {
          await database.addToPlaylist(playlist.id, t.spotifyId);
        }
        _showToast('Added ${tracks.length} tracks to ${playlist.name}');
      }
    } catch (e, stack) {
      debugPrint('[ContentContextMenu] Error adding to playlist: $e\n$stack');
      _showToast('Error adding to playlist: $e');
    }
  }

  Future<void> _promptCreatePlaylist() async {
    final controller = TextEditingController();
    final database = _container.read(db.appDatabaseProvider);

    if (!_parentContext.mounted) return;

    showPremiumModal<void>(
      context: _parentContext,
      title: 'New Playlist',
      child: Builder(
        builder: (dialogContext) {
          final dialogColorScheme = Theme.of(dialogContext).colorScheme;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                autofocus: true,
                style: TextStyle(
                  color: dialogColorScheme.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  hintText: 'My Playlist',
                  hintStyle: TextStyle(
                    color: dialogColorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                  ),
                  filled: true,
                  fillColor: dialogColorScheme.onSurface.withValues(alpha: 0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                ),
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: TactileTap(
                      onTap: () => Navigator.of(dialogContext, rootNavigator: true).pop(),
                      child: Container(
                        height: 48,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: dialogColorScheme.outlineVariant.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: dialogColorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
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
                          final newId = await database.createPlaylist(name);
                          if (dialogContext.mounted) {
                            Navigator.of(dialogContext, rootNavigator: true).pop();
                          }
                          final playlist = await (database.select(database.playlists)..where((p) => p.id.equals(newId))).getSingle();
                          await _addItemToPlaylist(playlist);
                        }
                      },
                      child: Container(
                        height: 48,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              dialogColorScheme.primary,
                              dialogColorScheme.primary.withValues(alpha: 0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: dialogColorScheme.primary.withValues(alpha: 0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          'Create',
                          style: TextStyle(
                            color: dialogColorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildShareSubmenuContent(BuildContext context) {
    final (url, id) = switch (widget.target) {
      TrackContextTarget target => (
          'https://open.spotify.com/track/${target.track.spotifyId}',
          target.track.spotifyId,
        ),
      AlbumContextTarget target => (
          'https://open.spotify.com/album/${target.id}',
          target.id,
        ),
      PlaylistContextTarget target => (
          target.isLocal ? 'ppplayer://playlist/${target.localId}' : 'https://open.spotify.com/playlist/${target.id}',
          target.id,
        ),
      ArtistContextTarget target => (
          'https://open.spotify.com/artist/${target.id}',
          target.id,
        ),
      RadioContextTarget target => (
          'https://ppplayer.com/radio/${target.seedType}/${target.seedId}',
          target.seedId,
        ),
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ContextMenuItem(
          icon: Icons.link_rounded,
          label: 'Copy link',
          onTap: () {
            Navigator.of(context).pop();
            _copyToClipboard(url);
          },
        ),
        _ContextMenuItem(
          icon: Icons.tag_rounded,
          label: 'Copy ID',
          onTap: () {
            Navigator.of(context).pop();
            _copyToClipboard(id);
          },
        ),
      ],
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    _showToast('Link copied to clipboard');
  }

  void _showToast(String message) {
    if (_parentContext.mounted) {
      final messenger = ScaffoldMessenger.maybeOf(_parentContext);
      if (messenger != null) {
        final colorScheme = Theme.of(_parentContext).colorScheme;
        messenger.clearSnackBars();
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              message,
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: colorScheme.surfaceContainerHighest,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(milliseconds: 1800),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: colorScheme.outlineVariant.withValues(alpha: 0.2),
              ),
            ),
            elevation: 8,
            margin: const EdgeInsets.only(bottom: 24, left: 24, right: 24),
          ),
        );
      }
    }
  }
}

// ==========================================
// 5. ATOMIC MENU ITEM COMPONENT
// ==========================================

class _ContextMenuItem extends StatefulWidget {
  const _ContextMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
    this.hasSubmenu = false,
    this.onHoverTrigger,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;
  final bool hasSubmenu;
  final void Function(Offset globalOffset)? onHoverTrigger;

  @override
  State<_ContextMenuItem> createState() => _ContextMenuItemState();
}

class _ContextMenuItemState extends State<_ContextMenuItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final isCustomColor = widget.iconColor != null;
    final defaultIconColor = _isHovered ? colorScheme.onSurface : colorScheme.onSurfaceVariant;
    final iconColor = widget.iconColor ?? defaultIconColor;

    final Color hoverBg = isCustomColor
        ? widget.iconColor!.withValues(alpha: 0.12)
        : colorScheme.onSurface.withValues(alpha: 0.08);

    final Color hoverBorder = isCustomColor
        ? widget.iconColor!.withValues(alpha: 0.22)
        : colorScheme.outlineVariant.withValues(alpha: 0.20);

    return MouseRegion(
      onEnter: (event) {
        setState(() => _isHovered = true);
        if (widget.hasSubmenu && widget.onHoverTrigger != null) {
          final renderBox = context.findRenderObject() as RenderBox?;
          if (renderBox != null) {
            final offset = renderBox.localToGlobal(Offset.zero);
            widget.onHoverTrigger!(offset);
          }
        }
      },
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOutCubic,
          height: 38,
          decoration: BoxDecoration(
            color: _isHovered ? hoverBg : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _isHovered ? hoverBorder : Colors.transparent,
              width: 1.0,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              AnimatedScale(
                scale: _isHovered ? 1.08 : 1.0,
                duration: const Duration(milliseconds: 140),
                curve: Curves.easeOutCubic,
                child: Icon(
                  widget.icon,
                  size: 19,
                  color: iconColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 140),
                  curve: Curves.easeOutCubic,
                  style: TextStyle(
                    color: _isHovered
                        ? (isCustomColor && widget.iconColor == colorScheme.error
                            ? colorScheme.error
                            : colorScheme.onSurface)
                        : colorScheme.onSurface.withValues(alpha: 0.9),
                    fontSize: 13.5,
                    fontWeight: _isHovered ? FontWeight.w600 : FontWeight.w500,
                    letterSpacing: -0.2,
                  ),
                  child: Text(
                    widget.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              if (widget.hasSubmenu)
                AnimatedSlide(
                  offset: Offset(_isHovered ? 0.08 : 0.0, 0),
                  duration: const Duration(milliseconds: 140),
                  curve: Curves.easeOutCubic,
                  child: Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: _isHovered
                        ? colorScheme.onSurface
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContextMenuDivider extends StatelessWidget {
  const _ContextMenuDivider();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
      child: Divider(
        height: 1,
        thickness: 0.8,
        color: colorScheme.outlineVariant.withValues(alpha: 0.18),
      ),
    );
  }
}
