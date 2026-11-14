import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';

/// First screen while the app has no routes yet. The router slice replaces it
/// with the welcome / wardrobe flow (PHASE2_PLAN.md §9, slice 6).
class BootScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenH,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.l10n.appName, style: context.text.displayLarge),
              const SizedBox(height: AppSpacing.xs),
              Text(context.l10n.appTagline, style: context.text.bodyLarge),
            ],
          ),
        ),
      ),
    );
  }
}
