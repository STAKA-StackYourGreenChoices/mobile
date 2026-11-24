import 'package:dio/dio.dart';

import 'package:staka/core/sharing/share_target.dart';
import 'package:staka/features/wardrobe/domain/models/impact.dart';

/// `GET /me/impact` and `GET /me/activity` (V2-5). Parsed by hand and
/// leniently: a missing number counts as 0, an unknown type as "other".
class ImpactRemoteDataSource {
  const new(this._dio);

  final Dio _dio;

  static const pageSize = 20;

  Future<Impact> fetchImpact() async {
    final response = await _dio.get<Map<String, dynamic>>('/me/impact');
    final json = response.data!;
    int count(String key) => (json[key] as num?)?.toInt() ?? 0;
    return Impact(
      pieces: count('pieces'),
      verifiedPieces: count('verifiedPieces'),
      sharedPieces: count('sharedPieces'),
      totalViews: count('totalViews'),
      carbonGramsOwned: count('carbonGramsOwned'),
      points: count('points'),
    );
  }

  Future<ActivityPage> fetchActivity(int page) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/me/activity',
      queryParameters: {'page': page, 'limit': pageSize},
    );
    final body = response.data!;
    final items = [
      for (final item in body['items'] as List<dynamic>)
        activityItemFromJson(item as Map<String, dynamic>),
    ];
    return ActivityPage(
      items: items,
      total: (body['total'] as num?)?.toInt() ?? items.length,
    );
  }
}

/// `{type, at, card?, points?, channel?}`; the card's product name is
/// read from `card.product.name`.
ActivityItem activityItemFromJson(Map<String, dynamic> json) {
  final card = json['card'] as Map<String, dynamic>?;
  final product = card?['product'] as Map<String, dynamic>?;
  final channel = json['channel'] as String?;
  return ActivityItem(
    type: ActivityType.fromApi(json['type'] as String?),
    at: DateTime.parse(json['at'] as String),
    cardId: card?['id'] as String?,
    productName: product?['name'] as String?,
    points: (json['points'] as num?)?.toInt(),
    channel: channel == null
        ? null
        : ShareChannel.values.where((c) => c.apiName == channel).firstOrNull ??
              ShareChannel.other,
  );
}
