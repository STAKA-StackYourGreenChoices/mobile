import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/sharing/share_actions.dart';
import 'package:staka/features/rewards/presentation/state/points_controllers.dart';
import 'package:staka/features/rewards/presentation/state/rewards_controllers.dart';
import 'package:staka/features/rewards/presentation/widgets/reward_widgets.dart';
import 'package:staka/shared/widgets/data_display/points_entry_row.dart';
import 'package:staka/shared/widgets/feedback/app_empty_state.dart';
import 'package:staka/shared/widgets/feedback/app_error_state.dart';
import 'package:staka/shared/widgets/feedback/app_loader.dart';
import 'package:staka/shared/widgets/feedback/app_snackbar.dart';
import 'package:staka/shared/widgets/feedback/load_more_footer.dart';
import 'package:staka/shared/widgets/layout/app_scaffold.dart';

/// The history: every points entry (V2-6) and My vouchers (V2-7), each
/// newest first, more as the shopper scrolls.
class PointsHistoryScreen extends StatelessWidget {
  const new({this.showVouchers = false, super.key});

  /// Opens on My vouchers (`/rewards/vouchers`, e.g. from a
  /// notification).
  final bool showVouchers;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DefaultTabController(
      length: 2,
      initialIndex: showVouchers ? 1 : 0,
      child: AppScaffold(
        showAppBar: true,
        isScrollable: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              header: true,
              child: Text(l10n.historyTitle, style: context.text.headingLarge),
            ),
            TabBar(
              tabs: [
                Tab(text: l10n.historyTabPoints),
                Tab(text: l10n.historyTabVouchers),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            const Expanded(
              child: TabBarView(children: [_PointsTab(), _VouchersTab()]),
            ),
          ],
        ),
      ),
    );
  }
}

class _PointsTab extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(pointsHistoryControllerProvider.notifier);
    return PointsHistoryScrollView(
      state: ref.watch(pointsHistoryControllerProvider),
      showTitle: false,
      onRefresh: controller.refresh,
      onRetry: controller.retry,
      onLoadMore: controller.loadMore,
    );
  }
}

class _VouchersTab extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(vouchersControllerProvider.notifier);
    return VouchersScrollView(
      state: ref.watch(vouchersControllerProvider),
      onRefresh: controller.refresh,
      onRetry: controller.retry,
      onLoadMore: controller.loadMore,
      onCopyPressed: (code) async {
        final l10n = context.l10n;
        await ref.read(shareActionsProvider).copy(code);
        if (context.mounted) {
          AppSnackbar.show(context, message: l10n.voucherCopied);
        }
      },
    );
  }
}

class PointsHistoryScrollView extends StatelessWidget {
  const new({
    required this.state,
    required this.onRefresh,
    required this.onRetry,
    required this.onLoadMore,
    this.showTitle = true,
    super.key,
  });

  final PointsHistoryState state;

  /// The heading; off under the history's tabs.
  final bool showTitle;
  final Future<void> Function() onRefresh;
  final VoidCallback onRetry;
  final VoidCallback onLoadMore;

  static const double _prefetchExtent = 64.0 * 5;

  bool _onScroll(Notification notification) {
    final metrics = switch (notification) {
      ScrollNotification(:final metrics) => metrics,
      ScrollMetricsNotification(:final metrics) => metrics,
      _ => null,
    };
    final body = state;
    if (metrics != null &&
        metrics.extentAfter < _prefetchExtent &&
        body is PointsHistoryLoaded &&
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
            if (showTitle)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: Semantics(
                    header: true,
                    child: Text(
                      l10n.pointsHistoryTitle,
                      style: context.text.headingLarge,
                    ),
                  ),
                ),
              ),
            ...switch (state) {
              PointsHistoryLoading() => const [
                SliverFillRemaining(hasScrollBody: false, child: AppLoader()),
              ],
              PointsHistoryFailed(:final failure) => [
                SliverToBoxAdapter(
                  child: AppErrorState(
                    failure: failure,
                    onRetryPressed: onRetry,
                  ),
                ),
              ],
              PointsHistoryEmpty() => [
                SliverToBoxAdapter(
                  child: AppEmptyState(
                    icon: Icons.stars_outlined,
                    title: l10n.pointsHistoryEmptyTitle,
                    message: l10n.pointsHistoryEmptyBody,
                  ),
                ),
              ],
              PointsHistoryLoaded(
                :final entries,
                :final isLoadingMore,
                :final loadMoreFailure,
              ) =>
                [
                  SliverList.separated(
                    itemCount: entries.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (_, index) =>
                        PointsEntryRow(entry: entries[index]),
                  ),
                  SliverToBoxAdapter(
                    child: LoadMoreFooter(
                      isLoading: isLoadingMore,
                      failure: loadMoreFailure,
                      onRetryPressed: onLoadMore,
                    ),
                  ),
                ],
            },
          ],
        ),
      ),
    );
  }
}

/// My vouchers: each code with Copy, newest first.
class VouchersScrollView extends StatelessWidget {
  const new({
    required this.state,
    required this.onRefresh,
    required this.onRetry,
    required this.onLoadMore,
    required this.onCopyPressed,
    super.key,
  });

  final VouchersState state;
  final Future<void> Function() onRefresh;
  final VoidCallback onRetry;
  final VoidCallback onLoadMore;
  final ValueChanged<String> onCopyPressed;

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
        body is VouchersLoaded &&
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
          slivers: switch (state) {
            VouchersLoading() => const [
              SliverFillRemaining(hasScrollBody: false, child: AppLoader()),
            ],
            VouchersFailed(:final failure) => [
              SliverToBoxAdapter(
                child: AppErrorState(failure: failure, onRetryPressed: onRetry),
              ),
            ],
            VouchersEmpty() => [
              SliverToBoxAdapter(
                child: AppEmptyState(
                  icon: Icons.local_activity_outlined,
                  title: l10n.vouchersEmptyTitle,
                  message: l10n.vouchersEmptyBody,
                ),
              ),
            ],
            VouchersLoaded(
              :final items,
              :final isLoadingMore,
              :final loadMoreFailure,
            ) =>
              [
                SliverList.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (_, index) => VoucherRow(
                    voucher: items[index],
                    onCopyPressed: () => onCopyPressed(items[index].code),
                  ),
                ),
                SliverToBoxAdapter(
                  child: LoadMoreFooter(
                    isLoading: isLoadingMore,
                    failure: loadMoreFailure,
                    onRetryPressed: onLoadMore,
                  ),
                ),
              ],
          },
        ),
      ),
    );
  }
}
