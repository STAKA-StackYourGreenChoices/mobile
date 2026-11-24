import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/error/error_mapper.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/push/push_controller.dart';
import 'package:staka/core/push/push_messaging.dart';
import 'package:staka/features/notifications/presentation/state/notification_settings_controller.dart';
import 'package:staka/shared/widgets/feedback/app_error_state.dart';
import 'package:staka/shared/widgets/feedback/app_form_alert.dart';
import 'package:staka/shared/widgets/feedback/app_loader.dart';
import 'package:staka/shared/widgets/feedback/app_snackbar.dart';
import 'package:staka/shared/widgets/layout/app_scaffold.dart';

/// Account → Notifications (V2-9): whether STAKA may send push
/// notifications and emails about decisions, shares and rewards.
class NotificationSettingsScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final state = ref.watch(notificationSettingsControllerProvider);
    final controller = ref.read(
      notificationSettingsControllerProvider.notifier,
    );
    final push = ref.watch(pushControllerProvider);
    final pushController = ref.read(pushControllerProvider.notifier);

    ref.listen(notificationSettingsControllerProvider, (previous, next) {
      final failure = next is NotificationSettingsLoaded
          ? next.saveFailure
          : null;
      if (failure == null) return;
      AppSnackbar.show(
        context,
        message: messageForFailure(failure, l10n),
        tone: AlertTone.error,
      );
    });

    return AppScaffold(
      showAppBar: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Text(
              l10n.notificationSettingsTitle,
              style: context.text.headingLarge,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            l10n.notificationSettingsBody,
            style: context.text.bodyLarge.copyWith(
              color: context.colors.inkMuted,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          switch (state) {
            NotificationSettingsLoading() => const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
              child: AppLoader(),
            ),
            NotificationSettingsFailed(:final failure) => AppErrorState(
              failure: failure,
              onRetryPressed: controller.retry,
            ),
            NotificationSettingsLoaded(:final settings, :final isSaving) =>
              Column(
                children: [
                  // Push needs the phone's permission too (Android 13+).
                  if (push.isAvailable &&
                      push.permission != PushPermission.granted)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: PhonePushOffNotice(
                        canAsk: push.canAsk,
                        onAllowPressed: pushController.requestPermission,
                      ),
                    ),
                  _SettingSwitch(
                    icon: Icons.notifications_active_outlined,
                    title: l10n.pushNotifications,
                    body: l10n.pushNotificationsBody,
                    value: settings.push,
                    onChanged: isSaving
                        ? null
                        : (on) {
                            unawaited(controller.setPush(on: on));
                            if (on && push.canAsk) {
                              unawaited(pushController.requestPermission());
                            }
                          },
                  ),
                  const Divider(height: 1),
                  _SettingSwitch(
                    icon: Icons.mail_outline_rounded,
                    title: l10n.emailNotifications,
                    body: l10n.emailNotificationsBody,
                    value: settings.email,
                    onChanged: isSaving
                        ? null
                        : (on) => controller.setEmail(on: on),
                  ),
                ],
              ),
          },
        ],
      ),
    );
  }
}

class _SettingSwitch extends StatelessWidget {
  const new({
    required this.icon,
    required this.title,
    required this.body,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String body;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) => SwitchListTile(
    value: value,
    onChanged: onChanged,
    contentPadding: EdgeInsets.zero,
    secondary: Icon(icon, color: context.colors.inkMuted),
    title: Text(title, style: context.text.bodyLarge),
    subtitle: Text(
      body,
      style: context.text.bodySmall.copyWith(color: context.colors.inkMuted),
    ),
  );
}

/// Push is on for the account but the phone doesn't allow it. Android asks
/// only once; after a "no" only the phone's settings can change it.
class PhonePushOffNotice extends StatelessWidget {
  const new({required this.canAsk, required this.onAllowPressed, super.key});

  final bool canAsk;
  final VoidCallback onAllowPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return Card(
      child: Padding(
        padding: AppSpacing.card,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.xs,
          children: [
            Row(
              spacing: AppSpacing.sm,
              children: [
                Icon(Icons.notifications_off_outlined, color: colors.inkMuted),
                Expanded(
                  child: Text(
                    l10n.phonePushOffTitle,
                    style: context.text.label,
                  ),
                ),
              ],
            ),
            Text(
              canAsk ? l10n.phonePushOffAskBody : l10n.phonePushOffDeniedBody,
              style: context.text.bodySmall.copyWith(color: colors.inkMuted),
            ),
            if (canAsk)
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton(
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  onPressed: onAllowPressed,
                  child: Text(l10n.allowNotifications),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
