import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/sharing/share_target.dart';
import 'package:staka/features/manage/analytics/data/analytics_repository.dart';
import 'package:staka/features/manage/analytics/domain/analytics_report.dart';

/// Analytics (V2-5). Gives the scripted answers in turn, then the last one
/// again; with none, every load fails. Records every request.
class FakeAnalyticsRepository implements AnalyticsRepository {
  new({List<Result<AnalyticsReport>> answers = const []})
    : _answers = [...answers];

  final List<Result<AnalyticsReport>> _answers;
  final List<({DateTime from, DateTime to, String? brandId})> requests = [];

  @override
  Future<Result<AnalyticsReport>> fetchReport({
    required DateTime from,
    required DateTime to,
    String? brandId,
  }) async {
    requests.add((from: from, to: to, brandId: brandId));
    if (_answers.isEmpty) return const Err(NetworkFailure());
    return _answers.length == 1 ? _answers.single : _answers.removeAt(0);
  }
}

const AnalyticsReport sampleReport = AnalyticsReport(
  funnel: {
    FunnelStep.scans: 1240,
    FunnelStep.added: 610,
    FunnelStep.verified: 380,
    FunnelStep.shared: 145,
    FunnelStep.viewed: 92,
  },
  sharesByChannel: {
    ShareChannel.whatsapp: 80,
    ShareChannel.instagram: 41,
    ShareChannel.copy: 16,
    ShareChannel.qr: 8,
  },
  viewsByChannel: {
    ShareChannel.whatsapp: 54,
    ShareChannel.instagram: 30,
    ShareChannel.other: 8,
  },
  topProducts: [
    TopProduct(
      id: 'p1',
      name: 'Organic Cotton Tee',
      brandName: 'Terra Threads',
      scans: 420,
      verified: 150,
      shared: 61,
    ),
    TopProduct(
      id: 'p2',
      name: 'Recycled Denim Jeans',
      brandName: 'Loom & Leaf',
      scans: 310,
      verified: 92,
      shared: 30,
    ),
    TopProduct(
      id: 'p3',
      name: 'Hemp Overshirt',
      brandName: 'Terra Threads',
      scans: 128,
      verified: 40,
      shared: 12,
    ),
  ],
);

const AnalyticsReport emptyReport = AnalyticsReport(
  funnel: {},
  sharesByChannel: {},
  viewsByChannel: {},
  topProducts: [],
);
