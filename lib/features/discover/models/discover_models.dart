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

  Map<String, dynamic> toJson() => {
    'title': title,
    'subtitle': subtitle,
    'type': type.name,
    'tracks': tracks.map((t) => t.toJson()).toList(),
    'artists': artists.map((a) => a.toJson()).toList(),
  };

  factory DiscoverSection.fromJson(Map<String, dynamic> json) =>
      DiscoverSection(
        title: json['title'] as String,
        subtitle: json['subtitle'] as String?,
        type: DiscoverSectionType.values.firstWhere(
          (e) => e.name == json['type'],
        ),
        tracks:
            (json['tracks'] as List?)
                ?.map((t) => Track.fromJson(t as Map<String, dynamic>))
                .toList() ??
            [],
        artists:
            (json['artists'] as List?)
                ?.map((a) => Artist.fromJson(a as Map<String, dynamic>))
                .toList() ??
            [],
      );
}

class DiscoverContent {
  const DiscoverContent({required this.sections, required this.isPersonalized});

  final List<DiscoverSection> sections;
  final bool isPersonalized;

  Map<String, dynamic> toJson() => {
    'sections': sections.map((s) => s.toJson()).toList(),
    'isPersonalized': isPersonalized,
  };

  factory DiscoverContent.fromJson(Map<String, dynamic> json) =>
      DiscoverContent(
        sections:
            (json['sections'] as List?)
                ?.map(
                  (s) => DiscoverSection.fromJson(s as Map<String, dynamic>),
                )
                .toList() ??
            [],
        isPersonalized: json['isPersonalized'] as bool? ?? false,
      );
}
