import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_typography.dart';

/// One row in the account settings card, e.g. "Change password". [detail]
/// is the current value ("+91 98765 43210", "Not added"). Without
/// [onPressed] the row only shows its value.
class AccountLinkTile extends StatelessWidget {
  const new({
    required this.icon,
    required this.label,
    this.detail,
    this.onPressed,
    super.key,
  });

  final IconData icon;
  final String label;
  final String? detail;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => Card(
    clipBehavior: Clip.antiAlias,
    child: ListTile(
      minTileHeight: 56,
      leading: Icon(icon, color: context.colors.brandPrimary),
      title: Text(label, style: context.text.bodyLarge),
      subtitle: switch (detail) {
        final detail? => Text(
          detail,
          style: context.text.bodyMedium.copyWith(
            color: context.colors.inkMuted,
          ),
        ),
        null => null,
      },
      trailing: onPressed == null
          ? null
          : Icon(Icons.chevron_right_rounded, color: context.colors.inkSubtle),
      onTap: onPressed,
    ),
  );
}
