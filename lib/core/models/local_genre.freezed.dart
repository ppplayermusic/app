// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'local_genre.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LocalGenre {

 String get name; int get trackCount;
/// Create a copy of LocalGenre
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocalGenreCopyWith<LocalGenre> get copyWith => _$LocalGenreCopyWithImpl<LocalGenre>(this as LocalGenre, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocalGenre&&(identical(other.name, name) || other.name == name)&&(identical(other.trackCount, trackCount) || other.trackCount == trackCount));
}


@override
int get hashCode => Object.hash(runtimeType,name,trackCount);

@override
String toString() {
  return 'LocalGenre(name: $name, trackCount: $trackCount)';
}


}

/// @nodoc
abstract mixin class $LocalGenreCopyWith<$Res>  {
  factory $LocalGenreCopyWith(LocalGenre value, $Res Function(LocalGenre) _then) = _$LocalGenreCopyWithImpl;
@useResult
$Res call({
 String name, int trackCount
});




}
/// @nodoc
class _$LocalGenreCopyWithImpl<$Res>
    implements $LocalGenreCopyWith<$Res> {
  _$LocalGenreCopyWithImpl(this._self, this._then);

  final LocalGenre _self;
  final $Res Function(LocalGenre) _then;

/// Create a copy of LocalGenre
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? trackCount = null,}) {
  return _then(LocalGenre(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,trackCount: null == trackCount ? _self.trackCount : trackCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LocalGenre].
extension LocalGenrePatterns on LocalGenre {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LocalGenre value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LocalGenre() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LocalGenre value)  $default,){
final _that = this;
switch (_that) {
case _LocalGenre():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LocalGenre value)?  $default,){
final _that = this;
switch (_that) {
case _LocalGenre() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  int trackCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LocalGenre() when $default != null:
return $default(_that.name,_that.trackCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  int trackCount)  $default,) {final _that = this;
switch (_that) {
case _LocalGenre():
return $default(_that.name,_that.trackCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  int trackCount)?  $default,) {final _that = this;
switch (_that) {
case _LocalGenre() when $default != null:
return $default(_that.name,_that.trackCount);case _:
  return null;

}
}

}

/// @nodoc


class _LocalGenre implements LocalGenre {
  const _LocalGenre({required this.name, this.trackCount = 0});
  

@override final  String name;
@override@JsonKey() final  int trackCount;

/// Create a copy of LocalGenre
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocalGenreCopyWith<_LocalGenre> get copyWith => __$LocalGenreCopyWithImpl<_LocalGenre>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LocalGenre&&(identical(other.name, name) || other.name == name)&&(identical(other.trackCount, trackCount) || other.trackCount == trackCount));
}


@override
int get hashCode => Object.hash(runtimeType,name,trackCount);

@override
String toString() {
  return 'LocalGenre(name: $name, trackCount: $trackCount)';
}


}

/// @nodoc
abstract mixin class _$LocalGenreCopyWith<$Res> implements $LocalGenreCopyWith<$Res> {
  factory _$LocalGenreCopyWith(_LocalGenre value, $Res Function(_LocalGenre) _then) = __$LocalGenreCopyWithImpl;
@override @useResult
$Res call({
 String name, int trackCount
});




}
/// @nodoc
class __$LocalGenreCopyWithImpl<$Res>
    implements _$LocalGenreCopyWith<$Res> {
  __$LocalGenreCopyWithImpl(this._self, this._then);

  final _LocalGenre _self;
  final $Res Function(_LocalGenre) _then;

/// Create a copy of LocalGenre
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? trackCount = null,}) {
  return _then(_LocalGenre(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,trackCount: null == trackCount ? _self.trackCount : trackCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
