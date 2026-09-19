// lib/core/local_library/video_probe_service.dart

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:media_kit/media_kit.dart' hide Track;
import 'package:media_kit_video/media_kit_video.dart';

/// Result of a video probe operation.
enum VideoProbeResult {
  /// A video stream with positive dimensions was confirmed.
  hasVideo,

  /// No video stream was found (audio-only or empty container).
  audioOnly,

  /// The probe timed out or encountered an error; classification is unknown.
  probeFailed,

  /// The probe was cancelled before completing.
  cancelled,
}

/// Isolates video-stream detection from the active playback engine.
///
/// Creates its own short-lived [Player] instance per probe so probing cannot
/// interrupt or contaminate the main playback pipeline.  Concurrency is
/// bounded by [maxConcurrent] to avoid starving playback.
///
/// ## Cover-art guard
/// libmpv can expose embedded cover art via a video track.  The probe uses the
/// combination of `videoParams.w > 0 && videoParams.h > 0 && dw > 0` as a
/// necessary condition.  Embedded still images typically have the same
/// dimensions but zero display-width, or are exposed only as attached pictures
/// (no demuxed video track).  This filter is not perfect, but it avoids the
/// common case of an MP3 with an embedded JPEG being promoted to a video file.
///
/// ## Audio-only MP4
/// An MP4 that contains only AAC/MP3 audio will produce either no
/// [VideoParams] event or one with null w/h.  The probe returns [audioOnly]
/// and [LocalFile.isVideo] is never set.  The file will not appear in the
/// Videos library.  If the user imported it through the audio import path it
/// will appear in the music library; if imported through the video path it
/// will remain silent (not surfaced in either library for that import session)
/// — the user can open it via "Open File" to import it as audio.
class VideoProbeService {
  static const int maxConcurrent = 2;
  static const Duration probeTimeout = Duration(seconds: 8);

  /// Semaphore-style counter to limit parallel probes.
  static int _active = 0;
  static final _queue = <Completer<void>>[];

  /// Probes [mediaUri] for a video stream.
  ///
  /// [mediaUri] must be a valid media_kit URI (e.g. `Uri.file(path).toString()`
  /// or a raw `content://` URI on Android).
  ///
  /// Returns a [VideoProbeResult].  Never throws.
  static Future<VideoProbeResult> probe(
    String mediaUri, {
    CancellationToken? cancellationToken,
  }) async {
    // Honour an already-cancelled token immediately.
    if (cancellationToken?.isCancelled == true) {
      return VideoProbeResult.cancelled;
    }

    // Wait for a slot in the concurrency window.
    if (_active >= maxConcurrent) {
      final waiter = Completer<void>();
      _queue.add(waiter);
      await waiter.future;
    }

    if (cancellationToken?.isCancelled == true) {
      _release();
      return VideoProbeResult.cancelled;
    }

    _active++;
    Player? player;

    try {
      MediaKit.ensureInitialized();
      player = Player();
      // VideoController must exist for the native renderer to decode video
      // Create video controller purely to probe constraints/tracks
      VideoController(player);

      final completer = Completer<VideoProbeResult>();

      // Subscribe to videoParams stream.  The native player emits a
      // VideoParams() (default, with null w/h) when no video is present, and
      // a VideoParams(w:N, h:M, ...) when a video stream is found.
      StreamSubscription<VideoParams>? sub;
      sub = player.stream.videoParams.listen((params) {
        if (completer.isCompleted) return;
        // Guard: w and h must both be positive.  A still image attached to an
        // audio file may produce w/h values of 0 or emit an event with only
        // pixelformat set but no geometry.
        final w = params.w;
        final h = params.h;
        if (w != null && w > 0 && h != null && h > 0) {
          sub?.cancel();
          completer.complete(VideoProbeResult.hasVideo);
        }
      });

      // Listen for errors to resolve the completer early.
      StreamSubscription<String>? errSub;
      errSub = player.stream.error.listen((err) {
        if (completer.isCompleted) return;
        errSub?.cancel();
        sub?.cancel();
        completer.complete(VideoProbeResult.probeFailed);
      });

      // Open the media without starting playback.
      await player.open(Media(mediaUri), play: false);

      // Also watch completed: an audio-only file that loads and immediately
      // signals completion without any videoParams event → audioOnly.
      StreamSubscription<bool>? completedSub;
      completedSub = player.stream.completed.listen((done) {
        if (done && !completer.isCompleted) {
          completedSub?.cancel();
          sub?.cancel();
          errSub?.cancel();
          completer.complete(VideoProbeResult.audioOnly);
        }
      });

      // Timeout and cancellation guard.
      final result = await completer.future
          .timeout(probeTimeout, onTimeout: () => VideoProbeResult.probeFailed)
          .then((r) {
            if (cancellationToken?.isCancelled == true) {
              return VideoProbeResult.cancelled;
            }
            return r;
          });

      sub.cancel();
      errSub.cancel();
      completedSub.cancel();

      // If no videoParams event fired and no error/completion, we consider the
      // stream as audio-only (the timeout catches a genuine hang).
      if (!completer.isCompleted) {
        return VideoProbeResult.audioOnly;
      }

      return result;
    } catch (e) {
      debugPrint('VideoProbeService: probe failed for $mediaUri: $e');
      return VideoProbeResult.probeFailed;
    } finally {
      try {
        await player?.dispose();
      } catch (_) {}
      _release();
    }
  }

  static void _release() {
    _active = (_active - 1).clamp(0, maxConcurrent);
    if (_queue.isNotEmpty) {
      final next = _queue.removeAt(0);
      next.complete();
    }
  }
}

/// Lightweight cancellation token for probe operations.
class CancellationToken {
  bool _cancelled = false;
  bool get isCancelled => _cancelled;
  void cancel() => _cancelled = true;
}
