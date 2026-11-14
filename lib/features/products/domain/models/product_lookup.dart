import 'package:staka/core/models/product.dart';

/// What looking up a scanned code found — the website's product page cases.
sealed class ProductLookup {
  const new();
}

/// A product, and the shopper's tag for it if they already have one.
final class ProductFound extends ProductLookup {
  const new(this.product, {this.ownedCardId});

  final Product product;
  final String? ownedCardId;
}

/// The code isn't a valid GTIN (API 400, e.g. a wrong check digit).
/// [message] is the API's explanation.
final class InvalidBarcode extends ProductLookup {
  const new(this.message);

  final String message;
}

/// A valid code no partner brand has added (API 404).
final class UnknownProduct extends ProductLookup {
  const new();
}
