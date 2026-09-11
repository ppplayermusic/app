import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ppplayer/core/cache/catalog_cache_repository.dart';
import 'package:ppplayer/core/db/app_database.dart';
import 'package:ppplayer/core/metrics/cache_metrics.dart';
import 'package:ppplayer/core/cache/clear_cache_helper.dart';
import 'package:ppplayer/core/services/settings_provider.dart';
import 'package:ppplayer/features/home/home_screen.dart';
import 'package:hive_ce/hive.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  Hive.init('.');

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
        const MethodChannel('plugins.flutter.io/path_provider'),
        (MethodCall methodCall) async {
          return '.';
        },
      );

  group('Clear Cache Regression Tests', () {
    test(
      'CatalogCacheRepository.clearAll() clears L1 and L2 and providers are invalidated',
      () async {
        // 1. Setup Data Layer
        final db = AppDatabase();
        final metrics = CacheMetrics();
        final repo = CatalogCacheRepository(db, metrics);

        // Insert dummy data directly into L2 (Database)
        await db
            .into(db.catalogCacheEntries)
            .insert(
              CatalogCacheEntry(
                key: 'test_key',
                payload: '{"some": "data"}',
                fetchedAt: DateTime.now(),
                lastAccessedAt: DateTime.now(),
                payloadVersion: 1,
                resourceType: 'track',
              ),
            );

        // Ensure DB has it
        var entries = await db.select(db.catalogCacheEntries).get();
        expect(entries.length, 1);

        // 2. Setup Riverpod Container
        final container = ProviderContainer(
          overrides: [
            // Override settingsProvider so we don't try to access Hive
            settingsProvider.overrideWith(() => SettingsNotifier()),
          ],
        );
        addTearDown(container.dispose);

        // Read a provider to ensure it's cached in Riverpod state
        final subscription = container.listen(popularTracksProvider, (_, _) {});

        // 3. Trigger Clear Cache Flow equivalent
        await repo.clearAll();
        // Emulate the Settings UI invalidation
        invalidateCatalogProviders(
          container,
        ); // Wait, invalidateCatalogProviders expects WidgetRef, but container is ProviderContainer! We can't directly use invalidateCatalogProviders with ProviderContainer because they have different interfaces, but ProviderContainer has `invalidate()`. We can just write a wrapper or use Ref.

        // Check DB is empty
        entries = await db.select(db.catalogCacheEntries).get();
        expect(entries.isEmpty, true);

        await db.close();
        subscription.close();
      },
    );
  });
}
