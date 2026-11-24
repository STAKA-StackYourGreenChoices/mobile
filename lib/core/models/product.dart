import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:staka/core/models/brand.dart';
import 'package:staka/core/models/product_variant.dart';
import 'package:staka/core/models/sustainability_info.dart';

part 'product.freezed.dart';

/// A catalog product, identified on its label by [gtin] (stored as 14
/// digits; show it with `displayGtin`). [imageUrl] is already resolved to
/// an address this phone can load.
///
/// Since V2-2 a product is a style with [variants] (size, colour), each
/// with its own barcode; [gtin] and [sku] are the primary variant's.
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

    /// Hidden from shoppers by a STAKA admin (V2-12 moderation). Only
    /// admin lists send it.
    @Default(false) bool isHidden,

    /// What kind of piece it is (V2-2).
    @Default(ProductCategory.other) ProductCategory category,

    /// The brand's own code for the style (V2-2).
    String? styleCode,

    /// Every size/colour (V2-2); empty from an older API.
    @Default(<ProductVariant>[]) List<ProductVariant> variants,

    /// The variant whose barcode was scanned (product lookups only).
    ProductVariant? matchedVariant,
  }) = _Product;

  const new _();

  /// The barcode to show: the scanned variant's, else the primary one.
  String get shownGtin => matchedVariant?.gtin ?? gtin;
}
