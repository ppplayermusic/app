// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'local_album.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LocalAlbum {

 String get albumGroupKey; String get title; String? get artist; String? get artworkPath; int get trackCount; int? get releaseYear;
/// Create a copy of LocalAlbum
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocalAlbumCopyWith<LocalAlbum> get copyWith => _$LocalAlbumCopyWithImpl<LocalAlbum>(this as LocalAlbum, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocalAlbum&&(identical(other.albumGroupKey, albumGroupKey) || other.albumGroupKey == albumGroupKey)&&(identical(other.title, title) || other.title == title)&&(identical(other.artist, artist) || other.artist == artist)&&(identical(other.artworkPath, artworkPath) || other.artworkPath == artworkPath)&&(identical(other.trackCount, trackCount) || other.trackCount == trackCount)&&(identical(other.releaseYear, releaseYear) || other.releaseYear == releaseYear));
}


@override
int get hashCode => Object.hash(runtimeType,albumGroupKey,title,artist,artworkPath,trackCount,releaseYear);

@override
String toString() {
  return 'LocalAlbum(albumGroupKey: $albumGroupKey, title: $title, artist: $artist, artworkPath: $artworkPath, trackCount: $trackCount, releaseYear: $releaseYear)';
}


}

/// @nodoc
abstract mixin class $LocalAlbumCopyWith<$Res>  {
  factory $LocalAlbumCopyWith(LocalAlbum value, $Res Function(LocalAlbum) _then) = _$LocalAlbumCopyWithImpl;
@useResult
$Res call({
 String albumGroupKey, String title, String? artist, String? artworkPath, int trackCount, int? releaseYear
});




}
/// @nodoc
class _$LocalAlbumCopyWithImpl<$Res>
    implements $LocalAlbumCopyWith<$Res> {
  _$LocalAlbumCopyWithImpl(this._self, this._then);

  final LocalAlbum _self;
  final $Res Function(LocalAlbum) _then;

/// Create a copy of LocalAlbum
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? albumGroupKey = null,Object? title = null,Object? artist = freezed,Object? artworkPath = freezed,Object? trackCount = null,Object? releaseYear = freezed,}) {
  return _then(LocalAlbum(
albumGroupKey: null == albumGroupKey ? _self.albumGroupKey : albumGroupKey // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,artist: freezed == artist ? _self.artist : artist // ignore: cast_nullable_to_non_nullable
as String?,artworkPath: freezed == artworkPath ? _self.artworkPath : artworkPath // ignore: cast_nullable_to_non_nullable
as String?,trackCount: null == trackCount ? _self.trackCount : trackCount // ignore: cast_nullable_to_non_nullable
as int,releaseYear: freezed == releaseYear ? _self.releaseYear : releaseYear // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [LocalAlbum].
extension LocalAlbumPatterns on LocalAlbum {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LocalAlbum value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LocalAlbum() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LocalAlbum value)  $default,){
final _that = this;
switch (_that) {
case _LocalAlbum():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LocalAlbum value)?  $default,){
final _that = this;
switch (_that) {
case _LocalAlbum() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String albumGroupKey,  String title,  String? artist,  String? artworkPath,  int trackCount,  int? releaseYear)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LocalAlbum() when $default != null:
return $default(_that.albumGroupKey,_that.title,_that.artist,_that.artworkPath,_that.trackCount,_that.releaseYear);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String albumGroupKey,  String title,  String? artist,  String? artworkPath,  int trackCount,  int? releaseYear)  $default,) {final _that = this;
switch (_that) {
case _LocalAlbum():
return $default(_that.albumGroupKey,_that.title,_that.artist,_that.artworkPath,_that.trackCount,_that.releaseYear);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String albumGroupKey,  String title,  String? artist,  String? artworkPath,  int trackCount,  int? releaseYear)?  $default,) {final _that = this;
switch (_that) {
case _LocalAlbum() when $default != null:
return $default(_that.albumGroupKey,_that.title,_that.artist,_that.artworkPath,_that.trackCount,_that.releaseYear);case _:
  return null;

}
}

}

/// @nodoc


class _LocalAlbum implements LocalAlbum {
  const _LocalAlbum({required this.albumGroupKey, required this.title, this.artist, this.artworkPath, this.trackCount = 0, this.releaseYear});
  

@override final  String albumGroupKey;
@override final  String title;
@override final  String? artist;
@override final  String? artworkPath;
@override@JsonKey() final  int trackCount;
@override final  int? releaseYear;

/// Create a copy of LocalAlbum
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocalAlbumCopyWith<_LocalAlbum> get copyWith => __$LocalAlbumCopyWithImpl<_LocalAlbum>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LocalAlbum&&(identical(other.albumGroupKey, albumGroupKey) || other.albumGroupKey == albumGroupKey)&&(identical(other.title, title) || other.title == title)&&(identical(other.artist, artist) || other.artist == artist)&&(identical(other.artworkPath, artworkPath) || other.artworkPath == artworkPath)&&(identical(other.trackCount, trackCount) || other.trackCount == trackCount)&&(identical(other.releaseYear, releaseYear) || other.releaseYear == releaseYear));
}


@override
int get hashCode => Object.hash(runtimeType,albumGroupKey,title,artist,artworkPath,trackCount,releaseYear);

@override
String toString() {
  return 'LocalAlbum(albumGroupKey: $albumGroupKey, title: $title, artist: $artist, artworkPath: $artworkPath, trackCount: $trackCount, releaseYear: $releaseYear)';
}


}

/// @nodoc
abstract mixin class _$LocalAlbumCopyWith<$Res> implements $LocalAlbumCopyWith<$Res> {
  factory _$LocalAlbumCopyWith(_LocalAlbum value, $Res Function(_LocalAlbum) _then) = __$LocalAlbumCopyWithImpl;
@override @useResult
$Res call({
 String albumGroupKey, String title, String? artist, String? artworkPath, int trackCount, int? releaseYear
});




}
/// @nodoc
class __$LocalAlbumCopyWithImpl<$Res>
    implements _$LocalAlbumCopyWith<$Res> {
  __$LocalAlbumCopyWithImpl(this._self, this._then);

  final _LocalAlbum _self;
  final $Res Function(_LocalAlbum) _then;

/// Create a copy of LocalAlbum
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? albumGroupKey = null,Object? title = null,Object? artist = freezed,Object? artworkPath = freezed,Object? trackCount = null,Object? releaseYear = freezed,}) {
  return _then(_LocalAlbum(
albumGroupKey: null == albumGroupKey ? _self.albumGroupKey : albumGroupKey // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,artist: freezed == artist ? _self.artist : artist // ignore: cast_nullable_to_non_nullable
as String?,artworkPath: freezed == artworkPath ? _self.artworkPath : artworkPath // ignore: cast_nullable_to_non_nullable
as String?,trackCount: null == trackCount ? _self.trackCount : trackCount // ignore: cast_nullable_to_non_nullable
as int,releaseYear: freezed == releaseYear ? _self.releaseYear : releaseYear // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
