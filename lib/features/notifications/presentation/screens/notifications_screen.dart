import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/app/routes.dart';
import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/error/error_mapper.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/notifications/notification_models.dart';
import 'package:staka/features/brand_portal/presentation/state/current_brand.dart';
import 'package:staka/features/notifications/presentation/notification_destination.dart';
import 'package:staka/features/notifications/presentation/state/notifications_controller.dart';
import 'package:staka/features/notifications/presentation/widgets/notification_row.dart';
import 'package:staka/shared/widgets/feedback/app_empty_state.dart';
import 'package:staka/shared/widgets/feedback/app_error_state.dart';
import 'package:staka/shared/widgets/feedback/app_form_alert.dart';
import 'package:staka/shared/widgets/feedback/app_loader.dart';
import 'package:staka/shared/widgets/feedback/app_snackbar.dart';
import 'package:staka/shared/widgets/feedback/load_more_footer.dart';
import 'package:staka/shared/widgets/layout/app_scaffold.dart';

/// The notification inbox (V2-9), from the wardrobe's bell: newest first,
/// unread ones marked; tapping one marks it read and opens what it's about.
class NotificationsScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final state = ref.watch(notificationsControllerProvider);
    final controller = ref.read(notificationsControllerProvider.notifier);

    void open(AppNotification notification) {
      final destination = notificationDestination(notification);
      // Mark read without waiting: the tap should feel instant.
      unawaited(controller.open(notification));
      if (destination == null) return;
      openNotificationDestination(
        destination,
        router: GoRouter.of(context),
        selectBrand: ref.read(selectedBrandIdProvider.notifier).select,
      );
    }

    return AppScaffold(
      showAppBar: true,
      isScrollable: false,
      actions: [
        IconButton(
          tooltip: l10n.notificationSettingsTooltip,
          icon: const Icon(Icons.settings_outlined),
          onPressed: () => context.goNamed(AppRoute.notificationSettings.name),
        ),
      ],
      body: NotificationsScrollView(
        state: state,
        onRefresh: controller.refresh,
        onRetry: controller.retry,
        onLoadMore: controller.loadMore,
        onPressed: open,
        onMarkAllRead: () async {
          final failure = await controller.markAllRead();
          if (failure != null && context.mounted) {
            AppSnackbar.show(
              context,
              message: messageForFailure(failure, l10n),
              tone: AlertTone.error,
            );
          }
        },
      ),
    );
  }
}

class NotificationsScrollView extends StatelessWidget {
  const new({
    required this.state,
    required this.onRefresh,
    required this.onRetry,
    required this.onLoadMore,
    required this.onPressed,
    required this.onMarkAllRead,
    super.key,
  });

  final NotificationsState state;
  final Future<void> Function() onRefresh;
  final VoidCallback onRetry;
  final VoidCallback onLoadMore;
  final ValueChanged<AppNotification> onPressed;
  final VoidCallback onMarkAllRead;

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
        body is NotificationsLoaded &&
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
    final loaded = switch (state) {
      final NotificationsLoaded loaded => loaded,
      _ => null,
    };
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
                        l10n.notificationsTitle,
                        style: context.text.headingLarge,
                      ),
                    ),
                    Text(
                      switch (loaded) {
                        NotificationsLoaded(unreadCount: final n) when n > 0 =>
                          l10n.notificationsUnread(n),
                        _ => l10n.notificationsBody,
                      },
                      style: context.text.bodyLarge.copyWith(
                        color: context.colors.inkMuted,
                      ),
                    ),
                    if (loaded case NotificationsLoaded(
                      unreadCount: > 0,
                      :final isMarkingAll,
                    ))
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: TextButton.icon(
                          style: TextButton.styleFrom(padding: EdgeInsets.zero),
                          onPressed: isMarkingAll ? null : onMarkAllRead,
                          icon: const Icon(Icons.done_all_rounded),
                          label: Text(l10n.markAllRead),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            ...switch (state) {
              NotificationsLoading() => const [
                SliverFillRemaining(hasScrollBody: false, child: AppLoader()),
              ],
              NotificationsFailed(:final failure) => [
                SliverToBoxAdapter(
                  child: AppErrorState(
                    failure: failure,
                    onRetryPressed: onRetry,
                  ),
                ),
              ],
              NotificationsEmpty() => [
                SliverToBoxAdapter(
                  child: AppEmptyState(
                    icon: Icons.notifications_none_rounded,
                    title: l10n.notificationsEmptyTitle,
                    message: l10n.notificationsEmptyBody,
                  ),
                ),
              ],
              NotificationsLoaded(
                :final items,
                :final isLoadingMore,
                :final loadMoreFailure,
              ) =>
                [
                  SliverList.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (_, index) => NotificationRow(
                      notification: items[index],
                      onPressed: () => onPressed(items[index]),
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
          ],
        ),
      ),
    );
  }
}
