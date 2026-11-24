import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/error/result.dart';
import 'package:staka/core/network/dio_client.dart';
import 'package:staka/core/network/guard_api.dart';
import 'package:staka/core/sharing/share_target.dart';
import 'package:staka/features/manage/analytics/domain/analytics_report.dart';
import 'package:staka/features/manage/shared/manage_scope.dart';

part 'analytics_repository.g.dart';

/// Funnel, channels and top products (V2-5): every brand's for admins
/// (`/admin/analytics/*`), a brand's own for its team
/// (`/brand/:brandId/analytics/*`).
abstract interface class AnalyticsRepository {
  /// [from] and [to] are whole days, both included. [brandId] narrows an
  /// admin's figures to one brand.
  Future<Result<AnalyticsReport>> fetchReport({
    required DateTime from,
    required DateTime to,
    String? brandId,
  });
}

@riverpod
AnalyticsRepository analyticsRepository(Ref ref, ManageScope scope) =>
    ApiAnalyticsRepository(ref.watch(dioProvider), scope);

class ApiAnalyticsRepository implements AnalyticsRepository {
  const new(this._dio, this._scope);

  final Dio _dio;
  final ManageScope _scope;

  static const topProductCount = 5;
  static final _day = DateFormat('yyyy-MM-dd');

  String _path(String name) => switch (_scope) {
    AdminScope() => '/admin/analytics/$name',
    BrandScope(:final brandId) =>
      '/brand/${Uri.encodeComponent(brandId)}/analytics/$name',
  };

  @override
  Future<Result<AnalyticsReport>> fetchReport({
    required DateTime from,
    required DateTime to,
    String? brandId,
  }) => guardApi(() async {
    final query = {
      'from': _day.format(from),
      'to': _day.format(to),
      'brandId': ?brandId,
    };
    final (funnel, channels, top) = await (
      _dio.get<Map<String, dynamic>>(_path('funnel'), queryParameters: query),
      _dio.get<Map<String, dynamic>>(_path('channels'), queryParameters: query),
      _dio.get<Object>(
        _path('top-products'),
        queryParameters: {...query, 'limit': topProductCount},
      ),
    ).wait;
    final channelBody = channels.data ?? const {};
    return AnalyticsReport(
      funnel: {
        for (final step in FunnelStep.values)
          step: _int(funnel.data?[step.apiName]),
      },
      sharesByChannel: _byChannel(channelBody['shares']),
      viewsByChannel: _byChannel(channelBody['views']),
      topProducts: [
        for (final item in switch (top.data) {
          final List<dynamic> list => list,
          {'items': final List<dynamic> list} => list,
          _ => const <dynamic>[],
        })
          ?_topProduct(item),
      ],
    );
  });

  static int _int(Object? value) => (value as num?)?.toInt() ?? 0;

  /// `{whatsapp: 12, ...}`; names the app doesn't know count as "other".
  static Map<ShareChannel, int> _byChannel(Object? json) {
    final counts = <ShareChannel, int>{};
    if (json is! Map<String, dynamic>) return counts;
    for (final MapEntry(:key, :value) in json.entries) {
      final channel =
          ShareChannel.values.where((c) => c.apiName == key).firstOrNull ??
          ShareChannel.other;
      counts[channel] = (counts[channel] ?? 0) + _int(value);
    }
    return counts;
  }

  /// `{product: {id, name, brand: {name}}, scans, verified, shared}`; a flat
  /// `{id, name, brandName, ...}` is read too.
  static TopProduct? _topProduct(Object? json) {
    if (json is! Map<String, dynamic>) return null;
    final product = json['product'] as Map<String, dynamic>? ?? json;
    final id = product['id'] as String?;
    if (id == null) return null;
    final brand = product['brand'] as Map<String, dynamic>?;
    return TopProduct(
      id: id,
      name: product['name'] as String? ?? '',
      brandName: brand?['name'] as String? ?? json['brandName'] as String?,
      scans: _int(json['scans']),
      verified: _int(json['verified']),
      shared: _int(json['shared']),
    );
  }
}
