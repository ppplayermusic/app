import 'playback_track.dart';

enum PlaybackEventType {
  trackStarted,
  trackEnded,
  playbackResumed,
  playbackPaused,
  playbackError,
  bufferingStarted,
  bufferingEnded,
  positionDiscontinuity,
}

class PlaybackEvent {
  final PlaybackEventType type;
  final PlaybackTrack? track;
  final Duration? position;
  final String? message;

  const PlaybackEvent({
    required this.type,
    this.track,
    this.position,
    this.message,
  });

  @override
  String toString() => 'PlaybackEvent(type: $type, message: $message)';
}
