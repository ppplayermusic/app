// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'track.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Track {

 String get spotifyId; String get name; String get artistId; String get artistName; String? get albumId; String? get albumName; String? get albumImage; int? get durationMs; String? get youtubeVideoId; int get playCount; bool get isFavorite; String? get queueItemId; QueueItemOrigin get queueOrigin; TrackSourceType get sourceType;/// Absolute path or content URI stored by LocalFileResolver.
/// Null only when [sourceType] == TrackSourceType.online.
 String? get localFilePath;/// Local artwork absolute path (cached by MetadataExtractor).
 String? get localArtworkPath;/// 'available' | 'missing' | 'permissionRevoked' | 'decodingError'
 String get localAvailabilityStatus; String? get localAlbumGroupKey; DateTime? get localAddedAt;/// True when [VideoProbeService] confirmed a video stream in this file.
/// False for all audio-only tracks, unclassified pre-v11 rows, and
/// online tracks.
 bool get isVideoFile;/// Stream URL for network streams.
 String? get networkStreamUrl;/// Whether the network stream is explicitly flagged as a live broadcast.
 bool get isLiveStream;
/// Create a copy of Track
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrackCopyWith<Track> get copyWith => _$TrackCopyWithImpl<Track>(this as Track, _$identity);

  /// Serializes this Track to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Track&&(identical(other.spotifyId, spotifyId) || other.spotifyId == spotifyId)&&(identical(other.name, name) || other.name == name)&&(identical(other.artistId, artistId) || other.artistId == artistId)&&(identical(other.artistName, artistName) || other.artistName == artistName)&&(identical(other.albumId, albumId) || other.albumId == albumId)&&(identical(other.albumName, albumName) || other.albumName == albumName)&&(identical(other.albumImage, albumImage) || other.albumImage == albumImage)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.youtubeVideoId, youtubeVideoId) || other.youtubeVideoId == youtubeVideoId)&&(identical(other.playCount, playCount) || other.playCount == playCount)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.queueItemId, queueItemId) || other.queueItemId == queueItemId)&&(identical(other.queueOrigin, queueOrigin) || other.queueOrigin == queueOrigin)&&(identical(other.sourceType, sourceType) || other.sourceType == sourceType)&&(identical(other.localFilePath, localFilePath) || other.localFilePath == localFilePath)&&(identical(other.localArtworkPath, localArtworkPath) || other.localArtworkPath == localArtworkPath)&&(identical(other.localAvailabilityStatus, localAvailabilityStatus) || other.localAvailabilityStatus == localAvailabilityStatus)&&(identical(other.localAlbumGroupKey, localAlbumGroupKey) || other.localAlbumGroupKey == localAlbumGroupKey)&&(identical(other.localAddedAt, localAddedAt) || other.localAddedAt == localAddedAt)&&(identical(other.isVideoFile, isVideoFile) || other.isVideoFile == isVideoFile)&&(identical(other.networkStreamUrl, networkStreamUrl) || other.networkStreamUrl == networkStreamUrl)&&(identical(other.isLiveStream, isLiveStream) || other.isLiveStream == isLiveStream));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,spotifyId,name,artistId,artistName,albumId,albumName,albumImage,durationMs,youtubeVideoId,playCount,isFavorite,queueItemId,queueOrigin,sourceType,localFilePath,localArtworkPath,localAvailabilityStatus,localAlbumGroupKey,localAddedAt,isVideoFile,networkStreamUrl,isLiveStream]);

@override
String toString() {
  return 'Track(spotifyId: $spotifyId, name: $name, artistId: $artistId, artistName: $artistName, albumId: $albumId, albumName: $albumName, albumImage: $albumImage, durationMs: $durationMs, youtubeVideoId: $youtubeVideoId, playCount: $playCount, isFavorite: $isFavorite, queueItemId: $queueItemId, queueOrigin: $queueOrigin, sourceType: $sourceType, localFilePath: $localFilePath, localArtworkPath: $localArtworkPath, localAvailabilityStatus: $localAvailabilityStatus, localAlbumGroupKey: $localAlbumGroupKey, localAddedAt: $localAddedAt, isVideoFile: $isVideoFile, networkStreamUrl: $networkStreamUrl, isLiveStream: $isLiveStream)';
}


}

