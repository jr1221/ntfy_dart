// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'publishable_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$PublishableMessageToJson(PublishableMessage instance) {
  final val = <String, dynamic>{
    'hashCode': instance.hashCode,
    'topic': instance.topic,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('message', instance.message);
  writeNotNull('title', instance.title);
  writeNotNull('filename', instance.filename);
  writeNotNull('delay', PublishableMessage._dateTimeToUnixTime(instance.delay));
  writeNotNull('email', instance.email);
  writeNotNull('call', instance.call);
  writeNotNull('tags', instance.tags);
  writeNotNull('priority', _$PriorityLevelsEnumMap[instance.priority]);
  writeNotNull('actions', instance.actions);
  writeNotNull('click', instance.click?.toString());
  writeNotNull('attach', instance.attach?.toString());
  writeNotNull('icon', instance.icon?.toString());
  writeNotNull('authorization', instance.authorization);
  writeNotNull('cache', PublishableMessage._falseToNo(instance.cache));
  writeNotNull('firebase', PublishableMessage._falseToNo(instance.firebase));
  return val;
}

const _$PriorityLevelsEnumMap = {
  PriorityLevels.min: 1,
  PriorityLevels.low: 2,
  PriorityLevels.none: 3,
  PriorityLevels.high: 4,
  PriorityLevels.max: 5,
};
