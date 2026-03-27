import 'package:freezed_annotation/freezed_annotation.dart';

part 'block.freezed.dart';
part 'block.g.dart';

enum DurationType {
  fixedMeasures,
  manualLoop,
}

enum VariationType {
  immediate,
  crescendoBeatByBeat,
  crescendoByMeasure,
}

@freezed
class Block with _$Block {
  const factory Block({
    required String id,
    required String name,
    required int startBpm,
    required int endBpm,
    required int signatureNumerator,
    required int signatureDenominator,
    required DurationType durationType,
    int? fixedMeasuresCount,
    required VariationType variationType,
    required bool ttsEnabled,
    String? ttsText,
    required int ttsCountInBeats,
  }) = _Block;

  factory Block.fromJson(Map<String, dynamic> json) => _$BlockFromJson(json);
}
