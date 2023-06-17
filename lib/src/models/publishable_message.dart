import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'shared_model.dart';

part 'publishable_message.g.dart';

@JsonSerializable(includeIfNull: false, createFactory: false)
class PublishableMessage {
  /// Target topic name
  String topic;

  /// 	Message body; set to triggered if empty or not passed
  String? message;

  /// [Message title](https://ntfy.sh/docs/publish/#message-title)
  String? title;

  /// File name of the attachment
  String? filename;

  /// Timestamp for delayed delivery
  @JsonKey(toJson: _dateTimeToUnixTime)
  DateTime? delay;

  /// E-mail address for e-mail notifications
  String? email;

  ///Phone number to use for [voice call](https://docs.ntfy.sh/publish/#phone-calls)
  String? call;

  /// List of [tags](https://ntfy.sh/docs/publish/#tags-emojis) that may or not map to emojis
  List<String>? tags;

  /// [Message priority](https://ntfy.sh/docs/publish/#message-priority)
  PriorityLevels? priority;

  /// Custom [user action buttons](https://ntfy.sh/docs/publish/#action-buttons) for notifications
  List<Action>? actions;

  /// Website opened when notification is [clicked](https://ntfy.sh/docs/publish/#click-action)
  Uri? click;

  /// URL of an attachment, see [attach via URL](https://ntfy.sh/docs/publish/#attach-file-from-url)
  Uri? attach;

  /// [Icon](https://ntfy.sh/docs/publish/#icons)
  Uri? icon;

  String? authorization;

  /// [Message caching](https://ntfy.sh/docs/publish/#message-caching)
  @JsonKey(toJson: _falseToNo)
  bool? cache;

  /// [Disable Firebase](https://ntfy.sh/docs/publish/#disable-firebase)
  @JsonKey(toJson: _falseToNo)
  bool? firebase;

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
      this.firebase});

  /// [Open website/app](https://ntfy.sh/docs/publish/#open-websiteapp)
  void addViewAction(
      {required String label, required Uri url, bool clear = false}) {
    if (actions != null) {
      actions?.add(Action(
          action: ActionTypes.view, label: label, url: url, clear: clear));
    } else {
      actions = [
        Action(action: ActionTypes.view, label: label, url: url, clear: clear)
      ];
    }
  }

  /// [Send android broadcast](https://ntfy.sh/docs/publish/#send-android-broadcast)
  void addBroadcastAction(
      {required String label,
      String? intent,
      Map<String, String>? extras,
      bool clear = false}) {
    if (actions != null) {
      actions?.add(Action(
          action: ActionTypes.broadcast,
          label: label,
          intent: intent,
          extras: extras,
          clear: clear));
    } else {
      actions = [
        Action(
            action: ActionTypes.broadcast,
            label: label,
            intent: intent,
            extras: extras,
            clear: clear)
      ];
    }
  }

  /// [Send HTTP Request](https://ntfy.sh/docs/publish/#send-http-request)
  void addHttpAction(
      {required String label,
      required Uri url,
      MethodTypes? method,
      Map<String, String>? headers,
      String? body,
      bool clear = false}) {
    if (actions != null) {
      actions?.add(Action(
          action: ActionTypes.http,
          label: label,
          url: url,
          method: method,
          headers: headers,
          body: body,
          clear: clear));
    } else {
      actions = [
        Action(
            action: ActionTypes.http,
            label: label,
            url: url,
            method: method,
            headers: headers,
            body: body,
            clear: clear)
      ];
    }
  }

  /// [Username + password auth](https://docs.ntfy.sh/publish/?h=call#username-password)
  void addAuthentication({required String username, required String password}) {
    authorization = 'Basic ${base64Encode(('$username:$password').codeUnits)}';
  }

  /// [Acccess token auth (bearer)](https://docs.ntfy.sh/publish/?h=call#access-tokens)
  void addTokenAuthentication({required String accessToken}) {
    authorization = 'Bearer $accessToken';
  }

  Map<String, dynamic> toJson() => _$PublishableMessageToJson(this);

  @override
  toString() => message ?? topic;
}
