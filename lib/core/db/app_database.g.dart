// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TracksTable extends Tracks with TableInfo<$TracksTable, Track> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TracksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _spotifyIdMeta = const VerificationMeta(
    'spotifyId',
  );
  @override
  late final GeneratedColumn<String> spotifyId = GeneratedColumn<String>(
    'spotify_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _artistIdMeta = const VerificationMeta(
    'artistId',
  );
  @override
  late final GeneratedColumn<String> artistId = GeneratedColumn<String>(
    'artist_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _artistNameMeta = const VerificationMeta(
    'artistName',
  );
  @override
  late final GeneratedColumn<String> artistName = GeneratedColumn<String>(
    'artist_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _albumIdMeta = const VerificationMeta(
    'albumId',
  );
  @override
  late final GeneratedColumn<String> albumId = GeneratedColumn<String>(
    'album_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _albumNameMeta = const VerificationMeta(
    'albumName',
  );
  @override
  late final GeneratedColumn<String> albumName = GeneratedColumn<String>(
    'album_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _albumImageMeta = const VerificationMeta(
    'albumImage',
  );
  @override
  late final GeneratedColumn<String> albumImage = GeneratedColumn<String>(
    'album_image',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMsMeta = const VerificationMeta(
    'durationMs',
  );
  @override
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
    'duration_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _youtubeVideoIdMeta = const VerificationMeta(
    'youtubeVideoId',
  );
  @override
  late final GeneratedColumn<String> youtubeVideoId = GeneratedColumn<String>(
    'youtube_video_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _youtubeResolvedAtMeta = const VerificationMeta(
    'youtubeResolvedAt',
  );
  @override
  late final GeneratedColumn<DateTime> youtubeResolvedAt =
      GeneratedColumn<DateTime>(
        'youtube_resolved_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _playCountMeta = const VerificationMeta(
    'playCount',
  );
  @override
  late final GeneratedColumn<int> playCount = GeneratedColumn<int>(
    'play_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _lastPlayedAtMeta = const VerificationMeta(
    'lastPlayedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastPlayedAt = GeneratedColumn<DateTime>(
    'last_played_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    spotifyId,
    name,
    artistId,
    artistName,
    albumId,
    albumName,
    albumImage,
    durationMs,
    youtubeVideoId,
    youtubeResolvedAt,
    playCount,
    isFavorite,
    lastPlayedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tracks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Track> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('spotify_id')) {
      context.handle(
        _spotifyIdMeta,
        spotifyId.isAcceptableOrUnknown(data['spotify_id']!, _spotifyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_spotifyIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('artist_id')) {
      context.handle(
        _artistIdMeta,
        artistId.isAcceptableOrUnknown(data['artist_id']!, _artistIdMeta),
      );
    } else if (isInserting) {
      context.missing(_artistIdMeta);
    }
    if (data.containsKey('artist_name')) {
      context.handle(
        _artistNameMeta,
        artistName.isAcceptableOrUnknown(data['artist_name']!, _artistNameMeta),
      );
    } else if (isInserting) {
      context.missing(_artistNameMeta);
    }
    if (data.containsKey('album_id')) {
      context.handle(
        _albumIdMeta,
        albumId.isAcceptableOrUnknown(data['album_id']!, _albumIdMeta),
      );
    }
    if (data.containsKey('album_name')) {
      context.handle(
        _albumNameMeta,
        albumName.isAcceptableOrUnknown(data['album_name']!, _albumNameMeta),
      );
    }
    if (data.containsKey('album_image')) {
      context.handle(
        _albumImageMeta,
        albumImage.isAcceptableOrUnknown(data['album_image']!, _albumImageMeta),
      );
    }
    if (data.containsKey('duration_ms')) {
      context.handle(
        _durationMsMeta,
        durationMs.isAcceptableOrUnknown(data['duration_ms']!, _durationMsMeta),
      );
    }
    if (data.containsKey('youtube_video_id')) {
      context.handle(
        _youtubeVideoIdMeta,
        youtubeVideoId.isAcceptableOrUnknown(
          data['youtube_video_id']!,
          _youtubeVideoIdMeta,
        ),
      );
    }
    if (data.containsKey('youtube_resolved_at')) {
      context.handle(
        _youtubeResolvedAtMeta,
        youtubeResolvedAt.isAcceptableOrUnknown(
          data['youtube_resolved_at']!,
          _youtubeResolvedAtMeta,
        ),
      );
    }
    if (data.containsKey('play_count')) {
      context.handle(
        _playCountMeta,
        playCount.isAcceptableOrUnknown(data['play_count']!, _playCountMeta),
      );
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    if (data.containsKey('last_played_at')) {
      context.handle(
        _lastPlayedAtMeta,
        lastPlayedAt.isAcceptableOrUnknown(
          data['last_played_at']!,
          _lastPlayedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {spotifyId};
  @override
  Track map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Track(
      spotifyId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}spotify_id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      artistId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}artist_id'],
          )!,
      artistName:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}artist_name'],
          )!,
      albumId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}album_id'],
      ),
      albumName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}album_name'],
      ),
      albumImage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}album_image'],
      ),
      durationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_ms'],
      ),
      youtubeVideoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}youtube_video_id'],
      ),
      youtubeResolvedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}youtube_resolved_at'],
      ),
      playCount:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}play_count'],
          )!,
      isFavorite:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_favorite'],
          )!,
      lastPlayedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_played_at'],
      ),
    );
  }

  @override
  $TracksTable createAlias(String alias) {
    return $TracksTable(attachedDatabase, alias);
  }
}

