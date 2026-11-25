import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/rewards/points.dart';
import 'package:staka/features/rewards/data/points_repository.dart';

/// Points (V2-6). Pages are answered by number (missing pages: no points
/// at all); the earn rules fail unless given. Records the pages asked for.
class FakePointsRepository implements PointsRepository {
  new({
    Map<int, Result<PointsPage>> pages = const {},
    this.rules = const Err(NotFoundFailure([])),
  }) : _pages = {...pages};

  final Map<int, Result<PointsPage>> _pages;
  Result<List<EarnRule>> rules;
  final List<int> fetchedPages = [];

  @override
  Future<Result<PointsPage>> fetchPoints(int page) async {
    fetchedPages.add(page);
    return _pages[page] ??
        const Ok(PointsPage(balance: 0, entries: [], total: 0));
  }

  @override
  Future<Result<List<EarnRule>>> fetchEarnRules() async => rules;
}

const List<EarnRule> sampleRules = [
  EarnRule(reason: PointsReason.pieceVerified, points: 50),
  EarnRule(reason: PointsReason.firstShare, points: 20),
  EarnRule(reason: PointsReason.wardrobeShared, points: 30),
  EarnRule(reason: PointsReason.views, points: 5, dailyCap: 50),
  EarnRule(reason: PointsReason.phoneVerified, points: 10),
];

final List<PointsEntry> sampleEntries = [
  PointsEntry(
    delta: 50,
    reason: PointsReason.pieceVerified,
    at: DateTime.utc(2026, 11, 20),
    expiresAt: DateTime.utc(2027, 11, 20),
    productName: 'Organic Cotton Tee',
  ),
  PointsEntry(
    delta: 5,
    reason: PointsReason.views,
    at: DateTime.utc(2026, 11, 19),
    expiresAt: DateTime.utc(2027, 11, 19),
    productName: 'Organic Cotton Tee',
  ),
  PointsEntry(
    delta: -500,
    reason: PointsReason.redeemed,
    at: DateTime.utc(2026, 11, 12),
    rewardTitle: '₹200 off at Terra Threads',
  ),
  PointsEntry(
    delta: 25,
    reason: PointsReason.adjusted,
    at: DateTime.utc(2026, 11, 8),
    note: 'Sorry for the late check.',
  ),
  PointsEntry(
    delta: -20,
    reason: PointsReason.expired,
    at: DateTime.utc(2026, 11),
  ),
];

PointsPage samplePoints({List<PointsEntry>? entries, int? total}) => PointsPage(
  balance: 1240,
  expiringPoints: 120,
  expiringOn: DateTime.utc(2027, 1, 12),
  entries: entries ?? sampleEntries,
  total: total ?? (entries ?? sampleEntries).length,
);
