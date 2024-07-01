// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Account _$AccountFromJson(Map<String, dynamic> json) => Account(
      json['Username'] as String?,
      json['Id'] as String?,
      json['Role'] as String?,
    );

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
      'Username': instance.Username,
      'Id': instance.Id,
      'Role': instance.Role,
    };
