import 'package:freezed_annotation/freezed_annotation.dart';

part 'local_album.freezed.dart';

@freezed
abstract class LocalAlbum with _$LocalAlbum {
  const factory LocalAlbum({
    required String albumGroupKey,
    required String title,
    String? artist,
    String? artworkPath,
    @Default(0) int trackCount,
    int? releaseYear,
  }) = _LocalAlbum;
}
