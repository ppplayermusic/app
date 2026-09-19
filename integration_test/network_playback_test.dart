import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:media_kit/media_kit.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() { MediaKit.ensureInitialized(); });

  testWidgets('Network HLS Playback Smoke Test', (WidgetTester tester) async {
    final player = Player();
    
    // Apple's public HLS test stream
    final networkUri = 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';
    
    await player.open(Media(networkUri), play: false);
    
    bool hasError = false;
    player.stream.error.listen((event) { hasError = true; print('Error: $event'); });

    await player.play();
    
    // Wait enough time for network buffering
    await Future.delayed(const Duration(seconds: 10));
    
    print('State after 10s: playing=${player.state.playing}, pos=${player.state.position}, width=${player.state.width}, height=${player.state.height}');
    expect(player.state.playing, isTrue, reason: 'Player failed to enter playing state');
    
    // Ensure position is advancing
    final pos1 = player.state.position;
    await Future.delayed(const Duration(seconds: 3));
    final pos2 = player.state.position;
    
    print('Pos1: $pos1, Pos2: $pos2');
    expect(pos2 > pos1, isTrue, reason: 'Playback position is not advancing');
    
    await player.dispose();
    
    expect(hasError, isFalse, reason: 'Player emitted an error during network playback');
  });
}
