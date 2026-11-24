import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/app/router/router.dart';
import 'package:staka/core/auth/session_controller.dart';
import 'package:staka/core/auth/session_state.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/notifications/notifications_repository.dart';
import 'package:staka/core/push/push_controller.dart';
import 'package:staka/core/push/push_messaging.dart';
import 'package:staka/features/brand_portal/presentation/state/current_brand.dart';
import 'package:staka/features/notifications/presentation/notification_destination.dart';
import 'package:staka/shared/widgets/feedback/app_snackbar.dart';

/// Push in the running app (V2-9): keeps [PushController] going, opens what
/// a tapped notification is about (from the background, or once signed in
/// when it started the app), and shows one that arrives while the app is
/// open as a banner with "Open".
class PushMessageHandler extends ConsumerStatefulWidget {
  const new({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<PushMessageHandler> createState() => _PushMessageHandlerState();
}

class _PushMessageHandlerState extends ConsumerState<PushMessageHandler> {
  final List<StreamSubscription<PushMessage>> _subscriptions = [];
  bool _isListening = false;

  /// Tapped before the session was ready; opened once signed in.
  PushMessage? _pending;

  @override
  void initState() {
    super.initState();
    ref
      ..listenManual(pushControllerProvider, (_, next) {
        if (next.isAvailable) unawaited(_listen());
      }, fireImmediately: true)
      ..listenManual(sessionControllerProvider, (_, next) {
        if (next is SignedIn && _pending != null) {
          final message = _pending!;
          _pending = null;
          // After the redirect to the wardrobe has run.
          unawaited(Future.microtask(() => _open(message)));
        }
      });
  }

  Future<void> _listen() async {
    if (_isListening) return;
    _isListening = true;
    final messaging = ref.read(pushMessagingProvider);
    _subscriptions
      ..add(messaging.openedMessages.listen(_open))
      ..add(messaging.foregroundMessages.listen(_show));
    final initial = await messaging.initialMessage();
    if (initial != null && mounted) _open(initial);
  }

  void _open(PushMessage message) {
    if (ref.read(sessionControllerProvider) is! SignedIn) {
      _pending = message;
      return;
    }
    ref.read(notificationsRevisionProvider.notifier).bump();
    final destination = notificationDestination(message.asNotification);
    if (destination == null) return;
    openNotificationDestination(
      destination,
      router: ref.read(routerProvider),
      selectBrand: ref.read(selectedBrandIdProvider.notifier).select,
      // From outside the app: the screen alone, not over another.
      stack: false,
    );
  }

  void _show(PushMessage message) {
    if (!mounted || ref.read(sessionControllerProvider) is! SignedIn) return;
    ref.read(notificationsRevisionProvider.notifier).bump();
    final text = [?message.title, ?message.body].join('\n');
    if (text.isEmpty) return;
    final canOpen = notificationDestination(message.asNotification) != null;
    AppSnackbar.show(
      context,
      message: text,
      icon: Icons.notifications_active_outlined,
      actionLabel: canOpen ? context.l10n.openNotification : null,
      onAction: canOpen ? () => _open(message) : null,
    );
  }

  @override
  void dispose() {
    for (final subscription in _subscriptions) {
      unawaited(subscription.cancel());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
