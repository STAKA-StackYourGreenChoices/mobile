import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/shared/widgets/data_display/staka_mark.dart';

/// Shown for the moment the saved session is being checked at launch. It
/// carries on from the Android splash (same green, same mark) so the start
/// doesn't flash a different screen.
class LaunchScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      backgroundColor: colors.splash,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: AppSpacing.xl,
          children: [
            StakaMark(color: colors.onSplash),
            SizedBox.square(
              dimension: AppSizes.iconInline,
              child: CircularProgressIndicator(
                color: colors.onSplash,
                strokeWidth: 2,
                semanticsLabel: context.l10n.loading,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
