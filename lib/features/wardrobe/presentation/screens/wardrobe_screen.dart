import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/app/routes.dart';
import 'package:staka/core/auth/session_controller.dart';
import 'package:staka/core/auth/session_state.dart';
import 'package:staka/core/error/error_mapper.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/models/user.dart';
import 'package:staka/core/state/request_state.dart';
import 'package:staka/features/wardrobe/domain/models/resend_outcome.dart';
import 'package:staka/features/wardrobe/presentation/state/verify_email_controller.dart';
import 'package:staka/features/wardrobe/presentation/state/wardrobe_controller.dart';
import 'package:staka/features/wardrobe/presentation/state/wardrobe_filter.dart';
import 'package:staka/features/wardrobe/presentation/state/wardrobe_state.dart';
import 'package:staka/features/wardrobe/presentation/widgets/verify_email_banner.dart';
import 'package:staka/features/wardrobe/presentation/widgets/wardrobe_scroll_view.dart';
import 'package:staka/shared/widgets/feedback/app_error_state.dart';
import 'package:staka/shared/widgets/feedback/app_form_alert.dart';
import 'package:staka/shared/widgets/feedback/app_loader.dart';
import 'package:staka/shared/widgets/feedback/app_snackbar.dart';
import 'package:staka/shared/widgets/layout/app_scaffold.dart';

/// The Wardrobe tab, the website's `/wardrobe`: the shopper's tags split
/// into verified and waiting for proof, with an email-confirmation banner
/// until the email is confirmed.
class WardrobeScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final session = ref.watch(sessionControllerProvider);
    if (session is! SignedIn) return const SizedBox.shrink();
    final wardrobe = ref.watch(wardrobeControllerProvider);
    final controller = ref.read(wardrobeControllerProvider.notifier);

    ref.listen(wardrobeControllerProvider, (previous, next) {
      final failure = next is WardrobeData ? next.refreshFailure : null;
      final before = previous is WardrobeData ? previous.refreshFailure : null;
      if (failure == null || identical(failure, before)) return;
      AppSnackbar.show(
        context,
        message: messageForFailure(failure, l10n),
        tone: AlertTone.error,
      );
    });

    return AppScaffold(
      isScrollable: false,
      body: switch (wardrobe) {
        WardrobeLoading() => const AppLoader(),
        WardrobeError(:final failure) => AppErrorState(
          failure: failure,
          onRetryPressed: controller.retry,
        ),
        WardrobeEmpty() || WardrobeData() => WardrobeScrollView(
          state: wardrobe,
          title: session.isNewAccount
              ? l10n.welcomeName(session.user.firstName)
              : l10n.wardrobeTitle,
          onRefresh: controller.refresh,
          category: ref.watch(wardrobeCategoryFilterProvider),
          onCategorySelected: ref
              .read(wardrobeCategoryFilterProvider.notifier)
              .select,
          onScanPressed: () => context.goNamed(AppRoute.scan.name),
          onTagPressed: (card) => context.pushNamed(
            AppRoute.tag.name,
            pathParameters: {'id': card.id},
          ),
          onSharePressed: () => context.pushNamed(AppRoute.wardrobeShare.name),
          // A phone-only account has no email to confirm.
          banner: switch (session.user) {
            User(emailVerified: false, :final String email) =>
              _VerifyEmailSection(
                email: email,
                isJustJoined: session.isNewAccount,
              ),
            _ => null,
          },
        ),
      },
    );
  }
}

/// Connects the banner to its resend request.
class _VerifyEmailSection extends ConsumerWidget {
  const new({required this.email, required this.isJustJoined});

  final String email;
  final bool isJustJoined;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final request = ref.watch(verifyEmailControllerProvider);
    return VerifyEmailBanner(
      email: email,
      isJustJoined: isJustJoined,
      isSending: request is RequestSending,
      statusMessage: switch (request) {
        RequestDone(value: ResendOutcome.sent) => l10n.verificationResent,
        RequestDone(value: ResendOutcome.alreadyConfirmed) =>
          l10n.emailAlreadyConfirmed,
        RequestFailed(:final failure) => messageForFailure(failure, l10n),
        _ => null,
      },
      onResendPressed: ref.read(verifyEmailControllerProvider.notifier).resend,
    );
  }
}
