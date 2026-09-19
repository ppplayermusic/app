import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart' as yt;
// ignore: depend_on_referenced_packages
import 'package:webview_flutter/webview_flutter.dart';

class FakeWebViewController extends Fake implements WebViewController {
  @override
  Future<void> addJavaScriptChannel(
    String name, {
    required void Function(JavaScriptMessage) onMessageReceived,
  }) async {}
}

// A fake YoutubePlayerController to emit custom events without a real webview
class FakeYoutubeController extends Fake implements yt.YoutubePlayerController {
  final StreamController<yt.YoutubePlayerValue> _streamController =
      StreamController<yt.YoutubePlayerValue>.broadcast();
  yt.YoutubePlayerValue _value = yt.YoutubePlayerValue();
  final _webViewController = FakeWebViewController();

  @override
  WebViewController get webViewController => _webViewController;

  @override
  yt.YoutubePlayerValue get value => _value;

  @override
  StreamSubscription<yt.YoutubePlayerValue> listen(
    void Function(yt.YoutubePlayerValue event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return _streamController.stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  void emitError(String videoId, yt.YoutubeError error) {
    _value = yt.YoutubePlayerValue(
      error: error,
      metaData: yt.YoutubeMetaData(videoId: videoId),
    );
    _streamController.add(_value);
  }

  void emitState(String videoId, yt.PlayerState state) {
    _value = yt.YoutubePlayerValue(
      playerState: state,
      metaData: yt.YoutubeMetaData(videoId: videoId),
    );
    _streamController.add(_value);
  }

  final commands = <({String name, Map<String, Object?> parameters})>[];
  Completer<void>? pauseCompletion,
      volumeCompletion,
      seekCompletion,
      cueCompletion,
      playCompletion;
  int count(String name) => commands.where((c) => c.name == name).length;
  Future<void> record(
    String name, [
    Map<String, Object?> parameters = const {},
    Completer<void>? completion,
  ]) {
    commands.add((name: name, parameters: parameters));
    return completion?.future ?? Future.value();
  }

  @override
  Future<void> playVideo() => record('play', const {}, playCompletion);
  @override
  Future<void> setVolume(int volume) =>
      record('volume', {'volume': volume}, volumeCompletion);
  @override
  Future<void> seekTo({required double seconds, bool allowSeekAhead = true}) =>
      record('seek', {
        'seconds': seconds,
        'allowSeekAhead': allowSeekAhead,
      }, seekCompletion);
  @override
  Future<void> setPlaybackRate(double playbackRate) =>
      record('setPlaybackRate', {'playbackRate': playbackRate});
  @override
  Future<double> get currentTime async => 12;
  @override
  Future<double> get duration async => 200;
  @override
  Future<void> close() => _streamController.close();
  @override
  Future<void> loadVideoById({
    required String videoId,
    double? startSeconds,
    double? endSeconds,
  }) => record('load', {
    'videoId': videoId,
    'startSeconds': startSeconds,
    'endSeconds': endSeconds,
  });
  @override
  Future<void> cueVideoById({
    required String videoId,
    double? startSeconds,
    double? endSeconds,
  }) => record('cue', {
    'videoId': videoId,
    'startSeconds': startSeconds,
    'endSeconds': endSeconds,
  }, cueCompletion);
  @override
  Future<void> pauseVideo() => record('pause', const {}, pauseCompletion);
}
