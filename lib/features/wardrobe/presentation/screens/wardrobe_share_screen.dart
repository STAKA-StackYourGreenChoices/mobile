import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/error/error_mapper.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/models/share_link.dart';
import 'package:staka/core/sharing/share_actions.dart';
import 'package:staka/core/utils/public_wardrobe_url.dart';
import 'package:staka/features/wardrobe/presentation/state/wardrobe_share_controller.dart';
import 'package:staka/shared/formatters/date_format.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';
import 'package:staka/shared/widgets/feedback/app_error_state.dart';
import 'package:staka/shared/widgets/feedback/app_form_alert.dart';
import 'package:staka/shared/widgets/feedback/app_loader.dart';
import 'package:staka/shared/widgets/feedback/app_snackbar.dart';
import 'package:staka/shared/widgets/layout/app_scaffold.dart';
import 'package:staka/shared/widgets/sharing/share_link_actions.dart';

/// Share the whole wardrobe (V2-3): one public link to every verified
/// piece, with a QR code to show someone in person.
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
          linkActions: _linkActions(context, ref, ready.share),
        ),
      },
    );
  }

  ShareLinkCallbacks _linkActions(
    BuildContext context,
    WidgetRef ref,
    ShareLink? share,
  ) {
    final l10n = context.l10n;
    final actions = ref.read(shareActionsProvider);
    final url = share == null ? null : publicWardrobeUrl(share.slug);
    return ShareLinkCallbacks(
      onCopy: () async {
        if (url == null) return;
        await actions.copy(url);
        if (context.mounted) {
          AppSnackbar.show(context, message: l10n.linkCopied);
        }
      },
      onShare: (origin) {
        if (url == null) return;
        unawaited(
          actions.shareLink(
            url: url,
            text: l10n.wardrobeShareText,
            subject: l10n.wardrobeShareSubject,
            origin: origin,
          ),
        );
      },
      onOpen: () async {
        if (url == null) return;
        final opened = await actions.open(url);
        if (!opened && context.mounted) {
          AppSnackbar.show(
            context,
            message: l10n.couldNotOpenLink,
            tone: AlertTone.error,
          );
        }
      },
      onStop: ref.read(wardrobeShareControllerProvider.notifier).stop,
    );
  }
}

/// The screen's content once the share is known: the create button, or
/// the link, its QR code and what can be done with it.
class WardrobeShareView extends StatelessWidget {
  const new({
    required this.share,
    required this.onCreatePressed,
    required this.linkActions,
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
  final ShareLinkCallbacks linkActions;

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
        switch (share) {
          final share? => _Shared(
            share: share,
            busy: busy,
            linkActions: linkActions,
          ),
          null => AppButton(
            label: l10n.createWardrobeLink,
            loadingLabel: l10n.creatingLink,
            icon: Icons.link_rounded,
            isLoading: busy == WardrobeShareBusy.creating,
            onPressed: onCreatePressed,
          ),
        },
        Text(l10n.wardrobeShareHideHint, style: muted),
      ],
    );
  }
}

class _Shared extends StatelessWidget {
  const new({
    required this.share,
    required this.busy,
    required this.linkActions,
  });

  final ShareLink share;
  final WardrobeShareBusy busy;
  final ShareLinkCallbacks linkActions;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final url = publicWardrobeUrl(share.slug);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.md,
      children: [
        Center(child: _QrCode(url: url)),
        Text(
          l10n.sharedSince(formatDate(share.createdAt)),
          style: context.text.bodyMedium.copyWith(
            color: context.colors.inkMuted,
          ),
        ),
        ShareLinkActions(
          url: url,
          callbacks: linkActions,
          stopTitle: l10n.stopSharingWardrobeTitle,
          stopBody: l10n.stopSharingWardrobeBody,
          isStopping: busy == WardrobeShareBusy.stopping,
        ),
      ],
    );
  }
}

/// Dark modules on white in both themes: phone cameras read that best.
class _QrCode extends StatelessWidget {
  const new({required this.url});

  final String url;

  static const _size = 200.0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      spacing: AppSpacing.xs,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppRadius.allMd,
            border: Border.all(color: context.colors.border),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            // The default modules are black squares.
            child: QrImageView(
              data: url,
              size: _size,
              padding: EdgeInsets.zero,
              semanticsLabel: l10n.wardrobeQrLabel,
            ),
          ),
        ),
        Text(
          l10n.wardrobeQrHint,
          style: context.text.bodySmall.copyWith(
            color: context.colors.inkMuted,
          ),
        ),
      ],
    );
  }
}
