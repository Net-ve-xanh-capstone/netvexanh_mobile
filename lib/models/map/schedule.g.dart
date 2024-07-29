// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Schedule _$ScheduleFromJson(Map<String, dynamic> json) => Schedule(
      json['id'] as String,
      json['roundId'] as String?,
      json['year'] as String?,
      json['round'] as String?,
      json['examinerId'] as String?,
      json['status'] as String?,
      json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
    );

Map<String, dynamic> _$ScheduleToJson(Schedule instance) => <String, dynamic>{
      'id': instance.id,
      'roundId': instance.roundId,
      'round': instance.round,
      'year': instance.year,
      'examinerId': instance.examinerId,
      'status': instance.status,
      'endDate':instance.endDate
    };
