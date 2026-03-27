// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setlist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SetlistImpl _$$SetlistImplFromJson(Map<String, dynamic> json) =>
    _$SetlistImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      date: json['date'] as String?,
      location: json['location'] as String?,
      songs:
          (json['songs'] as List<dynamic>)
              .map((e) => Song.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$$SetlistImplToJson(_$SetlistImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'date': instance.date,
      'location': instance.location,
      'songs': instance.songs,
    };
