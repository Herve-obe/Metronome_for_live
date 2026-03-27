// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'block.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Block _$BlockFromJson(Map<String, dynamic> json) {
  return _Block.fromJson(json);
}

/// @nodoc
mixin _$Block {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get startBpm => throw _privateConstructorUsedError;
  int get endBpm => throw _privateConstructorUsedError;
  int get signatureNumerator => throw _privateConstructorUsedError;
  int get signatureDenominator => throw _privateConstructorUsedError;
  DurationType get durationType => throw _privateConstructorUsedError;
  int? get fixedMeasuresCount => throw _privateConstructorUsedError;
  VariationType get variationType => throw _privateConstructorUsedError;
  bool get ttsEnabled => throw _privateConstructorUsedError;
  String? get ttsText => throw _privateConstructorUsedError;
  int get ttsCountInBeats => throw _privateConstructorUsedError;

  /// Serializes this Block to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Block
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BlockCopyWith<Block> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BlockCopyWith<$Res> {
  factory $BlockCopyWith(Block value, $Res Function(Block) then) =
      _$BlockCopyWithImpl<$Res, Block>;
  @useResult
  $Res call({
    String id,
    String name,
    int startBpm,
    int endBpm,
    int signatureNumerator,
    int signatureDenominator,
    DurationType durationType,
    int? fixedMeasuresCount,
    VariationType variationType,
    bool ttsEnabled,
    String? ttsText,
    int ttsCountInBeats,
  });
}

/// @nodoc
class _$BlockCopyWithImpl<$Res, $Val extends Block>
    implements $BlockCopyWith<$Res> {
  _$BlockCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Block
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? startBpm = null,
    Object? endBpm = null,
    Object? signatureNumerator = null,
    Object? signatureDenominator = null,
    Object? durationType = null,
    Object? fixedMeasuresCount = freezed,
    Object? variationType = null,
    Object? ttsEnabled = null,
    Object? ttsText = freezed,
    Object? ttsCountInBeats = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
            startBpm:
                null == startBpm
                    ? _value.startBpm
                    : startBpm // ignore: cast_nullable_to_non_nullable
                        as int,
            endBpm:
                null == endBpm
                    ? _value.endBpm
                    : endBpm // ignore: cast_nullable_to_non_nullable
                        as int,
            signatureNumerator:
                null == signatureNumerator
                    ? _value.signatureNumerator
                    : signatureNumerator // ignore: cast_nullable_to_non_nullable
                        as int,
            signatureDenominator:
                null == signatureDenominator
                    ? _value.signatureDenominator
                    : signatureDenominator // ignore: cast_nullable_to_non_nullable
                        as int,
            durationType:
                null == durationType
                    ? _value.durationType
                    : durationType // ignore: cast_nullable_to_non_nullable
                        as DurationType,
            fixedMeasuresCount:
                freezed == fixedMeasuresCount
                    ? _value.fixedMeasuresCount
                    : fixedMeasuresCount // ignore: cast_nullable_to_non_nullable
                        as int?,
            variationType:
                null == variationType
                    ? _value.variationType
                    : variationType // ignore: cast_nullable_to_non_nullable
                        as VariationType,
            ttsEnabled:
                null == ttsEnabled
                    ? _value.ttsEnabled
                    : ttsEnabled // ignore: cast_nullable_to_non_nullable
                        as bool,
            ttsText:
                freezed == ttsText
                    ? _value.ttsText
                    : ttsText // ignore: cast_nullable_to_non_nullable
                        as String?,
            ttsCountInBeats:
                null == ttsCountInBeats
                    ? _value.ttsCountInBeats
                    : ttsCountInBeats // ignore: cast_nullable_to_non_nullable
                        as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BlockImplCopyWith<$Res> implements $BlockCopyWith<$Res> {
  factory _$$BlockImplCopyWith(
    _$BlockImpl value,
    $Res Function(_$BlockImpl) then,
  ) = __$$BlockImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    int startBpm,
    int endBpm,
    int signatureNumerator,
    int signatureDenominator,
    DurationType durationType,
    int? fixedMeasuresCount,
    VariationType variationType,
    bool ttsEnabled,
    String? ttsText,
    int ttsCountInBeats,
  });
}

