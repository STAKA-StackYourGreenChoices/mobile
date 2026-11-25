import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/error/result.dart';
import 'package:staka/core/network/dio_client.dart';
import 'package:staka/core/network/guard_api.dart';
import 'package:staka/features/manage/import/domain/models/picked_csv.dart';
import 'package:staka/features/manage/rewards/domain/brand_reward.dart';

part 'brand_rewards_repository.g.dart';

/// A brand's own rewards, their voucher codes and stats (V2-7 / V2-12),
/// under `/brand/:brandId/rewards`.
abstract interface class BrandRewardsRepository {
  Future<Result<List<BrandReward>>> fetchRewards(String brandId);
  Future<Result<BrandReward>> fetchReward(String brandId, String id);
  Future<Result<BrandReward>> createReward(
    String brandId,
    BrandRewardDraft draft,
  );
  Future<Result<BrandReward>> updateReward(
    String brandId,
    String id,
    BrandRewardDraft draft,
  );
  Future<Result<RewardStats>> fetchStats(String brandId, String id);

  /// A CSV of `code, expires_at?` rows.
  Future<Result<CodesUploadReport>> uploadCodes(
    String brandId,
    String id,
    PickedCsv file,
  );
}

@riverpod
BrandRewardsRepository brandRewardsRepository(Ref ref) =>
    ApiBrandRewardsRepository(ref.watch(dioProvider));

class ApiBrandRewardsRepository implements BrandRewardsRepository {
  const new(this._dio);

  final Dio _dio;

  static String _path(String brandId, [String? id]) {
    final base = '/brand/${Uri.encodeComponent(brandId)}/rewards';
    return id == null ? base : '$base/${Uri.encodeComponent(id)}';
  }

  @override
  Future<Result<List<BrandReward>>> fetchRewards(String brandId) =>
      guardApi(() async {
        final response = await _dio.get<Object>(_path(brandId));
        final items = switch (response.data) {
          final List<dynamic> list => list,
          {'items': final List<dynamic> list} => list,
          _ => const <dynamic>[],
        };
        return [
          for (final item in items)
            if (item case final Map<String, dynamic> json) rewardFromJson(json),
        ];
      });

  @override
  Future<Result<BrandReward>> fetchReward(String brandId, String id) =>
      guardApi(() async {
        final response = await _dio.get<Map<String, dynamic>>(
          _path(brandId, id),
        );
        return rewardFromJson(response.data!);
      });

  @override
  Future<Result<BrandReward>> createReward(
    String brandId,
    BrandRewardDraft draft,
  ) => guardApi(() async {
    final response = await _dio.post<Map<String, dynamic>>(
      _path(brandId),
      data: draft.toJson(),
    );
    return rewardFromJson(response.data!);
  });

  @override
  Future<Result<BrandReward>> updateReward(
    String brandId,
    String id,
    BrandRewardDraft draft,
  ) => guardApi(() async {
    final response = await _dio.patch<Map<String, dynamic>>(
      _path(brandId, id),
      data: draft.toJson(),
    );
    return rewardFromJson(response.data!);
  });

  @override
  Future<Result<RewardStats>> fetchStats(String brandId, String id) =>
      guardApi(() async {
        final response = await _dio.get<Map<String, dynamic>>(
          '${_path(brandId, id)}/stats',
        );
        final json = response.data!;
        return RewardStats(
          codesTotal: _int(json['codesTotal']),
          codesLeft: _int(json['codesLeft']),
          redeemed: _int(json['redeemed']),
        );
      });

  @override
  Future<Result<CodesUploadReport>> uploadCodes(
    String brandId,
    String id,
    PickedCsv file,
  ) => guardApi(() async {
    final form = FormData.fromMap({
      'file': MultipartFile.fromBytes(
        file.bytes,
        filename: file.name,
        contentType: DioMediaType('text', 'csv'),
      ),
    });
    final response = await _dio.post<Map<String, dynamic>>(
      '${_path(brandId, id)}/codes',
      data: form,
    );
    final json = response.data!;
    return CodesUploadReport(
      added: _int(json['added']),
      duplicates: _int(json['duplicates']),
    );
  });

  static int _int(Object? value) => (value as num?)?.toInt() ?? 0;

  /// `{id, title, valueText, pointsCost, description?, terms?, startsAt,
  /// endsAt?, active}`.
  static BrandReward rewardFromJson(Map<String, dynamic> json) => BrandReward(
    id: json['id'] as String,
    title: json['title'] as String? ?? '',
    valueText: json['valueText'] as String? ?? '',
    pointsCost: _int(json['pointsCost']),
    description: json['description'] as String?,
    terms: json['terms'] as String?,
    startsAt: switch (json['startsAt']) {
      final String at => DateTime.parse(at),
      _ => DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
    },
    endsAt: switch (json['endsAt']) {
      final String at => DateTime.parse(at),
      _ => null,
    },
    isActive: json['active'] as bool? ?? true,
  );
}
