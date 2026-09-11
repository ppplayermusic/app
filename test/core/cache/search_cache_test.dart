import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:ppplayer/core/db/app_database.dart';
import 'package:ppplayer/core/cache/catalog_cache_repository.dart';
import 'package:ppplayer/core/cache/cache_config.dart';
import 'package:ppplayer/core/api/spotify_client.dart';
import 'package:ppplayer/core/api/spotify_repository.dart';
import 'package:ppplayer/core/metrics/cache_metrics.dart';
import 'package:mocktail/mocktail.dart';

class MockSpotifyClient extends Mock implements SpotifyClient {}

void main() {
  late AppDatabase db;
  late MockSpotifyClient mockClient;
  late CatalogCacheRepository cacheRepo;
  late SpotifyRepository repo;
  late CacheMetrics metrics;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    mockClient = MockSpotifyClient();
    when(() => mockClient.market).thenReturn('US');
    metrics = CacheMetrics();
    cacheRepo = CatalogCacheRepository(db, metrics);
    repo = SpotifyRepository(mockClient, cacheRepo);
  });

  tearDown(() async {
    await db.close();
  });

  test(
    'watchSearch uses SWR and deduplicates identical canonical queries',
    () async {
      when(
        () => mockClient.search(any(), limit: any(named: 'limit')),
      ).thenAnswer((_) async {
        return {'mock': 'fresh_data'};
      });

      final query1 = 'The Beatles';
      final query2 =
          'the beatles '; // Different display case/whitespace, same canonical identity

      final stream1 = repo.watchSearch(query1);
      final results1 = <CacheResult<Map<String, dynamic>>>[];
      final sub1 = stream1.listen(results1.add);

      final stream2 = repo.watchSearch(query2);
      final results2 = <CacheResult<Map<String, dynamic>>>[];
      final sub2 = stream2.listen(results2.add);

      await Future.delayed(const Duration(milliseconds: 500));

      expect(results1.isNotEmpty, true, reason: 'results1 is empty');
      expect(results2.isNotEmpty, true, reason: 'results2 is empty');

      // Only one network call should occur. Since query1 was first, it gets passed to the fetcher.
      verify(() => mockClient.search('The Beatles', limit: 20)).called(1);

      await sub1.cancel();
      await sub2.cancel();
      await Future.delayed(
        const Duration(milliseconds: 100),
      ); // wait for cancellation to settle
    },
  );

  test('watchSearch emits stale data then fresh data', () async {
    final staleTime = DateTime.now().subtract(const Duration(hours: 1));
    final normalized = 'test query';

    await db
        .into(db.catalogCacheEntries)
        .insert(
          CatalogCacheEntriesCompanion.insert(
            key: CacheKeyBuilder.search(
              normalized,
              'track,artist,album,playlist',
              'US',
              limit: 20,
              offset: 0,
            ),
            payload: jsonEncode({'mock': 'stale_data'}),
            fetchedAt: staleTime,
            lastAccessedAt: staleTime,
            payloadVersion: CacheConfig.catalogPayloadVersion,
            resourceType: ResourceType.search.name,
          ),
        );

    when(() => mockClient.search(any(), limit: any(named: 'limit'))).thenAnswer(
      (_) async {
        await Future.delayed(const Duration(milliseconds: 50));
        return {'mock': 'fresh_data'};
      },
    );

    final results = <CacheResult<Map<String, dynamic>>>[];
    final sub = repo.watchSearch('test query').listen(results.add);

    await Future.delayed(const Duration(milliseconds: 10));
    expect(results.length, 1);
    expect(results[0].data['mock'], 'stale_data');

    await Future.delayed(const Duration(milliseconds: 100));
    expect(results.length, 2);
    expect(results[1].data['mock'], 'fresh_data');

    await sub.cancel();
    await Future.delayed(const Duration(milliseconds: 100));
  });
}
