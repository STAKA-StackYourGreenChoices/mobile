import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';
import 'package:staka/shared/widgets/feedback/feedback_message.dart';

/// No product has this id: the website's 404 line, and the way back its
/// back link offers ("Products").
class ProductNotFound extends StatelessWidget {
  const new({required this.onProductsPressed, super.key});

  final VoidCallback onProductsPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return FeedbackMessage(
      icon: Icons.search_off_rounded,
      iconColor: context.colors.inkMuted,
      message: l10n.pageNotFound,
      action: AppButton(
        label: l10n.adminProducts,
        icon: Icons.arrow_back_rounded,
        variant: AppButtonVariant.secondary,
        onPressed: onProductsPressed,
      ),
    );
  }
}
