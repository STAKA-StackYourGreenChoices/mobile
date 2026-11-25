import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/rewards/points.dart';
import 'package:staka/features/manage/rewards/data/admin_rewards_repository.dart';
import 'package:staka/features/manage/rewards/domain/brand_reward.dart';
import 'package:staka/features/manage/users/data/admin_users_repository.dart';

import 'brand_rewards_fakes.dart';

/// Admin rewards and rules (V2-7 / V2-6). Switch-offs mark the reward off;
/// rule saves replace the rule. Records both.
class FakeAdminRewardsRepository implements AdminRewardsRepository {
  new({
    List<AdminReward>? rewards,
    List<RewardRule>? rules,
    this.switchOffFailure,
  }) : rewards = [...?rewards],
       rules = [...?rules];

  final List<AdminReward> rewards;
  final List<RewardRule> rules;
  Failure? switchOffFailure;
  final List<String> switchedOff = [];
  final List<RewardRule> savedRules = [];

  @override
  Future<Result<List<AdminReward>>> fetchRewards() async => Ok([...rewards]);

  @override
  Future<Result<void>> switchOff(String rewardId) async {
    switchedOff.add(rewardId);
    if (switchOffFailure case final failure?) return Err(failure);
    final index = rewards.indexWhere((r) => r.reward.id == rewardId);
    if (index >= 0) {
      final old = rewards[index];
      rewards[index] = AdminReward(
        reward: switchedOffCopy(old),
        brandName: old.brandName,
      );
    }
    return const Ok(null);
  }

  @override
  Future<Result<List<RewardRule>>> fetchRules() async => Ok([...rules]);

  @override
  Future<Result<RewardRule>> updateRule(RewardRule rule) async {
    savedRules.add(rule);
    final index = rules.indexWhere((r) => r.key == rule.key);
    if (index >= 0) rules[index] = rule;
    return Ok(rule);
  }
}

/// Users with points: [users] by id, [points] by id (default none).
class FakeAdminUsersRepository implements AdminUsersRepository {
  new({List<AdminUser>? users, Map<String, PointsPage>? points})
    : users = [...?users],
      points = {...?points};

  final List<AdminUser> users;
  final Map<String, PointsPage> points;
  final List<String> queries = [];
  final List<(String, int, String)> adjustments = [];

  @override
  Future<Result<AdminUserPage>> search(String query) async {
    queries.add(query);
    final q = query.toLowerCase();
    final found = [
      for (final user in users)
        if (user.name.toLowerCase().contains(q) ||
            (user.email ?? '').toLowerCase().contains(q))
          user,
    ];
    return Ok(AdminUserPage(items: found, total: found.length));
  }

  @override
  Future<Result<AdminUser>> fetchUser(String id) async {
    for (final user in users) {
      if (user.id == id) return Ok(user);
    }
    return const Err(NotFoundFailure([]));
  }

  @override
  Future<Result<PointsPage>> fetchPoints(String id, int page) async =>
      Ok(points[id] ?? const PointsPage(balance: 0, entries: [], total: 0));

  @override
  Future<Result<void>> adjustPoints(
    String id, {
    required int delta,
    required String note,
  }) async {
    adjustments.add((id, delta, note));
    final index = users.indexWhere((u) => u.id == id);
    if (index >= 0) {
      final old = users[index];
      users[index] = AdminUser(
        id: old.id,
        name: old.name,
        email: old.email,
        phone: old.phone,
        pointsBalance: old.pointsBalance + delta,
      );
    }
    return const Ok(null);
  }
}

/// [old]'s reward, switched off.
BrandReward switchedOffCopy(AdminReward old) => BrandReward(
  id: old.reward.id,
  title: old.reward.title,
  valueText: old.reward.valueText,
  pointsCost: old.reward.pointsCost,
  description: old.reward.description,
  terms: old.reward.terms,
  startsAt: old.reward.startsAt,
  endsAt: old.reward.endsAt,
  isActive: false,
);

final List<AdminReward> sampleAdminRewards = [
  for (final (index, reward) in sampleBrandRewards.indexed)
    AdminReward(
      reward: reward,
      brandName: index.isEven ? 'Terra Threads' : 'Loom & Co',
    ),
];

const List<RewardRule> sampleRewardRules = [
  RewardRule(key: 'PIECE_VERIFIED', points: 50),
  RewardRule(key: 'FIRST_SHARE', points: 20),
  RewardRule(key: 'WARDROBE_SHARED', points: 30),
  RewardRule(key: 'VIEWS_10', points: 5, dailyCap: 50),
  RewardRule(key: 'PHONE_VERIFIED', points: 10, isActive: false),
];

const List<AdminUser> sampleAdminUsers = [
  AdminUser(
    id: 'u1',
    name: 'Ada Lovelace',
    email: 'ada@example.com',
    phone: '+919876543210',
    pointsBalance: 1240,
  ),
  AdminUser(id: 'u2', name: 'Grace Hopper', pointsBalance: 80),
];
