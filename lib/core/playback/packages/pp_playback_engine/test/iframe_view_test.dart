import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pp_playback_engine/pp_playback_engine.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart' as yt;

class MockPlaybackController extends Mock implements PlaybackController {}

void main() {
  late MockPlaybackController mockController;

  setUp(() {
    mockController = MockPlaybackController();
  });

  testWidgets('PlaybackView renders YoutubePlayer when in IFrame mode', (
    WidgetTester tester,
  ) async {
    // 1. Setup mock state
    const status = PlaybackStatus(
      track: PlaybackTrack(id: 'test_id', title: 'Test Track'),
      state: PlaybackState.playing,
      isIFrameMode: true,
    );

    final ytController = yt.YoutubePlayerController.fromVideoId(
      videoId: 'test_id',
      autoPlay: true,
      params: const yt.YoutubePlayerParams(showFullscreenButton: true),
    );

    when(() => mockController.currentStatus).thenReturn(status);
    when(
      () => mockController.statusStream,
    ).thenAnswer((_) => Stream.value(status));
    when(() => mockController.youtubeController).thenReturn(ytController);

    // 2. Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PlaybackView(controller: mockController, status: status),
        ),
      ),
    );

    // 3. Verify YoutubePlayer is present
    expect(find.byType(yt.YoutubePlayer), findsOneWidget);

    await ytController.close();
  });

  testWidgets('PlaybackView logic branch verification', (
    WidgetTester tester,
  ) async {
    // This test specifically verifies that the build method switches correctly
    // without actually rendering the heavy media_kit widget which fails in tests.

    const statusIFrame = PlaybackStatus(isIFrameMode: true);

    when(() => mockController.currentStatus).thenReturn(statusIFrame);
    when(
      () => mockController.statusStream,
    ).thenAnswer((_) => Stream.value(statusIFrame));
    when(() => mockController.youtubeController).thenReturn(null);

    // Verify IFrame branch doesn't throw even with null youtubeController (it should handle it in build)
    await tester.pumpWidget(
      MaterialApp(
        home: PlaybackView(controller: mockController, status: statusIFrame),
      ),
    );

    // We expect it to NOT find YoutubePlayer if controller is null, which is correct handling
    expect(find.byType(yt.YoutubePlayer), findsNothing);
  });
}
