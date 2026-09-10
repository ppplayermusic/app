import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:pp_playback_engine/pp_playback_engine.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart' as yt;
import 'package:webview_flutter/webview_flutter.dart';

class FakeWebViewController extends Fake implements WebViewController {
  @override
  Future<void> addJavaScriptChannel(String name, {required void Function(JavaScriptMessage) onMessageReceived}) async {}
}

// A fake YoutubePlayerController to emit custom events without a real webview
class FakeYoutubeController extends Fake implements yt.YoutubePlayerController {
  final StreamController<yt.YoutubePlayerValue> _streamController = StreamController<yt.YoutubePlayerValue>.broadcast();
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

  @override
  Future<void> loadVideoById({
    required String videoId,
    double? startSeconds,
    double? endSeconds,
  }) async {
    // Stub
  }
}

void main() {
  test('Engine ignores stale errors for different video IDs but accepts legitimate errors', () async {
    final fakeController = FakeYoutubeController();
    
    final engine = MediaKitPlaybackEngine(
      youtubeControllerFactory: (id, params) => fakeController,
    );
    
    final statuses = <PlaybackStatus>[];
    engine.statusStream.listen((s) => statuses.add(s));

    final track1 = const PlaybackTrack(id: 'vid_1', title: 'T1', artist: 'A', duration: Duration.zero);
    final track2 = const PlaybackTrack(id: 'vid_2', title: 'T2', artist: 'A', duration: Duration.zero);

    // 1. Play track 1
    await engine.play(track1);
    
    // 2. Play track 2 (simulating a rapid skip)
    await engine.play(track2);
    
    // We are now waiting for track 2 ('vid_2') to load.
    // The previous track ('vid_1') suddenly emits a delayed network error.
    fakeController.emitError('vid_1', yt.YoutubeError.videoNotFound);
    
    await Future.delayed(const Duration(milliseconds: 50));
    
    // The engine should STILL be in preparing state for track 2, ignoring the stale error.
    expect(statuses.last.state, PlaybackState.preparing);
    expect(statuses.last.track?.id, 'vid_2');
    expect(statuses.last.error, isNull);
    
    // Now track 2 legitimately fails.
    fakeController.emitError('vid_2', yt.YoutubeError.videoNotFound);
    
    await Future.delayed(const Duration(milliseconds: 50));
    
    // The engine should accept this error because the video ID matches the current load.
    expect(statuses.last.state, PlaybackState.error);
    expect(statuses.last.error, 'unavailable_media:videoNotFound');
  });
}

