// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'local_artist.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LocalArtist {

 String get name; int get trackCount; int get albumCount; String? get fallbackArtworkPath;
/// Create a copy of LocalArtist
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocalArtistCopyWith<LocalArtist> get copyWith => _$LocalArtistCopyWithImpl<LocalArtist>(this as LocalArtist, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocalArtist&&(identical(other.name, name) || other.name == name)&&(identical(other.trackCount, trackCount) || other.trackCount == trackCount)&&(identical(other.albumCount, albumCount) || other.albumCount == albumCount)&&(identical(other.fallbackArtworkPath, fallbackArtworkPath) || other.fallbackArtworkPath == fallbackArtworkPath));
}


@override
int get hashCode => Object.hash(runtimeType,name,trackCount,albumCount,fallbackArtworkPath);

@override
String toString() {
  return 'LocalArtist(name: $name, trackCount: $trackCount, albumCount: $albumCount, fallbackArtworkPath: $fallbackArtworkPath)';
}


}

/// @nodoc
abstract mixin class $LocalArtistCopyWith<$Res>  {
  factory $LocalArtistCopyWith(LocalArtist value, $Res Function(LocalArtist) _then) = _$LocalArtistCopyWithImpl;
@useResult
$Res call({
 String name, int trackCount, int albumCount, String? fallbackArtworkPath
});




}
/// @nodoc
class _$LocalArtistCopyWithImpl<$Res>
    implements $LocalArtistCopyWith<$Res> {
  _$LocalArtistCopyWithImpl(this._self, this._then);

  final LocalArtist _self;
  final $Res Function(LocalArtist) _then;

/// Create a copy of LocalArtist
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? trackCount = null,Object? albumCount = null,Object? fallbackArtworkPath = freezed,}) {
  return _then(LocalArtist(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,trackCount: null == trackCount ? _self.trackCount : trackCount // ignore: cast_nullable_to_non_nullable
as int,albumCount: null == albumCount ? _self.albumCount : albumCount // ignore: cast_nullable_to_non_nullable
as int,fallbackArtworkPath: freezed == fallbackArtworkPath ? _self.fallbackArtworkPath : fallbackArtworkPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LocalArtist].
extension LocalArtistPatterns on LocalArtist {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LocalArtist value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LocalArtist() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LocalArtist value)  $default,){
final _that = this;
switch (_that) {
case _LocalArtist():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LocalArtist value)?  $default,){
final _that = this;
switch (_that) {
case _LocalArtist() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  int trackCount,  int albumCount,  String? fallbackArtworkPath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LocalArtist() when $default != null:
return $default(_that.name,_that.trackCount,_that.albumCount,_that.fallbackArtworkPath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  int trackCount,  int albumCount,  String? fallbackArtworkPath)  $default,) {final _that = this;
switch (_that) {
case _LocalArtist():
return $default(_that.name,_that.trackCount,_that.albumCount,_that.fallbackArtworkPath);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  int trackCount,  int albumCount,  String? fallbackArtworkPath)?  $default,) {final _that = this;
switch (_that) {
case _LocalArtist() when $default != null:
return $default(_that.name,_that.trackCount,_that.albumCount,_that.fallbackArtworkPath);case _:
  return null;

}
}

}

/// @nodoc


class _LocalArtist implements LocalArtist {
  const _LocalArtist({required this.name, this.trackCount = 0, this.albumCount = 0, this.fallbackArtworkPath});
  

@override final  String name;
@override@JsonKey() final  int trackCount;
@override@JsonKey() final  int albumCount;
@override final  String? fallbackArtworkPath;

/// Create a copy of LocalArtist
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocalArtistCopyWith<_LocalArtist> get copyWith => __$LocalArtistCopyWithImpl<_LocalArtist>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LocalArtist&&(identical(other.name, name) || other.name == name)&&(identical(other.trackCount, trackCount) || other.trackCount == trackCount)&&(identical(other.albumCount, albumCount) || other.albumCount == albumCount)&&(identical(other.fallbackArtworkPath, fallbackArtworkPath) || other.fallbackArtworkPath == fallbackArtworkPath));
}


@override
int get hashCode => Object.hash(runtimeType,name,trackCount,albumCount,fallbackArtworkPath);

@override
String toString() {
  return 'LocalArtist(name: $name, trackCount: $trackCount, albumCount: $albumCount, fallbackArtworkPath: $fallbackArtworkPath)';
}


}

/// @nodoc
abstract mixin class _$LocalArtistCopyWith<$Res> implements $LocalArtistCopyWith<$Res> {
  factory _$LocalArtistCopyWith(_LocalArtist value, $Res Function(_LocalArtist) _then) = __$LocalArtistCopyWithImpl;
@override @useResult
$Res call({
 String name, int trackCount, int albumCount, String? fallbackArtworkPath
});




}
/// @nodoc
class __$LocalArtistCopyWithImpl<$Res>
    implements _$LocalArtistCopyWith<$Res> {
  __$LocalArtistCopyWithImpl(this._self, this._then);

  final _LocalArtist _self;
  final $Res Function(_LocalArtist) _then;

/// Create a copy of LocalArtist
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? trackCount = null,Object? albumCount = null,Object? fallbackArtworkPath = freezed,}) {
  return _then(_LocalArtist(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,trackCount: null == trackCount ? _self.trackCount : trackCount // ignore: cast_nullable_to_non_nullable
as int,albumCount: null == albumCount ? _self.albumCount : albumCount // ignore: cast_nullable_to_non_nullable
as int,fallbackArtworkPath: freezed == fallbackArtworkPath ? _self.fallbackArtworkPath : fallbackArtworkPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
