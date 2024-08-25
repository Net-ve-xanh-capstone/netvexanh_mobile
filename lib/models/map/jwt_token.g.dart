// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../jwt_token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JwtToken _$JwtTokenFromJson(Map<String, dynamic> json) => JwtToken(
      json['jwToken'] as String?,
      json['success'] as bool?,
      json['message'] as String?,
    );

Map<String, dynamic> _$JwtTokenToJson(JwtToken instance) => <String, dynamic>{
      'jwToken': instance.jwToken,
      'success': instance.success,
      'message': instance.message,
    };
