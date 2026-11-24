import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_variant.freezed.dart';

/// One size/colour of a product (V2-2), with its own barcode and SKU.
@freezed
abstract class ProductVariant with _$ProductVariant {
  const factory({
    required String id,
    required String gtin,
    required String sku,
    String? size,
    String? colour,
  }) = _ProductVariant;
}

/// What kind of piece a product is (V2-2). Products without one are
/// [other].
enum ProductCategory {
  tops('TOPS'),
  bottoms('BOTTOMS'),
  dresses('DRESSES'),
  outerwear('OUTERWEAR'),
  footwear('FOOTWEAR'),
  accessories('ACCESSORIES'),
  other('OTHER');

  new(this.apiName);

  final String apiName;

  /// An unknown or missing category counts as [other].
  static ProductCategory fromApi(String? value) => values.firstWhere(
    (category) => category.apiName == value,
    orElse: () => other,
  );
}
