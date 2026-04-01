// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'track.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Track _$TrackFromJson(Map<String, dynamic> json) {
  return _Track.fromJson(json);
}

/// @nodoc
mixin _$Track {
  String get spotifyId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get artistId => throw _privateConstructorUsedError;
  String get artistName => throw _privateConstructorUsedError;
  String? get albumId => throw _privateConstructorUsedError;
  String? get albumName => throw _privateConstructorUsedError;
  String? get albumImage => throw _privateConstructorUsedError;
  int? get durationMs => throw _privateConstructorUsedError;
  String? get youtubeVideoId => throw _privateConstructorUsedError;
  int get playCount => throw _privateConstructorUsedError;
  bool get isFavorite => throw _privateConstructorUsedError;

  /// Serializes this Track to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Track
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TrackCopyWith<Track> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrackCopyWith<$Res> {
  factory $TrackCopyWith(Track value, $Res Function(Track) then) =
      _$TrackCopyWithImpl<$Res, Track>;
  @useResult
  $Res call({
    String spotifyId,
    String name,
    String artistId,
    String artistName,
    String? albumId,
    String? albumName,
    String? albumImage,
    int? durationMs,
    String? youtubeVideoId,
    int playCount,
    bool isFavorite,
  });
}

/// @nodoc
class _$TrackCopyWithImpl<$Res, $Val extends Track>
    implements $TrackCopyWith<$Res> {
  _$TrackCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Track
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? spotifyId = null,
    Object? name = null,
    Object? artistId = null,
    Object? artistName = null,
    Object? albumId = freezed,
    Object? albumName = freezed,
    Object? albumImage = freezed,
    Object? durationMs = freezed,
    Object? youtubeVideoId = freezed,
    Object? playCount = null,
    Object? isFavorite = null,
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
            albumId:
                freezed == albumId
                    ? _value.albumId
                    : albumId // ignore: cast_nullable_to_non_nullable
                        as String?,
            albumName:
                freezed == albumName
                    ? _value.albumName
                    : albumName // ignore: cast_nullable_to_non_nullable
                        as String?,
            albumImage:
                freezed == albumImage
                    ? _value.albumImage
                    : albumImage // ignore: cast_nullable_to_non_nullable
                        as String?,
            durationMs:
                freezed == durationMs
                    ? _value.durationMs
                    : durationMs // ignore: cast_nullable_to_non_nullable
                        as int?,
            youtubeVideoId:
                freezed == youtubeVideoId
                    ? _value.youtubeVideoId
                    : youtubeVideoId // ignore: cast_nullable_to_non_nullable
                        as String?,
            playCount:
                null == playCount
                    ? _value.playCount
                    : playCount // ignore: cast_nullable_to_non_nullable
                        as int,
            isFavorite:
                null == isFavorite
                    ? _value.isFavorite
                    : isFavorite // ignore: cast_nullable_to_non_nullable
                        as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TrackImplCopyWith<$Res> implements $TrackCopyWith<$Res> {
  factory _$$TrackImplCopyWith(
    _$TrackImpl value,
    $Res Function(_$TrackImpl) then,
  ) = __$$TrackImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String spotifyId,
    String name,
    String artistId,
    String artistName,
    String? albumId,
    String? albumName,
    String? albumImage,
    int? durationMs,
    String? youtubeVideoId,
    int playCount,
    bool isFavorite,
  });
}

