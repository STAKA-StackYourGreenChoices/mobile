import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/app/routes.dart';
import 'package:staka/core/auth/session_controller.dart';
import 'package:staka/core/auth/session_state.dart';
import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/error/error_mapper.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/models/user.dart';
import 'package:staka/core/state/request_state.dart';
import 'package:staka/core/utils/phone_number.dart';
import 'package:staka/features/account/presentation/state/account_controller.dart';
import 'package:staka/features/account/presentation/state/account_data_controllers.dart';
import 'package:staka/features/account/presentation/widgets/account_header.dart';
import 'package:staka/features/account/presentation/widgets/account_link_tile.dart';
import 'package:staka/features/account/presentation/widgets/account_section.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';
import 'package:staka/shared/widgets/feedback/app_form_alert.dart';
import 'package:staka/shared/widgets/feedback/app_snackbar.dart';
import 'package:staka/shared/widgets/layout/app_scaffold.dart';

/// The Account tab: who is signed in, how they sign in (phone, email,
/// password), their data (download, delete), sign out. The user comes from
/// the session, so there is nothing to load here.
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
    final export = ref.watch(exportDataControllerProvider);

    ref.listen(exportDataControllerProvider, (_, next) {
      if (next case RequestFailed(:final failure)) {
        AppSnackbar.show(
          context,
          message: messageForFailure(failure, l10n),
          tone: AlertTone.error,
        );
      }
    });

    return AppScaffold(
      title: l10n.navAccount,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AccountHeader(
            name: user.name,
            detail: switch (user) {
              User(:final String email) => email,
              User(:final String phone) => PhoneNumber.display(phone),
              _ => null,
            },
          ),
          const SizedBox(height: AppSpacing.xl),
          AccountSection(
            title: l10n.accountSectionSignIn,
            children: [
              AccountLinkTile(
                icon: Icons.smartphone_rounded,
                label: l10n.accountPhoneRow,
                detail: switch (user.phone) {
                  final phone? => PhoneNumber.display(phone),
                  null => l10n.accountNotAdded,
                },
                onPressed: () => context.pushNamed(AppRoute.accountPhone.name),
              ),
              AccountLinkTile(
                icon: Icons.mail_outline_rounded,
                label: l10n.accountEmailRow,
                detail: switch (user) {
                  User(:final String email, emailVerified: true) => email,
                  User(:final String email) => l10n.accountEmailUnconfirmed(
                    email,
                  ),
                  _ => l10n.accountNotAdded,
                },
                // Changing an email isn't in the API; adding one is.
                onPressed: user.email == null
                    ? () => context.pushNamed(AppRoute.addEmail.name)
                    : null,
              ),
              if (user.hasPassword)
                AccountLinkTile(
                  icon: Icons.lock_outline_rounded,
                  label: l10n.changePassword,
                  onPressed: () =>
                      context.pushNamed(AppRoute.changePassword.name),
                )
              else
                AccountLinkTile(
                  icon: Icons.lock_outline_rounded,
                  label: l10n.setPasswordTitle,
                  onPressed: () => context.pushNamed(AppRoute.setPassword.name),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          AccountSection(
            title: l10n.accountSectionData,
            children: [
              AccountLinkTile(
                icon: Icons.download_rounded,
                label: l10n.downloadData,
                detail: l10n.downloadDataDetail,
                isBusy: export is RequestSending,
                onPressed: ref
                    .read(exportDataControllerProvider.notifier)
                    .download,
              ),
              AccountLinkTile(
                icon: Icons.delete_outline_rounded,
                label: l10n.deleteAccount,
                isDestructive: true,
                onPressed: () => context.pushNamed(AppRoute.deleteAccount.name),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
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
