import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/error/result.dart';
import 'package:staka/core/network/dio_client.dart';
import 'package:staka/core/network/guard_api.dart';
import 'package:staka/features/rewards/domain/reward.dart';

part 'rewards_repository.g.dart';

/// The rewards catalog, redeeming and the shopper's vouchers (V2-7).
abstract interface class RewardsRepository {
  Future<Result<List<Reward>>> fetchRewards();
  Future<Result<Reward>> fetchReward(String id);

  /// Sends [idempotencyKey] as `Idempotency-Key`: the same key again
  /// answers the first result instead of taking points twice.
  Future<Result<Voucher>> redeem(
    Reward reward, {
    required String idempotencyKey,
  });

  /// [page] starts at 1.
  Future<Result<VoucherPage>> fetchVouchers(int page);
}

@riverpod
RewardsRepository rewardsRepository(Ref ref) =>
    ApiRewardsRepository(ref.watch(dioProvider));

class ApiRewardsRepository implements RewardsRepository {
  const new(this._dio);

  final Dio _dio;

  static const pageSize = 20;

  @override
  Future<Result<List<Reward>>> fetchRewards() => guardApi(() async {
    final response = await _dio.get<Object>('/rewards');
    return [
      for (final item in _items(response.data))
        if (item case final Map<String, dynamic> json) _reward(json),
    ];
  });

  @override
  Future<Result<Reward>> fetchReward(String id) => guardApi(() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/rewards/${Uri.encodeComponent(id)}',
    );
    return _reward(response.data!);
  });

  @override
  Future<Result<Voucher>> redeem(
    Reward reward, {
    required String idempotencyKey,
  }) => guardApi(() async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/rewards/${Uri.encodeComponent(reward.id)}/redeem',
      options: Options(headers: {'Idempotency-Key': idempotencyKey}),
    );
    final body = response.data!;
    final redemption = body['redemption'] as Map<String, dynamic>? ?? body;
    return Voucher(
      id: redemption['id'] as String? ?? '',
      code: body['code'] as String? ?? '',
      rewardTitle: reward.title,
      valueText: reward.valueText,
      brandName: reward.brandName,
      points: _int(redemption['points'] ?? reward.pointsCost),
      redeemedAt: _date(redemption['createdAt']) ?? DateTime.now(),
      expiresAt: _date(body['expiresAt']),
    );
  });

  @override
  Future<Result<VoucherPage>> fetchVouchers(int page) => guardApi(() async {
    final response = await _dio.get<Object>(
      '/me/redemptions',
      queryParameters: {'page': page, 'limit': pageSize},
    );
    final items = [
      for (final item in _items(response.data))
        if (item case final Map<String, dynamic> json) _voucher(json),
    ];
    return VoucherPage(
      items: items,
      total: switch (response.data) {
        {'total': final num total} => total.toInt(),
        _ => items.length,
      },
    );
  });

  static List<dynamic> _items(Object? body) => switch (body) {
    final List<dynamic> list => list,
    {'items': final List<dynamic> list} => list,
    _ => const [],
  };

  static int _int(Object? value) => (value as num?)?.toInt() ?? 0;

  static DateTime? _date(Object? value) =>
      value is String ? DateTime.parse(value) : null;

  /// `{id, title, valueText, pointsCost, description?, terms?, endsAt?,
  /// brand: {name, logoUrl?}, inStock, canAfford}`.
  static Reward _reward(Map<String, dynamic> json) {
    final brand = json['brand'] as Map<String, dynamic>?;
    return Reward(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      valueText: json['valueText'] as String? ?? '',
      pointsCost: _int(json['pointsCost']),
      brandName: brand?['name'] as String? ?? '',
      brandLogoUrl: brand?['logoUrl'] as String?,
      description: json['description'] as String?,
      terms: json['terms'] as String?,
      endsAt: _date(json['endsAt']),
      inStock: json['inStock'] as bool? ?? true,
      canAfford: json['canAfford'] as bool? ?? false,
    );
  }

  /// `{id, code, expiresAt?, points, createdAt, reward: {title, valueText,
  /// brand: {name}}}`.
  static Voucher _voucher(Map<String, dynamic> json) {
    final reward = json['reward'] as Map<String, dynamic>? ?? const {};
    final brand = reward['brand'] as Map<String, dynamic>?;
    return Voucher(
      id: json['id'] as String? ?? '',
      code: json['code'] as String? ?? '',
      rewardTitle: reward['title'] as String? ?? '',
      valueText: reward['valueText'] as String? ?? '',
      brandName: brand?['name'] as String? ?? '',
      points: _int(json['points']),
      redeemedAt: _date(json['createdAt']) ?? DateTime.now(),
      expiresAt: _date(json['expiresAt']),
    );
  }
}
