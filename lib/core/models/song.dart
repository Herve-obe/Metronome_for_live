import 'package:freezed_annotation/freezed_annotation.dart';
import 'block.dart';

part 'song.freezed.dart';
part 'song.g.dart';

@freezed
class Song with _$Song {
  const factory Song({
    required String id,
    required String title,
    String? artist,
    String? notes,
    required List<Block> blocks,
  }) = _Song;

  factory Song.fromJson(Map<String, dynamic> json) => _$SongFromJson(json);
}
