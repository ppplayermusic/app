import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:media_kit/media_kit.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/db/app_database.dart';
import 'core/playback/media_handler.dart';
import 'core/services/settings_provider.dart';
import 'core/playback/media_sync_service.dart';
import 'core/services/dock_menu_service.dart';
import 'core/metrics/cache_metrics.dart';
import 'core/playback/pip_handler.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ppplayer/l10n/app_localizations.dart';
import 'package:macos_file_open_handler/macos_file_open_handler.dart';
import 'package:path_provider/path_provider.dart';

import 'core/player/player_provider.dart';
import 'core/local_library/local_library_service.dart';

/// Global access to the provider container for the [AudioHandler].
late ProviderContainer globalContainer;

Future<void> _requestNotificationPermission() async {
  if (!kIsWeb && Platform.isAndroid) {
    final status = await Permission.notification.status;
    if (status.isDenied) {
      await Permission.notification.request();
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();

  // Load environment variables (wrap in try-catch in case it's missing)
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    debugPrint(
      'Warning: .env file not found or could not be loaded. Relying on --dart-define or defaults.',
    );
  }

  // Request notification permissions for background service stability on Android 13+
  await _requestNotificationPermission();

  PipHandler.init();

  // Init Hive for prefs/queue
  String? dbPath;
  if (!kIsWeb) {
    final appDir = await getApplicationSupportDirectory();
    dbPath = appDir.path;
    Hive.init(appDir.path);
  } else {
    await Hive.initFlutter();
  }

  // Initialize Ads if on mobile - delay to avoid startup contention
  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
    Future.delayed(const Duration(seconds: 10), () {
      MobileAds.instance.initialize();
    });
  }

  final appDatabase = AppDatabase(dbPath);

  // Initialize the container first (needed by builder)
  globalContainer = ProviderContainer(
    overrides: [appDatabaseProvider.overrideWithValue(appDatabase)],
  );

  // Configure AudioSession for background playback & audio focus
  final session = await AudioSession.instance;
  await session.configure(const AudioSessionConfiguration.music());

  // Initialize the audio handler bridge
  final PpPlayerAudioHandler handler;

  if (!kIsWeb && Platform.isMacOS) {
    // macOS: WebKit provides its own Now Playing integration for the YouTube iframe.
    // If we register audio_service, it creates a duplicate card in the Control Center.
    // By instantiating our handler directly without AudioService.init, our internal
    // Riverpod states work, but the OS doesn't get duplicate notifications.
    handler = PpPlayerAudioHandler(() => globalContainer);
  } else {
    handler = await AudioService.init(
      builder: () => PpPlayerAudioHandler(() => globalContainer),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.ppplayer.app.playback',
        androidNotificationChannelName: 'Music Playback',
        androidNotificationOngoing: true,
        androidStopForegroundOnPause: true,
        androidNotificationIcon: 'mipmap/ic_launcher',
        androidResumeOnClick: true,
      ),
    );
  }

  // Re-initialize/Update container with the actual handler instance
  globalContainer = ProviderContainer(
    overrides: [
      // Provide the drift database instance app-wide
      appDatabaseProvider.overrideWithValue(appDatabase),
      // Register the static handler instance
      audioHandlerProvider.overrideWithValue(handler),
    ],
  );

  // Initialize background media sync service
  globalContainer.read(mediaSyncServiceProvider);

  // Initialize native dock menu service for macOS
  if (!kIsWeb && Platform.isMacOS) {
    globalContainer.read(dockMenuServiceProvider);

    // Register file open handler
    MacosFileOpenHandler.instance.listen(
      (files) async {
        if (files.isEmpty) return;
        final libraryService = globalContainer.read(
          localLibraryServiceProvider,
        );
        final tracks = await libraryService.importFilesByPaths(
          files.map((e) => e.path).toList(),
        );

        if (tracks.isNotEmpty) {
          final player = globalContainer.read(playerProvider.notifier);
          // Play the first track and add the rest to queue
          player.playTrack(tracks.first);
        }
      },
      onError: (error, stackTrace) {
        debugPrint('Could not open file: $error');
      },
    );
  }

  if (kDebugMode) {
    globalContainer.read(cacheMetricsProvider).startLogging();
  }

  // Instrument Flutter Lifecycle
  AppLifecycleListener(onStateChange: (AppLifecycleState state) {});

  runApp(
    UncontrolledProviderScope(
      container: globalContainer,
      child: const _AppLifecycleLogger(child: PpPlayerApp()),
    ),
  );
}

class _AppLifecycleLogger extends StatefulWidget {
  final Widget child;
  const _AppLifecycleLogger({required this.child});
  @override
  State<_AppLifecycleLogger> createState() => _AppLifecycleLoggerState();
}

class _AppLifecycleLoggerState extends State<_AppLifecycleLogger>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final time = DateTime.now().toIso8601String().substring(11, 23);
    debugPrint(
      '$time [PipDebug][FLUTTER] state=${state.name} inPip=${PipHandler.isInPipMode} activityStopped=${PipHandler.isActivityStopped}',
    );
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class PpPlayerApp extends ConsumerWidget {
  const PpPlayerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final settings = ref.watch(settingsProvider);
    final themeColor = AppTheme.themeColors[settings.themeIndex];

    return MaterialApp.router(
      title: 'PPPlayer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(primaryColor: themeColor),
      scrollBehavior: const AppScrollBehavior(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: settings.languageCode != null
          ? Locale(settings.languageCode!)
          : null,
      routerConfig: router,
    );
  }
}

class AppScrollBehavior extends MaterialScrollBehavior {
  const AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
  };
}
