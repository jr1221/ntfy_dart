// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_error_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServerErrorResponse _$ServerErrorResponseFromJson(Map<String, dynamic> json) =>
    ServerErrorResponse(
      code: json['code'] as int,
      http: json['http'] as int,
      error: json['error'] as String,
      link: json['link'] == null ? null : Uri.parse(json['link'] as String),
    );
