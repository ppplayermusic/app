import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:ppplayer/core/db/app_database.dart';
import 'package:ppplayer/core/cache/catalog_cache_repository.dart';
import 'package:ppplayer/core/cache/cache_config.dart';

final testStreamProvider = StreamProvider.autoDispose<CacheResult<String>>((
  ref,
) {
  final repo = ref.watch(catalogCacheRepositoryProvider);
  return repo.watchOrFetch<String>(
    key: 'swr_riverpod_test',
    resourceType: ResourceType.artist,
    fetch: () async {
      await Future.delayed(const Duration(milliseconds: 50));
      return 'fresh_data';
    },
    decode: (json) => json,
    encode: (data) => data,
  );
});

void main() {
  test('Riverpod SWR emission sequence', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    // Insert stale data
    final twoDaysAgo = DateTime.now().subtract(const Duration(days: 2));
    await db
        .into(db.catalogCacheEntries)
        .insert(
          CatalogCacheEntriesCompanion.insert(
            key: 'swr_riverpod_test',
            payload: 'stale_data',
            fetchedAt: twoDaysAgo,
            lastAccessedAt: twoDaysAgo,
            payloadVersion: CacheConfig.catalogPayloadVersion,
            resourceType: ResourceType.artist.name,
          ),
        );

    final container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
    );
    addTearDown(container.dispose);

    final states = <AsyncValue<CacheResult<String>>>[];
    container.listen(testStreamProvider, (previous, next) {
      states.add(next);
    }, fireImmediately: true);

    // Initial state is loading
    expect(states.length, 1);
    expect(states[0], isA<AsyncLoading>());

    // Wait for the stream to yield stale, then fetch fresh
    await Future.delayed(const Duration(milliseconds: 100));

    // The sequence should be Loading -> Data(stale) -> Data(fresh)
    expect(states.length, 3);
    expect(states[1], isA<AsyncData>());
    expect(states[1].value!.data, 'stale_data');

    expect(states[2], isA<AsyncData>());
    expect(states[2].value!.data, 'fresh_data');
  });
}
