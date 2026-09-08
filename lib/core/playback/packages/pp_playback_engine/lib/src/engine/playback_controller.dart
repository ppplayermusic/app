import 'dart:async';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../models/playback_status.dart';
import '../models/playback_event.dart';
import '../models/playback_track.dart';

abstract class PlaybackController {
  Stream<PlaybackStatus> get statusStream;
  Stream<PlaybackEvent> get eventStream;
  PlaybackStatus get currentStatus;

  Future<void> play(PlaybackTrack track);
  Future<void> pause();
  Future<void> resume();
  Future<void> stop();
  Future<void> seekTo(Duration position);
  Future<void> setVolume(double volume);
  Future<void> setSpeed(double speed);
  
  /// A platform-specific renderer (e.g. VideoController for media_kit)
  dynamic get renderer;
  
  YoutubePlayerController? get youtubeController;
  
  void dispose();
}
