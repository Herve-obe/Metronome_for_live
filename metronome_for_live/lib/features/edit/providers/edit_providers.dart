import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/database/app_database.dart';
import '../../../core/providers/database_provider.dart';

const _uuid = Uuid();

// ═══════════════════════════════════════════════════════════
// PROJECTS
// ═══════════════════════════════════════════════════════════

final projectsStreamProvider = StreamProvider<List<Project>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchAllProjects();
});

final projectsActionsProvider = Provider<ProjectsActions>((ref) {
  return ProjectsActions(ref.watch(databaseProvider));
});

class ProjectsActions {
  final AppDatabase _db;
  ProjectsActions(this._db);

  Future<String> create(String name, {String groupName = ''}) async {
    final id = _uuid.v4();
    await _db.insertProject(ProjectsCompanion.insert(
      id: id,
      name: name,
      groupName: Value(groupName),
    ));
    return id;
  }

  Future<void> rename(String id, String newName) async {
    final project = await _db.getProject(id);
    await _db.updateProject(ProjectsCompanion(
      id: Value(project.id),
      name: Value(newName),
      groupName: Value(project.groupName),
      createdAt: Value(project.createdAt),
      updatedAt: Value(DateTime.now()),
    ));
  }

  Future<void> updateGroup(String id, String groupName) async {
    final project = await _db.getProject(id);
    await _db.updateProject(ProjectsCompanion(
      id: Value(project.id),
      name: Value(project.name),
      groupName: Value(groupName),
      createdAt: Value(project.createdAt),
      updatedAt: Value(DateTime.now()),
    ));
  }

  Future<void> delete(String id) => _db.deleteProjectCascade(id);
}

// ═══════════════════════════════════════════════════════════
// SETLISTS
// ═══════════════════════════════════════════════════════════

final setlistsStreamProvider =
    StreamProvider.family<List<Setlist>, String>((ref, projectId) {
  final db = ref.watch(databaseProvider);
  return db.watchSetlistsForProject(projectId);
});

final setlistsActionsProvider = Provider<SetlistsActions>((ref) {
  return SetlistsActions(ref.watch(databaseProvider));
});

class SetlistsActions {
  final AppDatabase _db;
  SetlistsActions(this._db);

  Future<String> create(String projectId, String name) async {
    final id = _uuid.v4();
    final existing = await _db.getSetlistsForProject(projectId);
    await _db.insertSetlist(SetlistsCompanion.insert(
      id: id,
      projectId: projectId,
      name: name,
      sortOrder: Value(existing.length),
    ));
    return id;
  }

  Future<void> rename(String id, String newName) async {
    await (_db.update(_db.setlists)..where((t) => t.id.equals(id)))
        .write(SetlistsCompanion(name: Value(newName)));
  }

  Future<void> delete(String id) => _db.deleteSetlistCascade(id);

  Future<void> reorder(List<String> orderedIds) =>
      _db.reorderSetlists(orderedIds);
}

// ═══════════════════════════════════════════════════════════
// SONGS
// ═══════════════════════════════════════════════════════════

final songsStreamProvider =
    StreamProvider.family<List<Song>, String>((ref, setlistId) {
  final db = ref.watch(databaseProvider);
  return db.watchSongsForSetlist(setlistId);
});

final songsActionsProvider = Provider<SongsActions>((ref) {
  return SongsActions(ref.watch(databaseProvider));
});

class SongsActions {
  final AppDatabase _db;
  SongsActions(this._db);

  Future<String> create(String setlistId, String name) async {
    final id = _uuid.v4();
    final existing = await _db.getSongsForSetlist(setlistId);
    await _db.insertSong(SongsCompanion.insert(
      id: id,
      setlistId: setlistId,
      name: name,
      sortOrder: Value(existing.length),
    ));
    return id;
  }

  Future<void> rename(String id, String newName) async {
    await (_db.update(_db.songs)..where((t) => t.id.equals(id)))
        .write(SongsCompanion(name: Value(newName)));
  }

  Future<void> delete(String id) => _db.deleteSongCascade(id);

  Future<void> reorder(List<String> orderedIds) =>
      _db.reorderSongs(orderedIds);
}

// ═══════════════════════════════════════════════════════════
// TEMPO BLOCKS
// ═══════════════════════════════════════════════════════════

final blocksStreamProvider =
    StreamProvider.family<List<TempoBlock>, String>((ref, songId) {
  final db = ref.watch(databaseProvider);
  return db.watchBlocksForSong(songId);
});

final blocksActionsProvider = Provider<BlocksActions>((ref) {
  return BlocksActions(ref.watch(databaseProvider));
});

class BlocksActions {
  final AppDatabase _db;
  BlocksActions(this._db);

  Future<String> create(String songId, String name,
      {int bpm = 120, int numerator = 4, int denominator = 4}) async {
    final id = _uuid.v4();
    final existing = await _db.getBlocksForSong(songId);
    await _db.insertBlock(TempoBlocksCompanion.insert(
      id: id,
      songId: songId,
      name: name,
      sortOrder: Value(existing.length),
      bpm: Value(bpm),
      numerator: Value(numerator),
      denominator: Value(denominator),
    ));
    return id;
  }

  Future<void> update(TempoBlocksCompanion block) => _db.updateBlock(block);

  Future<void> delete(String id) => _db.deleteBlock(id);

  Future<void> reorder(List<String> orderedIds) =>
      _db.reorderBlocks(orderedIds);
}
