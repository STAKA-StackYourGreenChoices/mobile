import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/error/error_mapper.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';
import 'package:staka/shared/widgets/feedback/app_loader.dart';

/// Under the rows: a spinner while the next page loads, or why it failed
/// and a way to try again. Only space once the next page is on its way.
class ProductListFooter extends StatelessWidget {
  const new({
    required this.isLoading,
    required this.failure,
    required this.onRetryPressed,
    super.key,
  });

  final bool isLoading;
  final Failure? failure;
  final VoidCallback onRetryPressed;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
        child: AppLoader(size: AppLoaderSize.sm),
      );
    }
    final failure = this.failure;
    if (failure == null) return const SizedBox(height: AppSpacing.lg);
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Column(
        spacing: AppSpacing.sm,
        children: [
          Text(
            messageForFailure(failure, l10n),
            textAlign: TextAlign.center,
            style: context.text.bodyMedium.copyWith(
              color: context.colors.inkMuted,
            ),
          ),
          AppButton(
            label: l10n.tryAgain,
            icon: Icons.refresh_rounded,
            variant: AppButtonVariant.secondary,
            onPressed: onRetryPressed,
          ),
        ],
      ),
    );
  }
}
