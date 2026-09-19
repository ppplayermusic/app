import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:media_kit/media_kit.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() {
    MediaKit.ensureInitialized();
  });

  testWidgets('Video Playback Integration Test', (WidgetTester tester) async {
    final player = Player();

    final assetUri = 'asset://assets/test_fixtures/test_video.mp4';

    await player.open(Media(assetUri), play: false);

    bool hasError = false;
    bool hasVideo = false;

    player.stream.error.listen((event) {
      hasError = true;
      print('Error: $event');
    });
    player.stream.tracks.listen((tracks) {
      if (tracks.video.isNotEmpty) hasVideo = true;
    });

    await player.play();
    await Future.delayed(const Duration(seconds: 1));

    // Verify video tracks are present
    expect(hasVideo, isTrue, reason: 'Video track was not detected');

    // Test pause
    await player.pause();
    await Future.delayed(const Duration(milliseconds: 500));
    expect(player.state.playing, isFalse);

    // Test seek
    await player.seek(const Duration(seconds: 1));
    await Future.delayed(const Duration(milliseconds: 500));
    expect(player.state.position.inMilliseconds, greaterThanOrEqualTo(900));

    // Resume and finish
    await player.play();
    await Future.delayed(const Duration(seconds: 3));

    await player.dispose();

    expect(hasError, isFalse, reason: 'Player emitted an error');
  });
}
