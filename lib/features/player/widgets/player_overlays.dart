import 'dart:async';
import 'package:flutter/material.dart' hide RepeatMode;
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart' as mk;
import 'package:ppplayer/l10n/app_localizations.dart';
import '../../../core/playback/playback_providers.dart';
import '../../../core/player/player_provider.dart';
import '../../../core/services/settings_provider.dart';
import '../../../shared/widgets/tactile_buttons.dart';
import '../../../shared/widgets/artists_links.dart';
import '../../../core/db/app_database.dart' as db;
import '../../../shared/widgets/context_menu/content_context_menu.dart';

class PlayerOverlays extends ConsumerStatefulWidget {
  final VoidCallback onToggleFullscreen;
  final bool isFullscreen;
  final VoidCallback onCollapse;
  final VoidCallback onToggleQueue;
  final Widget middleTopBar;
  final bool alwaysShowControls;

  const PlayerOverlays({
    super.key,
    required this.onToggleFullscreen,
    required this.isFullscreen,
    required this.onCollapse,
    required this.onToggleQueue,
    required this.middleTopBar,
    this.alwaysShowControls = false,
  });

  @override
  ConsumerState<PlayerOverlays> createState() => _PlayerOverlaysState();
}

class _PlayerOverlaysState extends ConsumerState<PlayerOverlays> {
  Timer? _hideTimer;
  bool _controlsVisible = true;
  bool _isHoveringControls = false;
  double? _dragValue;
  final FocusNode _overlayFocusNode = FocusNode();

  mk.Player? get _mkPlayer {
    final engine = ref.read(playbackControllerProvider);
    return engine.renderer?.player;
  }

  @override
  void initState() {
    super.initState();
    _overlayFocusNode.addListener(_onFocusChanged);
    _startHideTimer();
  }

  void _onFocusChanged() {
    if (_overlayFocusNode.hasFocus) {
      _isHoveringControls = true;
      _onInteraction();
    } else {
      _isHoveringControls = false;
      if (_controlsVisible) {
        _startHideTimer();
      }
    }
  }

