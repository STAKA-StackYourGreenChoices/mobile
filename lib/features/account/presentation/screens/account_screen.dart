import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/app/routes.dart';
import 'package:staka/core/auth/session_controller.dart';
import 'package:staka/core/auth/session_state.dart';
import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/features/account/presentation/state/account_controller.dart';
import 'package:staka/features/account/presentation/widgets/account_header.dart';
import 'package:staka/features/account/presentation/widgets/account_link_tile.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';
import 'package:staka/shared/widgets/layout/app_scaffold.dart';

/// The Account tab: who is signed in, change password, sign out. The user
/// comes from the session, so there is nothing to load here.
class AccountScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final user = ref.watch(
      sessionControllerProvider.select(
        (session) => session is SignedIn ? session.user : null,
      ),
    );
    // Only signed-in people reach this tab; this covers the frame in which
    // the router is leaving after sign-out.
    if (user == null) return const SizedBox.shrink();
    final isSigningOut = ref.watch(accountControllerProvider);

    return AppScaffold(
      title: l10n.navAccount,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AccountHeader(name: user.name, email: user.email),
          const SizedBox(height: AppSpacing.lg),
          AccountLinkTile(
            icon: Icons.lock_outline_rounded,
            label: l10n.changePassword,
            onPressed: () => context.pushNamed(AppRoute.changePassword.name),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            label: l10n.signOut,
            loadingLabel: l10n.signingOut,
            icon: Icons.logout_rounded,
            variant: AppButtonVariant.secondary,
            isLoading: isSigningOut,
            isExpanded: true,
            onPressed: ref.read(accountControllerProvider.notifier).signOut,
          ),
        ],
      ),
    );
  }
}
