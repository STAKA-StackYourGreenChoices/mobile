import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:staka/core/models/brand.dart';
import 'package:staka/core/models/sustainability_info.dart';

part 'product.freezed.dart';

/// A catalog product, identified on its label by [gtin] (stored as 14
/// digits; show it with `displayGtin`). [imageUrl] is already resolved to
/// an address this phone can load.
@freezed
abstract class Product with _$Product {
  const factory({
    required String id,
    required String gtin,
    required String sku,
    required String name,
    required Brand brand,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? description,
    String? imageUrl,
    SustainabilityInfo? sustainabilityInfo,
  }) = _Product;
}
