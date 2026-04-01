// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'artist.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Artist _$ArtistFromJson(Map<String, dynamic> json) {
  return _Artist.fromJson(json);
}

/// @nodoc
mixin _$Artist {
  String get spotifyId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get imageSmall => throw _privateConstructorUsedError;
  int? get followers => throw _privateConstructorUsedError;
  int? get popularity => throw _privateConstructorUsedError;

  /// Serializes this Artist to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Artist
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ArtistCopyWith<Artist> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ArtistCopyWith<$Res> {
  factory $ArtistCopyWith(Artist value, $Res Function(Artist) then) =
      _$ArtistCopyWithImpl<$Res, Artist>;
  @useResult
  $Res call({
    String spotifyId,
    String name,
    String? imageUrl,
    String? imageSmall,
    int? followers,
    int? popularity,
  });
}

/// @nodoc
class _$ArtistCopyWithImpl<$Res, $Val extends Artist>
    implements $ArtistCopyWith<$Res> {
  _$ArtistCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Artist
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? spotifyId = null,
    Object? name = null,
    Object? imageUrl = freezed,
    Object? imageSmall = freezed,
    Object? followers = freezed,
    Object? popularity = freezed,
  }) {
    return _then(
      _value.copyWith(
            spotifyId:
                null == spotifyId
                    ? _value.spotifyId
                    : spotifyId // ignore: cast_nullable_to_non_nullable
                        as String,
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
            imageUrl:
                freezed == imageUrl
                    ? _value.imageUrl
                    : imageUrl // ignore: cast_nullable_to_non_nullable
                        as String?,
            imageSmall:
                freezed == imageSmall
                    ? _value.imageSmall
                    : imageSmall // ignore: cast_nullable_to_non_nullable
                        as String?,
            followers:
                freezed == followers
                    ? _value.followers
                    : followers // ignore: cast_nullable_to_non_nullable
                        as int?,
            popularity:
                freezed == popularity
                    ? _value.popularity
                    : popularity // ignore: cast_nullable_to_non_nullable
                        as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ArtistImplCopyWith<$Res> implements $ArtistCopyWith<$Res> {
  factory _$$ArtistImplCopyWith(
    _$ArtistImpl value,
    $Res Function(_$ArtistImpl) then,
  ) = __$$ArtistImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String spotifyId,
    String name,
    String? imageUrl,
    String? imageSmall,
    int? followers,
    int? popularity,
  });
}

/// @nodoc
class __$$ArtistImplCopyWithImpl<$Res>
    extends _$ArtistCopyWithImpl<$Res, _$ArtistImpl>
    implements _$$ArtistImplCopyWith<$Res> {
  __$$ArtistImplCopyWithImpl(
    _$ArtistImpl _value,
    $Res Function(_$ArtistImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Artist
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? spotifyId = null,
    Object? name = null,
    Object? imageUrl = freezed,
    Object? imageSmall = freezed,
    Object? followers = freezed,
    Object? popularity = freezed,
  }) {
    return _then(
      _$ArtistImpl(
        spotifyId:
            null == spotifyId
                ? _value.spotifyId
                : spotifyId // ignore: cast_nullable_to_non_nullable
                    as String,
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String,
        imageUrl:
            freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                    as String?,
        imageSmall:
            freezed == imageSmall
                ? _value.imageSmall
                : imageSmall // ignore: cast_nullable_to_non_nullable
                    as String?,
        followers:
            freezed == followers
                ? _value.followers
                : followers // ignore: cast_nullable_to_non_nullable
                    as int?,
        popularity:
            freezed == popularity
                ? _value.popularity
                : popularity // ignore: cast_nullable_to_non_nullable
                    as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ArtistImpl implements _Artist {
  const _$ArtistImpl({
    required this.spotifyId,
    required this.name,
    this.imageUrl,
    this.imageSmall,
    this.followers,
    this.popularity,
  });

  factory _$ArtistImpl.fromJson(Map<String, dynamic> json) =>
      _$$ArtistImplFromJson(json);

  @override
  final String spotifyId;
  @override
  final String name;
  @override
  final String? imageUrl;
  @override
  final String? imageSmall;
  @override
  final int? followers;
  @override
  final int? popularity;

  @override
  String toString() {
    return 'Artist(spotifyId: $spotifyId, name: $name, imageUrl: $imageUrl, imageSmall: $imageSmall, followers: $followers, popularity: $popularity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ArtistImpl &&
            (identical(other.spotifyId, spotifyId) ||
                other.spotifyId == spotifyId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.imageSmall, imageSmall) ||
                other.imageSmall == imageSmall) &&
            (identical(other.followers, followers) ||
                other.followers == followers) &&
            (identical(other.popularity, popularity) ||
                other.popularity == popularity));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    spotifyId,
    name,
    imageUrl,
    imageSmall,
    followers,
    popularity,
  );

  /// Create a copy of Artist
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ArtistImplCopyWith<_$ArtistImpl> get copyWith =>
      __$$ArtistImplCopyWithImpl<_$ArtistImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ArtistImplToJson(this);
  }
}

abstract class _Artist implements Artist {
  const factory _Artist({
    required final String spotifyId,
    required final String name,
    final String? imageUrl,
    final String? imageSmall,
    final int? followers,
    final int? popularity,
  }) = _$ArtistImpl;

  factory _Artist.fromJson(Map<String, dynamic> json) = _$ArtistImpl.fromJson;

  @override
  String get spotifyId;
  @override
  String get name;
  @override
  String? get imageUrl;
  @override
  String? get imageSmall;
  @override
  int? get followers;
  @override
  int? get popularity;

  /// Create a copy of Artist
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ArtistImplCopyWith<_$ArtistImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
