import 'package:freezed_annotation/freezed_annotation.dart';

part 'track.freezed.dart';
part 'track.g.dart';

enum QueueItemOrigin { context, user, autoplay }

@freezed
abstract class Track with _$Track {
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
    @Default(QueueItemOrigin.context) QueueItemOrigin queueOrigin,
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
    final album = (json['album'] as Map<String, dynamic>?) ?? {};
    final images = (album['images'] as List?) ?? [];
    return Track(
      spotifyId: (json['id'] as String?) ?? '',
      name: (json['name'] as String?) ?? 'Unknown Title',
      artistId:
          artists.isNotEmpty
              ? artists
                  .map((a) => (a is Map ? a['id']?.toString() : null) ?? '')
                  .where((id) => id.isNotEmpty)
                  .join(',')
              : '',
      artistName:
          artists.isNotEmpty
              ? artists
                  .map((a) => (a is Map ? a['name']?.toString() : null) ?? '')
                  .where((n) => n.isNotEmpty)
                  .join(', ')
              : 'Unknown Artist',
      albumId: album['id']?.toString(),
      albumName: album['name']?.toString(),
      albumImage:
          images.isNotEmpty && images[0] is Map
              ? (images[0] as Map)['url']?.toString()
              : null,
      durationMs: json['duration_ms'] as int?,
    );
  }
}
