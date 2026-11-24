import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/error/error_mapper.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/models/share_link.dart';
import 'package:staka/core/sharing/share_target.dart';
import 'package:staka/features/wardrobe/presentation/state/wardrobe_share_controller.dart';
import 'package:staka/shared/formatters/date_format.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';
import 'package:staka/shared/widgets/feedback/app_error_state.dart';
import 'package:staka/shared/widgets/feedback/app_form_alert.dart';
import 'package:staka/shared/widgets/feedback/app_loader.dart';
import 'package:staka/shared/widgets/feedback/app_snackbar.dart';
import 'package:staka/shared/widgets/layout/app_scaffold.dart';
import 'package:staka/shared/widgets/sharing/share_link_section.dart';

/// Share the whole wardrobe (V2-3): one public link to every verified
/// piece, with the same channels, images and QR code as a tag (V2-4).
class WardrobeShareScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final state = ref.watch(wardrobeShareControllerProvider);
    final controller = ref.read(wardrobeShareControllerProvider.notifier);

    ref.listen(wardrobeShareControllerProvider, (previous, next) {
      final outcome = next is WardrobeShareReady ? next.outcome : null;
      final before = previous is WardrobeShareReady ? previous.outcome : null;
      if (outcome == before) return;
      switch (outcome) {
        case WardrobeShareOutcome.created:
          AppSnackbar.show(context, message: l10n.wardrobeLinkReady);
        case WardrobeShareOutcome.stopped:
          AppSnackbar.show(context, message: l10n.sharingTurnedOff);
        case WardrobeShareOutcome.none || null:
          break;
      }
    });

    return AppScaffold(
      showAppBar: true,
      title: l10n.wardrobeShareTitle,
      isScrollable: state is WardrobeShareReady,
      body: switch (state) {
        WardrobeShareLoading() => const AppLoader(),
        WardrobeShareLoadFailed(:final failure) => AppErrorState(
          failure: failure,
          onRetryPressed: controller.retry,
        ),
        final WardrobeShareReady ready => WardrobeShareView(
          share: ready.share,
          busy: ready.busy,
          errorMessage: switch (ready.failure) {
            final failure? => messageForFailure(failure, l10n),
            null => null,
          },
          onCreatePressed: controller.create,
          linkSection: switch (ready.share) {
            final share? => ShareLinkSection(
              target: ShareTarget(kind: ShareKind.wardrobe, slug: share.slug),
              shareText: l10n.wardrobeShareText,
              shareSubject: l10n.wardrobeShareSubject,
              stopTitle: l10n.stopSharingWardrobeTitle,
              stopBody: l10n.stopSharingWardrobeBody,
              isStopping: ready.busy == WardrobeShareBusy.stopping,
              onStop: controller.stop,
            ),
            null => null,
          },
        ),
      },
    );
  }
}

/// The screen's content once the share is known: the create button, or
/// when it was shared and the [linkSection].
class WardrobeShareView extends StatelessWidget {
  const new({
    required this.share,
    required this.onCreatePressed,
    this.linkSection,
    this.busy = WardrobeShareBusy.none,
    this.errorMessage,
    super.key,
  });

  /// Null while the wardrobe isn't shared.
  final ShareLink? share;
  final WardrobeShareBusy busy;

  /// The API's reason for a refused create or stop.
  final String? errorMessage;
  final VoidCallback onCreatePressed;

  /// The link and its actions; shown while [share] is set.
  final Widget? linkSection;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final muted = context.text.bodyMedium.copyWith(
      color: context.colors.inkMuted,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.md,
      children: [
        Text(l10n.wardrobeShareBody, style: context.text.bodyLarge),
        if (errorMessage case final message?)
          AppFormAlert(message: message, tone: AlertTone.error),
        if (share case final share?) ...[
          Text(l10n.sharedSince(formatDate(share.createdAt)), style: muted),
          ?linkSection,
        ] else
          AppButton(
            label: l10n.createWardrobeLink,
            loadingLabel: l10n.creatingLink,
            icon: Icons.link_rounded,
            isLoading: busy == WardrobeShareBusy.creating,
            onPressed: onCreatePressed,
          ),
        Text(l10n.wardrobeShareHideHint, style: muted),
      ],
    );
  }
}
