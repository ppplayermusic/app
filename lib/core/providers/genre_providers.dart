import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/spotify_repository.dart';
import '../models/track.dart';

final browseCategoriesProvider = StreamProvider<List<Map<String, dynamic>>>((
  ref,
) {
  final repo = ref.watch(spotifyRepositoryProvider);
  return repo.watchBrowseCategories(limit: 50).map((res) => res.data);
});

final categoryPlaylistsProvider =
    StreamProvider.family<List<Map<String, dynamic>>, String>((
      ref,
      categoryId,
    ) {
      final repo = ref.watch(spotifyRepositoryProvider);
      return repo.watchCategoryPlaylists(categoryId).map((r) => r.data);
    });

final categoryTopTracksProvider = StreamProvider.family<List<Track>, String>((
  ref,
  categoryId,
) async* {
  final playlists = await ref.watch(
    categoryPlaylistsProvider(categoryId).future,
  );
  if (playlists.isEmpty) {
    yield [];
    return;
  }

  final playlistId = playlists.first['id'] as String?;
  if (playlistId == null) {
    yield [];
    return;
  }

  final repo = ref.watch(spotifyRepositoryProvider);
  yield* repo.watchPlaylistTracks(playlistId).map((r) => r.data);
});

final categoryCollageImagesProvider = StreamProvider.family<List<String>, String>((
  ref,
  categoryId,
) async* {
  final tracks = await ref.watch(categoryTopTracksProvider(categoryId).future);

  final images = <String>{};
  for (final track in tracks) {
    if (track.albumImage != null && track.albumImage!.isNotEmpty) {
      images.add(track.albumImage!);
      if (images.length >= 3) break;
    }
  }

  yield images.toList();
});

final playlistCollageImagesProvider = StreamProvider.family<List<String>, String>((
  ref,
  playlistId,
) async* {
  final repo = ref.watch(spotifyRepositoryProvider);
  final tracksStream = repo.watchPlaylistTracks(playlistId);

  await for (final cacheResult in tracksStream) {
    final images = <String>{};
    for (final track in cacheResult.data) {
      if (track.albumImage != null && track.albumImage!.isNotEmpty) {
        images.add(track.albumImage!);
        if (images.length >= 3) break;
      }
    }
    yield images.toList();
  }
});
