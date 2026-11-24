import 'dart:async';

import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/push/device_repository.dart';
import 'package:staka/core/push/push_messaging.dart';

/// Push without Firebase (V2-9). By default push isn't available, as in a
/// build without `google-services.json`, so screens behave as before.
/// [answerToRequest] is what the phone answers when asked.
class FakePushMessaging implements PushMessaging {
  new({
    this.isAvailable = false,
    this.permissionNow = PushPermission.notAsked,
    this.answerToRequest = PushPermission.granted,
    this.currentToken = 'token-1',
    this.initial,
  });

  bool isAvailable;
  PushPermission permissionNow;
  PushPermission answerToRequest;
  String? currentToken;
  PushMessage? initial;

  int permissionRequests = 0;
  int tokenDeletes = 0;

  final _refreshes = StreamController<String>.broadcast();
  final _foreground = StreamController<PushMessage>.broadcast();
  final _opened = StreamController<PushMessage>.broadcast();

  void refreshToken(String token) {
    currentToken = token;
    _refreshes.add(token);
  }

  void receive(PushMessage message) => _foreground.add(message);

  void tap(PushMessage message) => _opened.add(message);

  @override
  Future<bool> start() async => isAvailable;

  @override
  Future<PushPermission> permission() async => permissionNow;

  @override
  Future<PushPermission> requestPermission() async {
    permissionRequests++;
    if (permissionNow == PushPermission.notAsked) {
      permissionNow = answerToRequest;
    }
    return permissionNow;
  }

  @override
  Future<String?> token() async => currentToken;

  @override
  Stream<String> get tokenRefreshes => _refreshes.stream;

  @override
  Stream<PushMessage> get foregroundMessages => _foreground.stream;

  @override
  Stream<PushMessage> get openedMessages => _opened.stream;

  @override
  Future<PushMessage?> initialMessage() async {
    final message = initial;
    initial = null;
    return message;
  }

  @override
  Future<void> deleteToken() async {
    tokenDeletes++;
    currentToken = null;
  }
}

/// Records registrations; [failing] makes them all fail.
class FakeDeviceRepository implements DeviceRepository {
  new({this.failing = false});

  bool failing;
  final List<String> registered = [];
  final List<String> unregistered = [];

  @override
  Future<Result<void>> register(String token) async {
    registered.add(token);
    return failing ? const Err(NetworkFailure()) : const Ok(null);
  }

  @override
  Future<Result<void>> unregister(String token) async {
    unregistered.add(token);
    return const Ok(null);
  }
}
