import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';

/// "My wardrobe" (or "Welcome, Ada" right after joining), one line of
/// context, and the Scan action once there is something in it — the
/// website's `PageHeader` on `/wardrobe`.
class WardrobeHeader extends StatelessWidget {
  const new({
    required this.title,
    required this.description,
    this.actionLabel,
    this.onActionPressed,
    this.trailing,
    super.key,
  });

  final String title;
  final String description;
  final String? actionLabel;
  final VoidCallback? onActionPressed;

  /// Beside the title, e.g. the notification bell (V2-9).
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Expanded(
            child: Semantics(
              header: true,
              child: Text(title, style: context.text.headingLarge),
            ),
          ),
          ?trailing,
        ],
      ),
      const SizedBox(height: AppSpacing.xxs),
      Text(
        description,
        style: context.text.bodyLarge.copyWith(color: context.colors.inkMuted),
      ),
      if ((actionLabel, onActionPressed) case (final label?, final onPressed?))
        Padding(
          padding: const EdgeInsets.only(top: AppSpacing.md),
          child: AppButton(
            label: label,
            icon: Icons.qr_code_scanner_rounded,
            onPressed: onPressed,
          ),
        ),
    ],
  );
}
