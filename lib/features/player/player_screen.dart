import 'dart:ui';
import 'package:flutter/material.dart' hide RepeatMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../core/player/player_provider.dart';
import '../../core/player/video_layout_provider.dart';
import '../../core/services/settings_provider.dart';
import '../../shared/widgets/track_tile.dart';
import '../../shared/widgets/tactile_buttons.dart';

String _formatDuration(Duration d) {
  final minutes = d.inMinutes;
  final seconds = d.inSeconds % 60;
  return '$minutes:${seconds.toString().padLeft(2, '0')}';
}

class PlayerScreen extends ConsumerStatefulWidget {
  const PlayerScreen({super.key});

  @override
  ConsumerState<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen> {
  final GlobalKey _videoKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Proactively update layout after mounting to catch the initial position
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateVideoLayout());
    
    // Staggered updates to ensure we capture the final position after 
    // GoRouter transition animations finish (which usually take ~300ms)
    _frequentLayoutUpdate();
  }

  void _frequentLayoutUpdate() {
    // Immediate update
    if (mounted) _updateVideoLayout();

    // Update every 50ms for the first 1.5s during potential animations
    int count = 0;
    const duration = Duration(milliseconds: 50);
    const limit = 30; // 1.5 seconds

    Future.doWhile(() async {
      await Future.delayed(duration);
      if (!mounted) return false;
      _updateVideoLayout();
      count++;
      return count < limit;
    });
  }

  void _updateVideoLayout() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final RenderBox? box = _videoKey.currentContext?.findRenderObject() as RenderBox?;
      if (box != null) {
        final position = box.localToGlobal(Offset.zero);
        ref.read(videoLayoutProvider.notifier).updateLayout(box.size, position);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final playerState = ref.watch(playerProvider);
    final playerNotifier = ref.read(playerProvider.notifier);
    final settings = ref.watch(settingsProvider);
    final track = playerState.currentTrack;

    if (track == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: Text('No track playing')),
      );
    }

    final isQueueView = settings.playerView == PlayerView.queue;
    final isVideoView = settings.playerView == PlayerView.video;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background blurred image
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: track.albumImage ?? '',
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => const SizedBox.shrink(),
            )
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .scale(begin: const Offset(1.0, 1.0), end: const Offset(1.15, 1.15), duration: 20.seconds, curve: Curves.easeInOutSine)
            .move(begin: const Offset(-20, -10), end: const Offset(20, 10), duration: 15.seconds, curve: Curves.easeInOutSine),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
              child: Container(
                color: Colors.black.withValues(alpha: 0.6),
              ),
            ),
          ),

          // Main Content
          SafeArea(
            child: Column(
              children: [
                // Header Toggles
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                  child: Row(
                    children: [
                      TactileIconButton(
                        icon: Icons.keyboard_arrow_down,
                        size: 32,
                        padding: EdgeInsets.zero,
                        onTap: () => context.pop(),
                      ),
                      const Spacer(),
                      // Center Toggles (Premium Segmented Style)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: Colors.white10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _ToggleTab(
                                  label: 'VIDEO',
                                  isActive: isVideoView,
                                  onTap: () => ref.read(settingsProvider.notifier).setPlayerView(PlayerView.video),
                                ),
                                _ToggleTab(
                                  label: 'ARTWORK',
                                  isActive: settings.playerView == PlayerView.artwork,
                                  onTap: () => ref.read(settingsProvider.notifier).setPlayerView(PlayerView.artwork),
                                ),
                                _ToggleTab(
                                  label: 'QUEUE',
                                  isActive: isQueueView,
                                  onTap: () => ref.read(settingsProvider.notifier).setPlayerView(PlayerView.queue),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert),
                        onSelected: (value) {
                          switch (value) {
                            case 'add_to_playlist':
                              TrackTile.showPlaylistPicker(context, ref, track);
                              break;
                            case 'go_to_artist':
                              context.pop(); // Close player
                              context.push('/artist/${track.artistId}');
                              break;
                            case 'go_to_album':
                              if (track.albumId != null) {
                                context.pop(); // Close player
                                context.push('/album/${track.albumId}');
                              }
                              break;
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(value: 'add_to_playlist', child: Text('Add to Playlist')),
                          const PopupMenuItem(value: 'go_to_artist', child: Text('Go to Artist')),
                          const PopupMenuItem(value: 'go_to_album', child: Text('Go to Album')),
                        ],
                      ),
                    ],
                  ),
                ),

                // Content Area
                Expanded(
                  child: isQueueView
                      ? _QueueView(playerState: playerState)
                      : Column(
                          children: [
                            // Video/Artwork area
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                child: Center(
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(maxWidth: 800),
                                    child: AspectRatio(
                                      aspectRatio: 16 / 9,
                                      child: isVideoView
                                          ? Container(
                                              key: _videoKey,
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius: BorderRadius.circular(24),
                                              ),
                                            )
                                          : _VinylArtwork(
                                              imageUrl: playerState.currentTrack?.albumImage ?? '',
                                              isPlaying: playerState.isPlaying,
                                            )
                                              .animate()
                                              .fadeIn(duration: 600.ms, curve: Curves.easeOut)
                                              .slideY(begin: -0.1, end: 0, duration: 600.ms, curve: Curves.easeOut),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Track Info & Controls
                            Container(
                              padding: const EdgeInsets.only(bottom: 32),
                              child: Column(
                                children: [
                                  // Track Info
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                playerState.currentTrack?.name ?? 'Not Playing',
                                                style: const TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              )
                                                .animate()
                                                .fadeIn(duration: 500.ms, delay: 200.ms)
                                                .slideX(begin: 0.1, duration: 500.ms, curve: Curves.easeOutCubic)
                                                .shimmer(delay: 5.seconds, duration: 2.seconds, curve: Curves.easeInOut),
                                              const SizedBox(height: 4),
                                              Text(
                                                playerState.currentTrack?.artistName ?? 'Unknown Artist',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white.withValues(alpha: 0.7),
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              )
                                                .animate()
                                                .fadeIn(duration: 500.ms, delay: 300.ms)
                                                .slideX(begin: 0.1, duration: 500.ms, curve: Curves.easeOutCubic),
                                            ],
                                          ),
                                        ),
                                        if (playerState.currentTrack != null)
                                          IconButton(
                                            icon: Icon(
                                              playerState.currentTrack!.isFavorite 
                                                ? Icons.favorite 
                                                : Icons.favorite_border,
                                              color: playerState.currentTrack!.isFavorite 
                                                ? const Color(0xFF1DB954) 
                                                : Colors.white,
                                            ),
                                            onPressed: () => playerNotifier.toggleFavorite(playerState.currentTrack!),
                                          ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  // Controls
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                    child: Column(
                                      children: [
                                        SliderTheme(
                                          data: SliderTheme.of(context).copyWith(
                                            trackHeight: 4,
                                            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                                            overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                                            activeTrackColor: const Color(0xFF1DB954),
                                            inactiveTrackColor: Colors.white24,
                                            thumbColor: Colors.white,
                                          ),
                                          child: Slider(
                                            value: playerState.position.inSeconds.toDouble(),
                                            max: playerState.duration.inSeconds > 0
                                                ? playerState.duration.inSeconds.toDouble()
                                                : 1.0,
                                            onChanged: (v) => playerNotifier.seekTo(Duration(seconds: v.toInt())),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(_formatDuration(playerState.position),
                                                  style: const TextStyle(color: Colors.white60, fontSize: 12)),
                                              Text(_formatDuration(playerState.duration),
                                                  style: const TextStyle(color: Colors.white60, fontSize: 12)),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            TactileIconButton(
                                              icon: Icons.shuffle,
                                              color: playerState.isShuffled ? const Color(0xFF1DB954) : Colors.white,
                                              onTap: playerNotifier.toggleShuffle,
                                            ),
                                            TactileIconButton(
                                              icon: Icons.skip_previous,
                                              size: 38,
                                              onTap: playerNotifier.skipPrevious,
                                            ),
                                            TactilePlayerPlayPauseButton(
                                              isPlaying: playerState.isPlaying,
                                              onTap: playerNotifier.togglePlay,
                                            ),
                                            TactileIconButton(
                                              icon: Icons.skip_next,
                                              size: 38,
                                              onTap: playerNotifier.skipNext,
                                            ),
                                            TactileIconButton(
                                              icon: playerState.repeatMode == RepeatMode.none ? Icons.repeat : Icons.repeat_one,
                                              color: playerState.repeatMode != RepeatMode.none
                                                  ? const Color(0xFF1DB954)
                                                  : Colors.white,
                                              onTap: playerNotifier.cycleRepeat,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                )
                  .animate()
                  .fadeIn(duration: 500.ms, delay: 400.ms)
                  .slideY(begin: 0.1, duration: 500.ms, curve: Curves.easeOutCubic),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleTab extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _ToggleTab({required this.label, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TactileTap(
      onTap: onTap,
      scaleDown: 0.95,
      hapticType: HapticFeedbackType.light,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.white.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: isActive ? Colors.white : Colors.white60,
          ),
        ),
      ),
    );
  }
}

class _QueueView extends StatelessWidget {
  final PlayerState playerState;
  const _QueueView({required this.playerState});

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: playerState.queue.length,
      proxyDecorator: (child, index, animation) => AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          final animValue = Curves.easeInOut.transform(animation.value);
          final elevation = lerpDouble(0, 8, animValue)!;
          return Material(
            elevation: elevation,
            color: Colors.white.withValues(alpha: 0.1),
            child: child,
          );
        },
        child: child,
      ),
      onReorder: (oldIndex, newIndex) {
        ProviderScope.containerOf(context).read(playerProvider.notifier).reorderQueue(oldIndex, newIndex);
      },
      itemBuilder: (context, i) {
        final t = playerState.queue[i];
        final isCurrent = playerState.currentIndex == i;
        return TactileTap(
          key: ValueKey(t.spotifyId),
          onTap: () => ProviderScope.containerOf(context).read(playerProvider.notifier).skipTo(i),
          scaleDown: 0.98,
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: CachedNetworkImage(imageUrl: t.albumImage ?? '', width: 40, height: 40, fit: BoxFit.cover),
            ),
            title: Text(t.name, style: TextStyle(color: isCurrent ? Colors.green : Colors.white, fontWeight: isCurrent ? FontWeight.bold : null)),
            subtitle: Text(t.artistName, style: const TextStyle(color: Colors.white54, fontSize: 12)),
            trailing: ReorderableDragStartListener(
              index: i,
              child: const Icon(Icons.drag_handle, color: Colors.white24),
            ),
          ),
        );
      },
    );
  }
}

