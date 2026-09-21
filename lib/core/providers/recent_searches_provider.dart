import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';

final recentSearchesProvider =
    NotifierProvider<RecentSearchesNotifier, List<String>>(
      RecentSearchesNotifier.new,
    );

class RecentSearchesNotifier extends Notifier<List<String>> {
  @override
  List<String> build() {
    _load();
    return [];
  }

  static const _boxName = 'recent_searches_box';

  Future<void> _load() async {
    final box = await Hive.openBox<String>(_boxName);
    state = box.values.toList().reversed.toList();
  }

  Future<void> addSearch(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;

    final normalized = trimmed.toLowerCase();

    final box = await Hive.openBox<String>(_boxName);

    // Remove if already exists to avoid duplicates
    final keyToRemove = box.keys.firstWhere(
      (k) => box.get(k)?.toLowerCase() == normalized,
      orElse: () => null,
    );
    if (keyToRemove != null) {
      await box.delete(keyToRemove);
    }

    await box.add(trimmed);

    // Keep only last 10
    while (box.length > 10) {
      await box.deleteAt(0);
    }

    state = box.values.toList().reversed.toList();
  }

  Future<void> removeSearch(String query) async {
    final normalized = query.trim().toLowerCase();
    final box = await Hive.openBox<String>(_boxName);
    final keyToRemove = box.keys.firstWhere(
      (k) => box.get(k)?.toLowerCase() == normalized,
      orElse: () => null,
    );
    if (keyToRemove != null) {
      await box.delete(keyToRemove);
      state = box.values.toList().reversed.toList();
    }
  }

  Future<void> clearAll() async {
    final box = await Hive.openBox<String>(_boxName);
    await box.clear();
    state = [];
  }
}
