import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'shared_model.dart';

part 'publishable_message.g.dart';

@JsonSerializable(includeIfNull: false, createFactory: false)

/// Note: using helpers to add actions or authorizations may break equality, declare up front for objects needing ==
class PublishableMessage extends Equatable {
  /// Target topic name
  final String topic;

  /// 	Message body; set to triggered if empty or not passed
  final String? message;

  /// [Message title](https://ntfy.sh/docs/publish/#message-title)
  final String? title;

  /// File name of the attachment
  final String? filename;

  /// Timestamp for delayed delivery
  @JsonKey(toJson: _dateTimeToUnixTime)
  final DateTime? delay;

  /// E-mail address for e-mail notifications
  final String? email;

  ///Phone number to use for [voice call](https://docs.ntfy.sh/publish/#phone-calls)
  final String? call;

  /// List of [tags](https://ntfy.sh/docs/publish/#tags-emojis) that may or not map to emojis
  final List<String>? tags;

  /// [Message priority](https://ntfy.sh/docs/publish/#message-priority)
  final PriorityLevels? priority;

  /// Custom [user action buttons](https://ntfy.sh/docs/publish/#action-buttons) for notifications
  final List<Action>? actions;

  /// Website opened when notification is [clicked](https://ntfy.sh/docs/publish/#click-action)
  final Uri? click;

  /// URL of an attachment, see [attach via URL](https://ntfy.sh/docs/publish/#attach-file-from-url)
  final Uri? attach;

  /// [Icon](https://ntfy.sh/docs/publish/#icons)
  final Uri? icon;

  final String? authorization;

  /// [Message caching](https://ntfy.sh/docs/publish/#message-caching)
  @JsonKey(toJson: _falseToNo)
  final bool? cache;

  /// [Disable Firebase](https://ntfy.sh/docs/publish/#disable-firebase)
  @JsonKey(toJson: _falseToNo)
  final bool? firebase;

  static String? _falseToNo(bool? usedIn) {
    if (usedIn != null && !usedIn) return 'No';
    return null;
  }

  static String? _dateTimeToUnixTime(DateTime? date) {
    if (date != null) {
      return (date.millisecondsSinceEpoch / 1000).round().toString();
    }
    return null;
  }

  /// Default constructor (see authentication constructors for help on the authorization field)
  PublishableMessage(
      {required this.topic,
      this.message,
      this.title,
      this.filename,
      this.delay,
      this.email,
      this.call,
      this.priority,
      this.actions,
      this.tags,
      this.click,
      this.attach,
      this.icon,
      this.cache,
      this.firebase,
      this.authorization});

  /// Construct message with [Username + password auth](https://docs.ntfy.sh/publish/?h=call#username-password)
  PublishableMessage.withAuthentication(
      {required this.topic,
      this.message,
      this.title,
      this.filename,
      this.delay,
      this.email,
      this.call,
      this.priority,
      this.actions,
      this.tags,
      this.click,
      this.attach,
      this.icon,
      this.cache,
      this.firebase,
      required String username,
      required String password})
      : authorization =
            'Basic ${base64Encode(('$username:$password').codeUnits)}';

  /// [Acccess token auth (bearer)](https://docs.ntfy.sh/publish/?h=call#access-tokens)
  PublishableMessage.withTokenAuthentication(
      {required this.topic,
      this.message,
      this.title,
      this.filename,
      this.delay,
      this.email,
      this.call,
      this.priority,
      this.actions,
      this.tags,
      this.click,
      this.attach,
      this.icon,
      this.cache,
      this.firebase,
      required String accessToken})
      : authorization = 'Bearer $accessToken';

  Map<String, dynamic> toJson() => _$PublishableMessageToJson(this);

  @override
  List<Object?> get props => [
        topic,
        message,
        title,
        filename,
        delay,
        email,
        call,
        priority,
        actions,
        tags,
        click,
        attach,
        icon,
        cache,
        firebase,
        authorization
      ];

  @override
  bool get stringify => true;
}
