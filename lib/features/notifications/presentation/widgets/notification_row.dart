import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/notifications/notification_models.dart';
import 'package:staka/shared/formatters/date_format.dart';

/// One notification: an icon for what it's about, the title (bold while
/// unread, with a dot), the message and the date.
class NotificationRow extends StatelessWidget {
  const new({required this.notification, required this.onPressed, super.key});

  final AppNotification notification;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final unread = !notification.isRead;
    return MergeSemantics(
      child: Semantics(
        value: unread ? l10n.notificationUnreadLabel : null,
        child: InkWell(
          onTap: onPressed,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 72),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.sm,
                children: [
                  Icon(
                    notificationIcon(notification.target),
                    size: AppSizes.iconDefault,
                    color: unread ? colors.brandPrimary : colors.inkMuted,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: AppSpacing.xxs / 2,
                      children: [
                        Text(
                          notification.title,
                          style: unread
                              ? context.text.label
                              : context.text.bodyLarge,
                        ),
                        if (notification.body.isNotEmpty)
                          Text(
                            notification.body,
                            style: context.text.bodyMedium.copyWith(
                              color: colors.inkMuted,
                            ),
                          ),
                        Text(
                          formatDate(notification.createdAt),
                          style: context.text.bodySmall.copyWith(
                            color: colors.inkMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (unread)
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.xs),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: colors.brandPrimary,
                          shape: BoxShape.circle,
                        ),
                        child: const SizedBox.square(dimension: 10),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

IconData notificationIcon(NotificationTarget target) => switch (target) {
  NotificationTarget.tag => Icons.sell_outlined,
  NotificationTarget.claim ||
  NotificationTarget.brandClaim => Icons.receipt_long_outlined,
  NotificationTarget.dispute => Icons.gavel_rounded,
  NotificationTarget.rewards => Icons.stars_outlined,
  NotificationTarget.voucher => Icons.redeem_rounded,
  NotificationTarget.activity => Icons.history_rounded,
  NotificationTarget.brandApplication => Icons.storefront_outlined,
  NotificationTarget.none => Icons.notifications_none_rounded,
};
