import 'package:flutter_riverpod/flutter_riverpod.dart';


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
