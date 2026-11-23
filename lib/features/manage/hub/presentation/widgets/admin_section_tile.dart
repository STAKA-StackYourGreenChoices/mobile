import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';

/// One admin area in the hub: its name, what it is for (the website's page
/// description) and a chevron. The whole card opens it.
class AdminSectionTile extends StatelessWidget {
  const new({
    required this.icon,
    required this.title,
    required this.description,
    required this.onPressed,
    super.key,
  });

  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Card(
    clipBehavior: Clip.antiAlias,
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      leading: Icon(icon, color: context.colors.brandPrimary),
      title: Text(title, style: context.text.label),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: AppSpacing.xxs),
        child: Text(
          description,
          style: context.text.bodySmall.copyWith(
            color: context.colors.inkMuted,
          ),
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: context.colors.inkSubtle,
      ),
      onTap: onPressed,
    ),
  );
}
