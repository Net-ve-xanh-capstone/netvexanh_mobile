// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../list_post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListPost _$ListPostFromJson(Map<String, dynamic> json) => ListPost(
      json['id'] as String?,
      json['image'] as String?,
      json['title'] as String?,
      json['description'] as String?,
      json['staffId'] as String?,
      json['categoryId'] as String?,
      json['categoryName'] as String?,
    );

Map<String, dynamic> _$ListPostToJson(ListPost instance) => <String, dynamic>{
      'id': instance.id,
      'image': instance.image,
      'title': instance.title,
      'description': instance.description,
      'staffId': instance.staffId,
      'categoryId': instance.categoryId,
      'categoryName': instance.categoryName,
    };
