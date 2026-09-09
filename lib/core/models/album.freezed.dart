// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'album.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Album {

 String get spotifyId; String get name; String get artistId; String get artistName; String? get imageUrl; String? get releaseDate; int? get totalTracks;
/// Create a copy of Album
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlbumCopyWith<Album> get copyWith => _$AlbumCopyWithImpl<Album>(this as Album, _$identity);

  /// Serializes this Album to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Album&&(identical(other.spotifyId, spotifyId) || other.spotifyId == spotifyId)&&(identical(other.name, name) || other.name == name)&&(identical(other.artistId, artistId) || other.artistId == artistId)&&(identical(other.artistName, artistName) || other.artistName == artistName)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate)&&(identical(other.totalTracks, totalTracks) || other.totalTracks == totalTracks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,spotifyId,name,artistId,artistName,imageUrl,releaseDate,totalTracks);

@override
String toString() {
  return 'Album(spotifyId: $spotifyId, name: $name, artistId: $artistId, artistName: $artistName, imageUrl: $imageUrl, releaseDate: $releaseDate, totalTracks: $totalTracks)';
}


}

/// @nodoc
abstract mixin class $AlbumCopyWith<$Res>  {
  factory $AlbumCopyWith(Album value, $Res Function(Album) _then) = _$AlbumCopyWithImpl;
@useResult
$Res call({
 String spotifyId, String name, String artistId, String artistName, String? imageUrl, String? releaseDate, int? totalTracks
});




}
/// @nodoc
class _$AlbumCopyWithImpl<$Res>
    implements $AlbumCopyWith<$Res> {
  _$AlbumCopyWithImpl(this._self, this._then);

  final Album _self;
  final $Res Function(Album) _then;

/// Create a copy of Album
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? spotifyId = null,Object? name = null,Object? artistId = null,Object? artistName = null,Object? imageUrl = freezed,Object? releaseDate = freezed,Object? totalTracks = freezed,}) {
  return _then(Album(
spotifyId: null == spotifyId ? _self.spotifyId : spotifyId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,artistId: null == artistId ? _self.artistId : artistId // ignore: cast_nullable_to_non_nullable
as String,artistName: null == artistName ? _self.artistName : artistName // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,releaseDate: freezed == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as String?,totalTracks: freezed == totalTracks ? _self.totalTracks : totalTracks // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [Album].
extension AlbumPatterns on Album {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Album value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Album() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Album value)  $default,){
final _that = this;
switch (_that) {
case _Album():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Album value)?  $default,){
final _that = this;
switch (_that) {
case _Album() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String spotifyId,  String name,  String artistId,  String artistName,  String? imageUrl,  String? releaseDate,  int? totalTracks)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Album() when $default != null:
return $default(_that.spotifyId,_that.name,_that.artistId,_that.artistName,_that.imageUrl,_that.releaseDate,_that.totalTracks);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String spotifyId,  String name,  String artistId,  String artistName,  String? imageUrl,  String? releaseDate,  int? totalTracks)  $default,) {final _that = this;
switch (_that) {
case _Album():
return $default(_that.spotifyId,_that.name,_that.artistId,_that.artistName,_that.imageUrl,_that.releaseDate,_that.totalTracks);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String spotifyId,  String name,  String artistId,  String artistName,  String? imageUrl,  String? releaseDate,  int? totalTracks)?  $default,) {final _that = this;
switch (_that) {
case _Album() when $default != null:
return $default(_that.spotifyId,_that.name,_that.artistId,_that.artistName,_that.imageUrl,_that.releaseDate,_that.totalTracks);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Album implements Album {
  const _Album({required this.spotifyId, required this.name, required this.artistId, required this.artistName, this.imageUrl, this.releaseDate, this.totalTracks});
  factory _Album.fromJson(Map<String, dynamic> json) => _$AlbumFromJson(json);

@override final  String spotifyId;
@override final  String name;
@override final  String artistId;
@override final  String artistName;
@override final  String? imageUrl;
@override final  String? releaseDate;
@override final  int? totalTracks;

/// Create a copy of Album
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlbumCopyWith<_Album> get copyWith => __$AlbumCopyWithImpl<_Album>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AlbumToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Album&&(identical(other.spotifyId, spotifyId) || other.spotifyId == spotifyId)&&(identical(other.name, name) || other.name == name)&&(identical(other.artistId, artistId) || other.artistId == artistId)&&(identical(other.artistName, artistName) || other.artistName == artistName)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate)&&(identical(other.totalTracks, totalTracks) || other.totalTracks == totalTracks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,spotifyId,name,artistId,artistName,imageUrl,releaseDate,totalTracks);

@override
String toString() {
  return 'Album(spotifyId: $spotifyId, name: $name, artistId: $artistId, artistName: $artistName, imageUrl: $imageUrl, releaseDate: $releaseDate, totalTracks: $totalTracks)';
}


}

/// @nodoc
abstract mixin class _$AlbumCopyWith<$Res> implements $AlbumCopyWith<$Res> {
  factory _$AlbumCopyWith(_Album value, $Res Function(_Album) _then) = __$AlbumCopyWithImpl;
@override @useResult
$Res call({
 String spotifyId, String name, String artistId, String artistName, String? imageUrl, String? releaseDate, int? totalTracks
});




}
/// @nodoc
class __$AlbumCopyWithImpl<$Res>
    implements _$AlbumCopyWith<$Res> {
  __$AlbumCopyWithImpl(this._self, this._then);

  final _Album _self;
  final $Res Function(_Album) _then;

/// Create a copy of Album
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? spotifyId = null,Object? name = null,Object? artistId = null,Object? artistName = null,Object? imageUrl = freezed,Object? releaseDate = freezed,Object? totalTracks = freezed,}) {
  return _then(_Album(
spotifyId: null == spotifyId ? _self.spotifyId : spotifyId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,artistId: null == artistId ? _self.artistId : artistId // ignore: cast_nullable_to_non_nullable
as String,artistName: null == artistName ? _self.artistName : artistName // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,releaseDate: freezed == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as String?,totalTracks: freezed == totalTracks ? _self.totalTracks : totalTracks // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
