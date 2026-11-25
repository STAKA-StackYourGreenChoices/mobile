import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/state/request_state.dart';
import 'package:staka/features/manage/import/domain/models/picked_csv.dart';
import 'package:staka/features/manage/import/presentation/state/import_file_actions.dart';
import 'package:staka/features/manage/rewards/data/brand_rewards_repository.dart';
import 'package:staka/features/manage/rewards/domain/brand_reward.dart';

part 'brand_rewards_controllers.g.dart';

/// Bumped after a save or a codes upload, so lists, details and stats
/// reload.
@Riverpod(keepAlive: true)
class BrandRewardsRevision extends _$BrandRewardsRevision {
  @override
  int build() => 0;

  void bump() => state++;
}

@riverpod
Future<Result<List<BrandReward>>> brandRewards(Ref ref, String brandId) {
  ref.watch(brandRewardsRevisionProvider);
  return ref.read(brandRewardsRepositoryProvider).fetchRewards(brandId);
}

@riverpod
Future<Result<BrandReward>> brandReward(
  Ref ref,
  String brandId,
  String rewardId,
) {
  ref.watch(brandRewardsRevisionProvider);
  return ref
      .read(brandRewardsRepositoryProvider)
      .fetchReward(brandId, rewardId);
}

/// The codes behind a reward; null when they can't load (the screen then
/// leaves the numbers out).
@riverpod
Future<RewardStats?> brandRewardStats(
  Ref ref,
  String brandId,
  String rewardId,
) async {
  ref.watch(brandRewardsRevisionProvider);
  final result = await ref
      .read(brandRewardsRepositoryProvider)
      .fetchStats(brandId, rewardId);
  return switch (result) {
    Ok(:final value) => value,
    Err() => null,
  };
}

/// Creates a reward (no [rewardId]) or saves changes to one.
@riverpod
class BrandRewardSaveController extends _$BrandRewardSaveController {
  @override
  RequestState<BrandReward> build(String brandId, String? rewardId) =>
      const RequestIdle();

  Future<void> save(BrandRewardDraft draft) async {
    if (state is RequestSending) return;
    final repository = ref.read(brandRewardsRepositoryProvider);
    final revision = ref.read(brandRewardsRevisionProvider.notifier);
    state = const RequestSending();
    final result = switch (rewardId) {
      final id? => await repository.updateReward(brandId, id, draft),
      null => await repository.createReward(brandId, draft),
    };
    if (result is Ok) revision.bump();
    if (!ref.mounted) return;
    state = switch (result) {
      Ok(:final value) => RequestDone(value),
      Err(:final failure) => RequestFailed(failure),
    };
  }
}

/// Why a picked file wasn't sent.
enum CodesFileProblem { notCsv, empty, tooLarge }

sealed class CodesUploadState {
  const new();
}

final class CodesUploadIdle extends CodesUploadState {
  const new();
}

final class CodesUploadSending extends CodesUploadState {
  const new(this.fileName);

  final String fileName;
}

final class CodesUploadDone extends CodesUploadState {
  const new(this.fileName, this.report);

  final String fileName;
  final CodesUploadReport report;
}

final class CodesUploadRejected extends CodesUploadState {
  const new(this.fileName, this.problem);

  final String fileName;
  final CodesFileProblem problem;
}

final class CodesUploadFailed extends CodesUploadState {
  const new(this.fileName, this.failure);

  final String fileName;
  final Failure failure;
}

/// Pick a CSV of voucher codes and send it. The file is checked here first
/// (CSV, not empty, 2 MB at most), like the product import.
@riverpod
class CodesUploadController extends _$CodesUploadController {
  @override
  CodesUploadState build(String brandId, String rewardId) =>
      const CodesUploadIdle();

  Future<void> pickAndUpload() async {
    if (state is CodesUploadSending) return;
    final file = await ref.read(importFileActionsProvider).pickCsv();
    if (file == null || !ref.mounted) return;
    if (_problem(file) case final problem?) {
      state = CodesUploadRejected(file.name, problem);
      return;
    }
    final revision = ref.read(brandRewardsRevisionProvider.notifier);
    state = CodesUploadSending(file.name);
    final result = await ref
        .read(brandRewardsRepositoryProvider)
        .uploadCodes(brandId, rewardId, file);
    if (result is Ok) revision.bump();
    if (!ref.mounted) return;
    state = switch (result) {
      Ok(:final value) => CodesUploadDone(file.name, value),
      Err(:final failure) => CodesUploadFailed(file.name, failure),
    };
  }

  static CodesFileProblem? _problem(PickedCsv file) {
    if (!file.isCsv) return CodesFileProblem.notCsv;
    if (file.isEmpty) return CodesFileProblem.empty;
    if (file.isTooLarge) return CodesFileProblem.tooLarge;
    return null;
  }
}