/// @nodoc
class __$$TrackImplCopyWithImpl<$Res>
    extends _$TrackCopyWithImpl<$Res, _$TrackImpl>
    implements _$$TrackImplCopyWith<$Res> {
  __$$TrackImplCopyWithImpl(
    _$TrackImpl _value,
    $Res Function(_$TrackImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Track
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? spotifyId = null,
    Object? name = null,
    Object? artistId = null,
    Object? artistName = null,
    Object? albumId = freezed,
    Object? albumName = freezed,
    Object? albumImage = freezed,
    Object? durationMs = freezed,
    Object? youtubeVideoId = freezed,
    Object? playCount = null,
    Object? isFavorite = null,
  }) {
    return _then(
      _$TrackImpl(
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
        albumId:
            freezed == albumId
                ? _value.albumId
                : albumId // ignore: cast_nullable_to_non_nullable
                    as String?,
        albumName:
            freezed == albumName
                ? _value.albumName
                : albumName // ignore: cast_nullable_to_non_nullable
                    as String?,
        albumImage:
            freezed == albumImage
                ? _value.albumImage
                : albumImage // ignore: cast_nullable_to_non_nullable
                    as String?,
        durationMs:
            freezed == durationMs
                ? _value.durationMs
                : durationMs // ignore: cast_nullable_to_non_nullable
                    as int?,
        youtubeVideoId:
            freezed == youtubeVideoId
                ? _value.youtubeVideoId
                : youtubeVideoId // ignore: cast_nullable_to_non_nullable
                    as String?,
        playCount:
            null == playCount
                ? _value.playCount
                : playCount // ignore: cast_nullable_to_non_nullable
                    as int,
        isFavorite:
            null == isFavorite
                ? _value.isFavorite
                : isFavorite // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TrackImpl implements _Track {
  const _$TrackImpl({
    required this.spotifyId,
    required this.name,
    required this.artistId,
    required this.artistName,
    this.albumId,
    this.albumName,
    this.albumImage,
    this.durationMs,
    this.youtubeVideoId,
    this.playCount = 0,
    this.isFavorite = false,
  });

  factory _$TrackImpl.fromJson(Map<String, dynamic> json) =>
      _$$TrackImplFromJson(json);

  @override
  final String spotifyId;
  @override
  final String name;
  @override
  final String artistId;
  @override
  final String artistName;
  @override
  final String? albumId;
  @override
  final String? albumName;
  @override
  final String? albumImage;
  @override
  final int? durationMs;
  @override
  final String? youtubeVideoId;
  @override
  @JsonKey()
  final int playCount;
  @override
  @JsonKey()
  final bool isFavorite;

  @override
  String toString() {
    return 'Track(spotifyId: $spotifyId, name: $name, artistId: $artistId, artistName: $artistName, albumId: $albumId, albumName: $albumName, albumImage: $albumImage, durationMs: $durationMs, youtubeVideoId: $youtubeVideoId, playCount: $playCount, isFavorite: $isFavorite)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrackImpl &&
            (identical(other.spotifyId, spotifyId) ||
                other.spotifyId == spotifyId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.artistId, artistId) ||
                other.artistId == artistId) &&
            (identical(other.artistName, artistName) ||
                other.artistName == artistName) &&
            (identical(other.albumId, albumId) || other.albumId == albumId) &&
            (identical(other.albumName, albumName) ||
                other.albumName == albumName) &&
            (identical(other.albumImage, albumImage) ||
                other.albumImage == albumImage) &&
            (identical(other.durationMs, durationMs) ||
                other.durationMs == durationMs) &&
            (identical(other.youtubeVideoId, youtubeVideoId) ||
                other.youtubeVideoId == youtubeVideoId) &&
            (identical(other.playCount, playCount) ||
                other.playCount == playCount) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    spotifyId,
    name,
    artistId,
    artistName,
    albumId,
    albumName,
    albumImage,
    durationMs,
    youtubeVideoId,
    playCount,
    isFavorite,
  );

  /// Create a copy of Track
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TrackImplCopyWith<_$TrackImpl> get copyWith =>
      __$$TrackImplCopyWithImpl<_$TrackImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TrackImplToJson(this);
  }
}

abstract class _Track implements Track {
  const factory _Track({
    required final String spotifyId,
    required final String name,
    required final String artistId,
    required final String artistName,
    final String? albumId,
    final String? albumName,
    final String? albumImage,
    final int? durationMs,
    final String? youtubeVideoId,
    final int playCount,
    final bool isFavorite,
  }) = _$TrackImpl;

  factory _Track.fromJson(Map<String, dynamic> json) = _$TrackImpl.fromJson;

  @override
  String get spotifyId;
  @override
  String get name;
  @override
  String get artistId;
  @override
  String get artistName;
  @override
  String? get albumId;
  @override
  String? get albumName;
  @override
  String? get albumImage;
  @override
  int? get durationMs;
  @override
  String? get youtubeVideoId;
  @override
  int get playCount;
  @override
  bool get isFavorite;

  /// Create a copy of Track
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TrackImplCopyWith<_$TrackImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
