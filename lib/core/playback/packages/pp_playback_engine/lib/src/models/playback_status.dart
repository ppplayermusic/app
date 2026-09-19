import 'playback_track.dart';

enum PlaybackState {
  idle,
  preparing,
  buffering,
  ready,
  playing,
  paused,
  ended,
  error,
}

class PlaybackStatus {
  final PlaybackTrack? track;
  final PlaybackState state;
  final Duration position;
  final Duration duration;
  final Duration buffered;
  final bool hasVideo;
  final bool isIFrameMode;
  final String? activeVideoId;
  final String? error;
  final double volume;
  final double speed;
  final bool supportsSpeed;
  final int? generation;
  final double? videoAspectRatio;
  final bool isLive;
  final bool isSeekable;

  const PlaybackStatus({
    this.track,
    this.state = PlaybackState.idle,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.buffered = Duration.zero,
    this.hasVideo = false,
    this.isIFrameMode = false,
    this.activeVideoId,
    this.error,
    this.volume = 1.0,
    this.speed = 1.0,
    this.supportsSpeed = false,
    this.generation,
    this.videoAspectRatio,
    this.isLive = false,
    this.isSeekable = true,
  });

  bool get isPlaying => state == PlaybackState.playing;
  bool get isBuffering => state == PlaybackState.buffering;
  bool get isReady =>
      state == PlaybackState.ready ||
      state == PlaybackState.playing ||
      state == PlaybackState.paused;

  PlaybackStatus copyWith({
    PlaybackTrack? track,
    PlaybackState? state,
    Duration? position,
    Duration? duration,
    Duration? buffered,
    bool? hasVideo,
    bool? isIFrameMode,
    String? activeVideoId,
    Object? error = _sentinel,
    bool clearError = false,
    double? volume,
    double? speed,
    bool? supportsSpeed,
    int? generation,
    double? videoAspectRatio,
    bool? isLive,
    bool? isSeekable,
  }) {
    return PlaybackStatus(
      track: track ?? this.track,
      state: state ?? this.state,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      buffered: buffered ?? this.buffered,
      hasVideo: hasVideo ?? this.hasVideo,
      isIFrameMode: isIFrameMode ?? this.isIFrameMode,
      activeVideoId: activeVideoId ?? this.activeVideoId,
      error:
          clearError
              ? null
              : (identical(error, _sentinel) ? this.error : error as String?),
      volume: volume ?? this.volume,
      speed: speed ?? this.speed,
      supportsSpeed: supportsSpeed ?? this.supportsSpeed,
      generation: generation ?? this.generation,
      videoAspectRatio: videoAspectRatio ?? this.videoAspectRatio,
      isLive: isLive ?? this.isLive,
      isSeekable: isSeekable ?? this.isSeekable,
    );
  }

  @override
  String toString() =>
      'PlaybackStatus(state: $state, position: $position, iframe: $isIFrameMode)';
}

const Object _sentinel = Object();
