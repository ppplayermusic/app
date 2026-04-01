// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ArtistImpl _$$ArtistImplFromJson(Map<String, dynamic> json) => _$ArtistImpl(
  spotifyId: json['spotifyId'] as String,
  name: json['name'] as String,
  imageUrl: json['imageUrl'] as String?,
  imageSmall: json['imageSmall'] as String?,
  followers: (json['followers'] as num?)?.toInt(),
  popularity: (json['popularity'] as num?)?.toInt(),
);

Map<String, dynamic> _$$ArtistImplToJson(_$ArtistImpl instance) =>
    <String, dynamic>{
      'spotifyId': instance.spotifyId,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'imageSmall': instance.imageSmall,
      'followers': instance.followers,
      'popularity': instance.popularity,
    };
