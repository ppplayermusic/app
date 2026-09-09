// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Album _$AlbumFromJson(Map<String, dynamic> json) => _Album(
  spotifyId: json['spotifyId'] as String,
  name: json['name'] as String,
  artistId: json['artistId'] as String,
  artistName: json['artistName'] as String,
  imageUrl: json['imageUrl'] as String?,
  releaseDate: json['releaseDate'] as String?,
  totalTracks: (json['totalTracks'] as num?)?.toInt(),
);

Map<String, dynamic> _$AlbumToJson(_Album instance) => <String, dynamic>{
  'spotifyId': instance.spotifyId,
  'name': instance.name,
  'artistId': instance.artistId,
  'artistName': instance.artistName,
  'imageUrl': instance.imageUrl,
  'releaseDate': instance.releaseDate,
  'totalTracks': instance.totalTracks,
};
