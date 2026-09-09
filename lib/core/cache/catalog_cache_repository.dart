import 'dart:async';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../db/app_database.dart';
import 'cache_config.dart';
import '../metrics/cache_metrics.dart';

enum CacheSource {
  memory,
  persistent,
  network,
  staleMemory,
  stalePersistent,
}

class CacheResult<T> {
  final T data;
  final CacheSource source;
  final DateTime fetchedAt;

  CacheResult({
    required this.data,
    required this.source,
    required this.fetchedAt,
  });
}

class _L1Entry<T> {
  final T data;
  final DateTime fetchedAt;

  _L1Entry(this.data, this.fetchedAt);
}

class CatalogCacheRepository {
  final AppDatabase _db;
  final CacheMetrics _metrics;
  
  // L1 Cache: Bounded memory cache (max 250 items)
  final int _maxL1Size = 250;
  final LinkedHashMap<String, _L1Entry<dynamic>> _l1Cache = LinkedHashMap<String, _L1Entry<dynamic>>();
  
  // In-flight request deduplication
  final Map<String, Future<dynamic>> _inFlight = {};

  CatalogCacheRepository(this._db, this._metrics);

  /// SWR Implementation: Returns a stream that may emit a cached value immediately,
  /// followed by a fresh network value if the cache was stale (but usable).
  /// If the cache is fully expired or missing, it blocks and emits the network value.
  Stream<CacheResult<T>> watchOrFetch<T>({
    required String key,
    required ResourceType resourceType,
    required Future<T> Function() fetch,
    required T Function(String json) decode,
    required String Function(T value) encode,
  }) async* {
    final policy = resourceType.policy;
    final now = DateTime.now();

    // 1. Check L1 Memory Cache
    final l1Entry = _l1Cache[key];
    if (l1Entry != null) {
      // Move to end (most recently used)
      _l1Cache.remove(key);
      _l1Cache[key] = l1Entry;

      final age = now.difference(l1Entry.fetchedAt);
      if (age < policy.freshFor) {
        _metrics.l1Hits++;
        yield CacheResult(data: l1Entry.data as T, source: CacheSource.memory, fetchedAt: l1Entry.fetchedAt);
        return;
      } else if (age < policy.usableFor) {
        _metrics.l1StaleHits++;
        yield CacheResult(data: l1Entry.data as T, source: CacheSource.staleMemory, fetchedAt: l1Entry.fetchedAt);
        // Continue to network fetch in background
      } else {
        _metrics.l1Misses++;
        // Expired in memory, remove it
        _l1Cache.remove(key);
      }
    } else {
      _metrics.l1Misses++;
      // 2. Check L2 Persistent Cache (Drift)
      final driftEntry = await (_db.select(_db.catalogCacheEntries)..where((tbl) => tbl.key.equals(key))).getSingleOrNull();
      
      if (driftEntry != null) {
        if (driftEntry.payloadVersion == CacheConfig.catalogPayloadVersion) {
          final age = now.difference(driftEntry.fetchedAt);
          if (age < policy.usableFor) {
            try {
              final decodedData = decode(driftEntry.payload);
              _putL1(key, decodedData, driftEntry.fetchedAt); // Promote to L1

              // Throttle lastAccessedAt updates (only if > 1 hour old)
              if (now.difference(driftEntry.lastAccessedAt).inHours >= 1) {
                (_db.update(_db.catalogCacheEntries)..where((tbl) => tbl.key.equals(key)))
                  .write(CatalogCacheEntriesCompanion(lastAccessedAt: Value(now)));
              }

              if (age < policy.freshFor) {
                _metrics.l2Hits++;
                yield CacheResult(data: decodedData, source: CacheSource.persistent, fetchedAt: driftEntry.fetchedAt);
                return;
              } else {
                _metrics.l2StaleHits++;
                yield CacheResult(data: decodedData, source: CacheSource.stalePersistent, fetchedAt: driftEntry.fetchedAt);
                // Continue to network fetch in background
              }
            } catch (e) {
              _metrics.decodeFailures++;
              // Self-healing: Decode failed, delete corrupt entry and proceed to network
              await (_db.delete(_db.catalogCacheEntries)..where((tbl) => tbl.key.equals(key))).go();
            }
          } else {
             _metrics.l2Misses++;
             // Expired in DB, we can delete it (or let background cleanup handle it)
             await (_db.delete(_db.catalogCacheEntries)..where((tbl) => tbl.key.equals(key))).go();
          }
        } else {
          _metrics.l2Misses++;
          // Schema payload mismatch, delete entry
          await (_db.delete(_db.catalogCacheEntries)..where((tbl) => tbl.key.equals(key))).go();
        }
      } else {
        _metrics.l2Misses++;
      }
    }

    // 3. Network Fetch (with deduplication)
    try {
      if (_inFlight.containsKey(key)) {
        _metrics.dedupHits++;
      } else {
        _metrics.backgroundRefreshes++;
      }
      final fetchFuture = _inFlight.putIfAbsent(key, () => _executeFetchAndCache<T>(key, resourceType, fetch, encode));
      final freshData = await fetchFuture as T;
      
      yield CacheResult(
        data: freshData, 
        source: CacheSource.network, 
        fetchedAt: DateTime.now() // Approximated, technically inside _executeFetchAndCache
      );
    } catch (e) {
      // If we yielded stale data previously, we just swallow the error 
      // and allow the UI to keep using the stale data.
      // 429 rate limits should be handled upstream (SpotifyClient throws or defers).
      // If this is the *first* emission (no stale data), rethrow the error.
      _inFlight.remove(key); // Ensure failed futures are removed immediately on error
      print('CatalogCacheRepository.watchOrFetch ERROR for key $key: $e');
      rethrow;
    }
  }

