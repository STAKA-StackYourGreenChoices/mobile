import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/shared/widgets/feedback/app_loader.dart';

/// One row in the account settings card, e.g. "Change password". [detail]
/// is the current value ("+91 98765 43210", "Not added"). Without
/// [onPressed] the row only shows its value. [isBusy] swaps the chevron for
/// a spinner while the row's action runs; [isDestructive] colours a row
/// that leads to something that can't be undone.
class AccountLinkTile extends StatelessWidget {
  const new({
    required this.icon,
    required this.label,
    this.detail,
    this.onPressed,
    this.isBusy = false,
    this.isDestructive = false,
    super.key,
  });

  final IconData icon;
  final String label;
  final String? detail;
  final VoidCallback? onPressed;
  final bool isBusy;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) => Card(
    clipBehavior: Clip.antiAlias,
    child: ListTile(
      minTileHeight: 56,
      leading: Icon(
        icon,
        color: isDestructive
            ? context.colors.dangerText
            : context.colors.brandPrimary,
      ),
      title: Text(
        label,
        style: isDestructive
            ? context.text.bodyLarge.copyWith(color: context.colors.dangerText)
            : context.text.bodyLarge,
      ),
      subtitle: switch (detail) {
        final detail? => Text(
          detail,
          style: context.text.bodyMedium.copyWith(
            color: context.colors.inkMuted,
          ),
        ),
        null => null,
      },
      trailing: switch ((isBusy, onPressed)) {
        // Sized, as AppLoader centres itself in whatever room it gets.
        (true, _) => const SizedBox.square(
          dimension: AppSizes.iconInline,
          child: AppLoader(size: AppLoaderSize.sm),
        ),
        (false, null) => null,
        (false, _) => Icon(
          Icons.chevron_right_rounded,
          color: context.colors.inkSubtle,
        ),
      },
      onTap: isBusy ? null : onPressed,
    ),
  );
}
