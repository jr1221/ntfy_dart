import 'package:json_annotation/json_annotation.dart';
import 'shared_model.dart';

part 'message_response.g.dart';

@JsonSerializable(includeIfNull: false, createToJson: false)
class MessageResponse {
  /// Randomly chosen message identifier
  String id;

  /// Message date time, as Unix time stamp
  @JsonKey(fromJson: _dateFromEpochSeconds)
  DateTime time;

  /// Unix time stamp indicating when the message will be deleted, not set if Cache: no is sent
  @JsonKey(fromJson: _dateFromEpochSeconds)
  DateTime? expires;

  /// Message type, typically you'd be only interested in message
  EventTypes event;

  /// Comma-separated list of topics the message is associated with; only one for all message events, but may be a list in open events
  String topic;

  /// Message body; always present in message events
  String? message;

  /// Message [title](https://ntfy.sh/docs/publish/#message-title); if not set defaults to ntfy.sh/<topic>
  String? title;

  /// List of [tags](https://ntfy.sh/docs/publish/#tags-emojis) that may or not map to emojis
  List<String>? tags;

  /// [Message priority](Website opened when notification is clicked)
  PriorityLevels? priority;

  /// Website opened when notification is [clicked](https://ntfy.sh/docs/publish/#click-action)
  Uri? click;

  /// [Action buttons](https://ntfy.sh/docs/publish/#action-buttons) that can be displayed in the notification
  List<Action>? actions;

  Attachment? attachment;

  static DateTime _dateFromEpochSeconds(int seconds) {
    return DateTime.fromMillisecondsSinceEpoch((seconds * 1000).round());
  }

  MessageResponse(
      {required this.id,
      required this.time,
      required this.event,
      required this.topic,
      this.message,
      this.expires,
      this.title,
      this.tags,
      this.priority,
      this.click,
      this.actions,
      this.attachment});

  factory MessageResponse.fromJson(Map<String, dynamic> json) =>
      _$MessageResponseFromJson(json);

  @override
  toString() => message ?? id;
}

@JsonSerializable(includeIfNull: false, createToJson: false)
class Attachment {
  /// Name of the attachment, can be overridden with X-Filename, see [attachments](https://ntfy.sh/docs/publish/#attachments)
  String name;

  /// URL of the attachment
  Uri url;

  /// Mime type of the attachment, only defined if attachment was uploaded to ntfy server
  String? type;

  /// Size of the attachment in bytes, only defined if attachment was uploaded to ntfy server
  int? size;

  /// Attachment expiry date as Unix time stamp, only defined if attachment was uploaded to ntfy server
  int? expires;

  /// [Attachments](https://ntfy.sh/docs/publish/#attachments)
  Attachment(
      {required this.name,
      required this.url,
      this.type,
      this.size,
      this.expires});

  factory Attachment.fromJson(Map<String, dynamic> json) =>
      _$AttachmentFromJson(json);
}

enum EventTypes {
  @JsonValue('open')
  open,
  @JsonValue('keepalive')
  keepAlive,
  @JsonValue('message')
  message,
  @JsonValue('poll_request')
  pollRequest,
}
