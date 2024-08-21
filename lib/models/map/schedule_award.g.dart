// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../schedule_award.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduleAward _$ScheduleAwardFromJson(Map<String, dynamic> json) =>
    ScheduleAward(
      json['id'] as String,
      json['quantity'] as int,
      json['awardId'] as String,
      json['rank'] as String,
      json['scheduleId'] as String,
      json['status'] as String,
      (json['paintingViewModelsList'] as List<dynamic>)
          .map((e) => Painting.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ScheduleAwardToJson(ScheduleAward instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quantity': instance.quantity,
      'awardId': instance.awardId,
      'rank': instance.rank,
      'scheduleId': instance.scheduleId,
      'status': instance.status,
      'paintingViewModelsList': instance.paintingViewModelsList,
    };
