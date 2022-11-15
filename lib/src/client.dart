import 'dart:convert';

import 'package:http/http.dart' as http;

import 'models/message_response.dart';
import 'models/publishable_message.dart';
import 'models/server_error_response.dart';
import 'models/shared_model.dart';

/// Client to send messages to a ntfy server
/// IMPORTANT: Call [dispose()] when finished using this client (including streams), or your process may hang!
class NtfyClient {
  /// Base path of server running ntfy
  Uri basePath;
  final http.Client _client = http.Client();

  /// Creates a new client.  Optionally pass [basePath] to set custom server, defaults to https://ntfy.sh/.
  /// IMPORTANT: Call [dispose()] when finished using this client (including streams), or your process may hang!
  NtfyClient({Uri? basePath})
      : basePath = basePath ?? Uri.parse('https://ntfy.sh/');

  /// Change the base path of the ntfy server.
  void changeBasePath(Uri newBasePath) {
    basePath = newBasePath;
  }

  /// Publish a message on the server at [basePath], using a [PublishableMessage] object to configure the message
  Future<MessageResponse> publishMessage(
      PublishableMessage publishModel) async {
    final response =
        await _client.post(basePath, body: jsonEncode(publishModel.toJson()));

    try {
      return MessageResponse.fromJson(jsonDecode(response.body));
    } catch (e, s) {
      try {
        throw NtfyApiError(response.statusCode, response,
            ServerErrorResponse.fromJson(jsonDecode(response.body)));
      } catch (_) {
        rethrow;
      }
    }
  }

  /// Subscribe to a stream via GET.  Will emit [MessageResponse]s as they are published.
  Future<Stream<MessageResponse>> getMessageStream(List<String> topics,
      {FilterOptions? filters}) async {
    final streamResponse = await _client.send(http.Request(
        'GET', _constructListenURL(topics: topics, filters: filters)));

    return streamResponse.stream.toStringStream().map<MessageResponse>((event) {
      try {
        return MessageResponse.fromJson(jsonDecode(event));
      } catch (e) {
        try {
          throw NtfyApiError(streamResponse.statusCode, null,
              ServerErrorResponse.fromJson(jsonDecode(event)));
        } catch (_) {
          throw e;
        }
      }
    });
  }

  /// Not recommended:  will emit messages as strings, will also emit blank lines for keepalive
  Future<Stream<String>> getRawStream(List<String> topics,
      {FilterOptions? filters}) async {
    final streamResponse = await _client.send(http.Request('GET',
        _constructListenURL(topics: topics, filters: filters, useRaw: true)));

    return streamResponse.stream.toStringStream();
  }

  /// Poll for messages rather than keeping a connection open, optionally limit how old messages can be and show scheduled messages
  Future<List<MessageResponse>> pollMessages(List<String> topics,
      {DateTime? since, bool scheduled = false, FilterOptions? filters}) async {
    final streamResponse = await _client.send(http.Request(
        'GET',
        _constructListenURL(
            topics: topics,
            since: since,
            scheduled: scheduled,
            filters: filters,
            poll: true)));

    final response = await streamResponse.stream.bytesToString();

    // split response by open brace before id, and remove empty lines
    final splitResp = response.split('{')
      ..removeWhere((element) => element.isEmpty);

    return splitResp.map<MessageResponse>((singleJSON) {
      // add back the open brace and trim whitespace and line breaks
      singleJSON = '{${singleJSON.trim()}';
      try {
        return MessageResponse.fromJson(jsonDecode(singleJSON));
      } catch (e) {
        try {
          throw NtfyApiError(streamResponse.statusCode, null,
              ServerErrorResponse.fromJson(jsonDecode(singleJSON)));
        } catch (_) {
          throw e;
        }
      }
    }).toList();
  }

  /// Constructs URL for filters and other listening parameters in JSON format
  Uri _constructListenURL(
      {required List<String> topics,
      DateTime? since,
      bool scheduled = false,
      FilterOptions? filters,
      bool poll = false,
      bool useRaw = false}) {
    String askString = '/';

    askString += topics.join(',');

    // add JSON endpoint or raw endpoint
    if (useRaw) {
      askString += '/raw';
    } else {
      askString += '/json';
    }

    Map<String, dynamic> queryParams = {};
    if (poll) {
      queryParams['poll'] = '1';
    }
    if (since != null) {
      queryParams['since'] = '${(since.millisecondsSinceEpoch / 1000).round()}';
    }
    if (scheduled) {
      queryParams['sched'] = '1';
    }
    if (filters != null) {
      queryParams.addAll(filters.filterQueryParams());
    }

    Uri askUrl;
    if (basePath.toString().startsWith('https')) {
      askUrl = Uri.https(basePath.authority, askString, queryParams);
    } else {
      askUrl = Uri.http(basePath.authority, askString, queryParams);
    }

    return askUrl;
  }

  /// IMPORTANT: Dispose of the client when finished making requests.  This will terminate stream listeners!
  void close() {
    _client.close();
  }
}

/// An error usually caused by a response by the API, see the [serverMessage] to understand why
class NtfyApiError extends Error {
  ///  Message sent by the server regarding the issue
  final ServerErrorResponse? serverMessage;

  /// HTTP status code sent by the server
  final int statusCode;

  /// Full HTTP response sent by the server, check [response.body] for server response when [serverMessage] could not be parsed
  final http.Response? response;

  NtfyApiError(this.statusCode, [this.response, this.serverMessage]);

  @override
  toString() => serverMessage?.error ?? response?.body ?? 'Unknown Api Error';
}

/// Filter messages via different parameters
class FilterOptions {
  /// Only return messages that match this exact message ID
  String? id;

  /// Only return messages that match this exact message string
  String? message;

  /// Only return messages that match this exact title string
  String? title;

  /// Only return messages that match any priority listed
  List<PriorityLevels>? priority;

  /// Only return messages that match all listed tags
  List<String>? tags;

  /// Filter messages via different parameters
  FilterOptions({this.id, this.message, this.title, this.priority, this.tags});

  Map<String, dynamic> filterQueryParams() {
    Map<String, dynamic> queryParams = {};
    if (id != null) {
      queryParams['id'] = id;
    }

    if (message != null) {
      queryParams['message'] = message;
    }

    if (title != null) {
      queryParams['title'] = title;
    }

    if (priority != null) {
      // make priorities values, as it cannot handle `default`
      queryParams['priority'] = priority?.map<int>((e) => e.value).join(',');
    }

    if (tags != null) {
      queryParams['tags'] = tags?.join(',');
    }

    return queryParams;
  }
}