class Track extends DataClass implements Insertable<Track> {
  final String spotifyId;
  final String name;
  final String artistId;
  final String artistName;
  final String? albumId;
  final String? albumName;
  final String? albumImage;
  final int? durationMs;
  final String? youtubeVideoId;
  final DateTime? youtubeResolvedAt;
  final int playCount;
  final bool isFavorite;
  final DateTime? lastPlayedAt;
  const Track({
    required this.spotifyId,
    required this.name,
    required this.artistId,
    required this.artistName,
    this.albumId,
    this.albumName,
    this.albumImage,
    this.durationMs,
    this.youtubeVideoId,
    this.youtubeResolvedAt,
    required this.playCount,
    required this.isFavorite,
    this.lastPlayedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['spotify_id'] = Variable<String>(spotifyId);
    map['name'] = Variable<String>(name);
    map['artist_id'] = Variable<String>(artistId);
    map['artist_name'] = Variable<String>(artistName);
    if (!nullToAbsent || albumId != null) {
      map['album_id'] = Variable<String>(albumId);
    }
    if (!nullToAbsent || albumName != null) {
      map['album_name'] = Variable<String>(albumName);
    }
    if (!nullToAbsent || albumImage != null) {
      map['album_image'] = Variable<String>(albumImage);
    }
    if (!nullToAbsent || durationMs != null) {
      map['duration_ms'] = Variable<int>(durationMs);
    }
    if (!nullToAbsent || youtubeVideoId != null) {
      map['youtube_video_id'] = Variable<String>(youtubeVideoId);
    }
    if (!nullToAbsent || youtubeResolvedAt != null) {
      map['youtube_resolved_at'] = Variable<DateTime>(youtubeResolvedAt);
    }
    map['play_count'] = Variable<int>(playCount);
    map['is_favorite'] = Variable<bool>(isFavorite);
    if (!nullToAbsent || lastPlayedAt != null) {
      map['last_played_at'] = Variable<DateTime>(lastPlayedAt);
    }
    return map;
  }

  TracksCompanion toCompanion(bool nullToAbsent) {
    return TracksCompanion(
      spotifyId: Value(spotifyId),
      name: Value(name),
      artistId: Value(artistId),
      artistName: Value(artistName),
      albumId:
          albumId == null && nullToAbsent
              ? const Value.absent()
              : Value(albumId),
      albumName:
          albumName == null && nullToAbsent
              ? const Value.absent()
              : Value(albumName),
      albumImage:
          albumImage == null && nullToAbsent
              ? const Value.absent()
              : Value(albumImage),
      durationMs:
          durationMs == null && nullToAbsent
              ? const Value.absent()
              : Value(durationMs),
      youtubeVideoId:
          youtubeVideoId == null && nullToAbsent
              ? const Value.absent()
              : Value(youtubeVideoId),
      youtubeResolvedAt:
          youtubeResolvedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(youtubeResolvedAt),
      playCount: Value(playCount),
      isFavorite: Value(isFavorite),
      lastPlayedAt:
          lastPlayedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(lastPlayedAt),
    );
  }

  factory Track.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Track(
      spotifyId: serializer.fromJson<String>(json['spotifyId']),
      name: serializer.fromJson<String>(json['name']),
      artistId: serializer.fromJson<String>(json['artistId']),
      artistName: serializer.fromJson<String>(json['artistName']),
      albumId: serializer.fromJson<String?>(json['albumId']),
      albumName: serializer.fromJson<String?>(json['albumName']),
      albumImage: serializer.fromJson<String?>(json['albumImage']),
      durationMs: serializer.fromJson<int?>(json['durationMs']),
      youtubeVideoId: serializer.fromJson<String?>(json['youtubeVideoId']),
      youtubeResolvedAt: serializer.fromJson<DateTime?>(
        json['youtubeResolvedAt'],
      ),
      playCount: serializer.fromJson<int>(json['playCount']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      lastPlayedAt: serializer.fromJson<DateTime?>(json['lastPlayedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'spotifyId': serializer.toJson<String>(spotifyId),
      'name': serializer.toJson<String>(name),
      'artistId': serializer.toJson<String>(artistId),
      'artistName': serializer.toJson<String>(artistName),
      'albumId': serializer.toJson<String?>(albumId),
      'albumName': serializer.toJson<String?>(albumName),
      'albumImage': serializer.toJson<String?>(albumImage),
      'durationMs': serializer.toJson<int?>(durationMs),
      'youtubeVideoId': serializer.toJson<String?>(youtubeVideoId),
      'youtubeResolvedAt': serializer.toJson<DateTime?>(youtubeResolvedAt),
      'playCount': serializer.toJson<int>(playCount),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'lastPlayedAt': serializer.toJson<DateTime?>(lastPlayedAt),
    };
  }

  Track copyWith({
    String? spotifyId,
    String? name,
    String? artistId,
    String? artistName,
    Value<String?> albumId = const Value.absent(),
    Value<String?> albumName = const Value.absent(),
    Value<String?> albumImage = const Value.absent(),
    Value<int?> durationMs = const Value.absent(),
    Value<String?> youtubeVideoId = const Value.absent(),
    Value<DateTime?> youtubeResolvedAt = const Value.absent(),
    int? playCount,
    bool? isFavorite,
    Value<DateTime?> lastPlayedAt = const Value.absent(),
  }) => Track(
    spotifyId: spotifyId ?? this.spotifyId,
    name: name ?? this.name,
    artistId: artistId ?? this.artistId,
    artistName: artistName ?? this.artistName,
    albumId: albumId.present ? albumId.value : this.albumId,
    albumName: albumName.present ? albumName.value : this.albumName,
    albumImage: albumImage.present ? albumImage.value : this.albumImage,
    durationMs: durationMs.present ? durationMs.value : this.durationMs,
    youtubeVideoId:
        youtubeVideoId.present ? youtubeVideoId.value : this.youtubeVideoId,
    youtubeResolvedAt:
        youtubeResolvedAt.present
            ? youtubeResolvedAt.value
            : this.youtubeResolvedAt,
    playCount: playCount ?? this.playCount,
    isFavorite: isFavorite ?? this.isFavorite,
    lastPlayedAt: lastPlayedAt.present ? lastPlayedAt.value : this.lastPlayedAt,
  );
  Track copyWithCompanion(TracksCompanion data) {
    return Track(
      spotifyId: data.spotifyId.present ? data.spotifyId.value : this.spotifyId,
      name: data.name.present ? data.name.value : this.name,
      artistId: data.artistId.present ? data.artistId.value : this.artistId,
      artistName:
          data.artistName.present ? data.artistName.value : this.artistName,
      albumId: data.albumId.present ? data.albumId.value : this.albumId,
      albumName: data.albumName.present ? data.albumName.value : this.albumName,
      albumImage:
          data.albumImage.present ? data.albumImage.value : this.albumImage,
      durationMs:
          data.durationMs.present ? data.durationMs.value : this.durationMs,
      youtubeVideoId:
          data.youtubeVideoId.present
              ? data.youtubeVideoId.value
              : this.youtubeVideoId,
      youtubeResolvedAt:
          data.youtubeResolvedAt.present
              ? data.youtubeResolvedAt.value
              : this.youtubeResolvedAt,
      playCount: data.playCount.present ? data.playCount.value : this.playCount,
      isFavorite:
          data.isFavorite.present ? data.isFavorite.value : this.isFavorite,
      lastPlayedAt:
          data.lastPlayedAt.present
              ? data.lastPlayedAt.value
              : this.lastPlayedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Track(')
          ..write('spotifyId: $spotifyId, ')
          ..write('name: $name, ')
          ..write('artistId: $artistId, ')
          ..write('artistName: $artistName, ')
          ..write('albumId: $albumId, ')
          ..write('albumName: $albumName, ')
          ..write('albumImage: $albumImage, ')
          ..write('durationMs: $durationMs, ')
          ..write('youtubeVideoId: $youtubeVideoId, ')
          ..write('youtubeResolvedAt: $youtubeResolvedAt, ')
          ..write('playCount: $playCount, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('lastPlayedAt: $lastPlayedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    spotifyId,
    name,
    artistId,
    artistName,
    albumId,
    albumName,
    albumImage,
    durationMs,
    youtubeVideoId,
    youtubeResolvedAt,
    playCount,
    isFavorite,
    lastPlayedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Track &&
          other.spotifyId == this.spotifyId &&
          other.name == this.name &&
          other.artistId == this.artistId &&
          other.artistName == this.artistName &&
          other.albumId == this.albumId &&
          other.albumName == this.albumName &&
          other.albumImage == this.albumImage &&
          other.durationMs == this.durationMs &&
          other.youtubeVideoId == this.youtubeVideoId &&
          other.youtubeResolvedAt == this.youtubeResolvedAt &&
          other.playCount == this.playCount &&
          other.isFavorite == this.isFavorite &&
          other.lastPlayedAt == this.lastPlayedAt);
}

class TracksCompanion extends UpdateCompanion<Track> {
  final Value<String> spotifyId;
  final Value<String> name;
  final Value<String> artistId;
  final Value<String> artistName;
  final Value<String?> albumId;
  final Value<String?> albumName;
  final Value<String?> albumImage;
  final Value<int?> durationMs;
  final Value<String?> youtubeVideoId;
  final Value<DateTime?> youtubeResolvedAt;
  final Value<int> playCount;
  final Value<bool> isFavorite;
  final Value<DateTime?> lastPlayedAt;
  final Value<int> rowid;
  const TracksCompanion({
    this.spotifyId = const Value.absent(),
    this.name = const Value.absent(),
    this.artistId = const Value.absent(),
    this.artistName = const Value.absent(),
    this.albumId = const Value.absent(),
    this.albumName = const Value.absent(),
    this.albumImage = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.youtubeVideoId = const Value.absent(),
    this.youtubeResolvedAt = const Value.absent(),
    this.playCount = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.lastPlayedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TracksCompanion.insert({
    required String spotifyId,
    required String name,
    required String artistId,
    required String artistName,
    this.albumId = const Value.absent(),
    this.albumName = const Value.absent(),
    this.albumImage = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.youtubeVideoId = const Value.absent(),
    this.youtubeResolvedAt = const Value.absent(),
    this.playCount = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.lastPlayedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : spotifyId = Value(spotifyId),
       name = Value(name),
       artistId = Value(artistId),
       artistName = Value(artistName);
  static Insertable<Track> custom({
    Expression<String>? spotifyId,
    Expression<String>? name,
    Expression<String>? artistId,
    Expression<String>? artistName,
    Expression<String>? albumId,
    Expression<String>? albumName,
    Expression<String>? albumImage,
    Expression<int>? durationMs,
    Expression<String>? youtubeVideoId,
    Expression<DateTime>? youtubeResolvedAt,
    Expression<int>? playCount,
    Expression<bool>? isFavorite,
    Expression<DateTime>? lastPlayedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (spotifyId != null) 'spotify_id': spotifyId,
      if (name != null) 'name': name,
      if (artistId != null) 'artist_id': artistId,
      if (artistName != null) 'artist_name': artistName,
      if (albumId != null) 'album_id': albumId,
      if (albumName != null) 'album_name': albumName,
      if (albumImage != null) 'album_image': albumImage,
      if (durationMs != null) 'duration_ms': durationMs,
      if (youtubeVideoId != null) 'youtube_video_id': youtubeVideoId,
      if (youtubeResolvedAt != null) 'youtube_resolved_at': youtubeResolvedAt,
      if (playCount != null) 'play_count': playCount,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (lastPlayedAt != null) 'last_played_at': lastPlayedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TracksCompanion copyWith({
    Value<String>? spotifyId,
    Value<String>? name,
    Value<String>? artistId,
    Value<String>? artistName,
    Value<String?>? albumId,
    Value<String?>? albumName,
    Value<String?>? albumImage,
    Value<int?>? durationMs,
    Value<String?>? youtubeVideoId,
    Value<DateTime?>? youtubeResolvedAt,
    Value<int>? playCount,
    Value<bool>? isFavorite,
    Value<DateTime?>? lastPlayedAt,
    Value<int>? rowid,
  }) {
    return TracksCompanion(
      spotifyId: spotifyId ?? this.spotifyId,
      name: name ?? this.name,
      artistId: artistId ?? this.artistId,
      artistName: artistName ?? this.artistName,
      albumId: albumId ?? this.albumId,
      albumName: albumName ?? this.albumName,
      albumImage: albumImage ?? this.albumImage,
      durationMs: durationMs ?? this.durationMs,
      youtubeVideoId: youtubeVideoId ?? this.youtubeVideoId,
      youtubeResolvedAt: youtubeResolvedAt ?? this.youtubeResolvedAt,
      playCount: playCount ?? this.playCount,
      isFavorite: isFavorite ?? this.isFavorite,
      lastPlayedAt: lastPlayedAt ?? this.lastPlayedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (spotifyId.present) {
      map['spotify_id'] = Variable<String>(spotifyId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (artistId.present) {
      map['artist_id'] = Variable<String>(artistId.value);
    }
    if (artistName.present) {
      map['artist_name'] = Variable<String>(artistName.value);
    }
    if (albumId.present) {
      map['album_id'] = Variable<String>(albumId.value);
    }
    if (albumName.present) {
      map['album_name'] = Variable<String>(albumName.value);
    }
    if (albumImage.present) {
      map['album_image'] = Variable<String>(albumImage.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    if (youtubeVideoId.present) {
      map['youtube_video_id'] = Variable<String>(youtubeVideoId.value);
    }
    if (youtubeResolvedAt.present) {
      map['youtube_resolved_at'] = Variable<DateTime>(youtubeResolvedAt.value);
    }
    if (playCount.present) {
      map['play_count'] = Variable<int>(playCount.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (lastPlayedAt.present) {
      map['last_played_at'] = Variable<DateTime>(lastPlayedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TracksCompanion(')
          ..write('spotifyId: $spotifyId, ')
          ..write('name: $name, ')
          ..write('artistId: $artistId, ')
          ..write('artistName: $artistName, ')
          ..write('albumId: $albumId, ')
          ..write('albumName: $albumName, ')
          ..write('albumImage: $albumImage, ')
          ..write('durationMs: $durationMs, ')
          ..write('youtubeVideoId: $youtubeVideoId, ')
          ..write('youtubeResolvedAt: $youtubeResolvedAt, ')
          ..write('playCount: $playCount, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('lastPlayedAt: $lastPlayedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ArtistsTable extends Artists with TableInfo<$ArtistsTable, Artist> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ArtistsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _spotifyIdMeta = const VerificationMeta(
    'spotifyId',
  );
  @override
  late final GeneratedColumn<String> spotifyId = GeneratedColumn<String>(
    'spotify_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageSmallMeta = const VerificationMeta(
    'imageSmall',
  );
  @override
  late final GeneratedColumn<String> imageSmall = GeneratedColumn<String>(
    'image_small',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _followersMeta = const VerificationMeta(
    'followers',
  );
  @override
  late final GeneratedColumn<int> followers = GeneratedColumn<int>(
    'followers',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isFollowedMeta = const VerificationMeta(
    'isFollowed',
  );
  @override
  late final GeneratedColumn<bool> isFollowed = GeneratedColumn<bool>(
    'is_followed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_followed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    spotifyId,
    name,
    imageUrl,
    imageSmall,
    followers,
    isFollowed,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'artists';
  @override
  VerificationContext validateIntegrity(
    Insertable<Artist> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('spotify_id')) {
      context.handle(
        _spotifyIdMeta,
        spotifyId.isAcceptableOrUnknown(data['spotify_id']!, _spotifyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_spotifyIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('image_small')) {
      context.handle(
        _imageSmallMeta,
        imageSmall.isAcceptableOrUnknown(data['image_small']!, _imageSmallMeta),
      );
    }
    if (data.containsKey('followers')) {
      context.handle(
        _followersMeta,
        followers.isAcceptableOrUnknown(data['followers']!, _followersMeta),
      );
    }
    if (data.containsKey('is_followed')) {
      context.handle(
        _isFollowedMeta,
        isFollowed.isAcceptableOrUnknown(data['is_followed']!, _isFollowedMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {spotifyId};
  @override
  Artist map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Artist(
      spotifyId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}spotify_id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      imageSmall: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_small'],
      ),
      followers: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}followers'],
      ),
      isFollowed:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_followed'],
          )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $ArtistsTable createAlias(String alias) {
    return $ArtistsTable(attachedDatabase, alias);
  }
}

class Artist extends DataClass implements Insertable<Artist> {
  final String spotifyId;
  final String name;
  final String? imageUrl;
  final String? imageSmall;
  final int? followers;
  final bool isFollowed;
  final DateTime? updatedAt;
  const Artist({
    required this.spotifyId,
    required this.name,
    this.imageUrl,
    this.imageSmall,
    this.followers,
    required this.isFollowed,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['spotify_id'] = Variable<String>(spotifyId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    if (!nullToAbsent || imageSmall != null) {
      map['image_small'] = Variable<String>(imageSmall);
    }
    if (!nullToAbsent || followers != null) {
      map['followers'] = Variable<int>(followers);
    }
    map['is_followed'] = Variable<bool>(isFollowed);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  ArtistsCompanion toCompanion(bool nullToAbsent) {
    return ArtistsCompanion(
      spotifyId: Value(spotifyId),
      name: Value(name),
      imageUrl:
          imageUrl == null && nullToAbsent
              ? const Value.absent()
              : Value(imageUrl),
      imageSmall:
          imageSmall == null && nullToAbsent
              ? const Value.absent()
              : Value(imageSmall),
      followers:
          followers == null && nullToAbsent
              ? const Value.absent()
              : Value(followers),
      isFollowed: Value(isFollowed),
      updatedAt:
          updatedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(updatedAt),
    );
  }

  factory Artist.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Artist(
      spotifyId: serializer.fromJson<String>(json['spotifyId']),
      name: serializer.fromJson<String>(json['name']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      imageSmall: serializer.fromJson<String?>(json['imageSmall']),
      followers: serializer.fromJson<int?>(json['followers']),
      isFollowed: serializer.fromJson<bool>(json['isFollowed']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'spotifyId': serializer.toJson<String>(spotifyId),
      'name': serializer.toJson<String>(name),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'imageSmall': serializer.toJson<String?>(imageSmall),
      'followers': serializer.toJson<int?>(followers),
      'isFollowed': serializer.toJson<bool>(isFollowed),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  Artist copyWith({
    String? spotifyId,
    String? name,
    Value<String?> imageUrl = const Value.absent(),
    Value<String?> imageSmall = const Value.absent(),
    Value<int?> followers = const Value.absent(),
    bool? isFollowed,
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => Artist(
    spotifyId: spotifyId ?? this.spotifyId,
    name: name ?? this.name,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    imageSmall: imageSmall.present ? imageSmall.value : this.imageSmall,
    followers: followers.present ? followers.value : this.followers,
    isFollowed: isFollowed ?? this.isFollowed,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  Artist copyWithCompanion(ArtistsCompanion data) {
    return Artist(
      spotifyId: data.spotifyId.present ? data.spotifyId.value : this.spotifyId,
      name: data.name.present ? data.name.value : this.name,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      imageSmall:
          data.imageSmall.present ? data.imageSmall.value : this.imageSmall,
      followers: data.followers.present ? data.followers.value : this.followers,
      isFollowed:
          data.isFollowed.present ? data.isFollowed.value : this.isFollowed,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Artist(')
          ..write('spotifyId: $spotifyId, ')
          ..write('name: $name, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('imageSmall: $imageSmall, ')
          ..write('followers: $followers, ')
          ..write('isFollowed: $isFollowed, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    spotifyId,
    name,
    imageUrl,
    imageSmall,
    followers,
    isFollowed,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Artist &&
          other.spotifyId == this.spotifyId &&
          other.name == this.name &&
          other.imageUrl == this.imageUrl &&
          other.imageSmall == this.imageSmall &&
          other.followers == this.followers &&
          other.isFollowed == this.isFollowed &&
          other.updatedAt == this.updatedAt);
}

class ArtistsCompanion extends UpdateCompanion<Artist> {
  final Value<String> spotifyId;
  final Value<String> name;
  final Value<String?> imageUrl;
  final Value<String?> imageSmall;
  final Value<int?> followers;
  final Value<bool> isFollowed;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const ArtistsCompanion({
    this.spotifyId = const Value.absent(),
    this.name = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.imageSmall = const Value.absent(),
    this.followers = const Value.absent(),
    this.isFollowed = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ArtistsCompanion.insert({
    required String spotifyId,
    required String name,
    this.imageUrl = const Value.absent(),
    this.imageSmall = const Value.absent(),
    this.followers = const Value.absent(),
    this.isFollowed = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : spotifyId = Value(spotifyId),
       name = Value(name);
  static Insertable<Artist> custom({
    Expression<String>? spotifyId,
    Expression<String>? name,
    Expression<String>? imageUrl,
    Expression<String>? imageSmall,
    Expression<int>? followers,
    Expression<bool>? isFollowed,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (spotifyId != null) 'spotify_id': spotifyId,
      if (name != null) 'name': name,
      if (imageUrl != null) 'image_url': imageUrl,
      if (imageSmall != null) 'image_small': imageSmall,
      if (followers != null) 'followers': followers,
      if (isFollowed != null) 'is_followed': isFollowed,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ArtistsCompanion copyWith({
    Value<String>? spotifyId,
    Value<String>? name,
    Value<String?>? imageUrl,
    Value<String?>? imageSmall,
    Value<int?>? followers,
    Value<bool>? isFollowed,
    Value<DateTime?>? updatedAt,
    Value<int>? rowid,
  }) {
    return ArtistsCompanion(
      spotifyId: spotifyId ?? this.spotifyId,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      imageSmall: imageSmall ?? this.imageSmall,
      followers: followers ?? this.followers,
      isFollowed: isFollowed ?? this.isFollowed,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (spotifyId.present) {
      map['spotify_id'] = Variable<String>(spotifyId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (imageSmall.present) {
      map['image_small'] = Variable<String>(imageSmall.value);
    }
    if (followers.present) {
      map['followers'] = Variable<int>(followers.value);
    }
    if (isFollowed.present) {
      map['is_followed'] = Variable<bool>(isFollowed.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ArtistsCompanion(')
          ..write('spotifyId: $spotifyId, ')
          ..write('name: $name, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('imageSmall: $imageSmall, ')
          ..write('followers: $followers, ')
          ..write('isFollowed: $isFollowed, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AlbumsTable extends Albums with TableInfo<$AlbumsTable, Album> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AlbumsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _spotifyIdMeta = const VerificationMeta(
    'spotifyId',
  );
  @override
  late final GeneratedColumn<String> spotifyId = GeneratedColumn<String>(
    'spotify_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _artistIdMeta = const VerificationMeta(
    'artistId',
  );
  @override
  late final GeneratedColumn<String> artistId = GeneratedColumn<String>(
    'artist_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _artistNameMeta = const VerificationMeta(
    'artistName',
  );
  @override
  late final GeneratedColumn<String> artistName = GeneratedColumn<String>(
    'artist_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _releaseDateMeta = const VerificationMeta(
    'releaseDate',
  );
  @override
  late final GeneratedColumn<String> releaseDate = GeneratedColumn<String>(
    'release_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalTracksMeta = const VerificationMeta(
    'totalTracks',
  );
  @override
  late final GeneratedColumn<int> totalTracks = GeneratedColumn<int>(
    'total_tracks',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isLikedMeta = const VerificationMeta(
    'isLiked',
  );
  @override
  late final GeneratedColumn<bool> isLiked = GeneratedColumn<bool>(
    'is_liked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_liked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    spotifyId,
    name,
    artistId,
    artistName,
    imageUrl,
    releaseDate,
    totalTracks,
    isLiked,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'albums';
  @override
  VerificationContext validateIntegrity(
    Insertable<Album> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('spotify_id')) {
      context.handle(
        _spotifyIdMeta,
        spotifyId.isAcceptableOrUnknown(data['spotify_id']!, _spotifyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_spotifyIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('artist_id')) {
      context.handle(
        _artistIdMeta,
        artistId.isAcceptableOrUnknown(data['artist_id']!, _artistIdMeta),
      );
    } else if (isInserting) {
      context.missing(_artistIdMeta);
    }
    if (data.containsKey('artist_name')) {
      context.handle(
        _artistNameMeta,
        artistName.isAcceptableOrUnknown(data['artist_name']!, _artistNameMeta),
      );
    } else if (isInserting) {
      context.missing(_artistNameMeta);
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('release_date')) {
      context.handle(
        _releaseDateMeta,
        releaseDate.isAcceptableOrUnknown(
          data['release_date']!,
          _releaseDateMeta,
        ),
      );
    }
    if (data.containsKey('total_tracks')) {
      context.handle(
        _totalTracksMeta,
        totalTracks.isAcceptableOrUnknown(
          data['total_tracks']!,
          _totalTracksMeta,
        ),
      );
    }
    if (data.containsKey('is_liked')) {
      context.handle(
        _isLikedMeta,
        isLiked.isAcceptableOrUnknown(data['is_liked']!, _isLikedMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {spotifyId};
  @override
  Album map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Album(
      spotifyId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}spotify_id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      artistId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}artist_id'],
          )!,
      artistName:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}artist_name'],
          )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      releaseDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}release_date'],
      ),
      totalTracks: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_tracks'],
      ),
      isLiked:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_liked'],
          )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $AlbumsTable createAlias(String alias) {
    return $AlbumsTable(attachedDatabase, alias);
  }
}

class Album extends DataClass implements Insertable<Album> {
  final String spotifyId;
  final String name;
  final String artistId;
  final String artistName;
  final String? imageUrl;
  final String? releaseDate;
  final int? totalTracks;
  final bool isLiked;
  final DateTime? updatedAt;
  const Album({
    required this.spotifyId,
    required this.name,
    required this.artistId,
    required this.artistName,
    this.imageUrl,
    this.releaseDate,
    this.totalTracks,
    required this.isLiked,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['spotify_id'] = Variable<String>(spotifyId);
    map['name'] = Variable<String>(name);
    map['artist_id'] = Variable<String>(artistId);
    map['artist_name'] = Variable<String>(artistName);
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    if (!nullToAbsent || releaseDate != null) {
      map['release_date'] = Variable<String>(releaseDate);
    }
    if (!nullToAbsent || totalTracks != null) {
      map['total_tracks'] = Variable<int>(totalTracks);
    }
    map['is_liked'] = Variable<bool>(isLiked);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  AlbumsCompanion toCompanion(bool nullToAbsent) {
    return AlbumsCompanion(
      spotifyId: Value(spotifyId),
      name: Value(name),
      artistId: Value(artistId),
      artistName: Value(artistName),
      imageUrl:
          imageUrl == null && nullToAbsent
              ? const Value.absent()
              : Value(imageUrl),
      releaseDate:
          releaseDate == null && nullToAbsent
              ? const Value.absent()
              : Value(releaseDate),
      totalTracks:
          totalTracks == null && nullToAbsent
              ? const Value.absent()
              : Value(totalTracks),
      isLiked: Value(isLiked),
      updatedAt:
          updatedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(updatedAt),
    );
  }

  factory Album.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Album(
      spotifyId: serializer.fromJson<String>(json['spotifyId']),
      name: serializer.fromJson<String>(json['name']),
      artistId: serializer.fromJson<String>(json['artistId']),
      artistName: serializer.fromJson<String>(json['artistName']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      releaseDate: serializer.fromJson<String?>(json['releaseDate']),
      totalTracks: serializer.fromJson<int?>(json['totalTracks']),
      isLiked: serializer.fromJson<bool>(json['isLiked']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'spotifyId': serializer.toJson<String>(spotifyId),
      'name': serializer.toJson<String>(name),
      'artistId': serializer.toJson<String>(artistId),
      'artistName': serializer.toJson<String>(artistName),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'releaseDate': serializer.toJson<String?>(releaseDate),
      'totalTracks': serializer.toJson<int?>(totalTracks),
      'isLiked': serializer.toJson<bool>(isLiked),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  Album copyWith({
    String? spotifyId,
    String? name,
    String? artistId,
    String? artistName,
    Value<String?> imageUrl = const Value.absent(),
    Value<String?> releaseDate = const Value.absent(),
    Value<int?> totalTracks = const Value.absent(),
    bool? isLiked,
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => Album(
    spotifyId: spotifyId ?? this.spotifyId,
    name: name ?? this.name,
    artistId: artistId ?? this.artistId,
    artistName: artistName ?? this.artistName,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    releaseDate: releaseDate.present ? releaseDate.value : this.releaseDate,
    totalTracks: totalTracks.present ? totalTracks.value : this.totalTracks,
    isLiked: isLiked ?? this.isLiked,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  Album copyWithCompanion(AlbumsCompanion data) {
    return Album(
      spotifyId: data.spotifyId.present ? data.spotifyId.value : this.spotifyId,
      name: data.name.present ? data.name.value : this.name,
      artistId: data.artistId.present ? data.artistId.value : this.artistId,
      artistName:
          data.artistName.present ? data.artistName.value : this.artistName,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      releaseDate:
          data.releaseDate.present ? data.releaseDate.value : this.releaseDate,
      totalTracks:
          data.totalTracks.present ? data.totalTracks.value : this.totalTracks,
      isLiked: data.isLiked.present ? data.isLiked.value : this.isLiked,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Album(')
          ..write('spotifyId: $spotifyId, ')
          ..write('name: $name, ')
          ..write('artistId: $artistId, ')
          ..write('artistName: $artistName, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('releaseDate: $releaseDate, ')
          ..write('totalTracks: $totalTracks, ')
          ..write('isLiked: $isLiked, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    spotifyId,
    name,
    artistId,
    artistName,
    imageUrl,
    releaseDate,
    totalTracks,
    isLiked,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Album &&
          other.spotifyId == this.spotifyId &&
          other.name == this.name &&
          other.artistId == this.artistId &&
          other.artistName == this.artistName &&
          other.imageUrl == this.imageUrl &&
          other.releaseDate == this.releaseDate &&
          other.totalTracks == this.totalTracks &&
          other.isLiked == this.isLiked &&
          other.updatedAt == this.updatedAt);
}

class AlbumsCompanion extends UpdateCompanion<Album> {
  final Value<String> spotifyId;
  final Value<String> name;
  final Value<String> artistId;
  final Value<String> artistName;
  final Value<String?> imageUrl;
  final Value<String?> releaseDate;
  final Value<int?> totalTracks;
  final Value<bool> isLiked;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const AlbumsCompanion({
    this.spotifyId = const Value.absent(),
    this.name = const Value.absent(),
    this.artistId = const Value.absent(),
    this.artistName = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.releaseDate = const Value.absent(),
    this.totalTracks = const Value.absent(),
    this.isLiked = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AlbumsCompanion.insert({
    required String spotifyId,
    required String name,
    required String artistId,
    required String artistName,
    this.imageUrl = const Value.absent(),
    this.releaseDate = const Value.absent(),
    this.totalTracks = const Value.absent(),
    this.isLiked = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : spotifyId = Value(spotifyId),
       name = Value(name),
       artistId = Value(artistId),
       artistName = Value(artistName);
  static Insertable<Album> custom({
    Expression<String>? spotifyId,
    Expression<String>? name,
    Expression<String>? artistId,
    Expression<String>? artistName,
    Expression<String>? imageUrl,
    Expression<String>? releaseDate,
    Expression<int>? totalTracks,
    Expression<bool>? isLiked,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (spotifyId != null) 'spotify_id': spotifyId,
      if (name != null) 'name': name,
      if (artistId != null) 'artist_id': artistId,
      if (artistName != null) 'artist_name': artistName,
      if (imageUrl != null) 'image_url': imageUrl,
      if (releaseDate != null) 'release_date': releaseDate,
      if (totalTracks != null) 'total_tracks': totalTracks,
      if (isLiked != null) 'is_liked': isLiked,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AlbumsCompanion copyWith({
    Value<String>? spotifyId,
    Value<String>? name,
    Value<String>? artistId,
    Value<String>? artistName,
    Value<String?>? imageUrl,
    Value<String?>? releaseDate,
    Value<int?>? totalTracks,
    Value<bool>? isLiked,
    Value<DateTime?>? updatedAt,
    Value<int>? rowid,
  }) {
    return AlbumsCompanion(
      spotifyId: spotifyId ?? this.spotifyId,
      name: name ?? this.name,
      artistId: artistId ?? this.artistId,
      artistName: artistName ?? this.artistName,
      imageUrl: imageUrl ?? this.imageUrl,
      releaseDate: releaseDate ?? this.releaseDate,
      totalTracks: totalTracks ?? this.totalTracks,
      isLiked: isLiked ?? this.isLiked,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (spotifyId.present) {
      map['spotify_id'] = Variable<String>(spotifyId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (artistId.present) {
      map['artist_id'] = Variable<String>(artistId.value);
    }
    if (artistName.present) {
      map['artist_name'] = Variable<String>(artistName.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (releaseDate.present) {
      map['release_date'] = Variable<String>(releaseDate.value);
    }
    if (totalTracks.present) {
      map['total_tracks'] = Variable<int>(totalTracks.value);
    }
    if (isLiked.present) {
      map['is_liked'] = Variable<bool>(isLiked.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AlbumsCompanion(')
          ..write('spotifyId: $spotifyId, ')
          ..write('name: $name, ')
          ..write('artistId: $artistId, ')
          ..write('artistName: $artistName, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('releaseDate: $releaseDate, ')
          ..write('totalTracks: $totalTracks, ')
          ..write('isLiked: $isLiked, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlaylistsTable extends Playlists
    with TableInfo<$PlaylistsTable, Playlist> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlaylistsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _spotifyIdMeta = const VerificationMeta(
    'spotifyId',
  );
  @override
  late final GeneratedColumn<String> spotifyId = GeneratedColumn<String>(
    'spotify_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    spotifyId,
    imageUrl,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'playlists';
  @override
  VerificationContext validateIntegrity(
    Insertable<Playlist> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('spotify_id')) {
      context.handle(
        _spotifyIdMeta,
        spotifyId.isAcceptableOrUnknown(data['spotify_id']!, _spotifyIdMeta),
      );
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Playlist map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Playlist(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      spotifyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}spotify_id'],
      ),
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
    );
  }

  @override
  $PlaylistsTable createAlias(String alias) {
    return $PlaylistsTable(attachedDatabase, alias);
  }
}

class Playlist extends DataClass implements Insertable<Playlist> {
  final int id;
  final String name;
  final String? spotifyId;
  final String? imageUrl;
  final DateTime createdAt;
  const Playlist({
    required this.id,
    required this.name,
    this.spotifyId,
    this.imageUrl,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || spotifyId != null) {
      map['spotify_id'] = Variable<String>(spotifyId);
    }
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PlaylistsCompanion toCompanion(bool nullToAbsent) {
    return PlaylistsCompanion(
      id: Value(id),
      name: Value(name),
      spotifyId:
          spotifyId == null && nullToAbsent
              ? const Value.absent()
              : Value(spotifyId),
      imageUrl:
          imageUrl == null && nullToAbsent
              ? const Value.absent()
              : Value(imageUrl),
      createdAt: Value(createdAt),
    );
  }

  factory Playlist.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Playlist(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      spotifyId: serializer.fromJson<String?>(json['spotifyId']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'spotifyId': serializer.toJson<String?>(spotifyId),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Playlist copyWith({
    int? id,
    String? name,
    Value<String?> spotifyId = const Value.absent(),
    Value<String?> imageUrl = const Value.absent(),
    DateTime? createdAt,
  }) => Playlist(
    id: id ?? this.id,
    name: name ?? this.name,
    spotifyId: spotifyId.present ? spotifyId.value : this.spotifyId,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    createdAt: createdAt ?? this.createdAt,
  );
  Playlist copyWithCompanion(PlaylistsCompanion data) {
    return Playlist(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      spotifyId: data.spotifyId.present ? data.spotifyId.value : this.spotifyId,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Playlist(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('spotifyId: $spotifyId, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, spotifyId, imageUrl, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Playlist &&
          other.id == this.id &&
          other.name == this.name &&
          other.spotifyId == this.spotifyId &&
          other.imageUrl == this.imageUrl &&
          other.createdAt == this.createdAt);
}

class PlaylistsCompanion extends UpdateCompanion<Playlist> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> spotifyId;
  final Value<String?> imageUrl;
  final Value<DateTime> createdAt;
  const PlaylistsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.spotifyId = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PlaylistsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.spotifyId = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Playlist> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? spotifyId,
    Expression<String>? imageUrl,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (spotifyId != null) 'spotify_id': spotifyId,
      if (imageUrl != null) 'image_url': imageUrl,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PlaylistsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? spotifyId,
    Value<String?>? imageUrl,
    Value<DateTime>? createdAt,
  }) {
    return PlaylistsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      spotifyId: spotifyId ?? this.spotifyId,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (spotifyId.present) {
      map['spotify_id'] = Variable<String>(spotifyId.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlaylistsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('spotifyId: $spotifyId, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $PlaylistTracksTable extends PlaylistTracks
    with TableInfo<$PlaylistTracksTable, PlaylistTrack> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlaylistTracksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _playlistIdMeta = const VerificationMeta(
    'playlistId',
  );
  @override
  late final GeneratedColumn<int> playlistId = GeneratedColumn<int>(
    'playlist_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _trackSpotifyIdMeta = const VerificationMeta(
    'trackSpotifyId',
  );
  @override
  late final GeneratedColumn<String> trackSpotifyId = GeneratedColumn<String>(
    'track_spotify_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [playlistId, trackSpotifyId, position];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'playlist_tracks';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlaylistTrack> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('playlist_id')) {
      context.handle(
        _playlistIdMeta,
        playlistId.isAcceptableOrUnknown(data['playlist_id']!, _playlistIdMeta),
      );
    } else if (isInserting) {
      context.missing(_playlistIdMeta);
    }
    if (data.containsKey('track_spotify_id')) {
      context.handle(
        _trackSpotifyIdMeta,
        trackSpotifyId.isAcceptableOrUnknown(
          data['track_spotify_id']!,
          _trackSpotifyIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_trackSpotifyIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {playlistId, trackSpotifyId};
  @override
  PlaylistTrack map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlaylistTrack(
      playlistId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}playlist_id'],
          )!,
      trackSpotifyId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}track_spotify_id'],
          )!,
      position:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}position'],
          )!,
    );
  }

  @override
  $PlaylistTracksTable createAlias(String alias) {
    return $PlaylistTracksTable(attachedDatabase, alias);
  }
}

class PlaylistTrack extends DataClass implements Insertable<PlaylistTrack> {
  final int playlistId;
  final String trackSpotifyId;
  final int position;
  const PlaylistTrack({
    required this.playlistId,
    required this.trackSpotifyId,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['playlist_id'] = Variable<int>(playlistId);
    map['track_spotify_id'] = Variable<String>(trackSpotifyId);
    map['position'] = Variable<int>(position);
    return map;
  }

  PlaylistTracksCompanion toCompanion(bool nullToAbsent) {
    return PlaylistTracksCompanion(
      playlistId: Value(playlistId),
      trackSpotifyId: Value(trackSpotifyId),
      position: Value(position),
    );
  }

  factory PlaylistTrack.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlaylistTrack(
      playlistId: serializer.fromJson<int>(json['playlistId']),
      trackSpotifyId: serializer.fromJson<String>(json['trackSpotifyId']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'playlistId': serializer.toJson<int>(playlistId),
      'trackSpotifyId': serializer.toJson<String>(trackSpotifyId),
      'position': serializer.toJson<int>(position),
    };
  }

  PlaylistTrack copyWith({
    int? playlistId,
    String? trackSpotifyId,
    int? position,
  }) => PlaylistTrack(
    playlistId: playlistId ?? this.playlistId,
    trackSpotifyId: trackSpotifyId ?? this.trackSpotifyId,
    position: position ?? this.position,
  );
  PlaylistTrack copyWithCompanion(PlaylistTracksCompanion data) {
    return PlaylistTrack(
      playlistId:
          data.playlistId.present ? data.playlistId.value : this.playlistId,
      trackSpotifyId:
          data.trackSpotifyId.present
              ? data.trackSpotifyId.value
              : this.trackSpotifyId,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlaylistTrack(')
          ..write('playlistId: $playlistId, ')
          ..write('trackSpotifyId: $trackSpotifyId, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(playlistId, trackSpotifyId, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlaylistTrack &&
          other.playlistId == this.playlistId &&
          other.trackSpotifyId == this.trackSpotifyId &&
          other.position == this.position);
}

class PlaylistTracksCompanion extends UpdateCompanion<PlaylistTrack> {
  final Value<int> playlistId;
  final Value<String> trackSpotifyId;
  final Value<int> position;
  final Value<int> rowid;
  const PlaylistTracksCompanion({
    this.playlistId = const Value.absent(),
    this.trackSpotifyId = const Value.absent(),
    this.position = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlaylistTracksCompanion.insert({
    required int playlistId,
    required String trackSpotifyId,
    required int position,
    this.rowid = const Value.absent(),
  }) : playlistId = Value(playlistId),
       trackSpotifyId = Value(trackSpotifyId),
       position = Value(position);
  static Insertable<PlaylistTrack> custom({
    Expression<int>? playlistId,
    Expression<String>? trackSpotifyId,
    Expression<int>? position,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (playlistId != null) 'playlist_id': playlistId,
      if (trackSpotifyId != null) 'track_spotify_id': trackSpotifyId,
      if (position != null) 'position': position,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlaylistTracksCompanion copyWith({
    Value<int>? playlistId,
    Value<String>? trackSpotifyId,
    Value<int>? position,
    Value<int>? rowid,
  }) {
    return PlaylistTracksCompanion(
      playlistId: playlistId ?? this.playlistId,
      trackSpotifyId: trackSpotifyId ?? this.trackSpotifyId,
      position: position ?? this.position,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (playlistId.present) {
      map['playlist_id'] = Variable<int>(playlistId.value);
    }
    if (trackSpotifyId.present) {
      map['track_spotify_id'] = Variable<String>(trackSpotifyId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlaylistTracksCompanion(')
          ..write('playlistId: $playlistId, ')
          ..write('trackSpotifyId: $trackSpotifyId, ')
          ..write('position: $position, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RadiosTable extends Radios with TableInfo<$RadiosTable, Radio> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RadiosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _seedIdMeta = const VerificationMeta('seedId');
  @override
  late final GeneratedColumn<String> seedId = GeneratedColumn<String>(
    'seed_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _seedTypeMeta = const VerificationMeta(
    'seedType',
  );
  @override
  late final GeneratedColumn<String> seedType = GeneratedColumn<String>(
    'seed_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isFollowedMeta = const VerificationMeta(
    'isFollowed',
  );
  @override
  late final GeneratedColumn<bool> isFollowed = GeneratedColumn<bool>(
    'is_followed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_followed" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    seedId,
    seedType,
    title,
    imageUrl,
    isFollowed,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'radios';
  @override
  VerificationContext validateIntegrity(
    Insertable<Radio> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('seed_id')) {
      context.handle(
        _seedIdMeta,
        seedId.isAcceptableOrUnknown(data['seed_id']!, _seedIdMeta),
      );
    } else if (isInserting) {
      context.missing(_seedIdMeta);
    }
    if (data.containsKey('seed_type')) {
      context.handle(
        _seedTypeMeta,
        seedType.isAcceptableOrUnknown(data['seed_type']!, _seedTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_seedTypeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('is_followed')) {
      context.handle(
        _isFollowedMeta,
        isFollowed.isAcceptableOrUnknown(data['is_followed']!, _isFollowedMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {seedId, seedType};
  @override
  Radio map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Radio(
      seedId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}seed_id'],
          )!,
      seedType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}seed_type'],
          )!,
      title:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}title'],
          )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      isFollowed:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_followed'],
          )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $RadiosTable createAlias(String alias) {
    return $RadiosTable(attachedDatabase, alias);
  }
}

class Radio extends DataClass implements Insertable<Radio> {
  final String seedId;
  final String seedType;
  final String title;
  final String? imageUrl;
  final bool isFollowed;
  final DateTime? updatedAt;
  const Radio({
    required this.seedId,
    required this.seedType,
    required this.title,
    this.imageUrl,
    required this.isFollowed,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['seed_id'] = Variable<String>(seedId);
    map['seed_type'] = Variable<String>(seedType);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    map['is_followed'] = Variable<bool>(isFollowed);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  RadiosCompanion toCompanion(bool nullToAbsent) {
    return RadiosCompanion(
      seedId: Value(seedId),
      seedType: Value(seedType),
      title: Value(title),
      imageUrl:
          imageUrl == null && nullToAbsent
              ? const Value.absent()
              : Value(imageUrl),
      isFollowed: Value(isFollowed),
      updatedAt:
          updatedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(updatedAt),
    );
  }

  factory Radio.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Radio(
      seedId: serializer.fromJson<String>(json['seedId']),
      seedType: serializer.fromJson<String>(json['seedType']),
      title: serializer.fromJson<String>(json['title']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      isFollowed: serializer.fromJson<bool>(json['isFollowed']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'seedId': serializer.toJson<String>(seedId),
      'seedType': serializer.toJson<String>(seedType),
      'title': serializer.toJson<String>(title),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'isFollowed': serializer.toJson<bool>(isFollowed),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  Radio copyWith({
    String? seedId,
    String? seedType,
    String? title,
    Value<String?> imageUrl = const Value.absent(),
    bool? isFollowed,
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => Radio(
    seedId: seedId ?? this.seedId,
    seedType: seedType ?? this.seedType,
    title: title ?? this.title,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    isFollowed: isFollowed ?? this.isFollowed,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  Radio copyWithCompanion(RadiosCompanion data) {
    return Radio(
      seedId: data.seedId.present ? data.seedId.value : this.seedId,
      seedType: data.seedType.present ? data.seedType.value : this.seedType,
      title: data.title.present ? data.title.value : this.title,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      isFollowed:
          data.isFollowed.present ? data.isFollowed.value : this.isFollowed,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Radio(')
          ..write('seedId: $seedId, ')
          ..write('seedType: $seedType, ')
          ..write('title: $title, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('isFollowed: $isFollowed, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(seedId, seedType, title, imageUrl, isFollowed, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Radio &&
          other.seedId == this.seedId &&
          other.seedType == this.seedType &&
          other.title == this.title &&
          other.imageUrl == this.imageUrl &&
          other.isFollowed == this.isFollowed &&
          other.updatedAt == this.updatedAt);
}

class RadiosCompanion extends UpdateCompanion<Radio> {
  final Value<String> seedId;
  final Value<String> seedType;
  final Value<String> title;
  final Value<String?> imageUrl;
  final Value<bool> isFollowed;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const RadiosCompanion({
    this.seedId = const Value.absent(),
    this.seedType = const Value.absent(),
    this.title = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.isFollowed = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RadiosCompanion.insert({
    required String seedId,
    required String seedType,
    required String title,
    this.imageUrl = const Value.absent(),
    this.isFollowed = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : seedId = Value(seedId),
       seedType = Value(seedType),
       title = Value(title);
  static Insertable<Radio> custom({
    Expression<String>? seedId,
    Expression<String>? seedType,
    Expression<String>? title,
    Expression<String>? imageUrl,
    Expression<bool>? isFollowed,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (seedId != null) 'seed_id': seedId,
      if (seedType != null) 'seed_type': seedType,
      if (title != null) 'title': title,
      if (imageUrl != null) 'image_url': imageUrl,
      if (isFollowed != null) 'is_followed': isFollowed,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RadiosCompanion copyWith({
    Value<String>? seedId,
    Value<String>? seedType,
    Value<String>? title,
    Value<String?>? imageUrl,
    Value<bool>? isFollowed,
    Value<DateTime?>? updatedAt,
    Value<int>? rowid,
  }) {
    return RadiosCompanion(
      seedId: seedId ?? this.seedId,
      seedType: seedType ?? this.seedType,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      isFollowed: isFollowed ?? this.isFollowed,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (seedId.present) {
      map['seed_id'] = Variable<String>(seedId.value);
    }
    if (seedType.present) {
      map['seed_type'] = Variable<String>(seedType.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (isFollowed.present) {
      map['is_followed'] = Variable<bool>(isFollowed.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RadiosCompanion(')
          ..write('seedId: $seedId, ')
          ..write('seedType: $seedType, ')
          ..write('title: $title, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('isFollowed: $isFollowed, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CatalogCacheEntriesTable extends CatalogCacheEntries
    with TableInfo<$CatalogCacheEntriesTable, CatalogCacheEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CatalogCacheEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fetchedAtMeta = const VerificationMeta(
    'fetchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
    'fetched_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastAccessedAtMeta = const VerificationMeta(
    'lastAccessedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastAccessedAt =
      GeneratedColumn<DateTime>(
        'last_accessed_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _payloadVersionMeta = const VerificationMeta(
    'payloadVersion',
  );
  @override
  late final GeneratedColumn<int> payloadVersion = GeneratedColumn<int>(
    'payload_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _resourceTypeMeta = const VerificationMeta(
    'resourceType',
  );
  @override
  late final GeneratedColumn<String> resourceType = GeneratedColumn<String>(
    'resource_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    key,
    payload,
    fetchedAt,
    lastAccessedAt,
    payloadVersion,
    resourceType,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'catalog_cache_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<CatalogCacheEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('fetched_at')) {
      context.handle(
        _fetchedAtMeta,
        fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_fetchedAtMeta);
    }
    if (data.containsKey('last_accessed_at')) {
      context.handle(
        _lastAccessedAtMeta,
        lastAccessedAt.isAcceptableOrUnknown(
          data['last_accessed_at']!,
          _lastAccessedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastAccessedAtMeta);
    }
    if (data.containsKey('payload_version')) {
      context.handle(
        _payloadVersionMeta,
        payloadVersion.isAcceptableOrUnknown(
          data['payload_version']!,
          _payloadVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadVersionMeta);
    }
    if (data.containsKey('resource_type')) {
      context.handle(
        _resourceTypeMeta,
        resourceType.isAcceptableOrUnknown(
          data['resource_type']!,
          _resourceTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_resourceTypeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  CatalogCacheEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CatalogCacheEntry(
      key:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}key'],
          )!,
      payload:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}payload'],
          )!,
      fetchedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}fetched_at'],
          )!,
      lastAccessedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}last_accessed_at'],
          )!,
      payloadVersion:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}payload_version'],
          )!,
      resourceType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}resource_type'],
          )!,
    );
  }

  @override
  $CatalogCacheEntriesTable createAlias(String alias) {
    return $CatalogCacheEntriesTable(attachedDatabase, alias);
  }
}

class CatalogCacheEntry extends DataClass
    implements Insertable<CatalogCacheEntry> {
  final String key;
  final String payload;
  final DateTime fetchedAt;
  final DateTime lastAccessedAt;
  final int payloadVersion;
  final String resourceType;
  const CatalogCacheEntry({
    required this.key,
    required this.payload,
    required this.fetchedAt,
    required this.lastAccessedAt,
    required this.payloadVersion,
    required this.resourceType,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['payload'] = Variable<String>(payload);
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    map['last_accessed_at'] = Variable<DateTime>(lastAccessedAt);
    map['payload_version'] = Variable<int>(payloadVersion);
    map['resource_type'] = Variable<String>(resourceType);
    return map;
  }

  CatalogCacheEntriesCompanion toCompanion(bool nullToAbsent) {
    return CatalogCacheEntriesCompanion(
      key: Value(key),
      payload: Value(payload),
      fetchedAt: Value(fetchedAt),
      lastAccessedAt: Value(lastAccessedAt),
      payloadVersion: Value(payloadVersion),
      resourceType: Value(resourceType),
    );
  }

  factory CatalogCacheEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CatalogCacheEntry(
      key: serializer.fromJson<String>(json['key']),
      payload: serializer.fromJson<String>(json['payload']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
      lastAccessedAt: serializer.fromJson<DateTime>(json['lastAccessedAt']),
      payloadVersion: serializer.fromJson<int>(json['payloadVersion']),
      resourceType: serializer.fromJson<String>(json['resourceType']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'payload': serializer.toJson<String>(payload),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
      'lastAccessedAt': serializer.toJson<DateTime>(lastAccessedAt),
      'payloadVersion': serializer.toJson<int>(payloadVersion),
      'resourceType': serializer.toJson<String>(resourceType),
    };
  }

  CatalogCacheEntry copyWith({
    String? key,
    String? payload,
    DateTime? fetchedAt,
    DateTime? lastAccessedAt,
    int? payloadVersion,
    String? resourceType,
  }) => CatalogCacheEntry(
    key: key ?? this.key,
    payload: payload ?? this.payload,
    fetchedAt: fetchedAt ?? this.fetchedAt,
    lastAccessedAt: lastAccessedAt ?? this.lastAccessedAt,
    payloadVersion: payloadVersion ?? this.payloadVersion,
    resourceType: resourceType ?? this.resourceType,
  );
  CatalogCacheEntry copyWithCompanion(CatalogCacheEntriesCompanion data) {
    return CatalogCacheEntry(
      key: data.key.present ? data.key.value : this.key,
      payload: data.payload.present ? data.payload.value : this.payload,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
      lastAccessedAt:
          data.lastAccessedAt.present
              ? data.lastAccessedAt.value
              : this.lastAccessedAt,
      payloadVersion:
          data.payloadVersion.present
              ? data.payloadVersion.value
              : this.payloadVersion,
      resourceType:
          data.resourceType.present
              ? data.resourceType.value
              : this.resourceType,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CatalogCacheEntry(')
          ..write('key: $key, ')
          ..write('payload: $payload, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('lastAccessedAt: $lastAccessedAt, ')
          ..write('payloadVersion: $payloadVersion, ')
          ..write('resourceType: $resourceType')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    key,
    payload,
    fetchedAt,
    lastAccessedAt,
    payloadVersion,
    resourceType,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CatalogCacheEntry &&
          other.key == this.key &&
          other.payload == this.payload &&
          other.fetchedAt == this.fetchedAt &&
          other.lastAccessedAt == this.lastAccessedAt &&
          other.payloadVersion == this.payloadVersion &&
          other.resourceType == this.resourceType);
}

class CatalogCacheEntriesCompanion extends UpdateCompanion<CatalogCacheEntry> {
  final Value<String> key;
  final Value<String> payload;
  final Value<DateTime> fetchedAt;
  final Value<DateTime> lastAccessedAt;
  final Value<int> payloadVersion;
  final Value<String> resourceType;
  final Value<int> rowid;
  const CatalogCacheEntriesCompanion({
    this.key = const Value.absent(),
    this.payload = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.lastAccessedAt = const Value.absent(),
    this.payloadVersion = const Value.absent(),
    this.resourceType = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CatalogCacheEntriesCompanion.insert({
    required String key,
    required String payload,
    required DateTime fetchedAt,
    required DateTime lastAccessedAt,
    required int payloadVersion,
    required String resourceType,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       payload = Value(payload),
       fetchedAt = Value(fetchedAt),
       lastAccessedAt = Value(lastAccessedAt),
       payloadVersion = Value(payloadVersion),
       resourceType = Value(resourceType);
  static Insertable<CatalogCacheEntry> custom({
    Expression<String>? key,
    Expression<String>? payload,
    Expression<DateTime>? fetchedAt,
    Expression<DateTime>? lastAccessedAt,
    Expression<int>? payloadVersion,
    Expression<String>? resourceType,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (payload != null) 'payload': payload,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (lastAccessedAt != null) 'last_accessed_at': lastAccessedAt,
      if (payloadVersion != null) 'payload_version': payloadVersion,
      if (resourceType != null) 'resource_type': resourceType,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CatalogCacheEntriesCompanion copyWith({
    Value<String>? key,
    Value<String>? payload,
    Value<DateTime>? fetchedAt,
    Value<DateTime>? lastAccessedAt,
    Value<int>? payloadVersion,
    Value<String>? resourceType,
    Value<int>? rowid,
  }) {
    return CatalogCacheEntriesCompanion(
      key: key ?? this.key,
      payload: payload ?? this.payload,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      lastAccessedAt: lastAccessedAt ?? this.lastAccessedAt,
      payloadVersion: payloadVersion ?? this.payloadVersion,
      resourceType: resourceType ?? this.resourceType,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (lastAccessedAt.present) {
      map['last_accessed_at'] = Variable<DateTime>(lastAccessedAt.value);
    }
    if (payloadVersion.present) {
      map['payload_version'] = Variable<int>(payloadVersion.value);
    }
    if (resourceType.present) {
      map['resource_type'] = Variable<String>(resourceType.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CatalogCacheEntriesCompanion(')
          ..write('key: $key, ')
          ..write('payload: $payload, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('lastAccessedAt: $lastAccessedAt, ')
          ..write('payloadVersion: $payloadVersion, ')
          ..write('resourceType: $resourceType, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TracksTable tracks = $TracksTable(this);
  late final $ArtistsTable artists = $ArtistsTable(this);
  late final $AlbumsTable albums = $AlbumsTable(this);
  late final $PlaylistsTable playlists = $PlaylistsTable(this);
  late final $PlaylistTracksTable playlistTracks = $PlaylistTracksTable(this);
  late final $RadiosTable radios = $RadiosTable(this);
  late final $CatalogCacheEntriesTable catalogCacheEntries =
      $CatalogCacheEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    tracks,
    artists,
    albums,
    playlists,
    playlistTracks,
    radios,
    catalogCacheEntries,
  ];
}

typedef $$TracksTableCreateCompanionBuilder =
    TracksCompanion Function({
      required String spotifyId,
      required String name,
      required String artistId,
      required String artistName,
      Value<String?> albumId,
      Value<String?> albumName,
      Value<String?> albumImage,
      Value<int?> durationMs,
      Value<String?> youtubeVideoId,
      Value<DateTime?> youtubeResolvedAt,
      Value<int> playCount,
      Value<bool> isFavorite,
      Value<DateTime?> lastPlayedAt,
      Value<int> rowid,
    });
typedef $$TracksTableUpdateCompanionBuilder =
    TracksCompanion Function({
      Value<String> spotifyId,
      Value<String> name,
      Value<String> artistId,
      Value<String> artistName,
      Value<String?> albumId,
      Value<String?> albumName,
      Value<String?> albumImage,
      Value<int?> durationMs,
      Value<String?> youtubeVideoId,
      Value<DateTime?> youtubeResolvedAt,
      Value<int> playCount,
      Value<bool> isFavorite,
      Value<DateTime?> lastPlayedAt,
      Value<int> rowid,
    });

class $$TracksTableFilterComposer
    extends Composer<_$AppDatabase, $TracksTable> {
  $$TracksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get spotifyId => $composableBuilder(
    column: $table.spotifyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get artistId => $composableBuilder(
    column: $table.artistId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get artistName => $composableBuilder(
    column: $table.artistName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get albumId => $composableBuilder(
    column: $table.albumId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get albumName => $composableBuilder(
    column: $table.albumName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get albumImage => $composableBuilder(
    column: $table.albumImage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get youtubeVideoId => $composableBuilder(
    column: $table.youtubeVideoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get youtubeResolvedAt => $composableBuilder(
    column: $table.youtubeResolvedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get playCount => $composableBuilder(
    column: $table.playCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastPlayedAt => $composableBuilder(
    column: $table.lastPlayedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TracksTableOrderingComposer
    extends Composer<_$AppDatabase, $TracksTable> {
  $$TracksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get spotifyId => $composableBuilder(
    column: $table.spotifyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get artistId => $composableBuilder(
    column: $table.artistId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get artistName => $composableBuilder(
    column: $table.artistName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get albumId => $composableBuilder(
    column: $table.albumId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get albumName => $composableBuilder(
    column: $table.albumName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get albumImage => $composableBuilder(
    column: $table.albumImage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get youtubeVideoId => $composableBuilder(
    column: $table.youtubeVideoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get youtubeResolvedAt => $composableBuilder(
    column: $table.youtubeResolvedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get playCount => $composableBuilder(
    column: $table.playCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastPlayedAt => $composableBuilder(
    column: $table.lastPlayedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TracksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TracksTable> {
  $$TracksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get spotifyId =>
      $composableBuilder(column: $table.spotifyId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get artistId =>
      $composableBuilder(column: $table.artistId, builder: (column) => column);

  GeneratedColumn<String> get artistName => $composableBuilder(
    column: $table.artistName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get albumId =>
      $composableBuilder(column: $table.albumId, builder: (column) => column);

  GeneratedColumn<String> get albumName =>
      $composableBuilder(column: $table.albumName, builder: (column) => column);

  GeneratedColumn<String> get albumImage => $composableBuilder(
    column: $table.albumImage,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get youtubeVideoId => $composableBuilder(
    column: $table.youtubeVideoId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get youtubeResolvedAt => $composableBuilder(
    column: $table.youtubeResolvedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get playCount =>
      $composableBuilder(column: $table.playCount, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastPlayedAt => $composableBuilder(
    column: $table.lastPlayedAt,
    builder: (column) => column,
  );
}

class $$TracksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TracksTable,
          Track,
          $$TracksTableFilterComposer,
          $$TracksTableOrderingComposer,
          $$TracksTableAnnotationComposer,
          $$TracksTableCreateCompanionBuilder,
          $$TracksTableUpdateCompanionBuilder,
          (Track, BaseReferences<_$AppDatabase, $TracksTable, Track>),
          Track,
          PrefetchHooks Function()
        > {
  $$TracksTableTableManager(_$AppDatabase db, $TracksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$TracksTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$TracksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$TracksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> spotifyId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> artistId = const Value.absent(),
                Value<String> artistName = const Value.absent(),
                Value<String?> albumId = const Value.absent(),
                Value<String?> albumName = const Value.absent(),
                Value<String?> albumImage = const Value.absent(),
                Value<int?> durationMs = const Value.absent(),
                Value<String?> youtubeVideoId = const Value.absent(),
                Value<DateTime?> youtubeResolvedAt = const Value.absent(),
                Value<int> playCount = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<DateTime?> lastPlayedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TracksCompanion(
                spotifyId: spotifyId,
                name: name,
                artistId: artistId,
                artistName: artistName,
                albumId: albumId,
                albumName: albumName,
                albumImage: albumImage,
                durationMs: durationMs,
                youtubeVideoId: youtubeVideoId,
                youtubeResolvedAt: youtubeResolvedAt,
                playCount: playCount,
                isFavorite: isFavorite,
                lastPlayedAt: lastPlayedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String spotifyId,
                required String name,
                required String artistId,
                required String artistName,
                Value<String?> albumId = const Value.absent(),
                Value<String?> albumName = const Value.absent(),
                Value<String?> albumImage = const Value.absent(),
                Value<int?> durationMs = const Value.absent(),
                Value<String?> youtubeVideoId = const Value.absent(),
                Value<DateTime?> youtubeResolvedAt = const Value.absent(),
                Value<int> playCount = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<DateTime?> lastPlayedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TracksCompanion.insert(
                spotifyId: spotifyId,
                name: name,
                artistId: artistId,
                artistName: artistName,
                albumId: albumId,
                albumName: albumName,
                albumImage: albumImage,
                durationMs: durationMs,
                youtubeVideoId: youtubeVideoId,
                youtubeResolvedAt: youtubeResolvedAt,
                playCount: playCount,
                isFavorite: isFavorite,
                lastPlayedAt: lastPlayedAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable<$TracksTable, Track>(table),
                          BaseReferences<_$AppDatabase, $TracksTable, Track>(
                            db,
                            table,
                            e,
                          ),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TracksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TracksTable,
      Track,
      $$TracksTableFilterComposer,
      $$TracksTableOrderingComposer,
      $$TracksTableAnnotationComposer,
      $$TracksTableCreateCompanionBuilder,
      $$TracksTableUpdateCompanionBuilder,
      (Track, BaseReferences<_$AppDatabase, $TracksTable, Track>),
      Track,
      PrefetchHooks Function()
    >;
typedef $$ArtistsTableCreateCompanionBuilder =
    ArtistsCompanion Function({
      required String spotifyId,
      required String name,
      Value<String?> imageUrl,
      Value<String?> imageSmall,
      Value<int?> followers,
      Value<bool> isFollowed,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });
typedef $$ArtistsTableUpdateCompanionBuilder =
    ArtistsCompanion Function({
      Value<String> spotifyId,
      Value<String> name,
      Value<String?> imageUrl,
      Value<String?> imageSmall,
      Value<int?> followers,
      Value<bool> isFollowed,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });

class $$ArtistsTableFilterComposer
    extends Composer<_$AppDatabase, $ArtistsTable> {
  $$ArtistsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get spotifyId => $composableBuilder(
    column: $table.spotifyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageSmall => $composableBuilder(
    column: $table.imageSmall,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get followers => $composableBuilder(
    column: $table.followers,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFollowed => $composableBuilder(
    column: $table.isFollowed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ArtistsTableOrderingComposer
    extends Composer<_$AppDatabase, $ArtistsTable> {
  $$ArtistsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get spotifyId => $composableBuilder(
    column: $table.spotifyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageSmall => $composableBuilder(
    column: $table.imageSmall,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get followers => $composableBuilder(
    column: $table.followers,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFollowed => $composableBuilder(
    column: $table.isFollowed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ArtistsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ArtistsTable> {
  $$ArtistsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get spotifyId =>
      $composableBuilder(column: $table.spotifyId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<String> get imageSmall => $composableBuilder(
    column: $table.imageSmall,
    builder: (column) => column,
  );

  GeneratedColumn<int> get followers =>
      $composableBuilder(column: $table.followers, builder: (column) => column);

  GeneratedColumn<bool> get isFollowed => $composableBuilder(
    column: $table.isFollowed,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ArtistsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ArtistsTable,
          Artist,
          $$ArtistsTableFilterComposer,
          $$ArtistsTableOrderingComposer,
          $$ArtistsTableAnnotationComposer,
          $$ArtistsTableCreateCompanionBuilder,
          $$ArtistsTableUpdateCompanionBuilder,
          (Artist, BaseReferences<_$AppDatabase, $ArtistsTable, Artist>),
          Artist,
          PrefetchHooks Function()
        > {
  $$ArtistsTableTableManager(_$AppDatabase db, $ArtistsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$ArtistsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$ArtistsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$ArtistsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> spotifyId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<String?> imageSmall = const Value.absent(),
                Value<int?> followers = const Value.absent(),
                Value<bool> isFollowed = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ArtistsCompanion(
                spotifyId: spotifyId,
                name: name,
                imageUrl: imageUrl,
                imageSmall: imageSmall,
                followers: followers,
                isFollowed: isFollowed,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String spotifyId,
                required String name,
                Value<String?> imageUrl = const Value.absent(),
                Value<String?> imageSmall = const Value.absent(),
                Value<int?> followers = const Value.absent(),
                Value<bool> isFollowed = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ArtistsCompanion.insert(
                spotifyId: spotifyId,
                name: name,
                imageUrl: imageUrl,
                imageSmall: imageSmall,
                followers: followers,
                isFollowed: isFollowed,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable<$ArtistsTable, Artist>(table),
                          BaseReferences<_$AppDatabase, $ArtistsTable, Artist>(
                            db,
                            table,
                            e,
                          ),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ArtistsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ArtistsTable,
      Artist,
      $$ArtistsTableFilterComposer,
      $$ArtistsTableOrderingComposer,
      $$ArtistsTableAnnotationComposer,
      $$ArtistsTableCreateCompanionBuilder,
      $$ArtistsTableUpdateCompanionBuilder,
      (Artist, BaseReferences<_$AppDatabase, $ArtistsTable, Artist>),
      Artist,
      PrefetchHooks Function()
    >;
typedef $$AlbumsTableCreateCompanionBuilder =
    AlbumsCompanion Function({
      required String spotifyId,
      required String name,
      required String artistId,
      required String artistName,
      Value<String?> imageUrl,
      Value<String?> releaseDate,
      Value<int?> totalTracks,
      Value<bool> isLiked,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });
typedef $$AlbumsTableUpdateCompanionBuilder =
    AlbumsCompanion Function({
      Value<String> spotifyId,
      Value<String> name,
      Value<String> artistId,
      Value<String> artistName,
      Value<String?> imageUrl,
      Value<String?> releaseDate,
      Value<int?> totalTracks,
      Value<bool> isLiked,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });

class $$AlbumsTableFilterComposer
    extends Composer<_$AppDatabase, $AlbumsTable> {
  $$AlbumsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get spotifyId => $composableBuilder(
    column: $table.spotifyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get artistId => $composableBuilder(
    column: $table.artistId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get artistName => $composableBuilder(
    column: $table.artistName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get releaseDate => $composableBuilder(
    column: $table.releaseDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalTracks => $composableBuilder(
    column: $table.totalTracks,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isLiked => $composableBuilder(
    column: $table.isLiked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AlbumsTableOrderingComposer
    extends Composer<_$AppDatabase, $AlbumsTable> {
  $$AlbumsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get spotifyId => $composableBuilder(
    column: $table.spotifyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get artistId => $composableBuilder(
    column: $table.artistId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get artistName => $composableBuilder(
    column: $table.artistName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get releaseDate => $composableBuilder(
    column: $table.releaseDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalTracks => $composableBuilder(
    column: $table.totalTracks,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isLiked => $composableBuilder(
    column: $table.isLiked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AlbumsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AlbumsTable> {
  $$AlbumsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get spotifyId =>
      $composableBuilder(column: $table.spotifyId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get artistId =>
      $composableBuilder(column: $table.artistId, builder: (column) => column);

  GeneratedColumn<String> get artistName => $composableBuilder(
    column: $table.artistName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<String> get releaseDate => $composableBuilder(
    column: $table.releaseDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalTracks => $composableBuilder(
    column: $table.totalTracks,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isLiked =>
      $composableBuilder(column: $table.isLiked, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AlbumsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AlbumsTable,
          Album,
          $$AlbumsTableFilterComposer,
          $$AlbumsTableOrderingComposer,
          $$AlbumsTableAnnotationComposer,
          $$AlbumsTableCreateCompanionBuilder,
          $$AlbumsTableUpdateCompanionBuilder,
          (Album, BaseReferences<_$AppDatabase, $AlbumsTable, Album>),
          Album,
          PrefetchHooks Function()
        > {
  $$AlbumsTableTableManager(_$AppDatabase db, $AlbumsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$AlbumsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$AlbumsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$AlbumsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> spotifyId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> artistId = const Value.absent(),
                Value<String> artistName = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<String?> releaseDate = const Value.absent(),
                Value<int?> totalTracks = const Value.absent(),
                Value<bool> isLiked = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AlbumsCompanion(
                spotifyId: spotifyId,
                name: name,
                artistId: artistId,
                artistName: artistName,
                imageUrl: imageUrl,
                releaseDate: releaseDate,
                totalTracks: totalTracks,
                isLiked: isLiked,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String spotifyId,
                required String name,
                required String artistId,
                required String artistName,
                Value<String?> imageUrl = const Value.absent(),
                Value<String?> releaseDate = const Value.absent(),
                Value<int?> totalTracks = const Value.absent(),
                Value<bool> isLiked = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AlbumsCompanion.insert(
                spotifyId: spotifyId,
                name: name,
                artistId: artistId,
                artistName: artistName,
                imageUrl: imageUrl,
                releaseDate: releaseDate,
                totalTracks: totalTracks,
                isLiked: isLiked,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable<$AlbumsTable, Album>(table),
                          BaseReferences<_$AppDatabase, $AlbumsTable, Album>(
                            db,
                            table,
                            e,
                          ),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AlbumsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AlbumsTable,
      Album,
      $$AlbumsTableFilterComposer,
      $$AlbumsTableOrderingComposer,
      $$AlbumsTableAnnotationComposer,
      $$AlbumsTableCreateCompanionBuilder,
      $$AlbumsTableUpdateCompanionBuilder,
      (Album, BaseReferences<_$AppDatabase, $AlbumsTable, Album>),
      Album,
      PrefetchHooks Function()
    >;
typedef $$PlaylistsTableCreateCompanionBuilder =
    PlaylistsCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> spotifyId,
      Value<String?> imageUrl,
      Value<DateTime> createdAt,
    });
typedef $$PlaylistsTableUpdateCompanionBuilder =
    PlaylistsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> spotifyId,
      Value<String?> imageUrl,
      Value<DateTime> createdAt,
    });

class $$PlaylistsTableFilterComposer
    extends Composer<_$AppDatabase, $PlaylistsTable> {
  $$PlaylistsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get spotifyId => $composableBuilder(
    column: $table.spotifyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PlaylistsTableOrderingComposer
    extends Composer<_$AppDatabase, $PlaylistsTable> {
  $$PlaylistsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get spotifyId => $composableBuilder(
    column: $table.spotifyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlaylistsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlaylistsTable> {
  $$PlaylistsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get spotifyId =>
      $composableBuilder(column: $table.spotifyId, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$PlaylistsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlaylistsTable,
          Playlist,
          $$PlaylistsTableFilterComposer,
          $$PlaylistsTableOrderingComposer,
          $$PlaylistsTableAnnotationComposer,
          $$PlaylistsTableCreateCompanionBuilder,
          $$PlaylistsTableUpdateCompanionBuilder,
          (Playlist, BaseReferences<_$AppDatabase, $PlaylistsTable, Playlist>),
          Playlist,
          PrefetchHooks Function()
        > {
  $$PlaylistsTableTableManager(_$AppDatabase db, $PlaylistsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$PlaylistsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$PlaylistsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$PlaylistsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> spotifyId = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PlaylistsCompanion(
                id: id,
                name: name,
                spotifyId: spotifyId,
                imageUrl: imageUrl,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> spotifyId = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PlaylistsCompanion.insert(
                id: id,
                name: name,
                spotifyId: spotifyId,
                imageUrl: imageUrl,
                createdAt: createdAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable<$PlaylistsTable, Playlist>(table),
                          BaseReferences<
                            _$AppDatabase,
                            $PlaylistsTable,
                            Playlist
                          >(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PlaylistsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlaylistsTable,
      Playlist,
      $$PlaylistsTableFilterComposer,
      $$PlaylistsTableOrderingComposer,
      $$PlaylistsTableAnnotationComposer,
      $$PlaylistsTableCreateCompanionBuilder,
      $$PlaylistsTableUpdateCompanionBuilder,
      (Playlist, BaseReferences<_$AppDatabase, $PlaylistsTable, Playlist>),
      Playlist,
      PrefetchHooks Function()
    >;
typedef $$PlaylistTracksTableCreateCompanionBuilder =
    PlaylistTracksCompanion Function({
      required int playlistId,
      required String trackSpotifyId,
      required int position,
      Value<int> rowid,
    });
typedef $$PlaylistTracksTableUpdateCompanionBuilder =
    PlaylistTracksCompanion Function({
      Value<int> playlistId,
      Value<String> trackSpotifyId,
      Value<int> position,
      Value<int> rowid,
    });

class $$PlaylistTracksTableFilterComposer
    extends Composer<_$AppDatabase, $PlaylistTracksTable> {
  $$PlaylistTracksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get playlistId => $composableBuilder(
    column: $table.playlistId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trackSpotifyId => $composableBuilder(
    column: $table.trackSpotifyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PlaylistTracksTableOrderingComposer
    extends Composer<_$AppDatabase, $PlaylistTracksTable> {
  $$PlaylistTracksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get playlistId => $composableBuilder(
    column: $table.playlistId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trackSpotifyId => $composableBuilder(
    column: $table.trackSpotifyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlaylistTracksTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlaylistTracksTable> {
  $$PlaylistTracksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get playlistId => $composableBuilder(
    column: $table.playlistId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get trackSpotifyId => $composableBuilder(
    column: $table.trackSpotifyId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);
}

class $$PlaylistTracksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlaylistTracksTable,
          PlaylistTrack,
          $$PlaylistTracksTableFilterComposer,
          $$PlaylistTracksTableOrderingComposer,
          $$PlaylistTracksTableAnnotationComposer,
          $$PlaylistTracksTableCreateCompanionBuilder,
          $$PlaylistTracksTableUpdateCompanionBuilder,
          (
            PlaylistTrack,
            BaseReferences<_$AppDatabase, $PlaylistTracksTable, PlaylistTrack>,
          ),
          PlaylistTrack,
          PrefetchHooks Function()
        > {
  $$PlaylistTracksTableTableManager(
    _$AppDatabase db,
    $PlaylistTracksTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$PlaylistTracksTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $$PlaylistTracksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$PlaylistTracksTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> playlistId = const Value.absent(),
                Value<String> trackSpotifyId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlaylistTracksCompanion(
                playlistId: playlistId,
                trackSpotifyId: trackSpotifyId,
                position: position,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int playlistId,
                required String trackSpotifyId,
                required int position,
                Value<int> rowid = const Value.absent(),
              }) => PlaylistTracksCompanion.insert(
                playlistId: playlistId,
                trackSpotifyId: trackSpotifyId,
                position: position,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable<$PlaylistTracksTable, PlaylistTrack>(
                            table,
                          ),
                          BaseReferences<
                            _$AppDatabase,
                            $PlaylistTracksTable,
                            PlaylistTrack
                          >(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PlaylistTracksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlaylistTracksTable,
      PlaylistTrack,
      $$PlaylistTracksTableFilterComposer,
      $$PlaylistTracksTableOrderingComposer,
      $$PlaylistTracksTableAnnotationComposer,
      $$PlaylistTracksTableCreateCompanionBuilder,
      $$PlaylistTracksTableUpdateCompanionBuilder,
      (
        PlaylistTrack,
        BaseReferences<_$AppDatabase, $PlaylistTracksTable, PlaylistTrack>,
      ),
      PlaylistTrack,
      PrefetchHooks Function()
    >;
typedef $$RadiosTableCreateCompanionBuilder =
    RadiosCompanion Function({
      required String seedId,
      required String seedType,
      required String title,
      Value<String?> imageUrl,
      Value<bool> isFollowed,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });
typedef $$RadiosTableUpdateCompanionBuilder =
    RadiosCompanion Function({
      Value<String> seedId,
      Value<String> seedType,
      Value<String> title,
      Value<String?> imageUrl,
      Value<bool> isFollowed,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });

class $$RadiosTableFilterComposer
    extends Composer<_$AppDatabase, $RadiosTable> {
  $$RadiosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get seedId => $composableBuilder(
    column: $table.seedId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get seedType => $composableBuilder(
    column: $table.seedType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFollowed => $composableBuilder(
    column: $table.isFollowed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RadiosTableOrderingComposer
    extends Composer<_$AppDatabase, $RadiosTable> {
  $$RadiosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get seedId => $composableBuilder(
    column: $table.seedId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get seedType => $composableBuilder(
    column: $table.seedType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFollowed => $composableBuilder(
    column: $table.isFollowed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RadiosTableAnnotationComposer
    extends Composer<_$AppDatabase, $RadiosTable> {
  $$RadiosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get seedId =>
      $composableBuilder(column: $table.seedId, builder: (column) => column);

  GeneratedColumn<String> get seedType =>
      $composableBuilder(column: $table.seedType, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<bool> get isFollowed => $composableBuilder(
    column: $table.isFollowed,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$RadiosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RadiosTable,
          Radio,
          $$RadiosTableFilterComposer,
          $$RadiosTableOrderingComposer,
          $$RadiosTableAnnotationComposer,
          $$RadiosTableCreateCompanionBuilder,
          $$RadiosTableUpdateCompanionBuilder,
          (Radio, BaseReferences<_$AppDatabase, $RadiosTable, Radio>),
          Radio,
          PrefetchHooks Function()
        > {
  $$RadiosTableTableManager(_$AppDatabase db, $RadiosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$RadiosTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$RadiosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$RadiosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> seedId = const Value.absent(),
                Value<String> seedType = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<bool> isFollowed = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RadiosCompanion(
                seedId: seedId,
                seedType: seedType,
                title: title,
                imageUrl: imageUrl,
                isFollowed: isFollowed,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String seedId,
                required String seedType,
                required String title,
                Value<String?> imageUrl = const Value.absent(),
                Value<bool> isFollowed = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RadiosCompanion.insert(
                seedId: seedId,
                seedType: seedType,
                title: title,
                imageUrl: imageUrl,
                isFollowed: isFollowed,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable<$RadiosTable, Radio>(table),
                          BaseReferences<_$AppDatabase, $RadiosTable, Radio>(
                            db,
                            table,
                            e,
                          ),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RadiosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RadiosTable,
      Radio,
      $$RadiosTableFilterComposer,
      $$RadiosTableOrderingComposer,
      $$RadiosTableAnnotationComposer,
      $$RadiosTableCreateCompanionBuilder,
      $$RadiosTableUpdateCompanionBuilder,
      (Radio, BaseReferences<_$AppDatabase, $RadiosTable, Radio>),
      Radio,
      PrefetchHooks Function()
    >;
typedef $$CatalogCacheEntriesTableCreateCompanionBuilder =
    CatalogCacheEntriesCompanion Function({
      required String key,
      required String payload,
      required DateTime fetchedAt,
      required DateTime lastAccessedAt,
      required int payloadVersion,
      required String resourceType,
      Value<int> rowid,
    });
typedef $$CatalogCacheEntriesTableUpdateCompanionBuilder =
    CatalogCacheEntriesCompanion Function({
      Value<String> key,
      Value<String> payload,
      Value<DateTime> fetchedAt,
      Value<DateTime> lastAccessedAt,
      Value<int> payloadVersion,
      Value<String> resourceType,
      Value<int> rowid,
    });

class $$CatalogCacheEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $CatalogCacheEntriesTable> {
  $$CatalogCacheEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastAccessedAt => $composableBuilder(
    column: $table.lastAccessedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get payloadVersion => $composableBuilder(
    column: $table.payloadVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get resourceType => $composableBuilder(
    column: $table.resourceType,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CatalogCacheEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CatalogCacheEntriesTable> {
  $$CatalogCacheEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastAccessedAt => $composableBuilder(
    column: $table.lastAccessedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get payloadVersion => $composableBuilder(
    column: $table.payloadVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get resourceType => $composableBuilder(
    column: $table.resourceType,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CatalogCacheEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CatalogCacheEntriesTable> {
  $$CatalogCacheEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastAccessedAt => $composableBuilder(
    column: $table.lastAccessedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get payloadVersion => $composableBuilder(
    column: $table.payloadVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get resourceType => $composableBuilder(
    column: $table.resourceType,
    builder: (column) => column,
  );
}

class $$CatalogCacheEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CatalogCacheEntriesTable,
          CatalogCacheEntry,
          $$CatalogCacheEntriesTableFilterComposer,
          $$CatalogCacheEntriesTableOrderingComposer,
          $$CatalogCacheEntriesTableAnnotationComposer,
          $$CatalogCacheEntriesTableCreateCompanionBuilder,
          $$CatalogCacheEntriesTableUpdateCompanionBuilder,
          (
            CatalogCacheEntry,
            BaseReferences<
              _$AppDatabase,
              $CatalogCacheEntriesTable,
              CatalogCacheEntry
            >,
          ),
          CatalogCacheEntry,
          PrefetchHooks Function()
        > {
  $$CatalogCacheEntriesTableTableManager(
    _$AppDatabase db,
    $CatalogCacheEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$CatalogCacheEntriesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$CatalogCacheEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$CatalogCacheEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<DateTime> fetchedAt = const Value.absent(),
                Value<DateTime> lastAccessedAt = const Value.absent(),
                Value<int> payloadVersion = const Value.absent(),
                Value<String> resourceType = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CatalogCacheEntriesCompanion(
                key: key,
                payload: payload,
                fetchedAt: fetchedAt,
                lastAccessedAt: lastAccessedAt,
                payloadVersion: payloadVersion,
                resourceType: resourceType,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String payload,
                required DateTime fetchedAt,
                required DateTime lastAccessedAt,
                required int payloadVersion,
                required String resourceType,
                Value<int> rowid = const Value.absent(),
              }) => CatalogCacheEntriesCompanion.insert(
                key: key,
                payload: payload,
                fetchedAt: fetchedAt,
                lastAccessedAt: lastAccessedAt,
                payloadVersion: payloadVersion,
                resourceType: resourceType,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable<
                            $CatalogCacheEntriesTable,
                            CatalogCacheEntry
                          >(table),
                          BaseReferences<
                            _$AppDatabase,
                            $CatalogCacheEntriesTable,
                            CatalogCacheEntry
                          >(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CatalogCacheEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CatalogCacheEntriesTable,
      CatalogCacheEntry,
      $$CatalogCacheEntriesTableFilterComposer,
      $$CatalogCacheEntriesTableOrderingComposer,
      $$CatalogCacheEntriesTableAnnotationComposer,
      $$CatalogCacheEntriesTableCreateCompanionBuilder,
      $$CatalogCacheEntriesTableUpdateCompanionBuilder,
      (
        CatalogCacheEntry,
        BaseReferences<
          _$AppDatabase,
          $CatalogCacheEntriesTable,
          CatalogCacheEntry
        >,
      ),
      CatalogCacheEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TracksTableTableManager get tracks =>
      $$TracksTableTableManager(_db, _db.tracks);
  $$ArtistsTableTableManager get artists =>
      $$ArtistsTableTableManager(_db, _db.artists);
  $$AlbumsTableTableManager get albums =>
      $$AlbumsTableTableManager(_db, _db.albums);
  $$PlaylistsTableTableManager get playlists =>
      $$PlaylistsTableTableManager(_db, _db.playlists);
  $$PlaylistTracksTableTableManager get playlistTracks =>
      $$PlaylistTracksTableTableManager(_db, _db.playlistTracks);
  $$RadiosTableTableManager get radios =>
      $$RadiosTableTableManager(_db, _db.radios);
  $$CatalogCacheEntriesTableTableManager get catalogCacheEntries =>
      $$CatalogCacheEntriesTableTableManager(_db, _db.catalogCacheEntries);
}
