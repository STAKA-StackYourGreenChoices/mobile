import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

/// One scripted reply: a JSON response, or a thrown [DioException].
typedef FakeReply = Future<ResponseBody> Function(RequestOptions options);

/// A Dio adapter that answers from a script instead of the network, and
/// records every request it receives.
class FakeHttpAdapter implements HttpClientAdapter {
  new(List<FakeReply> replies) : _replies = [...replies];

  final List<FakeReply> _replies;
  final List<RequestOptions> requests = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) {
    requests.add(options);
    if (_replies.isEmpty) throw StateError('No reply scripted');
    return _replies.removeAt(0)(options);
  }

  @override
  void close({bool force = false}) {}
}

FakeReply json(int status, Object? body) =>
    (_) async => ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );

FakeReply connectionError() =>
    (options) async => throw DioException.connectionError(
      requestOptions: options,
      reason: 'offline',
    );
