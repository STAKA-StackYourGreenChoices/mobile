import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';

/// The inbox bell with the unread count (V2-9); "9+" above nine.
class NotificationBell extends StatelessWidget {
  const new({required this.unread, required this.onPressed, super.key});

  final int unread;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return IconButton(
      tooltip: unread == 0
          ? l10n.notificationsTitle
          : l10n.notificationsUnread(unread),
      onPressed: onPressed,
      icon: Badge(
        isLabelVisible: unread > 0,
        backgroundColor: colors.danger,
        textColor: colors.onDanger,
        textStyle: context.text.label.copyWith(fontSize: 11, height: 1),
        label: Text(unread > 9 ? '9+' : '$unread'),
        child: Icon(
          unread > 0
              ? Icons.notifications_rounded
              : Icons.notifications_none_rounded,
          color: colors.ink,
        ),
      ),
    );
  }
}
