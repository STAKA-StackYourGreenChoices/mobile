import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/app/routes.dart';
import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/error/error_mapper.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/time/clock.dart';
import 'package:staka/features/manage/rewards/domain/brand_reward.dart';
import 'package:staka/features/manage/rewards/presentation/state/brand_rewards_controllers.dart';
import 'package:staka/features/manage/rewards/presentation/widgets/brand_reward_widgets.dart';
import 'package:staka/features/manage/shared/widgets/admin_not_found.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';
import 'package:staka/shared/widgets/feedback/app_error_state.dart';
import 'package:staka/shared/widgets/feedback/app_form_alert.dart';
import 'package:staka/shared/widgets/feedback/app_loader.dart';
import 'package:staka/shared/widgets/layout/app_scaffold.dart';

/// One of the brand's rewards: what shoppers see, its codes, and Upload
/// codes / Edit.
class BrandRewardScreen extends ConsumerWidget {
  const new({required this.brandId, required this.rewardId, super.key});

  final String brandId;
  final String rewardId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final detail = ref.watch(brandRewardProvider(brandId, rewardId)).value;
    final upload = codesUploadControllerProvider(brandId, rewardId);
    return AppScaffold(
      showAppBar: true,
      actions: [
        if (detail is Ok)
          IconButton(
            tooltip: l10n.editReward,
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => context.goNamed(
              AppRoute.brandRewardEdit.name,
              pathParameters: {'id': rewardId},
            ),
          ),
      ],
      body: switch (detail) {
        null => const Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl),
          child: AppLoader(),
        ),
        Err(failure: NotFoundFailure()) => AdminNotFound(
          backLabel: l10n.brandRewardsTitle,
          onBackPressed: () => context.goNamed(AppRoute.brandRewards.name),
        ),
        Err(:final failure) => AppErrorState(
          failure: failure,
          onRetryPressed: () =>
              ref.invalidate(brandRewardProvider(brandId, rewardId)),
        ),
        Ok(:final value) => BrandRewardView(
          reward: value,
          now: ref.watch(clockProvider)(),
          stats: ref.watch(brandRewardStatsProvider(brandId, rewardId)).value,
          upload: ref.watch(upload),
          onUploadPressed: () =>
              unawaited(ref.read(upload.notifier).pickAndUpload()),
        ),
      },
    );
  }
}

class BrandRewardView extends StatelessWidget {
  const new({
    required this.reward,
    required this.now,
    required this.upload,
    required this.onUploadPressed,
    this.stats,
    super.key,
  });

  final BrandReward reward;
  final DateTime now;
  final RewardStats? stats;
  final CodesUploadState upload;
  final VoidCallback onUploadPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final muted = context.text.bodySmall.copyWith(color: colors.inkMuted);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.xs,
      children: [
        Semantics(
          header: true,
          child: Text(reward.valueText, style: context.text.headingLarge),
        ),
        Text(reward.title, style: context.text.bodyLarge),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: BrandRewardStatusPill(reward: reward, now: now),
        ),
        Text(
          '${l10n.pointsCount(reward.pointsCost)} · '
          '${rewardRunText(reward, l10n)}',
          style: context.text.label.copyWith(color: colors.brandPrimary),
        ),
        if (reward.description case final description?
            when description.isNotEmpty)
          Text(description, style: context.text.bodyMedium),
        if (reward.terms case final terms? when terms.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(l10n.rewardTerms, style: context.text.label),
          Text(terms, style: muted),
        ],
        if (stats case final stats?) ...[
          const SizedBox(height: AppSpacing.sm),
          RewardStatsCard(stats: stats),
        ],
        const SizedBox(height: AppSpacing.md),
        Semantics(
          header: true,
          child: Text(l10n.uploadCodesTitle, style: context.text.headingSmall),
        ),
        Text(l10n.uploadCodesBody, style: muted),
        const SizedBox(height: AppSpacing.xxs),
        ...switch (upload) {
          CodesUploadDone(:final report) => [
            AppFormAlert(
              tone: AlertTone.success,
              message:
                  '${l10n.codesAdded(report.added)} '
                  '${l10n.codesDuplicates(report.duplicates)}',
            ),
          ],
          CodesUploadRejected(:final fileName, :final problem) => [
            AppFormAlert(
              tone: AlertTone.error,
              message: switch (problem) {
                CodesFileProblem.notCsv => l10n.notCsvFile(fileName),
                CodesFileProblem.empty => l10n.csvEmptyFile(fileName),
                CodesFileProblem.tooLarge => l10n.csvTooLarge,
              },
            ),
          ],
          CodesUploadFailed(:final failure) => [
            AppFormAlert(
              tone: AlertTone.error,
              message: messageForFailure(failure, l10n),
            ),
          ],
          _ => const <Widget>[],
        },
        AppButton(
          label: l10n.chooseCsvFile,
          icon: Icons.upload_file_outlined,
          variant: AppButtonVariant.secondary,
          isExpanded: true,
          isLoading: upload is CodesUploadSending,
          loadingLabel: switch (upload) {
            CodesUploadSending(:final fileName) => l10n.uploadingCodes(
              fileName,
            ),
            _ => null,
          },
          onPressed: onUploadPressed,
        ),
        Text(l10n.csvLimits, style: muted, textAlign: TextAlign.center),
      ],
    );
  }
}
