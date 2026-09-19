import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:media_kit/media_kit.dart';
import 'package:pp_playback_engine/pp_playback_engine.dart';
import 'dart:async';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() {
    MediaKit.ensureInitialized();
  });

  testWidgets('macOS Session Isolation Smoke Test', (
    WidgetTester tester,
  ) async {
    final engine = MediaKitPlaybackEngine();

    engine.statusStream.listen((status) {
      print(
        'TEST STATUS: ${status.state} - ${status.duration} - ${status.position}',
      );
    });

    final trackA = PlaybackTrack(
      id: 'track_a',
      title: 'Track A',
      networkMediaUri:
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      sourceType: PlaybackSourceType.networkStream,
    );

    final trackB = PlaybackTrack(
      id: 'track_b',
      title: 'Track B',
      networkMediaUri:
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
      sourceType: PlaybackSourceType.networkStream,
    );

    print('--- 1. Rapid Switching ---');
    engine.play(trackA);
    await Future.delayed(const Duration(milliseconds: 100));
    engine.play(trackB);
    await Future.delayed(const Duration(milliseconds: 100));
    engine.play(trackA);
    await Future.delayed(
      const Duration(seconds: 10),
    ); // Let it load and play (increased for Android)
    expect(engine.currentStatus.state, PlaybackState.playing);

    print('--- 2. Same-URL Reopening ---');
    engine.play(trackA);
    await Future.delayed(const Duration(seconds: 10)); // Increased for Android
    expect(engine.currentStatus.state, PlaybackState.playing);

    print('--- 3. Pause During Loading ---');
    final pauseCompleter = Completer<void>();
    StreamSubscription? sub;
    sub = engine.statusStream.listen((status) {
      if (status.state == PlaybackState.buffering &&
          !pauseCompleter.isCompleted) {
        pauseCompleter.complete();
      }
    });
    engine.play(trackB);
    // Pause immediately
    engine.pause();
    await Future.delayed(const Duration(seconds: 4));
    sub.cancel();
    expect(engine.currentStatus.state, PlaybackState.paused);

    print('--- 4. Stopping During Loading ---');
    engine.play(trackA);
    // Stop immediately
    engine.stop();
    await Future.delayed(const Duration(seconds: 2));
    expect(engine.currentStatus.state, PlaybackState.idle);

    engine.dispose();
  });
}
