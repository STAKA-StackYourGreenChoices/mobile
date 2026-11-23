import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/features/manage/claims/domain/models/claim.dart';
import 'package:staka/features/manage/claims/presentation/state/claim_list_state.dart';
import 'package:staka/features/manage/claims/presentation/widgets/claim_row.dart';
import 'package:staka/features/manage/claims/presentation/widgets/claim_status_tabs.dart';
import 'package:staka/features/manage/shared/widgets/load_more_footer.dart';
import 'package:staka/shared/widgets/feedback/app_error_state.dart';
import 'package:staka/shared/widgets/feedback/app_loader.dart';
import 'package:staka/shared/widgets/feedback/feedback_message.dart';

/// The claims page as one scroll: heading, status tabs, then the claims of
/// the selected status, more loading when about five rows remain.
class ClaimsScrollView extends StatelessWidget {
  const new({
    required this.status,
    required this.state,
    required this.onStatusSelected,
    required this.onRefresh,
    required this.onRetry,
    required this.onLoadMore,
    required this.onClaimPressed,
    super.key,
  });

  final ClaimStatus status;
  final ClaimListState state;
  final ValueChanged<ClaimStatus> onStatusSelected;
  final Future<void> Function() onRefresh;
  final VoidCallback onRetry;
  final VoidCallback onLoadMore;
  final ValueChanged<Claim> onClaimPressed;

  static const double _prefetchExtent = 72.0 * 5;

  bool _onScroll(Notification notification) {
    final metrics = switch (notification) {
      ScrollNotification(:final metrics) => metrics,
      ScrollMetricsNotification(:final metrics) => metrics,
      _ => null,
    };
    final body = state;
    if (metrics != null &&
        metrics.extentAfter < _prefetchExtent &&
        body is ClaimListLoaded &&
        body.hasMore &&
        !body.isLoadingMore &&
        body.loadMoreFailure == null) {
      onLoadMore();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: NotificationListener<Notification>(
        onNotification: _onScroll,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Semantics(
                    header: true,
                    child: Text(
                      l10n.claimsTitle,
                      style: context.text.headingLarge,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    l10n.adminClaimsDescription,
                    style: context.text.bodyLarge.copyWith(
                      color: context.colors.inkMuted,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  ClaimStatusTabs(
                    selected: status,
                    count: switch (state) {
                      ClaimListLoaded(:final total) => total,
                      ClaimListEmpty() => 0,
                      _ => null,
                    },
                    onSelected: onStatusSelected,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
            ..._body(context),
          ],
        ),
      ),
    );
  }

  List<Widget> _body(BuildContext context) {
    final l10n = context.l10n;
    return switch (state) {
      ClaimListLoading() => const [
        SliverFillRemaining(hasScrollBody: false, child: AppLoader()),
      ],
      ClaimListFailed(:final failure) => [
        SliverToBoxAdapter(
          child: AppErrorState(failure: failure, onRetryPressed: onRetry),
        ),
      ],
      ClaimListEmpty() => [
        SliverToBoxAdapter(
          child: FeedbackMessage(
            icon: Icons.inbox_outlined,
            iconColor: context.colors.brandPrimary,
            title: Text(switch (status) {
              ClaimStatus.pending => l10n.nothingToReview,
              ClaimStatus.approved => l10n.noApprovedClaims,
              ClaimStatus.rejected => l10n.noRejectedClaims,
            }, style: context.text.headingMedium),
            message: status == ClaimStatus.pending
                ? l10n.nothingToReviewBody
                : l10n.decidedClaimsBody,
          ),
        ),
      ],
      final ClaimListLoaded loaded => [
        DecoratedSliver(
          decoration: BoxDecoration(
            color: context.colors.surfaceRaised,
            border: Border.all(color: context.colors.border),
            borderRadius: AppRadius.allMd,
          ),
          sliver: SliverList.separated(
            itemCount: loaded.items.length,
            itemBuilder: (_, index) => ClaimRow(
              key: ValueKey(loaded.items[index].id),
              claim: loaded.items[index],
              onPressed: () => onClaimPressed(loaded.items[index]),
            ),
            separatorBuilder: (_, _) =>
                Divider(height: 1, color: context.colors.border),
          ),
        ),
        SliverToBoxAdapter(
          child: LoadMoreFooter(
            isLoading: loaded.isLoadingMore,
            failure: loaded.loadMoreFailure,
            onRetryPressed: onLoadMore,
          ),
        ),
      ],
    };
  }
}
