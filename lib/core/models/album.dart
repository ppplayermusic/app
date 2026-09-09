import 'package:freezed_annotation/freezed_annotation.dart';

part 'album.freezed.dart';
part 'album.g.dart';

@freezed
abstract class Album with _$Album {
  const factory Album({
    required String spotifyId,
    required String name,
    required String artistId,
    required String artistName,
    String? imageUrl,
    String? releaseDate,
    int? totalTracks,
  }) = _Album;

  factory Album.fromJson(Map<String, dynamic> json) => _$AlbumFromJson(json);

  factory Album.fromSpotify(Map<String, dynamic> json) {
    final artists = (json['artists'] as List?) ?? [];
    final images = (json['images'] as List?) ?? [];
    return Album(
      spotifyId: json['id'] as String,
      name: json['name'] as String,
      artistId: artists.isNotEmpty ? artists[0]['id'] as String : '',
      artistName: artists.isNotEmpty ? artists[0]['name'] as String : '',
      imageUrl: images.isNotEmpty ? images[0]['url'] as String? : null,
      releaseDate: json['release_date'] as String?,
      totalTracks: json['total_tracks'] as int?,
    );
  }
}
