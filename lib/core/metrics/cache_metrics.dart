import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CacheMetrics {
  // L1 Metrics
  int l1Hits = 0;
  int l1StaleHits = 0;
  int l1Misses = 0;

  // L2 Metrics
  int l2Hits = 0;
  int l2StaleHits = 0;
  int l2Misses = 0;

  // Cache Operations
  int dedupHits = 0;
  int backgroundRefreshes = 0;
  int cacheWrites = 0;
  int decodeFailures = 0;

  // Spotify Metrics
  int spotifyRequests = 0;

  // YouTube Resolver Metrics
  int youtubeResolutionRequests = 0;
  int youtubeCachedMappingHits = 0;
  int youtubeNegativeCacheHits = 0;
  int youtubeForcedReresolutions = 0;

  Timer? _loggingTimer;
  bool _isLogging = false;

  void startLogging() {
    if (!kDebugMode) return;
    if (_isLogging) return;
    _isLogging = true;

    _loggingTimer = Timer.periodic(const Duration(seconds: 20), (_) {
      _printMetrics();
    });
  }

  void stopLogging() {
    _loggingTimer?.cancel();
    _isLogging = false;
  }

  void _printMetrics() {
    final int l1Total = l1Hits + l1StaleHits + l1Misses;
    final String l1HitRate = l1Total > 0 ? '${((l1Hits + l1StaleHits) / l1Total * 100).toStringAsFixed(1)}%' : 'N/A';

    final int l2Total = l2Hits + l2StaleHits + l2Misses;
    final String l2HitRate = l2Total > 0 ? '${((l2Hits + l2StaleHits) / l2Total * 100).toStringAsFixed(1)}%' : 'N/A';

    debugPrint('\n=== [CacheMetrics] ===');
    debugPrint('L1   | fresh=$l1Hits stale=$l1StaleHits miss=$l1Misses (Hit Rate: $l1HitRate)');
    debugPrint('L2   | fresh=$l2Hits stale=$l2StaleHits miss=$l2Misses (Hit Rate: $l2HitRate)');
    debugPrint('Ops  | dedup=$dedupHits refresh=$backgroundRefreshes writes=$cacheWrites decodeFail=$decodeFailures');
    debugPrint('Net  | spotifyRequests=$spotifyRequests');
    debugPrint('YT   | resolves=$youtubeResolutionRequests mappingHits=$youtubeCachedMappingHits negativeHits=$youtubeNegativeCacheHits forcedRetries=$youtubeForcedReresolutions');
    debugPrint('======================\n');
  }
}

final cacheMetricsProvider = Provider<CacheMetrics>((ref) {
  final metrics = CacheMetrics();
  ref.onDispose(() => metrics.stopLogging());
  return metrics;
});
