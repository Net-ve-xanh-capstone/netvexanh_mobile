// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'painting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Painting _$PaintingFromJson(Map<String, dynamic> json) => Painting(
      Id: json['Id'] as String,
      Image: json['Image'] as String?,
      Name: json['Name'] as String?,
      Description: json['Description'] as String?,
      SubmitTime: DateTime.parse(json['SubmitTime'] as String),
      RoundTopicId: json['RoundTopicId'] as String?,
      ScheduleId: json['ScheduleId'] as String?,
      Status: json['Status'] as String?,
      Code: json['Code'] as String?,
      OwnerName: json['OwnerName'] as String?,
    );

Map<String, dynamic> _$PaintingToJson(Painting instance) => <String, dynamic>{
      'Id': instance.Id,
      'Image': instance.Image,
      'Name': instance.Name,
      'Description': instance.Description,
      'SubmitTime': instance.SubmitTime.toIso8601String(),
      'RoundTopicId': instance.RoundTopicId,
      'ScheduleId': instance.ScheduleId,
      'Status': instance.Status,
      'Code': instance.Code,
      'OwnerName': instance.OwnerName,
    };
