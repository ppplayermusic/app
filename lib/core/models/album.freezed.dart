// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'album.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Album _$AlbumFromJson(Map<String, dynamic> json) {
  return _Album.fromJson(json);
}

/// @nodoc
mixin _$Album {
  String get spotifyId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get artistId => throw _privateConstructorUsedError;
  String get artistName => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get releaseDate => throw _privateConstructorUsedError;
  int? get totalTracks => throw _privateConstructorUsedError;

  /// Serializes this Album to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Album
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AlbumCopyWith<Album> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlbumCopyWith<$Res> {
  factory $AlbumCopyWith(Album value, $Res Function(Album) then) =
      _$AlbumCopyWithImpl<$Res, Album>;
  @useResult
  $Res call({
    String spotifyId,
    String name,
    String artistId,
    String artistName,
    String? imageUrl,
    String? releaseDate,
    int? totalTracks,
  });
}

/// @nodoc
class _$AlbumCopyWithImpl<$Res, $Val extends Album>
    implements $AlbumCopyWith<$Res> {
  _$AlbumCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Album
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? spotifyId = null,
    Object? name = null,
    Object? artistId = null,
    Object? artistName = null,
    Object? imageUrl = freezed,
    Object? releaseDate = freezed,
    Object? totalTracks = freezed,
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
            artistId:
                null == artistId
                    ? _value.artistId
                    : artistId // ignore: cast_nullable_to_non_nullable
                        as String,
            artistName:
                null == artistName
                    ? _value.artistName
                    : artistName // ignore: cast_nullable_to_non_nullable
                        as String,
            imageUrl:
                freezed == imageUrl
                    ? _value.imageUrl
                    : imageUrl // ignore: cast_nullable_to_non_nullable
                        as String?,
            releaseDate:
                freezed == releaseDate
                    ? _value.releaseDate
                    : releaseDate // ignore: cast_nullable_to_non_nullable
                        as String?,
            totalTracks:
                freezed == totalTracks
                    ? _value.totalTracks
                    : totalTracks // ignore: cast_nullable_to_non_nullable
                        as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AlbumImplCopyWith<$Res> implements $AlbumCopyWith<$Res> {
  factory _$$AlbumImplCopyWith(
    _$AlbumImpl value,
    $Res Function(_$AlbumImpl) then,
  ) = __$$AlbumImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String spotifyId,
    String name,
    String artistId,
    String artistName,
    String? imageUrl,
    String? releaseDate,
    int? totalTracks,
  });
}

/// @nodoc
class __$$AlbumImplCopyWithImpl<$Res>
    extends _$AlbumCopyWithImpl<$Res, _$AlbumImpl>
    implements _$$AlbumImplCopyWith<$Res> {
  __$$AlbumImplCopyWithImpl(
    _$AlbumImpl _value,
    $Res Function(_$AlbumImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Album
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? spotifyId = null,
    Object? name = null,
    Object? artistId = null,
    Object? artistName = null,
    Object? imageUrl = freezed,
    Object? releaseDate = freezed,
    Object? totalTracks = freezed,
  }) {
    return _then(
      _$AlbumImpl(
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
        artistId:
            null == artistId
                ? _value.artistId
                : artistId // ignore: cast_nullable_to_non_nullable
                    as String,
        artistName:
            null == artistName
                ? _value.artistName
                : artistName // ignore: cast_nullable_to_non_nullable
                    as String,
        imageUrl:
            freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                    as String?,
        releaseDate:
            freezed == releaseDate
                ? _value.releaseDate
                : releaseDate // ignore: cast_nullable_to_non_nullable
                    as String?,
        totalTracks:
            freezed == totalTracks
                ? _value.totalTracks
                : totalTracks // ignore: cast_nullable_to_non_nullable
                    as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AlbumImpl implements _Album {
  const _$AlbumImpl({
    required this.spotifyId,
    required this.name,
    required this.artistId,
    required this.artistName,
    this.imageUrl,
    this.releaseDate,
    this.totalTracks,
  });

  factory _$AlbumImpl.fromJson(Map<String, dynamic> json) =>
      _$$AlbumImplFromJson(json);

  @override
  final String spotifyId;
  @override
  final String name;
  @override
  final String artistId;
  @override
  final String artistName;
  @override
  final String? imageUrl;
  @override
  final String? releaseDate;
  @override
  final int? totalTracks;

  @override
  String toString() {
    return 'Album(spotifyId: $spotifyId, name: $name, artistId: $artistId, artistName: $artistName, imageUrl: $imageUrl, releaseDate: $releaseDate, totalTracks: $totalTracks)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlbumImpl &&
            (identical(other.spotifyId, spotifyId) ||
                other.spotifyId == spotifyId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.artistId, artistId) ||
                other.artistId == artistId) &&
            (identical(other.artistName, artistName) ||
                other.artistName == artistName) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.releaseDate, releaseDate) ||
                other.releaseDate == releaseDate) &&
            (identical(other.totalTracks, totalTracks) ||
                other.totalTracks == totalTracks));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    spotifyId,
    name,
    artistId,
    artistName,
    imageUrl,
    releaseDate,
    totalTracks,
  );

  /// Create a copy of Album
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AlbumImplCopyWith<_$AlbumImpl> get copyWith =>
      __$$AlbumImplCopyWithImpl<_$AlbumImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AlbumImplToJson(this);
  }
}

abstract class _Album implements Album {
  const factory _Album({
    required final String spotifyId,
    required final String name,
    required final String artistId,
    required final String artistName,
    final String? imageUrl,
    final String? releaseDate,
    final int? totalTracks,
  }) = _$AlbumImpl;

  factory _Album.fromJson(Map<String, dynamic> json) = _$AlbumImpl.fromJson;

  @override
  String get spotifyId;
  @override
  String get name;
  @override
  String get artistId;
  @override
  String get artistName;
  @override
  String? get imageUrl;
  @override
  String? get releaseDate;
  @override
  int? get totalTracks;

  /// Create a copy of Album
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AlbumImplCopyWith<_$AlbumImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
