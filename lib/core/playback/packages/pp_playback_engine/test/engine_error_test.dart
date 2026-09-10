import 'package:flutter_test/flutter_test.dart';
import 'package:pp_playback_engine/pp_playback_engine.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart' as yt;
import 'fake_youtube_controller.dart';

void main() {
  testWidgets(
    'Engine ignores stale errors for different video IDs but accepts legitimate errors',
    (tester) async {
      final fakeController = FakeYoutubeController();

      final engine = MediaKitPlaybackEngine(
        youtubeControllerFactory: (id, params) => fakeController,
      );

      addTearDown(engine.dispose);
      final statuses = <PlaybackStatus>[];
      final subscription = engine.statusStream.listen(statuses.add);
      addTearDown(subscription.cancel);

      final track1 = const PlaybackTrack(
        id: 'vid_1',
        title: 'T1',
        artist: 'A',
        duration: Duration.zero,
      );
      final track2 = const PlaybackTrack(
        id: 'vid_2',
        title: 'T2',
        artist: 'A',
        duration: Duration.zero,
      );

      // 1. Play track 1
      await engine.play(track1);

      // 2. Play track 2 (simulating a rapid skip)
      await engine.play(track2);

      // We are now waiting for track 2 ('vid_2') to load.
      // The previous track ('vid_1') suddenly emits a delayed network error.
      fakeController.emitError('vid_1', yt.YoutubeError.videoNotFound);

      await tester.pump();

      // The engine should STILL be in preparing state for track 2, ignoring the stale error.
      expect(statuses.last.state, PlaybackState.preparing);
      expect(statuses.last.track?.id, 'vid_2');
      expect(statuses.last.error, isNull);

      // Now track 2 legitimately fails.
      fakeController.emitError('vid_2', yt.YoutubeError.videoNotFound);

      await tester.pump();

      // The engine should accept this error because the video ID matches the current load.
      expect(statuses.last.state, PlaybackState.error);
      expect(statuses.last.error, 'unavailable_media:videoNotFound');
    },
  );

  testWidgets('Engine accepts errors with missing video IDs', (tester) async {
    final fakeController = FakeYoutubeController();
    final engine = MediaKitPlaybackEngine(
      youtubeControllerFactory: (id, params) => fakeController,
    );
    addTearDown(engine.dispose);
    final statuses = <PlaybackStatus>[];
    final subscription = engine.statusStream.listen(statuses.add);
    addTearDown(subscription.cancel);

    await engine.play(
      const PlaybackTrack(
        id: 'vid_1',
        title: 'T1',
        artist: 'A',
        duration: Duration.zero,
      ),
    );

    // Emit an error with an empty video ID
    fakeController.emitError('', yt.YoutubeError.notEmbeddable);
    await tester.pump();

    // Since the video ID is missing, the engine can't prove it's stale, so it must accept it
    expect(statuses.last.state, PlaybackState.error);
    expect(statuses.last.error, 'unavailable_media:notEmbeddable');
  });

  testWidgets('Engine behavior on same-video retry with stale error', (
    tester,
  ) async {
    final fakeController = FakeYoutubeController();
    final engine = MediaKitPlaybackEngine(
      youtubeControllerFactory: (id, params) => fakeController,
    );
    addTearDown(engine.dispose);
    final statuses = <PlaybackStatus>[];
    final subscription = engine.statusStream.listen(statuses.add);
    addTearDown(subscription.cancel);

    final track = const PlaybackTrack(
      id: 'vid_1',
      title: 'T1',
      artist: 'A',
      duration: Duration.zero,
    );

    // 1. Play track
    await engine.play(track);

    // 2. Simulate a user hitting retry (playing the exact same track again)
    await engine.play(track);

    // 3. A stale error from the first attempt arrives
    fakeController.emitError('vid_1', yt.YoutubeError.cannotFindVideo);
    await tester.pump();

    // Currently, the engine accepts it because the videoId matches the current track.
    // This test documents the current known limitation.
    expect(statuses.last.state, PlaybackState.error);
    expect(statuses.last.error, 'unavailable_media:cannotFindVideo');
  });
}
