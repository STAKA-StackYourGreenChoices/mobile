import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_typography.dart';

/// One row in the account settings card, e.g. "Change password".
class AccountLinkTile extends StatelessWidget {
  const new({
    required this.icon,
    required this.label,
    required this.onPressed,
    super.key,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Card(
    clipBehavior: Clip.antiAlias,
    child: ListTile(
      minTileHeight: 56,
      leading: Icon(icon, color: context.colors.brandPrimary),
      title: Text(label, style: context.text.bodyLarge),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: context.colors.inkSubtle,
      ),
      onTap: onPressed,
    ),
  );
}
