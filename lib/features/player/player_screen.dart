import '../../shared/widgets/pp_image.dart';
import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart' hide RepeatMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ppplayer/l10n/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:ppplayer/core/cache/image_cache_manager.dart';
import '../../core/playback/playback_providers.dart';
import '../../core/player/player_provider.dart';
import '../../core/player/video_layout_provider.dart';
import '../../core/services/settings_provider.dart';
import '../../shared/widgets/tactile_buttons.dart';
import '../../shared/widgets/adaptive_blur.dart';
import '../../shared/widgets/artists_links.dart';
import '../../shared/widgets/context_menu/content_context_menu.dart';
import '../../core/db/app_database.dart' as db;

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
  final GlobalKey _videoSlotKey = GlobalKey(debugLabel: 'player_video_slot');
  double? _dragValue;
  Size? _lastWindowSize;

  @override
  void initState() {
    super.initState();
    _scheduleLayoutUpdates();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Re-measure immediately on every window resize (macOS / desktop).
    final windowSize = MediaQuery.sizeOf(context);
    if (_lastWindowSize != null && _lastWindowSize != windowSize) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _updateVideoLayout('resize');
      });
    }
    _lastWindowSize = windowSize;
  }

  void _scheduleLayoutUpdates() {
    for (var ms in [0, 50, 100, 250, 500, 800]) {
      Future.delayed(Duration(milliseconds: ms), () {
        if (mounted) _updateVideoLayout('scheduled_$ms');
      });
    }
  }

  void _updateVideoLayout([String label = 'manual']) {
    if (!mounted) return;
    final RenderBox? box =
        _videoSlotKey.currentContext?.findRenderObject() as RenderBox?;
    if (box != null) {
      final position = box.localToGlobal(Offset.zero);
      ref
          .read(videoLayoutProvider.notifier)
          .updateLayout(box.size, position, label: label);
    }
  }

  @override
  Widget build(BuildContext context) {
    final playerState = ref.watch(playerProvider);
    final playerNotifier = ref.read(playerProvider.notifier);
    final settings = ref.watch(settingsProvider);
    final track = playerState.currentTrack;

    if (track == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: Text(AppLocalizations.of(context)!.noTrackPlaying)),
      );
    }

    ref.listen(settingsProvider.select((s) => s.playerView), (prev, next) {
      if (next == PlayerView.video) {
        _scheduleLayoutUpdates();
      } else {
        ref
            .read(videoLayoutProvider.notifier)
            .setVisible(false, label: AppLocalizations.of(context)!.playerscreenviewswitch);
      }
    });

    final isQueueView = settings.playerView == PlayerView.queue;
    final isVideoView = settings.playerView == PlayerView.video;
    final colorScheme = Theme.of(context).colorScheme;
    final isPowerSaver = settings.performanceMode == PerformanceMode.powerSaver;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          Positioned.fill(
            child: RepaintBoundary(
              child: PPImage(
                    imageUrl: track.albumImage ?? '',
                    fit: BoxFit.cover,
                  )
                  .animate(
                    onPlay:
                        (controller) =>
                            isPowerSaver
                                ? null
                                : controller.repeat(reverse: true),
                  )
                  .scale(
                    begin: const Offset(1.1, 1.1),
                    end: const Offset(1.5, 1.5),
                    duration: 25.seconds,
                    curve: Curves.easeInOutSine,
                  )
                  .move(
                    begin: const Offset(-60, -30),
                    end: const Offset(60, 30),
                    duration: 22.seconds,
                    curve: Curves.easeInOutSine,
                  )
                  .blur(
                    begin: const Offset(80, 80),
                    end:
                        isPowerSaver
                            ? const Offset(80, 80)
                            : const Offset(120, 120),
                    duration: 25.seconds,
                    curve: Curves.easeInOutSine,
                  ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorScheme.surface.withValues(alpha: 0.4),
                    colorScheme.surface.withValues(alpha: 0.7),
                    colorScheme.surface.withValues(alpha: 0.85),
                    colorScheme.surface.withValues(alpha: 0.98),
                  ],
                  stops: const [0.0, 0.3, 0.7, 1.0],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 1.5,
                      colors: [
                        Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.08),
                        Colors.transparent,
                      ],
                    ),
                  ),
                )
                .animate(
                  onPlay:
                      (controller) =>
                          isPowerSaver
                              ? null
                              : controller.repeat(reverse: true),
                )
                .fadeIn(duration: 4.seconds, curve: Curves.easeInOutSine)
                .scale(
                  begin: const Offset(0.8, 0.8),
                  end: const Offset(1.4, 1.4),
                  duration: 10.seconds,
                  curve: Curves.easeInOutSine,
                ),
          ),
          Positioned.fill(
            child: Opacity(
              opacity: 0.03,
              child: CachedNetworkImage(
                cacheManager: PPImageCacheManager.instance,
                imageUrl: 'https://www.transparenttextures.com/patterns/p6.png',
                repeat: ImageRepeat.repeat,
                color: colorScheme.onSurface.withValues(alpha: 0.1),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 8.0,
                  ),
                  child: Row(
                    children: [
                      TactileIconButton(
                        icon: Icons.keyboard_arrow_down,
                        size: 32,
                        padding: EdgeInsets.zero,
                        onTap: () => context.pop(),
                      ),
                      const Spacer(),
                      AdaptiveBlur(
                            sigmaX: 12,
                            sigmaY: 12,
                            borderRadius: BorderRadius.circular(28),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: colorScheme.onSurface.withValues(
                                  alpha: 0.05,
                                ),
                                borderRadius: BorderRadius.circular(28),
                                border: Border.all(
                                  color: colorScheme.onSurface.withValues(
                                    alpha: 0.12,
                                  ),
                                  width: 0.5,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _ToggleTab(
                                    label: AppLocalizations.of(context)!.video,
                                    isActive: isVideoView,
                                    onTap:
                                        () => ref
                                            .read(settingsProvider.notifier)
                                            .setPlayerView(PlayerView.video),
                                  ),
                                  _ToggleTab(
                                    label: AppLocalizations.of(context)!.artwork,
                                    isActive:
                                        settings.playerView ==
                                        PlayerView.artwork,
                                    onTap:
                                        () => ref
                                            .read(settingsProvider.notifier)
                                            .setPlayerView(PlayerView.artwork),
                                  ),
                                  _ToggleTab(
                                    label: AppLocalizations.of(context)!.queue,
                                    isActive: isQueueView,
                                    onTap:
                                        () => ref
                                            .read(settingsProvider.notifier)
                                            .setPlayerView(PlayerView.queue),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .animate()
                          .fadeIn(duration: 600.ms, delay: 200.ms)
                          .slideY(
                            begin: -0.2,
                            end: 0,
                            curve: Curves.easeOutCubic,
                          ),
                      const Spacer(),
                      Builder(
                        builder:
                            (btnContext) => TactileIconButton(
                              icon: Icons.more_vert,
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.8,
                              ),
                              hoverColor: colorScheme.primary,
                              tooltip: AppLocalizations.of(context)!.moreOptions,
                              onTap: () {
                                final renderBox =
                                    btnContext.findRenderObject() as RenderBox?;
                                final offset = renderBox?.localToGlobal(
                                  Offset.zero,
                                );
                                showContentContextMenu(
                                  context,
                                  ref,
                                  position:
                                      offset != null
                                          ? offset +
                                              Offset(0, renderBox!.size.height)
                                          : Offset.zero,
                                  target: TrackContextTarget(track),
                                );
                              },
                            ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child:
                      isQueueView
                          ? _QueueView(playerState: playerState)
                          : Column(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0,
                                  ),
                                  child: Center(
                                    child: ConstrainedBox(
                                      constraints: const BoxConstraints(
                                        maxWidth: 800,
                                      ),
                                      child: AspectRatio(
                                        aspectRatio: 16 / 9,
                                        child:
                                            isVideoView
                                                ? Consumer(
                                                  builder: (
                                                    context,
                                                    ref,
                                                    child,
                                                  ) {
                                                    final status =
                                                        ref
                                                            .watch(
                                                              playbackStatusProvider,
                                                            )
                                                            .asData
                                                            ?.value;
                                                    final hasVideo =
                                                        status?.hasVideo ??
                                                        false;

                                                    if (!hasVideo &&
                                                        status != null &&
                                                        status.state !=
                                                            PlaybackState
                                                                .preparing) {
                                                      // Fallback to artwork if the resolved stream is audio-only
                                                      return Stack(
                                                        fit: StackFit.expand,
                                                        children: [
                                                          _VinylArtwork(
                                                            imageUrl:
                                                                playerState
                                                                    .currentTrack
                                                                    ?.albumImage ??
                                                                '',
                                                            isPlaying:
                                                                playerState
                                                                    .isPlaying,
                                                          ),
                                                          Positioned(
                                                            bottom: 12,
                                                            right: 12,
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        8,
                                                                    vertical: 4,
                                                                  ),
                                                              decoration: BoxDecoration(
                                                                color: Theme.of(
                                                                      context,
                                                                    )
                                                                    .colorScheme
                                                                    .surface
                                                                    .withValues(
                                                                      alpha:
                                                                          0.8,
                                                                    ),
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      8,
                                                                    ),
                                                              ),
                                                              child: Text(
                                                                'AUDIO ONLY',
                                                                style: TextStyle(
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w900,
                                                                  color:
                                                                      Theme.of(
                                                                        context,
                                                                      ).colorScheme.primary,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    }

                                                    return LayoutBuilder(
                                                      builder: (context, _) {
                                                        // Fire on every reflow of the slot itself
                                                        // (e.g. after AspectRatio recalculates on resize).
                                                        WidgetsBinding.instance
                                                            .addPostFrameCallback(
                                                              (_) => _updateVideoLayout('slot_reflow'),
                                                            );
                                                        return Container(
                                                          key: _videoSlotKey,
                                                          decoration: BoxDecoration(
                                                            color: Colors.black,
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  24,
                                                                ),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },
                                                )
                                                : _VinylArtwork(
                                                      imageUrl:
                                                          playerState
                                                              .currentTrack
                                                              ?.albumImage ??
                                                          '',
                                                      isPlaying:
                                                          playerState.isPlaying,
                                                    )
                                                    .animate()
                                                    .fadeIn(
                                                      duration: 800.ms,
                                                      curve: Curves.easeOut,
                                                    )
                                                    .scale(
                                                      begin: const Offset(
                                                        0.9,
                                                        0.9,
                                                      ),
                                                      end: const Offset(1, 1),
                                                      duration: 800.ms,
                                                      curve:
                                                          Curves.easeOutCubic,
                                                    ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  0,
                                  16,
                                  24,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(36),
                                  child: RepaintBoundary(
                                    child: AdaptiveBlur(
                                      sigmaX: 20,
                                      sigmaY: 20,
                                      borderRadius: BorderRadius.circular(36),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 28,
                                        ),
                                        decoration: BoxDecoration(
                                          color: colorScheme.surfaceContainerLow
                                              .withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(
                                            36,
                                          ),
                                          border: Border.all(
                                            color: colorScheme.onSurface
                                                .withValues(alpha: 0.08),
                                            width: 0.5,
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                              width: 40,
                                              height: 4,
                                              margin: const EdgeInsets.only(
                                                bottom: 20,
                                              ),
                                              decoration: BoxDecoration(
                                                color: colorScheme.onSurface
                                                    .withValues(alpha: 0.1),
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 24.0,
                                                  ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                              playerState
                                                                      .currentTrack
                                                                      ?.name ??
                                                                  'Not Playing',
                                                              style: TextStyle(
                                                                fontSize: 26,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w900,
                                                                color:
                                                                    colorScheme
                                                                        .onSurface,
                                                                letterSpacing:
                                                                    -1.2,
                                                                height: 1.1,
                                                              ),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            )
                                                            .animate()
                                                            .fadeIn(
                                                              duration: 500.ms,
                                                              delay: 200.ms,
                                                            )
                                                            .slideX(
                                                              begin: 0.05,
                                                              duration: 500.ms,
                                                              curve:
                                                                  Curves
                                                                      .easeOutCubic,
                                                            ),
                                                        const SizedBox(
                                                          height: 2,
                                                        ),
                                                        if (playerState
                                                                .currentTrack !=
                                                            null)
                                                          ArtistsLinks(
                                                                track:
                                                                    playerState
                                                                        .currentTrack!,
                                                                toUpperCase:
                                                                    true,
                                                                style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                  color: Theme.of(
                                                                        context,
                                                                      )
                                                                      .colorScheme
                                                                      .primary
                                                                      .withValues(
                                                                        alpha:
                                                                            0.9,
                                                                      ),
                                                                  letterSpacing:
                                                                      2.0,
                                                                ),
                                                              )
                                                              .animate()
                                                              .fadeIn(
                                                                duration:
                                                                    500.ms,
                                                                delay: 300.ms,
                                                              )
                                                              .slideX(
                                                                begin: 0.05,
                                                                duration:
                                                                    500.ms,
                                                                curve:
                                                                    Curves
                                                                        .easeOutCubic,
                                                              ),
                                                      ],
                                                    ),
                                                  ),
                                                  if (playerState
                                                          .currentTrack !=
                                                      null) ...[
                                                    StreamBuilder<bool>(
                                                      stream: ref
                                                          .watch(
                                                            db.appDatabaseProvider,
                                                          )
                                                          .watchTrackFavorite(
                                                            playerState
                                                                .currentTrack!
                                                                .spotifyId,
                                                          ),
                                                      initialData:
                                                          playerState
                                                              .currentTrack!
                                                              .isFavorite,
                                                      builder: (
                                                        context,
                                                        snapshot,
                                                      ) {
                                                        final isFav =
                                                            snapshot.data ??
                                                            playerState
                                                                .currentTrack!
                                                                .isFavorite;
                                                        return TactileIconButton(
                                                              icon:
                                                                  isFav
                                                                      ? Icons
                                                                          .favorite
                                                                      : Icons
                                                                          .favorite_border,
                                                              color:
                                                                  isFav
                                                                      ? colorScheme
                                                                          .primary
                                                                      : colorScheme
                                                                          .onSurface,
                                                              onTap:
                                                                  () => playerNotifier.toggleFavorite(
                                                                    playerState
                                                                        .currentTrack!
                                                                        .copyWith(
                                                                          isFavorite:
                                                                              isFav,
                                                                        ),
                                                                  ),
                                                            )
                                                            .animate(
                                                              target:
                                                                  isFav ? 1 : 0,
                                                            )
                                                            .scale(
                                                              begin:
                                                                  const Offset(
                                                                    1,
                                                                    1,
                                                                  ),
                                                              end: const Offset(
                                                                1.1,
                                                                1.1,
                                                              ),
                                                              duration: 200.ms,
                                                              curve:
                                                                  Curves
                                                                      .easeOutBack,
                                                            )
                                                            .then()
                                                            .scale(
                                                              begin:
                                                                  const Offset(
                                                                    1.1,
                                                                    1.1,
                                                                  ),
                                                              end: const Offset(
                                                                1,
                                                                1,
                                                              ),
                                                              duration: 150.ms,
                                                            );
                                                      },
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Builder(
                                                      builder:
                                                          (
                                                            btnContext,
                                                          ) => TactileIconButton(
                                                            icon:
                                                                Icons
                                                                    .more_horiz,
                                                            color: colorScheme
                                                                .onSurface
                                                                .withValues(
                                                                  alpha: 0.6,
                                                                ),
                                                            onTap: () {
                                                              final renderBox =
                                                                  btnContext
                                                                          .findRenderObject()
                                                                      as RenderBox?;
                                                              final offset = renderBox
                                                                  ?.localToGlobal(
                                                                    Offset.zero,
                                                                  );
                                                              showContentContextMenu(
                                                                context,
                                                                ref,
                                                                position:
                                                                    offset !=
                                                                            null
                                                                        ? offset +
                                                                            Offset(
                                                                              0,
                                                                              renderBox!.size.height,
                                                                            )
                                                                        : Offset
                                                                            .zero,
                                                                target: TrackContextTarget(
                                                                  playerState
                                                                      .currentTrack!,
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 16.0,
                                                  ),
                                              child: Column(
                                                children: [
                                                  SliderTheme(
                                                    data: SliderTheme.of(
                                                      context,
                                                    ).copyWith(
                                                      trackHeight: 4,
                                                      thumbShape:
                                                          const RoundSliderThumbShape(
                                                            enabledThumbRadius:
                                                                7,
                                                            elevation: 5,
                                                          ),
                                                      overlayShape:
                                                          const RoundSliderOverlayShape(
                                                            overlayRadius: 18,
                                                          ),
                                                      activeTrackColor:
                                                          colorScheme.primary,
                                                      inactiveTrackColor:
                                                          colorScheme.onSurface
                                                              .withValues(
                                                                alpha: 0.05,
                                                              ),
                                                      thumbColor:
                                                          colorScheme.onSurface,
                                                      trackShape:
                                                          const RoundedRectSliderTrackShape(),
                                                    ),
                                                    child: Builder(
                                                      builder: (context) {
                                                        final maxDuration =
                                                            playerState
                                                                        .duration
                                                                        .inSeconds >
                                                                    0
                                                                ? playerState
                                                                    .duration
                                                                    .inSeconds
                                                                    .toDouble()
                                                                : 1.0;
                                                        return Slider(
                                                          value: (_dragValue ??
                                                                  playerState
                                                                      .position
                                                                      .inSeconds
                                                                      .toDouble())
                                                              .clamp(
                                                                0.0,
                                                                maxDuration,
                                                              ),
                                                          max: maxDuration,
                                                          onChangeStart: (v) {
                                                            setState(() {
                                                              _dragValue = v;
                                                            });
                                                          },
                                                          onChanged: (v) {
                                                            setState(() {
                                                              _dragValue = v;
                                                            });
                                                          },
                                                          onChangeEnd: (v) {
                                                            playerNotifier.seekTo(
                                                              Duration(
                                                                seconds:
                                                                    v.toInt(),
                                                              ),
                                                            );
                                                            setState(() {
                                                              _dragValue = null;
                                                            });
                                                          },
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 16.0,
                                                        ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          _formatDuration(
                                                            _dragValue != null
                                                                ? Duration(
                                                                  seconds:
                                                                      _dragValue!
                                                                          .toInt(),
                                                                )
                                                                : playerState
                                                                    .position,
                                                          ),
                                                          style: TextStyle(
                                                            color: colorScheme
                                                                .onSurface
                                                                .withValues(
                                                                  alpha: 0.5,
                                                                ),
                                                            fontSize: 11,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            letterSpacing: 0.5,
                                                          ),
                                                        ),
                                                        Text(
                                                          _formatDuration(
                                                            playerState
                                                                .duration,
                                                          ),
                                                          style: TextStyle(
                                                            color: colorScheme
                                                                .onSurface
                                                                .withValues(
                                                                  alpha: 0.5,
                                                                ),
                                                            fontSize: 11,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            letterSpacing: 0.5,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 20.0,
                                                  ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  TactileIconButton(
                                                    icon: Icons.shuffle,
                                                    color:
                                                        playerState.isShuffled
                                                            ? colorScheme
                                                                .primary
                                                            : colorScheme
                                                                .onSurface
                                                                .withValues(
                                                                  alpha: 0.5,
                                                                ),
                                                    hoverColor:
                                                        playerState.isShuffled
                                                            ? colorScheme
                                                                .primary
                                                            : colorScheme
                                                                .onSurface,
                                                    tooltip: AppLocalizations.of(context)!.shuffle,
                                                    onTap:
                                                        playerNotifier
                                                            .toggleShuffle,
                                                  ),
                                                  TactileIconButton(
                                                    icon: Icons.skip_previous,
                                                    size: 32,
                                                    color:
                                                        colorScheme.onSurface,
                                                    hoverColor:
                                                        colorScheme.primary,
                                                    tooltip: AppLocalizations.of(context)!.previous,
                                                    onTap:
                                                        playerNotifier
                                                            .skipPrevious,
                                                  ),
                                                  TactilePlayerPlayPauseButton(
                                                    isPlaying:
                                                        playerState.isPlaying,
                                                    size: 76,
                                                    onTap:
                                                        playerNotifier
                                                            .togglePlay,
                                                  ),
                                                  TactileIconButton(
                                                    icon: Icons.skip_next,
                                                    size: 32,
                                                    color:
                                                        colorScheme.onSurface,
                                                    hoverColor:
                                                        colorScheme.primary,
                                                    tooltip: AppLocalizations.of(context)!.next,
                                                    onTap:
                                                        playerNotifier.skipNext,
                                                  ),
                                                  TactileIconButton(
                                                    icon:
                                                        playerState.repeatMode ==
                                                                RepeatMode.none
                                                            ? Icons.repeat
                                                            : Icons.repeat_one,
                                                    color:
                                                        playerState.repeatMode !=
                                                                RepeatMode.none
                                                            ? colorScheme
                                                                .primary
                                                            : colorScheme
                                                                .onSurface
                                                                .withValues(
                                                                  alpha: 0.5,
                                                                ),
                                                    hoverColor:
                                                        playerState.repeatMode !=
                                                                RepeatMode.none
                                                            ? colorScheme
                                                                .primary
                                                            : colorScheme
                                                                .onSurface,
                                                    tooltip:
                                                        playerState.repeatMode ==
                                                                RepeatMode.none
                                                            ? 'Repeat Off'
                                                            : (playerState
                                                                        .repeatMode ==
                                                                    RepeatMode
                                                                        .one
                                                                ? 'Repeat One'
                                                                : 'Repeat All'),
                                                    onTap:
                                                        playerNotifier
                                                            .cycleRepeat,
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
                              ),
                            ],
                          ),
                ).animate().fadeIn(duration: 600.ms, delay: 300.ms).slideY(begin: 0.05, duration: 600.ms, curve: Curves.easeOutCubic),
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

  const _ToggleTab({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

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
          color:
              isActive
                  ? Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.1)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            color:
                isActive
                    ? Theme.of(context).colorScheme.onSurface
                    : Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.5),
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
      buildDefaultDragHandles: false,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: playerState.queue.length,
      proxyDecorator:
          (child, index, animation) => AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              final animValue = Curves.easeInOut.transform(animation.value);
              final elevation = lerpDouble(0, 8, animValue)!;
              return Material(
                elevation: elevation,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.1),
                child: child,
              );
            },
            child: child,
          ),
      onReorderItem: (oldIndex, newIndex) {
        ProviderScope.containerOf(
          context,
        ).read(playerProvider.notifier).reorderQueue(oldIndex, newIndex);
      },
      itemBuilder: (context, i) {
        final t = playerState.queue[i];
        final isCurrent = playerState.currentIndex == i;
        final colorScheme = Theme.of(context).colorScheme;
        return KeyedSubtree(
          key: ValueKey(t.queueItemId ?? t.spotifyId),
          child: Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: ContentContextMenuRegion(
                  target: TrackContextTarget(t, isInQueue: true, queueIndex: i),
                  child: TactileTap(
                    onTap:
                        () => ProviderScope.containerOf(
                          context,
                        ).read(playerProvider.notifier).skipTo(i),
                    scaleDown: 0.98,
                    child: AdaptiveBlur(
                      sigmaX: 15,
                      sigmaY: 15,
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color:
                              isCurrent
                                  ? colorScheme.primary.withValues(alpha: 0.12)
                                  : colorScheme.onSurface.withValues(
                                    alpha: 0.03,
                                  ),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color:
                                isCurrent
                                    ? colorScheme.primary.withValues(alpha: 0.5)
                                    : colorScheme.onSurface.withValues(
                                      alpha: 0.12,
                                    ),
                            width: 0.5,
                          ),
                          boxShadow: [
                            if (isCurrent)
                              BoxShadow(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withValues(alpha: 0.15),
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
                                  PPImage(
                                    imageUrl: t.albumImage ?? '',
                                    width: 52,
                                    height: 52,
                                    fit: BoxFit.cover,
                                  ),
                                  if (isCurrent)
                                    Positioned.fill(
                                      child: Container(
                                        color: colorScheme.shadow.withValues(
                                          alpha: 0.3,
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.equalizer,
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.primary,
                                            size: 24,
                                          ),
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
                                      color:
                                          isCurrent
                                              ? colorScheme.onSurface
                                              : colorScheme.onSurface
                                                  .withValues(alpha: 0.9),
                                      fontWeight:
                                          isCurrent
                                              ? FontWeight.w900
                                              : FontWeight.w800,
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
                                      color:
                                          isCurrent
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                                  .withValues(alpha: 0.8)
                                              : colorScheme.onSurface
                                                  .withValues(alpha: 0.4),
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
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                child: Icon(
                                  Icons.drag_handle,
                                  color:
                                      isCurrent
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withValues(alpha: 0.6)
                                          : colorScheme.onSurface.withValues(
                                            alpha: 0.2,
                                          ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
              .animate()
              .fadeIn(duration: 400.ms)
              .slideX(begin: 0.1, duration: 400.ms, curve: Curves.easeOutCubic),
        );
      },
    );
  }
}

class _VinylArtwork extends StatefulWidget {
  final String imageUrl;
  final bool isPlaying;

  const _VinylArtwork({required this.imageUrl, required this.isPlaying});

  @override
  State<_VinylArtwork> createState() => _VinylArtworkState();
}

class _VinylArtworkState extends State<_VinylArtwork>
    with SingleTickerProviderStateMixin {
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
    final colorScheme = Theme.of(context).colorScheme;
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
                          Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.35),
                          Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.08),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.4, 1.0],
                      ),
                    ),
                  )
                  .animate(target: widget.isPlaying ? 1 : 0)
                  .scale(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1.2, 1.2),
                    duration: 2.seconds,
                    curve: Curves.easeInOutSine,
                  )
                  .custom(
                    duration: 2.seconds,
                    builder:
                        (context, value, child) =>
                            Opacity(opacity: 0.5 + (0.5 * value), child: child),
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
                        color: colorScheme.shadow.withValues(alpha: 0.6),
                        blurRadius: 30,
                        offset: const Offset(15, 10),
                      ),
                    ],
                    gradient: SweepGradient(
                      colors: [
                        colorScheme.surfaceContainerHighest,
                        colorScheme.surfaceContainerHigh,
                        colorScheme.surfaceContainerHighest,
                        colorScheme.surfaceContainer,
                        colorScheme.surfaceContainerHighest,
                      ],
                      stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                    ),
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colorScheme.onSurface.withValues(alpha: 0.05),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Container(
                        width: recordSize * 0.36,
                        height: recordSize * 0.36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: colorScheme.surfaceContainerHighest,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.shadow.withValues(alpha: 0.2),
                              blurRadius: 10,
                            ),
                          ],
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                              widget.imageUrl,
                              cacheManager: PPImageCacheManager.instance,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Center(
                          child: Container(
                            width: recordSize * 0.06,
                            height: recordSize * 0.06,
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerHighest,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: colorScheme.onSurface.withValues(
                                  alpha: 0.05,
                                ),
                              ),
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
                    color: colorScheme.shadow.withValues(alpha: 0.5),
                    blurRadius: 40,
                    offset: const Offset(-10, 20),
                  ),
                  BoxShadow(
                    color: colorScheme.onSurface.withValues(alpha: 0.05),
                    blurRadius: 20,
                    offset: const Offset(-5, -5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: PPImage(
                  imageUrl: widget.imageUrl,
                  fit: BoxFit.cover,
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
