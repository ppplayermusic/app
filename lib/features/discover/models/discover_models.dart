import '../../../core/models/artist.dart';
import '../../../core/models/track.dart';

enum DiscoverSectionType {
  madeForYou,
  becauseYouListenedTo,
  fromFavorites,
  followedArtists,
  explore, // Fallback/discovery content
}

class DiscoverSection {
  const DiscoverSection({
    required this.title,
    this.subtitle,
    required this.type,
    this.tracks = const [],
    this.artists = const [],
  });

  final String title;
  final String? subtitle;
  final DiscoverSectionType type;
  final List<Track> tracks;
  final List<Artist> artists;
}

class DiscoverContent {
  const DiscoverContent({
    required this.sections,
    required this.isPersonalized,
  });

  final List<DiscoverSection> sections;
  final bool isPersonalized;
}
