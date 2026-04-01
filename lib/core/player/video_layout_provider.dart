import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final videoLayerLinkProvider = Provider((ref) => LayerLink());

/// Holds the size and position of the video "hole" in the PlayerScreen
class VideoLayoutState {
  final Size size;
  final Offset position;
  final bool isReady;

  VideoLayoutState({
    this.size = Size.zero, 
    this.position = Offset.zero,
    this.isReady = false,
  });

  VideoLayoutState copyWith({Size? size, Offset? position, bool? isReady}) {
    return VideoLayoutState(
      size: size ?? this.size,
      position: position ?? this.position,
      isReady: isReady ?? this.isReady,
    );
  }
}

class VideoLayoutNotifier extends StateNotifier<VideoLayoutState> {
  VideoLayoutNotifier() : super(VideoLayoutState());

  void updateLayout(Size size, Offset position) {
    state = state.copyWith(size: size, position: position, isReady: true);
  }

  void clear() {
    state = VideoLayoutState();
  }
}

final videoLayoutProvider = StateNotifierProvider<VideoLayoutNotifier, VideoLayoutState>((ref) {
  return VideoLayoutNotifier();
});
