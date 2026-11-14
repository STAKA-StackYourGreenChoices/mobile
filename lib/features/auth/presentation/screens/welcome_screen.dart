import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/app/routes.dart';
import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/features/auth/presentation/widgets/welcome_hero_tag.dart';
import 'package:staka/features/auth/presentation/widgets/welcome_steps.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';
import 'package:staka/shared/widgets/layout/app_scaffold.dart';

/// First screen for signed-out people: what STAKA does, in the website's
/// words, then one primary action (create an account) and sign in second
/// (DECISIONS.md #6), then a real tag swinging from its string, as on the
/// website's phone layout.
class WelcomeScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.xl),
          Text(l10n.appTagline, style: context.text.displayMedium),
          const SizedBox(height: AppSpacing.md),
          Text(
            l10n.welcomeLede,
            style: context.text.bodyLarge.copyWith(
              color: context.colors.inkMuted,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            label: l10n.createAccount,
            isExpanded: true,
            onPressed: () => context.pushNamed(AppRoute.register.name),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppButton(
            label: l10n.signIn,
            variant: AppButtonVariant.secondary,
            isExpanded: true,
            onPressed: () => context.pushNamed(AppRoute.login.name),
          ),
          const SizedBox(height: AppSpacing.xl),
          const WelcomeHeroTag(),
          const SizedBox(height: AppSpacing.xxl),
          const WelcomeSteps(),
        ],
      ),
    );
  }
}