/// @nodoc
abstract mixin class $TrackCopyWith<$Res>  {
  factory $TrackCopyWith(Track value, $Res Function(Track) _then) = _$TrackCopyWithImpl;
@useResult
$Res call({
 String spotifyId, String name, String artistId, String artistName, String? albumId, String? albumName, String? albumImage, int? durationMs, String? youtubeVideoId, int playCount, bool isFavorite, String? queueItemId, QueueItemOrigin queueOrigin, TrackSourceType sourceType, String? localFilePath, String? localArtworkPath, String localAvailabilityStatus, String? localAlbumGroupKey, DateTime? localAddedAt, bool isVideoFile, String? networkStreamUrl, bool isLiveStream
});




}
/// @nodoc
class _$TrackCopyWithImpl<$Res>
    implements $TrackCopyWith<$Res> {
  _$TrackCopyWithImpl(this._self, this._then);

  final Track _self;
  final $Res Function(Track) _then;

/// Create a copy of Track
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? spotifyId = null,Object? name = null,Object? artistId = null,Object? artistName = null,Object? albumId = freezed,Object? albumName = freezed,Object? albumImage = freezed,Object? durationMs = freezed,Object? youtubeVideoId = freezed,Object? playCount = null,Object? isFavorite = null,Object? queueItemId = freezed,Object? queueOrigin = null,Object? sourceType = null,Object? localFilePath = freezed,Object? localArtworkPath = freezed,Object? localAvailabilityStatus = null,Object? localAlbumGroupKey = freezed,Object? localAddedAt = freezed,Object? isVideoFile = null,Object? networkStreamUrl = freezed,Object? isLiveStream = null,}) {
  return _then(Track(
spotifyId: null == spotifyId ? _self.spotifyId : spotifyId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,artistId: null == artistId ? _self.artistId : artistId // ignore: cast_nullable_to_non_nullable
as String,artistName: null == artistName ? _self.artistName : artistName // ignore: cast_nullable_to_non_nullable
as String,albumId: freezed == albumId ? _self.albumId : albumId // ignore: cast_nullable_to_non_nullable
as String?,albumName: freezed == albumName ? _self.albumName : albumName // ignore: cast_nullable_to_non_nullable
as String?,albumImage: freezed == albumImage ? _self.albumImage : albumImage // ignore: cast_nullable_to_non_nullable
as String?,durationMs: freezed == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int?,youtubeVideoId: freezed == youtubeVideoId ? _self.youtubeVideoId : youtubeVideoId // ignore: cast_nullable_to_non_nullable
as String?,playCount: null == playCount ? _self.playCount : playCount // ignore: cast_nullable_to_non_nullable
as int,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,queueItemId: freezed == queueItemId ? _self.queueItemId : queueItemId // ignore: cast_nullable_to_non_nullable
as String?,queueOrigin: null == queueOrigin ? _self.queueOrigin : queueOrigin // ignore: cast_nullable_to_non_nullable
as QueueItemOrigin,sourceType: null == sourceType ? _self.sourceType : sourceType // ignore: cast_nullable_to_non_nullable
as TrackSourceType,localFilePath: freezed == localFilePath ? _self.localFilePath : localFilePath // ignore: cast_nullable_to_non_nullable
as String?,localArtworkPath: freezed == localArtworkPath ? _self.localArtworkPath : localArtworkPath // ignore: cast_nullable_to_non_nullable
as String?,localAvailabilityStatus: null == localAvailabilityStatus ? _self.localAvailabilityStatus : localAvailabilityStatus // ignore: cast_nullable_to_non_nullable
as String,localAlbumGroupKey: freezed == localAlbumGroupKey ? _self.localAlbumGroupKey : localAlbumGroupKey // ignore: cast_nullable_to_non_nullable
as String?,localAddedAt: freezed == localAddedAt ? _self.localAddedAt : localAddedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isVideoFile: null == isVideoFile ? _self.isVideoFile : isVideoFile // ignore: cast_nullable_to_non_nullable
as bool,networkStreamUrl: freezed == networkStreamUrl ? _self.networkStreamUrl : networkStreamUrl // ignore: cast_nullable_to_non_nullable
as String?,isLiveStream: null == isLiveStream ? _self.isLiveStream : isLiveStream // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Track].
extension TrackPatterns on Track {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Track value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Track() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Track value)  $default,){
final _that = this;
switch (_that) {
case _Track():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Track value)?  $default,){
final _that = this;
switch (_that) {
case _Track() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String spotifyId,  String name,  String artistId,  String artistName,  String? albumId,  String? albumName,  String? albumImage,  int? durationMs,  String? youtubeVideoId,  int playCount,  bool isFavorite,  String? queueItemId,  QueueItemOrigin queueOrigin,  TrackSourceType sourceType,  String? localFilePath,  String? localArtworkPath,  String localAvailabilityStatus,  String? localAlbumGroupKey,  DateTime? localAddedAt,  bool isVideoFile,  String? networkStreamUrl,  bool isLiveStream)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Track() when $default != null:
return $default(_that.spotifyId,_that.name,_that.artistId,_that.artistName,_that.albumId,_that.albumName,_that.albumImage,_that.durationMs,_that.youtubeVideoId,_that.playCount,_that.isFavorite,_that.queueItemId,_that.queueOrigin,_that.sourceType,_that.localFilePath,_that.localArtworkPath,_that.localAvailabilityStatus,_that.localAlbumGroupKey,_that.localAddedAt,_that.isVideoFile,_that.networkStreamUrl,_that.isLiveStream);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String spotifyId,  String name,  String artistId,  String artistName,  String? albumId,  String? albumName,  String? albumImage,  int? durationMs,  String? youtubeVideoId,  int playCount,  bool isFavorite,  String? queueItemId,  QueueItemOrigin queueOrigin,  TrackSourceType sourceType,  String? localFilePath,  String? localArtworkPath,  String localAvailabilityStatus,  String? localAlbumGroupKey,  DateTime? localAddedAt,  bool isVideoFile,  String? networkStreamUrl,  bool isLiveStream)  $default,) {final _that = this;
switch (_that) {
case _Track():
return $default(_that.spotifyId,_that.name,_that.artistId,_that.artistName,_that.albumId,_that.albumName,_that.albumImage,_that.durationMs,_that.youtubeVideoId,_that.playCount,_that.isFavorite,_that.queueItemId,_that.queueOrigin,_that.sourceType,_that.localFilePath,_that.localArtworkPath,_that.localAvailabilityStatus,_that.localAlbumGroupKey,_that.localAddedAt,_that.isVideoFile,_that.networkStreamUrl,_that.isLiveStream);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String spotifyId,  String name,  String artistId,  String artistName,  String? albumId,  String? albumName,  String? albumImage,  int? durationMs,  String? youtubeVideoId,  int playCount,  bool isFavorite,  String? queueItemId,  QueueItemOrigin queueOrigin,  TrackSourceType sourceType,  String? localFilePath,  String? localArtworkPath,  String localAvailabilityStatus,  String? localAlbumGroupKey,  DateTime? localAddedAt,  bool isVideoFile,  String? networkStreamUrl,  bool isLiveStream)?  $default,) {final _that = this;
switch (_that) {
case _Track() when $default != null:
return $default(_that.spotifyId,_that.name,_that.artistId,_that.artistName,_that.albumId,_that.albumName,_that.albumImage,_that.durationMs,_that.youtubeVideoId,_that.playCount,_that.isFavorite,_that.queueItemId,_that.queueOrigin,_that.sourceType,_that.localFilePath,_that.localArtworkPath,_that.localAvailabilityStatus,_that.localAlbumGroupKey,_that.localAddedAt,_that.isVideoFile,_that.networkStreamUrl,_that.isLiveStream);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Track implements Track {
  const _Track({required this.spotifyId, required this.name, required this.artistId, required this.artistName, this.albumId, this.albumName, this.albumImage, this.durationMs, this.youtubeVideoId, this.playCount = 0, this.isFavorite = false, this.queueItemId, this.queueOrigin = QueueItemOrigin.context, this.sourceType = TrackSourceType.online, this.localFilePath, this.localArtworkPath, this.localAvailabilityStatus = 'available', this.localAlbumGroupKey, this.localAddedAt, this.isVideoFile = false, this.networkStreamUrl, this.isLiveStream = false});
  factory _Track.fromJson(Map<String, dynamic> json) => _$TrackFromJson(json);

@override final  String spotifyId;
@override final  String name;
@override final  String artistId;
@override final  String artistName;
@override final  String? albumId;
@override final  String? albumName;
@override final  String? albumImage;
@override final  int? durationMs;
@override final  String? youtubeVideoId;
@override@JsonKey() final  int playCount;
@override@JsonKey() final  bool isFavorite;
@override final  String? queueItemId;
@override@JsonKey() final  QueueItemOrigin queueOrigin;
@override@JsonKey() final  TrackSourceType sourceType;
/// Absolute path or content URI stored by LocalFileResolver.
/// Null only when [sourceType] == TrackSourceType.online.
@override final  String? localFilePath;
/// Local artwork absolute path (cached by MetadataExtractor).
@override final  String? localArtworkPath;
/// 'available' | 'missing' | 'permissionRevoked' | 'decodingError'
@override@JsonKey() final  String localAvailabilityStatus;
@override final  String? localAlbumGroupKey;
@override final  DateTime? localAddedAt;
/// True when [VideoProbeService] confirmed a video stream in this file.
/// False for all audio-only tracks, unclassified pre-v11 rows, and
/// online tracks.
@override@JsonKey() final  bool isVideoFile;
/// Stream URL for network streams.
@override final  String? networkStreamUrl;
/// Whether the network stream is explicitly flagged as a live broadcast.
@override@JsonKey() final  bool isLiveStream;

/// Create a copy of Track
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrackCopyWith<_Track> get copyWith => __$TrackCopyWithImpl<_Track>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TrackToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Track&&(identical(other.spotifyId, spotifyId) || other.spotifyId == spotifyId)&&(identical(other.name, name) || other.name == name)&&(identical(other.artistId, artistId) || other.artistId == artistId)&&(identical(other.artistName, artistName) || other.artistName == artistName)&&(identical(other.albumId, albumId) || other.albumId == albumId)&&(identical(other.albumName, albumName) || other.albumName == albumName)&&(identical(other.albumImage, albumImage) || other.albumImage == albumImage)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.youtubeVideoId, youtubeVideoId) || other.youtubeVideoId == youtubeVideoId)&&(identical(other.playCount, playCount) || other.playCount == playCount)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.queueItemId, queueItemId) || other.queueItemId == queueItemId)&&(identical(other.queueOrigin, queueOrigin) || other.queueOrigin == queueOrigin)&&(identical(other.sourceType, sourceType) || other.sourceType == sourceType)&&(identical(other.localFilePath, localFilePath) || other.localFilePath == localFilePath)&&(identical(other.localArtworkPath, localArtworkPath) || other.localArtworkPath == localArtworkPath)&&(identical(other.localAvailabilityStatus, localAvailabilityStatus) || other.localAvailabilityStatus == localAvailabilityStatus)&&(identical(other.localAlbumGroupKey, localAlbumGroupKey) || other.localAlbumGroupKey == localAlbumGroupKey)&&(identical(other.localAddedAt, localAddedAt) || other.localAddedAt == localAddedAt)&&(identical(other.isVideoFile, isVideoFile) || other.isVideoFile == isVideoFile)&&(identical(other.networkStreamUrl, networkStreamUrl) || other.networkStreamUrl == networkStreamUrl)&&(identical(other.isLiveStream, isLiveStream) || other.isLiveStream == isLiveStream));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,spotifyId,name,artistId,artistName,albumId,albumName,albumImage,durationMs,youtubeVideoId,playCount,isFavorite,queueItemId,queueOrigin,sourceType,localFilePath,localArtworkPath,localAvailabilityStatus,localAlbumGroupKey,localAddedAt,isVideoFile,networkStreamUrl,isLiveStream]);