  Future<T> _executeFetchAndCache<T>(
    String key, 
    ResourceType resourceType, 
    Future<T> Function() fetch, 
    String Function(T value) encode
  ) async {
    try {
      final data = await fetch();
      final now = DateTime.now();

      // Write to L2 Persistent Cache
      final payload = encode(data);
      await _db.into(_db.catalogCacheEntries).insertOnConflictUpdate(
        CatalogCacheEntriesCompanion(
          key: Value(key),
          payload: Value(payload),
          fetchedAt: Value(now),
          lastAccessedAt: Value(now),
          payloadVersion: const Value(CacheConfig.catalogPayloadVersion),
          resourceType: Value(resourceType.name),
        )
      );
      _metrics.cacheWrites++;

      // Write to L1 Memory Cache
      _putL1(key, data, now);

      return data;
    } finally {
      // Always remove from in-flight registry when done
      _inFlight.remove(key);
    }
  }

  void _putL1<T>(String key, T data, DateTime fetchedAt) {
    _l1Cache[key] = _L1Entry(data, fetchedAt);
    if (_l1Cache.length > _maxL1Size) {
      // Remove oldest (first inserted in LinkedHashMap)
      _l1Cache.remove(_l1Cache.keys.first);
    }
  }

  /// Triggered after app startup to purge old cache entries.
  Future<void> cleanup() async {
    // We can do this in batches if needed, but a single delete query is usually fast in SQLite.
    // For now, we delete anything where fetchedAt + usableFor < now
    final now = DateTime.now();

    for (final resourceType in ResourceType.values) {
      final policy = resourceType.policy;
      final threshold = now.subtract(policy.usableFor);
      
      await (_db.delete(_db.catalogCacheEntries)
        ..where((tbl) => tbl.resourceType.equals(resourceType.name) & tbl.fetchedAt.isSmallerThanValue(threshold)))
      .go();
    }
  }

  /// Completely clears both L1 (Memory) and L2 (Persistent) caches.
  Future<void> clearAll() async {
    _l1Cache.clear();
    await _db.delete(_db.catalogCacheEntries).go();
  }
}

final catalogCacheRepositoryProvider = Provider<CatalogCacheRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final metrics = ref.watch(cacheMetricsProvider);
  return CatalogCacheRepository(db, metrics);
});
