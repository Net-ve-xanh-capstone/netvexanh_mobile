// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../jwt_token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JwtToken _$JwtTokenFromJson(Map<String, dynamic> json) => JwtToken(
      json['JwToken'] as String?,
      json['Success'] as bool?,
      json['Message'] as String?,
    );

Map<String, dynamic> _$JwtTokenToJson(JwtToken instance) => <String, dynamic>{
      'JwToken': instance.JwToken,
      'Success': instance.Success,
      'Message': instance.Message,
    };

