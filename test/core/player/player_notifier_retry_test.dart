import 'dart:async';
import 'dart:io';
import 'package:hive_ce/hive.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
// ignore_for_file: unused_import, depend_on_referenced_packages, unnecessary_import
import 'package:pp_playback_engine/pp_playback_engine.dart';
import 'package:ppplayer/core/models/track.dart';
import 'package:ppplayer/core/player/player_provider.dart';
import 'package:ppplayer/core/models/resolved_video_candidate.dart';
import 'package:ppplayer/core/models/playback_resolution_error.dart';
import 'package:ppplayer/core/playback/playback_providers.dart';
import 'package:ppplayer/core/playback/playback_service.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart' as yt;
import 'package:ppplayer/core/services/settings_provider.dart';

class FakeSettingsNotifier extends SettingsNotifier {
  @override
  SettingsState build() {
    return SettingsState(
      selectedCountry: 'US',
      autoplayEnabled: false,
      isLoaded: true,
    );
  }
}

// ---------------------------------------------------------------------------
// Stubs
// ---------------------------------------------------------------------------

/// Configurable fake for PlaybackService.
class FakePlaybackService implements PlaybackService {
  List<ResolvedVideoCandidate> candidates;
  final Exception? _throwError;
  int resolveCallCount = 0;

  FakePlaybackService({this.candidates = const [], Exception? throwError})
    : _throwError = throwError;

  @override
  Ref get ref => throw UnimplementedError();

  @override
  Future<List<ResolvedVideoCandidate>> resolveCandidates(
    Track track,
    String? regionCode,
  ) async {
    resolveCallCount++;
    if (_throwError != null) throw _throwError;
    return candidates;
  }

  @override
  Future<void> cacheYoutubeId(String spotifyId, String? youtubeId) async {}

  @override
  Future<void> recordPlay(Track track) async {}

  @override
  Future<void> toggleFavorite(Track track, bool isFavorite) async {}

  @override
  Future<void> prefetchNext(Track track, String? regionCode) async {}

  @override
  Future<List<Track>> getPlaylistTracks(int playlistId) async => [];

  @override
  Future<List<Track>> getRadioTracks(String artistId) async => [];

  @override
  Future<List<Track>> getRecentlyPlayed({int limit = 50}) async => [];
}

/// Fake PlaybackController that records play() calls.
class FakePlaybackController implements PlaybackController {
  @override
  bool get supportsSpeed => true;
  @override
  bool get supportsVideoFitMode => false;

  final _statusController = StreamController<PlaybackStatus>.broadcast();
  final List<String> playedIds = [];
  Completer<void>? nextPlay;
  bool disposed = false;

  void emitStatus(PlaybackStatus s) => _statusController.add(s);

  @override
  Stream<PlaybackStatus> get statusStream => _statusController.stream;

  @override
  Stream<PlaybackEvent> get eventStream => const Stream.empty();

  @override
  PlaybackStatus get currentStatus => const PlaybackStatus();

  @override
  Future<void> play(
    PlaybackTrack track, {
    Duration startAt = Duration.zero,
  }) async {
    playedIds.add(track.id);
    nextPlay?.complete();
    nextPlay = null;
  }

  @override
  Future<void> pause({
    String caller = 'user',
    bool failOnTimeout = false,
  }) async {}

  @override
  Future<void> prepare(PlaybackTrack track, {Duration? position}) async {}

  @override
  Future<void> resume() async {}

  @override
  Future<void> stop() async {}

  @override
  Future<void> seekTo(Duration position) async {}

  @override
  Future<void> setVolume(double volume) async {}

  @override
  Future<void> setSpeed(double speed) async {}

  @override
  dynamic get renderer => null;

  @override
  yt.YoutubePlayerController? get youtubeController => null;

  @override
  Future<void> dispose() async {
    disposed = true;
    _statusController.close();
  }

  @override
  Future<void> setSubtitleTrack(String? uri) async {}

  @override
  bool get supportsExternalSubtitles => false;

  @override
  bool get supportsSubtitleDelay => false;

  @override
  bool get supportsSubtitleTextSize => false;

  @override
  bool get supportsSubtitleBackgroundStyling => false;

  @override
  bool get supportsTrackSelection => false;

