import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/discover_models.dart';
import '../services/discover_service.dart';

final discoverContentProvider = StreamProvider.autoDispose<DiscoverContent>((ref) {
  // Keep the cache alive to avoid refetching on transient navigations
  ref.keepAlive();
  
  final service = ref.watch(discoverServiceProvider);
  return service.watchDiscoverContent().map((result) => result.data);
});
