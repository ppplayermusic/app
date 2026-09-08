import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';

final recentSearchesProvider = StateNotifierProvider<RecentSearchesNotifier, List<String>>((ref) {
  return RecentSearchesNotifier();
});

class RecentSearchesNotifier extends StateNotifier<List<String>> {
  RecentSearchesNotifier() : super([]) {
    _load();
  }

  static const _boxName = 'recent_searches_box';

  Future<void> _load() async {
    final box = await Hive.openBox<String>(_boxName);
    state = box.values.toList().reversed.toList();
  }

  Future<void> addSearch(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;
    
    final box = await Hive.openBox<String>(_boxName);
    
    // Remove if already exists to avoid duplicates
    final keyToRemove = box.keys.firstWhere((k) => box.get(k) == trimmed, orElse: () => null);
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
    final box = await Hive.openBox<String>(_boxName);
    final keyToRemove = box.keys.firstWhere((k) => box.get(k) == query, orElse: () => null);
    if (keyToRemove != null) {
      await box.delete(keyToRemove);
      state = box.values.toList().reversed.toList();
    }
  }
}
