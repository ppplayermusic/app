import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ppplayer/core/metrics/cache_metrics.dart';
import 'package:ppplayer/core/cache/catalog_cache_repository.dart';
import 'package:ppplayer/core/db/app_database.dart';
import 'package:drift/native.dart';
import 'package:ppplayer/core/cache/cache_config.dart';

void main() {
  late ProviderContainer container;
  late AppDatabase db;
  late CatalogCacheRepository repository;
  late CacheMetrics metrics;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
    );
    metrics = container.read(cacheMetricsProvider);
    repository = container.read(catalogCacheRepositoryProvider);
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  test('fetch increments L1 miss and cache writes', () async {
    final stream = repository.watchOrFetch<String>(
      key: 'test_key',
      resourceType: ResourceType.artist,
      fetch: () async => 'fetched_data',
      decode: (json) => json,
      encode: (data) => data,
    );

    await stream.toList();

    expect(metrics.l1Misses, 1);
    expect(metrics.l2Misses, 1);
    expect(metrics.cacheWrites, 1);
  });

  test('fresh cache hit increments L1 hits', () async {
    // First fetch
    await repository
        .watchOrFetch<String>(
          key: 'test_key',
          resourceType: ResourceType.artist,
          fetch: () async => 'fetched_data',
          decode: (json) => json,
          encode: (data) => data,
        )
        .toList();

    expect(metrics.l1Misses, 1);

    // Second fetch
    await repository
        .watchOrFetch<String>(
          key: 'test_key',
          resourceType: ResourceType.artist,
          fetch: () async => 'fetched_data2',
          decode: (json) => json,
          encode: (data) => data,
        )
        .toList();

    expect(metrics.l1Hits, 1);
    // Shouldn't increase misses
    expect(metrics.l1Misses, 1);
  });

  test('SWR increments stale hits and background refreshes', () async {
    final twoDaysAgo = DateTime.now().subtract(const Duration(days: 2));

    await db
        .into(db.catalogCacheEntries)
        .insert(
          CatalogCacheEntriesCompanion.insert(
            key: 'swr_test',
            payload: 'stale_data',
            fetchedAt: twoDaysAgo,
            lastAccessedAt: twoDaysAgo,
            payloadVersion: CacheConfig.catalogPayloadVersion,
            resourceType: ResourceType.artist.name,
          ),
        );

    final stream = repository.watchOrFetch<String>(
      key: 'swr_test',
      resourceType: ResourceType.artist,
      fetch: () async => 'fresh_data',
      decode: (json) => json,
      encode: (data) => data,
    );

    await stream.toList();

    expect(metrics.l1Misses, 1);
    expect(metrics.l2StaleHits, 1);
    expect(metrics.backgroundRefreshes, 1);
    expect(metrics.cacheWrites, 1);
  });

  test(
    'concurrent requests increment dedupHits by callers joining in-flight',
    () async {
      final futures = List.generate(
        10,
        (index) => repository
            .watchOrFetch<String>(
              key: 'dedup_test_multi',
              resourceType: ResourceType.artist,
              fetch: () async {
                await Future.delayed(const Duration(milliseconds: 50));
                return 'multi_data';
              },
              decode: (json) => json,
              encode: (data) => data,
            )
            .toList(),
      );

      await Future.wait(futures);

      expect(metrics.dedupHits, 9);
    },
  );

  test('L2 hit works across process restarts without L1', () async {
    // 1. Repository A fetches and persists to Drift
    await repository
        .watchOrFetch<String>(
          key: 'restart_test',
          resourceType: ResourceType.artist,
          fetch: () async => 'persistent_data',
          decode: (json) => json,
          encode: (data) => data,
        )
        .toList();

    // Verify Repository A fetched it once
    expect(metrics.l1Misses, 1);
    expect(metrics.l2Misses, 1);

    // 2. Dispose Repository A / Simulate restart by creating Repository B
    final repositoryB = CatalogCacheRepository(db, metrics);

    // 3. Request same item from Repository B (which has empty L1)
    await repositoryB
        .watchOrFetch<String>(
          key: 'restart_test',
          resourceType: ResourceType.artist,
          fetch: () async => 'should_not_fetch',
          decode: (json) => json,
          encode: (data) => data,
        )
        .toList();

    // Verify Repository B hits L2
    expect(metrics.l1Misses, 2); // Missed in L1 for both Repos
    expect(metrics.l2Hits, 1); // Hit L2 for Repo B

    // We can't directly check spotifyRequests = 0 since we're injecting a fake fetch,
    // but hitting L2 ensures the fetch closure wasn't called.
  });
}
