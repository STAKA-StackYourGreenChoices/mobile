import 'package:flutter/foundation.dart';

import 'package:staka/core/sharing/share_target.dart';

/// The period the figures cover, ending today (V2-5).
enum AnalyticsPeriod {
  week(7),
  month(30),
  quarter(90);

  new(this.days);

  final int days;
}

/// From a scan to a view by someone else, in order. The API's names are
/// fixed: keep [apiName] as is.
enum FunnelStep {
  scans('scans'),
  added('added'),
  verified('verified'),
  shared('shared'),
  viewed('viewed');

  new(this.apiName);

  final String apiName;
}

/// One of the most active products in the period.
@immutable
class TopProduct {
  const new({
    required this.id,
    required this.name,
    required this.scans,
    required this.verified,
    required this.shared,
    this.brandName,
  });

  final String id;
  final String name;

  /// Shown to admins, who see every brand.
  final String? brandName;
  final int scans;
  final int verified;
  final int shared;
}

/// Everything the Analytics screen shows for one period.
@immutable
class AnalyticsReport {
  const new({
    required this.funnel,
    required this.sharesByChannel,
    required this.viewsByChannel,
    required this.topProducts,
  });

  final Map<FunnelStep, int> funnel;
  final Map<ShareChannel, int> sharesByChannel;
  final Map<ShareChannel, int> viewsByChannel;
  final List<TopProduct> topProducts;

  int count(FunnelStep step) => funnel[step] ?? 0;

  /// Nothing happened at all in the period.
  bool get isEmpty =>
      funnel.values.every((n) => n == 0) &&
      sharesByChannel.isEmpty &&
      viewsByChannel.isEmpty &&
      topProducts.isEmpty;

  /// Channels with any figure, most first.
  static List<(ShareChannel, int)> ranked(Map<ShareChannel, int> byChannel) => [
    for (final MapEntry(:key, :value) in byChannel.entries)
      if (value > 0) (key, value),
  ]..sort((a, b) => b.$2.compareTo(a.$2));
}
