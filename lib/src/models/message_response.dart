import 'package:json_annotation/json_annotation.dart';
import 'shared_model.dart';
import 'package:equatable/equatable.dart';

part 'message_response.g.dart';

@JsonSerializable(includeIfNull: false, createToJson: false)
class MessageResponse extends Equatable {
  /// Randomly chosen message identifier
  final String id;

  /// Message date time, as Unix time stamp
  @JsonKey(fromJson: _dateFromEpochSeconds)
  final DateTime time;

  /// Unix time stamp indicating when the message will be deleted, not set if Cache: no is sent
  @JsonKey(fromJson: _nullableDateFromEpochSeconds)
  final DateTime? expires;

  /// Message type, typically you'd be only interested in message
  final EventTypes event;

  /// Comma-separated list of topics the message is associated with; only one for all message events, but may be a list in open events
  final String topic;

  /// Message body; always present in message events
  final String? message;

  /// Message [title](https://ntfy.sh/docs/publish/#message-title); if not set defaults to ntfy.sh/<topic>
  final String? title;

  /// List of [tags](https://ntfy.sh/docs/publish/#tags-emojis) that may or not map to emojis
  final List<String>? tags;

  /// [Message priority](Website opened when notification is clicked)
  final PriorityLevels? priority;

  /// Website opened when notification is [clicked](https://ntfy.sh/docs/publish/#click-action)
  final Uri? click;

  /// [Action buttons](https://ntfy.sh/docs/publish/#action-buttons) that can be displayed in the notification
  final List<Action>? actions;

  final Attachment? attachment;

  static DateTime _dateFromEpochSeconds(int seconds) {
    return DateTime.fromMillisecondsSinceEpoch((seconds * 1000).round());
  }

  static DateTime? _nullableDateFromEpochSeconds(int? seconds) {
    if (seconds == null) return null;
    return DateTime.fromMillisecondsSinceEpoch((seconds * 1000).round());
  }

  const MessageResponse(
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
  @JsonKey(includeFromJson: false)
  List<Object?> get props => [
        id,
        time,
        event,
        topic,
        message,
        expires,
        title,
        tags,
        priority,
        click,
        actions,
        attachment
      ];

  @override
  @JsonKey(includeFromJson: false)
  bool get stringify => true;

  @JsonKey(includeFromJson: false)
  int get hashcode => super.hashCode;
}

@JsonSerializable(includeIfNull: false, createToJson: false)
class Attachment extends Equatable {
  /// Name of the attachment, can be overridden with X-Filename, see [attachments](https://ntfy.sh/docs/publish/#attachments)
  final String name;

  /// URL of the attachment
  final Uri url;

  /// Mime type of the attachment, only defined if attachment was uploaded to ntfy server
  final String? type;

  /// Size of the attachment in bytes, only defined if attachment was uploaded to ntfy server
  final int? size;

  /// Attachment expiry date as Unix time stamp, only defined if attachment was uploaded to ntfy server
  final int? expires;

  /// [Attachments](https://ntfy.sh/docs/publish/#attachments)
  const Attachment(
      {required this.name,
      required this.url,
      this.type,
      this.size,
      this.expires});

  factory Attachment.fromJson(Map<String, dynamic> json) =>
      _$AttachmentFromJson(json);

  @override
  @JsonKey(includeFromJson: false)
  List<Object?> get props => [name, url, type, size, expires];

  @override
  @JsonKey(includeFromJson: false)
  bool get stringify => true;

  @JsonKey(includeFromJson: false)
  int get hashcode => super.hashCode;
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
