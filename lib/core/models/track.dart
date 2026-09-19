import 'package:freezed_annotation/freezed_annotation.dart';

part 'track.freezed.dart';
part 'track.g.dart';

enum QueueItemOrigin { context, user, autoplay }

/// Distinguishes how the track is played. Stored explicitly so that an
/// unavailable local track is still recognised as local in the playback layer.
enum TrackSourceType { online, local, networkStream }

enum StreamLiveStatus {
  unknown(0),
  live(1),
  onDemand(2);

  final int value;
  const StreamLiveStatus(this.value);

  static StreamLiveStatus fromValue(int value) {
    return StreamLiveStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => StreamLiveStatus.unknown,
    );
  }
}

Object? _readLiveStatus(Map json, String key) {
  if (json.containsKey('liveStatus')) return json['liveStatus'];
  if (json['isLiveStream'] == true) return 1;
  return 0;
}

class StreamLiveStatusConverter
    implements JsonConverter<StreamLiveStatus, dynamic> {
  const StreamLiveStatusConverter();

  @override
  StreamLiveStatus fromJson(dynamic json) {
    if (json is int) {
      if (json == 1) return StreamLiveStatus.live;
      if (json == 2) return StreamLiveStatus.onDemand;
      return StreamLiveStatus.unknown;
    } else if (json is String) {
      if (json == 'live') return StreamLiveStatus.live;
      if (json == 'onDemand') return StreamLiveStatus.onDemand;
      return StreamLiveStatus.unknown;
    }
    return StreamLiveStatus.unknown;
  }

  @override
  dynamic toJson(StreamLiveStatus object) => object.index;
}

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
    // --- Local music fields ---
    @Default(TrackSourceType.online) TrackSourceType sourceType,

    /// Absolute path or content URI stored by LocalFileResolver.
    /// Null only when [sourceType] == TrackSourceType.online.
    String? localFilePath,

    /// Local artwork absolute path (cached by MetadataExtractor).
    String? localArtworkPath,

    /// 'available' | 'missing' | 'permissionRevoked' | 'decodingError'
    @Default('available') String localAvailabilityStatus,
    String? localAlbumGroupKey,
    DateTime? localAddedAt,

    /// True when [VideoProbeService] confirmed a video stream in this file.
    /// False for all audio-only tracks, unclassified pre-v11 rows, and
    /// online tracks.
    @Default(false) bool isVideoFile,
    // --- Network Stream fields ---
    /// Stream URL for network streams.
    String? networkStreamUrl,

    /// The stream live status (unknown, live, onDemand).
    @StreamLiveStatusConverter()
    @JsonKey(readValue: _readLiveStatus)
    @Default(StreamLiveStatus.unknown)
    StreamLiveStatus liveStatus,
  }) = _Track;

  factory Track.fromJson(Map<String, dynamic> json) => _$TrackFromJson(json);

  /// Build from Drift database row
  factory Track.fromDb(dynamic t) {
    final String id = t.spotifyId;

    if (id.startsWith('stream:')) {
      return Track(
        spotifyId: id,
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
        sourceType: TrackSourceType.networkStream,
        networkStreamUrl: id.substring(7),
      );
    }

    return Track(
      spotifyId: id,
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
      sourceType: id.startsWith('local:')
          ? TrackSourceType.local
          : TrackSourceType.online,
    );
  }

  /// Build from a locally imported file plus its LocalFile DB row.
  factory Track.fromLocalFile({
    required String libraryId, // 'local:<uuid>'
    required String name,
    required String artistName,
    required String albumName,
    required String localFilePath,
    String? localArtworkPath,
    int? durationMs,
    bool isFavorite = false,
    int playCount = 0,
    String localAvailabilityStatus = 'available',
    DateTime? localAddedAt,
    bool isVideoFile = false,
  }) {
    return Track(
      spotifyId: libraryId,
      name: name,
      // Local tracks use libraryId as artistId/albumId placeholder.
      artistId: 'local',
      artistName: artistName,
      albumId: null,
      albumName: albumName,
      albumImage: localArtworkPath,
      durationMs: durationMs,
      sourceType: TrackSourceType.local,
      localFilePath: localFilePath,
      localArtworkPath: localArtworkPath,
      localAvailabilityStatus: localAvailabilityStatus,
      localAddedAt: localAddedAt,
      isFavorite: isFavorite,
      playCount: playCount,
      isVideoFile: isVideoFile,
    );
  }

  /// Build from a parsed network stream (e.g. M3U channel)
  factory Track.fromNetworkStream({
    required String streamUrl,
    required String title,
    String? logoUrl,
    String? groupTitle,
    bool isFavorite = false,
    StreamLiveStatus liveStatus = StreamLiveStatus.unknown,
  }) {
    return Track(
      // We prefix with 'stream:' to avoid Spotify ID collisions.
      spotifyId: 'stream:$streamUrl',
      name: title,
      artistId: 'stream',
      artistName: groupTitle ?? 'Network Stream',
      albumId: null,
      albumName: null,
      albumImage: logoUrl,
      sourceType: TrackSourceType.networkStream,
      networkStreamUrl: streamUrl,
      isFavorite: isFavorite,
      liveStatus: liveStatus,
      isVideoFile: true, // Most IPTV streams are video
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
      artistId: artists.isNotEmpty
          ? artists
                .map((a) => (a is Map ? a['id']?.toString() : null) ?? '')
                .where((id) => id.isNotEmpty)
                .join(',')
          : '',
      artistName: artists.isNotEmpty
          ? artists
                .map((a) => (a is Map ? a['name']?.toString() : null) ?? '')
                .where((n) => n.isNotEmpty)
                .join(', ')
          : 'Unknown Artist',
      albumId: album['id']?.toString(),
      albumName: album['name']?.toString(),
      albumImage: images.isNotEmpty && images[0] is Map
          ? (images[0] as Map)['url']?.toString()
          : null,
      durationMs: json['duration_ms'] as int?,
    );
  }
}

extension TrackSourceX on Track {
  bool get isLocal => sourceType == TrackSourceType.local;
  bool get isNetworkStream => sourceType == TrackSourceType.networkStream;

  /// True when the track is local AND the file was last seen as accessible.
  /// An unavailable local track has isLocal=true but isAvailable=false.
  bool get isAvailable => !isLocal || localAvailabilityStatus == 'available';
}
