// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageResponse _$MessageResponseFromJson(Map<String, dynamic> json) =>
    MessageResponse(
      id: json['id'] as String,
      time: MessageResponse._dateFromEpochSeconds(json['time'] as int),
      event: $enumDecode(_$EventTypesEnumMap, json['event']),
      topic: json['topic'] as String,
      message: json['message'] as String?,
      expires: MessageResponse._dateFromEpochSeconds(json['expires'] as int),
      title: json['title'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      priority: $enumDecodeNullable(_$PriorityLevelsEnumMap, json['priority']),
      click: json['click'] == null ? null : Uri.parse(json['click'] as String),
      actions: (json['actions'] as List<dynamic>?)
          ?.map((e) => Action.fromJson(e as Map<String, dynamic>))
          .toList(),
      attachment: json['attachment'] == null
          ? null
          : Attachment.fromJson(json['attachment'] as Map<String, dynamic>),
    );

const _$EventTypesEnumMap = {
  EventTypes.open: 'open',
  EventTypes.keepAlive: 'keepalive',
  EventTypes.message: 'message',
  EventTypes.pollRequest: 'poll_request',
};

const _$PriorityLevelsEnumMap = {
  PriorityLevels.min: 1,
  PriorityLevels.low: 2,
  PriorityLevels.none: 3,
  PriorityLevels.high: 4,
  PriorityLevels.max: 5,
};

Attachment _$AttachmentFromJson(Map<String, dynamic> json) => Attachment(
      name: json['name'] as String,
      url: Uri.parse(json['url'] as String),
      type: json['type'] as String?,
      size: json['size'] as int?,
      expires: json['expires'] as int?,
    );

Map<String, dynamic> _$AttachmentToJson(Attachment instance) {
  final val = <String, dynamic>{
    'name': instance.name,
    'url': instance.url.toString(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('type', instance.type);
  writeNotNull('size', instance.size);
  writeNotNull('expires', instance.expires);
  return val;
}
