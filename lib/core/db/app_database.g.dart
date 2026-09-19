// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TracksTable extends Tracks with TableInfo<$TracksTable, TrackEntry> {
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
    Insertable<TrackEntry> instance, {
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
  TrackEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrackEntry(
      spotifyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}spotify_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      artistId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}artist_id'],
      )!,
      artistName: attachedDatabase.typeMapping.read(
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
      playCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}play_count'],
      )!,
      isFavorite: attachedDatabase.typeMapping.read(
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

class TrackEntry extends DataClass implements Insertable<TrackEntry> {
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
  const TrackEntry({
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
      albumId: albumId == null && nullToAbsent
          ? const Value.absent()
          : Value(albumId),
      albumName: albumName == null && nullToAbsent
          ? const Value.absent()
          : Value(albumName),
      albumImage: albumImage == null && nullToAbsent
          ? const Value.absent()
          : Value(albumImage),
      durationMs: durationMs == null && nullToAbsent
          ? const Value.absent()
          : Value(durationMs),
      youtubeVideoId: youtubeVideoId == null && nullToAbsent
          ? const Value.absent()
          : Value(youtubeVideoId),
      youtubeResolvedAt: youtubeResolvedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(youtubeResolvedAt),
      playCount: Value(playCount),
      isFavorite: Value(isFavorite),
      lastPlayedAt: lastPlayedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPlayedAt),
    );
  }

  factory TrackEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrackEntry(
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

  TrackEntry copyWith({
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
  }) => TrackEntry(
    spotifyId: spotifyId ?? this.spotifyId,
    name: name ?? this.name,
    artistId: artistId ?? this.artistId,
    artistName: artistName ?? this.artistName,
    albumId: albumId.present ? albumId.value : this.albumId,
    albumName: albumName.present ? albumName.value : this.albumName,
    albumImage: albumImage.present ? albumImage.value : this.albumImage,
    durationMs: durationMs.present ? durationMs.value : this.durationMs,
    youtubeVideoId: youtubeVideoId.present
        ? youtubeVideoId.value
        : this.youtubeVideoId,
    youtubeResolvedAt: youtubeResolvedAt.present
        ? youtubeResolvedAt.value
        : this.youtubeResolvedAt,
    playCount: playCount ?? this.playCount,
    isFavorite: isFavorite ?? this.isFavorite,
    lastPlayedAt: lastPlayedAt.present ? lastPlayedAt.value : this.lastPlayedAt,
  );
  TrackEntry copyWithCompanion(TracksCompanion data) {
    return TrackEntry(
      spotifyId: data.spotifyId.present ? data.spotifyId.value : this.spotifyId,
      name: data.name.present ? data.name.value : this.name,
      artistId: data.artistId.present ? data.artistId.value : this.artistId,
      artistName: data.artistName.present
          ? data.artistName.value
          : this.artistName,
      albumId: data.albumId.present ? data.albumId.value : this.albumId,
      albumName: data.albumName.present ? data.albumName.value : this.albumName,
      albumImage: data.albumImage.present
          ? data.albumImage.value
          : this.albumImage,
      durationMs: data.durationMs.present
          ? data.durationMs.value
          : this.durationMs,
      youtubeVideoId: data.youtubeVideoId.present
          ? data.youtubeVideoId.value
          : this.youtubeVideoId,
      youtubeResolvedAt: data.youtubeResolvedAt.present
          ? data.youtubeResolvedAt.value
          : this.youtubeResolvedAt,
      playCount: data.playCount.present ? data.playCount.value : this.playCount,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
      lastPlayedAt: data.lastPlayedAt.present
          ? data.lastPlayedAt.value
          : this.lastPlayedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TrackEntry(')
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
      (other is TrackEntry &&
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

class TracksCompanion extends UpdateCompanion<TrackEntry> {
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
  static Insertable<TrackEntry> custom({
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
      spotifyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}spotify_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
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
      isFollowed: attachedDatabase.typeMapping.read(
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
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      imageSmall: imageSmall == null && nullToAbsent
          ? const Value.absent()
          : Value(imageSmall),
      followers: followers == null && nullToAbsent
          ? const Value.absent()
          : Value(followers),
      isFollowed: Value(isFollowed),
      updatedAt: updatedAt == null && nullToAbsent
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
      imageSmall: data.imageSmall.present
          ? data.imageSmall.value
          : this.imageSmall,
      followers: data.followers.present ? data.followers.value : this.followers,
      isFollowed: data.isFollowed.present
          ? data.isFollowed.value
          : this.isFollowed,
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
      spotifyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}spotify_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      artistId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}artist_id'],
      )!,
      artistName: attachedDatabase.typeMapping.read(
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
      isLiked: attachedDatabase.typeMapping.read(
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
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      releaseDate: releaseDate == null && nullToAbsent
          ? const Value.absent()
          : Value(releaseDate),
      totalTracks: totalTracks == null && nullToAbsent
          ? const Value.absent()
          : Value(totalTracks),
      isLiked: Value(isLiked),
      updatedAt: updatedAt == null && nullToAbsent
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
      artistName: data.artistName.present
          ? data.artistName.value
          : this.artistName,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      releaseDate: data.releaseDate.present
          ? data.releaseDate.value
          : this.releaseDate,
      totalTracks: data.totalTracks.present
          ? data.totalTracks.value
          : this.totalTracks,
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
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
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
      createdAt: attachedDatabase.typeMapping.read(
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
      spotifyId: spotifyId == null && nullToAbsent
          ? const Value.absent()
          : Value(spotifyId),
      imageUrl: imageUrl == null && nullToAbsent
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
  List<GeneratedColumn> get $columns => [
    id,
    playlistId,
    trackSpotifyId,
    position,
  ];
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
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlaylistTrack map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlaylistTrack(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      playlistId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}playlist_id'],
      )!,
      trackSpotifyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}track_spotify_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
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
  final int id;
  final int playlistId;
  final String trackSpotifyId;
  final int position;
  const PlaylistTrack({
    required this.id,
    required this.playlistId,
    required this.trackSpotifyId,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['playlist_id'] = Variable<int>(playlistId);
    map['track_spotify_id'] = Variable<String>(trackSpotifyId);
    map['position'] = Variable<int>(position);
    return map;
  }

  PlaylistTracksCompanion toCompanion(bool nullToAbsent) {
    return PlaylistTracksCompanion(
      id: Value(id),
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
      id: serializer.fromJson<int>(json['id']),
      playlistId: serializer.fromJson<int>(json['playlistId']),
      trackSpotifyId: serializer.fromJson<String>(json['trackSpotifyId']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'playlistId': serializer.toJson<int>(playlistId),
      'trackSpotifyId': serializer.toJson<String>(trackSpotifyId),
      'position': serializer.toJson<int>(position),
    };
  }

  PlaylistTrack copyWith({
    int? id,
    int? playlistId,
    String? trackSpotifyId,
    int? position,
  }) => PlaylistTrack(
    id: id ?? this.id,
    playlistId: playlistId ?? this.playlistId,
    trackSpotifyId: trackSpotifyId ?? this.trackSpotifyId,
    position: position ?? this.position,
  );
  PlaylistTrack copyWithCompanion(PlaylistTracksCompanion data) {
    return PlaylistTrack(
      id: data.id.present ? data.id.value : this.id,
      playlistId: data.playlistId.present
          ? data.playlistId.value
          : this.playlistId,
      trackSpotifyId: data.trackSpotifyId.present
          ? data.trackSpotifyId.value
          : this.trackSpotifyId,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlaylistTrack(')
          ..write('id: $id, ')
          ..write('playlistId: $playlistId, ')
          ..write('trackSpotifyId: $trackSpotifyId, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, playlistId, trackSpotifyId, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlaylistTrack &&
          other.id == this.id &&
          other.playlistId == this.playlistId &&
          other.trackSpotifyId == this.trackSpotifyId &&
          other.position == this.position);
}

class PlaylistTracksCompanion extends UpdateCompanion<PlaylistTrack> {
  final Value<int> id;
  final Value<int> playlistId;
  final Value<String> trackSpotifyId;
  final Value<int> position;
  const PlaylistTracksCompanion({
    this.id = const Value.absent(),
    this.playlistId = const Value.absent(),
    this.trackSpotifyId = const Value.absent(),
    this.position = const Value.absent(),
  });
  PlaylistTracksCompanion.insert({
    this.id = const Value.absent(),
    required int playlistId,
    required String trackSpotifyId,
    required int position,
  }) : playlistId = Value(playlistId),
       trackSpotifyId = Value(trackSpotifyId),
       position = Value(position);
  static Insertable<PlaylistTrack> custom({
    Expression<int>? id,
    Expression<int>? playlistId,
    Expression<String>? trackSpotifyId,
    Expression<int>? position,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (playlistId != null) 'playlist_id': playlistId,
      if (trackSpotifyId != null) 'track_spotify_id': trackSpotifyId,
      if (position != null) 'position': position,
    });
  }

  PlaylistTracksCompanion copyWith({
    Value<int>? id,
    Value<int>? playlistId,
    Value<String>? trackSpotifyId,
    Value<int>? position,
  }) {
    return PlaylistTracksCompanion(
      id: id ?? this.id,
      playlistId: playlistId ?? this.playlistId,
      trackSpotifyId: trackSpotifyId ?? this.trackSpotifyId,
      position: position ?? this.position,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (playlistId.present) {
      map['playlist_id'] = Variable<int>(playlistId.value);
    }
    if (trackSpotifyId.present) {
      map['track_spotify_id'] = Variable<String>(trackSpotifyId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlaylistTracksCompanion(')
          ..write('id: $id, ')
          ..write('playlistId: $playlistId, ')
          ..write('trackSpotifyId: $trackSpotifyId, ')
          ..write('position: $position')
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
      seedId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}seed_id'],
      )!,
      seedType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}seed_type'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      isFollowed: attachedDatabase.typeMapping.read(
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
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      isFollowed: Value(isFollowed),
      updatedAt: updatedAt == null && nullToAbsent
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
      isFollowed: data.isFollowed.present
          ? data.isFollowed.value
          : this.isFollowed,
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
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      fetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fetched_at'],
      )!,
      lastAccessedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_accessed_at'],
      )!,
      payloadVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}payload_version'],
      )!,
      resourceType: attachedDatabase.typeMapping.read(
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
      lastAccessedAt: data.lastAccessedAt.present
          ? data.lastAccessedAt.value
          : this.lastAccessedAt,
      payloadVersion: data.payloadVersion.present
          ? data.payloadVersion.value
          : this.payloadVersion,
      resourceType: data.resourceType.present
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

class $LocalFilesTable extends LocalFiles
    with TableInfo<$LocalFilesTable, LocalFile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalFilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _libraryIdMeta = const VerificationMeta(
    'libraryId',
  );
  @override
  late final GeneratedColumn<String> libraryId = GeneratedColumn<String>(
    'library_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mechanismMeta = const VerificationMeta(
    'mechanism',
  );
  @override
  late final GeneratedColumn<String> mechanism = GeneratedColumn<String>(
    'mechanism',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _locatorMeta = const VerificationMeta(
    'locator',
  );
  @override
  late final GeneratedColumn<String> locator = GeneratedColumn<String>(
    'locator',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayPathMeta = const VerificationMeta(
    'displayPath',
  );
  @override
  late final GeneratedColumn<String> displayPath = GeneratedColumn<String>(
    'display_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deduplicationKeyMeta = const VerificationMeta(
    'deduplicationKey',
  );
  @override
  late final GeneratedColumn<String> deduplicationKey = GeneratedColumn<String>(
    'deduplication_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _availabilityStatusMeta =
      const VerificationMeta('availabilityStatus');
  @override
  late final GeneratedColumn<String> availabilityStatus =
      GeneratedColumn<String>(
        'availability_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('available'),
      );
  static const VerificationMeta _lastScannedAtMeta = const VerificationMeta(
    'lastScannedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastScannedAt =
      GeneratedColumn<DateTime>(
        'last_scanned_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _importRootLocatorMeta = const VerificationMeta(
    'importRootLocator',
  );
  @override
  late final GeneratedColumn<String> importRootLocator =
      GeneratedColumn<String>(
        'import_root_locator',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _albumArtistMeta = const VerificationMeta(
    'albumArtist',
  );
  @override
  late final GeneratedColumn<String> albumArtist = GeneratedColumn<String>(
    'album_artist',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _albumGroupKeyMeta = const VerificationMeta(
    'albumGroupKey',
  );
  @override
  late final GeneratedColumn<String> albumGroupKey = GeneratedColumn<String>(
    'album_group_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _trackNumberMeta = const VerificationMeta(
    'trackNumber',
  );
  @override
  late final GeneratedColumn<int> trackNumber = GeneratedColumn<int>(
    'track_number',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _trackTotalMeta = const VerificationMeta(
    'trackTotal',
  );
  @override
  late final GeneratedColumn<int> trackTotal = GeneratedColumn<int>(
    'track_total',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _discNumberMeta = const VerificationMeta(
    'discNumber',
  );
  @override
  late final GeneratedColumn<int> discNumber = GeneratedColumn<int>(
    'disc_number',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _discTotalMeta = const VerificationMeta(
    'discTotal',
  );
  @override
  late final GeneratedColumn<int> discTotal = GeneratedColumn<int>(
    'disc_total',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _genreMeta = const VerificationMeta('genre');
  @override
  late final GeneratedColumn<String> genre = GeneratedColumn<String>(
    'genre',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _releaseYearMeta = const VerificationMeta(
    'releaseYear',
  );
  @override
  late final GeneratedColumn<int> releaseYear = GeneratedColumn<int>(
    'release_year',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _artworkPathMeta = const VerificationMeta(
    'artworkPath',
  );
  @override
  late final GeneratedColumn<String> artworkPath = GeneratedColumn<String>(
    'artwork_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _artworkMimeTypeMeta = const VerificationMeta(
    'artworkMimeType',
  );
  @override
  late final GeneratedColumn<String> artworkMimeType = GeneratedColumn<String>(
    'artwork_mime_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addedAtMeta = const VerificationMeta(
    'addedAt',
  );
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
    'added_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _isVideoMeta = const VerificationMeta(
    'isVideo',
  );
  @override
  late final GeneratedColumn<bool> isVideo = GeneratedColumn<bool>(
    'is_video',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_video" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    libraryId,
    mechanism,
    locator,
    displayPath,
    deduplicationKey,
    availabilityStatus,
    lastScannedAt,
    importRootLocator,
    albumArtist,
    albumGroupKey,
    trackNumber,
    trackTotal,
    discNumber,
    discTotal,
    genre,
    releaseYear,
    artworkPath,
    artworkMimeType,
    addedAt,
    isVideo,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_files';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalFile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('library_id')) {
      context.handle(
        _libraryIdMeta,
        libraryId.isAcceptableOrUnknown(data['library_id']!, _libraryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_libraryIdMeta);
    }
    if (data.containsKey('mechanism')) {
      context.handle(
        _mechanismMeta,
        mechanism.isAcceptableOrUnknown(data['mechanism']!, _mechanismMeta),
      );
    } else if (isInserting) {
      context.missing(_mechanismMeta);
    }
    if (data.containsKey('locator')) {
      context.handle(
        _locatorMeta,
        locator.isAcceptableOrUnknown(data['locator']!, _locatorMeta),
      );
    } else if (isInserting) {
      context.missing(_locatorMeta);
    }
    if (data.containsKey('display_path')) {
      context.handle(
        _displayPathMeta,
        displayPath.isAcceptableOrUnknown(
          data['display_path']!,
          _displayPathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayPathMeta);
    }
    if (data.containsKey('deduplication_key')) {
      context.handle(
        _deduplicationKeyMeta,
        deduplicationKey.isAcceptableOrUnknown(
          data['deduplication_key']!,
          _deduplicationKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_deduplicationKeyMeta);
    }
    if (data.containsKey('availability_status')) {
      context.handle(
        _availabilityStatusMeta,
        availabilityStatus.isAcceptableOrUnknown(
          data['availability_status']!,
          _availabilityStatusMeta,
        ),
      );
    }
    if (data.containsKey('last_scanned_at')) {
      context.handle(
        _lastScannedAtMeta,
        lastScannedAt.isAcceptableOrUnknown(
          data['last_scanned_at']!,
          _lastScannedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastScannedAtMeta);
    }
    if (data.containsKey('import_root_locator')) {
      context.handle(
        _importRootLocatorMeta,
        importRootLocator.isAcceptableOrUnknown(
          data['import_root_locator']!,
          _importRootLocatorMeta,
        ),
      );
    }
    if (data.containsKey('album_artist')) {
      context.handle(
        _albumArtistMeta,
        albumArtist.isAcceptableOrUnknown(
          data['album_artist']!,
          _albumArtistMeta,
        ),
      );
    }
    if (data.containsKey('album_group_key')) {
      context.handle(
        _albumGroupKeyMeta,
        albumGroupKey.isAcceptableOrUnknown(
          data['album_group_key']!,
          _albumGroupKeyMeta,
        ),
      );
    }
    if (data.containsKey('track_number')) {
      context.handle(
        _trackNumberMeta,
        trackNumber.isAcceptableOrUnknown(
          data['track_number']!,
          _trackNumberMeta,
        ),
      );
    }
    if (data.containsKey('track_total')) {
      context.handle(
        _trackTotalMeta,
        trackTotal.isAcceptableOrUnknown(data['track_total']!, _trackTotalMeta),
      );
    }
    if (data.containsKey('disc_number')) {
      context.handle(
        _discNumberMeta,
        discNumber.isAcceptableOrUnknown(data['disc_number']!, _discNumberMeta),
      );
    }
    if (data.containsKey('disc_total')) {
      context.handle(
        _discTotalMeta,
        discTotal.isAcceptableOrUnknown(data['disc_total']!, _discTotalMeta),
      );
    }
    if (data.containsKey('genre')) {
      context.handle(
        _genreMeta,
        genre.isAcceptableOrUnknown(data['genre']!, _genreMeta),
      );
    }
    if (data.containsKey('release_year')) {
      context.handle(
        _releaseYearMeta,
        releaseYear.isAcceptableOrUnknown(
          data['release_year']!,
          _releaseYearMeta,
        ),
      );
    }
    if (data.containsKey('artwork_path')) {
      context.handle(
        _artworkPathMeta,
        artworkPath.isAcceptableOrUnknown(
          data['artwork_path']!,
          _artworkPathMeta,
        ),
      );
    }
    if (data.containsKey('artwork_mime_type')) {
      context.handle(
        _artworkMimeTypeMeta,
        artworkMimeType.isAcceptableOrUnknown(
          data['artwork_mime_type']!,
          _artworkMimeTypeMeta,
        ),
      );
    }
    if (data.containsKey('added_at')) {
      context.handle(
        _addedAtMeta,
        addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta),
      );
    }
    if (data.containsKey('is_video')) {
      context.handle(
        _isVideoMeta,
        isVideo.isAcceptableOrUnknown(data['is_video']!, _isVideoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {libraryId};
  @override
  LocalFile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalFile(
      libraryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}library_id'],
      )!,
      mechanism: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mechanism'],
      )!,
      locator: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}locator'],
      )!,
      displayPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_path'],
      )!,
      deduplicationKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}deduplication_key'],
      )!,
      availabilityStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}availability_status'],
      )!,
      lastScannedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_scanned_at'],
      )!,
      importRootLocator: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}import_root_locator'],
      ),
      albumArtist: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}album_artist'],
      ),
      albumGroupKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}album_group_key'],
      ),
      trackNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}track_number'],
      ),
      trackTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}track_total'],
      ),
      discNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}disc_number'],
      ),
      discTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}disc_total'],
      ),
      genre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}genre'],
      ),
      releaseYear: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}release_year'],
      ),
      artworkPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}artwork_path'],
      ),
      artworkMimeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}artwork_mime_type'],
      ),
      addedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}added_at'],
      )!,
      isVideo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_video'],
      )!,
    );
  }

  @override
  $LocalFilesTable createAlias(String alias) {
    return $LocalFilesTable(attachedDatabase, alias);
  }
}

