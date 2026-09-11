import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final videoLayerLinkProvider = Provider((ref) => LayerLink());

/// Holds the size and position of the video "hole" in the PlayerScreen
class VideoLayoutState {
  final Size size;
  final Offset position;
  final bool isReady;
  final bool isVisible;
  final String debugLabel;
  final DateTime updatedAt;

  VideoLayoutState({
    this.size = Size.zero,
    this.position = Offset.zero,
    this.isReady = false,
    this.isVisible = false,
    this.debugLabel = 'initial',
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  VideoLayoutState copyWith({
    Size? size,
    Offset? position,
    bool? isReady,
    bool? isVisible,
    String? debugLabel,
    DateTime? updatedAt,
  }) {
    return VideoLayoutState(
      size: size ?? this.size,
      position: position ?? this.position,
      isReady: isReady ?? this.isReady,
      isVisible: isVisible ?? this.isVisible,
      debugLabel: debugLabel ?? this.debugLabel,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}

class VideoLayoutNotifier extends Notifier<VideoLayoutState> {
  @override
  VideoLayoutState build() => VideoLayoutState();

  void updateLayout(Size size, Offset position, {String label = 'unknown'}) {
    state = state.copyWith(
      size: size,
      position: position,
      isReady: true,
      isVisible: true,
      debugLabel: label,
      updatedAt: DateTime.now(),
    );
  }

  void setVisible(bool visible, {String label = 'visibility_change'}) {
    state = state.copyWith(
      isVisible: visible,
      debugLabel: label,
      updatedAt: DateTime.now(),
    );
  }

  void clear() {
    state = VideoLayoutState(debugLabel: 'cleared');
  }
}

final videoLayoutProvider =
    NotifierProvider<VideoLayoutNotifier, VideoLayoutState>(
      VideoLayoutNotifier.new,
    );
