import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/spotify_client.dart';
import '../models/track.dart';

final browseCategoriesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final client = ref.watch(spotifyClientProvider);
  return client.getBrowseCategories(limit: 40);
});

final categoryPlaylistsProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, categoryId) async {
  final client = ref.watch(spotifyClientProvider);
  return client.getCategoryPlaylists(categoryId, limit: 20);
});

final categoryTopTracksProvider = FutureProvider.family<List<Track>, String>((ref, categoryId) async {
  final client = ref.watch(spotifyClientProvider);
  final playlists = await client.getCategoryPlaylists(categoryId, limit: 1);
  if (playlists.isEmpty) return [];
  
  final playlistId = playlists.first['id'] as String;
  return client.getPlaylistTracks(playlistId, limit: 30);
});
