import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/error/error_mapper.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/sharing/share_actions.dart';
import 'package:staka/features/rewards/domain/reward.dart';
import 'package:staka/features/rewards/presentation/state/points_controllers.dart';
import 'package:staka/features/rewards/presentation/state/rewards_controllers.dart';
import 'package:staka/features/rewards/presentation/widgets/redeem_confirm_dialog.dart';
import 'package:staka/features/rewards/presentation/widgets/reward_widgets.dart';
import 'package:staka/shared/formatters/date_format.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';
import 'package:staka/shared/widgets/feedback/app_empty_state.dart';
import 'package:staka/shared/widgets/feedback/app_error_state.dart';
import 'package:staka/shared/widgets/feedback/app_form_alert.dart';
import 'package:staka/shared/widgets/feedback/app_loader.dart';
import 'package:staka/shared/widgets/feedback/app_snackbar.dart';
import 'package:staka/shared/widgets/layout/app_scaffold.dart';

/// One voucher (V2-7): what it is, its terms, and Redeem → confirm → the
/// code to use at checkout.
class RewardDetailScreen extends ConsumerStatefulWidget {
  const new({required this.rewardId, super.key});

  final String rewardId;

  @override
  ConsumerState<RewardDetailScreen> createState() => _RewardDetailState();
}

class _RewardDetailState extends ConsumerState<RewardDetailScreen> {
  @override
  void initState() {
    super.initState();
    ref.listenManual(redeemControllerProvider(widget.rewardId), (_, next) {
      if (next is RedeemFailed && mounted) {
        final l10n = context.l10n;
        AppSnackbar.show(
          context,
          message: switch (next.problem) {
            RedeemProblem.notEnoughPoints => l10n.redeemNotEnough,
            RedeemProblem.outOfStock => l10n.redeemOutOfStock,
            RedeemProblem.ended => l10n.redeemEnded,
            RedeemProblem.other => messageForFailure(next.failure, l10n),
          },
          tone: AlertTone.error,
        );
      }
    });
  }

  Future<void> _redeem(Reward reward) async {
    if (!await showRedeemConfirmDialog(context, reward)) return;
    if (!mounted) return;
    await ref
        .read(redeemControllerProvider(widget.rewardId).notifier)
        .redeem(reward);
  }

  Future<void> _copy(String code) async {
    final l10n = context.l10n;
    await ref.read(shareActionsProvider).copy(code);
    if (mounted) AppSnackbar.show(context, message: l10n.voucherCopied);
  }

  @override
  Widget build(BuildContext context) {
    final id = widget.rewardId;
    final detail = ref.watch(rewardDetailProvider(id));
    final redeem = ref.watch(redeemControllerProvider(id));
    final balance = switch (ref.watch(pointsOverviewProvider)) {
      AsyncData(value: Ok(:final value)) => value.balance,
      _ => null,
    };
    return AppScaffold(
      showAppBar: true,
      // `.value`, so a reload after the redeem keeps the screen.
      body: switch (detail.value) {
        Ok(:final value) => RewardDetailView(
          reward: value,
          balance: balance,
          redeem: redeem,
          onRedeemPressed: () => unawaited(_redeem(value)),
          onCopyPressed: (code) => unawaited(_copy(code)),
        ),
        Err(failure: NotFoundFailure()) => AppEmptyState(
          icon: Icons.event_busy_outlined,
          title: context.l10n.rewardEndedTitle,
          message: context.l10n.rewardEndedBody,
        ),
        Err(:final failure) => AppErrorState(
          failure: failure,
          onRetryPressed: () => ref.invalidate(rewardDetailProvider(id)),
        ),
        null => const Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl),
          child: AppLoader(),
        ),
      },
    );
  }
}

class RewardDetailView extends StatelessWidget {
  const new({
    required this.reward,
    required this.redeem,
    required this.onRedeemPressed,
    required this.onCopyPressed,
    this.balance,
    super.key,
  });

  final Reward reward;
  final RedeemState redeem;
  final int? balance;
  final VoidCallback onRedeemPressed;
  final ValueChanged<String> onCopyPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final muted = context.text.bodySmall.copyWith(color: colors.inkMuted);
    final short = rewardShortfall(reward, balance);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.xs,
      children: [
        Row(
          spacing: AppSpacing.sm,
          children: [
            BrandLogo(
              name: reward.brandName,
              url: reward.brandLogoUrl,
              size: 48,
            ),
            Expanded(
              child: Text(
                l10n.rewardAt(reward.brandName),
                style: context.text.bodyLarge.copyWith(color: colors.inkMuted),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Semantics(
          header: true,
          child: Text(reward.valueText, style: context.text.headingLarge),
        ),
        if (reward.title != reward.valueText)
          Text(reward.title, style: context.text.bodyLarge),
        if (reward.description case final description?
            when description.isNotEmpty)
          Text(description, style: context.text.bodyMedium),
        Text(
          [
            l10n.pointsCount(reward.pointsCost),
            if (reward.endsAt case final ends?)
              l10n.rewardEndsOn(formatDate(ends)),
          ].join(' · '),
          style: context.text.label.copyWith(color: colors.brandPrimary),
        ),
        const SizedBox(height: AppSpacing.md),
        switch (redeem) {
          RedeemDone(:final voucher) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.xs,
            children: [
              Semantics(
                liveRegion: true,
                header: true,
                child: Text(
                  l10n.rewardDoneTitle,
                  style: context.text.headingSmall,
                ),
              ),
              Text(
                l10n.rewardDoneBody(reward.brandName),
                style: context.text.bodyMedium,
              ),
              VoucherCodeCard(
                voucher: voucher,
                onCopyPressed: () => onCopyPressed(voucher.code),
              ),
            ],
          ),
          _ => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.xs,
            children: [
              AppButton(
                label: l10n.rewardRedeem,
                icon: Icons.redeem_rounded,
                loadingLabel: l10n.rewardRedeeming,
                isLoading: redeem is RedeemSending,
                isExpanded: true,
                onPressed: reward.inStock && short == 0
                    ? onRedeemPressed
                    : null,
              ),
              if (!reward.inStock)
                Text(
                  l10n.rewardOutOfStock,
                  textAlign: TextAlign.center,
                  style: muted,
                )
              else if (short > 0)
                Text(
                  l10n.rewardNeedMore(short),
                  textAlign: TextAlign.center,
                  style: muted,
                ),
            ],
          ),
        },
        if (reward.terms case final terms? when terms.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          Semantics(
            header: true,
            child: Text(l10n.rewardTerms, style: context.text.headingSmall),
          ),
          Text(terms, style: muted),
        ],
      ],
    );
  }
}
