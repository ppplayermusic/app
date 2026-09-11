import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../player/player_provider.dart';

final dockMenuServiceProvider = Provider<DockMenuService>((ref) {
  final service = DockMenuService(ref);
  service.init();
  return service;
});

class DockMenuService {
  final Ref ref;
  static const MethodChannel _channel = MethodChannel('com.ppplayer/dock_menu');

  DockMenuService(this.ref);

  void init() {
    _channel.setMethodCallHandler(_handleMethodCall);

    // Listen to player state to update the dock menu
    ref.listen<PlayerState>(playerProvider, (previous, next) {
      if (previous?.isPlaying != next.isPlaying ||
          previous?.isShuffled != next.isShuffled ||
          previous?.repeatMode != next.repeatMode) {
        _updateNativeState(
          isPlaying: next.isPlaying,
          isShuffle: next.isShuffled,
          repeatMode: next.repeatMode.name,
        );
      }
    });
  }

  Future<void> _updateNativeState({
    required bool isPlaying,
    required bool isShuffle,
    required String repeatMode,
  }) async {
    try {
      await _channel.invokeMethod('updateState', {
        'isPlaying': isPlaying,
        'isShuffle': isShuffle,
        'repeatMode': repeatMode,
      });
    } catch (e) {
      // Ignore if not implemented or running on non-macOS
    }
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    final player = ref.read(playerProvider.notifier);

    switch (call.method) {
      case 'playPause':
        player.togglePlay();
        break;
      case 'next':
        player.skipNext();
        break;
      case 'previous':
        player.skipPrevious();
        break;
      case 'toggleShuffle':
        player.toggleShuffle();
        break;
      case 'toggleRepeat':
        player.cycleRepeat();
        break;
      default:
        throw PlatformException(
          code: 'UNIMPLEMENTED',
          message: 'Method ${call.method} not implemented',
        );
    }
  }
}
