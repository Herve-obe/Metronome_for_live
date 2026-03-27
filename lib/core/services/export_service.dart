import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:metronome_for_live/core/models/setlist.dart';

class ExportService {
  final _uuid = const Uuid();

  String exportSetlist(Setlist setlist) {
    // Encode the entire setlist model into a miniature string
    return jsonEncode(setlist.toJson());
  }

  Setlist? importSetlist(String jsonStr) {
    try {
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      final original = Setlist.fromJson(map);
      
      // We must regenerate all IDs to prevent SQLite conflicts if imported in the same database,
      // and to ensure isolation if modifications are made later.
      final newSetlistId = _uuid.v4();
      final newSongs = original.songs.map((song) {
        final newSongId = _uuid.v4();
        final newBlocks = song.blocks.map((block) {
          return block.copyWith(id: _uuid.v4());
        }).toList();
        return song.copyWith(id: newSongId, blocks: newBlocks);
      }).toList();
      
      return original.copyWith(id: newSetlistId, songs: newSongs);
    } catch (e) {
      return null;
    }
  }
}
