import 'package:audio_service/audio_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'player_provider.dart';

/// An [AudioHandler] that bridges the Flutter player state with the system media controls.
/// It doesn't play audio itself (the WebView does), but it reports the state to the OS.
class PpPlayerAudioHandler extends BaseAudioHandler with QueueHandler {
  PpPlayerAudioHandler(this._containerProvider) {
    // Initial state: stopped
    playbackState.add(playbackState.value.copyWith(
      controls: [
        MediaControl.skipToPrevious,
        MediaControl.play,
        MediaControl.skipToNext,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      processingState: AudioProcessingState.idle,
      playing: false,
    ));
  }

  final ProviderContainer Function() _containerProvider;
  ProviderContainer get _container => _containerProvider();

  /// Update the OS metadata (Title, Artist, Album, Image).
  void updateMetadata({
    required String id,
    required String title,
    required String artist,
    String? album,
    String? artUri,
    Duration? duration,
  }) {
    mediaItem.add(MediaItem(
      id: id,
      title: title,
      artist: artist,
      album: album,
      displayTitle: title,
      displaySubtitle: artist,
      artUri: (artUri != null && artUri.isNotEmpty) ? Uri.parse(artUri) : null,
      duration: duration,
    ));
  }

  /// Update the OS playback state (Playing, Paused, Position).
  void updatePlaybackState({
    required bool playing,
    required Duration position,
    required Duration bufferedPosition,
    AudioProcessingState processingState = AudioProcessingState.ready,
  }) {
    playbackState.add(playbackState.value.copyWith(
      controls: [
        MediaControl.skipToPrevious,
        if (playing) MediaControl.pause else MediaControl.play,
        MediaControl.skipToNext,
        MediaControl.stop,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.play,
        MediaAction.pause,
        MediaAction.skipToNext,
        MediaAction.skipToPrevious,
        MediaAction.stop,
      },
      androidCompactActionIndices: const [0, 1, 2],
      processingState: processingState,
      playing: playing,
      updatePosition: position,
      bufferedPosition: bufferedPosition,
    ));
  }

  // --- Remote Command Handlers ---

  @override
  Future<void> play() async {
    _container.read(playerProvider.notifier).resume();
  }

  @override
  Future<void> pause() async {
    _container.read(playerProvider.notifier).pause();
  }

  @override
  Future<void> skipToNext() async {
    _container.read(playerProvider.notifier).skipNext();
  }

  @override
  Future<void> skipToPrevious() async {
    _container.read(playerProvider.notifier).skipPrevious();
  }

  @override
  Future<void> seek(Duration position) async {
    _container.read(playerProvider.notifier).seekTo(position);
  }

  @override
  Future<void> stop() async {
    _container.read(playerProvider.notifier).pause();
    playbackState.add(playbackState.value.copyWith(
      playing: false,
      processingState: AudioProcessingState.idle,
    ));
    await super.stop();
  }
}

/// Provider for the AudioHandler.
final audioHandlerProvider = Provider<PpPlayerAudioHandler>((ref) {
  throw UnimplementedError('AudioHandler must be initialized in main()');
});
