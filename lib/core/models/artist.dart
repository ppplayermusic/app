import 'package:freezed_annotation/freezed_annotation.dart';

part 'artist.freezed.dart';
part 'artist.g.dart';

@freezed
class Artist with _$Artist {
  const factory Artist({
    required String spotifyId,
    required String name,
    String? imageUrl,
    String? imageSmall,
    int? followers,
    int? popularity,
  }) = _Artist;

  factory Artist.fromJson(Map<String, dynamic> json) =>
      _$ArtistFromJson(json);

  factory Artist.fromSpotify(Map<String, dynamic> json) {
    final images = (json['images'] as List?) ?? [];
    return Artist(
      spotifyId: json['id'] as String,
      name: json['name'] as String,
      imageUrl: images.isNotEmpty ? images[0]['url'] as String? : null,
      imageSmall: images.length > 1 ? images[1]['url'] as String? : null,
      followers: (json['followers'] as Map?)?['total'] as int?,
      popularity: json['popularity'] as int?,
    );
  }
}
