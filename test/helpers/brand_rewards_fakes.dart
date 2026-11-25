import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/features/manage/import/domain/models/picked_csv.dart';
import 'package:staka/features/manage/rewards/data/brand_rewards_repository.dart';
import 'package:staka/features/manage/rewards/domain/brand_reward.dart';

/// A brand's rewards (V2-7). Saves add to or replace in the list; every
/// call is recorded.
class FakeBrandRewardsRepository implements BrandRewardsRepository {
  new({
    List<BrandReward>? rewards,
    this.listResult,
    this.saveFailure,
    this.stats = const Ok(sampleStats),
    this.uploadResult = const Ok(CodesUploadReport(added: 120, duplicates: 3)),
  }) : rewards = [...?rewards];

  final List<BrandReward> rewards;

  /// Answers the list instead of [rewards] when set.
  Result<List<BrandReward>>? listResult;
  Failure? saveFailure;
  Result<RewardStats> stats;
  Result<CodesUploadReport> uploadResult;

  final List<String> brandIds = [];
  final List<BrandRewardDraft> created = [];
  final List<(String, BrandRewardDraft)> updated = [];
  final List<PickedCsv> uploaded = [];

  @override
  Future<Result<List<BrandReward>>> fetchRewards(String brandId) async {
    brandIds.add(brandId);
    return listResult ?? Ok([...rewards]);
  }

  @override
  Future<Result<BrandReward>> fetchReward(String brandId, String id) async {
    for (final reward in rewards) {
      if (reward.id == id) return Ok(reward);
    }
    return const Err(NotFoundFailure([]));
  }

  @override
  Future<Result<BrandReward>> createReward(
    String brandId,
    BrandRewardDraft draft,
  ) async {
    created.add(draft);
    if (saveFailure case final failure?) return Err(failure);
    final reward = _fromDraft('new${created.length}', draft);
    rewards.add(reward);
    return Ok(reward);
  }

  @override
  Future<Result<BrandReward>> updateReward(
    String brandId,
    String id,
    BrandRewardDraft draft,
  ) async {
    updated.add((id, draft));
    if (saveFailure case final failure?) return Err(failure);
    final reward = _fromDraft(id, draft);
    final index = rewards.indexWhere((r) => r.id == id);
    if (index >= 0) rewards[index] = reward;
    return Ok(reward);
  }

  @override
  Future<Result<RewardStats>> fetchStats(String brandId, String id) async =>
      stats;

  @override
  Future<Result<CodesUploadReport>> uploadCodes(
    String brandId,
    String id,
    PickedCsv file,
  ) async {
    uploaded.add(file);
    return uploadResult;
  }

  static BrandReward _fromDraft(String id, BrandRewardDraft draft) =>
      BrandReward(
        id: id,
        title: draft.title,
        valueText: draft.valueText,
        pointsCost: draft.pointsCost,
        description: draft.description,
        terms: draft.terms,
        startsAt: draft.startsAt,
        endsAt: draft.endsAt,
        isActive: draft.isActive,
      );
}

/// The tests' "now": 25 Nov 2026.
final DateTime rewardsNow = DateTime(2026, 11, 25, 12);

final List<BrandReward> sampleBrandRewards = [
  BrandReward(
    id: 'r1',
    title: '₹200 off your next order',
    valueText: '₹200 off',
    pointsCost: 500,
    description: 'Off any order of ₹999 or more.',
    terms: 'One per order. Not with other offers. Online only.',
    startsAt: DateTime(2026, 11),
    endsAt: DateTime(2027, 3, 31, 23, 59),
  ),
  BrandReward(
    id: 'r2',
    title: 'Free shipping for a year',
    valueText: 'Free shipping',
    pointsCost: 1500,
    startsAt: DateTime(2026, 12),
  ),
  BrandReward(
    id: 'r3',
    title: 'Monsoon sale voucher',
    valueText: '10% off',
    pointsCost: 300,
    startsAt: DateTime(2026, 6),
    endsAt: DateTime(2026, 9, 30, 23, 59),
  ),
  BrandReward(
    id: 'r4',
    title: 'Tote bag with any order',
    valueText: 'Free tote',
    pointsCost: 250,
    startsAt: DateTime(2026, 10),
    isActive: false,
  ),
];

const RewardStats sampleStats = RewardStats(
  codesTotal: 200,
  codesLeft: 158,
  redeemed: 42,
);
