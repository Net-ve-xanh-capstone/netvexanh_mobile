// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) => Post(
      json['id'] as String?,
      json['url'] as String?,
      json['title'] as String?,
      json['description'] as String?,
      json['staffId'] as String?,
      json['categoryId'] as String?,
      json['categoryName'] as String?,
      (json['images'] as List<dynamic>?)
          ?.map((e) => Image.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'title': instance.title,
      'description': instance.description,
      'staffId': instance.staffId,
      'categoryId': instance.categoryId,
      'categoryName': instance.categoryName,
      'images': instance.images,
    };
