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
    // Proactively update layout after mounting
    _scheduleLayoutUpdates();
  }

  void _scheduleLayoutUpdates() {
    // Schedule multiple updates to catch layout settling during animations
    for (var ms in [0, 50, 100, 250, 500, 800]) {
      Future.delayed(Duration(milliseconds: ms), () {
        if (mounted) _updateVideoLayout();
      });
    }
  }

  void _updateVideoLayout() {
    if (!mounted) return;
    final RenderBox? box = _videoKey.currentContext?.findRenderObject() as RenderBox?;
    if (box != null) {
      final position = box.localToGlobal(Offset.zero);
      ref.read(videoLayoutProvider.notifier).updateLayout(box.size, position);
    }
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

    ref.listen(settingsProvider.select((s) => s.playerView), (prev, next) {
      if (next == PlayerView.video) {
        _scheduleLayoutUpdates();
      }
    });

    final isQueueView = settings.playerView == PlayerView.queue;
    final isVideoView = settings.playerView == PlayerView.video;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background blurred image (Ambient Ambient Motion)
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: track.albumImage ?? '',
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => const SizedBox.shrink(),
            )
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .scale(begin: const Offset(1.1, 1.1), end: const Offset(1.5, 1.5), duration: 25.seconds, curve: Curves.easeInOutSine)
            .move(begin: const Offset(-60, -30), end: const Offset(60, 30), duration: 22.seconds, curve: Curves.easeInOutSine)
            .blur(begin: const Offset(80, 80), end: const Offset(120, 120), duration: 25.seconds, curve: Curves.easeInOutSine),
          ),
          // Deep Cinematic Blur Layer
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.black.withValues(alpha: 0.3),
                      Colors.black.withValues(alpha: 0.6),
                      Colors.black.withValues(alpha: 0.8),
                      Colors.black.withValues(alpha: 0.95),
                    ],
                    stops: const [0.0, 0.3, 0.7, 1.0],
                  ),
                ),
              ),
            ),
          ),
          // Additional Ambient "Breathe" Layer (Dynamic Glow)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.5,
                  colors: [
                    Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            )
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .fadeIn(duration: 4.seconds, curve: Curves.easeInOutSine)
            .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.4, 1.4), duration: 10.seconds, curve: Curves.easeInOutSine),
          ),
          // Subtle Noise Overlay (Editorial Feel)
          Positioned.fill(
            child: Opacity(
              opacity: 0.03,
              child: Image.network(
                'https://www.transparenttextures.com/patterns/p6.png',
                repeat: ImageRepeat.repeat,
                color: Colors.white,
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
                      ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.12), width: 0.5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8),
                                ),
                              ],
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
                      )
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 200.ms)
                      .slideY(begin: -0.2, end: 0, curve: Curves.easeOutCubic),
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
                                          ? LayoutBuilder(
                                              builder: (context, constraints) {
                                                // Trigger layout updates whenever the container's constraints change
                                                _updateVideoLayout();
                                                return Container(
                                                  key: _videoKey,
                                                  decoration: BoxDecoration(
                                                    color: Colors.black,
                                                    borderRadius: BorderRadius.circular(24),
                                                  ),
                                                );
                                              },
                                            )
                                          : _VinylArtwork(
                                              imageUrl: playerState.currentTrack?.albumImage ?? '',
                                              isPlaying: playerState.isPlaying,
                                            )
                                              .animate()
                                              .fadeIn(duration: 800.ms, curve: Curves.easeOut)
                                              .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1), duration: 800.ms, curve: Curves.easeOutCubic),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Control Deck (Glassmorphic Card)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(36),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
                                  child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 28),
                            decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.05),
                                      borderRadius: BorderRadius.circular(36),
                                      border: Border.all(color: Colors.white.withValues(alpha: 0.15), width: 0.5),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.4),
                                          blurRadius: 30,
                                          offset: const Offset(0, 15),
                                        ),
                                        BoxShadow(
                                          color: Colors.white.withValues(alpha: 0.03),
                                          blurRadius: 10,
                                          offset: const Offset(0, -2),
                                          spreadRadius: -2,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        // Premium Highlight Line
                                        Container(
                                          width: 40,
                                          height: 4,
                                          margin: const EdgeInsets.only(bottom: 20),
                                          decoration: BoxDecoration(
                                            color: Colors.white10,
                                            borderRadius: BorderRadius.circular(2),
                                          ),
                                        ),
                                        // Track Info
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                      Text(
                                                        playerState.currentTrack?.name ?? 'Not Playing',
                                                        style: const TextStyle(
                                                          fontSize: 26,
                                                          fontWeight: FontWeight.w900,
                                                          color: Colors.white,
                                                          letterSpacing: -1.2,
                                                          height: 1.1,
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      )
                                                      .animate()
                                                      .fadeIn(duration: 500.ms, delay: 200.ms)
                                                      .slideX(begin: 0.05, duration: 500.ms, curve: Curves.easeOutCubic),
                                                    const SizedBox(height: 2),
                                                    Text(
                                                      playerState.currentTrack?.artistName.toUpperCase() ?? 'UNKNOWN ARTIST',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w800,
                                                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.9),
                                                        letterSpacing: 2.0,
                                                      ),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    )
                                                      .animate()
                                                      .fadeIn(duration: 500.ms, delay: 300.ms)
                                                      .slideX(begin: 0.05, duration: 500.ms, curve: Curves.easeOutCubic),
                                                  ],
                                                ),
                                              ),
                                              if (playerState.currentTrack != null)
                                              TactileIconButton(
                                                icon: playerState.currentTrack!.isFavorite 
                                                  ? Icons.favorite 
                                                  : Icons.favorite_border,
                                                color: playerState.currentTrack!.isFavorite 
                                                  ? Theme.of(context).colorScheme.primary 
                                                  : Colors.white,
                                                onTap: () => playerNotifier.toggleFavorite(playerState.currentTrack!),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        // Progress Slider
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                          child: Column(
                                            children: [
                                              SliderTheme(
                                                data: SliderTheme.of(context).copyWith(
                                                  trackHeight: 4,
                                                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7, elevation: 5),
                                                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
                                                  activeTrackColor: Theme.of(context).colorScheme.primary,
                                                  inactiveTrackColor: Colors.white.withValues(alpha: 0.05),
                                                  thumbColor: Colors.white,
                                                  trackShape: const RoundedRectSliderTrackShape(),
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
                                                        style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
                                                    Text(_formatDuration(playerState.duration),
                                                        style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        // Interaction Controls
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              TactileIconButton(
                                                icon: Icons.shuffle,
                                                color: playerState.isShuffled ? Theme.of(context).colorScheme.primary : Colors.white60,
                                                onTap: playerNotifier.toggleShuffle,
                                              ),
                                              TactileIconButton(
                                                icon: Icons.skip_previous,
                                                size: 32,
                                                onTap: playerNotifier.skipPrevious,
                                              ),
                                              TactilePlayerPlayPauseButton(
                                                isPlaying: playerState.isPlaying,
                                                onTap: playerNotifier.togglePlay,
                                              ),
                                              TactileIconButton(
                                                icon: Icons.skip_next,
                                                size: 32,
                                                onTap: playerNotifier.skipNext,
                                              ),
                                              TactileIconButton(
                                                icon: playerState.repeatMode == RepeatMode.none ? Icons.repeat : Icons.repeat_one,
                                                color: playerState.repeatMode != RepeatMode.none
                                                    ? Theme.of(context).colorScheme.primary
                                                    : Colors.white60,
                                                onTap: playerNotifier.cycleRepeat,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 300.ms)
                  .slideY(begin: 0.05, duration: 600.ms, curve: Curves.easeOutCubic),
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
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.5),
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
        return Padding(
          key: ValueKey(t.spotifyId),
          padding: const EdgeInsets.only(bottom: 12.0),
          child: TactileTap(
            onTap: () => ProviderScope.containerOf(context).read(playerProvider.notifier).skipTo(i),
            scaleDown: 0.98,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isCurrent 
                        ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.12) 
                        : Colors.white.withValues(alpha: 0.03),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isCurrent 
                          ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.5) 
                          : Colors.white.withValues(alpha: 0.12),
                      width: 0.5,
                    ),
                    boxShadow: [
                      if (isCurrent)
                        BoxShadow(
                          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(
                          children: [
                            CachedNetworkImage(
                              imageUrl: t.albumImage ?? '',
                              width: 52,
                              height: 52,
                              fit: BoxFit.cover,
                            ),
                            if (isCurrent)
                              Positioned.fill(
                                child: Container(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  child: Center(
                                    child: Icon(Icons.equalizer, color: Theme.of(context).colorScheme.primary, size: 24),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              t.name,
                              style: TextStyle(
                                color: isCurrent ? Colors.white : Colors.white.withValues(alpha: 0.9),
                                fontWeight: isCurrent ? FontWeight.w900 : FontWeight.w800,
                                fontSize: 17,
                                letterSpacing: -0.7,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              t.artistName.toUpperCase(),
                              style: TextStyle(
                                color: isCurrent 
                                    ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.8) 
                                    : Colors.white.withValues(alpha: 0.4),
                                fontWeight: FontWeight.w900,
                                fontSize: 11,
                                letterSpacing: 1.0,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      ReorderableDragStartListener(
                        index: i,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Icon(
                            Icons.drag_handle, 
                            color: isCurrent 
                                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.6) 
                                : Colors.white.withValues(alpha: 0.2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
          .animate()
          .fadeIn(duration: 400.ms, delay: (i * 50).ms)
          .slideX(begin: 0.1, duration: 400.ms, curve: Curves.easeOutCubic),
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
        final recordSize = height * 0.92;
        return Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // Premium Dynamic Glow (Reactive-style pulse)
            Positioned(
              top: -recordSize * 0.15,
              left: -recordSize * 0.15,
              right: -recordSize * 0.15,
              bottom: -recordSize * 0.15,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary.withValues(alpha: 0.35),
                      Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.4, 1.0],
                  ),
                ),
              )
              .animate(target: widget.isPlaying ? 1 : 0)
              .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.2, 1.2), duration: 2.seconds, curve: Curves.easeInOutSine)
              .custom(
                duration: 2.seconds,
                builder: (context, value, child) => Opacity(
                  opacity: 0.5 + (0.5 * value),
                  child: child,
                ),
              ),
            ),

            // The Vinyl Record (High Fidelity Grooves)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeOutQuart,
              right: widget.isPlaying ? -recordSize * 0.42 : height * 0.04,
              child: RotationTransition(
                turns: _rotationController,
                child: Container(
                  width: recordSize,
                  height: recordSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.6),
                        blurRadius: 30,
                        offset: const Offset(15, 10),
                      ),
                    ],
                    gradient: const SweepGradient(
                      colors: [
                        Color(0xFF0F0F0F),
                        Color(0xFF2A2A2A),
                        Color(0xFF0F0F0F),
                        Color(0xFF333333),
                        Color(0xFF0F0F0F),
                      ],
                      stops: [0.0, 0.25, 0.5, 0.75, 1.0],
                    ),
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white10.withValues(alpha: 0.05), width: 1),
                    ),
                    child: Center(
                      child: Container(
                        width: recordSize * 0.36,
                        height: recordSize * 0.36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFF0F0F0F), width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 10,
                            ),
                          ],
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(widget.imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Center(
                          child: Container(
                            width: recordSize * 0.06,
                            height: recordSize * 0.06,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F0F0F),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white10),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            // The Sleeve (Premium Rounded Corner Card)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 40,
                    offset: const Offset(-10, 20),
                  ),
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.05),
                    blurRadius: 20,
                    offset: const Offset(-5, -5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: CachedNetworkImage(
                  imageUrl: widget.imageUrl,
                  fit: BoxFit.cover,
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  placeholder: (context, url) => Container(color: Colors.white.withValues(alpha: 0.05)),
                  errorWidget: (_, _, _) => Container(
                    color: Colors.white.withValues(alpha: 0.05),
                    child: const Icon(Icons.music_note, size: 64, color: Colors.white12),
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
