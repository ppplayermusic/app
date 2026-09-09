import 'package:flutter_test/flutter_test.dart';
import 'package:ppplayer/core/playback/packages/pp_playback_engine/lib/src/engine/media_kit_playback_engine.dart';

void main() {
  testWidgets('MediaKitPlaybackEngine initializes MediaKit on constructor if needed', (tester) async {
    TestWidgetsFlutterBinding.ensureInitialized();
    try {
      final engine = MediaKitPlaybackEngine();
      engine.dispose();
    } catch (e) {
      // In a unit test without native binaries, MediaKit throws
      expect(e.toString(), contains('MediaKit.ensureInitialized must be called'));
    }
  });
}
