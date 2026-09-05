import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audio_service/audio_service.dart';
import 'playback_providers.dart';
import 'package:pp_playback_engine/pp_playback_engine.dart' as engine;
import 'media_handler.dart';

/// A service that synchronizes the [PlaybackStatus] with the system media controls.
class MediaSyncService {
  MediaSyncService(this.ref) {
    _init();
  }

  final Ref ref;
  ProviderSubscription? _subscription;
  String? _lastTrackId;

  void _init() {
    // Listen to playback status and update system media controls
    _subscription = ref.listen(
      playbackStatusProvider,
      (previous, next) {
        if (next.hasValue && next.value != null) {
          _handleStatusUpdate(next.value!);
        }
      },
      fireImmediately: true,
    );
  }

  engine.PlaybackStatus? _lastStatus;
  DateTime _lastUpdateTime = DateTime.fromMillisecondsSinceEpoch(0);

  void _handleStatusUpdate(engine.PlaybackStatus currentStatus) {
    final handler = ref.read(audioHandlerProvider);
    final track = currentStatus.track;

    // 1. Update Metadata if track changed
    if (track != null && track.id != _lastTrackId) {
      _lastTrackId = track.id;
      handler.updateMetadata(
        id: track.id,
        title: track.title,
        artist: track.artist ?? '',
        artUri: track.artworkUrl,
        duration: currentStatus.duration,
      );
    }

    // 2. Throttle playback state updates
    final now = DateTime.now();
    final stateChanged = _lastStatus?.state != currentStatus.state;
    final playingChanged = _lastStatus?.isPlaying != currentStatus.isPlaying;
    
    // Only update OS if state/playing changed OR if we haven't updated for 1 second
    if (stateChanged || playingChanged || now.difference(_lastUpdateTime).inSeconds >= 1) {
      _lastUpdateTime = now;
      _lastStatus = currentStatus;
      
      handler.updatePlaybackState(
        playing: currentStatus.isPlaying,
        position: currentStatus.position,
        bufferedPosition: currentStatus.buffered,
        processingState: _mapToAudioProcessingState(currentStatus.state),
      );
    }
  }

  AudioProcessingState _mapToAudioProcessingState(engine.PlaybackState state) {
    switch (state) {
      case engine.PlaybackState.idle:
        return AudioProcessingState.idle;
      case engine.PlaybackState.preparing:
        return AudioProcessingState.loading;
      case engine.PlaybackState.buffering:
        return AudioProcessingState.buffering;
      case engine.PlaybackState.ready:
      case engine.PlaybackState.playing:
      case engine.PlaybackState.paused:
        return AudioProcessingState.ready;
      case engine.PlaybackState.ended:
        return AudioProcessingState.completed;
      case engine.PlaybackState.error:
        return AudioProcessingState.error;
    }
  }

  void dispose() {
    _subscription?.close();
  }
}

/// Provider for [MediaSyncService].
final mediaSyncServiceProvider = Provider<MediaSyncService>((ref) {
  final service = MediaSyncService(ref);
  ref.onDispose(() => service.dispose());
  return service;
});
