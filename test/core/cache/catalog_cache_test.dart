import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:ppplayer/core/db/app_database.dart';
import 'package:ppplayer/core/cache/catalog_cache_repository.dart';
import 'package:ppplayer/core/cache/cache_config.dart';
import 'package:ppplayer/core/metrics/cache_metrics.dart';

void main() {
  late AppDatabase db;
  late CatalogCacheRepository repository;
  late CacheMetrics metrics;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    metrics = CacheMetrics();
    repository = CatalogCacheRepository(db, metrics);
  });

  tearDown(() async {
    await db.close();
  });

  test('fetch writes to L1 and L2', () async {
    int fetchCount = 0;
    
    final stream = repository.watchOrFetch<String>(
      key: 'test_key',
      resourceType: ResourceType.artist,
      fetch: () async {
        fetchCount++;
        return 'fetched_data';
      },
      decode: (json) => json,
      encode: (data) => data,
    );

    final results = await stream.toList();
    
    expect(results.length, 1);
    expect(results.first.source, CacheSource.network);
    expect(results.first.data, 'fetched_data');
    expect(fetchCount, 1);

    // Verify L2
    final dbEntry = await (db.select(db.catalogCacheEntries)..where((t) => t.key.equals('test_key'))).getSingleOrNull();
    expect(dbEntry, isNotNull);
    expect(dbEntry!.payload, 'fetched_data');
  });

  test('fresh cache returns memory instantly and no network fetch', () async {
    int fetchCount = 0;
    
    // First fetch
    await repository.watchOrFetch<String>(
      key: 'test_key',
      resourceType: ResourceType.artist,
      fetch: () async {
        fetchCount++;
        return 'fetched_data';
      },
      decode: (json) => json,
      encode: (data) => data,
    ).first;

    expect(fetchCount, 1);

    // Second fetch should hit L1
    final stream = repository.watchOrFetch<String>(
      key: 'test_key',
      resourceType: ResourceType.artist,
      fetch: () async {
        fetchCount++;
        return 'fetched_data2';
      },
      decode: (json) => json,
      encode: (data) => data,
    );

    final results = await stream.toList();
    expect(results.length, 1);
    expect(results.first.source, CacheSource.memory);
    expect(results.first.data, 'fetched_data');
    expect(fetchCount, 1); // Fetch not called
  });

  test('SWR emits stale memory data then fetches and emits fresh network data', () async {
    int fetchCount = 0;
    
    // Setup stale memory entry by bypassing watchOrFetch
    // For artist, freshFor is 24h, usableFor is 7 days.
    // We'll simulate it's 2 days old (stale but usable).
    final twoDaysAgo = DateTime.now().subtract(const Duration(days: 2));
    
    // We can't access _l1Cache directly, so we write to DB and it'll get loaded and promote to L1 or just read as stale.
    await db.into(db.catalogCacheEntries).insert(
      CatalogCacheEntriesCompanion.insert(
        key: 'swr_test',
        payload: 'stale_data',
        fetchedAt: twoDaysAgo,
        lastAccessedAt: twoDaysAgo,
        payloadVersion: CacheConfig.catalogPayloadVersion,
        resourceType: ResourceType.artist.name,
      )
    );

    final stream = repository.watchOrFetch<String>(
      key: 'swr_test',
      resourceType: ResourceType.artist,
      fetch: () async {
        fetchCount++;
        return 'fresh_data';
      },
      decode: (json) => json,
      encode: (data) => data,
    );

    final results = await stream.toList();
    
    expect(results.length, 2);
    // First emission should be the stale persistent data
    expect(results[0].source, CacheSource.stalePersistent);
    expect(results[0].data, 'stale_data');
    
    // Second emission should be the fresh network data
    expect(results[1].source, CacheSource.network);
    expect(results[1].data, 'fresh_data');
    expect(fetchCount, 1);
  });
}
