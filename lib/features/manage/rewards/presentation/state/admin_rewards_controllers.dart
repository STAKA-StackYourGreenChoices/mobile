import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/error/result.dart';
import 'package:staka/core/state/request_state.dart';
import 'package:staka/features/manage/rewards/data/admin_rewards_repository.dart';
import 'package:staka/features/manage/rewards/presentation/state/brand_rewards_controllers.dart';

part 'admin_rewards_controllers.g.dart';

/// Every brand's rewards (Admin → Rewards). Reloads after a switch-off.
@riverpod
Future<Result<List<AdminReward>>> adminRewards(Ref ref) {
  ref.watch(brandRewardsRevisionProvider);
  return ref.read(adminRewardsRepositoryProvider).fetchRewards();
}

/// Switching one reward off.
@riverpod
class RewardSwitchOffController extends _$RewardSwitchOffController {
  @override
  RequestState<void> build(String rewardId) => const RequestIdle();

  Future<void> switchOff() async {
    if (state is RequestSending) return;
    final revision = ref.read(brandRewardsRevisionProvider.notifier);
    state = const RequestSending();
    final result = await ref
        .read(adminRewardsRepositoryProvider)
        .switchOff(rewardId);
    if (result is Ok) revision.bump();
    if (!ref.mounted) return;
    state = switch (result) {
      Ok() => const RequestDone(null),
      Err(:final failure) => RequestFailed(failure),
    };
  }
}

@Riverpod(keepAlive: true)
class RewardRulesRevision extends _$RewardRulesRevision {
  @override
  int build() => 0;

  void bump() => state++;
}

@riverpod
Future<Result<List<RewardRule>>> rewardRules(Ref ref) {
  ref.watch(rewardRulesRevisionProvider);
  return ref.read(adminRewardsRepositoryProvider).fetchRules();
}

/// Saving one rule from its sheet.
@riverpod
class RuleSaveController extends _$RuleSaveController {
  @override
  RequestState<RewardRule> build(String key) => const RequestIdle();

  Future<void> save(RewardRule rule) async {
    if (state is RequestSending) return;
    final revision = ref.read(rewardRulesRevisionProvider.notifier);
    state = const RequestSending();
    final result = await ref
        .read(adminRewardsRepositoryProvider)
        .updateRule(rule);
    if (result is Ok) revision.bump();
    if (!ref.mounted) return;
    state = switch (result) {
      Ok(:final value) => RequestDone(value),
      Err(:final failure) => RequestFailed(failure),
    };
  }
}
