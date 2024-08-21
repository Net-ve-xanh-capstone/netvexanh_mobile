// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../painting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Painting _$PaintingFromJson(Map<String, dynamic> json) => Painting(
      id: json['id'] as String,
      image: json['image'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      topicName: json['topicName'] as String?,
      scheduleId: json['scheduleId'] as String?,
      status: json['status'] as String?,
      code: json['code'] as String?,
      ownerName: json['ownerName'] as String?,
    );

Map<String, dynamic> _$PaintingToJson(Painting instance) => <String, dynamic>{
      'id': instance.id,
      'image': instance.image,
      'name': instance.name,
      'description': instance.description,
      'topicName': instance.topicName,
      'scheduleId': instance.scheduleId,
      'status': instance.status,
      'code': instance.code,
      'ownerName': instance.ownerName,
    };
