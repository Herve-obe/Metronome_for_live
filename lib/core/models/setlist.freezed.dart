// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'setlist.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Setlist _$SetlistFromJson(Map<String, dynamic> json) {
  return _Setlist.fromJson(json);
}

/// @nodoc
mixin _$Setlist {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get date => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  List<Song> get songs => throw _privateConstructorUsedError;

  /// Serializes this Setlist to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Setlist
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SetlistCopyWith<Setlist> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SetlistCopyWith<$Res> {
  factory $SetlistCopyWith(Setlist value, $Res Function(Setlist) then) =
      _$SetlistCopyWithImpl<$Res, Setlist>;
  @useResult
  $Res call({
    String id,
    String title,
    String? date,
    String? location,
    List<Song> songs,
  });
}

/// @nodoc
class _$SetlistCopyWithImpl<$Res, $Val extends Setlist>
    implements $SetlistCopyWith<$Res> {
  _$SetlistCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Setlist
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? date = freezed,
    Object? location = freezed,
    Object? songs = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            title:
                null == title
                    ? _value.title
                    : title // ignore: cast_nullable_to_non_nullable
                        as String,
            date:
                freezed == date
                    ? _value.date
                    : date // ignore: cast_nullable_to_non_nullable
                        as String?,
            location:
                freezed == location
                    ? _value.location
                    : location // ignore: cast_nullable_to_non_nullable
                        as String?,
            songs:
                null == songs
                    ? _value.songs
                    : songs // ignore: cast_nullable_to_non_nullable
                        as List<Song>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SetlistImplCopyWith<$Res> implements $SetlistCopyWith<$Res> {
  factory _$$SetlistImplCopyWith(
    _$SetlistImpl value,
    $Res Function(_$SetlistImpl) then,
  ) = __$$SetlistImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String? date,
    String? location,
    List<Song> songs,
  });
}

/// @nodoc
class __$$SetlistImplCopyWithImpl<$Res>
    extends _$SetlistCopyWithImpl<$Res, _$SetlistImpl>
    implements _$$SetlistImplCopyWith<$Res> {
  __$$SetlistImplCopyWithImpl(
    _$SetlistImpl _value,
    $Res Function(_$SetlistImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Setlist
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? date = freezed,
    Object? location = freezed,
    Object? songs = null,
  }) {
    return _then(
      _$SetlistImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        title:
            null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                    as String,
        date:
            freezed == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                    as String?,
        location:
            freezed == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                    as String?,
        songs:
            null == songs
                ? _value._songs
                : songs // ignore: cast_nullable_to_non_nullable
                    as List<Song>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SetlistImpl implements _Setlist {
  const _$SetlistImpl({
    required this.id,
    required this.title,
    this.date,
    this.location,
    required final List<Song> songs,
  }) : _songs = songs;

  factory _$SetlistImpl.fromJson(Map<String, dynamic> json) =>
      _$$SetlistImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String? date;
  @override
  final String? location;
  final List<Song> _songs;
  @override
  List<Song> get songs {
    if (_songs is EqualUnmodifiableListView) return _songs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_songs);
  }

  @override
  String toString() {
    return 'Setlist(id: $id, title: $title, date: $date, location: $location, songs: $songs)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SetlistImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.location, location) ||
                other.location == location) &&
            const DeepCollectionEquality().equals(other._songs, _songs));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    date,
    location,
    const DeepCollectionEquality().hash(_songs),
  );

  /// Create a copy of Setlist
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SetlistImplCopyWith<_$SetlistImpl> get copyWith =>
      __$$SetlistImplCopyWithImpl<_$SetlistImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SetlistImplToJson(this);
  }
}

abstract class _Setlist implements Setlist {
  const factory _Setlist({
    required final String id,
    required final String title,
    final String? date,
    final String? location,
    required final List<Song> songs,
  }) = _$SetlistImpl;

  factory _Setlist.fromJson(Map<String, dynamic> json) = _$SetlistImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String? get date;
  @override
  String? get location;
  @override
  List<Song> get songs;

  /// Create a copy of Setlist
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SetlistImplCopyWith<_$SetlistImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