  Future<void> setSubtitleDelay(Duration delay) async {}
  @override
  Future<void> setSubtitleAppearance({double? textSize, int? backgroundColor}) async {}
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

Track trackWith({String? youtubeVideoId, String spotifyId = 'spotifyAAA'}) {
  return Track(
    spotifyId: spotifyId,
    name: 'Test Track',
    artistId: 'artist1',
    artistName: 'Artist',
    youtubeVideoId: youtubeVideoId,
  );
}

ProviderContainer makeContainer({
  required PlaybackService service,
  required FakePlaybackController controller,
}) {
  return ProviderContainer(
    overrides: [
      playbackServiceProvider.overrideWithValue(service),
      playbackControllerProvider.overrideWithValue(controller),
      settingsProvider.overrideWith(FakeSettingsNotifier.new),
    ],
  );
}

Future<void> disposeContainer(
  ProviderContainer container,
  FakePlaybackController controller,
) async {
  final notifier = container.read(playerProvider.notifier);
  container.dispose();
  await notifier.persistenceSettled;
  controller.dispose();
}

// ---------------------------------------------------------------------------
// Tests
void main() {
  late Directory hiveDirectory;
  setUp(() async {
    hiveDirectory = await Directory.systemTemp.createTemp('ppplayer-hive-');
    Hive.init(hiveDirectory.path);
    // Disk-backed storage owned by this case, with no shared persisted state.
    await Hive.openBox('player_state');
  });
  tearDown(() async {
    await Hive.close();
    await hiveDirectory.delete(recursive: true);
  });

  group('PlayerNotifier.retryLoad()', () {
    // ------------------------------------------------------------------
    // Case A — Missing YouTube ID (null): must re-resolve, valid ID plays.
    // ------------------------------------------------------------------
    test('Case A: null youtubeVideoId → resolves and plays valid ID', () async {
      const resolvedId = 'dQw4w9WgXcW'; // 11 chars, valid
      final service = FakePlaybackService(
        candidates: [
          ResolvedVideoCandidate(
            videoId: resolvedId,
            title: 'title',
            channel: 'channel',
            confidenceScore: 1.0,
          ),
        ],
      );
      final controller = FakePlaybackController();
      final container = makeContainer(service: service, controller: controller);
      addTearDown(() => disposeContainer(container, controller));

      final notifier = container.read(playerProvider.notifier);

      // Force a track with null ID.
      await notifier.playTrack(trackWith(youtubeVideoId: null));

      expect(service.resolveCallCount, 1);
      expect(controller.playedIds, [resolvedId]);
      expect(container.read(playerProvider).loadError, isNull);
    });

    test(
      'Case A-retry: retryLoad with null ID → re-resolves and plays valid ID',
      () async {
        const resolvedId = 'abcdefghijk';
        final service = FakePlaybackService(
          candidates: [
            ResolvedVideoCandidate(
              videoId: resolvedId,
              title: 'title',
              channel: 'channel',
              confidenceScore: 1.0,
            ),
          ],
        );
        final controller = FakePlaybackController();

        // Use a container with a failing service first
        final emptyService = FakePlaybackService(candidates: []);
        final container = makeContainer(
          service: emptyService,
          controller: controller,
        );
        addTearDown(() => disposeContainer(container, controller));

        final notifier = container.read(playerProvider.notifier);
        await notifier.playTrack(trackWith(youtubeVideoId: null));
        expect(container.read(playerProvider).loadError, isNotNull);
        expect(controller.playedIds, isEmpty);

        emptyService.candidates = service.candidates;
        await notifier.retryLoad();
        expect(emptyService.resolveCallCount, 2);
        expect(controller.playedIds, [resolvedId]);
        expect(container.read(playerProvider).loadError, isNull);
      },
    );

    // ------------------------------------------------------------------
    // Case B — Invalid YouTube ID (Spotify-shaped): must re-resolve.
    // ------------------------------------------------------------------
    test(
      'Case B: invalid cached ID → resolves fresh, invalid never reaches engine',
      () async {
        const resolvedId = 'validYtId11';
        final invalidIds = [
          '4iV5W9uYedL', // 11 chars but matches spotifyId
          'short',
          'https://youtube.com/watch?v=abc',
          'invalid chars!',
        ];

        for (final badId in invalidIds) {
          final spotifyId = badId.length == 11 ? badId : 'spotifyAAA';
          final service = FakePlaybackService(
            candidates: [
              ResolvedVideoCandidate(
                videoId: resolvedId,
                title: 'title',
                channel: 'channel',
                confidenceScore: 1.0,
              ),
            ],
          );
          final controller = FakePlaybackController();
          final container = makeContainer(
            service: service,
            controller: controller,
          );
          addTearDown(() => disposeContainer(container, controller));

          final notifier = container.read(playerProvider.notifier);
          await notifier.playTrack(
            trackWith(youtubeVideoId: badId, spotifyId: spotifyId),
          );

          expect(
            controller.playedIds.contains(badId),
            isFalse,
            reason: 'Invalid ID "$badId" must never reach the engine',
          );
        }
      },
    );

    // ------------------------------------------------------------------
    // Case C — Resolver returns empty list.
    // ------------------------------------------------------------------
    test('Case C: resolver returns [] → no engine call, error set', () async {
      final service = FakePlaybackService(candidates: []);
      final controller = FakePlaybackController();
      final container = makeContainer(service: service, controller: controller);
      addTearDown(() => disposeContainer(container, controller));

      final notifier = container.read(playerProvider.notifier);
      await notifier.playTrack(trackWith(youtubeVideoId: null));

      expect(service.resolveCallCount, 1);
      expect(controller.playedIds, isEmpty); // never reaches engine
      expect(
        container.read(playerProvider).loadError,
        'No YouTube video found for this track',
      );
    });

    // ------------------------------------------------------------------
    // Case D — Network/Exception in resolver: must not crash, skip next.
    // ------------------------------------------------------------------
    test('Case D: resolver throws → no engine call, error set', () async {
      final service = FakePlaybackService(
        throwError: Exception('network error'),
      );
      final controller = FakePlaybackController();
      final container = makeContainer(service: service, controller: controller);
      addTearDown(() => disposeContainer(container, controller));

      final notifier = container.read(playerProvider.notifier);
      await notifier.playTrack(trackWith(youtubeVideoId: null));

      expect(service.resolveCallCount, 1);
      expect(controller.playedIds, isEmpty);
      expect(
        container.read(playerProvider).loadError,
        'Failed to resolve YouTube ID',
      );
    });

    // ------------------------------------------------------------------
    // Case E — Retry then track change race condition
    // ------------------------------------------------------------------
    test('Case E: retryLoad A then select B — B is authoritative', () async {
      const idA = 'vidIdAAA011';
      const idB = 'vidIdBBB011';

      final completer = Completer<List<ResolvedVideoCandidate>>();
      final service = _DelayedFakeService(completer, [
        ResolvedVideoCandidate(
          videoId: idB,
          title: 'title',
          channel: 'channel',
          confidenceScore: 1.0,
        ),
      ]);
      final controller = FakePlaybackController();

      final container = makeContainer(service: service, controller: controller);
      addTearDown(() => disposeContainer(container, controller));

      final notifier = container.read(playerProvider.notifier);

      // Start play A (will block)
      final futureA = notifier.playTrack(
        trackWith(youtubeVideoId: null, spotifyId: 'spotifyAAA'),
      );

      // Start play B (will resolve instantly in our mock)
      await notifier.playTrack(
        trackWith(youtubeVideoId: idB, spotifyId: 'spotifyBBB'),
      );

      // Unblock A
      completer.complete([
        ResolvedVideoCandidate(
          videoId: idA,
          title: 'title',
          channel: 'channel',
          confidenceScore: 1.0,
        ),
      ]);
      await futureA;

      // Only B should have been played, or if both, B must be the LAST one played?
      // Actually because A's playTrack captures generation, when A finishes resolving,
      // it should see that generation has advanced and ABORT before calling controller.play().
      expect(controller.playedIds, [idB]);
    });
  });

  test(
    'ambiguous failures exhaust finite candidates and stop after five track failures',
    () async {
      final service = FakePlaybackService(
        candidates: [
          ResolvedVideoCandidate(
            videoId: 'candidate01',
            title: 'A',
            channel: 'C',
            confidenceScore: 1,
          ),
          ResolvedVideoCandidate(
            videoId: 'candidate02',
            title: 'B',
            channel: 'C',
            confidenceScore: 1,
          ),
        ],
      );
      final controller = FakePlaybackController();
      final container = makeContainer(service: service, controller: controller);
      addTearDown(() => disposeContainer(container, controller));
      final notifier = container.read(playerProvider.notifier);
      final subscription = container.listen(playerProvider, (_, _) {});
      addTearDown(subscription.close);
      await notifier.cycleRepeat();
      await notifier.playTrack(trackWith());
      for (var i = 0; i < 100; i++) {
        controller.emitStatus(
          const PlaybackStatus(
            state: PlaybackState.error,
            error: 'unavailable_media:notEmbeddable',
          ),
        );
        // One event-loop barrier drains the async candidate/cache/stop chain.
        await Future<void>(() {});
      }
      expect(controller.playedIds.length, lessThanOrEqualTo(10));
      expect(service.resolveCallCount, lessThanOrEqualTo(5));
      expect(container.read(playerProvider).loadError, isNotNull);
    },
  );

  group('Preparing State Error Handling', () {
    test(
      'legitimate load failure during preparing triggers recovery',
      () async {
        final fakeService = FakePlaybackService(
          candidates: [
            ResolvedVideoCandidate(
              videoId: 'vid_1',
              title: 'A',
              channel: 'C',
              confidenceScore: 1.0,
            ),
            ResolvedVideoCandidate(
              videoId: 'vid_2',
              title: 'B',
              channel: 'C',
              confidenceScore: 1.0,
            ),
          ],
        );
        final fakeController = FakePlaybackController();

        final container = makeContainer(
          service: fakeService,
          controller: fakeController,
        );

        addTearDown(() => disposeContainer(container, fakeController));

        // Add a listener to ensure the provider is actively mounted
        final sub = container.listen(playerProvider, (previous, next) {});
        addTearDown(sub.close);

        final notifier = container.read(playerProvider.notifier);

        final track = trackWith(youtubeVideoId: null);
        await notifier.playTrack(track);

        // Wait for play dispatch
        await container.pump();
        expect(fakeController.playedIds.length, 1);

        // Emit preparing
        fakeController.emitStatus(
          const PlaybackStatus(state: PlaybackState.preparing),
        );

        await container.pump();

        final recovered = Completer<void>();
        fakeController.nextPlay = recovered;
        // Emit a legitimate fatal error during preparing
        fakeController.emitStatus(
          const PlaybackStatus(
            state: PlaybackState.error,
            error: 'unavailable_media:videoNotFound',
          ),
        );

        await container.pump();

        await recovered.future;
        // Should have advanced to candidate 2 automatically
        expect(fakeController.playedIds.length, 2);
        expect(
          notifier.state.currentTrack?.youtubeVideoId,
          'vid_2',
        ); // Now running candidate 2
      },
    );
  });

  group('Local Source Routing Regression', () {
    test('local track bypasses youtube resolution', () async {
      final service = FakePlaybackService(
        candidates: [
          const ResolvedVideoCandidate(
            videoId: 'online_vid',
            title: 'T',
            channel: 'C',
            confidenceScore: 1.0,
          ),
        ],
      );
      final fakeController = FakePlaybackController();
      final container = makeContainer(
        service: service,
        controller: fakeController,
      );
      final notifier = container.read(playerProvider.notifier);

      const localTrack = Track(
        spotifyId: 'local:1',
        name: 'Local',
        artistId: '1',
        artistName: 'Artist',
        durationMs: 1000,
        sourceType: TrackSourceType.local,
      );

      await notifier.playTrack(localTrack);
      await Future.delayed(Duration.zero);

      expect(
        service.resolveCallCount,
        0,
        reason: 'Should not resolve candidates for local track',
      );
      expect(fakeController.playedIds, contains('local:1'));

      await disposeContainer(container, fakeController);
    });
  });
}

// ---------------------------------------------------------------------------
// Helper: service that blocks until a completer resolves.
// ---------------------------------------------------------------------------
class _DelayedFakeService implements PlaybackService {
  final Completer<List<ResolvedVideoCandidate>> _completer;
  final List<ResolvedVideoCandidate> _instantFallback;
  int calls = 0;

  _DelayedFakeService(this._completer, this._instantFallback);

  @override
  Ref get ref => throw UnimplementedError();

  @override
  Future<List<ResolvedVideoCandidate>> resolveCandidates(
    Track track,
    String? regionCode,
  ) {
    calls++;
    if (calls == 1) return _completer.future;
    return Future.value(_instantFallback); // For track B
  }

  @override
  Future<void> cacheYoutubeId(String spotifyId, String? youtubeId) async {}

  @override
  Future<void> recordPlay(Track track) async {}

  @override
  Future<void> toggleFavorite(Track track, bool isFavorite) async {}

  @override
  Future<void> prefetchNext(Track track, String? regionCode) async {}

  @override
  Future<List<Track>> getPlaylistTracks(int playlistId) async => [];

  @override
  Future<List<Track>> getRadioTracks(String artistId) async => [];

  @override
  Future<List<Track>> getRecentlyPlayed({int limit = 50}) async => [];
}
