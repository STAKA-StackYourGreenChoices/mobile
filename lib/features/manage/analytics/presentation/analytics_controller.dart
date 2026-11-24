import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/time/clock.dart';
import 'package:staka/features/manage/analytics/data/analytics_repository.dart';
import 'package:staka/features/manage/analytics/domain/analytics_report.dart';
import 'package:staka/features/manage/shared/manage_scope.dart';

part 'analytics_controller.g.dart';

sealed class AnalyticsBody {
  const new();
}

final class AnalyticsLoading extends AnalyticsBody {
  const new();
}

final class AnalyticsFailed extends AnalyticsBody {
  const new(this.failure);

  final Failure failure;
}

final class AnalyticsLoaded extends AnalyticsBody {
  const new(this.report);

  final AnalyticsReport report;
}

@immutable
class AnalyticsState {
  const new({
    this.period = AnalyticsPeriod.month,
    this.brandId,
    this.body = const AnalyticsLoading(),
  });

  final AnalyticsPeriod period;

  /// An admin's brand filter; null is every brand.
  final String? brandId;
  final AnalyticsBody body;
}

/// The Analytics screen (V2-5): 30 days by default; another period or
/// brand loads again, keeping the old figures out of sight meanwhile.
@riverpod
class AnalyticsController extends _$AnalyticsController {
  /// Bumped on every load, so answers to an older one are dropped.
  int _generation = 0;

  @override
  AnalyticsState build(ManageScope scope) {
    unawaited(Future.microtask(_load));
    return const AnalyticsState();
  }

  Future<void> selectPeriod(AnalyticsPeriod period) async {
    if (period == state.period) return;
    state = AnalyticsState(period: period, brandId: state.brandId);
    await _load();
  }

  Future<void> filterByBrand(String? brandId) async {
    if (brandId == state.brandId) return;
    state = AnalyticsState(period: state.period, brandId: brandId);
    await _load();
  }

  Future<void> retry() async {
    state = AnalyticsState(period: state.period, brandId: state.brandId);
    await _load();
  }

  /// Pull to refresh: the figures stay while the new ones load.
  Future<void> refresh() => _load();

  Future<void> _load() async {
    final generation = ++_generation;
    final today = ref.read(clockProvider)();
    final to = DateTime(today.year, today.month, today.day);
    final from = to.subtract(Duration(days: state.period.days - 1));
    final result = await ref
        .read(analyticsRepositoryProvider(scope))
        .fetchReport(
          from: from,
          to: to,
          brandId: scope is AdminScope ? state.brandId : null,
        );
    if (!ref.mounted || generation != _generation) return;
    state = AnalyticsState(
      period: state.period,
      brandId: state.brandId,
      body: switch (result) {
        Ok(:final value) => AnalyticsLoaded(value),
        Err(:final failure) => AnalyticsFailed(failure),
      },
    );
  }
}
