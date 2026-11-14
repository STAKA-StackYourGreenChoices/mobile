import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/digital_card.dart';
import 'package:staka/features/products/domain/models/product_lookup.dart';

abstract interface class ProductRepository {
  /// The product for a scanned [gtin], and whether the shopper owns a tag
  /// for it. Invalid and unknown codes are results, not failures.
  Future<Result<ProductLookup>> lookUp(String gtin);

  /// Creates the shopper's tag (or returns the one they already have).
  Future<Result<DigitalCard>> addToWardrobe(String gtin);
}
