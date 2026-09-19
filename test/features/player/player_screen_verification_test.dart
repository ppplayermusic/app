import 'package:flutter/material.dart' hide RepeatMode;
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ppplayer/features/player/player_screen.dart';
import 'package:ppplayer/core/models/track.dart';

import 'package:ppplayer/core/player/player_provider.dart';
import 'package:ppplayer/core/services/settings_provider.dart';
import 'package:ppplayer/core/playback/playback_providers.dart';
import 'package:ppplayer/core/db/app_database.dart';
import 'package:ppplayer/l10n/app_localizations.dart';
import 'package:drift/native.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets(
    'PlayerScreen keeps video slot mounted during queue transitions and breakpoints',
    (WidgetTester tester) async {
      final track = Track(
        youtubeVideoId: 'test',
        spotifyId: 'test',
        name: 'Test',
        artistId: 'test',
        artistName: 'Artist',
        sourceType: TrackSourceType.online,
      );
      final queue = PlaybackQueue(tracks: [track], currentIndex: 0);

      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            playerProvider.overrideWith(
              () => FakePlayerNotifier(
                PlayerState(playbackQueue: queue, isPlaying: true),
              ),
            ),
            playbackStatusProvider.overrideWith(
              (ref) => Stream.value(
                const PlaybackStatus(
                  state: PlaybackState.playing,
                  hasVideo: true,
                ),
              ),
            ),
            settingsProvider.overrideWith(() => FakeSettingsNotifier()),
            appDatabaseProvider.overrideWithValue(db),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(body: PlayerScreen()),
          ),
        ),
      );

      await tester.pump(const Duration(seconds: 4));
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      // The video slot should be mounted
      final videoSlotFinder = find.byWidgetPredicate(
        (widget) =>
            widget.key is GlobalKey &&
            widget.key.toString().contains('player_video_slot'),
      );
      expect(videoSlotFinder, findsOneWidget);

      // Initial state: Queue panel is hidden, but the bottom bar toggle exists
      expect(find.byKey(const ValueKey('queue_toggle_button')), findsOneWidget);

      // Open Queue
      final queueButton = find.byKey(const ValueKey('queue_toggle_button'));
      await tester.tap(queueButton);
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      // Queue should be visible in side panel (width > 1000)
      expect(find.text('QUEUE'), findsOneWidget);
      expect(find.byType(BottomSheet), findsNothing);

      // Video slot MUST still be exactly the same widget (mounted)
      expect(videoSlotFinder, findsOneWidget);

      // Change size to < 1000 to cross breakpoint
      await tester.binding.setSurfaceSize(const Size(800, 800));
      await tester.pump(const Duration(milliseconds: 500));

      // Video slot MUST still be mounted
      expect(videoSlotFinder, findsOneWidget);

      // Queue should now be absolute positioned, not in side panel
      expect(find.text('QUEUE'), findsOneWidget);
      expect(videoSlotFinder, findsOneWidget);

      // Close Queue
      final BuildContext context = tester.element(find.byType(PlayerScreen));
      ProviderScope.containerOf(
        context,
      ).read(settingsProvider.notifier).setPlayerView(PlayerView.video);
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
      expect(find.text('QUEUE'), findsNothing);
      expect(videoSlotFinder, findsOneWidget);

      await tester.pump(const Duration(seconds: 4));

      // Reset surface size
      await tester.binding.setSurfaceSize(null);
      await tester.pump(const Duration(milliseconds: 50));

      // Unmount and flush drift stream cancellation timers
      await tester.pumpWidget(const SizedBox());
      await tester.pumpAndSettle();
    },
  );
}

class FakePlayerNotifier extends Notifier<PlayerState>
    implements PlayerNotifier {
  final PlayerState initialState;
  FakePlayerNotifier(this.initialState);
  @override
  PlayerState build() => initialState;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeSettingsNotifier extends Notifier<SettingsState>
    implements SettingsNotifier {
  @override
  SettingsState build() => SettingsState(selectedCountry: 'US');

  @override
  Future<void> setPlayerView(PlayerView view) async {
    state = state.copyWith(playerView: view);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
