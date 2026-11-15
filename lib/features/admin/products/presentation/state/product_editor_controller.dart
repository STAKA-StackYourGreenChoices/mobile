import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/features/admin/products/data/repositories/admin_product_repository_impl.dart';
import 'package:staka/features/admin/products/domain/models/editable_product.dart';
import 'package:staka/features/admin/products/presentation/state/product_editor_state.dart';

part 'product_editor_controller.g.dart';

/// The brands to choose from and, when editing, the product: what the
/// website's new and `[id]` pages load before showing the form.
@riverpod
class ProductEditorController extends _$ProductEditorController {
  static final _uuid = RegExp(r'^[0-9a-f-]{36}$', caseSensitive: false);

  @override
  ProductEditorState build(String? productId) {
    unawaited(Future.microtask(_load));
    return const EditorLoading();
  }

  Future<void> retry() async {
    state = const EditorLoading();
    await _load();
  }

  /// After a save: show what the API now holds (the website refreshes).
  void applySaved(EditableProduct product) {
    if (state case EditorReady(:final brands)) {
      state = EditorReady(brands: brands, product: product);
    }
  }

  Future<void> _load() async {
    final id = productId;
    if (id != null && !_uuid.hasMatch(id)) {
      state = const EditorNotFound();
      return;
    }
    final repository = ref.read(adminProductRepositoryProvider);
    final (brands, product) = await (
      repository.fetchBrands(),
      id == null
          ? Future<Result<EditableProduct>?>.value()
          : repository.fetchProduct(id),
    ).wait;
    if (!ref.mounted) return;
    state = switch ((brands, product)) {
      (_, Err(failure: NotFoundFailure())) => const EditorNotFound(),
      (Err(:final failure), _) ||
      (_, Err(:final failure)) => EditorFailed(failure),
      (Ok(value: final brands), Ok(value: final product)) => EditorReady(
        brands: brands,
        product: product,
      ),
      (Ok(value: final brands), null) => EditorReady(brands: brands),
    };
  }
}
