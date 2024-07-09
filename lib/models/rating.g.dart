// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Rating _$RatingFromJson(Map<String, dynamic> json) => Rating(
      json['scheduleId'] as String,
      (json['paintings'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$RatingToJson(Rating instance) => <String, dynamic>{
      'scheduleId': instance.scheduleId,
      'paintings': instance.paintings,
    };
