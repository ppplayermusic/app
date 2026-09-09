import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/spotify_repository.dart';
import '../models/track.dart';

final browseCategoriesProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  final repo = ref.watch(spotifyRepositoryProvider);
  return repo.watchBrowseCategories().map((res) => res.data);
});

final categoryPlaylistsProvider = StreamProvider.family<List<Map<String, dynamic>>, String>((ref, categoryId) {
  final repo = ref.watch(spotifyRepositoryProvider);
  return repo.watchCategoryPlaylists(categoryId).map((r) => r.data);
});

final categoryTopTracksProvider = StreamProvider.family<List<Track>, String>((ref, categoryId) async* {
  final playlists = await ref.watch(categoryPlaylistsProvider(categoryId).future);
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
