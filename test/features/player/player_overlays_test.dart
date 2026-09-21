import 'package:flutter/material.dart' hide RepeatMode;
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ppplayer/features/player/widgets/player_overlays.dart';
import 'package:ppplayer/core/models/track.dart';

import 'package:ppplayer/core/player/player_provider.dart';
import 'package:ppplayer/core/playback/playback_providers.dart';
import 'package:ppplayer/core/services/settings_provider.dart';
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

  testWidgets('PlayerOverlays hides Fit/Fill button for online tracks', (
    WidgetTester tester,
  ) async {
    final track = Track(
      youtubeVideoId: 'test',
      spotifyId: 'test',
      name: 'Test Online',
      artistId: 'test',
      artistName: 'Artist',
      sourceType: TrackSourceType.online,
    );
    final queue = PlaybackQueue(tracks: [track], currentIndex: 0);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          playerProvider.overrideWith(
            () => FakePlayerNotifier(
              PlayerState(playbackQueue: queue, isPlaying: true),
            ),
          ),
          playbackStatusProvider.overrideWith(
            (ref) => const Stream<PlaybackStatus>.empty(),
          ),
          settingsProvider.overrideWith(() => FakeSettingsNotifier()),
          appDatabaseProvider.overrideWithValue(db),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: PlayerOverlays(
              isFullscreen: false,
              onToggleFullscreen: () {},
              onCollapse: () {},
              onToggleQueue: () {},
              middleTopBar: const SizedBox(),
              alwaysShowControls: true,
            ),
          ),
        ),
      ),
    );

    await tester.pump();

    expect(find.byIcon(Icons.fit_screen), findsNothing);
    expect(find.byIcon(Icons.crop_free), findsNothing);

    await tester.pump(const Duration(seconds: 4));

    // Unmount and flush drift stream cancellation timers
    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 4));
  });

  testWidgets('PlayerOverlays excludes focus when controls are hidden', (
    WidgetTester tester,
  ) async {
    final track = Track(
      spotifyId: 'test',
      name: 'Test Local',
      artistId: 'test',
      artistName: 'Artist',
      sourceType: TrackSourceType.local,
    );
    final queue = PlaybackQueue(tracks: [track], currentIndex: 0);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          playerProvider.overrideWith(
            () => FakePlayerNotifier(
              PlayerState(playbackQueue: queue, isPlaying: true),
            ),
          ),
          playbackStatusProvider.overrideWith(
            (ref) => const Stream<PlaybackStatus>.empty(),
          ),
          settingsProvider.overrideWith(() => FakeSettingsNotifier()),
          appDatabaseProvider.overrideWithValue(db),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: PlayerOverlays(
              isFullscreen: false,
              onToggleFullscreen: () {},
              onCollapse: () {},
              onToggleQueue: () {},
              middleTopBar: const SizedBox(),
              alwaysShowControls: false,
            ),
          ),
        ),
      ),
    );

    // Initial state: controls are visible and focusable
    await tester.pump();
    final focusFinder = find.byKey(const ValueKey('overlays_exclude_focus'));
    expect(focusFinder, findsOneWidget);

    ExcludeFocus focusNode = tester.widget(focusFinder);
    expect(focusNode.excluding, false);

    // Wait 4 seconds for hide timer
    await tester.pump(const Duration(seconds: 4));

    // State after hide timer: controls are invisible and excluded from focus
    focusNode = tester.widget(focusFinder);
    expect(focusNode.excluding, true);

    // Unmount and flush drift stream cancellation timers
    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 4));
  });
}

class FakePlayerNotifier extends Notifier<PlayerState>
    implements PlayerNotifier {
  final PlayerState initialState;
  FakePlayerNotifier(this.initialState);
  @override
  PlayerState build() => initialState;

  @override
  PlaybackTrack? get currentPlaybackTrack => null;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeSettingsNotifier extends Notifier<SettingsState>
    implements SettingsNotifier {
  @override
  SettingsState build() => SettingsState(selectedCountry: 'US');
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
