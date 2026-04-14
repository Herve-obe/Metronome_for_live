import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Projects, Setlists, Songs, TempoBlocks])
class AppDatabase extends _$AppDatabase {
  AppDatabase._() : super(_openConnection());

  static AppDatabase? _instance;
  static AppDatabase get instance => _instance ??= AppDatabase._();

  @override
  int get schemaVersion => 1;

  // ═══════════════════════════════════════════════════════════
  // PROJECTS
  // ═══════════════════════════════════════════════════════════

  Future<List<Project>> getAllProjects() =>
      (select(projects)..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
          .get();

  Stream<List<Project>> watchAllProjects() =>
      (select(projects)..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
          .watch();

  Future<Project> getProject(String id) =>
      (select(projects)..where((t) => t.id.equals(id))).getSingle();

  Future<int> insertProject(ProjectsCompanion project) =>
      into(projects).insert(project);

  Future<bool> updateProject(ProjectsCompanion project) =>
      update(projects).replace(project);

  Future<int> deleteProject(String id) =>
      (delete(projects)..where((t) => t.id.equals(id))).go();

  // ═══════════════════════════════════════════════════════════
  // SETLISTS
  // ═══════════════════════════════════════════════════════════

  Stream<List<Setlist>> watchSetlistsForProject(String projectId) =>
      (select(setlists)
            ..where((t) => t.projectId.equals(projectId))
            ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .watch();

  Future<List<Setlist>> getSetlistsForProject(String projectId) =>
      (select(setlists)
            ..where((t) => t.projectId.equals(projectId))
            ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .get();

  Future<int> insertSetlist(SetlistsCompanion setlist) =>
      into(setlists).insert(setlist);

  Future<bool> updateSetlist(SetlistsCompanion setlist) =>
      update(setlists).replace(setlist);

  Future<int> deleteSetlist(String id) =>
      (delete(setlists)..where((t) => t.id.equals(id))).go();

  Future<void> reorderSetlists(List<String> orderedIds) async {
    await transaction(() async {
      for (int i = 0; i < orderedIds.length; i++) {
        await (update(setlists)..where((t) => t.id.equals(orderedIds[i])))
            .write(SetlistsCompanion(sortOrder: Value(i)));
      }
    });
  }

  // ═══════════════════════════════════════════════════════════
  // SONGS
  // ═══════════════════════════════════════════════════════════

  Stream<List<Song>> watchSongsForSetlist(String setlistId) =>
      (select(songs)
            ..where((t) => t.setlistId.equals(setlistId))
            ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .watch();

  Future<List<Song>> getSongsForSetlist(String setlistId) =>
      (select(songs)
            ..where((t) => t.setlistId.equals(setlistId))
            ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .get();

  Future<int> insertSong(SongsCompanion song) => into(songs).insert(song);

  Future<bool> updateSong(SongsCompanion song) => update(songs).replace(song);

  Future<int> deleteSong(String id) =>
      (delete(songs)..where((t) => t.id.equals(id))).go();

  Future<void> reorderSongs(List<String> orderedIds) async {
    await transaction(() async {
      for (int i = 0; i < orderedIds.length; i++) {
        await (update(songs)..where((t) => t.id.equals(orderedIds[i])))
            .write(SongsCompanion(sortOrder: Value(i)));
      }
    });
  }

  // ═══════════════════════════════════════════════════════════
  // TEMPO BLOCKS
  // ═══════════════════════════════════════════════════════════

  Stream<List<TempoBlock>> watchBlocksForSong(String songId) =>
      (select(tempoBlocks)
            ..where((t) => t.songId.equals(songId))
            ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .watch();

  Future<List<TempoBlock>> getBlocksForSong(String songId) =>
      (select(tempoBlocks)
            ..where((t) => t.songId.equals(songId))
            ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .get();

  Future<int> insertBlock(TempoBlocksCompanion block) =>
      into(tempoBlocks).insert(block);

  Future<bool> updateBlock(TempoBlocksCompanion block) =>
      update(tempoBlocks).replace(block);

  Future<int> deleteBlock(String id) =>
      (delete(tempoBlocks)..where((t) => t.id.equals(id))).go();

  Future<void> reorderBlocks(List<String> orderedIds) async {
    await transaction(() async {
      for (int i = 0; i < orderedIds.length; i++) {
        await (update(tempoBlocks)
              ..where((t) => t.id.equals(orderedIds[i])))
            .write(TempoBlocksCompanion(sortOrder: Value(i)));
      }
    });
  }

  // ═══════════════════════════════════════════════════════════
  // CASCADE DELETE
  // ═══════════════════════════════════════════════════════════

  /// Supprime un projet et toutes ses données enfants.
  Future<void> deleteProjectCascade(String projectId) async {
    await transaction(() async {
      // Get all setlists for this project
      final projectSetlists = await getSetlistsForProject(projectId);
      for (final setlist in projectSetlists) {
        await deleteSetlistCascade(setlist.id);
      }
      await deleteProject(projectId);
    });
  }

  /// Supprime une setlist et tous ses morceaux/blocs.
  Future<void> deleteSetlistCascade(String setlistId) async {
    await transaction(() async {
      final setlistSongs = await getSongsForSetlist(setlistId);
      for (final song in setlistSongs) {
        await deleteSongCascade(song.id);
      }
      await deleteSetlist(setlistId);
    });
  }

  /// Supprime un morceau et tous ses blocs.
  Future<void> deleteSongCascade(String songId) async {
    await transaction(() async {
      await (delete(tempoBlocks)..where((t) => t.songId.equals(songId))).go();
      await deleteSong(songId);
    });
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'metronome_for_live.db'));
    return NativeDatabase.createInBackground(file);
  });
}
