import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audio_service/audio_service.dart';
import '../cache/image_cache_manager.dart';
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
  Duration? _lastDuration;
  String? _lastArtCacheFile;
  bool _isDisposed = false;

  void _init() {
    // Listen to playback status and update system media controls
    _subscription = ref.listen(playbackStatusProvider, (previous, next) {
      switch (next) {
        case AsyncData(:final value):
          _handleStatusUpdate(value);
        default:
          break;
      }
    }, fireImmediately: true);
  }

  engine.PlaybackStatus? _lastStatus;
  DateTime _lastUpdateTime = DateTime.fromMillisecondsSinceEpoch(0);

  void _handleStatusUpdate(engine.PlaybackStatus currentStatus) {
    final handler = ref.read(audioHandlerProvider);
    final track = currentStatus.track;

    final trackChanged = track != null && track.id != _lastTrackId;
    final durationChanged = track != null && currentStatus.duration != _lastDuration;

    if (trackChanged) {
      _lastArtCacheFile = null;
    }

    if (trackChanged || durationChanged) {
      _lastTrackId = track.id;
      _lastDuration = currentStatus.duration;

      _pushMetadata(track, currentStatus.duration);

      if (trackChanged) {
        final artUrl = track.artworkUrl;
        if (artUrl != null && artUrl.isNotEmpty) {
          _resolveArtwork(track.id, artUrl);
        }
      }
    }

    // 2. Throttle playback state updates to avoid unnecessary COM message loop pumping
    final now = DateTime.now();
    final stateChanged = _lastStatus?.state != currentStatus.state;
    final playingChanged = _lastStatus?.isPlaying != currentStatus.isPlaying;

    // Calculate expected position to detect seeks
    final expectedPosition = _lastStatus != null && _lastStatus!.isPlaying
        ? _lastStatus!.position + now.difference(_lastUpdateTime)
        : _lastStatus?.position ?? Duration.zero;
        
    // Only update OS if state/playing changed OR if position jumped significantly (seek)
    final positionJumped = 
        (currentStatus.position - expectedPosition).inMilliseconds.abs() > 2000;

    if (stateChanged || playingChanged || positionJumped) {
      _lastUpdateTime = now;
      _lastStatus = currentStatus;

      // Run asynchronously to avoid Win32 COM message loop pumping during Flutter's internal phases
      Timer.run(() {
        if (_isDisposed) return;
        handler.updatePlaybackState(
          playing: currentStatus.isPlaying,
          position: currentStatus.position,
          bufferedPosition: currentStatus.buffered,
          speed: currentStatus.speed,
          processingState: _mapToAudioProcessingState(currentStatus.state),
        );
      });
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

  void _pushMetadata(engine.PlaybackTrack track, Duration duration) {
    final handler = ref.read(audioHandlerProvider);
    Timer.run(() {
      if (_isDisposed) return;
      handler.updateMetadata(
        id: track.id,
        title: track.title,
        artist: track.artist ?? '',
        artUri: track.artworkUrl,
        artCacheFile: _lastArtCacheFile,
        duration: duration,
      );
    });
  }

  Future<void> _resolveArtwork(
    String trackId,
    String artworkUrl,
  ) async {
    try {
      // 1. Check if already cached locally
      final fileInfo = await PPImageCacheManager.instance.getFileFromCache(
        artworkUrl,
      );
      if (fileInfo != null) {
        if (_lastTrackId == trackId && !_isDisposed) {
          _lastArtCacheFile = fileInfo.file.path;
          if (_lastStatus?.track != null) {
            _pushMetadata(_lastStatus!.track!, _lastDuration ?? Duration.zero);
          }
        }
        return;
      }

      // 2. If not yet cached, fetch and save to cache
      final file = await PPImageCacheManager.instance.getSingleFile(artworkUrl);

      if (file.existsSync() && _lastTrackId == trackId && !_isDisposed) {
        _lastArtCacheFile = file.path;
        if (_lastStatus?.track != null) {
          _pushMetadata(_lastStatus!.track!, _lastDuration ?? Duration.zero);
        }
      }
    } catch (_) {
      // Graceful fallback: text metadata and artUri are already active
    }
  }

  void dispose() {
    _isDisposed = true;
    _subscription?.close();
  }
}

/// Provider for [MediaSyncService].
final mediaSyncServiceProvider = Provider<MediaSyncService>((ref) {
  final service = MediaSyncService(ref);
  ref.onDispose(() => service.dispose());
  return service;
});
