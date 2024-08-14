// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../painting_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaintingResult _$PaintingResultFromJson(Map<String, dynamic> json) =>
    PaintingResult(
      json['paintingId'] as String?,
      json['code'] as String?,
      json['awardId'] as String?,
      json['isPass'] as bool,
      json['reason'] as String?,
    );

Map<String, dynamic> _$PaintingResultToJson(PaintingResult instance) =>
    <String, dynamic>{
      'paintingId': instance.paintingId,
      'code': instance.code,
      'awardId': instance.code,
      'isPass': instance.isPass,
      'reason': instance.reason,
    };
