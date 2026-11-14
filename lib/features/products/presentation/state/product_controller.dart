import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/error/result.dart';
import 'package:staka/features/products/data/repositories/product_repository_impl.dart';
import 'package:staka/features/products/presentation/state/product_state.dart';

part 'product_controller.g.dart';

/// The product for one scanned code.
@riverpod
class ProductController extends _$ProductController {
  @override
  ProductState build(String gtin) {
    unawaited(Future.microtask(_load));
    return const ProductLoading();
  }

  Future<void> retry() async {
    state = const ProductLoading();
    await _load();
  }

  Future<void> _load() async {
    final result = await ref.read(productRepositoryProvider).lookUp(gtin);
    if (!ref.mounted) return;
    state = switch (result) {
      Ok(:final value) => ProductReady(value),
      Err(:final failure) => ProductError(failure),
    };
  }
}
