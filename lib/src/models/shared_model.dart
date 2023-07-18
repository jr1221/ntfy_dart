import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'shared_model.g.dart';

@JsonSerializable(includeIfNull: false)
class Action extends Equatable {
  final ActionTypes action;

  final String label;

  final String? body, intent;

  final Uri? url;

  final bool? clear;

  final Map<String, String>? extras, headers;

  final MethodTypes? method;

  Action(
      {required this.action,
      required this.label,
      this.url,
      this.body,
      this.clear,
      this.intent,
      this.extras,
      this.method,
      this.headers});

  factory Action.fromJson(Map<String, dynamic> json) => _$ActionFromJson(json);

  Map<String, dynamic> toJson() => _$ActionToJson(this);

  @override
  List<Object?> get props =>
      [action, label, url, body, clear, intent, extras, method, headers];

  @override
  bool get stringify => true;
}

enum ActionTypes {
  @JsonValue('view')
  view,
  @JsonValue('broadcast')
  broadcast,
  @JsonValue('http')
  http,
}

enum MethodTypes {
  @JsonValue('GET')
  get,
  @JsonValue('POST')
  post,
  @JsonValue('PUT')
  put,
}

enum PriorityLevels {
  @JsonValue(1)
  min(1),
  @JsonValue(2)
  low(2),
  @JsonValue(3)
  none(3),
  @JsonValue(4)
  high(4),
  @JsonValue(5)
  max(5);

  const PriorityLevels(this.value);
  final int value;
}