class _VinylArtwork extends StatefulWidget {
  final String imageUrl;
  final bool isPlaying;

  const _VinylArtwork({
    required this.imageUrl,
    required this.isPlaying,
  });

  @override
  State<_VinylArtwork> createState() => _VinylArtworkState();
}

class _VinylArtworkState extends State<_VinylArtwork> with SingleTickerProviderStateMixin {
  late final AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    );
    if (widget.isPlaying) {
      _rotationController.repeat();
    }
  }

  @override
  void didUpdateWidget(_VinylArtwork oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying && !oldWidget.isPlaying) {
      _rotationController.repeat();
    } else if (!widget.isPlaying && oldWidget.isPlaying) {
      _rotationController.stop();
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        final recordSize = height * 0.95;
        return Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // The Vinyl Record
            AnimatedPositioned(
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
              right: widget.isPlaying ? -recordSize * 0.4 : height * 0.05,
              child: RotationTransition(
                turns: _rotationController,
                child: Container(
                  width: recordSize,
                  height: recordSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        blurRadius: 20,
                        offset: const Offset(10, 5),
                      ),
                    ],
                    gradient: const SweepGradient(
                      colors: [
                        Color(0xFF1A1A1A),
                        Color(0xFF333333),
                        Color(0xFF1A1A1A),
                        Color(0xFF333333),
                        Color(0xFF1A1A1A),
                      ],
                      stops: [0.0, 0.25, 0.5, 0.75, 1.0],
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: recordSize * 0.35,
                      height: recordSize * 0.35,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 2),
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(widget.imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Center(
                        child: Container(
                          width: recordSize * 0.05,
                          height: recordSize * 0.05,
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            // The Sleeve
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 30,
                    offset: const Offset(-5, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(
                  imageUrl: widget.imageUrl,
                  fit: BoxFit.cover,
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  errorWidget: (_, _, _) => Container(
                    color: Colors.white10,
                    child: const Icon(Icons.music_note, size: 64, color: Colors.white24),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
