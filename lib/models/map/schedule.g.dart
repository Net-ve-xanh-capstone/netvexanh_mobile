// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Schedule _$ScheduleFromJson(Map<String, dynamic> json) => Schedule(
      json['id'] as String,
      json['roundId'] as String?,
      json['description'] as String?,
      json['examinerId'] as String?,
    );

Map<String, dynamic> _$ScheduleToJson(Schedule instance) => <String, dynamic>{
      'id': instance.id,
      'roundId': instance.roundId,
      'description': instance.description,
      'examinerId': instance.examinerId,
    };
