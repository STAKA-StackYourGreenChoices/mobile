import 'package:freezed_annotation/freezed_annotation.dart';

part 'brand_summary.freezed.dart';

/// A brand as the admin screens list it, with how many products it has.
@freezed
abstract class BrandSummary with _$BrandSummary {
  const factory({
    required String id,
    required String name,
    required int productCount,
    required DateTime createdAt,
    String? description,
    String? logoUrl,
  }) = _BrandSummary;
}
