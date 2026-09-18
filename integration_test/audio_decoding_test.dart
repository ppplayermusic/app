import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:media_kit/media_kit.dart';
import 'package:path/path.dart' as p;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    MediaKit.ensureInitialized();
  });

  Future<void> testFormat(String extension) async {
    final player = Player();
    final assetUri = 'asset://assets/test_fixtures/test.$extension';
    
    await player.open(Media(assetUri), play: false);
    
    bool completed = false;
    bool hasError = false;
    
    player.stream.error.listen((event) {
      hasError = true;
    });
    
    player.stream.completed.listen((event) {
      completed = event;
    });
    
    await player.play();
    
    // Wait for the 0.5s audio to complete
    await Future.delayed(const Duration(seconds: 2));
    
    await player.dispose();
    
    expect(hasError, isFalse, reason: 'Player emitted an error for $extension');
    expect(completed, isTrue, reason: 'Player did not complete playback for $extension');
  }

  testWidgets('Audio decoding tests', (tester) async {
    final formats = ['wav', 'mp3', 'flac', 'm4a', 'ogg', 'opus', 'wma', 'wv', 'tta', 'ape', 'mpc'];
    for (final format in formats) {
      await testFormat(format);
    }
  });

  testWidgets('Error regression: inaccessible/corrupt files emit error', (tester) async {
    final player = Player();
    
    // Corrupt file
    final corruptUri = 'asset://assets/test_fixtures/corrupt.mp3';
    
    bool hasError = false;
    player.stream.error.listen((event) {
      hasError = true;
    });
    
    await player.open(Media(corruptUri), play: false);
    await player.play();
    
    await Future.delayed(const Duration(seconds: 1));
    await player.dispose();
    
    expect(hasError, isTrue, reason: 'Player should emit error for corrupt/inaccessible file');
  });
}
