import 'dart:async';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/logging/app_logger.dart';
import 'package:staka/core/network/dio_client.dart';
import 'package:staka/core/sharing/share_target.dart';

part 'event_tracker.g.dart';

/// Event types the app sends itself (`POST /events`, V2-5); the API
/// records the rest where they happen.
abstract final class AnalyticsEvents {
  static const scan = 'SCAN';
  static const scanUnknown = 'SCAN_UNKNOWN';
  static const shareClicked = 'SHARE_CLICKED';
}

/// Tells the API what the shopper did that it can't see. Fire and forget:
/// never awaited, never shown, never breaks a screen.
abstract interface class EventTracker {
  /// A code scanned or typed on the Scan tab: [known] when a partner
  /// brand has the product.
  void scanned(String gtin, {required bool known});

  void shareClicked(ShareChannel channel, {String? cardId});
}

@riverpod
EventTracker eventTracker(Ref ref) => ApiEventTracker(ref.watch(dioProvider));

class ApiEventTracker implements EventTracker {
  const new(this._dio);

  final Dio _dio;

  @override
  void scanned(String gtin, {required bool known}) => _send({
    'type': known ? AnalyticsEvents.scan : AnalyticsEvents.scanUnknown,
    'gtin': gtin,
  });

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
