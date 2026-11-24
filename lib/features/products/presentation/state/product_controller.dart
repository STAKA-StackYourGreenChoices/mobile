import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:staka/core/analytics/event_tracker.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/features/products/data/repositories/product_repository_impl.dart';
import 'package:staka/features/products/domain/models/product_lookup.dart';
import 'package:staka/features/products/presentation/state/product_state.dart';

part 'product_controller.g.dart';

/// The product for one code. [isScan]: opened from the Scan tab, so the
/// lookup's answer is reported as a scan (V2-5); the tag's "Product
/// details" link opens the same screen without it.
@riverpod
class ProductController extends _$ProductController {
  @override
  ProductState build(String gtin, {bool isScan = false}) {
    unawaited(Future.microtask(_load));
    return const ProductLoading();
  }

  Future<void> retry() async {
    state = const ProductLoading();
    await _load();
  }

  Future<void> _load() async {
    // Read before the await: the provider may be gone after it.
    final tracker = isScan ? ref.read(eventTrackerProvider) : null;
    final result = await ref.read(productRepositoryProvider).lookUp(gtin);
    // A mistyped code (400) or a failed request is not a scan.
    if (tracker != null) {
      switch (result) {
        case Ok(value: ProductFound()):
          tracker.scanned(gtin, known: true);
        case Ok(value: UnknownProduct()):
          tracker.scanned(gtin, known: false);
        case Ok(value: InvalidBarcode()) || Err():
          break;
      }
    }
    if (!ref.mounted) return;
    state = switch (result) {
      Ok(:final value) => ProductReady(value),
      Err(:final failure) => ProductError(failure),
    };
  }
}
