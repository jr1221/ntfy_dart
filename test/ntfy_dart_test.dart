import 'package:ntfy_dart/ntfy_dart.dart';
import 'package:test/test.dart';

/// Environment variables (pass in with --define=<KEY>=<VALUE>, system environment variables not supported!
/// NTFY_SERVER_URL  (required) URL of ntfy server for testing, do not use ntfy.sh!
/// TOPIC_TEST_PREFIX (optional) prefix by which to test topics are properly being registered, defaults to darttest
///
/// This test suite is not optimal as it relies on a properly configured server, so fails could fall in two codebases
void main() {
  if (!bool.hasEnvironment('NTFY_SERVER_URL')) {
    print(
        'Error: NTFY_SERVER_URL env var unset. Use --define=<KEY>=<VALUE> to set it!');
    return;
  }
  NtfyClient client = NtfyClient(
      basePath: Uri.parse(String.fromEnvironment('NTFY_SERVER_URL')));

  String topicPrefix =
      String.fromEnvironment('TOPIC_TEST_PREFIX', defaultValue: 'darttest');

  group('Round robin', () {
    test('send', () async {
      final message = await client.publishMessage(PublishableMessage(
          topic: '${topicPrefix}send', message: 'hello world'));
      expect(
          message,
          equals(MessageResponse(
              id: message.id,
              time: message.time,
              event: EventTypes.message,
              topic: '${topicPrefix}send',
              message: 'hello world',
              expires: message.expires)));
    });
    test('poll', () async {
      final message = await client.publishMessage(PublishableMessage(
          topic: '${topicPrefix}poll', message: 'hello world'));
      final polled = await client.pollMessages(['${topicPrefix}poll']);
      expect(message, equals(polled.first));
    });

    test('stream', () async {
      final stream = await client.getMessageStream(['${topicPrefix}stream']);
      final message = await client.publishMessage(PublishableMessage(
          topic: '${topicPrefix}stream', message: 'hello world'));
      final messageStreamed = await stream
          .firstWhere((element) => element.event == EventTypes.message);
      expect(message, equals(messageStreamed));
    });
  });
}
