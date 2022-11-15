// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Action _$ActionFromJson(Map<String, dynamic> json) => Action(
      action: $enumDecode(_$ActionTypesEnumMap, json['action']),
      label: json['label'] as String,
      url: json['url'] == null ? null : Uri.parse(json['url'] as String),
      body: json['body'] as String?,
      clear: json['clear'] as bool?,
      intent: json['intent'] as String?,
      extras: (json['extras'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      method: $enumDecodeNullable(_$MethodTypesEnumMap, json['method']),
      headers: (json['headers'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
    );

Map<String, dynamic> _$ActionToJson(Action instance) {
  final val = <String, dynamic>{
    'action': _$ActionTypesEnumMap[instance.action]!,
    'label': instance.label,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('body', instance.body);
  writeNotNull('intent', instance.intent);
  writeNotNull('url', instance.url?.toString());
  writeNotNull('clear', instance.clear);
  writeNotNull('extras', instance.extras);
  writeNotNull('headers', instance.headers);
  writeNotNull('method', _$MethodTypesEnumMap[instance.method]);
  return val;
}

const _$ActionTypesEnumMap = {
  ActionTypes.view: 'view',
  ActionTypes.broadcast: 'broadcast',
  ActionTypes.http: 'http',
};

const _$MethodTypesEnumMap = {
  MethodTypes.get: 'GET',
  MethodTypes.post: 'POST',
  MethodTypes.put: 'PUT',
};
