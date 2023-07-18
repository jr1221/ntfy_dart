import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'server_error_response.g.dart';

/// Server error response, see the [source code](https://github.com/binwiederhier/ntfy/blob/main/server/errors.go) for the full list of error [code]s.
@JsonSerializable(includeIfNull: false, createToJson: false)
class ServerErrorResponse extends Equatable {
  /// Internal error code
  final int code;

  /// HTTP code
  final int http;

  /// Error message
  final String error;

  /// Link to relevant documentation
  final Uri? link;

  ServerErrorResponse(
      {required this.code, required this.http, required this.error, this.link});

  factory ServerErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$ServerErrorResponseFromJson(json);

  @override
  List<Object?> get props => [code, http, error, link];

  @override
  bool get stringify => true;
}
