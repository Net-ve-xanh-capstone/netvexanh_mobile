// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************


Account _$AccountFromJson(Map<String, dynamic> json) => Account(
      json['username'] as String?,
      json['avatar'] as String?,
      json['birthday'] == null? null: DateTime.parse(json['birthday'] as String),
      json['fullName'] as String?,
      json['email'] as String?,
      json['address'] as String?,
      json['phone'] as String?,
      json['gender'] as bool
    );

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
      'username': instance.username,
      'avatar': instance.avatar,
      'birthday': instance.birthday?.toIso8601String(),
      'fullName': instance.fullName,
      'email': instance.email,
      'address': instance.address,
      'phone': instance.phone,
      'gender': instance.gender,
    };
