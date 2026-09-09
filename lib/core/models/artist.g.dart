// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Artist _$ArtistFromJson(Map<String, dynamic> json) => _Artist(
  spotifyId: json['spotifyId'] as String,
  name: json['name'] as String,
  imageUrl: json['imageUrl'] as String?,
  imageSmall: json['imageSmall'] as String?,
  followers: (json['followers'] as num?)?.toInt(),
  popularity: (json['popularity'] as num?)?.toInt(),
);

Map<String, dynamic> _$ArtistToJson(_Artist instance) => <String, dynamic>{
  'spotifyId': instance.spotifyId,
  'name': instance.name,
  'imageUrl': instance.imageUrl,
  'imageSmall': instance.imageSmall,
  'followers': instance.followers,
  'popularity': instance.popularity,
};
