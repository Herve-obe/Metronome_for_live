// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BlockImpl _$$BlockImplFromJson(Map<String, dynamic> json) => _$BlockImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  startBpm: (json['start_bpm'] as num).toInt(),
  endBpm: (json['end_bpm'] as num).toInt(),
  signatureNumerator: (json['signature_numerator'] as num).toInt(),
  signatureDenominator: (json['signature_denominator'] as num).toInt(),
  durationType: $enumDecode(_$DurationTypeEnumMap, json['duration_type']),
  fixedMeasuresCount: (json['fixed_measures_count'] as num?)?.toInt(),
  variationType: $enumDecode(_$VariationTypeEnumMap, json['variation_type']),
  ttsEnabled: json['tts_enabled'] as bool,
  ttsText: json['tts_text'] as String?,
  ttsCountInBeats: (json['tts_count_in_beats'] as num).toInt(),
);

Map<String, dynamic> _$$BlockImplToJson(_$BlockImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'start_bpm': instance.startBpm,
      'end_bpm': instance.endBpm,
      'signature_numerator': instance.signatureNumerator,
      'signature_denominator': instance.signatureDenominator,
      'duration_type': _$DurationTypeEnumMap[instance.durationType]!,
      'fixed_measures_count': instance.fixedMeasuresCount,
      'variation_type': _$VariationTypeEnumMap[instance.variationType]!,
      'tts_enabled': instance.ttsEnabled,
      'tts_text': instance.ttsText,
      'tts_count_in_beats': instance.ttsCountInBeats,
    };

const _$DurationTypeEnumMap = {
  DurationType.fixedMeasures: 'fixedMeasures',
  DurationType.manualLoop: 'manualLoop',
};

const _$VariationTypeEnumMap = {
  VariationType.immediate: 'immediate',
  VariationType.crescendoBeatByBeat: 'crescendoBeatByBeat',
  VariationType.crescendoByMeasure: 'crescendoByMeasure',
};
