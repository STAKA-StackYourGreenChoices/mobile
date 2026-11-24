import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart' as fcm;
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/logging/app_logger.dart';
import 'package:staka/core/notifications/notification_models.dart';

part 'push_messaging.g.dart';

/// Whether the phone lets STAKA show notifications (Android 13+ asks).
enum PushPermission { granted, denied, notAsked }

/// A push notification as the app needs it: what it says and where it
/// leads (`data: {target, id?, brandId?}`, the inbox's shape).
@immutable
class PushMessage {
  const new({this.title, this.body, this.data = const {}});

  final String? title;
  final String? body;
  final Map<String, Object?> data;

  /// As an inbox entry, to reuse its route mapping.
  AppNotification get asNotification => AppNotification(
    id: data['notificationId'] as String? ?? '',
    type: data['type'] as String? ?? '',
    title: title ?? '',
    body: body ?? '',
    createdAt: DateTime.now(),
    target: NotificationTarget.fromApi(data['target'] as String?),
    targetId: data['id'] as String?,
    brandId: data['brandId'] as String?,
  );
}

/// Firebase Cloud Messaging behind an interface (V2-9), so tests and phones
/// without Firebase set up run without it.
abstract interface class PushMessaging {
  /// Starts Firebase. False when push can't work here, e.g. a build made
  /// without `google-services.json`: the app then simply has no push.
  Future<bool> start();

  Future<PushPermission> permission();

  /// Shows the system's question if it hasn't been answered.
  Future<PushPermission> requestPermission();

  Future<String?> token();
  Stream<String> get tokenRefreshes;

  /// Arrived while the app was open.
  Stream<PushMessage> get foregroundMessages;

  /// Tapped while the app was in the background.
  Stream<PushMessage> get openedMessages;

  /// Tapped while the app was closed: it started for this.
  Future<PushMessage?> initialMessage();

  /// Makes the current token invalid, so a signed-out phone gets nothing.
  Future<void> deleteToken();
}

@Riverpod(keepAlive: true)
PushMessaging pushMessaging(Ref ref) => FirebasePushMessaging();

class FirebasePushMessaging implements PushMessaging {
  fcm.FirebaseMessaging get _messaging => fcm.FirebaseMessaging.instance;

  @override
  Future<bool> start() async {
    // Only the Android app has a Firebase config so far.
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return false;
    }
    try {
      if (Firebase.apps.isEmpty) await Firebase.initializeApp();
      return true;
    } on Object catch (error) {
      AppLogger.debug('Push is off: $error', name: 'push');
      return false;
    }
  }

  @override
  Future<PushPermission> permission() async =>
      _permission(await _messaging.getNotificationSettings());

  @override
  Future<PushPermission> requestPermission() async =>
      _permission(await _messaging.requestPermission());

  static PushPermission _permission(fcm.NotificationSettings settings) =>
      switch (settings.authorizationStatus) {
        fcm.AuthorizationStatus.authorized ||
        fcm.AuthorizationStatus.provisional => PushPermission.granted,
        fcm.AuthorizationStatus.denied ||
        fcm.AuthorizationStatus.deniedPermanently => PushPermission.denied,
        fcm.AuthorizationStatus.notDetermined => PushPermission.notAsked,
      };

  @override
  // The classic FCM registration token, which the API sends to with
  // firebase-admin (API plan V2-9). firebase_messaging 17 prefers
  // register()/onRegistered, which give an installation id for "direct
  // send" instead; switch once the API sends that way (DECISIONS V2-9).
  // ignore: deprecated_member_use
  Future<String?> token() => _messaging.getToken();

  @override
  // The classic token's refreshes; see token().
  // ignore: deprecated_member_use
  Stream<String> get tokenRefreshes => _messaging.onTokenRefresh;

  @override
  Stream<PushMessage> get foregroundMessages =>
      fcm.FirebaseMessaging.onMessage.map(_message);

  @override
  Stream<PushMessage> get openedMessages =>
      fcm.FirebaseMessaging.onMessageOpenedApp.map(_message);

  @override
  Future<PushMessage?> initialMessage() async =>
      switch (await _messaging.getInitialMessage()) {
        final message? => _message(message),
        null => null,
      };

  @override
  // Invalidates the classic token; see token().
  // ignore: deprecated_member_use
  Future<void> deleteToken() => _messaging.deleteToken();

  static PushMessage _message(fcm.RemoteMessage message) => PushMessage(
    title: message.notification?.title,
    body: message.notification?.body,
    data: message.data,
  );
}
