// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'local_folder.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LocalFolder {

 String get path; String get name; int get trackCount; int get subfolderCount;
/// Create a copy of LocalFolder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocalFolderCopyWith<LocalFolder> get copyWith => _$LocalFolderCopyWithImpl<LocalFolder>(this as LocalFolder, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocalFolder&&(identical(other.path, path) || other.path == path)&&(identical(other.name, name) || other.name == name)&&(identical(other.trackCount, trackCount) || other.trackCount == trackCount)&&(identical(other.subfolderCount, subfolderCount) || other.subfolderCount == subfolderCount));
}


@override
int get hashCode => Object.hash(runtimeType,path,name,trackCount,subfolderCount);

@override
String toString() {
  return 'LocalFolder(path: $path, name: $name, trackCount: $trackCount, subfolderCount: $subfolderCount)';
}


}

/// @nodoc
abstract mixin class $LocalFolderCopyWith<$Res>  {
  factory $LocalFolderCopyWith(LocalFolder value, $Res Function(LocalFolder) _then) = _$LocalFolderCopyWithImpl;
@useResult
$Res call({
 String path, String name, int trackCount, int subfolderCount
});




}
/// @nodoc
class _$LocalFolderCopyWithImpl<$Res>
    implements $LocalFolderCopyWith<$Res> {
  _$LocalFolderCopyWithImpl(this._self, this._then);

  final LocalFolder _self;
  final $Res Function(LocalFolder) _then;

/// Create a copy of LocalFolder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? path = null,Object? name = null,Object? trackCount = null,Object? subfolderCount = null,}) {
  return _then(LocalFolder(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,trackCount: null == trackCount ? _self.trackCount : trackCount // ignore: cast_nullable_to_non_nullable
as int,subfolderCount: null == subfolderCount ? _self.subfolderCount : subfolderCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LocalFolder].
extension LocalFolderPatterns on LocalFolder {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LocalFolder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LocalFolder() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LocalFolder value)  $default,){
final _that = this;
switch (_that) {
case _LocalFolder():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LocalFolder value)?  $default,){
final _that = this;
switch (_that) {
case _LocalFolder() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String path,  String name,  int trackCount,  int subfolderCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LocalFolder() when $default != null:
return $default(_that.path,_that.name,_that.trackCount,_that.subfolderCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String path,  String name,  int trackCount,  int subfolderCount)  $default,) {final _that = this;
switch (_that) {
case _LocalFolder():
return $default(_that.path,_that.name,_that.trackCount,_that.subfolderCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String path,  String name,  int trackCount,  int subfolderCount)?  $default,) {final _that = this;
switch (_that) {
case _LocalFolder() when $default != null:
return $default(_that.path,_that.name,_that.trackCount,_that.subfolderCount);case _:
  return null;

}
}

}

/// @nodoc


class _LocalFolder implements LocalFolder {
  const _LocalFolder({required this.path, required this.name, this.trackCount = 0, this.subfolderCount = 0});
  

@override final  String path;
@override final  String name;
@override@JsonKey() final  int trackCount;
@override@JsonKey() final  int subfolderCount;

/// Create a copy of LocalFolder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocalFolderCopyWith<_LocalFolder> get copyWith => __$LocalFolderCopyWithImpl<_LocalFolder>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LocalFolder&&(identical(other.path, path) || other.path == path)&&(identical(other.name, name) || other.name == name)&&(identical(other.trackCount, trackCount) || other.trackCount == trackCount)&&(identical(other.subfolderCount, subfolderCount) || other.subfolderCount == subfolderCount));
}


@override
int get hashCode => Object.hash(runtimeType,path,name,trackCount,subfolderCount);

@override
String toString() {
  return 'LocalFolder(path: $path, name: $name, trackCount: $trackCount, subfolderCount: $subfolderCount)';
}


}

/// @nodoc
abstract mixin class _$LocalFolderCopyWith<$Res> implements $LocalFolderCopyWith<$Res> {
  factory _$LocalFolderCopyWith(_LocalFolder value, $Res Function(_LocalFolder) _then) = __$LocalFolderCopyWithImpl;
@override @useResult
$Res call({
 String path, String name, int trackCount, int subfolderCount
});




}
/// @nodoc
class __$LocalFolderCopyWithImpl<$Res>
    implements _$LocalFolderCopyWith<$Res> {
  __$LocalFolderCopyWithImpl(this._self, this._then);

  final _LocalFolder _self;
  final $Res Function(_LocalFolder) _then;

/// Create a copy of LocalFolder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? path = null,Object? name = null,Object? trackCount = null,Object? subfolderCount = null,}) {
  return _then(_LocalFolder(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,trackCount: null == trackCount ? _self.trackCount : trackCount // ignore: cast_nullable_to_non_nullable
as int,subfolderCount: null == subfolderCount ? _self.subfolderCount : subfolderCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
