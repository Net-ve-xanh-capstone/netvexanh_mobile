// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../painting_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaintingResult _$PaintingResultFromJson(Map<String, dynamic> json) =>
    PaintingResult(
      json['paintingId'] as String?,
      json['awardId'] as String?,
      json['reason'] as String?,
      json['code'] as String?,
      json['isPass'] as bool,
      json['award'] as String?,
      json['image'] as String
    );

Map<String, dynamic> _$PaintingResultToJson(PaintingResult instance) =>
    <String, dynamic>{
      'paintingId': instance.paintingId,
      'awardId': instance.awardId,
      'reason': instance.reason,
    };
