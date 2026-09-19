import 'package:flutter/material.dart' hide RepeatMode;
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ppplayer/features/player/widgets/player_overlays.dart';
import 'package:ppplayer/features/player/player_screen.dart';
import 'package:ppplayer/core/models/track.dart';

import 'package:ppplayer/core/player/player_provider.dart';
import 'package:ppplayer/core/playback/playback_providers.dart';
import 'package:ppplayer/core/services/settings_provider.dart';
import 'package:ppplayer/core/db/app_database.dart';
import 'package:ppplayer/l10n/app_localizations.dart';
import 'package:drift/native.dart';
import 'dart:async';

// ──────────────────────────────────────────────────────────────────────────────
// Test helpers
// ──────────────────────────────────────────────────────────────────────────────

Widget _playerApp({
  required PlayerState playerState,
  required Stream<PlaybackStatus> statusStream,
  SettingsState? initialSettings,
  required AppDatabase db,
}) {
  return ProviderScope(
    overrides: [
      playerProvider.overrideWith(() => _FakePlayerNotifier(playerState)),
      playbackStatusProvider.overrideWith((ref) => statusStream),
      settingsProvider.overrideWith(
        () => _FakeSettingsNotifier(
          initialSettings ?? SettingsState(selectedCountry: 'US'),
        ),
      ),
      appDatabaseProvider.overrideWithValue(db),
    ],
    child: const MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: PlayerScreen()),
    ),
  );
}

Widget _overlaysApp({
  required PlayerState playerState,
  required Stream<PlaybackStatus> statusStream,
  required AppDatabase db,
  bool alwaysShowControls = true,
  VoidCallback? onCollapse,
}) {
  return ProviderScope(
    overrides: [
      playerProvider.overrideWith(() => _FakePlayerNotifier(playerState)),
      playbackStatusProvider.overrideWith((ref) => statusStream),
      settingsProvider.overrideWith(
        () => _FakeSettingsNotifier(SettingsState(selectedCountry: 'US')),
      ),
      appDatabaseProvider.overrideWithValue(db),
    ],
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: PlayerOverlays(
          isFullscreen: false,
          onToggleFullscreen: () {},
          onCollapse: onCollapse ?? () {},
          onToggleQueue: () {},
          middleTopBar: const SizedBox(),
          alwaysShowControls: alwaysShowControls,
        ),
      ),
    ),
  );
}

Track _localVideoTrack() => Track(
  spotifyId: 'local-vid',
  name: 'Local Video',
  artistId: 'a',
  artistName: 'Artist',
  sourceType: TrackSourceType.local,
  isVideoFile: true,
);

Track _localAudioTrack() => Track(
  spotifyId: 'local-audio',
  name: 'Local Audio',
  artistId: 'a',
  artistName: 'Artist',
  sourceType: TrackSourceType.local,
);

Track _youtubeTrack() => Track(
  youtubeVideoId: 'yt-vid-123',
  spotifyId: 'yt-123',
  name: 'YouTube Track',
  artistId: 'a',
  artistName: 'Artist',
  sourceType: TrackSourceType.online,
);