/// @nodoc
class __$$BlockImplCopyWithImpl<$Res>
    extends _$BlockCopyWithImpl<$Res, _$BlockImpl>
    implements _$$BlockImplCopyWith<$Res> {
  __$$BlockImplCopyWithImpl(
    _$BlockImpl _value,
    $Res Function(_$BlockImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Block
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? startBpm = null,
    Object? endBpm = null,
    Object? signatureNumerator = null,
    Object? signatureDenominator = null,
    Object? durationType = null,
    Object? fixedMeasuresCount = freezed,
    Object? variationType = null,
    Object? ttsEnabled = null,
    Object? ttsText = freezed,
    Object? ttsCountInBeats = null,
  }) {
    return _then(
      _$BlockImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String,
        startBpm:
            null == startBpm
                ? _value.startBpm
                : startBpm // ignore: cast_nullable_to_non_nullable
                    as int,
        endBpm:
            null == endBpm
                ? _value.endBpm
                : endBpm // ignore: cast_nullable_to_non_nullable
                    as int,
        signatureNumerator:
            null == signatureNumerator
                ? _value.signatureNumerator
                : signatureNumerator // ignore: cast_nullable_to_non_nullable
                    as int,
        signatureDenominator:
            null == signatureDenominator
                ? _value.signatureDenominator
                : signatureDenominator // ignore: cast_nullable_to_non_nullable
                    as int,
        durationType:
            null == durationType
                ? _value.durationType
                : durationType // ignore: cast_nullable_to_non_nullable
                    as DurationType,
        fixedMeasuresCount:
            freezed == fixedMeasuresCount
                ? _value.fixedMeasuresCount
                : fixedMeasuresCount // ignore: cast_nullable_to_non_nullable
                    as int?,
        variationType:
            null == variationType
                ? _value.variationType
                : variationType // ignore: cast_nullable_to_non_nullable
                    as VariationType,
        ttsEnabled:
            null == ttsEnabled
                ? _value.ttsEnabled
                : ttsEnabled // ignore: cast_nullable_to_non_nullable
                    as bool,
        ttsText:
            freezed == ttsText
                ? _value.ttsText
                : ttsText // ignore: cast_nullable_to_non_nullable
                    as String?,
        ttsCountInBeats:
            null == ttsCountInBeats
                ? _value.ttsCountInBeats
                : ttsCountInBeats // ignore: cast_nullable_to_non_nullable
                    as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BlockImpl implements _Block {
  const _$BlockImpl({
    required this.id,
    required this.name,
    required this.startBpm,
    required this.endBpm,
    required this.signatureNumerator,
    required this.signatureDenominator,
    required this.durationType,
    this.fixedMeasuresCount,
    required this.variationType,
    required this.ttsEnabled,
    this.ttsText,
    required this.ttsCountInBeats,
  });

  factory _$BlockImpl.fromJson(Map<String, dynamic> json) =>
      _$$BlockImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final int startBpm;
  @override
  final int endBpm;
  @override
  final int signatureNumerator;
  @override
  final int signatureDenominator;
  @override
  final DurationType durationType;
  @override
  final int? fixedMeasuresCount;
  @override
  final VariationType variationType;
  @override
  final bool ttsEnabled;
  @override
  final String? ttsText;
  @override
  final int ttsCountInBeats;

  @override
  String toString() {
    return 'Block(id: $id, name: $name, startBpm: $startBpm, endBpm: $endBpm, signatureNumerator: $signatureNumerator, signatureDenominator: $signatureDenominator, durationType: $durationType, fixedMeasuresCount: $fixedMeasuresCount, variationType: $variationType, ttsEnabled: $ttsEnabled, ttsText: $ttsText, ttsCountInBeats: $ttsCountInBeats)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BlockImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.startBpm, startBpm) ||
                other.startBpm == startBpm) &&
            (identical(other.endBpm, endBpm) || other.endBpm == endBpm) &&
            (identical(other.signatureNumerator, signatureNumerator) ||
                other.signatureNumerator == signatureNumerator) &&
            (identical(other.signatureDenominator, signatureDenominator) ||
                other.signatureDenominator == signatureDenominator) &&
            (identical(other.durationType, durationType) ||
                other.durationType == durationType) &&
            (identical(other.fixedMeasuresCount, fixedMeasuresCount) ||
                other.fixedMeasuresCount == fixedMeasuresCount) &&
            (identical(other.variationType, variationType) ||
                other.variationType == variationType) &&
            (identical(other.ttsEnabled, ttsEnabled) ||
                other.ttsEnabled == ttsEnabled) &&
            (identical(other.ttsText, ttsText) || other.ttsText == ttsText) &&
            (identical(other.ttsCountInBeats, ttsCountInBeats) ||
                other.ttsCountInBeats == ttsCountInBeats));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    startBpm,
    endBpm,
    signatureNumerator,
    signatureDenominator,
    durationType,
    fixedMeasuresCount,
    variationType,
    ttsEnabled,
    ttsText,
    ttsCountInBeats,
  );

  /// Create a copy of Block
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BlockImplCopyWith<_$BlockImpl> get copyWith =>
      __$$BlockImplCopyWithImpl<_$BlockImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BlockImplToJson(this);
  }
}

abstract class _Block implements Block {
  const factory _Block({
    required final String id,
    required final String name,
    required final int startBpm,
    required final int endBpm,
    required final int signatureNumerator,
    required final int signatureDenominator,
    required final DurationType durationType,
    final int? fixedMeasuresCount,
    required final VariationType variationType,
    required final bool ttsEnabled,
    final String? ttsText,
    required final int ttsCountInBeats,
  }) = _$BlockImpl;

  factory _Block.fromJson(Map<String, dynamic> json) = _$BlockImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  int get startBpm;
  @override
  int get endBpm;
  @override
  int get signatureNumerator;
  @override
  int get signatureDenominator;
  @override
  DurationType get durationType;
  @override
  int? get fixedMeasuresCount;
  @override
  VariationType get variationType;
  @override
  bool get ttsEnabled;
  @override
  String? get ttsText;
  @override
  int get ttsCountInBeats;

  /// Create a copy of Block
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BlockImplCopyWith<_$BlockImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
