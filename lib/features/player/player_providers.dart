import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/widgets.dart';

class IsFullscreen extends Notifier<bool> {
  @override
  bool build() => false;

  bool toggle() {
    state = !state;
    return state;
  }

  void setFullscreen(bool value) {
    state = value;
  }
}

final isFullscreenProvider = NotifierProvider<IsFullscreen, bool>(IsFullscreen.new);

class VideoFit extends Notifier<BoxFit> {
  @override
  BoxFit build() => BoxFit.contain;

  void toggle() {
    state = state == BoxFit.contain ? BoxFit.cover : BoxFit.contain;
  }
}

final videoFitProvider = NotifierProvider<VideoFit, BoxFit>(VideoFit.new);
