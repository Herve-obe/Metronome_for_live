import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:metronome_for_live/core/database/app_database.dart';
import 'package:metronome_for_live/core/models/project.dart';
import 'package:metronome_for_live/core/models/song.dart';
import 'package:metronome_for_live/core/models/block.dart';
import 'package:metronome_for_live/core/models/setlist.dart';

final databaseRepositoryProvider = Provider<DatabaseRepository>((ref) {
  return DatabaseRepository(ref);
});

class DatabaseRepository {
  final Ref _ref;
  DatabaseRepository(this._ref);

  Future<Database> get _db async => await _ref.read(databaseProvider.future);

  // Assainissement absolu de n'importe quel booléen vers entier (FFI Windows crash bypass)
  Map<String, dynamic> _sanitizeForSql(Map<String, dynamic> map) {
    return map.map((key, value) {
      if (value is bool) {
        return MapEntry(key, value ? 1 : 0);
      }
      return MapEntry(key, value);
    });
  }

  // --- PROJECTS ---
  Future<List<Project>> getProjects() async {
    final db = await _db;
    final results = await db.query('projects');
    return results.map((e) => Project.fromJson(e)).toList();
  }

  Future<void> saveProject(Project project) async {
    final db = await _db;
    final projectJson = project.toJson();
    projectJson.remove('songs');
    projectJson.remove('setlists');
    await db.insert('projects', _sanitizeForSql(projectJson), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteProject(String id) async {
    final db = await _db;
    await db.delete('projects', where: 'id = ?', whereArgs: [id]);
  }

  // --- SONGS ---
  Future<List<Song>> getSongsForProject(String projectId) async {
    final db = await _db;
    final results = await db.query('songs', where: 'project_id = ?', whereArgs: [projectId], orderBy: 'title ASC');
    
    final songs = <Song>[];
    for (final row in results) {
      final map = Map<String, dynamic>.from(row);
      map['blocks'] = [];
      final songBase = Song.fromJson(map);
      final blocks = await getBlocksForSong(songBase.id);
      songs.add(songBase.copyWith(blocks: blocks));
    }
    return songs;
  }

  Future<void> saveSong(Song song, String projectId) async {
    final db = await _db;
    final songJson = song.toJson();
    songJson.remove('blocks'); // Non stocké en colonne
    songJson['project_id'] = projectId; // Lien relationnel
    await db.insert('songs', _sanitizeForSql(songJson), conflictAlgorithm: ConflictAlgorithm.replace);

    // Sauvegarde en cascade des blocs
    await db.delete('blocks', where: 'song_id = ?', whereArgs: [song.id]);
    for (int i = 0; i < song.blocks.length; i++) {
        final block = song.blocks[i];
        final blockJson = block.toJson();
        blockJson['song_id'] = song.id;
        blockJson['sort_order'] = i;
        await db.insert('blocks', _sanitizeForSql(blockJson), conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<void> deleteSong(String id) async {
    final db = await _db;
    await db.delete('songs', where: 'id = ?', whereArgs: [id]);
  }

  // --- BLOCKS ---
  Future<List<Block>> getBlocksForSong(String songId) async {
    final db = await _db;
    final results = await db.query('blocks', where: 'song_id = ?', whereArgs: [songId], orderBy: 'sort_order ASC');
    return results.map((e) {
      final map = Map<String, dynamic>.from(e);
      if (map['tts_enabled'] is int) map['tts_enabled'] = map['tts_enabled'] == 1;
      return Block.fromJson(map);
    }).toList();
  }

  // --- SETLISTS ---
  Future<List<Setlist>> getSetlistsForProject(String projectId) async {
    final db = await _db;
    final results = await db.query('setlists', where: 'project_id = ?', whereArgs: [projectId]);
    
    final setlists = <Setlist>[];
    for (final row in results) {
      final map = Map<String, dynamic>.from(row);
      map['songs'] = [];
      final setlistBase = Setlist.fromJson(map);
      
      // On récupère les ID des chansons via la table de liaison
      final songRefs = await db.query('setlist_songs', where: 'setlist_id = ?', whereArgs: [setlistBase.id], orderBy: 'sort_order ASC');
      final songs = <Song>[];
      for (final ref in songRefs) {
         final songRes = await db.query('songs', where: 'id = ?', whereArgs: [ref['song_id']]);
         if (songRes.isNotEmpty) {
           final songMap = Map<String, dynamic>.from(songRes.first);
           songMap['blocks'] = [];
           final song = Song.fromJson(songMap);
           final blocks = await getBlocksForSong(song.id);
           songs.add(song.copyWith(blocks: blocks));
         }
      }
      setlists.add(setlistBase.copyWith(songs: songs));
    }
    return setlists;
  }

  Future<void> saveSetlist(Setlist setlist, String projectId) async {
    final db = await _db;
    final setlistJson = setlist.toJson();
    setlistJson.remove('songs');
    setlistJson['project_id'] = projectId;
    await db.insert('setlists', _sanitizeForSql(setlistJson), conflictAlgorithm: ConflictAlgorithm.replace);

    await db.delete('setlist_songs', where: 'setlist_id = ?', whereArgs: [setlist.id]);
    for (int i = 0; i < setlist.songs.length; i++) {
        await db.insert('setlist_songs', {
          'setlist_id': setlist.id,
          'song_id': setlist.songs[i].id,
          'sort_order': i,
        }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<void> deleteSetlist(String id) async {
    final db = await _db;
    await db.delete('setlists', where: 'id = ?', whereArgs: [id]);
  }
}
