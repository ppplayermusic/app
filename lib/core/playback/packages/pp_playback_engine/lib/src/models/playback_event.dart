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
  final int? generation;

  const PlaybackEvent({
    required this.type,
    this.track,
    this.position,
    this.message,
    this.generation,
  });

  @override
  String toString() => 'PlaybackEvent(type: $type, message: $message)';
}
