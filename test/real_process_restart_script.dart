// ignore_for_file: avoid_print
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ppplayer/core/db/app_database.dart';
import 'package:ppplayer/core/api/spotify_auth.dart';
import 'package:ppplayer/core/api/spotify_client.dart';
import 'package:ppplayer/core/api/spotify_repository.dart';
import 'package:drift/native.dart';

// Note: This script is meant to be run directly via dart run, not flutter test.
void main(List<String> args) async {
  final isPhase2 = args.contains('--phase2');
  final dbFile = File('test_real_db.sqlite');

  final db = AppDatabase.forTesting(NativeDatabase(dbFile));
  
  // Real network client but we'll monitor requests
  final dio = Dio();
  int requestCount = 0;
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      if (options.path.contains('spotify.com')) {
        requestCount++;
        print('NETWORK REQUEST: ${options.uri}');
      }
      return handler.next(options);
    }
  ));

  final auth = PPPlayerSpotifyAuth(dio);
  final client = SpotifyClient(dio, auth, market: 'US');

  final container = ProviderContainer(
    overrides: [
      appDatabaseProvider.overrideWithValue(db),
      spotifyClientProvider.overrideWithValue(client),
    ],
  );

  final repo = container.read(spotifyRepositoryProvider);

  print('Phase ${isPhase2 ? 2 : 1} Starting...');

  try {
    final artistResult = await repo.watchArtist('0TnOYISbd1XYRBk9myaseg').firstWhere((r) => r.data.isNotEmpty); // Pitbull
    final artist = artistResult.data;
    print('Got Artist: ${artist['name']}');
    
    if (!isPhase2) {
      if (requestCount == 0) {
        print('ERROR: Phase 1 should have made a network request!');
        exit(1);
      }
      print('Phase 1: Made $requestCount network requests. Exiting normally.');
      exit(0);
    } else {
      if (requestCount > 0) {
        print('ERROR: Phase 2 made $requestCount network requests! Expected 0 (L2 Hit).');
        exit(1);
      }
      print('Phase 2: Made 0 network requests. L2 Hit verified across process boundaries!');
      exit(0);
    }
  } catch (e) {
    print('Error: $e');
    exit(1);
  } finally {
    await db.close();
  }
}
