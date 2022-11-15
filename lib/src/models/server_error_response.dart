import 'package:json_annotation/json_annotation.dart';

part 'server_error_response.g.dart';

/// Server error response, see the [source code](https://github.com/binwiederhier/ntfy/blob/main/server/errors.go) for the full list of error [code]s.
@JsonSerializable(includeIfNull: false, createToJson: false)
class ServerErrorResponse {
  /// Internal error code
  int code;

  /// HTTP code
  int http;

  /// Error message
  String error;

  /// Link to relevant documentation
  Uri? link;

  ServerErrorResponse(
      {required this.code, required this.http, required this.error, this.link});

  factory ServerErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$ServerErrorResponseFromJson(json);

  @override
  toString() => error;
}
