// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProjectsTable extends Projects with TableInfo<$ProjectsTable, Project> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _groupNameMeta = const VerificationMeta(
    'groupName',
  );
  @override
  late final GeneratedColumn<String> groupName = GeneratedColumn<String>(
    'group_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    groupName,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'projects';
  @override
  VerificationContext validateIntegrity(
    Insertable<Project> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('group_name')) {
      context.handle(
        _groupNameMeta,
        groupName.isAcceptableOrUnknown(data['group_name']!, _groupNameMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Project map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Project(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      groupName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_name'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ProjectsTable createAlias(String alias) {
    return $ProjectsTable(attachedDatabase, alias);
  }
}

class Project extends DataClass implements Insertable<Project> {
  final String id;
  final String name;
  final String groupName;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Project({
    required this.id,
    required this.name,
    required this.groupName,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['group_name'] = Variable<String>(groupName);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ProjectsCompanion toCompanion(bool nullToAbsent) {
    return ProjectsCompanion(
      id: Value(id),
      name: Value(name),
      groupName: Value(groupName),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Project.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Project(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      groupName: serializer.fromJson<String>(json['groupName']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'groupName': serializer.toJson<String>(groupName),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Project copyWith({
    String? id,
    String? name,
    String? groupName,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Project(
    id: id ?? this.id,
    name: name ?? this.name,
    groupName: groupName ?? this.groupName,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Project copyWithCompanion(ProjectsCompanion data) {
    return Project(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      groupName: data.groupName.present ? data.groupName.value : this.groupName,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Project(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('groupName: $groupName, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, groupName, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Project &&
          other.id == this.id &&
          other.name == this.name &&
          other.groupName == this.groupName &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ProjectsCompanion extends UpdateCompanion<Project> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> groupName;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ProjectsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.groupName = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProjectsCompanion.insert({
    required String id,
    required String name,
    this.groupName = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<Project> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? groupName,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (groupName != null) 'group_name': groupName,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProjectsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? groupName,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ProjectsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      groupName: groupName ?? this.groupName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (groupName.present) {
      map['group_name'] = Variable<String>(groupName.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('groupName: $groupName, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SetlistsTable extends Setlists with TableInfo<$SetlistsTable, Setlist> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SetlistsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES projects (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _autoChainMeta = const VerificationMeta(
    'autoChain',
  );
  @override
  late final GeneratedColumn<bool> autoChain = GeneratedColumn<bool>(
    'auto_chain',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("auto_chain" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _countInMeasuresMeta = const VerificationMeta(
    'countInMeasures',
  );
  @override
  late final GeneratedColumn<int> countInMeasures = GeneratedColumn<int>(
    'count_in_measures',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    projectId,
    name,
    sortOrder,
    autoChain,
    countInMeasures,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'setlists';
  @override
  VerificationContext validateIntegrity(
    Insertable<Setlist> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('auto_chain')) {
      context.handle(
        _autoChainMeta,
        autoChain.isAcceptableOrUnknown(data['auto_chain']!, _autoChainMeta),
      );
    }
    if (data.containsKey('count_in_measures')) {
      context.handle(
        _countInMeasuresMeta,
        countInMeasures.isAcceptableOrUnknown(
          data['count_in_measures']!,
          _countInMeasuresMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Setlist map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setlist(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      autoChain: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}auto_chain'],
      )!,
      countInMeasures: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}count_in_measures'],
      )!,
    );
  }

  @override
  $SetlistsTable createAlias(String alias) {
    return $SetlistsTable(attachedDatabase, alias);
  }
}

class Setlist extends DataClass implements Insertable<Setlist> {
  final String id;
  final String projectId;
  final String name;
  final int sortOrder;
  final bool autoChain;
  final int countInMeasures;
  const Setlist({
    required this.id,
    required this.projectId,
    required this.name,
    required this.sortOrder,
    required this.autoChain,
    required this.countInMeasures,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['project_id'] = Variable<String>(projectId);
    map['name'] = Variable<String>(name);
    map['sort_order'] = Variable<int>(sortOrder);
    map['auto_chain'] = Variable<bool>(autoChain);
    map['count_in_measures'] = Variable<int>(countInMeasures);
    return map;
  }

  SetlistsCompanion toCompanion(bool nullToAbsent) {
    return SetlistsCompanion(
      id: Value(id),
      projectId: Value(projectId),
      name: Value(name),
      sortOrder: Value(sortOrder),
      autoChain: Value(autoChain),
      countInMeasures: Value(countInMeasures),
    );
  }

  factory Setlist.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setlist(
      id: serializer.fromJson<String>(json['id']),
      projectId: serializer.fromJson<String>(json['projectId']),
      name: serializer.fromJson<String>(json['name']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      autoChain: serializer.fromJson<bool>(json['autoChain']),
      countInMeasures: serializer.fromJson<int>(json['countInMeasures']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'projectId': serializer.toJson<String>(projectId),
      'name': serializer.toJson<String>(name),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'autoChain': serializer.toJson<bool>(autoChain),
      'countInMeasures': serializer.toJson<int>(countInMeasures),
    };
  }

  Setlist copyWith({
    String? id,
    String? projectId,
    String? name,
    int? sortOrder,
    bool? autoChain,
    int? countInMeasures,
  }) => Setlist(
    id: id ?? this.id,
    projectId: projectId ?? this.projectId,
    name: name ?? this.name,
    sortOrder: sortOrder ?? this.sortOrder,
    autoChain: autoChain ?? this.autoChain,
    countInMeasures: countInMeasures ?? this.countInMeasures,
  );
  Setlist copyWithCompanion(SetlistsCompanion data) {
    return Setlist(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      name: data.name.present ? data.name.value : this.name,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      autoChain: data.autoChain.present ? data.autoChain.value : this.autoChain,
      countInMeasures: data.countInMeasures.present
          ? data.countInMeasures.value
          : this.countInMeasures,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setlist(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('autoChain: $autoChain, ')
          ..write('countInMeasures: $countInMeasures')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, projectId, name, sortOrder, autoChain, countInMeasures);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setlist &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.name == this.name &&
          other.sortOrder == this.sortOrder &&
          other.autoChain == this.autoChain &&
          other.countInMeasures == this.countInMeasures);
}

class SetlistsCompanion extends UpdateCompanion<Setlist> {
  final Value<String> id;
  final Value<String> projectId;
  final Value<String> name;
  final Value<int> sortOrder;
  final Value<bool> autoChain;
  final Value<int> countInMeasures;
  final Value<int> rowid;
  const SetlistsCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.name = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.autoChain = const Value.absent(),
    this.countInMeasures = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SetlistsCompanion.insert({
    required String id,
    required String projectId,
    required String name,
    this.sortOrder = const Value.absent(),
    this.autoChain = const Value.absent(),
    this.countInMeasures = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       projectId = Value(projectId),
       name = Value(name);
  static Insertable<Setlist> custom({
    Expression<String>? id,
    Expression<String>? projectId,
    Expression<String>? name,
    Expression<int>? sortOrder,
    Expression<bool>? autoChain,
    Expression<int>? countInMeasures,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (name != null) 'name': name,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (autoChain != null) 'auto_chain': autoChain,
      if (countInMeasures != null) 'count_in_measures': countInMeasures,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SetlistsCompanion copyWith({
    Value<String>? id,
    Value<String>? projectId,
    Value<String>? name,
    Value<int>? sortOrder,
    Value<bool>? autoChain,
    Value<int>? countInMeasures,
    Value<int>? rowid,
  }) {
    return SetlistsCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
      autoChain: autoChain ?? this.autoChain,
      countInMeasures: countInMeasures ?? this.countInMeasures,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (autoChain.present) {
      map['auto_chain'] = Variable<bool>(autoChain.value);
    }
    if (countInMeasures.present) {
      map['count_in_measures'] = Variable<int>(countInMeasures.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SetlistsCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('autoChain: $autoChain, ')
          ..write('countInMeasures: $countInMeasures, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SongsTable extends Songs with TableInfo<$SongsTable, Song> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SongsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _setlistIdMeta = const VerificationMeta(
    'setlistId',
  );
  @override
  late final GeneratedColumn<String> setlistId = GeneratedColumn<String>(
    'setlist_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES setlists (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _autoChainMeta = const VerificationMeta(
    'autoChain',
  );
  @override
  late final GeneratedColumn<bool> autoChain = GeneratedColumn<bool>(
    'auto_chain',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("auto_chain" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    setlistId,
    name,
    sortOrder,
    autoChain,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'songs';
  @override
  VerificationContext validateIntegrity(
    Insertable<Song> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('setlist_id')) {
      context.handle(
        _setlistIdMeta,
        setlistId.isAcceptableOrUnknown(data['setlist_id']!, _setlistIdMeta),
      );
    } else if (isInserting) {
      context.missing(_setlistIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('auto_chain')) {
      context.handle(
        _autoChainMeta,
        autoChain.isAcceptableOrUnknown(data['auto_chain']!, _autoChainMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Song map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Song(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      setlistId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}setlist_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      autoChain: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}auto_chain'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
    );
  }

  @override
  $SongsTable createAlias(String alias) {
    return $SongsTable(attachedDatabase, alias);
  }
}

class Song extends DataClass implements Insertable<Song> {
  final String id;
  final String setlistId;
  final String name;
  final int sortOrder;
  final bool autoChain;
  final String notes;
  const Song({
    required this.id,
    required this.setlistId,
    required this.name,
    required this.sortOrder,
    required this.autoChain,
    required this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['setlist_id'] = Variable<String>(setlistId);
    map['name'] = Variable<String>(name);
    map['sort_order'] = Variable<int>(sortOrder);
    map['auto_chain'] = Variable<bool>(autoChain);
    map['notes'] = Variable<String>(notes);
    return map;
  }

  SongsCompanion toCompanion(bool nullToAbsent) {
    return SongsCompanion(
      id: Value(id),
      setlistId: Value(setlistId),
      name: Value(name),
      sortOrder: Value(sortOrder),
      autoChain: Value(autoChain),
      notes: Value(notes),
    );
  }

  factory Song.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Song(
      id: serializer.fromJson<String>(json['id']),
      setlistId: serializer.fromJson<String>(json['setlistId']),
      name: serializer.fromJson<String>(json['name']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      autoChain: serializer.fromJson<bool>(json['autoChain']),
      notes: serializer.fromJson<String>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'setlistId': serializer.toJson<String>(setlistId),
      'name': serializer.toJson<String>(name),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'autoChain': serializer.toJson<bool>(autoChain),
      'notes': serializer.toJson<String>(notes),
    };
  }

  Song copyWith({
    String? id,
    String? setlistId,
    String? name,
    int? sortOrder,
    bool? autoChain,
    String? notes,
  }) => Song(
    id: id ?? this.id,
    setlistId: setlistId ?? this.setlistId,
    name: name ?? this.name,
    sortOrder: sortOrder ?? this.sortOrder,
    autoChain: autoChain ?? this.autoChain,
    notes: notes ?? this.notes,
  );
  Song copyWithCompanion(SongsCompanion data) {
    return Song(
      id: data.id.present ? data.id.value : this.id,
      setlistId: data.setlistId.present ? data.setlistId.value : this.setlistId,
      name: data.name.present ? data.name.value : this.name,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      autoChain: data.autoChain.present ? data.autoChain.value : this.autoChain,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Song(')
          ..write('id: $id, ')
          ..write('setlistId: $setlistId, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('autoChain: $autoChain, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, setlistId, name, sortOrder, autoChain, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Song &&
          other.id == this.id &&
          other.setlistId == this.setlistId &&
          other.name == this.name &&
          other.sortOrder == this.sortOrder &&
          other.autoChain == this.autoChain &&
          other.notes == this.notes);
}

class SongsCompanion extends UpdateCompanion<Song> {
  final Value<String> id;
  final Value<String> setlistId;
  final Value<String> name;
  final Value<int> sortOrder;
  final Value<bool> autoChain;
  final Value<String> notes;
  final Value<int> rowid;
  const SongsCompanion({
    this.id = const Value.absent(),
    this.setlistId = const Value.absent(),
    this.name = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.autoChain = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SongsCompanion.insert({
    required String id,
    required String setlistId,
    required String name,
    this.sortOrder = const Value.absent(),
    this.autoChain = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       setlistId = Value(setlistId),
       name = Value(name);
  static Insertable<Song> custom({
    Expression<String>? id,
    Expression<String>? setlistId,
    Expression<String>? name,
    Expression<int>? sortOrder,
    Expression<bool>? autoChain,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (setlistId != null) 'setlist_id': setlistId,
      if (name != null) 'name': name,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (autoChain != null) 'auto_chain': autoChain,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SongsCompanion copyWith({
    Value<String>? id,
    Value<String>? setlistId,
    Value<String>? name,
    Value<int>? sortOrder,
    Value<bool>? autoChain,
    Value<String>? notes,
    Value<int>? rowid,
  }) {
    return SongsCompanion(
      id: id ?? this.id,
      setlistId: setlistId ?? this.setlistId,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
      autoChain: autoChain ?? this.autoChain,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (setlistId.present) {
      map['setlist_id'] = Variable<String>(setlistId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (autoChain.present) {
      map['auto_chain'] = Variable<bool>(autoChain.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SongsCompanion(')
          ..write('id: $id, ')
          ..write('setlistId: $setlistId, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('autoChain: $autoChain, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TempoBlocksTable extends TempoBlocks
    with TableInfo<$TempoBlocksTable, TempoBlock> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TempoBlocksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _songIdMeta = const VerificationMeta('songId');
  @override
  late final GeneratedColumn<String> songId = GeneratedColumn<String>(
    'song_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES songs (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _bpmMeta = const VerificationMeta('bpm');
  @override
  late final GeneratedColumn<int> bpm = GeneratedColumn<int>(
    'bpm',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(120),
  );
  static const VerificationMeta _numeratorMeta = const VerificationMeta(
    'numerator',
  );
  @override
  late final GeneratedColumn<int> numerator = GeneratedColumn<int>(
    'numerator',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(4),
  );
  static const VerificationMeta _denominatorMeta = const VerificationMeta(
    'denominator',
  );
  @override
  late final GeneratedColumn<int> denominator = GeneratedColumn<int>(
    'denominator',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(4),
  );
  static const VerificationMeta _subdivisionMeta = const VerificationMeta(
    'subdivision',
  );
  @override
  late final GeneratedColumn<int> subdivision = GeneratedColumn<int>(
    'subdivision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _measureCountMeta = const VerificationMeta(
    'measureCount',
  );
  @override
  late final GeneratedColumn<int> measureCount = GeneratedColumn<int>(
    'measure_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(4),
  );
  static const VerificationMeta _volumeMeta = const VerificationMeta('volume');
  @override
  late final GeneratedColumn<double> volume = GeneratedColumn<double>(
    'volume',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1.0),
  );
  static const VerificationMeta _accentSoundMeta = const VerificationMeta(
    'accentSound',
  );
  @override
  late final GeneratedColumn<String> accentSound = GeneratedColumn<String>(
    'accent_sound',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('click_accent'),
  );
  static const VerificationMeta _normalSoundMeta = const VerificationMeta(
    'normalSound',
  );
  @override
  late final GeneratedColumn<String> normalSound = GeneratedColumn<String>(
    'normal_sound',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('click_normal'),
  );
  static const VerificationMeta _subdivisionSoundMeta = const VerificationMeta(
    'subdivisionSound',
  );
  @override
  late final GeneratedColumn<String> subdivisionSound = GeneratedColumn<String>(
    'subdivision_sound',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('click_sub'),
  );
  static const VerificationMeta _announceNameMeta = const VerificationMeta(
    'announceName',
  );
  @override
  late final GeneratedColumn<bool> announceName = GeneratedColumn<bool>(
    'announce_name',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("announce_name" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _announceCountInMeta = const VerificationMeta(
    'announceCountIn',
  );
  @override
  late final GeneratedColumn<bool> announceCountIn = GeneratedColumn<bool>(
    'announce_count_in',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("announce_count_in" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _countInMeasuresMeta = const VerificationMeta(
    'countInMeasures',
  );
  @override
  late final GeneratedColumn<int> countInMeasures = GeneratedColumn<int>(
    'count_in_measures',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    songId,
    name,
    sortOrder,
    bpm,
    numerator,
    denominator,
    subdivision,
    measureCount,
    volume,
    accentSound,
    normalSound,
    subdivisionSound,
    announceName,
    announceCountIn,
    countInMeasures,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tempo_blocks';
  @override
  VerificationContext validateIntegrity(
    Insertable<TempoBlock> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('song_id')) {
      context.handle(
        _songIdMeta,
        songId.isAcceptableOrUnknown(data['song_id']!, _songIdMeta),
      );
    } else if (isInserting) {
      context.missing(_songIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('bpm')) {
      context.handle(
        _bpmMeta,
        bpm.isAcceptableOrUnknown(data['bpm']!, _bpmMeta),
      );
    }
    if (data.containsKey('numerator')) {
      context.handle(
        _numeratorMeta,
        numerator.isAcceptableOrUnknown(data['numerator']!, _numeratorMeta),
      );
    }
    if (data.containsKey('denominator')) {
      context.handle(
        _denominatorMeta,
        denominator.isAcceptableOrUnknown(
          data['denominator']!,
          _denominatorMeta,
        ),
      );
    }
    if (data.containsKey('subdivision')) {
      context.handle(
        _subdivisionMeta,
        subdivision.isAcceptableOrUnknown(
          data['subdivision']!,
          _subdivisionMeta,
        ),
      );
    }
    if (data.containsKey('measure_count')) {
      context.handle(
        _measureCountMeta,
        measureCount.isAcceptableOrUnknown(
          data['measure_count']!,
          _measureCountMeta,
        ),
      );
    }
    if (data.containsKey('volume')) {
      context.handle(
        _volumeMeta,
        volume.isAcceptableOrUnknown(data['volume']!, _volumeMeta),
      );
    }
    if (data.containsKey('accent_sound')) {
      context.handle(
        _accentSoundMeta,
        accentSound.isAcceptableOrUnknown(
          data['accent_sound']!,
          _accentSoundMeta,
        ),
      );
    }
    if (data.containsKey('normal_sound')) {
      context.handle(
        _normalSoundMeta,
        normalSound.isAcceptableOrUnknown(
          data['normal_sound']!,
          _normalSoundMeta,
        ),
      );
    }
    if (data.containsKey('subdivision_sound')) {
      context.handle(
        _subdivisionSoundMeta,
        subdivisionSound.isAcceptableOrUnknown(
          data['subdivision_sound']!,
          _subdivisionSoundMeta,
        ),
      );
    }
    if (data.containsKey('announce_name')) {
      context.handle(
        _announceNameMeta,
        announceName.isAcceptableOrUnknown(
          data['announce_name']!,
          _announceNameMeta,
        ),
      );
    }
    if (data.containsKey('announce_count_in')) {
      context.handle(
        _announceCountInMeta,
        announceCountIn.isAcceptableOrUnknown(
          data['announce_count_in']!,
          _announceCountInMeta,
        ),
      );
    }
    if (data.containsKey('count_in_measures')) {
      context.handle(
        _countInMeasuresMeta,
        countInMeasures.isAcceptableOrUnknown(
          data['count_in_measures']!,
          _countInMeasuresMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TempoBlock map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TempoBlock(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      songId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}song_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      bpm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bpm'],
      )!,
      numerator: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}numerator'],
      )!,
      denominator: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}denominator'],
      )!,
      subdivision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}subdivision'],
      )!,
      measureCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}measure_count'],
      )!,
      volume: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}volume'],
      )!,
      accentSound: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}accent_sound'],
      )!,
      normalSound: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}normal_sound'],
      )!,
      subdivisionSound: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subdivision_sound'],
      )!,
      announceName: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}announce_name'],
      )!,
      announceCountIn: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}announce_count_in'],
      )!,
      countInMeasures: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}count_in_measures'],
      )!,
    );
  }

  @override
  $TempoBlocksTable createAlias(String alias) {
    return $TempoBlocksTable(attachedDatabase, alias);
  }
}

class TempoBlock extends DataClass implements Insertable<TempoBlock> {
  final String id;
  final String songId;
  final String name;
  final int sortOrder;
  final int bpm;
  final int numerator;
  final int denominator;
  final int subdivision;
  final int measureCount;
  final double volume;
  final String accentSound;
  final String normalSound;
  final String subdivisionSound;
  final bool announceName;
  final bool announceCountIn;
  final int countInMeasures;
  const TempoBlock({
    required this.id,
    required this.songId,
    required this.name,
    required this.sortOrder,
    required this.bpm,
    required this.numerator,
    required this.denominator,
    required this.subdivision,
    required this.measureCount,
    required this.volume,
    required this.accentSound,
    required this.normalSound,
    required this.subdivisionSound,
    required this.announceName,
    required this.announceCountIn,
    required this.countInMeasures,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['song_id'] = Variable<String>(songId);
    map['name'] = Variable<String>(name);
    map['sort_order'] = Variable<int>(sortOrder);
    map['bpm'] = Variable<int>(bpm);
    map['numerator'] = Variable<int>(numerator);
    map['denominator'] = Variable<int>(denominator);
    map['subdivision'] = Variable<int>(subdivision);
    map['measure_count'] = Variable<int>(measureCount);
    map['volume'] = Variable<double>(volume);
    map['accent_sound'] = Variable<String>(accentSound);
    map['normal_sound'] = Variable<String>(normalSound);
    map['subdivision_sound'] = Variable<String>(subdivisionSound);
    map['announce_name'] = Variable<bool>(announceName);
    map['announce_count_in'] = Variable<bool>(announceCountIn);
    map['count_in_measures'] = Variable<int>(countInMeasures);
    return map;
  }

  TempoBlocksCompanion toCompanion(bool nullToAbsent) {
    return TempoBlocksCompanion(
      id: Value(id),
      songId: Value(songId),
      name: Value(name),
      sortOrder: Value(sortOrder),
      bpm: Value(bpm),
      numerator: Value(numerator),
      denominator: Value(denominator),
      subdivision: Value(subdivision),
      measureCount: Value(measureCount),
      volume: Value(volume),
      accentSound: Value(accentSound),
      normalSound: Value(normalSound),
      subdivisionSound: Value(subdivisionSound),
      announceName: Value(announceName),
      announceCountIn: Value(announceCountIn),
      countInMeasures: Value(countInMeasures),
    );
  }

  factory TempoBlock.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TempoBlock(
      id: serializer.fromJson<String>(json['id']),
      songId: serializer.fromJson<String>(json['songId']),
      name: serializer.fromJson<String>(json['name']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      bpm: serializer.fromJson<int>(json['bpm']),
      numerator: serializer.fromJson<int>(json['numerator']),
      denominator: serializer.fromJson<int>(json['denominator']),
      subdivision: serializer.fromJson<int>(json['subdivision']),
      measureCount: serializer.fromJson<int>(json['measureCount']),
      volume: serializer.fromJson<double>(json['volume']),
      accentSound: serializer.fromJson<String>(json['accentSound']),
      normalSound: serializer.fromJson<String>(json['normalSound']),
      subdivisionSound: serializer.fromJson<String>(json['subdivisionSound']),
      announceName: serializer.fromJson<bool>(json['announceName']),
      announceCountIn: serializer.fromJson<bool>(json['announceCountIn']),
      countInMeasures: serializer.fromJson<int>(json['countInMeasures']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'songId': serializer.toJson<String>(songId),
      'name': serializer.toJson<String>(name),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'bpm': serializer.toJson<int>(bpm),
      'numerator': serializer.toJson<int>(numerator),
      'denominator': serializer.toJson<int>(denominator),
      'subdivision': serializer.toJson<int>(subdivision),
      'measureCount': serializer.toJson<int>(measureCount),
      'volume': serializer.toJson<double>(volume),
      'accentSound': serializer.toJson<String>(accentSound),
      'normalSound': serializer.toJson<String>(normalSound),
      'subdivisionSound': serializer.toJson<String>(subdivisionSound),
      'announceName': serializer.toJson<bool>(announceName),
      'announceCountIn': serializer.toJson<bool>(announceCountIn),
      'countInMeasures': serializer.toJson<int>(countInMeasures),
    };
  }

  TempoBlock copyWith({
    String? id,
    String? songId,
    String? name,
    int? sortOrder,
    int? bpm,
    int? numerator,
    int? denominator,
    int? subdivision,
    int? measureCount,
    double? volume,
    String? accentSound,
    String? normalSound,
    String? subdivisionSound,
    bool? announceName,
    bool? announceCountIn,
    int? countInMeasures,
  }) => TempoBlock(
    id: id ?? this.id,
    songId: songId ?? this.songId,
    name: name ?? this.name,
    sortOrder: sortOrder ?? this.sortOrder,
    bpm: bpm ?? this.bpm,
    numerator: numerator ?? this.numerator,
    denominator: denominator ?? this.denominator,
    subdivision: subdivision ?? this.subdivision,
    measureCount: measureCount ?? this.measureCount,
    volume: volume ?? this.volume,
    accentSound: accentSound ?? this.accentSound,
    normalSound: normalSound ?? this.normalSound,
    subdivisionSound: subdivisionSound ?? this.subdivisionSound,
    announceName: announceName ?? this.announceName,
    announceCountIn: announceCountIn ?? this.announceCountIn,
    countInMeasures: countInMeasures ?? this.countInMeasures,
  );
  TempoBlock copyWithCompanion(TempoBlocksCompanion data) {
    return TempoBlock(
      id: data.id.present ? data.id.value : this.id,
      songId: data.songId.present ? data.songId.value : this.songId,
      name: data.name.present ? data.name.value : this.name,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      bpm: data.bpm.present ? data.bpm.value : this.bpm,
      numerator: data.numerator.present ? data.numerator.value : this.numerator,
      denominator: data.denominator.present
          ? data.denominator.value
          : this.denominator,
      subdivision: data.subdivision.present
          ? data.subdivision.value
          : this.subdivision,
      measureCount: data.measureCount.present
          ? data.measureCount.value
          : this.measureCount,
      volume: data.volume.present ? data.volume.value : this.volume,
      accentSound: data.accentSound.present
          ? data.accentSound.value
          : this.accentSound,
      normalSound: data.normalSound.present
          ? data.normalSound.value
          : this.normalSound,
      subdivisionSound: data.subdivisionSound.present
          ? data.subdivisionSound.value
          : this.subdivisionSound,
      announceName: data.announceName.present
          ? data.announceName.value
          : this.announceName,
      announceCountIn: data.announceCountIn.present
          ? data.announceCountIn.value
          : this.announceCountIn,
      countInMeasures: data.countInMeasures.present
          ? data.countInMeasures.value
          : this.countInMeasures,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TempoBlock(')
          ..write('id: $id, ')
          ..write('songId: $songId, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('bpm: $bpm, ')
          ..write('numerator: $numerator, ')
          ..write('denominator: $denominator, ')
          ..write('subdivision: $subdivision, ')
          ..write('measureCount: $measureCount, ')
          ..write('volume: $volume, ')
          ..write('accentSound: $accentSound, ')
          ..write('normalSound: $normalSound, ')
          ..write('subdivisionSound: $subdivisionSound, ')
          ..write('announceName: $announceName, ')
          ..write('announceCountIn: $announceCountIn, ')
          ..write('countInMeasures: $countInMeasures')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    songId,
    name,
    sortOrder,
    bpm,
    numerator,
    denominator,
    subdivision,
    measureCount,
    volume,
    accentSound,
    normalSound,
    subdivisionSound,
    announceName,
    announceCountIn,
    countInMeasures,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TempoBlock &&
          other.id == this.id &&
          other.songId == this.songId &&
          other.name == this.name &&
          other.sortOrder == this.sortOrder &&
          other.bpm == this.bpm &&
          other.numerator == this.numerator &&
          other.denominator == this.denominator &&
          other.subdivision == this.subdivision &&
          other.measureCount == this.measureCount &&
          other.volume == this.volume &&
          other.accentSound == this.accentSound &&
          other.normalSound == this.normalSound &&
          other.subdivisionSound == this.subdivisionSound &&
          other.announceName == this.announceName &&
          other.announceCountIn == this.announceCountIn &&
          other.countInMeasures == this.countInMeasures);
}

class TempoBlocksCompanion extends UpdateCompanion<TempoBlock> {
  final Value<String> id;
  final Value<String> songId;
  final Value<String> name;
  final Value<int> sortOrder;
  final Value<int> bpm;
  final Value<int> numerator;
  final Value<int> denominator;
  final Value<int> subdivision;
  final Value<int> measureCount;
  final Value<double> volume;
  final Value<String> accentSound;
  final Value<String> normalSound;
  final Value<String> subdivisionSound;
  final Value<bool> announceName;
  final Value<bool> announceCountIn;
  final Value<int> countInMeasures;
  final Value<int> rowid;
  const TempoBlocksCompanion({
    this.id = const Value.absent(),
    this.songId = const Value.absent(),
    this.name = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.bpm = const Value.absent(),
    this.numerator = const Value.absent(),
    this.denominator = const Value.absent(),
    this.subdivision = const Value.absent(),
    this.measureCount = const Value.absent(),
    this.volume = const Value.absent(),
    this.accentSound = const Value.absent(),
    this.normalSound = const Value.absent(),
    this.subdivisionSound = const Value.absent(),
    this.announceName = const Value.absent(),
    this.announceCountIn = const Value.absent(),
    this.countInMeasures = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TempoBlocksCompanion.insert({
    required String id,
    required String songId,
    required String name,
    this.sortOrder = const Value.absent(),
    this.bpm = const Value.absent(),
    this.numerator = const Value.absent(),
    this.denominator = const Value.absent(),
    this.subdivision = const Value.absent(),
    this.measureCount = const Value.absent(),
    this.volume = const Value.absent(),
    this.accentSound = const Value.absent(),
    this.normalSound = const Value.absent(),
    this.subdivisionSound = const Value.absent(),
    this.announceName = const Value.absent(),
    this.announceCountIn = const Value.absent(),
    this.countInMeasures = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       songId = Value(songId),
       name = Value(name);
  static Insertable<TempoBlock> custom({
    Expression<String>? id,
    Expression<String>? songId,
    Expression<String>? name,
    Expression<int>? sortOrder,
    Expression<int>? bpm,
    Expression<int>? numerator,
    Expression<int>? denominator,
    Expression<int>? subdivision,
    Expression<int>? measureCount,
    Expression<double>? volume,
    Expression<String>? accentSound,
    Expression<String>? normalSound,
    Expression<String>? subdivisionSound,
    Expression<bool>? announceName,
    Expression<bool>? announceCountIn,
    Expression<int>? countInMeasures,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (songId != null) 'song_id': songId,
      if (name != null) 'name': name,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (bpm != null) 'bpm': bpm,
      if (numerator != null) 'numerator': numerator,
      if (denominator != null) 'denominator': denominator,
      if (subdivision != null) 'subdivision': subdivision,
      if (measureCount != null) 'measure_count': measureCount,
      if (volume != null) 'volume': volume,
      if (accentSound != null) 'accent_sound': accentSound,
      if (normalSound != null) 'normal_sound': normalSound,
      if (subdivisionSound != null) 'subdivision_sound': subdivisionSound,
      if (announceName != null) 'announce_name': announceName,
      if (announceCountIn != null) 'announce_count_in': announceCountIn,
      if (countInMeasures != null) 'count_in_measures': countInMeasures,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TempoBlocksCompanion copyWith({
    Value<String>? id,
    Value<String>? songId,
    Value<String>? name,
    Value<int>? sortOrder,
    Value<int>? bpm,
    Value<int>? numerator,
    Value<int>? denominator,
    Value<int>? subdivision,
    Value<int>? measureCount,
    Value<double>? volume,
    Value<String>? accentSound,
    Value<String>? normalSound,
    Value<String>? subdivisionSound,
    Value<bool>? announceName,
    Value<bool>? announceCountIn,
    Value<int>? countInMeasures,
    Value<int>? rowid,
  }) {
    return TempoBlocksCompanion(
      id: id ?? this.id,
      songId: songId ?? this.songId,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
      bpm: bpm ?? this.bpm,
      numerator: numerator ?? this.numerator,
      denominator: denominator ?? this.denominator,
      subdivision: subdivision ?? this.subdivision,
      measureCount: measureCount ?? this.measureCount,
      volume: volume ?? this.volume,
      accentSound: accentSound ?? this.accentSound,
      normalSound: normalSound ?? this.normalSound,
      subdivisionSound: subdivisionSound ?? this.subdivisionSound,
      announceName: announceName ?? this.announceName,
      announceCountIn: announceCountIn ?? this.announceCountIn,
      countInMeasures: countInMeasures ?? this.countInMeasures,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (songId.present) {
      map['song_id'] = Variable<String>(songId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (bpm.present) {
      map['bpm'] = Variable<int>(bpm.value);
    }
    if (numerator.present) {
      map['numerator'] = Variable<int>(numerator.value);
    }
    if (denominator.present) {
      map['denominator'] = Variable<int>(denominator.value);
    }
    if (subdivision.present) {
      map['subdivision'] = Variable<int>(subdivision.value);
    }
    if (measureCount.present) {
      map['measure_count'] = Variable<int>(measureCount.value);
    }
    if (volume.present) {
      map['volume'] = Variable<double>(volume.value);
    }
    if (accentSound.present) {
      map['accent_sound'] = Variable<String>(accentSound.value);
    }
    if (normalSound.present) {
      map['normal_sound'] = Variable<String>(normalSound.value);
    }
    if (subdivisionSound.present) {
      map['subdivision_sound'] = Variable<String>(subdivisionSound.value);
    }
    if (announceName.present) {
      map['announce_name'] = Variable<bool>(announceName.value);
    }
    if (announceCountIn.present) {
      map['announce_count_in'] = Variable<bool>(announceCountIn.value);
    }
    if (countInMeasures.present) {
      map['count_in_measures'] = Variable<int>(countInMeasures.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TempoBlocksCompanion(')
          ..write('id: $id, ')
          ..write('songId: $songId, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('bpm: $bpm, ')
          ..write('numerator: $numerator, ')
          ..write('denominator: $denominator, ')
          ..write('subdivision: $subdivision, ')
          ..write('measureCount: $measureCount, ')
          ..write('volume: $volume, ')
          ..write('accentSound: $accentSound, ')
          ..write('normalSound: $normalSound, ')
          ..write('subdivisionSound: $subdivisionSound, ')
          ..write('announceName: $announceName, ')
          ..write('announceCountIn: $announceCountIn, ')
          ..write('countInMeasures: $countInMeasures, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProjectsTable projects = $ProjectsTable(this);
  late final $SetlistsTable setlists = $SetlistsTable(this);
  late final $SongsTable songs = $SongsTable(this);
  late final $TempoBlocksTable tempoBlocks = $TempoBlocksTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    projects,
    setlists,
    songs,
    tempoBlocks,
  ];
}

typedef $$ProjectsTableCreateCompanionBuilder =
    ProjectsCompanion Function({
      required String id,
      required String name,
      Value<String> groupName,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$ProjectsTableUpdateCompanionBuilder =
    ProjectsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> groupName,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$ProjectsTableReferences
    extends BaseReferences<_$AppDatabase, $ProjectsTable, Project> {
  $$ProjectsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SetlistsTable, List<Setlist>> _setlistsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.setlists,
    aliasName: $_aliasNameGenerator(db.projects.id, db.setlists.projectId),
  );

  $$SetlistsTableProcessedTableManager get setlistsRefs {
    final manager = $$SetlistsTableTableManager(
      $_db,
      $_db.setlists,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_setlistsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProjectsTableFilterComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get groupName => $composableBuilder(
    column: $table.groupName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> setlistsRefs(
    Expression<bool> Function($$SetlistsTableFilterComposer f) f,
  ) {
    final $$SetlistsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.setlists,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SetlistsTableFilterComposer(
            $db: $db,
            $table: $db.setlists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProjectsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get groupName => $composableBuilder(
    column: $table.groupName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProjectsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get groupName =>
      $composableBuilder(column: $table.groupName, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> setlistsRefs<T extends Object>(
    Expression<T> Function($$SetlistsTableAnnotationComposer a) f,
  ) {
    final $$SetlistsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.setlists,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SetlistsTableAnnotationComposer(
            $db: $db,
            $table: $db.setlists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProjectsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProjectsTable,
          Project,
          $$ProjectsTableFilterComposer,
          $$ProjectsTableOrderingComposer,
          $$ProjectsTableAnnotationComposer,
          $$ProjectsTableCreateCompanionBuilder,
          $$ProjectsTableUpdateCompanionBuilder,
          (Project, $$ProjectsTableReferences),
          Project,
          PrefetchHooks Function({bool setlistsRefs})
        > {
  $$ProjectsTableTableManager(_$AppDatabase db, $ProjectsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> groupName = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProjectsCompanion(
                id: id,
                name: name,
                groupName: groupName,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String> groupName = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProjectsCompanion.insert(
                id: id,
                name: name,
                groupName: groupName,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProjectsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({setlistsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (setlistsRefs) db.setlists],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (setlistsRefs)
                    await $_getPrefetchedData<Project, $ProjectsTable, Setlist>(
                      currentTable: table,
                      referencedTable: $$ProjectsTableReferences
                          ._setlistsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ProjectsTableReferences(db, table, p0).setlistsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.projectId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ProjectsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProjectsTable,
      Project,
      $$ProjectsTableFilterComposer,
      $$ProjectsTableOrderingComposer,
      $$ProjectsTableAnnotationComposer,
      $$ProjectsTableCreateCompanionBuilder,
      $$ProjectsTableUpdateCompanionBuilder,
      (Project, $$ProjectsTableReferences),
      Project,
      PrefetchHooks Function({bool setlistsRefs})
    >;
typedef $$SetlistsTableCreateCompanionBuilder =
    SetlistsCompanion Function({
      required String id,
      required String projectId,
      required String name,
      Value<int> sortOrder,
      Value<bool> autoChain,
      Value<int> countInMeasures,
      Value<int> rowid,
    });
typedef $$SetlistsTableUpdateCompanionBuilder =
    SetlistsCompanion Function({
      Value<String> id,
      Value<String> projectId,
      Value<String> name,
      Value<int> sortOrder,
      Value<bool> autoChain,
      Value<int> countInMeasures,
      Value<int> rowid,
    });

final class $$SetlistsTableReferences
    extends BaseReferences<_$AppDatabase, $SetlistsTable, Setlist> {
  $$SetlistsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProjectsTable _projectIdTable(_$AppDatabase db) => db.projects
      .createAlias($_aliasNameGenerator(db.setlists.projectId, db.projects.id));

  $$ProjectsTableProcessedTableManager get projectId {
    final $_column = $_itemColumn<String>('project_id')!;

    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$SongsTable, List<Song>> _songsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.songs,
    aliasName: $_aliasNameGenerator(db.setlists.id, db.songs.setlistId),
  );

  $$SongsTableProcessedTableManager get songsRefs {
    final manager = $$SongsTableTableManager(
      $_db,
      $_db.songs,
    ).filter((f) => f.setlistId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_songsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SetlistsTableFilterComposer
    extends Composer<_$AppDatabase, $SetlistsTable> {
  $$SetlistsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get autoChain => $composableBuilder(
    column: $table.autoChain,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get countInMeasures => $composableBuilder(
    column: $table.countInMeasures,
    builder: (column) => ColumnFilters(column),
  );

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> songsRefs(
    Expression<bool> Function($$SongsTableFilterComposer f) f,
  ) {
    final $$SongsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.songs,
      getReferencedColumn: (t) => t.setlistId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SongsTableFilterComposer(
            $db: $db,
            $table: $db.songs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SetlistsTableOrderingComposer
    extends Composer<_$AppDatabase, $SetlistsTable> {
  $$SetlistsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get autoChain => $composableBuilder(
    column: $table.autoChain,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get countInMeasures => $composableBuilder(
    column: $table.countInMeasures,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SetlistsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SetlistsTable> {
  $$SetlistsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get autoChain =>
      $composableBuilder(column: $table.autoChain, builder: (column) => column);

  GeneratedColumn<int> get countInMeasures => $composableBuilder(
    column: $table.countInMeasures,
    builder: (column) => column,
  );

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> songsRefs<T extends Object>(
    Expression<T> Function($$SongsTableAnnotationComposer a) f,
  ) {
    final $$SongsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.songs,
      getReferencedColumn: (t) => t.setlistId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SongsTableAnnotationComposer(
            $db: $db,
            $table: $db.songs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SetlistsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SetlistsTable,
          Setlist,
          $$SetlistsTableFilterComposer,
          $$SetlistsTableOrderingComposer,
          $$SetlistsTableAnnotationComposer,
          $$SetlistsTableCreateCompanionBuilder,
          $$SetlistsTableUpdateCompanionBuilder,
          (Setlist, $$SetlistsTableReferences),
          Setlist,
          PrefetchHooks Function({bool projectId, bool songsRefs})
        > {
  $$SetlistsTableTableManager(_$AppDatabase db, $SetlistsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SetlistsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SetlistsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SetlistsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> projectId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> autoChain = const Value.absent(),
                Value<int> countInMeasures = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SetlistsCompanion(
                id: id,
                projectId: projectId,
                name: name,
                sortOrder: sortOrder,
                autoChain: autoChain,
                countInMeasures: countInMeasures,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String projectId,
                required String name,
                Value<int> sortOrder = const Value.absent(),
                Value<bool> autoChain = const Value.absent(),
                Value<int> countInMeasures = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SetlistsCompanion.insert(
                id: id,
                projectId: projectId,
                name: name,
                sortOrder: sortOrder,
                autoChain: autoChain,
                countInMeasures: countInMeasures,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SetlistsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({projectId = false, songsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (songsRefs) db.songs],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (projectId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.projectId,
                                referencedTable: $$SetlistsTableReferences
                                    ._projectIdTable(db),
                                referencedColumn: $$SetlistsTableReferences
                                    ._projectIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (songsRefs)
                    await $_getPrefetchedData<Setlist, $SetlistsTable, Song>(
                      currentTable: table,
                      referencedTable: $$SetlistsTableReferences
                          ._songsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$SetlistsTableReferences(db, table, p0).songsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.setlistId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SetlistsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SetlistsTable,
      Setlist,
      $$SetlistsTableFilterComposer,
      $$SetlistsTableOrderingComposer,
      $$SetlistsTableAnnotationComposer,
      $$SetlistsTableCreateCompanionBuilder,
      $$SetlistsTableUpdateCompanionBuilder,
      (Setlist, $$SetlistsTableReferences),
      Setlist,
      PrefetchHooks Function({bool projectId, bool songsRefs})
    >;
typedef $$SongsTableCreateCompanionBuilder =
    SongsCompanion Function({
      required String id,
      required String setlistId,
      required String name,
      Value<int> sortOrder,
      Value<bool> autoChain,
      Value<String> notes,
      Value<int> rowid,
    });
typedef $$SongsTableUpdateCompanionBuilder =
    SongsCompanion Function({
      Value<String> id,
      Value<String> setlistId,
      Value<String> name,
      Value<int> sortOrder,
      Value<bool> autoChain,
      Value<String> notes,
      Value<int> rowid,
    });

final class $$SongsTableReferences
    extends BaseReferences<_$AppDatabase, $SongsTable, Song> {
  $$SongsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SetlistsTable _setlistIdTable(_$AppDatabase db) => db.setlists
      .createAlias($_aliasNameGenerator(db.songs.setlistId, db.setlists.id));

  $$SetlistsTableProcessedTableManager get setlistId {
    final $_column = $_itemColumn<String>('setlist_id')!;

    final manager = $$SetlistsTableTableManager(
      $_db,
      $_db.setlists,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_setlistIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TempoBlocksTable, List<TempoBlock>>
  _tempoBlocksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.tempoBlocks,
    aliasName: $_aliasNameGenerator(db.songs.id, db.tempoBlocks.songId),
  );

  $$TempoBlocksTableProcessedTableManager get tempoBlocksRefs {
    final manager = $$TempoBlocksTableTableManager(
      $_db,
      $_db.tempoBlocks,
    ).filter((f) => f.songId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_tempoBlocksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SongsTableFilterComposer extends Composer<_$AppDatabase, $SongsTable> {
  $$SongsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get autoChain => $composableBuilder(
    column: $table.autoChain,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$SetlistsTableFilterComposer get setlistId {
    final $$SetlistsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.setlistId,
      referencedTable: $db.setlists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SetlistsTableFilterComposer(
            $db: $db,
            $table: $db.setlists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> tempoBlocksRefs(
    Expression<bool> Function($$TempoBlocksTableFilterComposer f) f,
  ) {
    final $$TempoBlocksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tempoBlocks,
      getReferencedColumn: (t) => t.songId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TempoBlocksTableFilterComposer(
            $db: $db,
            $table: $db.tempoBlocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SongsTableOrderingComposer
    extends Composer<_$AppDatabase, $SongsTable> {
  $$SongsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get autoChain => $composableBuilder(
    column: $table.autoChain,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$SetlistsTableOrderingComposer get setlistId {
    final $$SetlistsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.setlistId,
      referencedTable: $db.setlists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SetlistsTableOrderingComposer(
            $db: $db,
            $table: $db.setlists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SongsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SongsTable> {
  $$SongsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get autoChain =>
      $composableBuilder(column: $table.autoChain, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$SetlistsTableAnnotationComposer get setlistId {
    final $$SetlistsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.setlistId,
      referencedTable: $db.setlists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SetlistsTableAnnotationComposer(
            $db: $db,
            $table: $db.setlists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> tempoBlocksRefs<T extends Object>(
    Expression<T> Function($$TempoBlocksTableAnnotationComposer a) f,
  ) {
    final $$TempoBlocksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tempoBlocks,
      getReferencedColumn: (t) => t.songId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TempoBlocksTableAnnotationComposer(
            $db: $db,
            $table: $db.tempoBlocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SongsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SongsTable,
          Song,
          $$SongsTableFilterComposer,
          $$SongsTableOrderingComposer,
          $$SongsTableAnnotationComposer,
          $$SongsTableCreateCompanionBuilder,
          $$SongsTableUpdateCompanionBuilder,
          (Song, $$SongsTableReferences),
          Song,
          PrefetchHooks Function({bool setlistId, bool tempoBlocksRefs})
        > {
  $$SongsTableTableManager(_$AppDatabase db, $SongsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SongsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SongsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SongsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> setlistId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> autoChain = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SongsCompanion(
                id: id,
                setlistId: setlistId,
                name: name,
                sortOrder: sortOrder,
                autoChain: autoChain,
                notes: notes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String setlistId,
                required String name,
                Value<int> sortOrder = const Value.absent(),
                Value<bool> autoChain = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SongsCompanion.insert(
                id: id,
                setlistId: setlistId,
                name: name,
                sortOrder: sortOrder,
                autoChain: autoChain,
                notes: notes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$SongsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({setlistId = false, tempoBlocksRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (tempoBlocksRefs) db.tempoBlocks,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (setlistId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.setlistId,
                                    referencedTable: $$SongsTableReferences
                                        ._setlistIdTable(db),
                                    referencedColumn: $$SongsTableReferences
                                        ._setlistIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (tempoBlocksRefs)
                        await $_getPrefetchedData<
                          Song,
                          $SongsTable,
                          TempoBlock
                        >(
                          currentTable: table,
                          referencedTable: $$SongsTableReferences
                              ._tempoBlocksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SongsTableReferences(
                                db,
                                table,
                                p0,
                              ).tempoBlocksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.songId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SongsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SongsTable,
      Song,
      $$SongsTableFilterComposer,
      $$SongsTableOrderingComposer,
      $$SongsTableAnnotationComposer,
      $$SongsTableCreateCompanionBuilder,
      $$SongsTableUpdateCompanionBuilder,
      (Song, $$SongsTableReferences),
      Song,
      PrefetchHooks Function({bool setlistId, bool tempoBlocksRefs})
    >;
typedef $$TempoBlocksTableCreateCompanionBuilder =
    TempoBlocksCompanion Function({
      required String id,
      required String songId,
      required String name,
      Value<int> sortOrder,
      Value<int> bpm,
      Value<int> numerator,
      Value<int> denominator,
      Value<int> subdivision,
      Value<int> measureCount,
      Value<double> volume,
      Value<String> accentSound,
      Value<String> normalSound,
      Value<String> subdivisionSound,
      Value<bool> announceName,
      Value<bool> announceCountIn,
      Value<int> countInMeasures,
      Value<int> rowid,
    });
typedef $$TempoBlocksTableUpdateCompanionBuilder =
    TempoBlocksCompanion Function({
      Value<String> id,
      Value<String> songId,
      Value<String> name,
      Value<int> sortOrder,
      Value<int> bpm,
      Value<int> numerator,
      Value<int> denominator,
      Value<int> subdivision,
      Value<int> measureCount,
      Value<double> volume,
      Value<String> accentSound,
      Value<String> normalSound,
      Value<String> subdivisionSound,
      Value<bool> announceName,
      Value<bool> announceCountIn,
      Value<int> countInMeasures,
      Value<int> rowid,
    });

final class $$TempoBlocksTableReferences
    extends BaseReferences<_$AppDatabase, $TempoBlocksTable, TempoBlock> {
  $$TempoBlocksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SongsTable _songIdTable(_$AppDatabase db) => db.songs.createAlias(
    $_aliasNameGenerator(db.tempoBlocks.songId, db.songs.id),
  );

  $$SongsTableProcessedTableManager get songId {
    final $_column = $_itemColumn<String>('song_id')!;

    final manager = $$SongsTableTableManager(
      $_db,
      $_db.songs,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_songIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TempoBlocksTableFilterComposer
    extends Composer<_$AppDatabase, $TempoBlocksTable> {
  $$TempoBlocksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bpm => $composableBuilder(
    column: $table.bpm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get numerator => $composableBuilder(
    column: $table.numerator,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get denominator => $composableBuilder(
    column: $table.denominator,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get subdivision => $composableBuilder(
    column: $table.subdivision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get measureCount => $composableBuilder(
    column: $table.measureCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get volume => $composableBuilder(
    column: $table.volume,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accentSound => $composableBuilder(
    column: $table.accentSound,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get normalSound => $composableBuilder(
    column: $table.normalSound,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subdivisionSound => $composableBuilder(
    column: $table.subdivisionSound,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get announceName => $composableBuilder(
    column: $table.announceName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get announceCountIn => $composableBuilder(
    column: $table.announceCountIn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get countInMeasures => $composableBuilder(
    column: $table.countInMeasures,
    builder: (column) => ColumnFilters(column),
  );

  $$SongsTableFilterComposer get songId {
    final $$SongsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.songId,
      referencedTable: $db.songs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SongsTableFilterComposer(
            $db: $db,
            $table: $db.songs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TempoBlocksTableOrderingComposer
    extends Composer<_$AppDatabase, $TempoBlocksTable> {
  $$TempoBlocksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bpm => $composableBuilder(
    column: $table.bpm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get numerator => $composableBuilder(
    column: $table.numerator,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get denominator => $composableBuilder(
    column: $table.denominator,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get subdivision => $composableBuilder(
    column: $table.subdivision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get measureCount => $composableBuilder(
    column: $table.measureCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get volume => $composableBuilder(
    column: $table.volume,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accentSound => $composableBuilder(
    column: $table.accentSound,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get normalSound => $composableBuilder(
    column: $table.normalSound,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subdivisionSound => $composableBuilder(
    column: $table.subdivisionSound,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get announceName => $composableBuilder(
    column: $table.announceName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get announceCountIn => $composableBuilder(
    column: $table.announceCountIn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get countInMeasures => $composableBuilder(
    column: $table.countInMeasures,
    builder: (column) => ColumnOrderings(column),
  );

  $$SongsTableOrderingComposer get songId {
    final $$SongsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.songId,
      referencedTable: $db.songs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SongsTableOrderingComposer(
            $db: $db,
            $table: $db.songs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TempoBlocksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TempoBlocksTable> {
  $$TempoBlocksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<int> get bpm =>
      $composableBuilder(column: $table.bpm, builder: (column) => column);

  GeneratedColumn<int> get numerator =>
      $composableBuilder(column: $table.numerator, builder: (column) => column);

  GeneratedColumn<int> get denominator => $composableBuilder(
    column: $table.denominator,
    builder: (column) => column,
  );

  GeneratedColumn<int> get subdivision => $composableBuilder(
    column: $table.subdivision,
    builder: (column) => column,
  );

  GeneratedColumn<int> get measureCount => $composableBuilder(
    column: $table.measureCount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get volume =>
      $composableBuilder(column: $table.volume, builder: (column) => column);

  GeneratedColumn<String> get accentSound => $composableBuilder(
    column: $table.accentSound,
    builder: (column) => column,
  );

  GeneratedColumn<String> get normalSound => $composableBuilder(
    column: $table.normalSound,
    builder: (column) => column,
  );

  GeneratedColumn<String> get subdivisionSound => $composableBuilder(
    column: $table.subdivisionSound,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get announceName => $composableBuilder(
    column: $table.announceName,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get announceCountIn => $composableBuilder(
    column: $table.announceCountIn,
    builder: (column) => column,
  );

  GeneratedColumn<int> get countInMeasures => $composableBuilder(
    column: $table.countInMeasures,
    builder: (column) => column,
  );

  $$SongsTableAnnotationComposer get songId {
    final $$SongsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.songId,
      referencedTable: $db.songs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SongsTableAnnotationComposer(
            $db: $db,
            $table: $db.songs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TempoBlocksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TempoBlocksTable,
          TempoBlock,
          $$TempoBlocksTableFilterComposer,
          $$TempoBlocksTableOrderingComposer,
          $$TempoBlocksTableAnnotationComposer,
          $$TempoBlocksTableCreateCompanionBuilder,
          $$TempoBlocksTableUpdateCompanionBuilder,
          (TempoBlock, $$TempoBlocksTableReferences),
          TempoBlock,
          PrefetchHooks Function({bool songId})
        > {
  $$TempoBlocksTableTableManager(_$AppDatabase db, $TempoBlocksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TempoBlocksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TempoBlocksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TempoBlocksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> songId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> bpm = const Value.absent(),
                Value<int> numerator = const Value.absent(),
                Value<int> denominator = const Value.absent(),
                Value<int> subdivision = const Value.absent(),
                Value<int> measureCount = const Value.absent(),
                Value<double> volume = const Value.absent(),
                Value<String> accentSound = const Value.absent(),
                Value<String> normalSound = const Value.absent(),
                Value<String> subdivisionSound = const Value.absent(),
                Value<bool> announceName = const Value.absent(),
                Value<bool> announceCountIn = const Value.absent(),
                Value<int> countInMeasures = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TempoBlocksCompanion(
                id: id,
                songId: songId,
                name: name,
                sortOrder: sortOrder,
                bpm: bpm,
                numerator: numerator,
                denominator: denominator,
                subdivision: subdivision,
                measureCount: measureCount,
                volume: volume,
                accentSound: accentSound,
                normalSound: normalSound,
                subdivisionSound: subdivisionSound,
                announceName: announceName,
                announceCountIn: announceCountIn,
                countInMeasures: countInMeasures,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String songId,
                required String name,
                Value<int> sortOrder = const Value.absent(),
                Value<int> bpm = const Value.absent(),
                Value<int> numerator = const Value.absent(),
                Value<int> denominator = const Value.absent(),
                Value<int> subdivision = const Value.absent(),
                Value<int> measureCount = const Value.absent(),
                Value<double> volume = const Value.absent(),
                Value<String> accentSound = const Value.absent(),
                Value<String> normalSound = const Value.absent(),
                Value<String> subdivisionSound = const Value.absent(),
                Value<bool> announceName = const Value.absent(),
                Value<bool> announceCountIn = const Value.absent(),
                Value<int> countInMeasures = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TempoBlocksCompanion.insert(
                id: id,
                songId: songId,
                name: name,
                sortOrder: sortOrder,
                bpm: bpm,
                numerator: numerator,
                denominator: denominator,
                subdivision: subdivision,
                measureCount: measureCount,
                volume: volume,
                accentSound: accentSound,
                normalSound: normalSound,
                subdivisionSound: subdivisionSound,
                announceName: announceName,
                announceCountIn: announceCountIn,
                countInMeasures: countInMeasures,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TempoBlocksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({songId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (songId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.songId,
                                referencedTable: $$TempoBlocksTableReferences
                                    ._songIdTable(db),
                                referencedColumn: $$TempoBlocksTableReferences
                                    ._songIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TempoBlocksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TempoBlocksTable,
      TempoBlock,
      $$TempoBlocksTableFilterComposer,
      $$TempoBlocksTableOrderingComposer,
      $$TempoBlocksTableAnnotationComposer,
      $$TempoBlocksTableCreateCompanionBuilder,
      $$TempoBlocksTableUpdateCompanionBuilder,
      (TempoBlock, $$TempoBlocksTableReferences),
      TempoBlock,
      PrefetchHooks Function({bool songId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProjectsTableTableManager get projects =>
      $$ProjectsTableTableManager(_db, _db.projects);
  $$SetlistsTableTableManager get setlists =>
      $$SetlistsTableTableManager(_db, _db.setlists);
  $$SongsTableTableManager get songs =>
      $$SongsTableTableManager(_db, _db.songs);
  $$TempoBlocksTableTableManager get tempoBlocks =>
      $$TempoBlocksTableTableManager(_db, _db.tempoBlocks);
}
