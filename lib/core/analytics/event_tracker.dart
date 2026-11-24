import 'dart:async';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/logging/app_logger.dart';
import 'package:staka/core/network/dio_client.dart';
import 'package:staka/core/sharing/share_target.dart';

part 'event_tracker.g.dart';

/// Event types the app sends itself (`POST /events`); the API records the
/// rest where they happen. V2-5 adds the scan events.
abstract final class AnalyticsEvents {
  static const shareClicked = 'SHARE_CLICKED';
}

/// Tells the API what the shopper did that it can't see. Fire and forget:
/// never awaited, never shown, never breaks a screen.
abstract interface class EventTracker {
  void shareClicked(ShareChannel channel, {String? cardId});
}

@riverpod
EventTracker eventTracker(Ref ref) => ApiEventTracker(ref.watch(dioProvider));

class ApiEventTracker implements EventTracker {
  const new(this._dio);

  final Dio _dio;

  @override
  void shareClicked(ShareChannel channel, {String? cardId}) => _send({
    'type': AnalyticsEvents.shareClicked,
    'cardId': ?cardId,
    'channel': channel.apiName,
  });

  void _send(Map<String, Object> body) => unawaited(
    _dio
        .post<void>('/events', data: body)
        .then<void>(
          (_) {},
          onError: (Object error) =>
              AppLogger.debug('Event ${body['type']} not sent: $error'),
        ),
  );
}
