import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/models/brand_summary.dart';
import 'package:staka/core/sharing/share_target.dart';
import 'package:staka/features/manage/analytics/domain/analytics_report.dart';
import 'package:staka/features/manage/analytics/presentation/analytics_controller.dart';
import 'package:staka/features/manage/products/presentation/state/brand_options_provider.dart';
import 'package:staka/features/manage/products/presentation/widgets/brand_filter_sheet.dart';
import 'package:staka/features/manage/shared/manage_scope.dart';
import 'package:staka/shared/formatters/share_labels.dart';
import 'package:staka/shared/widgets/data_display/value_bar.dart';
import 'package:staka/shared/widgets/feedback/app_empty_state.dart';
import 'package:staka/shared/widgets/feedback/app_error_state.dart';
import 'package:staka/shared/widgets/feedback/app_loader.dart';
import 'package:staka/shared/widgets/layout/app_scaffold.dart';

/// Analytics (V2-5), used twice: Admin → Analytics (every brand, with a
/// brand filter) and Brand → Analytics (that brand's products). Funnel
/// from scan to view, shares and views per channel, top products.
class AnalyticsScreen extends ConsumerWidget {
  const new({required this.scope, super.key});

  final ManageScope scope;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final provider = analyticsControllerProvider(scope);
    final state = ref.watch(provider);
    final controller = ref.read(provider.notifier);
    // A brand sees its own products only: no brand filter to load.
    final brands = scope is AdminScope
        ? ref.watch(brandOptionsProvider(scope))
        : null;

    Future<void> pickBrand(List<BrandSummary> options) async {
      final pick = await showBrandFilterSheet(
        context,
        brands: options,
        selectedId: state.brandId,
      );
      if (pick != null) await controller.filterByBrand(pick.brandId);
    }

    return AppScaffold(
      showAppBar: true,
      isScrollable: false,
      body: AnalyticsView(
        state: state,
        description: scope is AdminScope
            ? l10n.analyticsAdminBody
            : l10n.analyticsBrandBody,
        brandLabel: switch (brands) {
          AsyncData(value: Ok(:final value)) =>
            value.where((b) => b.id == state.brandId).firstOrNull?.name ??
                l10n.allBrands,
          _ => null,
        },
        onBrandPressed: switch (brands) {
          AsyncData(value: Ok(:final value)) => () => pickBrand(value),
          _ => null,
        },
        showBrands: scope is AdminScope,
        onPeriodSelected: controller.selectPeriod,
        onRefresh: controller.refresh,
        onRetry: controller.retry,
      ),
    );
  }
}

class AnalyticsView extends StatelessWidget {
  const new({
    required this.state,
    required this.description,
    required this.onPeriodSelected,
    required this.onRefresh,
    required this.onRetry,
    this.brandLabel,
    this.onBrandPressed,
    this.showBrands = false,
    super.key,
  });

  final AnalyticsState state;
  final String description;
  final ValueChanged<AnalyticsPeriod> onPeriodSelected;
  final Future<void> Function() onRefresh;
  final VoidCallback onRetry;

  /// The brand filter's button (admins); hidden while brands can't load.
  final String? brandLabel;
  final VoidCallback? onBrandPressed;

  /// Top products name their brand (admins see every brand).
  final bool showBrands;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          Semantics(
            header: true,
            child: Text(l10n.analyticsTitle, style: context.text.headingLarge),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            description,
            style: context.text.bodyLarge.copyWith(color: colors.inkMuted),
          ),
          const SizedBox(height: AppSpacing.md),
          _PeriodChips(selected: state.period, onSelected: onPeriodSelected),
          if ((brandLabel, onBrandPressed) case (
            final label?,
            final onPressed?,
          ))
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: OutlinedButton.icon(
                  onPressed: onPressed,
                  icon: const Icon(Icons.filter_list_rounded),
                  label: Text(label),
                ),
              ),
            ),
          const SizedBox(height: AppSpacing.lg),
          switch (state.body) {
            AnalyticsLoading() => const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl),
              child: AppLoader(),
            ),
            AnalyticsFailed(:final failure) => AppErrorState(
              failure: failure,
              onRetryPressed: onRetry,
            ),
            AnalyticsLoaded(:final report) when report.isEmpty => AppEmptyState(
              icon: Icons.insights_outlined,
              title: l10n.analyticsEmptyTitle,
              message: l10n.analyticsEmptyBody,
            ),
            AnalyticsLoaded(:final report) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: AppSpacing.md,
              children: [
                _FunnelCard(report: report),
                _ChannelsCard(report: report),
                _TopProductsCard(
                  products: report.topProducts,
                  showBrands: showBrands,
                ),
              ],
            ),
          },
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}

class _PeriodChips extends StatelessWidget {
  const new({required this.selected, required this.onSelected});

