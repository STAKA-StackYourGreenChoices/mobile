import 'package:staka/core/error/failure.dart';
import 'package:staka/features/products/domain/models/product_lookup.dart';

/// The product screen's states (guide §4.3): the "empty" cases — invalid
/// or unknown barcode — are lookups too.
sealed class ProductState {
  const new();
}

final class ProductLoading extends ProductState {
  const new();
}

final class ProductReady extends ProductState {
  const new(this.lookup);

  final ProductLookup lookup;
}

final class ProductError extends ProductState {
  const new(this.failure);

  final Failure failure;
}
