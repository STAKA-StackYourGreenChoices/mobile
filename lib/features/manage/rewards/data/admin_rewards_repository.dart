import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/error/result.dart';
import 'package:staka/core/network/dio_client.dart';
import 'package:staka/core/network/guard_api.dart';
import 'package:staka/core/rewards/points.dart';
import 'package:staka/features/manage/rewards/data/brand_rewards_repository.dart';
import 'package:staka/features/manage/rewards/domain/brand_reward.dart';

part 'admin_rewards_repository.g.dart';

/// One brand's reward as an admin sees it.
@immutable
class AdminReward {
  const new({required this.reward, required this.brandName});

  final BrandReward reward;
  final String brandName;
}

/// How many points one action earns (`RewardRule`, V2-6).
@immutable
class RewardRule {
  const new({
    required this.key,
    required this.points,
    this.dailyCap,
    this.isActive = true,
  });

  /// The API key (`PIECE_VERIFIED`…); unknown keys are shown as they are.
  final String key;
  final int points;
  final int? dailyCap;
  final bool isActive;

  PointsReason get reason => PointsReason.fromApi(key);
}

/// Admin moderation of rewards (V2-7) and the earn rules (V2-6).
abstract interface class AdminRewardsRepository {
  /// Every brand's rewards.
  Future<Result<List<AdminReward>>> fetchRewards();

  /// Takes a reward off the Rewards tab (`POST .../deactivate`).
  Future<Result<void>> switchOff(String rewardId);

  Future<Result<List<RewardRule>>> fetchRules();
  Future<Result<RewardRule>> updateRule(RewardRule rule);
}

@riverpod
AdminRewardsRepository adminRewardsRepository(Ref ref) =>
    ApiAdminRewardsRepository(ref.watch(dioProvider));

class ApiAdminRewardsRepository implements AdminRewardsRepository {
  const new(this._dio);

  final Dio _dio;

  static List<dynamic> _items(Object? body) => switch (body) {
    final List<dynamic> list => list,
    {'items': final List<dynamic> list} => list,
    _ => const [],
  };

  @override
  Future<Result<List<AdminReward>>> fetchRewards() => guardApi(() async {
    final response = await _dio.get<Object>('/admin/rewards');
    return [
      for (final item in _items(response.data))
        if (item case final Map<String, dynamic> json)
          AdminReward(
            reward: ApiBrandRewardsRepository.rewardFromJson(json),
            brandName: switch (json['brand']) {
              {'name': final String name} => name,
              _ => '',
            },
          ),
    ];
  });

  @override
  Future<Result<void>> switchOff(String rewardId) => guardApi(() async {
    await _dio.post<void>(
      '/admin/rewards/${Uri.encodeComponent(rewardId)}/deactivate',
    );
  });

  @override
  Future<Result<List<RewardRule>>> fetchRules() => guardApi(() async {
    final response = await _dio.get<Object>('/admin/reward-rules');
    return [
      for (final item in _items(response.data))
        if (item case final Map<String, dynamic> json) _rule(json),
    ];
  });

  @override
  Future<Result<RewardRule>> updateRule(RewardRule rule) => guardApi(() async {
    final response = await _dio.patch<Map<String, dynamic>>(
      '/admin/reward-rules',
      data: {
        'key': rule.key,
        'points': rule.points,
        'dailyCap': rule.dailyCap,
        'active': rule.isActive,
      },
    );
    return switch (response.data) {
      final Map<String, dynamic> json => _rule(json),
      _ => rule,
    };
  });

  static RewardRule _rule(Map<String, dynamic> json) => RewardRule(
    key: json['key'] as String? ?? '',
    points: (json['points'] as num?)?.toInt() ?? 0,
    dailyCap: (json['dailyCap'] as num?)?.toInt(),
    isActive: json['active'] as bool? ?? true,
  );
}
