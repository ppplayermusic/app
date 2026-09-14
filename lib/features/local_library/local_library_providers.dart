import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/db/app_database.dart';
import '../../core/models/track.dart' as model;
import '../../core/models/local_album.dart';
import '../../core/models/local_artist.dart';
import '../../core/models/local_folder.dart';


enum LocalSortOption { title, artist, album, duration, dateAdded }

class LocalSortOptionNotifier extends Notifier<LocalSortOption> {
  @override
  LocalSortOption build() => LocalSortOption.title;
  void update(LocalSortOption value) => state = value;
}
final localSortOptionProvider = NotifierProvider<LocalSortOptionNotifier, LocalSortOption>(LocalSortOptionNotifier.new);

class LocalSortAscendingNotifier extends Notifier<bool> {
  @override
  bool build() => true;
  void update(bool value) => state = value;
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
          result = a.name.compareTo(b.name);
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
