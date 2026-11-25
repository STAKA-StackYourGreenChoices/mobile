import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/error/result.dart';
import 'package:staka/core/network/dio_client.dart';
import 'package:staka/core/network/guard_api.dart';
import 'package:staka/core/rewards/points.dart';

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
    return pointsPageFromJson(response.data!);
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
}
