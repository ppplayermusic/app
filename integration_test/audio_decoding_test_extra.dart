import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:media_kit/media_kit.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() { MediaKit.ensureInitialized(); });

  Future<void> testFormat(String extension) async {
    final player = Player();
    final assetUri = 'asset://assets/test_fixtures/test.$extension';
    await player.open(Media(assetUri), play: false);
    
    bool completed = false;
    bool hasError = false;
    
    player.stream.error.listen((event) { hasError = true; print('Error on $extension: $event'); });
    player.stream.completed.listen((event) { completed = event; });
    
    await player.play();
    await Future.delayed(const Duration(seconds: 2));
    await player.dispose();
    
    expect(hasError, isFalse, reason: 'Player emitted an error for $extension');
    expect(completed, isTrue, reason: 'Player did not complete playback for $extension');
  }

  testWidgets('Audio decoding tests - extra formats', (tester) async {
    final formats = ['ape', 'mpc', 'mod', 'xm', 's3m'];
    for (final format in formats) {
      print('Testing $format...');
      await testFormat(format);
    }
  });
}
