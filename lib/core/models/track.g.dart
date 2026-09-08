// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TrackImpl _$$TrackImplFromJson(Map<String, dynamic> json) => _$TrackImpl(
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
);

Map<String, dynamic> _$$TrackImplToJson(_$TrackImpl instance) =>
    <String, dynamic>{
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
    };
