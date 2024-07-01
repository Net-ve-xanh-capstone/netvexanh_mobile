// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../test_jwt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Test _$TestFromJson(Map<String, dynamic> json) => Test(
      json['token'] as String?,
      json['refreshToken'] as String?,
      json['expiration'] as int?,
    );

Map<String, dynamic> _$TestToJson(Test instance) => <String, dynamic>{
      'token': instance.token,
      'refreshToken': instance.refreshToken,
      'expiration': instance.expiration,
    };
