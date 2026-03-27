import 'package:freezed_annotation/freezed_annotation.dart';
import 'song.dart';

part 'setlist.freezed.dart';
part 'setlist.g.dart';

@freezed
class Setlist with _$Setlist {
  const factory Setlist({
    required String id,
    required String title,
    String? date,
    String? location,
    required List<Song> songs,
  }) = _Setlist;

  factory Setlist.fromJson(Map<String, dynamic> json) => _$SetlistFromJson(json);
}
