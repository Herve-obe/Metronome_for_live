import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final databaseProvider = FutureProvider<Database>((ref) async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'metronome_for_live.db');

  return openDatabase(
    path,
    version: 1,
    onConfigure: (db) async {
      // Activation des clés étrangères SQLite
      await db.execute('PRAGMA foreign_keys = ON');
    },
    onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE projects (
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL
        )
      ''');

      await db.execute('''
        CREATE TABLE songs (
          id TEXT PRIMARY KEY,
          project_id TEXT,
          title TEXT NOT NULL,
          artist TEXT,
          notes TEXT,
          FOREIGN KEY (project_id) REFERENCES projects (id) ON DELETE CASCADE
        )
      ''');

      // sort_order ajouté pour conserver l'ordre des blocs dans une chanson
      await db.execute('''
        CREATE TABLE blocks (
          id TEXT PRIMARY KEY,
          song_id TEXT NOT NULL,
          name TEXT NOT NULL,
          start_bpm INTEGER NOT NULL,
          end_bpm INTEGER NOT NULL,
          signature_numerator INTEGER NOT NULL,
          signature_denominator INTEGER NOT NULL,
          duration_type TEXT NOT NULL,
          fixed_measures_count INTEGER,
          variation_type TEXT NOT NULL,
          tts_enabled INTEGER NOT NULL,
          tts_text TEXT,
          tts_count_in_beats INTEGER NOT NULL,
          sort_order INTEGER NOT NULL,
          FOREIGN KEY (song_id) REFERENCES songs (id) ON DELETE CASCADE
        )
      ''');

      await db.execute('''
        CREATE TABLE setlists (
          id TEXT PRIMARY KEY,
          project_id TEXT,
          title TEXT NOT NULL,
          date TEXT,
          location TEXT,
          FOREIGN KEY (project_id) REFERENCES projects (id) ON DELETE CASCADE
        )
      ''');

      await db.execute('''
        CREATE TABLE setlist_songs (
          setlist_id TEXT NOT NULL,
          song_id TEXT NOT NULL,
          sort_order INTEGER NOT NULL,
          PRIMARY KEY (setlist_id, song_id),
          FOREIGN KEY (setlist_id) REFERENCES setlists (id) ON DELETE CASCADE,
          FOREIGN KEY (song_id) REFERENCES songs (id) ON DELETE CASCADE
        )
      ''');
    },
  );
});
