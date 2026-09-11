// Import top-level features
import '../../features/home/home_screen.dart';
import '../../features/home/recently_played_screen.dart';
import '../../features/artist/artist_screen.dart';
import '../../features/album/album_screen.dart';
import '../../features/search/search_screen.dart';
import '../../features/library/remote_playlist_screen.dart';
import '../../features/radio/radio_details_screen.dart';
import '../../features/discover/providers/discover_providers.dart';
import '../../core/providers/genre_providers.dart';

void invalidateCatalogProviders(dynamic ref) {
  // Home Screen
  ref.invalidate(newReleasesProvider);
  ref.invalidate(featuredPlaylistsProvider);
  ref.invalidate(popularTracksProvider);
  ref.invalidate(marketPopularAlbumsProvider);
  ref.invalidate(popularArtistsProvider);
  ref.invalidate(madeForYouMixesProvider);
  ref.invalidate(suggestedStationsProvider);

  // Recently Played
  ref.invalidate(recentlyPlayedTracksProvider);

  // Discover
  ref.invalidate(discoverContentProvider);

  // Browse / Genres
  ref.invalidate(browseCategoriesProvider);

  // Family Providers (invalidating the base provider clears all cached instances)
  ref.invalidate(artistProvider);
  ref.invalidate(artistTopTracksProvider);
  ref.invalidate(artistAlbumsProvider);
  ref.invalidate(relatedArtistsProvider);
  ref.invalidate(artistPlaylistsProvider);

  ref.invalidate(albumProvider);
  ref.invalidate(searchResultsProvider);
  ref.invalidate(remotePlaylistTracksProvider);
  ref.invalidate(radioTracksProvider);
  ref.invalidate(categoryPlaylistsProvider);
  ref.invalidate(categoryTopTracksProvider);
}
