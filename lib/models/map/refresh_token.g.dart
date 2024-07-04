// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../refresh_token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RefreshToken _$RefreshTokenFromJson(Map<String, dynamic> json) => RefreshToken(
      json['current'] == null
          ? null
          : DateTime.parse(json['current'] as String),
      json['createTime'] == null
          ? null
          : DateTime.parse(json['createTime'] as String),
      json['expired'] == null
          ? null
          : DateTime.parse(json['expired'] as String),
      json['token'] as String?,
    );

Map<String, dynamic> _$RefreshTokenToJson(RefreshToken instance) =>
    <String, dynamic>{
      'current': instance.current?.toIso8601String(),
      'createTime': instance.createTime?.toIso8601String(),
      'expired': instance.expired?.toIso8601String(),
      'token': instance.token,
    };
