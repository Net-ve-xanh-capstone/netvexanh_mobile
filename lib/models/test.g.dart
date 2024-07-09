// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Test _$TestFromJson(Map<String, dynamic> json) => Test(
      json['Id'] as String,
      (json['quantity'] as num).toInt(),
      (json['images'] as List<dynamic>)
          .map((e) => Painting.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TestToJson(Test instance) => <String, dynamic>{
      'Id': instance.Id,
      'quantity': instance.quantity,
      'images': instance.images,
    };
