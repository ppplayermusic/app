import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/db/app_database.dart';
import 'core/player/media_handler.dart';

/// Global access to the provider container for the [AudioHandler].
late ProviderContainer globalContainer;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: '.env');

  // Init Hive for prefs/queue
  await Hive.initFlutter();

  // Initialize Ads if on mobile
  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
    MobileAds.instance.initialize();
  }

  // Initialize the audio handler bridge
  final handler = await AudioService.init(
    builder: () => PpPlayerAudioHandler(
      () => globalContainer,
    ),
    config: AudioServiceConfig(
      androidNotificationChannelId: 'com.ppplayer.music.playback',
      androidNotificationChannelName: 'Music Playback',
      androidStopForegroundOnPause: false, // Keep notification visible so user can press Play
      androidNotificationIcon: 'mipmap/ic_launcher',
    ),
  );

  // Configure the audio session for music playback
  final session = await AudioSession.instance;
  await session.configure(const AudioSessionConfiguration.music());
  
  // Activate the audio session
  await session.setActive(true);

  globalContainer = ProviderContainer(
    overrides: [
      // Provide the drift database instance app-wide
      appDatabaseProvider.overrideWithValue(AppDatabase()),
      // Register the static handler instance
      audioHandlerProvider.overrideWithValue(handler),
    ],
  );

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
    return MaterialApp.router(
      title: 'ppplayer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      routerConfig: router,
    );
  }
}
