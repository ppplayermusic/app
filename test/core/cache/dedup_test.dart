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

  test('Concurrent requests for the same key are deduplicated', () async {
    int fetchCount = 0;

    Future<String> fetch() async {
      fetchCount++;
      await Future.delayed(const Duration(milliseconds: 50));
      return 'data';
    }

    final futures = List.generate(10, (_) {
      return repository
          .watchOrFetch<String>(
            key: 'dedup_test',
            resourceType: ResourceType.artist,
            fetch: fetch,
            decode: (json) => json,
            encode: (data) => data,
          )
          .first;
    });

    final results = await Future.wait(futures);
    expect(results.length, 10);
    expect(fetchCount, 1);
  });

  test('Failed futures are removed from _inFlight', () async {
    int fetchCount = 0;

    Future<String> fetch() async {
      fetchCount++;
      await Future.delayed(const Duration(milliseconds: 10));
      throw Exception('fail');
    }

    try {
      await repository
          .watchOrFetch<String>(
            key: 'fail_test',
            resourceType: ResourceType.artist,
            fetch: fetch,
            decode: (json) => json,
            encode: (data) => data,
          )
          .first;
    } catch (_) {}

    expect(fetchCount, 1);

    // Second fetch should be allowed
    try {
      await repository
          .watchOrFetch<String>(
            key: 'fail_test',
            resourceType: ResourceType.artist,
            fetch: fetch,
            decode: (json) => json,
            encode: (data) => data,
          )
          .first;
    } catch (_) {}

    expect(fetchCount, 2);
  });
}
