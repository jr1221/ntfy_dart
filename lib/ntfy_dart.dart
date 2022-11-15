/// Wrapper around the [ntfy](https://ntfy.sh/) server API, with support for self-hosted servers
/// Create a new [NtfyClient] to get started
library ntfy_dart;

export 'src/models/publishable_message.dart';
export 'src/models/message_response.dart';
export 'src/models/server_error_response.dart';
export 'src/models/shared_model.dart';
export 'src/client.dart';

/// Helper function to schedule a message for a specific date rather than a [Duration], example:
/// ```
/// final model = PublishableMessage(
///       topic: 'EXAMPLETOPIC',
///       delay: durationToDate(Duration(seconds: 45);
/// ```
DateTime durationToDate(Duration duration) {
  return DateTime.now().add(duration);
}
