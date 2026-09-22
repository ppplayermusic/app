import 'dart:async';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../models/playback_status.dart';
import '../models/playback_event.dart';
import '../models/playback_track.dart';

abstract class PlaybackController {
  Stream<PlaybackStatus> get statusStream;
  Stream<PlaybackEvent> get eventStream;
  PlaybackStatus get currentStatus;

  Future<void> play(
    PlaybackTrack track, {
    Duration startAt = Duration.zero,
    bool play = true,
  });
  Future<void> pause({String caller = 'user', bool failOnTimeout = false});
  Future<void> resume();
  Future<void> stop();
  Future<void> seekTo(Duration position);
  Future<void> setVolume(double volume);
  Future<void> setSpeed(double speed);
  Future<void> setSubtitleTrack(String? uri);
  Future<void> setSubtitleDelay(Duration delay);
  Future<void> setSubtitleAppearance({double? textSize, int? backgroundColor});
  bool get supportsSpeed;
  bool get supportsTrackSelection;
  bool get supportsExternalSubtitles;
  bool get supportsSubtitleDelay;
  bool get supportsSubtitleTextSize;
  bool get supportsSubtitleBackgroundStyling;

  /// Whether the current rendering path supports switching between Fit and Fill
  /// video scaling modes. False when rendering via YouTube iframe, headless
  /// audio, or any other path that does not expose a native video surface.
  bool get supportsVideoFitMode;

  /// A platform-specific renderer (e.g. VideoController for media_kit)
  dynamic get renderer;

  YoutubePlayerController? get youtubeController;

  Future<void> prepare(PlaybackTrack track, {Duration? position});

  Future<void> dispose();
}
