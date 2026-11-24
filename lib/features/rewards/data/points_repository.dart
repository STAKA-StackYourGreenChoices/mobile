import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/error/result.dart';
import 'package:staka/core/network/dio_client.dart';
import 'package:staka/core/network/guard_api.dart';
import 'package:staka/features/rewards/domain/points.dart';

part 'points_repository.g.dart';

/// The shopper's points (V2-6).
abstract interface class PointsRepository {
  /// [page] starts at 1; every page carries the balance too.
  Future<Result<PointsPage>> fetchPoints(int page);

  /// The active ways to earn, for "How to earn".
  Future<Result<List<EarnRule>>> fetchEarnRules();
}

@riverpod
PointsRepository pointsRepository(Ref ref) =>
    ApiPointsRepository(ref.watch(dioProvider));

class ApiPointsRepository implements PointsRepository {
  const new(this._dio);

  final Dio _dio;

  static const pageSize = 20;

  @override
  Future<Result<PointsPage>> fetchPoints(int page) => guardApi(() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/me/points',
      queryParameters: {'page': page, 'limit': pageSize},
    );
    final body = response.data!;
    final expiring = body['expiringSoon'] as Map<String, dynamic>?;
    final entries = switch (body['entries']) {
      {'items': final List<dynamic> items} => items,
      final List<dynamic> items => items,
      _ => const <dynamic>[],
    };
    final on = expiring?['on'] as String?;
    return PointsPage(
      balance: _int(body['balance']),
      expiringPoints: _int(expiring?['points']),
      expiringOn: on == null ? null : DateTime.parse(on),
      entries: [
        for (final entry in entries) _entry(entry as Map<String, dynamic>),
      ],
      total: switch (body['entries']) {
        {'total': final num total} => total.toInt(),
        _ => entries.length,
      },
    );
  });

  @override
  Future<Result<List<EarnRule>>> fetchEarnRules() => guardApi(() async {
    final response = await _dio.get<List<dynamic>>('/rewards/rules');
    return [
      for (final rule in response.data ?? const <dynamic>[])
        if (rule case {'key': final String key, 'points': final num points}
            when PointsReason.fromApi(key) != PointsReason.other &&
                rule['active'] != false)
          EarnRule(
            reason: PointsReason.fromApi(key),
            points: points.toInt(),
            dailyCap: (rule['dailyCap'] as num?)?.toInt(),
          ),
    ];
  });

  static int _int(Object? value) => (value as num?)?.toInt() ?? 0;

  /// `{delta, reason, createdAt, expiresAt?, note?, card?: {product: {name}},
  /// reward?: {title}}`.
  static PointsEntry _entry(Map<String, dynamic> json) {
    final card = json['card'] as Map<String, dynamic>?;
    final product = card?['product'] as Map<String, dynamic>?;
    final reward = json['reward'] as Map<String, dynamic>?;
    final expiresAt = json['expiresAt'] as String?;
    return PointsEntry(
      delta: _int(json['delta']),
      reason: PointsReason.fromApi(json['reason'] as String?),
      at: DateTime.parse(json['createdAt'] as String),
      expiresAt: expiresAt == null ? null : DateTime.parse(expiresAt),
      productName: product?['name'] as String?,
      rewardTitle: reward?['title'] as String?,
      note: json['note'] as String?,
    );
  }
}
