import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audio_service/audio_service.dart';
import 'playback_providers.dart';
import 'package:pp_playback_engine/pp_playback_engine.dart' as engine;
import 'media_handler.dart';
import '../player/player_provider.dart';

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

      final artUrl = track.artworkUrl;
      if (artUrl != null && artUrl.isNotEmpty) {
        _resolveArtwork(track.id, artUrl, track, currentStatus.duration);
      }
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

  Future<void> _resolveArtwork(
    String trackId,
    String artworkUrl,
    engine.PlaybackTrack track,
    Duration? duration,
  ) async {
    try {
      // 1. Check if already cached locally
      final fileInfo = await DefaultCacheManager().getFileFromCache(artworkUrl);
      if (fileInfo != null && fileInfo.file.existsSync()) {
        if (_lastTrackId == trackId) {
          ref.read(audioHandlerProvider).updateMetadata(
                id: track.id,
                title: track.title,
                artist: track.artist ?? '',
                artUri: track.artworkUrl,
                artCacheFile: fileInfo.file.path,
                duration: duration,
              );
        }
        return;
      }

      // 2. If not yet cached, fetch and save to cache
      final file = await DefaultCacheManager().getSingleFile(artworkUrl);
      if (file.existsSync() && _lastTrackId == trackId) {
        ref.read(audioHandlerProvider).updateMetadata(
              id: track.id,
              title: track.title,
              artist: track.artist ?? '',
              artUri: track.artworkUrl,
              artCacheFile: file.path,
              duration: duration,
            );
      }
    } catch (_) {
      // Graceful fallback: text metadata and artUri are already active
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
