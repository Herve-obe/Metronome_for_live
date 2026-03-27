import 'package:freezed_annotation/freezed_annotation.dart';
import 'song.dart';
import 'setlist.dart';

part 'project.freezed.dart';
part 'project.g.dart';

@freezed
class Project with _$Project {
  const factory Project({
    required String id,
    required String name,
    @Default([]) List<Song> songs,
    @Default([]) List<Setlist> setlists,
  }) = _Project;

  factory Project.fromJson(Map<String, dynamic> json) => _$ProjectFromJson(json);
}
