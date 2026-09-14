import 'package:freezed_annotation/freezed_annotation.dart';

part 'local_folder.freezed.dart';

@freezed
abstract class LocalFolder with _$LocalFolder {
  const factory LocalFolder({
    required String path,
    required String name,
    @Default(0) int trackCount,
    @Default(0) int subfolderCount,
  }) = _LocalFolder;
}
