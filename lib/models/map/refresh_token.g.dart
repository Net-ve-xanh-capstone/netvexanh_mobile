// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../refresh_token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RefreshToken _$RefreshTokenFromJson(Map<String, dynamic> json) => RefreshToken(
      json['Current'] == null
          ? null
          : DateTime.parse(json['Current'] as String),
      json['CreateTime'] == null
          ? null
          : DateTime.parse(json['CreateTime'] as String),
      json['Expired'] == null
          ? null
          : DateTime.parse(json['Expired'] as String),
      json['Token'] as String?,
    );

Map<String, dynamic> _$RefreshTokenToJson(RefreshToken instance) =>
    <String, dynamic>{
      'Current': instance.Current?.toIso8601String(),
      'CreateTime': instance.CreateTime?.toIso8601String(),
      'Expired': instance.Expired?.toIso8601String(),
      'Token': instance.Token,
    };
