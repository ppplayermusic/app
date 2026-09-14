import 'package:freezed_annotation/freezed_annotation.dart';

part 'local_artist.freezed.dart';

@freezed
abstract class LocalArtist with _$LocalArtist {
  const factory LocalArtist({
    required String name,
    @Default(0) int trackCount,
    @Default(0) int albumCount,
    String? fallbackArtworkPath,
  }) = _LocalArtist;
}
