import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_typography.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';
import 'package:staka/shared/widgets/feedback/feedback_message.dart';

/// "Nothing here yet" as an invitation to act (guide §4.3): an icon, a
/// title, one sentence of direction, and usually a primary action. Mirrors
/// the website's empty wardrobe panel.
class AppEmptyState extends StatelessWidget {
  const new({
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.actionIcon,
    this.onActionPressed,
    super.key,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final IconData? actionIcon;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    return FeedbackMessage(
      icon: icon,
      iconColor: context.colors.brandPrimary,
      title: Text(title, style: context.text.headingMedium),
      message: message,
      action: switch ((actionLabel, onActionPressed)) {
        (final label?, final onPressed?) => AppButton(
          label: label,
          icon: actionIcon,
          onPressed: onPressed,
        ),
        _ => null,
      },
    );
  }
}