  @override
  void dispose() {
    _overlayFocusNode.removeListener(_onFocusChanged);
    _overlayFocusNode.dispose();
    _hideTimer?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(PlayerOverlays oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.alwaysShowControls && !oldWidget.alwaysShowControls) {
      if (!_controlsVisible) {
        setState(() {
          _controlsVisible = true;
        });
      }
    }
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        final isPlaying = ref.read(playerProvider).isPlaying;
        if (isPlaying && !_isHoveringControls && _dragValue == null && !widget.alwaysShowControls) {
          setState(() {
            _controlsVisible = false;
          });
        }
      }
    });
  }

  void _onInteraction() {
    if (!_controlsVisible) {
      setState(() {
        _controlsVisible = true;
      });
    }
    _startHideTimer();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    if (duration.inHours > 0) {
      return '${duration.inHours}:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  Future<void> _showTrackSelectionDialog<T>(
    String title,
    List<T> tracks,
    T currentTrack,
    ValueChanged<T> onSelect, {
    VoidCallback? onExternalLoad,
  }) async {
    _isHoveringControls = true; // Block timer while dialog is open
    final selected = await showDialog<T>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...tracks.map((track) {
                  final isSelected = track == currentTrack;
                  final dynamic t = track;
                  String? displayStr;
                  if (t.id == 'no' || t.id == 'none') {
                    displayStr = AppLocalizations.of(context)!.off;
                  } else if (t.title != null && t.title.toString().trim().isNotEmpty) {
                    displayStr = t.title;
                  } else if (t.language != null && t.language.toString().trim().isNotEmpty) {
                    displayStr = t.language;
                  } else {
                    displayStr = t.id;
                  }
                  final String displayTitle = displayStr ?? 'Unknown';
                  return ListTile(
                    title: Text(displayTitle),
                    trailing: isSelected ? const Icon(Icons.check) : null,
                    onTap: () => Navigator.of(context).pop(track),
                  );
                }),
                if (onExternalLoad != null) ...[
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.file_upload),
                    title: Text(AppLocalizations.of(context)!.loadSubtitleFile),
                    onTap: () {
                      Navigator.of(context).pop();
                      onExternalLoad();
                    },
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
    _isHoveringControls = false;
    _onInteraction();

    if (selected != null) {
      onSelect(selected);
    }
  }

  Future<void> _pickExternalSubtitle(mk.Player player) async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['srt', 'vtt'],
      );

      if (result.isNotEmpty && result.single.path != null) {
        final path = result.single.path!;
        await ref.read(playerProvider.notifier).setSubtitleTrack(path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AppLocalizations.of(context)!
                .errorLoadingSubtitle(e.toString()))));
      }
    }
  }

  void _showSpeedMenu(
    BuildContext context,
    PlayerNotifier playerNotifier,
    double currentSpeed,
  ) {
    _isHoveringControls = true; // Block timer while menu is open
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    final speeds = [0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 2.0];
    showMenu<double>(
      context: context,
      position: position,
      items: speeds.map((speed) {
        return PopupMenuItem<double>(
          value: speed,
          child: Row(
            children: [
              Text('${speed}x'),
              if (currentSpeed == speed) ...[
                const Spacer(),
                const Icon(Icons.check, size: 16),
              ],
            ],
          ),
        );
      }).toList(),
    ).then((selected) {
      _isHoveringControls = false;
      _onInteraction();
      if (selected != null) {
        playerNotifier.setSpeed(selected);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final playerState = ref.watch(playerProvider);
    final playerNotifier = ref.read(playerProvider.notifier);
    final settings = ref.watch(settingsProvider);
    final isPlaying = playerState.isPlaying;
    final colorScheme = Theme.of(context).colorScheme;
    final track = playerState.currentTrack;
    final playbackStatus = ref.watch(playbackStatusProvider).value;
    final hasVideo = playbackStatus?.hasVideo ?? false;
    // Capability is derived from live status fields so it updates mid-session
    // (e.g. switching from a local video to YouTube or audio-only).
    // isIFrameMode covers YouTube iframe; !hasVideo covers audio-only tracks.
    final supportsVideoFitMode =
        hasVideo && !(playbackStatus?.isIFrameMode ?? false);

    final showControls = widget.alwaysShowControls || _controlsVisible;

    // When paused, controls must always be visible — the timer guard in
    // _startHideTimer only hides when isPlaying, but if controls were hidden
    // before the pause (e.g. quick play-then-pause) we must restore them.
    if (!isPlaying && !showControls && !widget.alwaysShowControls) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !widget.alwaysShowControls) {
          setState(() => _controlsVisible = true);
          // Don't start hide timer — leave controls up while paused.
        }
      });
    }

    return Listener(
      onPointerHover: (_) => _onInteraction(),
      onPointerDown: (_) => _onInteraction(),
      onPointerMove: (_) => _onInteraction(),
      behavior: HitTestBehavior.translucent,
      child: Focus(
        focusNode: _overlayFocusNode,
        canRequestFocus: false,
        child: Stack(
          children: [
            // ── Tap/Hover-to-restore layer ──────────────────────────────────
            // Active ONLY when controls are hidden. Uses opaque hit testing to
            // reliably intercept the first tap or mouse movement, restoring controls
            // without passing the tap to the underlying native WebView (which would
            // cause an unintended play/pause or link click). Removed when controls
            // are visible so native interactions work normally.
            if (!showControls)
              Positioned.fill(
                child: MouseRegion(
                  onHover: (_) => _onInteraction(),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _onInteraction,
                  ),
                ),
              ),

            // ── Auto-hiding controls ─────────────────────────────────────────
            AnimatedOpacity(
              opacity: showControls ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: ExcludeFocus(
                key: const ValueKey('overlays_exclude_focus'),
                excluding: !showControls,
                child: IgnorePointer(
                  ignoring: !showControls,
                  child: Stack(
              children: [
              // TOP OVERLAY
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: MouseRegion(
                  onEnter: (_) => _isHoveringControls = true,
                  onExit: (_) => _isHoveringControls = false,
                  child: Container(
                    padding: const EdgeInsets.only(top: 16, bottom: 24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.8),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: SafeArea(
                      bottom: false,
                      child: Padding(
                        // Left padding reserves space for the permanent back button
                        // (44px icon + 12px inset) so the middle bar stays centred.
                        padding: const EdgeInsets.only(left: 56, right: 16),
                        child: Row(
                          children: [
                            const Spacer(),
                            widget.middleTopBar,
                            const Spacer(),
                              // Queue button moved to bottom bar
                            const SizedBox(width: 8),
                            if (playerState.supportsSpeed) ...[
                              Builder(
                                builder: (btnContext) => TactileIconButton(
                                  icon: Icons.speed,
                                  color: Colors.white.withValues(alpha: 0.8),
                                  hoverColor: colorScheme.primary,
                                  tooltip: 'Playback Speed',
                                  onTap: () {
                                    _onInteraction();
                                    _showSpeedMenu(btnContext, playerNotifier,
                                        playerState.speed);
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],
                            Builder(
                              builder: (btnContext) => TactileIconButton(
                                icon: Icons.more_vert,
                                color: Colors.white.withValues(alpha: 0.8),
                                hoverColor: colorScheme.primary,
                                tooltip: AppLocalizations.of(context)!.moreOptions,
                                onTap: () {
                                  _onInteraction();
                                  _isHoveringControls = true;
                                  final renderBox = btnContext.findRenderObject()
                                      as RenderBox?;
                                  final offset =
                                      renderBox?.localToGlobal(Offset.zero);
                                  if (track != null) {
                                    showContentContextMenu(
                                      context,
                                      ref,
                                      position: offset != null
                                          ? offset +
                                              Offset(0, renderBox!.size.height)
                                          : Offset.zero,
                                      target: TrackContextTarget(track),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // BOTTOM OVERLAY
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: MouseRegion(
                  onEnter: (_) => _isHoveringControls = true,
                  onExit: (_) => _isHoveringControls = false,
                  child: Container(
                    padding: const EdgeInsets.only(top: 64, bottom: 24, left: 24, right: 24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.85),
                          Colors.black.withValues(alpha: 0.4),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: SafeArea(
                      top: false,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Metadata Row
                          if (track != null)
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        track.name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      ArtistsLinks(
                                        track: track,
                                        style: TextStyle(
                                          color: Colors.white.withValues(alpha: 0.7),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                StreamBuilder<bool>(
                                  stream: ref
                                      .watch(db.appDatabaseProvider)
                                      .watchTrackFavorite(track.spotifyId),
                                  initialData: track.isFavorite,
                                  builder: (context, snapshot) {
                                    final isFav = snapshot.data ?? track.isFavorite;
                                    return TactileIconButton(
                                      icon: isFav
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: isFav ? colorScheme.primary : Colors.white,
                                      onTap: () {
                                        _onInteraction();
                                        playerNotifier.toggleFavorite(
                                            track.copyWith(isFavorite: isFav));
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          const SizedBox(height: 16),
                          // Progress Bar
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 4,
                              thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 6,
                              ),
                              overlayShape: const RoundSliderOverlayShape(
                                overlayRadius: 14,
                              ),
                              activeTrackColor: colorScheme.primary,
                              inactiveTrackColor: Colors.white.withValues(alpha: 0.2),
                              thumbColor: Colors.white,
                            ),
                            child: Builder(
                              builder: (context) {
                                final maxDuration = playerState.duration.inSeconds > 0
                                    ? playerState.duration.inSeconds.toDouble()
                                    : 1.0;
                                return Slider(
                                  value: (_dragValue ??
                                          playerState.position.inSeconds.toDouble())
                                      .clamp(0.0, maxDuration),
                                  max: maxDuration,
                                  onChangeStart: (v) {
                                    _onInteraction();
                                    setState(() => _dragValue = v);
                                  },
                                  onChanged: (v) {
                                    _onInteraction();
                                    setState(() => _dragValue = v);
                                  },
                                  onChangeEnd: (v) {
                                    _onInteraction();
                                    playerNotifier
                                        .seekTo(Duration(seconds: v.toInt()));
                                    setState(() => _dragValue = null);
                                  },
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatDuration(
                                    _dragValue != null
                                        ? Duration(seconds: _dragValue!.toInt())
                                        : playerState.position,
                                  ),
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.7),
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  _formatDuration(playerState.duration),
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.7),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Controls Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Left: Volume/Subtitle/Audio
                              Row(
                                children: [
                                  if (_mkPlayer != null) ...[
                                  IconButton(
                                    icon: const Icon(Icons.closed_caption,
                                        color: Colors.white),
                                    onPressed: () {
                                      _onInteraction();
                                      final player = _mkPlayer;
                                      if (player != null) {
                                        _showTrackSelectionDialog(
                                          AppLocalizations.of(context)!.subtitles,
                                          player.state.tracks.subtitle,
                                          player.state.track.subtitle,
                                          (t) async {
                                            if (t.id == 'no' || t.id == 'none') {
                                              await ref
                                                  .read(playerProvider.notifier)
                                                  .setSubtitleTrack(null);
                                            } else {
                                              player.setSubtitleTrack(t);
                                            }
                                          },
                                          onExternalLoad: () =>
                                              _pickExternalSubtitle(player),
                                        );
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.audiotrack,
                                        color: Colors.white),
                                    onPressed: () {
                                      _onInteraction();
                                      final player = _mkPlayer;
                                      if (player != null) {
                                        _showTrackSelectionDialog(
                                          AppLocalizations.of(context)!.audioTracks,
                                          player.state.tracks.audio,
                                          player.state.track.audio,
                                          (t) => player.setAudioTrack(t),
                                        );
                                      }
                                    },
                                  ),
                                  ],
                                ],
                              ),
                              // Center: Playback controls
                              Row(
                                children: [
                                  TactileIconButton(
                                    icon: Icons.shuffle,
                                    color: playerState.isShuffled
                                        ? colorScheme.primary
                                        : Colors.white.withValues(alpha: 0.6),
                                    onTap: () {
                                      _onInteraction();
                                      playerNotifier.toggleShuffle();
                                    },
                                  ),
                                  TactileIconButton(
                                    icon: Icons.skip_previous,
                                    size: 32,
                                    color: Colors.white,
                                    onTap: () {
                                      _onInteraction();
                                      playerNotifier.skipPrevious();
                                    },
                                  ),
                                  TactilePlayerPlayPauseButton(
                                    isPlaying: playerState.isPlaying,
                                    isLoading: playerState.isLoadingVideo,
                                    size: 64,
                                    onTap: () {
                                      _onInteraction();
                                      playerNotifier.togglePlay();
                                    },
                                  ),
                                  TactileIconButton(
                                    icon: Icons.skip_next,
                                    size: 32,
                                    color: Colors.white,
                                    onTap: () {
                                      _onInteraction();
                                      playerNotifier.skipNext();
                                    },
                                  ),
                                  TactileIconButton(
                                    icon: playerState.repeatMode == RepeatMode.one
                                        ? Icons.repeat_one
                                        : Icons.repeat,
                                    color: playerState.repeatMode != RepeatMode.none
                                        ? colorScheme.primary
                                        : Colors.white.withValues(alpha: 0.6),
                                    onTap: () {
                                      _onInteraction();
                                      playerNotifier.cycleRepeat();
                                    },
                                  ),
                                  TactileIconButton(
                                    icon: Icons.all_inclusive,
                                    color: settings.autoplayEnabled
                                        ? colorScheme.primary
                                        : Colors.white.withValues(alpha: 0.6),
                                    onTap: () {
                                      _onInteraction();
                                      ref.read(settingsProvider.notifier).toggleAutoplay(!settings.autoplayEnabled);
                                    },
                                  ),
                                ],
                              ),
                              // Right: Queue, Fit/Fill, Mini-player, Fullscreen
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.queue_music,
                                      color: Colors.white,
                                    ),
                                    tooltip: AppLocalizations.of(context)!.queue,
                                    onPressed: () {
                                      _onInteraction();
                                      widget.onToggleQueue();
                                    },
                                  ),
                                  if (supportsVideoFitMode)
                                    IconButton(
                                      icon: Icon(
                                        settings.videoFitMode == VideoFitMode.fill
                                            ? Icons.fit_screen
                                            : Icons.crop_free,
                                        color: Colors.white,
                                      ),
                                      tooltip: settings.videoFitMode == VideoFitMode.fill
                                          ? 'Fit'
                                          : 'Fill',
                                      onPressed: () {
                                        _onInteraction();
                                        final next = settings.videoFitMode == VideoFitMode.fit
                                            ? VideoFitMode.fill
                                            : VideoFitMode.fit;
                                        ref.read(settingsProvider.notifier).setVideoFitMode(next);
                                      },
                                    ),
                                  IconButton(
                                    icon: Icon(
                                      widget.isFullscreen
                                          ? Icons.fullscreen_exit
                                          : Icons.fullscreen,
                                      color: Colors.white,
                                    ),
                                    tooltip: widget.isFullscreen
                                        ? 'Exit Fullscreen'
                                        : 'Fullscreen',
                                    onPressed: () {
                                      _onInteraction();
                                      widget.onToggleFullscreen();
                                    },
                                  ),
                                 ],
                               ),
                             ],
                           ),
                         ],
                       ),
                     ),
                   ),
                 ),
               ),
             ],        // end inner Stack children (auto-hiding controls)
           ),          // end inner Stack
         ),            // end IgnorePointer
       ),              // end ExcludeFocus
     ),                // end AnimatedOpacity (auto-hiding)

     // ── Permanent back/collapse button ──────────────────────────────────
     // MUST be the LAST child of the outer Stack so it is painted on top
     // and hit-tested first. Stack traverses children in reverse order for
     // hit-testing, so placing it last guarantees clicks reach it even
     // when the IgnorePointer overlay sits beneath it in z-order.
     Positioned(
       top: 0,
       left: 0,
       child: SafeArea(
         bottom: false,
         child: Padding(
           padding: const EdgeInsets.only(top: 16, left: 12),
           child: TactileIconButton(
             key: const ValueKey('player_back_button_permanent'),
             icon: Icons.keyboard_arrow_down,
             size: 32,
             color: Colors.white,
             padding: EdgeInsets.zero,
             onTap: widget.onCollapse,
           ),
         ),
       ),
     ),
   ],                  // end outer Stack children
 ),                    // end outer Stack
),                     // end Focus
);                     // end Listener / return
  }
}
