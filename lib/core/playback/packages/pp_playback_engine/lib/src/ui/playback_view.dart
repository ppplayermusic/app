import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:media_kit_video/media_kit_video.dart' as mk;
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../engine/playback_controller.dart';
import '../models/playback_status.dart';

class PlaybackView extends StatefulWidget {
  final PlaybackController controller;
  final PlaybackStatus status;
  final BoxFit fit;
  final bool showControls;

  const PlaybackView({
    super.key,
    required this.controller,
    required this.status,
    this.fit = BoxFit.cover,
    this.showControls = false,
  });

  @override
  State<PlaybackView> createState() => _PlaybackViewState();
}

class _PlaybackViewState extends State<PlaybackView> {
  bool _toggle = false;
  Size? _lastSize;
  Timer? _pumpTimer;

  @override
  void dispose() {
    _pumpTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Detect window resizing to force the native Windows floating webview to perfectly track its layout
    // position (e.g. following the bottom right of the screen).
    final currentSize = MediaQuery.sizeOf(context);

    final isWindows = !kIsWeb && Platform.isWindows;

    if (isWindows && _lastSize != null && _lastSize != currentSize) {
      // If the window maximized or restored, a single frame might not be enough for the plugin
      // to sync the Win32 window. We pump a few extra rebuilds over the next 150ms to guarantee it catches up!
      _pumpTimer?.cancel();
      int pumpCount = 0;
      _pumpTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        setState(() {});
        pumpCount++;
        if (pumpCount >= 10) {
          timer.cancel();
        }
      });
    }
    _lastSize = currentSize;

    // Toggle a tiny sub-pixel difference to FORCE a Flutter layout pass on every build.
    // Transform.translate only affects painting, which causes the Win32 window to get stuck.
    // Changing the layout constraints forces the platform view to update its global position!
    if (isWindows) {
      _toggle = !_toggle;
    }

    if (widget.status.isIFrameMode &&
        widget.controller.youtubeController != null) {
      debugPrint(
        'PlaybackView: Building YouTube player for ${widget.status.activeVideoId}',
      );
      return ColoredBox(
        color: Colors.transparent,
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Alternate the width by 0.01px to FORCE a layout pass every build.
            // This causes the Win32 platform view to update its global position,
            // which keeps the video tracking the window correctly during resize/maximize.
            final targetWidth =
                constraints.maxWidth - (isWindows && !_toggle ? 0.01 : 0.0);
            return SizedBox(
              width: targetWidth < 0 ? 0.0 : targetWidth,
              height: constraints.maxHeight,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  YoutubePlayer(
                    key: const ValueKey('pp_youtube_iframe'),
                    controller: widget.controller.youtubeController!,
                    backgroundColor: Colors.transparent,
                  ),
                  if (widget.status.state == PlaybackState.preparing ||
                      widget.status.state == PlaybackState.buffering)
                    const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      );
    }

    final renderer = widget.controller.renderer;
    if (renderer == null) {
      // Headless mode (e.g. NativeServicePlaybackEngine on Android)
      return const ColoredBox(color: Colors.black);
    }

    return mk.Video(
      key: ObjectKey(renderer),
      controller: renderer,
      controls:
          widget.showControls ? mk.MaterialVideoControls : mk.NoVideoControls,
      fit: widget.fit,
      fill: Colors.transparent,
    );
  }
}
