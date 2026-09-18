import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/db/app_database.dart';
import '../../core/models/track.dart' as model;
import '../../core/models/local_album.dart';
import '../../core/models/local_artist.dart';
import '../../core/models/local_folder.dart';
import '../../core/models/local_genre.dart';
import 'package:hive_ce/hive_ce.dart';

enum LocalSortOption { title, artist, album, duration, dateAdded }

class LocalSortOptionNotifier extends Notifier<LocalSortOption> {
  static const _boxName = 'settings';
  static const _key = 'local_sort_option';

  @override
  LocalSortOption build() {
    _load();
    return LocalSortOption.title; // Default, will update after load
  }

  Future<void> _load() async {
    final box = await Hive.openBox(_boxName);
    final idx = box.get(_key, defaultValue: LocalSortOption.title.index) as int;
    state = LocalSortOption.values[idx.clamp(0, LocalSortOption.values.length - 1)];
  }

  Future<void> update(LocalSortOption value) async {
    state = value;
    final box = await Hive.openBox(_boxName);
    await box.put(_key, value.index);
  }
}
final localSortOptionProvider = NotifierProvider<LocalSortOptionNotifier, LocalSortOption>(LocalSortOptionNotifier.new);

class LocalSortAscendingNotifier extends Notifier<bool> {
  static const _boxName = 'settings';
  static const _key = 'local_sort_ascending';

  @override
  bool build() {
    _load();
    return true; // Default, will update after load
  }

  Future<void> _load() async {
    final box = await Hive.openBox(_boxName);
    state = box.get(_key, defaultValue: true) as bool;
  }

  Future<void> update(bool value) async {
    state = value;
    final box = await Hive.openBox(_boxName);
    await box.put(_key, value);
  }
}
final localSortAscendingProvider = NotifierProvider<LocalSortAscendingNotifier, bool>(LocalSortAscendingNotifier.new);

class LocalSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';
  void update(String value) => state = value;
}
final localSearchQueryProvider = NotifierProvider<LocalSearchQueryNotifier, String>(LocalSearchQueryNotifier.new);

final _localTracksStreamProvider = StreamProvider<List<model.Track>>((ref) {
  return ref.watch(appDatabaseProvider).watchLocalAppTracks();
});

final sortedLocalSongsProvider = Provider<AsyncValue<List<model.Track>>>((ref) {
  final tracksAsync = ref.watch(_localTracksStreamProvider);
  final sortOption = ref.watch(localSortOptionProvider);
  final isAscending = ref.watch(localSortAscendingProvider);
  final searchQuery = ref.watch(localSearchQueryProvider).toLowerCase();

  return tracksAsync.whenData((tracks) {
    var filtered = tracks;
    if (searchQuery.isNotEmpty) {
      filtered = tracks.where((t) {
        return t.name.toLowerCase().contains(searchQuery) ||
            t.artistName.toLowerCase().contains(searchQuery) ||
            (t.albumName?.toLowerCase().contains(searchQuery) ?? false);
      }).toList();
    }

    final sorted = List<model.Track>.from(filtered);
    sorted.sort((a, b) {
      int result = 0;
      switch (sortOption) {
        case LocalSortOption.title:
          result = a.name.compareTo(b.name);
          break;
        case LocalSortOption.artist:
          result = a.artistName.compareTo(b.artistName);
          break;
        case LocalSortOption.album:
          result = (a.albumName ?? '').compareTo(b.albumName ?? '');
          break;
        case LocalSortOption.duration:
          result = (a.durationMs ?? 0).compareTo(b.durationMs ?? 0);
          break;
        case LocalSortOption.dateAdded:
          result = (a.localAddedAt ?? DateTime.fromMillisecondsSinceEpoch(0))
              .compareTo(b.localAddedAt ?? DateTime.fromMillisecondsSinceEpoch(0));
          break;
      }
      return isAscending ? result : -result;
    });
    return sorted;
  });
});

final _localAlbumsStreamProvider = StreamProvider<List<LocalAlbum>>((ref) {
  return ref.watch(appDatabaseProvider).watchLocalAlbums();
});

final localAlbumsProvider = Provider<AsyncValue<List<LocalAlbum>>>((ref) {
  final albumsAsync = ref.watch(_localAlbumsStreamProvider);
  final searchQuery = ref.watch(localSearchQueryProvider).toLowerCase();
  
  return albumsAsync.whenData((albums) {
    var filtered = albums;
    if (searchQuery.isNotEmpty) {
      filtered = albums.where((a) {
        return a.title.toLowerCase().contains(searchQuery) ||
            (a.artist?.toLowerCase().contains(searchQuery) ?? false);
      }).toList();
    }
    
    final sorted = List<LocalAlbum>.from(filtered);
    sorted.sort((a, b) => a.title.compareTo(b.title));
    return sorted;
  });
});

final _localArtistsStreamProvider = StreamProvider<List<LocalArtist>>((ref) {
  return ref.watch(appDatabaseProvider).watchLocalArtists();
});

final localArtistsProvider = Provider<AsyncValue<List<LocalArtist>>>((ref) {
  final artistsAsync = ref.watch(_localArtistsStreamProvider);
  final searchQuery = ref.watch(localSearchQueryProvider).toLowerCase();

  return artistsAsync.whenData((artists) {
    var filtered = artists;
    if (searchQuery.isNotEmpty) {
      filtered = artists.where((a) => a.name.toLowerCase().contains(searchQuery)).toList();
    }
    
    final sorted = List<LocalArtist>.from(filtered);
    sorted.sort((a, b) => a.name.compareTo(b.name));
    return sorted;
  });
});

final localFoldersProvider = StreamProvider<List<LocalFolder>>((ref) {
  return ref.watch(appDatabaseProvider).watchLocalFolders();
});

final _localGenresStreamProvider = StreamProvider<List<LocalGenre>>((ref) {
  return ref.watch(appDatabaseProvider).watchLocalGenres();
});

final localGenresProvider = Provider<AsyncValue<List<LocalGenre>>>((ref) {
  final genresAsync = ref.watch(_localGenresStreamProvider);
  final searchQuery = ref.watch(localSearchQueryProvider).toLowerCase();

  return genresAsync.whenData((genres) {
    var filtered = genres;
    if (searchQuery.isNotEmpty) {
      filtered = genres.where((a) => a.name.toLowerCase().contains(searchQuery)).toList();
    }
    
    final sorted = List<LocalGenre>.from(filtered);
    sorted.sort((a, b) => a.name.compareTo(b.name));
    return sorted;
  });
});
