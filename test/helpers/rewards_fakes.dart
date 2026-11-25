import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/features/rewards/data/rewards_repository.dart';
import 'package:staka/features/rewards/domain/reward.dart';

/// The rewards catalog (V2-7). Redeem results are answered in order (the
/// last one repeats); every redeem's key is recorded.
class FakeRewardsRepository implements RewardsRepository {
  new({
    this.catalog = const Ok([]),
    this._details,
    List<Result<Voucher>>? redeemResults,
    Map<int, Result<VoucherPage>> voucherPages = const {},
  }) : _redeemResults = redeemResults ?? [Ok(sampleVoucher)],
       _voucherPages = {...voucherPages};

  Result<List<Reward>> catalog;
  final Map<String, Result<Reward>>? _details;
  final List<Result<Voucher>> _redeemResults;
  final Map<int, Result<VoucherPage>> _voucherPages;

  final List<String> redeemKeys = [];
  final List<int> fetchedVoucherPages = [];
  int catalogFetches = 0;
  int detailFetches = 0;

  @override
  Future<Result<List<Reward>>> fetchRewards() async {
    catalogFetches++;
    return catalog;
  }

  @override
  Future<Result<Reward>> fetchReward(String id) async {
    detailFetches++;
    if (_details?[id] case final detail?) return detail;
    if (catalog case Ok(:final value)) {
      for (final reward in value) {
        if (reward.id == id) return Ok(reward);
      }
    }
    return const Err(NotFoundFailure([]));
  }

  @override
  Future<Result<Voucher>> redeem(
    Reward reward, {
    required String idempotencyKey,
  }) async {
    redeemKeys.add(idempotencyKey);
    final index = redeemKeys.length - 1;
    return _redeemResults[index < _redeemResults.length
        ? index
        : _redeemResults.length - 1];
  }

  @override
  Future<Result<VoucherPage>> fetchVouchers(int page) async {
    fetchedVoucherPages.add(page);
    return _voucherPages[page] ?? const Ok(VoucherPage(items: [], total: 0));
  }
}

final List<Reward> sampleRewards = [
  Reward(
    id: 'r1',
    title: '₹200 off at Terra Threads',
    valueText: '₹200 off',
    pointsCost: 500,
    brandName: 'Terra Threads',
    description: 'Off any order of ₹999 or more.',
    terms: 'One per order. Not with other offers. Online only.',
    endsAt: DateTime.utc(2027, 3, 31),
    canAfford: true,
  ),
  const Reward(
    id: 'r2',
    title: 'Free shipping for a year',
    valueText: 'Free shipping',
    pointsCost: 1500,
    brandName: 'Loom & Co',
  ),
  const Reward(
    id: 'r3',
    title: '15% off a jacket',
    valueText: '15% off',
    pointsCost: 800,
    brandName: 'Northwind Outdoor',
    inStock: false,
    canAfford: true,
  ),
];

final Voucher sampleVoucher = Voucher(
  id: 'rd1',
  code: 'TERRA-7KQ2-M9XA',
  rewardTitle: '₹200 off at Terra Threads',
  valueText: '₹200 off',
  brandName: 'Terra Threads',
  points: 500,
  redeemedAt: DateTime.utc(2026, 11, 24),
  expiresAt: DateTime.utc(2027, 2, 24),
);

final List<Voucher> sampleVouchers = [
  sampleVoucher,
  Voucher(
    id: 'rd0',
    code: 'LOOM-SHIP-22',
    rewardTitle: 'Free shipping for a year',
    valueText: 'Free shipping',
    brandName: 'Loom & Co',
    points: 1500,
    redeemedAt: DateTime.utc(2026, 10, 2),
  ),
];
