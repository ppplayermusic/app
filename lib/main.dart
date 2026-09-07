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
import 'package:permission_handler/permission_handler.dart';

/// Global access to the provider container for the [AudioHandler].
late ProviderContainer globalContainer;

Future<void> _requestNotificationPermission() async {
  if (Platform.isAndroid) {
    final status = await Permission.notification.status;
    if (status.isDenied) {
      await Permission.notification.request();
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: '.env');

  // Request notification permissions for background service stability on Android 13+
  await _requestNotificationPermission();

  // Init Hive for prefs/queue
  await Hive.initFlutter();

  // Initialize Ads if on mobile - delay to avoid startup contention
  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
    Future.delayed(const Duration(seconds: 10), () {
      MobileAds.instance.initialize();
    });
  }

  final appDatabase = AppDatabase();

  // Initialize the container first (needed by builder)
  globalContainer = ProviderContainer(
    overrides: [
      appDatabaseProvider.overrideWithValue(appDatabase),
    ],
  );

  // Configure AudioSession for background playback & audio focus
  final session = await AudioSession.instance;
  await session.configure(const AudioSessionConfiguration.music());

  // Initialize the audio handler bridge
  final handler = await AudioService.init(
    builder: () => PpPlayerAudioHandler(
      () => globalContainer,
    ),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.ppplayer.app.playback',
      androidNotificationChannelName: 'Music Playback',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true, 
      androidNotificationIcon: 'mipmap/ic_launcher',
      androidResumeOnClick: true,
    ),
  );

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
  }

  runApp(
    UncontrolledProviderScope(
      container: globalContainer,
      child: const PpPlayerApp(),
    ),
  );
}

class PpPlayerApp extends ConsumerWidget {
  const PpPlayerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final settings = ref.watch(settingsProvider);
    final themeColor = AppTheme.themeColors[settings.themeIndex];

    return MaterialApp.router(
      title: 'PPPLAYER',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(primaryColor: themeColor),
      scrollBehavior: const AppScrollBehavior(),
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