  final AnalyticsPeriod selected;
  final ValueChanged<AnalyticsPeriod> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      container: true,
      label: context.l10n.analyticsPeriodLabel,
      child: Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.xs,
        children: [
          for (final period in AnalyticsPeriod.values)
            ChoiceChip(
              label: Text(context.l10n.analyticsDays(period.days)),
              selected: period == selected,
              onSelected: (_) => onSelected(period),
              selectedColor: colors.brandPrimary,
              checkmarkColor: colors.onBrandPrimary,
              labelStyle: period == selected
                  ? context.text.label.copyWith(color: colors.onBrandPrimary)
                  : null,
            ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const new({required this.title, required this.children, this.subtitle});

  final String title;
  final String? subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: AppSpacing.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.sm,
        children: [
          Semantics(
            header: true,
            child: Text(title, style: context.text.headingSmall),
          ),
          if (subtitle case final subtitle?)
            Text(
              subtitle,
              style: context.text.bodySmall.copyWith(
                color: context.colors.inkMuted,
              ),
            ),
          ...children,
        ],
      ),
    ),
  );
}

/// Scan → added → verified → shared → viewed, each bar against the scans,
/// with how many of the step before made it.
class _FunnelCard extends StatelessWidget {
  const new({required this.report});

  final AnalyticsReport report;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final number = NumberFormat.decimalPattern();
    const steps = FunnelStep.values;
    final most = max(1, steps.map(report.count).reduce(max));
    return _SectionCard(
      title: l10n.analyticsFunnelTitle,
      subtitle: l10n.analyticsFunnelBody,
      children: [
        for (final (index, step) in steps.indexed)
          ValueBar(
            label: funnelStepName(step, l10n),
            value: number.format(report.count(step)),
            share: report.count(step) / most,
            caption: switch (index) {
              0 => null,
              _ when report.count(steps[index - 1]) == 0 => null,
              _ => l10n.analyticsFromStepBefore(
                (report.count(step) * 100 / report.count(steps[index - 1]))
                    .round(),
              ),
            },
          ),
      ],
    );
  }
}

class _ChannelsCard extends StatelessWidget {
  const new({required this.report});

  final AnalyticsReport report;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final number = NumberFormat.decimalPattern();

    List<Widget> group(
      String title,
      Map<ShareChannel, int> byChannel,
      Color color,
    ) {
      final ranked = AnalyticsReport.ranked(byChannel);
      final most = ranked.isEmpty ? 1 : ranked.first.$2;
      return [
        Text(title, style: context.text.label.copyWith(color: colors.inkMuted)),
        if (ranked.isEmpty)
          Text(
            l10n.analyticsNoneInPeriod,
            style: context.text.bodySmall.copyWith(color: colors.inkMuted),
          )
        else
          for (final (channel, count) in ranked)
            ValueBar(
              label: channelName(channel, l10n),
              value: number.format(count),
              share: count / most,
              color: color,
            ),
      ];
    }

    return _SectionCard(
      title: l10n.analyticsChannelsTitle,
      children: [
        ...group(
          l10n.analyticsShares,
          report.sharesByChannel,
          colors.brandPrimary,
        ),
        const SizedBox(height: AppSpacing.xs),
        ...group(l10n.analyticsViews, report.viewsByChannel, colors.accent),
      ],
    );
  }
}

class _TopProductsCard extends StatelessWidget {
  const new({required this.products, required this.showBrands});

  final List<TopProduct> products;
  final bool showBrands;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final number = NumberFormat.decimalPattern();
    return _SectionCard(
      title: l10n.analyticsTopProductsTitle,
      children: [
        if (products.isEmpty)
          Text(
            l10n.analyticsNoneInPeriod,
            style: context.text.bodySmall.copyWith(color: colors.inkMuted),
          )
        else
          for (final (index, product) in products.indexed) ...[
            if (index > 0) const Divider(height: 1),
            MergeSemantics(
              child: Row(
                spacing: AppSpacing.sm,
                children: [
                  SizedBox(
                    width: AppSpacing.lg,
                    child: Text(
                      '${index + 1}',
                      style: context.text.label.copyWith(
                        color: colors.inkMuted,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.name, style: context.text.label),
                        if ((showBrands, product.brandName) case (
                          true,
                          final brand?,
                        ))
                          Text(
                            brand,
                            style: context.text.bodySmall.copyWith(
                              color: colors.inkMuted,
                            ),
                          ),
                        Text(
                          l10n.analyticsProductFigures(
                            number.format(product.scans),
                            number.format(product.verified),
                            number.format(product.shared),
                          ),
                          style: context.text.bodySmall.copyWith(
                            color: colors.inkMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
      ],
    );
  }
}

String funnelStepName(FunnelStep step, AppLocalizations l10n) => switch (step) {
  FunnelStep.scans => l10n.funnelScanned,
  FunnelStep.added => l10n.funnelAdded,
  FunnelStep.verified => l10n.funnelVerified,
  FunnelStep.shared => l10n.funnelShared,
  FunnelStep.viewed => l10n.funnelViewed,
};
