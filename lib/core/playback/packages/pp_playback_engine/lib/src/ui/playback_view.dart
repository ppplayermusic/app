import 'package:flutter/material.dart';
import 'package:media_kit_video/media_kit_video.dart' as mk;
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../engine/playback_controller.dart';
import '../models/playback_status.dart';

class PlaybackView extends StatelessWidget {
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
  Widget build(BuildContext context) {
    if (status.isIFrameMode && controller.youtubeController != null) {
      debugPrint('PlaybackView: Building YouTube player for ${status.activeVideoId}');
      return ColoredBox(
        color: Colors.black,
        child: AspectRatio(
          aspectRatio: 16 / 9,
          // Fixed height and width in a SizedBox help the WebView initialize with non-zero dimensions
          child: SizedBox(
            width: 320,
            height: 180,
            child: Stack(
              fit: StackFit.expand,
              children: [
                YoutubePlayer(
                  key: const ValueKey('pp_youtube_iframe'),
                  controller: controller.youtubeController!,
                ),
                if (status.state == PlaybackState.preparing || status.state == PlaybackState.buffering)
                  const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    if (controller.renderer == null) {
      // Headless mode (e.g. NativeServicePlaybackEngine on Android)
      return const ColoredBox(color: Colors.black);
    }

    return mk.Video(
      controller: controller.renderer,
      controls: showControls ? mk.MaterialVideoControls : mk.NoVideoControls,
      fit: fit,
    );
  }
}
