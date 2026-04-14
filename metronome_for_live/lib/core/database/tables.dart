import 'package:drift/drift.dart';

/// Table des projets (niveau le plus haut de la hiérarchie).
class Projects extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get groupName => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Table des setlists (appartiennent à un projet).
class Setlists extends Table {
  TextColumn get id => text()();
  TextColumn get projectId => text().references(Projects, #id)();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  BoolColumn get autoChain =>
      boolean().withDefault(const Constant(false))();
  IntColumn get countInMeasures =>
      integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Table des morceaux (appartiennent à une setlist).
class Songs extends Table {
  TextColumn get id => text()();
  TextColumn get setlistId => text().references(Setlists, #id)();
  TextColumn get name => text().withLength(min: 1, max: 200)();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  BoolColumn get autoChain =>
      boolean().withDefault(const Constant(false))();
  TextColumn get notes => text().withDefault(const Constant(''))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Table des blocs de tempo (appartiennent à un morceau).
class TempoBlocks extends Table {
  TextColumn get id => text()();
  TextColumn get songId => text().references(Songs, #id)();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  IntColumn get bpm => integer().withDefault(const Constant(120))();
  IntColumn get numerator => integer().withDefault(const Constant(4))();
  IntColumn get denominator => integer().withDefault(const Constant(4))();
  IntColumn get subdivision =>
      integer().withDefault(const Constant(0))(); // SubdivisionType index
  IntColumn get measureCount =>
      integer().withDefault(const Constant(4))(); // 0 = infinite
  RealColumn get volume =>
      real().withDefault(const Constant(1.0))();
  TextColumn get accentSound =>
      text().withDefault(const Constant('click_accent'))();
  TextColumn get normalSound =>
      text().withDefault(const Constant('click_normal'))();
  TextColumn get subdivisionSound =>
      text().withDefault(const Constant('click_sub'))();
  BoolColumn get announceName =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get announceCountIn =>
      boolean().withDefault(const Constant(false))();
  IntColumn get countInMeasures =>
      integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}
