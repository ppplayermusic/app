import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pp_playback_engine/pp_playback_engine.dart';
import '../models/track.dart';
import 'hybrid_playback_engine.dart';

export 'playback_service.dart' show playbackServiceProvider, PlaybackService;
export 'package:pp_playback_engine/pp_playback_engine.dart';

// Extension to convert App Track to PlaybackTrack
extension TrackToPlayback on Track {
  PlaybackTrack toPlaybackTrack() {
    if (sourceType == TrackSourceType.online) {
      if (youtubeVideoId == null) {
        throw StateError('Cannot create PlaybackTrack: youtubeVideoId is null for online track');
      }
      if (youtubeVideoId!.length != 11 || youtubeVideoId!.contains('http')) {
        throw StateError('Cannot create PlaybackTrack: Invalid online source ID "$youtubeVideoId"');
      }
    }
    return PlaybackTrack(
      id: isLocal ? spotifyId : youtubeVideoId!,
      title: name,
      artist: artistName,
      album: albumName,
      artworkUrl: albumImage,
      duration: durationMs != null ? Duration(milliseconds: durationMs!) : null,
      sourceType: isLocal ? PlaybackSourceType.local : PlaybackSourceType.online,
      // For local tracks, the localFilePath comes from the db (set by LocalFileResolver).
      // That path has already been processed (e.g. Uri.file() called) and is a valid URI string.
      localMediaUri: localFilePath,
      isVideo: isVideoFile,
    );
  }
}

/// The primary playback controller used by the app.
final playbackControllerProvider = Provider<PlaybackController>((ref) {
  final PlaybackController engine;

  if (defaultTargetPlatform == TargetPlatform.android) {
    engine = HybridPlaybackEngine();
  } else {
    engine = MediaKitPlaybackEngine();
  }

  ref.onDispose(() {
    engine.dispose();
  });

  return engine;
});

/// A persistent GlobalKey to keep the Video surface alive across navigation changes.
/// This prevents the "surface destroyed" error on Android when switching tabs.
final videoSurfaceKeyProvider = Provider<GlobalKey>((ref) {
  return GlobalKey(debugLabel: 'ppplayer_persistent_video_surface');
});

/// A stream provider that exposes the current player status.
final playbackStatusProvider = StreamProvider<PlaybackStatus>((ref) {
  final controller = ref.watch(playbackControllerProvider);
  return controller.statusStream;
});
