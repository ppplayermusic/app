// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Track _$TrackFromJson(Map<String, dynamic> json) => _Track(
  spotifyId: json['spotifyId'] as String,
  name: json['name'] as String,
  artistId: json['artistId'] as String,
  artistName: json['artistName'] as String,
  albumId: json['albumId'] as String?,
  albumName: json['albumName'] as String?,
  albumImage: json['albumImage'] as String?,
  durationMs: (json['durationMs'] as num?)?.toInt(),
  youtubeVideoId: json['youtubeVideoId'] as String?,
  playCount: (json['playCount'] as num?)?.toInt() ?? 0,
  isFavorite: json['isFavorite'] as bool? ?? false,
  queueItemId: json['queueItemId'] as String?,
  queueOrigin:
      $enumDecodeNullable(_$QueueItemOriginEnumMap, json['queueOrigin']) ??
      QueueItemOrigin.context,
  sourceType:
      $enumDecodeNullable(_$TrackSourceTypeEnumMap, json['sourceType']) ??
      TrackSourceType.online,
  localFilePath: json['localFilePath'] as String?,
  localArtworkPath: json['localArtworkPath'] as String?,
  localAvailabilityStatus:
      json['localAvailabilityStatus'] as String? ?? 'available',
  localAlbumGroupKey: json['localAlbumGroupKey'] as String?,
  localAddedAt: json['localAddedAt'] == null
      ? null
      : DateTime.parse(json['localAddedAt'] as String),
  isVideoFile: json['isVideoFile'] as bool? ?? false,
);

Map<String, dynamic> _$TrackToJson(_Track instance) => <String, dynamic>{
  'spotifyId': instance.spotifyId,
  'name': instance.name,
  'artistId': instance.artistId,
  'artistName': instance.artistName,
  'albumId': instance.albumId,
  'albumName': instance.albumName,
  'albumImage': instance.albumImage,
  'durationMs': instance.durationMs,
  'youtubeVideoId': instance.youtubeVideoId,
  'playCount': instance.playCount,
  'isFavorite': instance.isFavorite,
  'queueItemId': instance.queueItemId,
  'queueOrigin': _$QueueItemOriginEnumMap[instance.queueOrigin]!,
  'sourceType': _$TrackSourceTypeEnumMap[instance.sourceType]!,
  'localFilePath': instance.localFilePath,
  'localArtworkPath': instance.localArtworkPath,
  'localAvailabilityStatus': instance.localAvailabilityStatus,
  'localAlbumGroupKey': instance.localAlbumGroupKey,
  'localAddedAt': instance.localAddedAt?.toIso8601String(),
  'isVideoFile': instance.isVideoFile,
};

const _$QueueItemOriginEnumMap = {
  QueueItemOrigin.context: 'context',
  QueueItemOrigin.user: 'user',
  QueueItemOrigin.autoplay: 'autoplay',
};

const _$TrackSourceTypeEnumMap = {
  TrackSourceType.online: 'online',
  TrackSourceType.local: 'local',
};
