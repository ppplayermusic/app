import 'package:freezed_annotation/freezed_annotation.dart';

part 'local_genre.freezed.dart';

@freezed
abstract class LocalGenre with _$LocalGenre {
  const factory LocalGenre({required String name, @Default(0) int trackCount}) =
      _LocalGenre;
}
