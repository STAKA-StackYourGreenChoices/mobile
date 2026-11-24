import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/auth/session_controller.dart';
import 'package:staka/core/auth/session_state.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/logging/app_logger.dart';
import 'package:staka/core/push/device_repository.dart';
import 'package:staka/core/push/push_messaging.dart';

part 'push_controller.g.dart';

@immutable
class PushState {
  const new({
    this.isAvailable = false,
    this.permission = PushPermission.notAsked,
  });

  /// False until Firebase has started, and for good on a build without it.
  final bool isAvailable;
  final PushPermission permission;

  /// Worth asking: push works here and the phone hasn't been asked yet.
  bool get canAsk => isAvailable && permission == PushPermission.notAsked;
}

/// Push for the signed-in person (V2-9): starts Firebase once, registers
/// this phone's token after sign-in (and again when it changes) while
/// notifications are allowed, and removes it on sign-out. Never asks for
/// permission by itself: screens call [requestPermission] at a moment that
/// explains itself.
@Riverpod(keepAlive: true)
class PushController extends _$PushController {
  StreamSubscription<String>? _refreshes;

  /// The token the API has for this phone, if any.
  String? _registered;

  @override
  PushState build() {
    ref
      ..onDispose(() => unawaited(_refreshes?.cancel()))
      ..listen(sessionControllerProvider, (previous, next) {
        if (next is SignedIn && previous is! SignedIn) {
          unawaited(_register());
        } else if (next is SignedOut && previous is SignedIn) {
          unawaited(_forget());
        }
      });
    unawaited(Future.microtask(_start));
    return const PushState();
  }

  PushMessaging get _messaging => ref.read(pushMessagingProvider);

  Future<void> _start() async {
    final messaging = _messaging;
    if (!await messaging.start() || !ref.mounted) return;
    final permission = await messaging.permission();
    if (!ref.mounted) return;
    state = PushState(isAvailable: true, permission: permission);
    _refreshes = messaging.tokenRefreshes.listen(
      (token) => unawaited(_register(token: token)),
    );
    await _register();
  }

  /// Asks the phone (once it has been asked, Android answers by itself) and
  /// registers the token if allowed.
  Future<PushPermission> requestPermission() async {
    if (!state.isAvailable) return state.permission;
    final permission = await _messaging.requestPermission();
    if (!ref.mounted) return permission;
    state = PushState(isAvailable: true, permission: permission);
    await _register();
    return permission;
  }

  /// Rereads the permission, e.g. after a visit to the phone's settings.
  Future<void> refreshPermission() async {
    if (!state.isAvailable) return;
    final permission = await _messaging.permission();
    if (!ref.mounted) return;
    state = PushState(isAvailable: true, permission: permission);
    await _register();
  }

  /// Call before signing out, while the API still accepts the session.
  Future<void> beforeSignOut() async {
    final token = _registered;
    if (token == null) return;
    _registered = null;
    await ref.read(deviceRepositoryProvider).unregister(token);
  }

  Future<void> _register({String? token}) async {
    if (!state.isAvailable ||
        state.permission != PushPermission.granted ||
        ref.read(sessionControllerProvider) is! SignedIn) {
      return;
    }
    final current = token ?? await _messaging.token();
    if (current == null || current == _registered || !ref.mounted) return;
    final result = await ref.read(deviceRepositoryProvider).register(current);
    if (result is Ok) {
      _registered = current;
    } else {
      AppLogger.debug('Could not register this phone for push', name: 'push');
    }
  }

  /// Signed out (by choice or not): this phone's token stops working, so
  /// nothing more arrives for the old account.
  Future<void> _forget() async {
    _registered = null;
    if (!state.isAvailable) return;
    try {
      await _messaging.deleteToken();
    } on Object catch (error) {
      AppLogger.debug('Could not delete the push token: $error', name: 'push');
    }
  }
}
