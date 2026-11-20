import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';

/// "We sent a confirmation link to …" with "Send a new link" — the
/// website's `VerifyEmailBanner`. [statusMessage] replaces the reminder
/// after a resend and is announced to screen readers.
class VerifyEmailBanner extends StatelessWidget {
  const new({
    required this.email,
    required this.onResendPressed,
    this.statusMessage,
    this.isJustJoined = false,
    this.isSending = false,
    super.key,
  });

  final String email;
  final VoidCallback onResendPressed;
  final String? statusMessage;
  final bool isJustJoined;
  final bool isSending;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final reminder = isJustJoined
        ? l10n.verifyEmailJustJoined(email)
        : l10n.verifyEmailReminder(email);
    return Semantics(
      container: true,
      label: l10n.confirmYourEmail,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.brandPrimary.withValues(alpha: 0.06),
          border: Border.all(
            color: colors.brandPrimary.withValues(alpha: 0.25),
          ),
          borderRadius: AppRadius.allMd,
        ),
        child: Padding(
          padding: AppSpacing.card,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.sm,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.sm,
                children: [
                  Icon(
                    Icons.mark_email_unread_outlined,
                    size: AppSizes.iconInline,
                    color: colors.brandPrimary,
                  ),
                  Expanded(
                    child: Semantics(
                      liveRegion: statusMessage != null,
                      child: Text(
                        statusMessage ?? reminder,
                        style: context.text.bodyMedium,
                      ),
                    ),
                  ),
                ],
              ),
              AppButton(
                label: l10n.sendNewLink,
                loadingLabel: l10n.sending,
                variant: AppButtonVariant.secondary,
                isLoading: isSending,
                onPressed: onResendPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
