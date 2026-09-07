import 'package:freezed_annotation/freezed_annotation.dart';

part 'track.freezed.dart';
part 'track.g.dart';

@freezed
class Track with _$Track {
  const factory Track({
    required String spotifyId,
    required String name,
    required String artistId,
    required String artistName,
    String? albumId,
    String? albumName,
    String? albumImage,
    int? durationMs,
    String? youtubeVideoId,
    @Default(0) int playCount,
    @Default(false) bool isFavorite,
    String? queueItemId, // Unique ID for queue instances
  }) = _Track;

  factory Track.fromJson(Map<String, dynamic> json) => _$TrackFromJson(json);

  /// Build from Drift database row
  factory Track.fromDb(dynamic t) {
    return Track(
      spotifyId: t.spotifyId,
      name: t.name,
      artistId: t.artistId,
      artistName: t.artistName,
      albumId: t.albumId,
      albumName: t.albumName,
      albumImage: t.albumImage,
      durationMs: t.durationMs,
      youtubeVideoId: t.youtubeVideoId,
      playCount: t.playCount,
      isFavorite: t.isFavorite,
    );
  }

  /// Build a track from Spotify API track object
  factory Track.fromSpotify(Map<String, dynamic> json) {
    final artists = (json['artists'] as List?) ?? [];
    final album = json['album'] as Map<String, dynamic>? ?? {};
    final images = (album['images'] as List?) ?? [];
    return Track(
      spotifyId: json['id'] as String,
      name: json['name'] as String,
      artistId: artists.isNotEmpty ? artists[0]['id'] as String : '',
      artistName: artists.isNotEmpty ? artists.map((a) => a['name'] as String).join(', ') : '',
      albumId: album['id'] as String?,
      albumName: album['name'] as String?,
      albumImage: images.isNotEmpty ? images[0]['url'] as String? : null,
      durationMs: json['duration_ms'] as int?,
    );
  }
}
