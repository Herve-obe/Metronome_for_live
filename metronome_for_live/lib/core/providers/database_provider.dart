import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';

/// Provider global pour la base de données.
final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase.instance;
});
