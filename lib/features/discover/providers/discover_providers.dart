import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/discover_models.dart';
import '../services/discover_service.dart';

class DiscoverContentNotifier extends AutoDisposeAsyncNotifier<DiscoverContent> {
  Timer? _cacheTimer;

  @override
  FutureOr<DiscoverContent> build() async {
    // Keep the cache alive for 30 minutes unless manually invalidated
    ref.keepAlive();
    
    // Time-based expiration to prevent spamming Spotify.
    _cacheTimer?.cancel();
    _cacheTimer = Timer(const Duration(minutes: 30), () {
      ref.invalidateSelf();
    });

    ref.onDispose(() {
      _cacheTimer?.cancel();
    });

    final service = ref.watch(discoverServiceProvider);
    return service.buildDiscoverContent();
  }

  Future<void> refresh() async {
    // Manually force a refresh (e.g. pull to refresh)
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(discoverServiceProvider).buildDiscoverContent());
  }
}

final discoverContentProvider = AutoDisposeAsyncNotifierProvider<DiscoverContentNotifier, DiscoverContent>(
  DiscoverContentNotifier.new,
);
