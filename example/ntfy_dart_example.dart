import 'package:ntfy_dart/ntfy_dart.dart';

Future<void> main() async {
  // Create the client object for usage of the library, dont forget to dispose of it at the end!
  final String topic = 'ntfy-dart-example';

  final client = NtfyClient();

  // Create the JSON model to be sent to the server by creating a PublishableMessage
  final model = PublishableMessage(
      topic: topic,
      title: 'ntfy_dart',
      message: 'testing the capabilities of ntfy with the dart language!',
      priority: PriorityLevels.low,
      click: Uri.parse('https://github.com/jr1221/ntfy_dart'),
      tags: [
        'api',
        'test',
        'dart', // will render as an emoji on some platforms
      ],
      icon: Uri.parse('https://docs.ntfy.sh/static/img/ntfy.png'), // ntfy logo
      delay: durationToDate(Duration(seconds: 15)));

  // Sent a message to the server, catching and printing any server error that may get sent back
  MessageResponse? message;
  try {
    message = await client.publishMessage(model);
  } catch (error) {
    if (error is NtfyApiError) {
      print(error.serverMessage?.error);
    } else {
      rethrow;
    }
  }

  // you can access every part of a message in a MessageResponse object.  Note this differs from a PublishableMessage
  if (message != null) {
    print(message
        .event); // some events in streams are not going to messages, so be sure to discard them if you aren't interested.
  }

  // Filter and search through recently cached messages, returning a future unlike getMessageStream which is a stream.  Can include messages sent for the future
  final results = await client.pollMessages([topic], scheduled: true);

  for (MessageResponse result in results) {
    print('${result.message}, + ${result.priority}');
  }

  // Subscribe to the topic(s), receiving the MessageResponses right as they are published
  final stream = (await client.getMessageStream([topic],
      filters: FilterOptions(
          /* tags: [
        'api',
        'test',
        'dart'
      ], // needs ALL of these tags to be emited */
          priority: [
            PriorityLevels.low,
            PriorityLevels.none
          ] // needs ANY of the priority levels to be emited
          )));

  // listen to our stream for messages sent to the topic, instantaneous update
  final listening = stream.listen((event) {
    if (event.event == EventTypes.message) {
      //  again note other event types will periodically be sent here, but will be empty
      print(event.message);
      print(event.id); // mostly useful for future polling (see below)

      return;
    } else {
      print('received ${event.event}');
    }
  });

  // IMPORTANT: dispose of the client at the end of your usage to avoid hanging the process or leaving unneeded channels open with the ntfy server
  // this will break our stream, however, unless we do it after we terminate the stream.  Lets do this after the 20 seconds.
  Future.delayed(Duration(seconds: 20)).then((value) {
    listening.cancel();
    client.close();
  });
}
