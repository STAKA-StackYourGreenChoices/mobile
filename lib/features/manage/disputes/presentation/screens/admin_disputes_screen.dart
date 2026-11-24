import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/app/routes.dart';
import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/models/ownership.dart';
import 'package:staka/features/manage/disputes/presentation/state/dispute_providers.dart';
import 'package:staka/features/manage/disputes/presentation/widgets/dispute_labels.dart';
import 'package:staka/features/manage/disputes/presentation/widgets/dispute_row.dart';
import 'package:staka/features/manage/shared/widgets/status_tabs.dart';
import 'package:staka/shared/widgets/feedback/app_error_state.dart';
import 'package:staka/shared/widgets/feedback/app_loader.dart';
import 'package:staka/shared/widgets/feedback/feedback_message.dart';
import 'package:staka/shared/widgets/layout/app_scaffold.dart';

/// The Admin tab's Disputes (V2-12): shoppers who asked STAKA to look
/// again at a brand's rejection, the longest wait first, then those
/// already settled.
class AdminDisputesScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<AdminDisputesScreen> createState() =>
      _AdminDisputesScreenState();
}

class _AdminDisputesScreenState extends ConsumerState<AdminDisputesScreen> {
  /// Kept while a dispute is open above this page.
  DisputeStatus _status = DisputeStatus.open;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final provider = disputesProvider(_status);
    final disputes = ref.watch(provider);
    return AppScaffold(
      showAppBar: true,
      isScrollable: false,
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(provider.future),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.xxs,
                children: [
                  Semantics(
                    header: true,
                    child: Text(
                      l10n.adminDisputes,
                      style: context.text.headingLarge,
                    ),
                  ),
                  Text(
                    l10n.adminDisputesDescription,
                    style: context.text.bodyLarge.copyWith(
                      color: context.colors.inkMuted,
                    ),
                  ),
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              sliver: SliverToBoxAdapter(
                child: StatusTabs<DisputeStatus>(
                  values: DisputeStatus.values,
                  labelOf: l10n.disputeTabLabel,
                  selected: _status,
                  onSelected: (status) => setState(() => _status = status),
                  semanticsLabel: l10n.disputeStatusLabel,
                  count: switch (disputes) {
                    AsyncData(value: Ok(:final value)) => value.length,
                    _ => null,
                  },
                ),
              ),
            ),
            ...switch (disputes) {
              AsyncData(value: Ok(:final value)) when value.isEmpty => [
                SliverToBoxAdapter(
                  child: FeedbackMessage(
                    icon: Icons.balance_outlined,
                    iconColor: context.colors.brandPrimary,
                    message: l10n.noDisputesInStatus(_status.name),
                  ),
                ),
              ],
              AsyncData(value: Ok(:final value)) => [
                DecoratedSliver(
                  decoration: BoxDecoration(
                    color: context.colors.surfaceRaised,
                    border: Border.all(color: context.colors.border),
                    borderRadius: AppRadius.allMd,
                  ),
                  sliver: SliverList.separated(
                    itemCount: value.length,
                    itemBuilder: (_, index) => DisputeRow(
                      key: ValueKey(value[index].id),
                      dispute: value[index],
                      onPressed: () => context.goNamed(
                        AppRoute.adminDispute.name,
                        pathParameters: {'id': value[index].id},
                      ),
                    ),
                    separatorBuilder: (_, _) =>
                        Divider(height: 1, color: context.colors.border),
                  ),
                ),
              ],
              AsyncData(value: Err(:final failure)) => [
                SliverToBoxAdapter(
                  child: AppErrorState(
                    failure: failure,
                    onRetryPressed: () => ref.invalidate(provider),
                  ),
                ),
              ],
              _ => const [
                SliverFillRemaining(hasScrollBody: false, child: AppLoader()),
              ],
            },
          ],
        ),
      ),
    );
  }
}