@override
String toString() {
  return 'Track(spotifyId: $spotifyId, name: $name, artistId: $artistId, artistName: $artistName, albumId: $albumId, albumName: $albumName, albumImage: $albumImage, durationMs: $durationMs, youtubeVideoId: $youtubeVideoId, playCount: $playCount, isFavorite: $isFavorite, queueItemId: $queueItemId, queueOrigin: $queueOrigin, sourceType: $sourceType, localFilePath: $localFilePath, localArtworkPath: $localArtworkPath, localAvailabilityStatus: $localAvailabilityStatus, localAlbumGroupKey: $localAlbumGroupKey, localAddedAt: $localAddedAt, isVideoFile: $isVideoFile, networkStreamUrl: $networkStreamUrl, isLiveStream: $isLiveStream)';
}


}

/// @nodoc
abstract mixin class _$TrackCopyWith<$Res> implements $TrackCopyWith<$Res> {
  factory _$TrackCopyWith(_Track value, $Res Function(_Track) _then) = __$TrackCopyWithImpl;
@override @useResult
$Res call({
 String spotifyId, String name, String artistId, String artistName, String? albumId, String? albumName, String? albumImage, int? durationMs, String? youtubeVideoId, int playCount, bool isFavorite, String? queueItemId, QueueItemOrigin queueOrigin, TrackSourceType sourceType, String? localFilePath, String? localArtworkPath, String localAvailabilityStatus, String? localAlbumGroupKey, DateTime? localAddedAt, bool isVideoFile, String? networkStreamUrl, bool isLiveStream
});




}
/// @nodoc
class __$TrackCopyWithImpl<$Res>
    implements _$TrackCopyWith<$Res> {
  __$TrackCopyWithImpl(this._self, this._then);

  final _Track _self;
  final $Res Function(_Track) _then;

/// Create a copy of Track
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? spotifyId = null,Object? name = null,Object? artistId = null,Object? artistName = null,Object? albumId = freezed,Object? albumName = freezed,Object? albumImage = freezed,Object? durationMs = freezed,Object? youtubeVideoId = freezed,Object? playCount = null,Object? isFavorite = null,Object? queueItemId = freezed,Object? queueOrigin = null,Object? sourceType = null,Object? localFilePath = freezed,Object? localArtworkPath = freezed,Object? localAvailabilityStatus = null,Object? localAlbumGroupKey = freezed,Object? localAddedAt = freezed,Object? isVideoFile = null,Object? networkStreamUrl = freezed,Object? isLiveStream = null,}) {
  return _then(_Track(
spotifyId: null == spotifyId ? _self.spotifyId : spotifyId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,artistId: null == artistId ? _self.artistId : artistId // ignore: cast_nullable_to_non_nullable
as String,artistName: null == artistName ? _self.artistName : artistName // ignore: cast_nullable_to_non_nullable
as String,albumId: freezed == albumId ? _self.albumId : albumId // ignore: cast_nullable_to_non_nullable
as String?,albumName: freezed == albumName ? _self.albumName : albumName // ignore: cast_nullable_to_non_nullable
as String?,albumImage: freezed == albumImage ? _self.albumImage : albumImage // ignore: cast_nullable_to_non_nullable
as String?,durationMs: freezed == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int?,youtubeVideoId: freezed == youtubeVideoId ? _self.youtubeVideoId : youtubeVideoId // ignore: cast_nullable_to_non_nullable
as String?,playCount: null == playCount ? _self.playCount : playCount // ignore: cast_nullable_to_non_nullable
as int,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,queueItemId: freezed == queueItemId ? _self.queueItemId : queueItemId // ignore: cast_nullable_to_non_nullable
as String?,queueOrigin: null == queueOrigin ? _self.queueOrigin : queueOrigin // ignore: cast_nullable_to_non_nullable
as QueueItemOrigin,sourceType: null == sourceType ? _self.sourceType : sourceType // ignore: cast_nullable_to_non_nullable
as TrackSourceType,localFilePath: freezed == localFilePath ? _self.localFilePath : localFilePath // ignore: cast_nullable_to_non_nullable
as String?,localArtworkPath: freezed == localArtworkPath ? _self.localArtworkPath : localArtworkPath // ignore: cast_nullable_to_non_nullable
as String?,localAvailabilityStatus: null == localAvailabilityStatus ? _self.localAvailabilityStatus : localAvailabilityStatus // ignore: cast_nullable_to_non_nullable
as String,localAlbumGroupKey: freezed == localAlbumGroupKey ? _self.localAlbumGroupKey : localAlbumGroupKey // ignore: cast_nullable_to_non_nullable
as String?,localAddedAt: freezed == localAddedAt ? _self.localAddedAt : localAddedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isVideoFile: null == isVideoFile ? _self.isVideoFile : isVideoFile // ignore: cast_nullable_to_non_nullable
as bool,networkStreamUrl: freezed == networkStreamUrl ? _self.networkStreamUrl : networkStreamUrl // ignore: cast_nullable_to_non_nullable
as String?,isLiveStream: null == isLiveStream ? _self.isLiveStream : isLiveStream // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
