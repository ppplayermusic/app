import '../../shared/widgets/pp_image.dart';
import 'dart:ui' show lerpDouble;
import 'package:flutter/foundation.dart';
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

  // --- Video surface lifecycle state ---
  // Monotonically incremented whenever a new reveal is initiated.
  // Post-frame callbacks capture this at schedule time and abort if stale.
  int _videoLayoutGeneration = 0;
  // Last measured bounds. Used to deduplicate native bounds updates.
  Rect? _lastVideoBounds;
  // Guards against stacking multiple slot-unavailable retries.
  // When the slot isn't in the tree yet we schedule one retry; this flag
  // prevents additional probes from scheduling redundant retries while one
  // is already pending.
  bool _slotRetryPending = false;
  // Counts consecutive post-frame slot retries within a single trigger sequence.
  // Capped at _kMaxSlotRetries to prevent an unbounded loop when the slot
  // cannot exist (structural issue). Reset by every meaningful state-change
  // trigger so a subsequent real event starts fresh.
  int _slotRetryCount = 0;
  static const int _kMaxSlotRetries = 5;

  @override
  void initState() {
    super.initState();
    // Post-frame: read current state and attempt surface init.
    // This is the primary fix for the restored-session case:
    //   track already non-null, hasVideo already true, view already video
    //   → no ref.listen ever fires, but this runs unconditionally.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        if (kDebugMode) debugPrint('[VideoInit] Player Screen mounted — checking initial state');
        _logCurrentState();
        ensureVideoSurfaceReady('initial_mount');
      }
    });
    // Safety-net probes for slow media resolvers (> 1 frame).
    // The earlier probes handle the case where the screen opens before
    // the media has resolved; the later ones handle slow connections.
    _scheduleInitialLayoutProbes();
  }

  void _logCurrentState() {
    if (!kDebugMode) return;
    final playerView = ref.read(settingsProvider).playerView;
    final track = ref.read(playerProvider).currentTrack;
    final hasVideo =
        ref.read(playbackStatusProvider).asData?.value.hasVideo ?? false;
    debugPrint('[VideoInit] playerView=$playerView');
    debugPrint('[VideoInit] activeTrack=${track?.spotifyId ?? 'none'}');
    debugPrint('[VideoInit] hasVideo=$hasVideo');
    if (!hasVideo) debugPrint('[VideoInit] waiting for media...');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Re-measure immediately on every window resize (macOS / desktop).
    final windowSize = MediaQuery.sizeOf(context);
    if (_lastWindowSize != null && _lastWindowSize != windowSize) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) ensureVideoSurfaceReady('resize');
      });
    }
    _lastWindowSize = windowSize;
  }

  // Safety-net probes for slow media resolvers.
  // These intentionally do NOT increment the generation counter so they
  // don't invalidate each other or a concurrent live transition.
  void _scheduleInitialLayoutProbes() {
    for (final ms in [500, 1000, 1500, 2000]) {
      Future.delayed(Duration(milliseconds: ms), () {
        if (mounted) ensureVideoSurfaceReady('probe_${ms}ms');
      });
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // ensureVideoSurfaceReady
  //
  // Single, authoritative entry point for the video surface lifecycle.
  // Safe to call from any lifecycle event.
  //
  // Required conditions (checked in order):
  //   1. Widget is still mounted.
  //   2. Player view is VIDEO.
  //   3. hasVideo is true (media is actually video-capable).
  //   4. Video slot has measurable bounds in the render tree.
  //
  // If the slot is absent but all other conditions are met, schedules one
  // post-frame retry via _slotRetryPending (de-duplication flag).
  // The flag is cleared *before* the retry executes so the retry can
  // re-arm itself if the slot is still not ready on that frame.
  //
  // Sequence:
  //   position (hidden) → apply bounds → wait one Flutter frame → reveal
  // ──────────────────────────────────────────────────────────────────────────
  void ensureVideoSurfaceReady([String label = 'manual']) {
    if (!mounted) {
      if (kDebugMode) debugPrint('[VideoInit] skipped: unmounted ($label)');
      return;
    }

    final isPipMode = ref.read(playerProvider).isPipMode;
    final isVideoView =
        ref.read(settingsProvider).playerView == PlayerView.video;
    
    // In PiP mode, we MUST render the video surface regardless of the active tab.
    if (!isVideoView && !isPipMode) {
      // Not on video view and not in PiP — nothing to do. Do not retry.
      return;
    }

    // hasVideo must be true before the slot can even exist.
    // If it's not, the slot is definitely not in the tree yet.
    // Return without scheduling a retry — the hasVideo listener will re-trigger
    // us once media becomes video-capable.
    final hasVideo =
        ref.read(playbackStatusProvider).asData?.value.hasVideo ?? false;
    if (!hasVideo) {
      if (kDebugMode) {
        debugPrint('[VideoInit] skipped: hasVideo=false ($label) — waiting for media');
      }
      return;
    }

    final RenderBox? box =
        _videoSlotKey.currentContext?.findRenderObject() as RenderBox?;

    if (box == null || !box.hasSize) {
      // All other conditions are satisfied: view=video, hasVideo=true.
      // The slot just hasn't been laid out yet. Schedule ONE retry, up to
      // _kMaxSlotRetries consecutive frames. After that, stop the frame
      // loop and rely on the event-driven triggers (hasVideo, playerView,
      // track, slot_reflow) to restart initialization.
      if (!_slotRetryPending) {
        if (_slotRetryCount >= _kMaxSlotRetries) {
          if (kDebugMode) {
            debugPrint(
              '[VideoInit] slot unavailable after $_kMaxSlotRetries retries — '
              'stopping frame loop; waiting for event trigger ($label)',
            );
          }
          return;
        }
        _slotRetryPending = true;
        _slotRetryCount++;
        if (kDebugMode) {
          debugPrint(
            '[VideoInit] slot unavailable ($label) → retry '
            '$_slotRetryCount/$_kMaxSlotRetries',
          );
        }
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // Clear BEFORE retry so a subsequent unavailable result can re-arm.
          _slotRetryPending = false;
          if (!mounted) return;
          // Re-check conditions inside the callback: view or hasVideo may
          // have changed since the retry was scheduled.
          final stillPipMode = ref.read(playerProvider).isPipMode;
          final stillVideo =
              ref.read(settingsProvider).playerView == PlayerView.video || stillPipMode;
          final stillHasVideo =
              ref.read(playbackStatusProvider).asData?.value.hasVideo ?? false;
          if (!stillVideo || !stillHasVideo) {
            if (kDebugMode) {
              debugPrint(
                '[VideoInit] retry cancelled: '
                'view=${stillVideo ? 'video/pip' : 'other'} '
                'hasVideo=$stillHasVideo',
              );
            }
            _slotRetryCount = 0; // Reset for next valid trigger.
            return;
          }
          ensureVideoSurfaceReady('slot_retry_$_slotRetryCount');
        });
      } else {
        if (kDebugMode) {
          debugPrint('[VideoInit] slot unavailable ($label) — retry already pending');
        }
      }
      return;
    }

    if (box.size.width <= 0 || box.size.height <= 0) {
      if (kDebugMode) {
        debugPrint('[VideoInit] skipped: invalid slot size (${box.size}) ($label)');
      }
      return;
    }

    // Slot is available — reset the retry counter for the next trigger sequence.
    _slotRetryCount = 0;

    final position = box.localToGlobal(Offset.zero);
    final size = box.size;
    var newBounds =
        Rect.fromLTWH(position.dx, position.dy, size.width, size.height);

    final currentVisible = ref.read(videoLayoutProvider).isVisible;

    // ── Bounds deduplication ────────────────────────────────────────────────
    // Skip if bounds haven't changed materially AND already visible.
    // This prevents redundant native-window commits on each Flutter rebuild.
    final boundsChanged = _lastVideoBounds == null ||
        (_lastVideoBounds!.left - newBounds.left).abs() > 1.0 ||
        (_lastVideoBounds!.top - newBounds.top).abs() > 1.0 ||
        (_lastVideoBounds!.width - newBounds.width).abs() > 1.0 ||
        (_lastVideoBounds!.height - newBounds.height).abs() > 1.0;

    if (!boundsChanged && currentVisible) {
      // Bounds stable and already visible — no-op.
      return;
    }

    _lastVideoBounds = newBounds;
    final generation = ++_videoLayoutGeneration;

    if (kDebugMode) {
      final time = DateTime.now().toIso8601String().substring(11, 23);
      debugPrint('$time [PipDebug][VIDEO_SURFACE] event=ensureVideoSurfaceReady reason=$label hasVideo=$hasVideo videoView=$isVideoView visible=$currentVisible slotExists=true slotSize=${size.width}x${size.height} rect=$newBounds providerBounds=$_lastVideoBounds generation=$generation');
    }

    if (!currentVisible) {
      // ── Position first, reveal second ─────────────────────────────────────
      if (kDebugMode) {
        debugPrint('[VideoInit #$generation] hidden=true, applying native bounds');
      }

      ref
          .read(videoLayoutProvider.notifier)
          .updateLayout(size, position, isVisible: false,
              label: 'position_first ($label)');

      if (kDebugMode) {
        debugPrint('[VideoInit #$generation] scheduling reveal (next frame)');
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          if (kDebugMode) debugPrint('[VideoInit #$generation] reveal skipped: unmounted');
          return;
        }
        if (generation != _videoLayoutGeneration) {
          if (kDebugMode) {
            debugPrint(
              '[VideoInit #$generation] reveal skipped: stale '
              '(current=$_videoLayoutGeneration)',
            );
          }
          return;
        }
        if (ref.read(settingsProvider).playerView != PlayerView.video) {
          if (kDebugMode) {
            debugPrint('[VideoInit #$generation] reveal skipped: playerView changed');
          }
          return;
        }

        if (kDebugMode) {
          debugPrint('[VideoInit #$generation] frame committed → native visible=true');
        }
        ref
            .read(videoLayoutProvider.notifier)
            .updateLayout(size, position, isVisible: true,
                label: 'reveal ($label)');
      });
    } else {
      // Already visible but bounds changed (e.g., resize).
      // Update bounds in place without hiding/showing.
      if (kDebugMode) {
        debugPrint('[VideoInit #$generation] bounds update only (already visible)');
      }
      ref
          .read(videoLayoutProvider.notifier)
          .updateLayout(size, position, isVisible: true, label: label);
    }
  }

  @override
  Widget build(BuildContext context) {
    final playerState = ref.watch(playerProvider);
    final playerNotifier = ref.read(playerProvider.notifier);
    final settings = ref.watch(settingsProvider);
    final track = playerState.currentTrack;

    // Trigger surface init whenever we have track info and the screen is
    // already showing the video slot. This covers the case where the Player
    // Screen was opened *after* the first track started playing and the
    // initial probe schedule (from initState) ran before any slot existed.
    ref.listen(playerProvider.select((s) => s.currentTrack?.spotifyId), (prev, next) {
      if (next != null) {
        if (kDebugMode) {
          debugPrint('[VideoInit] activeTrack changed ($prev -> $next)');
        }
        _slotRetryCount = 0; // Fresh retry budget for this trigger.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) ensureVideoSurfaceReady('track_change');
        });
      }
    });

    ref.listen(
      playerProvider.select((s) => s.isPipMode),
      (prev, next) {
        if (next == false && prev == true) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) ensureVideoSurfaceReady('pip_exit_restored');
          });
        }
      },
    );

    // CRITICAL FIX: Listen for hasVideo becoming true.
    // This is the primary trigger for the cold-start case:
    //   - App opens, first track loads, media resolves → hasVideo flips true.
    //   - The Consumer widget inserts the video slot for the first time.
    //   - LayoutBuilder fires slot_reflow, but ensureVideoSurfaceReady also
    //     fires here independently from the status stream, as a belt-and-
    //     suspenders approach.
    ref.listen(
      playbackStatusProvider.select((s) {
        final data = s.asData;
        if (data == null) return false;
        return data.value.hasVideo;
      }),
      (prev, next) {
        if (next == true && prev != true) {
          if (kDebugMode) debugPrint('[VideoInit] hasVideo became true');
          _slotRetryCount = 0; // Fresh retry budget for this trigger.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) ensureVideoSurfaceReady('hasVideo_true');
          });
        }
      },
    );

    if (track == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: const Center(child: SizedBox.shrink()),
      );
    }

    ref.listen(settingsProvider.select((s) => s.playerView), (prev, next) {
      if (next == PlayerView.video) {
        _slotRetryCount = 0; // Fresh retry budget for this trigger.
        ensureVideoSurfaceReady('playerView->video');
      }
    });

    final isQueueView = settings.playerView == PlayerView.queue;
    final isVideoView = settings.playerView == PlayerView.video;
    final colorScheme = Theme.of(context).colorScheme;
    final isPowerSaver = settings.performanceMode == PerformanceMode.powerSaver;
    final isPipMode = playerState.isPipMode;

    if (isPipMode) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: SizedBox.expand(
          child: _buildPipVideoSlot(),
        ),
      );
    }

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
                                    onTap: () {
                                      if (kDebugMode && !isVideoView) {
                                        debugPrint('[VideoInit] ${settings.playerView.name} -> video');
                                      }
                                      ref
                                          .read(settingsProvider.notifier)
                                          .setPlayerView(PlayerView.video);
                                    },
                                  ),
                                  _ToggleTab(
                                    label: AppLocalizations.of(context)!.artwork,
                                    isActive:
                                        settings.playerView ==
                                        PlayerView.artwork,
                                    onTap: () {
                                      if (kDebugMode && isVideoView) {
                                        debugPrint('[VideoInit] video -> artwork: hiding native surface');
                                      }
                                      ref.read(videoLayoutProvider.notifier).setVisible(false, label: 'sync_hide_for_artwork');
                                      ref
                                          .read(settingsProvider.notifier)
                                          .setPlayerView(PlayerView.artwork);
                                    },
                                  ),
                                  _ToggleTab(
                                    label: AppLocalizations.of(context)!.queue,
                                    isActive: isQueueView,
                                    onTap: () {
                                      if (kDebugMode && isVideoView) {
                                        debugPrint('[VideoInit] video -> queue: hiding native surface');
                                      }
                                      ref.read(videoLayoutProvider.notifier).setVisible(false, label: 'sync_hide_for_queue');
                                      ref
                                          .read(settingsProvider.notifier)
                                          .setPlayerView(PlayerView.queue);
                                    },
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
                  child: Column(
                    children: [
                      Expanded(
                        flex: 3,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          switchInCurve: Curves.easeOutCubic,
                          switchOutCurve: Curves.easeInCubic,
                          layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
                            return Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                ...previousChildren,
                                if (currentChild != null) currentChild,
                              ],
                            );
                          },
                          child: isQueueView
                              ? SizedBox(
                                  key: const ValueKey('queue_view'),
                                  width: double.infinity,
                                  child: _QueueView(playerState: playerState),
                                )
                              : Padding(
                                  key: const ValueKey('presentation_view'),
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
                                        child: AnimatedSwitcher(
                                          duration: const Duration(milliseconds: 250),
                                          switchInCurve: Curves.easeOutCubic,
                                          switchOutCurve: Curves.easeInCubic,
                                          child: isVideoView
                                              ? Consumer(
                                                  key: const ValueKey('video_view'),
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
                                                      builder: (context, constraints) {
                                                        WidgetsBinding.instance
                                                            .addPostFrameCallback(
                                                              (_) => ensureVideoSurfaceReady('slot_reflow'),
                                                            );
                                                        Widget child = Container(
                                                          key: _videoSlotKey,
                                                          decoration: BoxDecoration(
                                                            color: Colors.transparent,
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  24,
                                                                ),
                                                          ),
                                                        );
                                                        return child;
                                                      },
                                                    );
                                                  },
                                                )
                                              : _VinylArtwork(
                                                    key: const ValueKey('artwork_view'),
                                                    imageUrl:
                                                        playerState
                                                            .currentTrack
                                                            ?.albumImage ??
                                                        '',
                                                    isPlaying:
                                                        playerState.isPlaying,
                                                  ),
                                        ),
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

  Widget _buildPipVideoSlot() {
    return LayoutBuilder(
      builder: (context, constraints) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => ensureVideoSurfaceReady('pip_layout_ready'),
        );
        // INVARIANT: The native WebView is rendered via a PlatformView which
        // sits BEHIND the Flutter UI layer on Android. This container marks
        // the dimensions of the video slot but MUST remain transparent. 
        // Adding an opaque color (like Colors.black) here will permanently 
        // block the video surface from being visible to the user.
        return Container(
          key: _videoSlotKey,
          color: Colors.transparent,
        );
      },
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

  const _VinylArtwork({super.key, required this.imageUrl, required this.isPlaying});

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