class LocalFile extends DataClass implements Insertable<LocalFile> {
  final String libraryId;
  final String mechanism;
  final String locator;
  final String displayPath;
  final String deduplicationKey;
  final String availabilityStatus;
  final DateTime lastScannedAt;
  final String? importRootLocator;
  final String? albumArtist;
  final String? albumGroupKey;
  final int? trackNumber;
  final int? trackTotal;
  final int? discNumber;
  final int? discTotal;
  final String? genre;
  final int? releaseYear;
  final String? artworkPath;
  final String? artworkMimeType;
  final DateTime addedAt;
  final bool isVideo;
  const LocalFile({
    required this.libraryId,
    required this.mechanism,
    required this.locator,
    required this.displayPath,
    required this.deduplicationKey,
    required this.availabilityStatus,
    required this.lastScannedAt,
    this.importRootLocator,
    this.albumArtist,
    this.albumGroupKey,
    this.trackNumber,
    this.trackTotal,
    this.discNumber,
    this.discTotal,
    this.genre,
    this.releaseYear,
    this.artworkPath,
    this.artworkMimeType,
    required this.addedAt,
    required this.isVideo,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['library_id'] = Variable<String>(libraryId);
    map['mechanism'] = Variable<String>(mechanism);
    map['locator'] = Variable<String>(locator);
    map['display_path'] = Variable<String>(displayPath);
    map['deduplication_key'] = Variable<String>(deduplicationKey);
    map['availability_status'] = Variable<String>(availabilityStatus);
    map['last_scanned_at'] = Variable<DateTime>(lastScannedAt);
    if (!nullToAbsent || importRootLocator != null) {
      map['import_root_locator'] = Variable<String>(importRootLocator);
    }
    if (!nullToAbsent || albumArtist != null) {
      map['album_artist'] = Variable<String>(albumArtist);
    }
    if (!nullToAbsent || albumGroupKey != null) {
      map['album_group_key'] = Variable<String>(albumGroupKey);
    }
    if (!nullToAbsent || trackNumber != null) {
      map['track_number'] = Variable<int>(trackNumber);
    }
    if (!nullToAbsent || trackTotal != null) {
      map['track_total'] = Variable<int>(trackTotal);
    }
    if (!nullToAbsent || discNumber != null) {
      map['disc_number'] = Variable<int>(discNumber);
    }
    if (!nullToAbsent || discTotal != null) {
      map['disc_total'] = Variable<int>(discTotal);
    }
    if (!nullToAbsent || genre != null) {
      map['genre'] = Variable<String>(genre);
    }
    if (!nullToAbsent || releaseYear != null) {
      map['release_year'] = Variable<int>(releaseYear);
    }
    if (!nullToAbsent || artworkPath != null) {
      map['artwork_path'] = Variable<String>(artworkPath);
    }
    if (!nullToAbsent || artworkMimeType != null) {
      map['artwork_mime_type'] = Variable<String>(artworkMimeType);
    }
    map['added_at'] = Variable<DateTime>(addedAt);
    map['is_video'] = Variable<bool>(isVideo);
    return map;
  }

  LocalFilesCompanion toCompanion(bool nullToAbsent) {
    return LocalFilesCompanion(
      libraryId: Value(libraryId),
      mechanism: Value(mechanism),
      locator: Value(locator),
      displayPath: Value(displayPath),
      deduplicationKey: Value(deduplicationKey),
      availabilityStatus: Value(availabilityStatus),
      lastScannedAt: Value(lastScannedAt),
      importRootLocator: importRootLocator == null && nullToAbsent
          ? const Value.absent()
          : Value(importRootLocator),
      albumArtist: albumArtist == null && nullToAbsent
          ? const Value.absent()
          : Value(albumArtist),
      albumGroupKey: albumGroupKey == null && nullToAbsent
          ? const Value.absent()
          : Value(albumGroupKey),
      trackNumber: trackNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(trackNumber),
      trackTotal: trackTotal == null && nullToAbsent
          ? const Value.absent()
          : Value(trackTotal),
      discNumber: discNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(discNumber),
      discTotal: discTotal == null && nullToAbsent
          ? const Value.absent()
          : Value(discTotal),
      genre: genre == null && nullToAbsent
          ? const Value.absent()
          : Value(genre),
      releaseYear: releaseYear == null && nullToAbsent
          ? const Value.absent()
          : Value(releaseYear),
      artworkPath: artworkPath == null && nullToAbsent
          ? const Value.absent()
          : Value(artworkPath),
      artworkMimeType: artworkMimeType == null && nullToAbsent
          ? const Value.absent()
          : Value(artworkMimeType),
      addedAt: Value(addedAt),
      isVideo: Value(isVideo),
    );
  }

  factory LocalFile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalFile(
      libraryId: serializer.fromJson<String>(json['libraryId']),
      mechanism: serializer.fromJson<String>(json['mechanism']),
      locator: serializer.fromJson<String>(json['locator']),
      displayPath: serializer.fromJson<String>(json['displayPath']),
      deduplicationKey: serializer.fromJson<String>(json['deduplicationKey']),
      availabilityStatus: serializer.fromJson<String>(
        json['availabilityStatus'],
      ),
      lastScannedAt: serializer.fromJson<DateTime>(json['lastScannedAt']),
      importRootLocator: serializer.fromJson<String?>(
        json['importRootLocator'],
      ),
      albumArtist: serializer.fromJson<String?>(json['albumArtist']),
      albumGroupKey: serializer.fromJson<String?>(json['albumGroupKey']),
      trackNumber: serializer.fromJson<int?>(json['trackNumber']),
      trackTotal: serializer.fromJson<int?>(json['trackTotal']),
      discNumber: serializer.fromJson<int?>(json['discNumber']),
      discTotal: serializer.fromJson<int?>(json['discTotal']),
      genre: serializer.fromJson<String?>(json['genre']),
      releaseYear: serializer.fromJson<int?>(json['releaseYear']),
      artworkPath: serializer.fromJson<String?>(json['artworkPath']),
      artworkMimeType: serializer.fromJson<String?>(json['artworkMimeType']),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
      isVideo: serializer.fromJson<bool>(json['isVideo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'libraryId': serializer.toJson<String>(libraryId),
      'mechanism': serializer.toJson<String>(mechanism),
      'locator': serializer.toJson<String>(locator),
      'displayPath': serializer.toJson<String>(displayPath),
      'deduplicationKey': serializer.toJson<String>(deduplicationKey),
      'availabilityStatus': serializer.toJson<String>(availabilityStatus),
      'lastScannedAt': serializer.toJson<DateTime>(lastScannedAt),
      'importRootLocator': serializer.toJson<String?>(importRootLocator),
      'albumArtist': serializer.toJson<String?>(albumArtist),
      'albumGroupKey': serializer.toJson<String?>(albumGroupKey),
      'trackNumber': serializer.toJson<int?>(trackNumber),
      'trackTotal': serializer.toJson<int?>(trackTotal),
      'discNumber': serializer.toJson<int?>(discNumber),
      'discTotal': serializer.toJson<int?>(discTotal),
      'genre': serializer.toJson<String?>(genre),
      'releaseYear': serializer.toJson<int?>(releaseYear),
      'artworkPath': serializer.toJson<String?>(artworkPath),
      'artworkMimeType': serializer.toJson<String?>(artworkMimeType),
      'addedAt': serializer.toJson<DateTime>(addedAt),
      'isVideo': serializer.toJson<bool>(isVideo),
    };
  }

  LocalFile copyWith({
    String? libraryId,
    String? mechanism,
    String? locator,
    String? displayPath,
    String? deduplicationKey,
    String? availabilityStatus,
    DateTime? lastScannedAt,
    Value<String?> importRootLocator = const Value.absent(),
    Value<String?> albumArtist = const Value.absent(),
    Value<String?> albumGroupKey = const Value.absent(),
    Value<int?> trackNumber = const Value.absent(),
    Value<int?> trackTotal = const Value.absent(),
    Value<int?> discNumber = const Value.absent(),
    Value<int?> discTotal = const Value.absent(),
    Value<String?> genre = const Value.absent(),
    Value<int?> releaseYear = const Value.absent(),
    Value<String?> artworkPath = const Value.absent(),
    Value<String?> artworkMimeType = const Value.absent(),
    DateTime? addedAt,
    bool? isVideo,
  }) => LocalFile(
    libraryId: libraryId ?? this.libraryId,
    mechanism: mechanism ?? this.mechanism,
    locator: locator ?? this.locator,
    displayPath: displayPath ?? this.displayPath,
    deduplicationKey: deduplicationKey ?? this.deduplicationKey,
    availabilityStatus: availabilityStatus ?? this.availabilityStatus,
    lastScannedAt: lastScannedAt ?? this.lastScannedAt,
    importRootLocator: importRootLocator.present
        ? importRootLocator.value
        : this.importRootLocator,
    albumArtist: albumArtist.present ? albumArtist.value : this.albumArtist,
    albumGroupKey: albumGroupKey.present
        ? albumGroupKey.value
        : this.albumGroupKey,
    trackNumber: trackNumber.present ? trackNumber.value : this.trackNumber,
    trackTotal: trackTotal.present ? trackTotal.value : this.trackTotal,
    discNumber: discNumber.present ? discNumber.value : this.discNumber,
    discTotal: discTotal.present ? discTotal.value : this.discTotal,
    genre: genre.present ? genre.value : this.genre,
    releaseYear: releaseYear.present ? releaseYear.value : this.releaseYear,
    artworkPath: artworkPath.present ? artworkPath.value : this.artworkPath,
    artworkMimeType: artworkMimeType.present
        ? artworkMimeType.value
        : this.artworkMimeType,
    addedAt: addedAt ?? this.addedAt,
    isVideo: isVideo ?? this.isVideo,
  );
  LocalFile copyWithCompanion(LocalFilesCompanion data) {
    return LocalFile(
      libraryId: data.libraryId.present ? data.libraryId.value : this.libraryId,
      mechanism: data.mechanism.present ? data.mechanism.value : this.mechanism,
      locator: data.locator.present ? data.locator.value : this.locator,
      displayPath: data.displayPath.present
          ? data.displayPath.value
          : this.displayPath,
      deduplicationKey: data.deduplicationKey.present
          ? data.deduplicationKey.value
          : this.deduplicationKey,
      availabilityStatus: data.availabilityStatus.present
          ? data.availabilityStatus.value
          : this.availabilityStatus,
      lastScannedAt: data.lastScannedAt.present
          ? data.lastScannedAt.value
          : this.lastScannedAt,
      importRootLocator: data.importRootLocator.present
          ? data.importRootLocator.value
          : this.importRootLocator,
      albumArtist: data.albumArtist.present
          ? data.albumArtist.value
          : this.albumArtist,
      albumGroupKey: data.albumGroupKey.present
          ? data.albumGroupKey.value
          : this.albumGroupKey,
      trackNumber: data.trackNumber.present
          ? data.trackNumber.value
          : this.trackNumber,
      trackTotal: data.trackTotal.present
          ? data.trackTotal.value
          : this.trackTotal,
      discNumber: data.discNumber.present
          ? data.discNumber.value
          : this.discNumber,
      discTotal: data.discTotal.present ? data.discTotal.value : this.discTotal,
      genre: data.genre.present ? data.genre.value : this.genre,
      releaseYear: data.releaseYear.present
          ? data.releaseYear.value
          : this.releaseYear,
      artworkPath: data.artworkPath.present
          ? data.artworkPath.value
          : this.artworkPath,
      artworkMimeType: data.artworkMimeType.present
          ? data.artworkMimeType.value
          : this.artworkMimeType,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
      isVideo: data.isVideo.present ? data.isVideo.value : this.isVideo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalFile(')
          ..write('libraryId: $libraryId, ')
          ..write('mechanism: $mechanism, ')
          ..write('locator: $locator, ')
          ..write('displayPath: $displayPath, ')
          ..write('deduplicationKey: $deduplicationKey, ')
          ..write('availabilityStatus: $availabilityStatus, ')
          ..write('lastScannedAt: $lastScannedAt, ')
          ..write('importRootLocator: $importRootLocator, ')
          ..write('albumArtist: $albumArtist, ')
          ..write('albumGroupKey: $albumGroupKey, ')
          ..write('trackNumber: $trackNumber, ')
          ..write('trackTotal: $trackTotal, ')
          ..write('discNumber: $discNumber, ')
          ..write('discTotal: $discTotal, ')
          ..write('genre: $genre, ')
          ..write('releaseYear: $releaseYear, ')
          ..write('artworkPath: $artworkPath, ')
          ..write('artworkMimeType: $artworkMimeType, ')
          ..write('addedAt: $addedAt, ')
          ..write('isVideo: $isVideo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    libraryId,
    mechanism,
    locator,
    displayPath,
    deduplicationKey,
    availabilityStatus,
    lastScannedAt,
    importRootLocator,
    albumArtist,
    albumGroupKey,
    trackNumber,
    trackTotal,
    discNumber,
    discTotal,
    genre,
    releaseYear,
    artworkPath,
    artworkMimeType,
    addedAt,
    isVideo,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalFile &&
          other.libraryId == this.libraryId &&
          other.mechanism == this.mechanism &&
          other.locator == this.locator &&
          other.displayPath == this.displayPath &&
          other.deduplicationKey == this.deduplicationKey &&
          other.availabilityStatus == this.availabilityStatus &&
          other.lastScannedAt == this.lastScannedAt &&
          other.importRootLocator == this.importRootLocator &&
          other.albumArtist == this.albumArtist &&
          other.albumGroupKey == this.albumGroupKey &&
          other.trackNumber == this.trackNumber &&
          other.trackTotal == this.trackTotal &&
          other.discNumber == this.discNumber &&
          other.discTotal == this.discTotal &&
          other.genre == this.genre &&
          other.releaseYear == this.releaseYear &&
          other.artworkPath == this.artworkPath &&
          other.artworkMimeType == this.artworkMimeType &&
          other.addedAt == this.addedAt &&
          other.isVideo == this.isVideo);
}

class LocalFilesCompanion extends UpdateCompanion<LocalFile> {
  final Value<String> libraryId;
  final Value<String> mechanism;
  final Value<String> locator;
  final Value<String> displayPath;
  final Value<String> deduplicationKey;
  final Value<String> availabilityStatus;
  final Value<DateTime> lastScannedAt;
  final Value<String?> importRootLocator;
  final Value<String?> albumArtist;
  final Value<String?> albumGroupKey;
  final Value<int?> trackNumber;
  final Value<int?> trackTotal;
  final Value<int?> discNumber;
  final Value<int?> discTotal;
  final Value<String?> genre;
  final Value<int?> releaseYear;
  final Value<String?> artworkPath;
  final Value<String?> artworkMimeType;
  final Value<DateTime> addedAt;
  final Value<bool> isVideo;
  final Value<int> rowid;
  const LocalFilesCompanion({
    this.libraryId = const Value.absent(),
    this.mechanism = const Value.absent(),
    this.locator = const Value.absent(),
    this.displayPath = const Value.absent(),
    this.deduplicationKey = const Value.absent(),
    this.availabilityStatus = const Value.absent(),
    this.lastScannedAt = const Value.absent(),
    this.importRootLocator = const Value.absent(),
    this.albumArtist = const Value.absent(),
    this.albumGroupKey = const Value.absent(),
    this.trackNumber = const Value.absent(),
    this.trackTotal = const Value.absent(),
    this.discNumber = const Value.absent(),
    this.discTotal = const Value.absent(),
    this.genre = const Value.absent(),
    this.releaseYear = const Value.absent(),
    this.artworkPath = const Value.absent(),
    this.artworkMimeType = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.isVideo = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalFilesCompanion.insert({
    required String libraryId,
    required String mechanism,
    required String locator,
    required String displayPath,
    required String deduplicationKey,
    this.availabilityStatus = const Value.absent(),
    required DateTime lastScannedAt,
    this.importRootLocator = const Value.absent(),
    this.albumArtist = const Value.absent(),
    this.albumGroupKey = const Value.absent(),
    this.trackNumber = const Value.absent(),
    this.trackTotal = const Value.absent(),
    this.discNumber = const Value.absent(),
    this.discTotal = const Value.absent(),
    this.genre = const Value.absent(),
    this.releaseYear = const Value.absent(),
    this.artworkPath = const Value.absent(),
    this.artworkMimeType = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.isVideo = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : libraryId = Value(libraryId),
       mechanism = Value(mechanism),
       locator = Value(locator),
       displayPath = Value(displayPath),
       deduplicationKey = Value(deduplicationKey),
       lastScannedAt = Value(lastScannedAt);
  static Insertable<LocalFile> custom({
    Expression<String>? libraryId,
    Expression<String>? mechanism,
    Expression<String>? locator,
    Expression<String>? displayPath,
    Expression<String>? deduplicationKey,
    Expression<String>? availabilityStatus,
    Expression<DateTime>? lastScannedAt,
    Expression<String>? importRootLocator,
    Expression<String>? albumArtist,
    Expression<String>? albumGroupKey,
    Expression<int>? trackNumber,
    Expression<int>? trackTotal,
    Expression<int>? discNumber,
    Expression<int>? discTotal,
    Expression<String>? genre,
    Expression<int>? releaseYear,
    Expression<String>? artworkPath,
    Expression<String>? artworkMimeType,
    Expression<DateTime>? addedAt,
    Expression<bool>? isVideo,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (libraryId != null) 'library_id': libraryId,
      if (mechanism != null) 'mechanism': mechanism,
      if (locator != null) 'locator': locator,
      if (displayPath != null) 'display_path': displayPath,
      if (deduplicationKey != null) 'deduplication_key': deduplicationKey,
      if (availabilityStatus != null) 'availability_status': availabilityStatus,
      if (lastScannedAt != null) 'last_scanned_at': lastScannedAt,
      if (importRootLocator != null) 'import_root_locator': importRootLocator,
      if (albumArtist != null) 'album_artist': albumArtist,
      if (albumGroupKey != null) 'album_group_key': albumGroupKey,
      if (trackNumber != null) 'track_number': trackNumber,
      if (trackTotal != null) 'track_total': trackTotal,
      if (discNumber != null) 'disc_number': discNumber,
      if (discTotal != null) 'disc_total': discTotal,
      if (genre != null) 'genre': genre,
      if (releaseYear != null) 'release_year': releaseYear,
      if (artworkPath != null) 'artwork_path': artworkPath,
      if (artworkMimeType != null) 'artwork_mime_type': artworkMimeType,
      if (addedAt != null) 'added_at': addedAt,
      if (isVideo != null) 'is_video': isVideo,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalFilesCompanion copyWith({
    Value<String>? libraryId,
    Value<String>? mechanism,
    Value<String>? locator,
    Value<String>? displayPath,
    Value<String>? deduplicationKey,
    Value<String>? availabilityStatus,
    Value<DateTime>? lastScannedAt,
    Value<String?>? importRootLocator,
    Value<String?>? albumArtist,
    Value<String?>? albumGroupKey,
    Value<int?>? trackNumber,
    Value<int?>? trackTotal,
    Value<int?>? discNumber,
    Value<int?>? discTotal,
    Value<String?>? genre,
    Value<int?>? releaseYear,
    Value<String?>? artworkPath,
    Value<String?>? artworkMimeType,
    Value<DateTime>? addedAt,
    Value<bool>? isVideo,
    Value<int>? rowid,
  }) {
    return LocalFilesCompanion(
      libraryId: libraryId ?? this.libraryId,
      mechanism: mechanism ?? this.mechanism,
      locator: locator ?? this.locator,
      displayPath: displayPath ?? this.displayPath,
      deduplicationKey: deduplicationKey ?? this.deduplicationKey,
      availabilityStatus: availabilityStatus ?? this.availabilityStatus,
      lastScannedAt: lastScannedAt ?? this.lastScannedAt,
      importRootLocator: importRootLocator ?? this.importRootLocator,
      albumArtist: albumArtist ?? this.albumArtist,
      albumGroupKey: albumGroupKey ?? this.albumGroupKey,
      trackNumber: trackNumber ?? this.trackNumber,
      trackTotal: trackTotal ?? this.trackTotal,
      discNumber: discNumber ?? this.discNumber,
      discTotal: discTotal ?? this.discTotal,
      genre: genre ?? this.genre,
      releaseYear: releaseYear ?? this.releaseYear,
      artworkPath: artworkPath ?? this.artworkPath,
      artworkMimeType: artworkMimeType ?? this.artworkMimeType,
      addedAt: addedAt ?? this.addedAt,
      isVideo: isVideo ?? this.isVideo,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (libraryId.present) {
      map['library_id'] = Variable<String>(libraryId.value);
    }
    if (mechanism.present) {
      map['mechanism'] = Variable<String>(mechanism.value);
    }
    if (locator.present) {
      map['locator'] = Variable<String>(locator.value);
    }
    if (displayPath.present) {
      map['display_path'] = Variable<String>(displayPath.value);
    }
    if (deduplicationKey.present) {
      map['deduplication_key'] = Variable<String>(deduplicationKey.value);
    }
    if (availabilityStatus.present) {
      map['availability_status'] = Variable<String>(availabilityStatus.value);
    }
    if (lastScannedAt.present) {
      map['last_scanned_at'] = Variable<DateTime>(lastScannedAt.value);
    }
    if (importRootLocator.present) {
      map['import_root_locator'] = Variable<String>(importRootLocator.value);
    }
    if (albumArtist.present) {
      map['album_artist'] = Variable<String>(albumArtist.value);
    }
    if (albumGroupKey.present) {
      map['album_group_key'] = Variable<String>(albumGroupKey.value);
    }
    if (trackNumber.present) {
      map['track_number'] = Variable<int>(trackNumber.value);
    }
    if (trackTotal.present) {
      map['track_total'] = Variable<int>(trackTotal.value);
    }
    if (discNumber.present) {
      map['disc_number'] = Variable<int>(discNumber.value);
    }
    if (discTotal.present) {
      map['disc_total'] = Variable<int>(discTotal.value);
    }
    if (genre.present) {
      map['genre'] = Variable<String>(genre.value);
    }
    if (releaseYear.present) {
      map['release_year'] = Variable<int>(releaseYear.value);
    }
    if (artworkPath.present) {
      map['artwork_path'] = Variable<String>(artworkPath.value);
    }
    if (artworkMimeType.present) {
      map['artwork_mime_type'] = Variable<String>(artworkMimeType.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    if (isVideo.present) {
      map['is_video'] = Variable<bool>(isVideo.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalFilesCompanion(')
          ..write('libraryId: $libraryId, ')
          ..write('mechanism: $mechanism, ')
          ..write('locator: $locator, ')
          ..write('displayPath: $displayPath, ')
          ..write('deduplicationKey: $deduplicationKey, ')
          ..write('availabilityStatus: $availabilityStatus, ')
          ..write('lastScannedAt: $lastScannedAt, ')
          ..write('importRootLocator: $importRootLocator, ')
          ..write('albumArtist: $albumArtist, ')
          ..write('albumGroupKey: $albumGroupKey, ')
          ..write('trackNumber: $trackNumber, ')
          ..write('trackTotal: $trackTotal, ')
          ..write('discNumber: $discNumber, ')
          ..write('discTotal: $discTotal, ')
          ..write('genre: $genre, ')
          ..write('releaseYear: $releaseYear, ')
          ..write('artworkPath: $artworkPath, ')
          ..write('artworkMimeType: $artworkMimeType, ')
          ..write('addedAt: $addedAt, ')
          ..write('isVideo: $isVideo, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ImportRootsTable extends ImportRoots
    with TableInfo<$ImportRootsTable, ImportRoot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ImportRootsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mechanismMeta = const VerificationMeta(
    'mechanism',
  );
  @override
  late final GeneratedColumn<String> mechanism = GeneratedColumn<String>(
    'mechanism',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rootLocatorMeta = const VerificationMeta(
    'rootLocator',
  );
  @override
  late final GeneratedColumn<String> rootLocator = GeneratedColumn<String>(
    'root_locator',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayPathMeta = const VerificationMeta(
    'displayPath',
  );
  @override
  late final GeneratedColumn<String> displayPath = GeneratedColumn<String>(
    'display_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addedAtMeta = const VerificationMeta(
    'addedAt',
  );
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
    'added_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mediaScopeMeta = const VerificationMeta(
    'mediaScope',
  );
  @override
  late final GeneratedColumn<String> mediaScope = GeneratedColumn<String>(
    'media_scope',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('audio'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    mechanism,
    rootLocator,
    displayPath,
    addedAt,
    mediaScope,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'import_roots';
  @override
  VerificationContext validateIntegrity(
    Insertable<ImportRoot> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('mechanism')) {
      context.handle(
        _mechanismMeta,
        mechanism.isAcceptableOrUnknown(data['mechanism']!, _mechanismMeta),
      );
    } else if (isInserting) {
      context.missing(_mechanismMeta);
    }
    if (data.containsKey('root_locator')) {
      context.handle(
        _rootLocatorMeta,
        rootLocator.isAcceptableOrUnknown(
          data['root_locator']!,
          _rootLocatorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_rootLocatorMeta);
    }
    if (data.containsKey('display_path')) {
      context.handle(
        _displayPathMeta,
        displayPath.isAcceptableOrUnknown(
          data['display_path']!,
          _displayPathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayPathMeta);
    }
    if (data.containsKey('added_at')) {
      context.handle(
        _addedAtMeta,
        addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_addedAtMeta);
    }
    if (data.containsKey('media_scope')) {
      context.handle(
        _mediaScopeMeta,
        mediaScope.isAcceptableOrUnknown(data['media_scope']!, _mediaScopeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ImportRoot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ImportRoot(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      mechanism: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mechanism'],
      )!,
      rootLocator: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}root_locator'],
      )!,
      displayPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_path'],
      )!,
      addedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}added_at'],
      )!,
      mediaScope: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}media_scope'],
      )!,
    );
  }

  @override
  $ImportRootsTable createAlias(String alias) {
    return $ImportRootsTable(attachedDatabase, alias);
  }
}

class ImportRoot extends DataClass implements Insertable<ImportRoot> {
  final String id;
  final String mechanism;
  final String rootLocator;
  final String displayPath;
  final DateTime addedAt;
  final String mediaScope;
  const ImportRoot({
    required this.id,
    required this.mechanism,
    required this.rootLocator,
    required this.displayPath,
    required this.addedAt,
    required this.mediaScope,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['mechanism'] = Variable<String>(mechanism);
    map['root_locator'] = Variable<String>(rootLocator);
    map['display_path'] = Variable<String>(displayPath);
    map['added_at'] = Variable<DateTime>(addedAt);
    map['media_scope'] = Variable<String>(mediaScope);
    return map;
  }

  ImportRootsCompanion toCompanion(bool nullToAbsent) {
    return ImportRootsCompanion(
      id: Value(id),
      mechanism: Value(mechanism),
      rootLocator: Value(rootLocator),
      displayPath: Value(displayPath),
      addedAt: Value(addedAt),
      mediaScope: Value(mediaScope),
    );
  }

  factory ImportRoot.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ImportRoot(
      id: serializer.fromJson<String>(json['id']),
      mechanism: serializer.fromJson<String>(json['mechanism']),
      rootLocator: serializer.fromJson<String>(json['rootLocator']),
      displayPath: serializer.fromJson<String>(json['displayPath']),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
      mediaScope: serializer.fromJson<String>(json['mediaScope']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'mechanism': serializer.toJson<String>(mechanism),
      'rootLocator': serializer.toJson<String>(rootLocator),
      'displayPath': serializer.toJson<String>(displayPath),
      'addedAt': serializer.toJson<DateTime>(addedAt),
      'mediaScope': serializer.toJson<String>(mediaScope),
    };
  }

  ImportRoot copyWith({
    String? id,
    String? mechanism,
    String? rootLocator,
    String? displayPath,
    DateTime? addedAt,
    String? mediaScope,
  }) => ImportRoot(
    id: id ?? this.id,
    mechanism: mechanism ?? this.mechanism,
    rootLocator: rootLocator ?? this.rootLocator,
    displayPath: displayPath ?? this.displayPath,
    addedAt: addedAt ?? this.addedAt,
    mediaScope: mediaScope ?? this.mediaScope,
  );
  ImportRoot copyWithCompanion(ImportRootsCompanion data) {
    return ImportRoot(
      id: data.id.present ? data.id.value : this.id,
      mechanism: data.mechanism.present ? data.mechanism.value : this.mechanism,
      rootLocator: data.rootLocator.present
          ? data.rootLocator.value
          : this.rootLocator,
      displayPath: data.displayPath.present
          ? data.displayPath.value
          : this.displayPath,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
      mediaScope: data.mediaScope.present
          ? data.mediaScope.value
          : this.mediaScope,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ImportRoot(')
          ..write('id: $id, ')
          ..write('mechanism: $mechanism, ')
          ..write('rootLocator: $rootLocator, ')
          ..write('displayPath: $displayPath, ')
          ..write('addedAt: $addedAt, ')
          ..write('mediaScope: $mediaScope')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, mechanism, rootLocator, displayPath, addedAt, mediaScope);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ImportRoot &&
          other.id == this.id &&
          other.mechanism == this.mechanism &&
          other.rootLocator == this.rootLocator &&
          other.displayPath == this.displayPath &&
          other.addedAt == this.addedAt &&
          other.mediaScope == this.mediaScope);
}

class ImportRootsCompanion extends UpdateCompanion<ImportRoot> {
  final Value<String> id;
  final Value<String> mechanism;
  final Value<String> rootLocator;
  final Value<String> displayPath;
  final Value<DateTime> addedAt;
  final Value<String> mediaScope;
  final Value<int> rowid;
  const ImportRootsCompanion({
    this.id = const Value.absent(),
    this.mechanism = const Value.absent(),
    this.rootLocator = const Value.absent(),
    this.displayPath = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.mediaScope = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ImportRootsCompanion.insert({
    required String id,
    required String mechanism,
    required String rootLocator,
    required String displayPath,
    required DateTime addedAt,
    this.mediaScope = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       mechanism = Value(mechanism),
       rootLocator = Value(rootLocator),
       displayPath = Value(displayPath),
       addedAt = Value(addedAt);
  static Insertable<ImportRoot> custom({
    Expression<String>? id,
    Expression<String>? mechanism,
    Expression<String>? rootLocator,
    Expression<String>? displayPath,
    Expression<DateTime>? addedAt,
    Expression<String>? mediaScope,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mechanism != null) 'mechanism': mechanism,
      if (rootLocator != null) 'root_locator': rootLocator,
      if (displayPath != null) 'display_path': displayPath,
      if (addedAt != null) 'added_at': addedAt,
      if (mediaScope != null) 'media_scope': mediaScope,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ImportRootsCompanion copyWith({
    Value<String>? id,
    Value<String>? mechanism,
    Value<String>? rootLocator,
    Value<String>? displayPath,
    Value<DateTime>? addedAt,
    Value<String>? mediaScope,
    Value<int>? rowid,
  }) {
    return ImportRootsCompanion(
      id: id ?? this.id,
      mechanism: mechanism ?? this.mechanism,
      rootLocator: rootLocator ?? this.rootLocator,
      displayPath: displayPath ?? this.displayPath,
      addedAt: addedAt ?? this.addedAt,
      mediaScope: mediaScope ?? this.mediaScope,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (mechanism.present) {
      map['mechanism'] = Variable<String>(mechanism.value);
    }
    if (rootLocator.present) {
      map['root_locator'] = Variable<String>(rootLocator.value);
    }
    if (displayPath.present) {
      map['display_path'] = Variable<String>(displayPath.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    if (mediaScope.present) {
      map['media_scope'] = Variable<String>(mediaScope.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ImportRootsCompanion(')
          ..write('id: $id, ')
          ..write('mechanism: $mechanism, ')
          ..write('rootLocator: $rootLocator, ')
          ..write('displayPath: $displayPath, ')
          ..write('addedAt: $addedAt, ')
          ..write('mediaScope: $mediaScope, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StreamPlaylistsTable extends StreamPlaylists
    with TableInfo<$StreamPlaylistsTable, StreamPlaylist> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StreamPlaylistsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceKindMeta = const VerificationMeta(
    'sourceKind',
  );
  @override
  late final GeneratedColumn<String> sourceKind = GeneratedColumn<String>(
    'source_kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceUriMeta = const VerificationMeta(
    'sourceUri',
  );
  @override
  late final GeneratedColumn<String> sourceUri = GeneratedColumn<String>(
    'source_uri',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _lastRefreshedMeta = const VerificationMeta(
    'lastRefreshed',
  );
  @override
  late final GeneratedColumn<DateTime> lastRefreshed =
      GeneratedColumn<DateTime>(
        'last_refreshed',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    sourceKind,
    sourceUri,
    createdAt,
    lastRefreshed,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stream_playlists';
  @override
  VerificationContext validateIntegrity(
    Insertable<StreamPlaylist> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('source_kind')) {
      context.handle(
        _sourceKindMeta,
        sourceKind.isAcceptableOrUnknown(data['source_kind']!, _sourceKindMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceKindMeta);
    }
    if (data.containsKey('source_uri')) {
      context.handle(
        _sourceUriMeta,
        sourceUri.isAcceptableOrUnknown(data['source_uri']!, _sourceUriMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceUriMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('last_refreshed')) {
      context.handle(
        _lastRefreshedMeta,
        lastRefreshed.isAcceptableOrUnknown(
          data['last_refreshed']!,
          _lastRefreshedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StreamPlaylist map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StreamPlaylist(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      sourceKind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_kind'],
      )!,
      sourceUri: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_uri'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      lastRefreshed: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_refreshed'],
      ),
    );
  }

  @override
  $StreamPlaylistsTable createAlias(String alias) {
    return $StreamPlaylistsTable(attachedDatabase, alias);
  }
}

class StreamPlaylist extends DataClass implements Insertable<StreamPlaylist> {
  final int id;
  final String title;
  final String sourceKind;
  final String sourceUri;
  final DateTime createdAt;
  final DateTime? lastRefreshed;
  const StreamPlaylist({
    required this.id,
    required this.title,
    required this.sourceKind,
    required this.sourceUri,
    required this.createdAt,
    this.lastRefreshed,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['source_kind'] = Variable<String>(sourceKind);
    map['source_uri'] = Variable<String>(sourceUri);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || lastRefreshed != null) {
      map['last_refreshed'] = Variable<DateTime>(lastRefreshed);
    }
    return map;
  }

  StreamPlaylistsCompanion toCompanion(bool nullToAbsent) {
    return StreamPlaylistsCompanion(
      id: Value(id),
      title: Value(title),
      sourceKind: Value(sourceKind),
      sourceUri: Value(sourceUri),
      createdAt: Value(createdAt),
      lastRefreshed: lastRefreshed == null && nullToAbsent
          ? const Value.absent()
          : Value(lastRefreshed),
    );
  }

  factory StreamPlaylist.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StreamPlaylist(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      sourceKind: serializer.fromJson<String>(json['sourceKind']),
      sourceUri: serializer.fromJson<String>(json['sourceUri']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastRefreshed: serializer.fromJson<DateTime?>(json['lastRefreshed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'sourceKind': serializer.toJson<String>(sourceKind),
      'sourceUri': serializer.toJson<String>(sourceUri),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastRefreshed': serializer.toJson<DateTime?>(lastRefreshed),
    };
  }

  StreamPlaylist copyWith({
    int? id,
    String? title,
    String? sourceKind,
    String? sourceUri,
    DateTime? createdAt,
    Value<DateTime?> lastRefreshed = const Value.absent(),
  }) => StreamPlaylist(
    id: id ?? this.id,
    title: title ?? this.title,
    sourceKind: sourceKind ?? this.sourceKind,
    sourceUri: sourceUri ?? this.sourceUri,
    createdAt: createdAt ?? this.createdAt,
    lastRefreshed: lastRefreshed.present
        ? lastRefreshed.value
        : this.lastRefreshed,
  );
  StreamPlaylist copyWithCompanion(StreamPlaylistsCompanion data) {
    return StreamPlaylist(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      sourceKind: data.sourceKind.present
          ? data.sourceKind.value
          : this.sourceKind,
      sourceUri: data.sourceUri.present ? data.sourceUri.value : this.sourceUri,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastRefreshed: data.lastRefreshed.present
          ? data.lastRefreshed.value
          : this.lastRefreshed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StreamPlaylist(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('sourceKind: $sourceKind, ')
          ..write('sourceUri: $sourceUri, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastRefreshed: $lastRefreshed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, sourceKind, sourceUri, createdAt, lastRefreshed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StreamPlaylist &&
          other.id == this.id &&
          other.title == this.title &&
          other.sourceKind == this.sourceKind &&
          other.sourceUri == this.sourceUri &&
          other.createdAt == this.createdAt &&
          other.lastRefreshed == this.lastRefreshed);
}

class StreamPlaylistsCompanion extends UpdateCompanion<StreamPlaylist> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> sourceKind;
  final Value<String> sourceUri;
  final Value<DateTime> createdAt;
  final Value<DateTime?> lastRefreshed;
  const StreamPlaylistsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.sourceKind = const Value.absent(),
    this.sourceUri = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastRefreshed = const Value.absent(),
  });
  StreamPlaylistsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String sourceKind,
    required String sourceUri,
    this.createdAt = const Value.absent(),
    this.lastRefreshed = const Value.absent(),
  }) : title = Value(title),
       sourceKind = Value(sourceKind),
       sourceUri = Value(sourceUri);
  static Insertable<StreamPlaylist> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? sourceKind,
    Expression<String>? sourceUri,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastRefreshed,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (sourceKind != null) 'source_kind': sourceKind,
      if (sourceUri != null) 'source_uri': sourceUri,
      if (createdAt != null) 'created_at': createdAt,
      if (lastRefreshed != null) 'last_refreshed': lastRefreshed,
    });
  }

  StreamPlaylistsCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String>? sourceKind,
    Value<String>? sourceUri,
    Value<DateTime>? createdAt,
    Value<DateTime?>? lastRefreshed,
  }) {
    return StreamPlaylistsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      sourceKind: sourceKind ?? this.sourceKind,
      sourceUri: sourceUri ?? this.sourceUri,
      createdAt: createdAt ?? this.createdAt,
      lastRefreshed: lastRefreshed ?? this.lastRefreshed,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (sourceKind.present) {
      map['source_kind'] = Variable<String>(sourceKind.value);
    }
    if (sourceUri.present) {
      map['source_uri'] = Variable<String>(sourceUri.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastRefreshed.present) {
      map['last_refreshed'] = Variable<DateTime>(lastRefreshed.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StreamPlaylistsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('sourceKind: $sourceKind, ')
          ..write('sourceUri: $sourceUri, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastRefreshed: $lastRefreshed')
          ..write(')'))
        .toString();
  }
}

class $StreamChannelsTable extends StreamChannels
    with TableInfo<$StreamChannelsTable, StreamChannel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StreamChannelsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _tvgIdMeta = const VerificationMeta('tvgId');
  @override
  late final GeneratedColumn<String> tvgId = GeneratedColumn<String>(
    'tvg_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _logoMeta = const VerificationMeta('logo');
  @override
  late final GeneratedColumn<String> logo = GeneratedColumn<String>(
    'logo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _groupTitleMeta = const VerificationMeta(
    'groupTitle',
  );
  @override
  late final GeneratedColumn<String> groupTitle = GeneratedColumn<String>(
    'group_title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _streamUrlMeta = const VerificationMeta(
    'streamUrl',
  );
  @override
  late final GeneratedColumn<String> streamUrl = GeneratedColumn<String>(
    'stream_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  List<GeneratedColumn> get $columns => [
    id,
    playlistId,
    tvgId,
    title,
    logo,
    groupTitle,
    streamUrl,
    isFavorite,
    position,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stream_channels';
  @override
  VerificationContext validateIntegrity(
    Insertable<StreamChannel> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('playlist_id')) {
      context.handle(
        _playlistIdMeta,
        playlistId.isAcceptableOrUnknown(data['playlist_id']!, _playlistIdMeta),
      );
    } else if (isInserting) {
      context.missing(_playlistIdMeta);
    }
    if (data.containsKey('tvg_id')) {
      context.handle(
        _tvgIdMeta,
        tvgId.isAcceptableOrUnknown(data['tvg_id']!, _tvgIdMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('logo')) {
      context.handle(
        _logoMeta,
        logo.isAcceptableOrUnknown(data['logo']!, _logoMeta),
      );
    }
    if (data.containsKey('group_title')) {
      context.handle(
        _groupTitleMeta,
        groupTitle.isAcceptableOrUnknown(data['group_title']!, _groupTitleMeta),
      );
    }
    if (data.containsKey('stream_url')) {
      context.handle(
        _streamUrlMeta,
        streamUrl.isAcceptableOrUnknown(data['stream_url']!, _streamUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_streamUrlMeta);
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StreamChannel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StreamChannel(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      playlistId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}playlist_id'],
      )!,
      tvgId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tvg_id'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      logo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}logo'],
      ),
      groupTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_title'],
      ),
      streamUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stream_url'],
      )!,
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
    );
  }

  @override
  $StreamChannelsTable createAlias(String alias) {
    return $StreamChannelsTable(attachedDatabase, alias);
  }
}

class StreamChannel extends DataClass implements Insertable<StreamChannel> {
  final int id;
  final int playlistId;
  final String? tvgId;
  final String title;
  final String? logo;
  final String? groupTitle;
  final String streamUrl;
  final bool isFavorite;
  final int position;
  const StreamChannel({
    required this.id,
    required this.playlistId,
    this.tvgId,
    required this.title,
    this.logo,
    this.groupTitle,
    required this.streamUrl,
    required this.isFavorite,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['playlist_id'] = Variable<int>(playlistId);
    if (!nullToAbsent || tvgId != null) {
      map['tvg_id'] = Variable<String>(tvgId);
    }
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || logo != null) {
      map['logo'] = Variable<String>(logo);
    }
    if (!nullToAbsent || groupTitle != null) {
      map['group_title'] = Variable<String>(groupTitle);
    }
    map['stream_url'] = Variable<String>(streamUrl);
    map['is_favorite'] = Variable<bool>(isFavorite);
    map['position'] = Variable<int>(position);
    return map;
  }

  StreamChannelsCompanion toCompanion(bool nullToAbsent) {
    return StreamChannelsCompanion(
      id: Value(id),
      playlistId: Value(playlistId),
      tvgId: tvgId == null && nullToAbsent
          ? const Value.absent()
          : Value(tvgId),
      title: Value(title),
      logo: logo == null && nullToAbsent ? const Value.absent() : Value(logo),
      groupTitle: groupTitle == null && nullToAbsent
          ? const Value.absent()
          : Value(groupTitle),
      streamUrl: Value(streamUrl),
      isFavorite: Value(isFavorite),
      position: Value(position),
    );
  }

  factory StreamChannel.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StreamChannel(
      id: serializer.fromJson<int>(json['id']),
      playlistId: serializer.fromJson<int>(json['playlistId']),
      tvgId: serializer.fromJson<String?>(json['tvgId']),
      title: serializer.fromJson<String>(json['title']),
      logo: serializer.fromJson<String?>(json['logo']),
      groupTitle: serializer.fromJson<String?>(json['groupTitle']),
      streamUrl: serializer.fromJson<String>(json['streamUrl']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'playlistId': serializer.toJson<int>(playlistId),
      'tvgId': serializer.toJson<String?>(tvgId),
      'title': serializer.toJson<String>(title),
      'logo': serializer.toJson<String?>(logo),
      'groupTitle': serializer.toJson<String?>(groupTitle),
      'streamUrl': serializer.toJson<String>(streamUrl),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'position': serializer.toJson<int>(position),
    };
  }

  StreamChannel copyWith({
    int? id,
    int? playlistId,
    Value<String?> tvgId = const Value.absent(),
    String? title,
    Value<String?> logo = const Value.absent(),
    Value<String?> groupTitle = const Value.absent(),
    String? streamUrl,
    bool? isFavorite,
    int? position,
  }) => StreamChannel(
    id: id ?? this.id,
    playlistId: playlistId ?? this.playlistId,
    tvgId: tvgId.present ? tvgId.value : this.tvgId,
    title: title ?? this.title,
    logo: logo.present ? logo.value : this.logo,
    groupTitle: groupTitle.present ? groupTitle.value : this.groupTitle,
    streamUrl: streamUrl ?? this.streamUrl,
    isFavorite: isFavorite ?? this.isFavorite,
    position: position ?? this.position,
  );
  StreamChannel copyWithCompanion(StreamChannelsCompanion data) {
    return StreamChannel(
      id: data.id.present ? data.id.value : this.id,
      playlistId: data.playlistId.present
          ? data.playlistId.value
          : this.playlistId,
      tvgId: data.tvgId.present ? data.tvgId.value : this.tvgId,
      title: data.title.present ? data.title.value : this.title,
      logo: data.logo.present ? data.logo.value : this.logo,
      groupTitle: data.groupTitle.present
          ? data.groupTitle.value
          : this.groupTitle,
      streamUrl: data.streamUrl.present ? data.streamUrl.value : this.streamUrl,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StreamChannel(')
          ..write('id: $id, ')
          ..write('playlistId: $playlistId, ')
          ..write('tvgId: $tvgId, ')
          ..write('title: $title, ')
          ..write('logo: $logo, ')
          ..write('groupTitle: $groupTitle, ')
          ..write('streamUrl: $streamUrl, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    playlistId,
    tvgId,
    title,
    logo,
    groupTitle,
    streamUrl,
    isFavorite,
    position,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StreamChannel &&
          other.id == this.id &&
          other.playlistId == this.playlistId &&
          other.tvgId == this.tvgId &&
          other.title == this.title &&
          other.logo == this.logo &&
          other.groupTitle == this.groupTitle &&
          other.streamUrl == this.streamUrl &&
          other.isFavorite == this.isFavorite &&
          other.position == this.position);
}

class StreamChannelsCompanion extends UpdateCompanion<StreamChannel> {
  final Value<int> id;
  final Value<int> playlistId;
  final Value<String?> tvgId;
  final Value<String> title;
  final Value<String?> logo;
  final Value<String?> groupTitle;
  final Value<String> streamUrl;
  final Value<bool> isFavorite;
  final Value<int> position;
  const StreamChannelsCompanion({
    this.id = const Value.absent(),
    this.playlistId = const Value.absent(),
    this.tvgId = const Value.absent(),
    this.title = const Value.absent(),
    this.logo = const Value.absent(),
    this.groupTitle = const Value.absent(),
    this.streamUrl = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.position = const Value.absent(),
  });
  StreamChannelsCompanion.insert({
    this.id = const Value.absent(),
    required int playlistId,
    this.tvgId = const Value.absent(),
    required String title,
    this.logo = const Value.absent(),
    this.groupTitle = const Value.absent(),
    required String streamUrl,
    this.isFavorite = const Value.absent(),
    required int position,
  }) : playlistId = Value(playlistId),
       title = Value(title),
       streamUrl = Value(streamUrl),
       position = Value(position);
  static Insertable<StreamChannel> custom({
    Expression<int>? id,
    Expression<int>? playlistId,
    Expression<String>? tvgId,
    Expression<String>? title,
    Expression<String>? logo,
    Expression<String>? groupTitle,
    Expression<String>? streamUrl,
    Expression<bool>? isFavorite,
    Expression<int>? position,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (playlistId != null) 'playlist_id': playlistId,
      if (tvgId != null) 'tvg_id': tvgId,
      if (title != null) 'title': title,
      if (logo != null) 'logo': logo,
      if (groupTitle != null) 'group_title': groupTitle,
      if (streamUrl != null) 'stream_url': streamUrl,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (position != null) 'position': position,
    });
  }

  StreamChannelsCompanion copyWith({
    Value<int>? id,
    Value<int>? playlistId,
    Value<String?>? tvgId,
    Value<String>? title,
    Value<String?>? logo,
    Value<String?>? groupTitle,
    Value<String>? streamUrl,
    Value<bool>? isFavorite,
    Value<int>? position,
  }) {
    return StreamChannelsCompanion(
      id: id ?? this.id,
      playlistId: playlistId ?? this.playlistId,
      tvgId: tvgId ?? this.tvgId,
      title: title ?? this.title,
      logo: logo ?? this.logo,
      groupTitle: groupTitle ?? this.groupTitle,
      streamUrl: streamUrl ?? this.streamUrl,
      isFavorite: isFavorite ?? this.isFavorite,
      position: position ?? this.position,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (playlistId.present) {
      map['playlist_id'] = Variable<int>(playlistId.value);
    }
    if (tvgId.present) {
      map['tvg_id'] = Variable<String>(tvgId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (logo.present) {
      map['logo'] = Variable<String>(logo.value);
    }
    if (groupTitle.present) {
      map['group_title'] = Variable<String>(groupTitle.value);
    }
    if (streamUrl.present) {
      map['stream_url'] = Variable<String>(streamUrl.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StreamChannelsCompanion(')
          ..write('id: $id, ')
          ..write('playlistId: $playlistId, ')
          ..write('tvgId: $tvgId, ')
          ..write('title: $title, ')
          ..write('logo: $logo, ')
          ..write('groupTitle: $groupTitle, ')
          ..write('streamUrl: $streamUrl, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('position: $position')
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
  late final $LocalFilesTable localFiles = $LocalFilesTable(this);
  late final $ImportRootsTable importRoots = $ImportRootsTable(this);
  late final $StreamPlaylistsTable streamPlaylists = $StreamPlaylistsTable(
    this,
  );
  late final $StreamChannelsTable streamChannels = $StreamChannelsTable(this);
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
    localFiles,
    importRoots,
    streamPlaylists,
    streamChannels,
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
          TrackEntry,
          $$TracksTableFilterComposer,
          $$TracksTableOrderingComposer,
          $$TracksTableAnnotationComposer,
          $$TracksTableCreateCompanionBuilder,
          $$TracksTableUpdateCompanionBuilder,
          (TrackEntry, BaseReferences<_$AppDatabase, $TracksTable, TrackEntry>),
          TrackEntry,
          PrefetchHooks Function()
        > {
  $$TracksTableTableManager(_$AppDatabase db, $TracksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TracksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TracksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TracksTableAnnotationComposer($db: db, $table: table),
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
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TracksTable, TrackEntry>(table),
                  BaseReferences<_$AppDatabase, $TracksTable, TrackEntry>(
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
      TrackEntry,
      $$TracksTableFilterComposer,
      $$TracksTableOrderingComposer,
      $$TracksTableAnnotationComposer,
      $$TracksTableCreateCompanionBuilder,
      $$TracksTableUpdateCompanionBuilder,
      (TrackEntry, BaseReferences<_$AppDatabase, $TracksTable, TrackEntry>),
      TrackEntry,
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
          createFilteringComposer: () =>
              $$ArtistsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ArtistsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ArtistsTableAnnotationComposer($db: db, $table: table),
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
          withReferenceMapper: (p0) => p0
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
          createFilteringComposer: () =>
              $$AlbumsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AlbumsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AlbumsTableAnnotationComposer($db: db, $table: table),
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
          withReferenceMapper: (p0) => p0
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
          createFilteringComposer: () =>
              $$PlaylistsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlaylistsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlaylistsTableAnnotationComposer($db: db, $table: table),
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
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PlaylistsTable, Playlist>(table),
                  BaseReferences<_$AppDatabase, $PlaylistsTable, Playlist>(
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
      Value<int> id,
      required int playlistId,
      required String trackSpotifyId,
      required int position,
    });
typedef $$PlaylistTracksTableUpdateCompanionBuilder =
    PlaylistTracksCompanion Function({
      Value<int> id,
      Value<int> playlistId,
      Value<String> trackSpotifyId,
      Value<int> position,
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
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

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
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

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
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

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
          createFilteringComposer: () =>
              $$PlaylistTracksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlaylistTracksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlaylistTracksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> playlistId = const Value.absent(),
                Value<String> trackSpotifyId = const Value.absent(),
                Value<int> position = const Value.absent(),
              }) => PlaylistTracksCompanion(
                id: id,
                playlistId: playlistId,
                trackSpotifyId: trackSpotifyId,
                position: position,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int playlistId,
                required String trackSpotifyId,
                required int position,
              }) => PlaylistTracksCompanion.insert(
                id: id,
                playlistId: playlistId,
                trackSpotifyId: trackSpotifyId,
                position: position,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PlaylistTracksTable, PlaylistTrack>(table),
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
          createFilteringComposer: () =>
              $$RadiosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RadiosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RadiosTableAnnotationComposer($db: db, $table: table),
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
          withReferenceMapper: (p0) => p0
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
          createFilteringComposer: () =>
              $$CatalogCacheEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CatalogCacheEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CatalogCacheEntriesTableAnnotationComposer(
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
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CatalogCacheEntriesTable, CatalogCacheEntry>(
                    table,
                  ),
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
typedef $$LocalFilesTableCreateCompanionBuilder =
    LocalFilesCompanion Function({
      required String libraryId,
      required String mechanism,
      required String locator,
      required String displayPath,
      required String deduplicationKey,
      Value<String> availabilityStatus,
      required DateTime lastScannedAt,
      Value<String?> importRootLocator,
      Value<String?> albumArtist,
      Value<String?> albumGroupKey,
      Value<int?> trackNumber,
      Value<int?> trackTotal,
      Value<int?> discNumber,
      Value<int?> discTotal,
      Value<String?> genre,
      Value<int?> releaseYear,
      Value<String?> artworkPath,
      Value<String?> artworkMimeType,
      Value<DateTime> addedAt,
      Value<bool> isVideo,
      Value<int> rowid,
    });
typedef $$LocalFilesTableUpdateCompanionBuilder =
    LocalFilesCompanion Function({
      Value<String> libraryId,
      Value<String> mechanism,
      Value<String> locator,
      Value<String> displayPath,
      Value<String> deduplicationKey,
      Value<String> availabilityStatus,
      Value<DateTime> lastScannedAt,
      Value<String?> importRootLocator,
      Value<String?> albumArtist,
      Value<String?> albumGroupKey,
      Value<int?> trackNumber,
      Value<int?> trackTotal,
      Value<int?> discNumber,
      Value<int?> discTotal,
      Value<String?> genre,
      Value<int?> releaseYear,
      Value<String?> artworkPath,
      Value<String?> artworkMimeType,
      Value<DateTime> addedAt,
      Value<bool> isVideo,
      Value<int> rowid,
    });

class $$LocalFilesTableFilterComposer
    extends Composer<_$AppDatabase, $LocalFilesTable> {
  $$LocalFilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get libraryId => $composableBuilder(
    column: $table.libraryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mechanism => $composableBuilder(
    column: $table.mechanism,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locator => $composableBuilder(
    column: $table.locator,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayPath => $composableBuilder(
    column: $table.displayPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deduplicationKey => $composableBuilder(
    column: $table.deduplicationKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get availabilityStatus => $composableBuilder(
    column: $table.availabilityStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastScannedAt => $composableBuilder(
    column: $table.lastScannedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get importRootLocator => $composableBuilder(
    column: $table.importRootLocator,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get albumArtist => $composableBuilder(
    column: $table.albumArtist,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get albumGroupKey => $composableBuilder(
    column: $table.albumGroupKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get trackNumber => $composableBuilder(
    column: $table.trackNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get trackTotal => $composableBuilder(
    column: $table.trackTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get discNumber => $composableBuilder(
    column: $table.discNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get discTotal => $composableBuilder(
    column: $table.discTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get genre => $composableBuilder(
    column: $table.genre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get releaseYear => $composableBuilder(
    column: $table.releaseYear,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get artworkPath => $composableBuilder(
    column: $table.artworkPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get artworkMimeType => $composableBuilder(
    column: $table.artworkMimeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isVideo => $composableBuilder(
    column: $table.isVideo,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalFilesTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalFilesTable> {
  $$LocalFilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get libraryId => $composableBuilder(
    column: $table.libraryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mechanism => $composableBuilder(
    column: $table.mechanism,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locator => $composableBuilder(
    column: $table.locator,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayPath => $composableBuilder(
    column: $table.displayPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deduplicationKey => $composableBuilder(
    column: $table.deduplicationKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get availabilityStatus => $composableBuilder(
    column: $table.availabilityStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastScannedAt => $composableBuilder(
    column: $table.lastScannedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get importRootLocator => $composableBuilder(
    column: $table.importRootLocator,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get albumArtist => $composableBuilder(
    column: $table.albumArtist,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get albumGroupKey => $composableBuilder(
    column: $table.albumGroupKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get trackNumber => $composableBuilder(
    column: $table.trackNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get trackTotal => $composableBuilder(
    column: $table.trackTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get discNumber => $composableBuilder(
    column: $table.discNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get discTotal => $composableBuilder(
    column: $table.discTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get genre => $composableBuilder(
    column: $table.genre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get releaseYear => $composableBuilder(
    column: $table.releaseYear,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get artworkPath => $composableBuilder(
    column: $table.artworkPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get artworkMimeType => $composableBuilder(
    column: $table.artworkMimeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isVideo => $composableBuilder(
    column: $table.isVideo,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalFilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalFilesTable> {
  $$LocalFilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get libraryId =>
      $composableBuilder(column: $table.libraryId, builder: (column) => column);

  GeneratedColumn<String> get mechanism =>
      $composableBuilder(column: $table.mechanism, builder: (column) => column);

  GeneratedColumn<String> get locator =>
      $composableBuilder(column: $table.locator, builder: (column) => column);

  GeneratedColumn<String> get displayPath => $composableBuilder(
    column: $table.displayPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deduplicationKey => $composableBuilder(
    column: $table.deduplicationKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get availabilityStatus => $composableBuilder(
    column: $table.availabilityStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastScannedAt => $composableBuilder(
    column: $table.lastScannedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get importRootLocator => $composableBuilder(
    column: $table.importRootLocator,
    builder: (column) => column,
  );

  GeneratedColumn<String> get albumArtist => $composableBuilder(
    column: $table.albumArtist,
    builder: (column) => column,
  );

  GeneratedColumn<String> get albumGroupKey => $composableBuilder(
    column: $table.albumGroupKey,
    builder: (column) => column,
  );

  GeneratedColumn<int> get trackNumber => $composableBuilder(
    column: $table.trackNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get trackTotal => $composableBuilder(
    column: $table.trackTotal,
    builder: (column) => column,
  );

  GeneratedColumn<int> get discNumber => $composableBuilder(
    column: $table.discNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get discTotal =>
      $composableBuilder(column: $table.discTotal, builder: (column) => column);

  GeneratedColumn<String> get genre =>
      $composableBuilder(column: $table.genre, builder: (column) => column);

  GeneratedColumn<int> get releaseYear => $composableBuilder(
    column: $table.releaseYear,
    builder: (column) => column,
  );

  GeneratedColumn<String> get artworkPath => $composableBuilder(
    column: $table.artworkPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get artworkMimeType => $composableBuilder(
    column: $table.artworkMimeType,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);

  GeneratedColumn<bool> get isVideo =>
      $composableBuilder(column: $table.isVideo, builder: (column) => column);
}

class $$LocalFilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalFilesTable,
          LocalFile,
          $$LocalFilesTableFilterComposer,
          $$LocalFilesTableOrderingComposer,
          $$LocalFilesTableAnnotationComposer,
          $$LocalFilesTableCreateCompanionBuilder,
          $$LocalFilesTableUpdateCompanionBuilder,
          (
            LocalFile,
            BaseReferences<_$AppDatabase, $LocalFilesTable, LocalFile>,
          ),
          LocalFile,
          PrefetchHooks Function()
        > {
  $$LocalFilesTableTableManager(_$AppDatabase db, $LocalFilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalFilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalFilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalFilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> libraryId = const Value.absent(),
                Value<String> mechanism = const Value.absent(),
                Value<String> locator = const Value.absent(),
                Value<String> displayPath = const Value.absent(),
                Value<String> deduplicationKey = const Value.absent(),
                Value<String> availabilityStatus = const Value.absent(),
                Value<DateTime> lastScannedAt = const Value.absent(),
                Value<String?> importRootLocator = const Value.absent(),
                Value<String?> albumArtist = const Value.absent(),
                Value<String?> albumGroupKey = const Value.absent(),
                Value<int?> trackNumber = const Value.absent(),
                Value<int?> trackTotal = const Value.absent(),
                Value<int?> discNumber = const Value.absent(),
                Value<int?> discTotal = const Value.absent(),
                Value<String?> genre = const Value.absent(),
                Value<int?> releaseYear = const Value.absent(),
                Value<String?> artworkPath = const Value.absent(),
                Value<String?> artworkMimeType = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
                Value<bool> isVideo = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalFilesCompanion(
                libraryId: libraryId,
                mechanism: mechanism,
                locator: locator,
                displayPath: displayPath,
                deduplicationKey: deduplicationKey,
                availabilityStatus: availabilityStatus,
                lastScannedAt: lastScannedAt,
                importRootLocator: importRootLocator,
                albumArtist: albumArtist,
                albumGroupKey: albumGroupKey,
                trackNumber: trackNumber,
                trackTotal: trackTotal,
                discNumber: discNumber,
                discTotal: discTotal,
                genre: genre,
                releaseYear: releaseYear,
                artworkPath: artworkPath,
                artworkMimeType: artworkMimeType,
                addedAt: addedAt,
                isVideo: isVideo,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String libraryId,
                required String mechanism,
                required String locator,
                required String displayPath,
                required String deduplicationKey,
                Value<String> availabilityStatus = const Value.absent(),
                required DateTime lastScannedAt,
                Value<String?> importRootLocator = const Value.absent(),
                Value<String?> albumArtist = const Value.absent(),
                Value<String?> albumGroupKey = const Value.absent(),
                Value<int?> trackNumber = const Value.absent(),
                Value<int?> trackTotal = const Value.absent(),
                Value<int?> discNumber = const Value.absent(),
                Value<int?> discTotal = const Value.absent(),
                Value<String?> genre = const Value.absent(),
                Value<int?> releaseYear = const Value.absent(),
                Value<String?> artworkPath = const Value.absent(),
                Value<String?> artworkMimeType = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
                Value<bool> isVideo = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalFilesCompanion.insert(
                libraryId: libraryId,
                mechanism: mechanism,
                locator: locator,
                displayPath: displayPath,
                deduplicationKey: deduplicationKey,
                availabilityStatus: availabilityStatus,
                lastScannedAt: lastScannedAt,
                importRootLocator: importRootLocator,
                albumArtist: albumArtist,
                albumGroupKey: albumGroupKey,
                trackNumber: trackNumber,
                trackTotal: trackTotal,
                discNumber: discNumber,
                discTotal: discTotal,
                genre: genre,
                releaseYear: releaseYear,
                artworkPath: artworkPath,
                artworkMimeType: artworkMimeType,
                addedAt: addedAt,
                isVideo: isVideo,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LocalFilesTable, LocalFile>(table),
                  BaseReferences<_$AppDatabase, $LocalFilesTable, LocalFile>(
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

typedef $$LocalFilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalFilesTable,
      LocalFile,
      $$LocalFilesTableFilterComposer,
      $$LocalFilesTableOrderingComposer,
      $$LocalFilesTableAnnotationComposer,
      $$LocalFilesTableCreateCompanionBuilder,
      $$LocalFilesTableUpdateCompanionBuilder,
      (LocalFile, BaseReferences<_$AppDatabase, $LocalFilesTable, LocalFile>),
      LocalFile,
      PrefetchHooks Function()
    >;
typedef $$ImportRootsTableCreateCompanionBuilder =
    ImportRootsCompanion Function({
      required String id,
      required String mechanism,
      required String rootLocator,
      required String displayPath,
      required DateTime addedAt,
      Value<String> mediaScope,
      Value<int> rowid,
    });
typedef $$ImportRootsTableUpdateCompanionBuilder =
    ImportRootsCompanion Function({
      Value<String> id,
      Value<String> mechanism,
      Value<String> rootLocator,
      Value<String> displayPath,
      Value<DateTime> addedAt,
      Value<String> mediaScope,
      Value<int> rowid,
    });

class $$ImportRootsTableFilterComposer
    extends Composer<_$AppDatabase, $ImportRootsTable> {
  $$ImportRootsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mechanism => $composableBuilder(
    column: $table.mechanism,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rootLocator => $composableBuilder(
    column: $table.rootLocator,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayPath => $composableBuilder(
    column: $table.displayPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mediaScope => $composableBuilder(
    column: $table.mediaScope,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ImportRootsTableOrderingComposer
    extends Composer<_$AppDatabase, $ImportRootsTable> {
  $$ImportRootsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mechanism => $composableBuilder(
    column: $table.mechanism,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rootLocator => $composableBuilder(
    column: $table.rootLocator,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayPath => $composableBuilder(
    column: $table.displayPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mediaScope => $composableBuilder(
    column: $table.mediaScope,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ImportRootsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ImportRootsTable> {
  $$ImportRootsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get mechanism =>
      $composableBuilder(column: $table.mechanism, builder: (column) => column);

  GeneratedColumn<String> get rootLocator => $composableBuilder(
    column: $table.rootLocator,
    builder: (column) => column,
  );

  GeneratedColumn<String> get displayPath => $composableBuilder(
    column: $table.displayPath,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);

  GeneratedColumn<String> get mediaScope => $composableBuilder(
    column: $table.mediaScope,
    builder: (column) => column,
  );
}

class $$ImportRootsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ImportRootsTable,
          ImportRoot,
          $$ImportRootsTableFilterComposer,
          $$ImportRootsTableOrderingComposer,
          $$ImportRootsTableAnnotationComposer,
          $$ImportRootsTableCreateCompanionBuilder,
          $$ImportRootsTableUpdateCompanionBuilder,
          (
            ImportRoot,
            BaseReferences<_$AppDatabase, $ImportRootsTable, ImportRoot>,
          ),
          ImportRoot,
          PrefetchHooks Function()
        > {
  $$ImportRootsTableTableManager(_$AppDatabase db, $ImportRootsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ImportRootsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ImportRootsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ImportRootsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> mechanism = const Value.absent(),
                Value<String> rootLocator = const Value.absent(),
                Value<String> displayPath = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
                Value<String> mediaScope = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ImportRootsCompanion(
                id: id,
                mechanism: mechanism,
                rootLocator: rootLocator,
                displayPath: displayPath,
                addedAt: addedAt,
                mediaScope: mediaScope,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String mechanism,
                required String rootLocator,
                required String displayPath,
                required DateTime addedAt,
                Value<String> mediaScope = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ImportRootsCompanion.insert(
                id: id,
                mechanism: mechanism,
                rootLocator: rootLocator,
                displayPath: displayPath,
                addedAt: addedAt,
                mediaScope: mediaScope,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ImportRootsTable, ImportRoot>(table),
                  BaseReferences<_$AppDatabase, $ImportRootsTable, ImportRoot>(
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

typedef $$ImportRootsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ImportRootsTable,
      ImportRoot,
      $$ImportRootsTableFilterComposer,
      $$ImportRootsTableOrderingComposer,
      $$ImportRootsTableAnnotationComposer,
      $$ImportRootsTableCreateCompanionBuilder,
      $$ImportRootsTableUpdateCompanionBuilder,
      (
        ImportRoot,
        BaseReferences<_$AppDatabase, $ImportRootsTable, ImportRoot>,
      ),
      ImportRoot,
      PrefetchHooks Function()
    >;
typedef $$StreamPlaylistsTableCreateCompanionBuilder =
    StreamPlaylistsCompanion Function({
      Value<int> id,
      required String title,
      required String sourceKind,
      required String sourceUri,
      Value<DateTime> createdAt,
      Value<DateTime?> lastRefreshed,
    });
typedef $$StreamPlaylistsTableUpdateCompanionBuilder =
    StreamPlaylistsCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String> sourceKind,
      Value<String> sourceUri,
      Value<DateTime> createdAt,
      Value<DateTime?> lastRefreshed,
    });

class $$StreamPlaylistsTableFilterComposer
    extends Composer<_$AppDatabase, $StreamPlaylistsTable> {
  $$StreamPlaylistsTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceKind => $composableBuilder(
    column: $table.sourceKind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceUri => $composableBuilder(
    column: $table.sourceUri,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastRefreshed => $composableBuilder(
    column: $table.lastRefreshed,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StreamPlaylistsTableOrderingComposer
    extends Composer<_$AppDatabase, $StreamPlaylistsTable> {
  $$StreamPlaylistsTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceKind => $composableBuilder(
    column: $table.sourceKind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceUri => $composableBuilder(
    column: $table.sourceUri,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastRefreshed => $composableBuilder(
    column: $table.lastRefreshed,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StreamPlaylistsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StreamPlaylistsTable> {
  $$StreamPlaylistsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get sourceKind => $composableBuilder(
    column: $table.sourceKind,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceUri =>
      $composableBuilder(column: $table.sourceUri, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastRefreshed => $composableBuilder(
    column: $table.lastRefreshed,
    builder: (column) => column,
  );
}

class $$StreamPlaylistsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StreamPlaylistsTable,
          StreamPlaylist,
          $$StreamPlaylistsTableFilterComposer,
          $$StreamPlaylistsTableOrderingComposer,
          $$StreamPlaylistsTableAnnotationComposer,
          $$StreamPlaylistsTableCreateCompanionBuilder,
          $$StreamPlaylistsTableUpdateCompanionBuilder,
          (
            StreamPlaylist,
            BaseReferences<
              _$AppDatabase,
              $StreamPlaylistsTable,
              StreamPlaylist
            >,
          ),
          StreamPlaylist,
          PrefetchHooks Function()
        > {
  $$StreamPlaylistsTableTableManager(
    _$AppDatabase db,
    $StreamPlaylistsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StreamPlaylistsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StreamPlaylistsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StreamPlaylistsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> sourceKind = const Value.absent(),
                Value<String> sourceUri = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> lastRefreshed = const Value.absent(),
              }) => StreamPlaylistsCompanion(
                id: id,
                title: title,
                sourceKind: sourceKind,
                sourceUri: sourceUri,
                createdAt: createdAt,
                lastRefreshed: lastRefreshed,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required String sourceKind,
                required String sourceUri,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> lastRefreshed = const Value.absent(),
              }) => StreamPlaylistsCompanion.insert(
                id: id,
                title: title,
                sourceKind: sourceKind,
                sourceUri: sourceUri,
                createdAt: createdAt,
                lastRefreshed: lastRefreshed,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StreamPlaylistsTable, StreamPlaylist>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $StreamPlaylistsTable,
                    StreamPlaylist
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StreamPlaylistsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StreamPlaylistsTable,
      StreamPlaylist,
      $$StreamPlaylistsTableFilterComposer,
      $$StreamPlaylistsTableOrderingComposer,
      $$StreamPlaylistsTableAnnotationComposer,
      $$StreamPlaylistsTableCreateCompanionBuilder,
      $$StreamPlaylistsTableUpdateCompanionBuilder,
      (
        StreamPlaylist,
        BaseReferences<_$AppDatabase, $StreamPlaylistsTable, StreamPlaylist>,
      ),
      StreamPlaylist,
      PrefetchHooks Function()
    >;
typedef $$StreamChannelsTableCreateCompanionBuilder =
    StreamChannelsCompanion Function({
      Value<int> id,
      required int playlistId,
      Value<String?> tvgId,
      required String title,
      Value<String?> logo,
      Value<String?> groupTitle,
      required String streamUrl,
      Value<bool> isFavorite,
      required int position,
    });
typedef $$StreamChannelsTableUpdateCompanionBuilder =
    StreamChannelsCompanion Function({
      Value<int> id,
      Value<int> playlistId,
      Value<String?> tvgId,
      Value<String> title,
      Value<String?> logo,
      Value<String?> groupTitle,
      Value<String> streamUrl,
      Value<bool> isFavorite,
      Value<int> position,
    });

class $$StreamChannelsTableFilterComposer
    extends Composer<_$AppDatabase, $StreamChannelsTable> {
  $$StreamChannelsTableFilterComposer({
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

  ColumnFilters<int> get playlistId => $composableBuilder(
    column: $table.playlistId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tvgId => $composableBuilder(
    column: $table.tvgId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get logo => $composableBuilder(
    column: $table.logo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get groupTitle => $composableBuilder(
    column: $table.groupTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get streamUrl => $composableBuilder(
    column: $table.streamUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StreamChannelsTableOrderingComposer
    extends Composer<_$AppDatabase, $StreamChannelsTable> {
  $$StreamChannelsTableOrderingComposer({
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

  ColumnOrderings<int> get playlistId => $composableBuilder(
    column: $table.playlistId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tvgId => $composableBuilder(
    column: $table.tvgId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get logo => $composableBuilder(
    column: $table.logo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get groupTitle => $composableBuilder(
    column: $table.groupTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get streamUrl => $composableBuilder(
    column: $table.streamUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StreamChannelsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StreamChannelsTable> {
  $$StreamChannelsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get playlistId => $composableBuilder(
    column: $table.playlistId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tvgId =>
      $composableBuilder(column: $table.tvgId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get logo =>
      $composableBuilder(column: $table.logo, builder: (column) => column);

  GeneratedColumn<String> get groupTitle => $composableBuilder(
    column: $table.groupTitle,
    builder: (column) => column,
  );

  GeneratedColumn<String> get streamUrl =>
      $composableBuilder(column: $table.streamUrl, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);
}

class $$StreamChannelsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StreamChannelsTable,
          StreamChannel,
          $$StreamChannelsTableFilterComposer,
          $$StreamChannelsTableOrderingComposer,
          $$StreamChannelsTableAnnotationComposer,
          $$StreamChannelsTableCreateCompanionBuilder,
          $$StreamChannelsTableUpdateCompanionBuilder,
          (
            StreamChannel,
            BaseReferences<_$AppDatabase, $StreamChannelsTable, StreamChannel>,
          ),
          StreamChannel,
          PrefetchHooks Function()
        > {
  $$StreamChannelsTableTableManager(
    _$AppDatabase db,
    $StreamChannelsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StreamChannelsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StreamChannelsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StreamChannelsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> playlistId = const Value.absent(),
                Value<String?> tvgId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> logo = const Value.absent(),
                Value<String?> groupTitle = const Value.absent(),
                Value<String> streamUrl = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<int> position = const Value.absent(),
              }) => StreamChannelsCompanion(
                id: id,
                playlistId: playlistId,
                tvgId: tvgId,
                title: title,
                logo: logo,
                groupTitle: groupTitle,
                streamUrl: streamUrl,
                isFavorite: isFavorite,
                position: position,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int playlistId,
                Value<String?> tvgId = const Value.absent(),
                required String title,
                Value<String?> logo = const Value.absent(),
                Value<String?> groupTitle = const Value.absent(),
                required String streamUrl,
                Value<bool> isFavorite = const Value.absent(),
                required int position,
              }) => StreamChannelsCompanion.insert(
                id: id,
                playlistId: playlistId,
                tvgId: tvgId,
                title: title,
                logo: logo,
                groupTitle: groupTitle,
                streamUrl: streamUrl,
                isFavorite: isFavorite,
                position: position,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StreamChannelsTable, StreamChannel>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $StreamChannelsTable,
                    StreamChannel
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StreamChannelsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StreamChannelsTable,
      StreamChannel,
      $$StreamChannelsTableFilterComposer,
      $$StreamChannelsTableOrderingComposer,
      $$StreamChannelsTableAnnotationComposer,
      $$StreamChannelsTableCreateCompanionBuilder,
      $$StreamChannelsTableUpdateCompanionBuilder,
      (
        StreamChannel,
        BaseReferences<_$AppDatabase, $StreamChannelsTable, StreamChannel>,
      ),
      StreamChannel,
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
  $$LocalFilesTableTableManager get localFiles =>
      $$LocalFilesTableTableManager(_db, _db.localFiles);
  $$ImportRootsTableTableManager get importRoots =>
      $$ImportRootsTableTableManager(_db, _db.importRoots);
  $$StreamPlaylistsTableTableManager get streamPlaylists =>
      $$StreamPlaylistsTableTableManager(_db, _db.streamPlaylists);
  $$StreamChannelsTableTableManager get streamChannels =>
      $$StreamChannelsTableTableManager(_db, _db.streamChannels);
}
