import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/features/rewards/presentation/state/points_controllers.dart';
import 'package:staka/features/rewards/presentation/widgets/points_widgets.dart';
import 'package:staka/shared/widgets/feedback/app_empty_state.dart';
import 'package:staka/shared/widgets/feedback/app_error_state.dart';
import 'package:staka/shared/widgets/feedback/app_loader.dart';
import 'package:staka/shared/widgets/feedback/load_more_footer.dart';
import 'package:staka/shared/widgets/layout/app_scaffold.dart';

/// Every points entry (V2-6), newest first, more as the shopper scrolls.
class PointsHistoryScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pointsHistoryControllerProvider);
    final controller = ref.read(pointsHistoryControllerProvider.notifier);
    return AppScaffold(
      showAppBar: true,
      isScrollable: false,
      body: PointsHistoryScrollView(
        state: state,
        onRefresh: controller.refresh,
        onRetry: controller.retry,
        onLoadMore: controller.loadMore,
      ),
    );
  }
}

class PointsHistoryScrollView extends StatelessWidget {
  const new({
    required this.state,
    required this.onRefresh,
    required this.onRetry,
    required this.onLoadMore,
    super.key,
  });

  final PointsHistoryState state;
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
