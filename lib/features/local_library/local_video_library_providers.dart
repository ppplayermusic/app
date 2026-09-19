// lib/features/local_library/local_video_library_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive_ce.dart';
import '../../core/db/app_database.dart';
import '../../core/models/track.dart' as model;

enum LocalVideoSortOption { title, duration, dateAdded }

class LocalVideoSortOptionNotifier extends Notifier<LocalVideoSortOption> {
  static const _boxName = 'settings';
  static const _key = 'local_video_sort_option';

  @override
  LocalVideoSortOption build() {
    _load();
    return LocalVideoSortOption.dateAdded; // Default to recently added
  }

  Future<void> _load() async {
    final box = await Hive.openBox(_boxName);
    final idx =
        box.get(_key, defaultValue: LocalVideoSortOption.dateAdded.index)
            as int;
    state = LocalVideoSortOption
        .values[idx.clamp(0, LocalVideoSortOption.values.length - 1)];
  }

  Future<void> update(LocalVideoSortOption value) async {
    state = value;
    final box = await Hive.openBox(_boxName);
    await box.put(_key, value.index);
  }
}

final localVideoSortOptionProvider =
    NotifierProvider<LocalVideoSortOptionNotifier, LocalVideoSortOption>(
      LocalVideoSortOptionNotifier.new,
    );

class LocalVideoSortAscendingNotifier extends Notifier<bool> {
  static const _boxName = 'settings';
  static const _key = 'local_video_sort_ascending';

  @override
  bool build() {
    _load();
    return false; // Default to descending (newest first)
  }

  Future<void> _load() async {
    final box = await Hive.openBox(_boxName);
    // Videos usually make sense to sort newest first
    state = box.get(_key, defaultValue: false) as bool;
  }

  Future<void> update(bool value) async {
    state = value;
    final box = await Hive.openBox(_boxName);
    await box.put(_key, value);
  }
}

final localVideoSortAscendingProvider =
    NotifierProvider<LocalVideoSortAscendingNotifier, bool>(
      LocalVideoSortAscendingNotifier.new,
    );

class LocalVideoSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';
  void update(String value) => state = value;
}

final localVideoSearchQueryProvider =
    NotifierProvider<LocalVideoSearchQueryNotifier, String>(
      LocalVideoSearchQueryNotifier.new,
    );

final _localVideoTracksStreamProvider = StreamProvider<List<model.Track>>((
  ref,
) {
  return ref.watch(appDatabaseProvider).watchLocalVideoTracks();
});

final sortedLocalVideosProvider = Provider<AsyncValue<List<model.Track>>>((
  ref,
) {
  final tracksAsync = ref.watch(_localVideoTracksStreamProvider);
  final sortOption = ref.watch(localVideoSortOptionProvider);
  final isAscending = ref.watch(localVideoSortAscendingProvider);
  final searchQuery = ref.watch(localVideoSearchQueryProvider).toLowerCase();

  return tracksAsync.whenData((tracks) {
    var filtered = tracks;
    if (searchQuery.isNotEmpty) {
      filtered = tracks.where((t) {
        return t.name.toLowerCase().contains(searchQuery);
      }).toList();
    }

    final sorted = List<model.Track>.from(filtered);
    sorted.sort((a, b) {
      int result = 0;
      switch (sortOption) {
        case LocalVideoSortOption.title:
          result = a.name.compareTo(b.name);
          break;
        case LocalVideoSortOption.duration:
          result = (a.durationMs ?? 0).compareTo(b.durationMs ?? 0);
          break;
        case LocalVideoSortOption.dateAdded:
          result = (a.localAddedAt ?? DateTime.fromMillisecondsSinceEpoch(0))
              .compareTo(
                b.localAddedAt ?? DateTime.fromMillisecondsSinceEpoch(0),
              );
          break;
      }
      return isAscending ? result : -result;
    });
    return sorted;
  });
});
