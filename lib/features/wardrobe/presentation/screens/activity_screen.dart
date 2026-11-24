import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/app/routes.dart';
import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/features/wardrobe/presentation/state/impact_controllers.dart';
import 'package:staka/features/wardrobe/presentation/widgets/activity_row.dart';
import 'package:staka/shared/widgets/feedback/app_empty_state.dart';
import 'package:staka/shared/widgets/feedback/app_error_state.dart';
import 'package:staka/shared/widgets/feedback/app_loader.dart';
import 'package:staka/shared/widgets/feedback/load_more_footer.dart';
import 'package:staka/shared/widgets/layout/app_scaffold.dart';

/// The activity timeline (V2-5), from the wardrobe's impact card: newest
/// first, more loading as the shopper scrolls.
class ActivityScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(activityControllerProvider);
    final controller = ref.read(activityControllerProvider.notifier);
    return AppScaffold(
      showAppBar: true,
      isScrollable: false,
      body: ActivityScrollView(
        state: state,
        onRefresh: controller.refresh,
        onRetry: controller.retry,
        onLoadMore: controller.loadMore,
        onTagPressed: (cardId) => context.pushNamed(
          AppRoute.tag.name,
          pathParameters: {'id': cardId},
        ),
      ),
    );
  }
}

class ActivityScrollView extends StatelessWidget {
  const new({
    required this.state,
    required this.onRefresh,
    required this.onRetry,
    required this.onLoadMore,
    required this.onTagPressed,
    super.key,
  });

  final ActivityState state;
  final Future<void> Function() onRefresh;
  final VoidCallback onRetry;
  final VoidCallback onLoadMore;
  final ValueChanged<String> onTagPressed;

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
        body is ActivityLoaded &&
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSpacing.xxs,
                  children: [
                    Semantics(
                      header: true,
                      child: Text(
                        l10n.activityTitle,
                        style: context.text.headingLarge,
                      ),
                    ),
                    Text(
                      l10n.activityBody,
                      style: context.text.bodyLarge.copyWith(
                        color: context.colors.inkMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ...switch (state) {
              ActivityLoading() => const [
                SliverFillRemaining(hasScrollBody: false, child: AppLoader()),
              ],
              ActivityFailed(:final failure) => [
                SliverToBoxAdapter(
                  child: AppErrorState(
                    failure: failure,
                    onRetryPressed: onRetry,
                  ),
                ),
              ],
              ActivityEmpty() => [
                SliverToBoxAdapter(
                  child: AppEmptyState(
                    icon: Icons.history_rounded,
                    title: l10n.activityEmptyTitle,
                    message: l10n.activityEmptyBody,
                  ),
                ),
              ],
              ActivityLoaded(
                :final items,
                :final isLoadingMore,
                :final loadMoreFailure,
              ) =>
                [
                  SliverList.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (_, index) {
                      final item = items[index];
                      return ActivityRow(
                        item: item,
                        onPressed: switch (item.cardId) {
                          final id? => () => onTagPressed(id),
                          null => null,
                        },
                      );
                    },
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