Future<void> _flush(WidgetTester tester) async {
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

Future<void> _pumpHideTimer(WidgetTester tester) async {
  await tester.pump(const Duration(seconds: 4));
}

Future<void> _unmount(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pumpAndSettle();
  await tester.pump(const Duration(seconds: 4));
}

// ──────────────────────────────────────────────────────────────────────────────
// Tests
// ──────────────────────────────────────────────────────────────────────────────

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  // ── Group 1: Fit/Fill capability gating ────────────────────────────────────

  group('Fit/Fill capability gating', () {
    testWidgets(
      'shows Fit/Fill for local video (hasVideo=true, isIFrameMode=false)',
      (tester) async {
        final queue = PlaybackQueue(
          tracks: [_localVideoTrack()],
          currentIndex: 0,
        );
        await tester.pumpWidget(
          _overlaysApp(
            playerState: PlayerState(playbackQueue: queue, isPlaying: true),
            statusStream: Stream.value(
              const PlaybackStatus(
                state: PlaybackState.playing,
                hasVideo: true,
              ),
            ),
            db: db,
          ),
        );
        await tester.pump();

        final hasFitIcon =
            find.byIcon(Icons.fit_screen).evaluate().isNotEmpty ||
            find.byIcon(Icons.crop_free).evaluate().isNotEmpty;
        expect(
          hasFitIcon,
          isTrue,
          reason: 'Fit/Fill button must appear for local video',
        );
        await _unmount(tester);
      },
    );

    testWidgets('hides Fit/Fill when isIFrameMode=true (YouTube iframe)', (
      tester,
    ) async {
      final queue = PlaybackQueue(tracks: [_youtubeTrack()], currentIndex: 0);
      await tester.pumpWidget(
        _overlaysApp(
          playerState: PlayerState(playbackQueue: queue, isPlaying: true),
          statusStream: Stream.value(
            const PlaybackStatus(
              state: PlaybackState.playing,
              hasVideo: true,
              isIFrameMode: true,
            ),
          ),
          db: db,
        ),
      );
      await tester.pump();
      expect(find.byIcon(Icons.fit_screen), findsNothing);
      expect(find.byIcon(Icons.crop_free), findsNothing);
      await _unmount(tester);
    });

    testWidgets('hides Fit/Fill for audio-only track (hasVideo=false)', (
      tester,
    ) async {
      final queue = PlaybackQueue(
        tracks: [_localAudioTrack()],
        currentIndex: 0,
      );
      await tester.pumpWidget(
        _overlaysApp(
          playerState: PlayerState(playbackQueue: queue, isPlaying: true),
          statusStream: Stream.value(
            const PlaybackStatus(state: PlaybackState.playing),
          ),
          db: db,
        ),
      );
      await tester.pump();
      expect(find.byIcon(Icons.fit_screen), findsNothing);
      expect(find.byIcon(Icons.crop_free), findsNothing);
      await _unmount(tester);
    });

    testWidgets(
      'Fit/Fill disappears when status switches to iframe mid-session',
      (tester) async {
        final queue = PlaybackQueue(
          tracks: [_localVideoTrack()],
          currentIndex: 0,
        );
        final controller = StreamController<PlaybackStatus>.broadcast();
        await tester.pumpWidget(
          _overlaysApp(
            playerState: PlayerState(playbackQueue: queue, isPlaying: true),
            statusStream: controller.stream,
            db: db,
          ),
        );

        controller.add(
          const PlaybackStatus(state: PlaybackState.playing, hasVideo: true),
        );
        await tester.pump();

        final hasFitInitially =
            find.byIcon(Icons.fit_screen).evaluate().isNotEmpty ||
            find.byIcon(Icons.crop_free).evaluate().isNotEmpty;
        expect(hasFitInitially, isTrue);

        // Switch to YouTube iframe.
        controller.add(
          const PlaybackStatus(
            state: PlaybackState.playing,
            hasVideo: true,
            isIFrameMode: true,
          ),
        );
        await tester.pump();

        expect(find.byIcon(Icons.fit_screen), findsNothing);
        expect(find.byIcon(Icons.crop_free), findsNothing);

        await controller.close();
        await _unmount(tester);
      },
    );
  });

  // ── Group 1b: Back button always accessible ────────────────────────────────

  group('Permanent back button', () {
    testWidgets('back button present and tappable when controls are hidden', (
      tester,
    ) async {
      // Scenario: video is playing and controls have auto-hidden.
      // The permanent back button must still be in the tree and not ignored.
      final queue = PlaybackQueue(
        tracks: [_localVideoTrack()],
        currentIndex: 0,
      );
      bool collapseCalled = false;

      await tester.pumpWidget(
        _overlaysApp(
          playerState: PlayerState(playbackQueue: queue, isPlaying: true),
          statusStream: Stream.value(
            const PlaybackStatus(state: PlaybackState.playing, hasVideo: true),
          ),
          db: db,
          alwaysShowControls:
              false, // simulate video playing with controls hidden
          onCollapse: () => collapseCalled = true,
        ),
      );
      // Pump enough frames to settle AnimatedOpacity/AnimatedScale without
      // hitting the repeating hide-timer (avoid pumpAndSettle which times out).
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      // The permanent back button should always be present by key —
      // even when alwaysShowControls=false hides the rest of the overlay.
      final backBtnFinder = find.byKey(
        const ValueKey('player_back_button_permanent'),
      );
      expect(
        backBtnFinder,
        findsOneWidget,
        reason: 'Permanent back button must always be in the widget tree',
      );

      // Verify it is outside the IgnorePointer subtree by ensuring it is
      // actually tappable. Use ensureVisible first to confirm layout.
      await tester.ensureVisible(backBtnFinder);
      await tester.pump();
      await tester.tap(backBtnFinder);
      await tester.pump();
      expect(
        collapseCalled,
        isTrue,
        reason: 'Tapping the permanent back button must invoke onCollapse',
      );

      await _unmount(tester);
    });

    testWidgets('controls restore to visible when track pauses', (
      tester,
    ) async {
      // Scenario: controls were hidden (e.g., auto-hid while playing),
      // then the track pauses. Controls must become visible again.
      final queue = PlaybackQueue(
        tracks: [_localVideoTrack()],
        currentIndex: 0,
      );
      final stateController = StreamController<PlaybackStatus>.broadcast();

      await tester.pumpWidget(
        _overlaysApp(
          playerState: PlayerState(playbackQueue: queue, isPlaying: false),
          statusStream: stateController.stream,
          db: db,
        ),
      );
      stateController.add(
        const PlaybackStatus(state: PlaybackState.paused, hasVideo: true),
      );
      await tester.pump();
      // After a frame callback the controls should be forced visible.
      await tester.pump(const Duration(milliseconds: 50));

      // The auto-hiding overlay must NOT be at opacity 0 when paused.
      final opacity = tester
          .widget<AnimatedOpacity>(
            find
                .ancestor(
                  of: find.byKey(const ValueKey('overlays_exclude_focus')),
                  matching: find.byType(AnimatedOpacity),
                )
                .first,
          )
          .opacity;
      expect(
        opacity,
        equals(1.0),
        reason: 'Controls must be fully visible when playback is paused',
      );

      await stateController.close();
      await _unmount(tester);
    });
  });

  // ── Group 2: Queue dismissal and view restoration ─────────────────────────

  group('Queue dismissal and view restoration', () {
    testWidgets('close button restores previous view (artwork→queue→artwork)', (
      tester,
    ) async {
      final queue = PlaybackQueue(
        tracks: [_localAudioTrack()],
        currentIndex: 0,
      );
      final initial = SettingsState(
        selectedCountry: 'US',
        playerView: PlayerView.artwork,
      );
      tester.view.physicalSize = const Size(600, 900);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        _playerApp(
          playerState: PlayerState(playbackQueue: queue, isPlaying: false),
          statusStream: Stream.value(const PlaybackStatus()),
          initialSettings: initial,
          db: db,
        ),
      );
      await _flush(tester);

      // Open queue from artwork.
      final ctx = tester.element(find.byType(PlayerScreen));
      ProviderScope.containerOf(
        ctx,
      ).read(settingsProvider.notifier).setPlayerView(PlayerView.queue);
      await _flush(tester);

      expect(find.byKey(const ValueKey('queue_close_button')), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('queue_close_button')));
      await _flush(tester);

      // Must restore artwork, not video.
      expect(
        ProviderScope.containerOf(ctx).read(settingsProvider).playerView,
        PlayerView.artwork,
      );

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      await _unmount(tester);
    });

    testWidgets('wide-screen queue side panel shows no close button', (
      tester,
    ) async {
      final queue = PlaybackQueue(
        tracks: [_localAudioTrack()],
        currentIndex: 0,
      );
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        _playerApp(
          playerState: PlayerState(playbackQueue: queue, isPlaying: false),
          statusStream: Stream.value(const PlaybackStatus()),
          db: db,
        ),
      );
      await _flush(tester);

      final ctx = tester.element(find.byType(PlayerScreen));
      ProviderScope.containerOf(
        ctx,
      ).read(settingsProvider.notifier).setPlayerView(PlayerView.queue);
      await _flush(tester);

      expect(find.byKey(const ValueKey('queue_close_button')), findsNothing);

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      await _unmount(tester);
    });

    testWidgets('PopScope.canPop=false on narrow, true on wide', (
      tester,
    ) async {
      final queue = PlaybackQueue(
        tracks: [_localAudioTrack()],
        currentIndex: 0,
      );

      // Narrow first.
      tester.view.physicalSize = const Size(600, 900);
      tester.view.devicePixelRatio = 1.0;
      await tester.pumpWidget(
        _playerApp(
          playerState: PlayerState(playbackQueue: queue, isPlaying: false),
          statusStream: Stream.value(const PlaybackStatus()),
          db: db,
        ),
      );
      await _flush(tester);

      final ctx = tester.element(find.byType(PlayerScreen));
      ProviderScope.containerOf(
        ctx,
      ).read(settingsProvider.notifier).setPlayerView(PlayerView.queue);
      await _flush(tester);

      expect(
        tester
            .widget<PopScope>(find.byKey(const ValueKey('player_pop_scope')))
            .canPop,
        isFalse,
      );

      // Switch to wide.
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      await _flush(tester);
      expect(
        tester
            .widget<PopScope>(find.byKey(const ValueKey('player_pop_scope')))
            .canPop,
        isTrue,
      );

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      await _unmount(tester);
    });
  });

  // ── Group 3: Breakpoint crossing ──────────────────────────────────────────

  group('Breakpoint crossing with queue open', () {
    testWidgets('video slot stays mounted across wide→narrow→wide', (
      tester,
    ) async {
      final queue = PlaybackQueue(tracks: [_youtubeTrack()], currentIndex: 0);
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        _playerApp(
          playerState: PlayerState(playbackQueue: queue, isPlaying: false),
          statusStream: Stream.value(const PlaybackStatus()),
          db: db,
        ),
      );
      await _flush(tester);

      final ctx = tester.element(find.byType(PlayerScreen));
      ProviderScope.containerOf(
        ctx,
      ).read(settingsProvider.notifier).setPlayerView(PlayerView.queue);
      await _flush(tester);

      final videoSlot = find.byWidgetPredicate(
        (w) => w.key.toString().contains('player_video_slot'),
      );
      expect(videoSlot, findsOneWidget);

      // Wide → narrow.
      tester.view.physicalSize = const Size(800, 800);
      tester.view.devicePixelRatio = 1.0;
      await _flush(tester);
      expect(videoSlot, findsOneWidget);
      expect(find.byKey(const ValueKey('queue_close_button')), findsOneWidget);

      // Narrow → wide.
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      await _flush(tester);
      expect(videoSlot, findsOneWidget);
      expect(find.byKey(const ValueKey('queue_close_button')), findsNothing);

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      await _unmount(tester);
    });

    testWidgets('at exactly 1000px uses side panel, at 999px uses overlay', (
      tester,
    ) async {
      final queue = PlaybackQueue(
        tracks: [_localAudioTrack()],
        currentIndex: 0,
      );

      // Exactly 1000px.
      tester.view.physicalSize = const Size(1000, 800);
      tester.view.devicePixelRatio = 1.0;
      await tester.pumpWidget(
        _playerApp(
          playerState: PlayerState(playbackQueue: queue, isPlaying: false),
          statusStream: Stream.value(const PlaybackStatus()),
          db: db,
        ),
      );
      await _flush(tester);
      final ctx = tester.element(find.byType(PlayerScreen));
      ProviderScope.containerOf(
        ctx,
      ).read(settingsProvider.notifier).setPlayerView(PlayerView.queue);
      await _flush(tester);
      expect(
        find.byKey(const ValueKey('queue_close_button')),
        findsNothing,
        reason: 'At 1000px should be side panel (no close button)',
      );

      // 999px.
      tester.view.physicalSize = const Size(999, 800);
      tester.view.devicePixelRatio = 1.0;
      await _flush(tester);
      expect(
        find.byKey(const ValueKey('queue_close_button')),
        findsOneWidget,
        reason: 'At 999px should be overlay (close button visible)',
      );

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      await _unmount(tester);
    });
  });

  // ── Group 4: Timer regression ─────────────────────────────────────────────
  //
  // Regression coverage for the infinite timer loop that was triggered when
  // focus changes re-armed the hide timer while controls were already hidden.
  // These tests cannot prove the bug is impossible, but they will catch a
  // regression that causes a pending-timer assertion failure or visible loop.

  group('Timer regression: control hide loop', () {
    testWidgets(
      'repeated show/hide cycles leave no pending timers on disposal',
      (tester) async {
        final queue = PlaybackQueue(
          tracks: [_localAudioTrack()],
          currentIndex: 0,
        );
        await tester.pumpWidget(
          _overlaysApp(
            playerState: PlayerState(playbackQueue: queue, isPlaying: true),
            statusStream: Stream.value(
              const PlaybackStatus(state: PlaybackState.playing),
            ),
            db: db,
            alwaysShowControls: false,
          ),
        );

        await tester.pump();

        // Pump 5 hide timer cycles.
        for (var i = 0; i < 5; i++) {
          // Let timer fire.
          await _pumpHideTimer(tester);
          // Pump a bit (simulating focus change / hover without re-showing).
          await tester.pump(const Duration(milliseconds: 100));
        }

        // Dispose. Must not throw "Timer is still pending".
        await _unmount(tester);
      },
    );

    testWidgets(
      'immediate disposal after controls shown cancels pending timer',
      (tester) async {
        final queue = PlaybackQueue(
          tracks: [_localAudioTrack()],
          currentIndex: 0,
        );
        await tester.pumpWidget(
          _overlaysApp(
            playerState: PlayerState(playbackQueue: queue, isPlaying: true),
            statusStream: Stream.value(
              const PlaybackStatus(state: PlaybackState.playing),
            ),
            db: db,
            alwaysShowControls: false,
          ),
        );

        // Controls visible, hide timer running.
        await tester.pump();

        // Unmount before timer fires.
        await tester.pumpWidget(const SizedBox());
        await tester.pumpAndSettle();
        // Flush past the timer interval to confirm it was cancelled.
        await tester.pump(const Duration(seconds: 4));
      },
    );

    testWidgets('focus changes while hidden do not re-arm hide timer', (
      tester,
    ) async {
      final queue = PlaybackQueue(
        tracks: [_localAudioTrack()],
        currentIndex: 0,
      );
      await tester.pumpWidget(
        _overlaysApp(
          playerState: PlayerState(playbackQueue: queue, isPlaying: true),
          statusStream: Stream.value(
            const PlaybackStatus(state: PlaybackState.playing),
          ),
          db: db,
          alwaysShowControls: false,
        ),
      );

      await tester.pump();
      final excludeFinder = find.byKey(
        const ValueKey('overlays_exclude_focus'),
      );
      expect(tester.widget<ExcludeFocus>(excludeFinder).excluding, false);

      // Let timer hide the controls.
      await _pumpHideTimer(tester);
      expect(tester.widget<ExcludeFocus>(excludeFinder).excluding, true);

      // Additional pumps simulate focus events arriving after controls are hidden.
      // If the loop bug were present, this would cause pumpAndSettle to time out.
      for (var i = 0; i < 20; i++) {
        await tester.pump(const Duration(milliseconds: 500));
      }

      // Controls remain hidden; no infinite loop.
      expect(tester.widget<ExcludeFocus>(excludeFinder).excluding, true);

      await _unmount(tester);
    });
  });
}

// ──────────────────────────────────────────────────────────────────────────────
// Fakes
// ──────────────────────────────────────────────────────────────────────────────

class _FakePlayerNotifier extends Notifier<PlayerState>
    implements PlayerNotifier {
  final PlayerState initialState;
  _FakePlayerNotifier(this.initialState);
  @override
  PlayerState build() => initialState;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeSettingsNotifier extends Notifier<SettingsState>
    implements SettingsNotifier {
  final SettingsState initial;
  _FakeSettingsNotifier(this.initial);

  @override
  SettingsState build() => initial;

  @override
  Future<void> setPlayerView(PlayerView view) async {
    state = state.copyWith(playerView: view);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
