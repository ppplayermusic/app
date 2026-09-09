import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class PPImageCacheManager {
  static const key = 'ppPlayerImageCache';

  static final CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 500,
    ),
  );
}
