import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/error/result.dart';
import 'package:staka/core/state/request_state.dart';
import 'package:staka/features/admin/products/data/repositories/admin_product_repository_impl.dart';
import 'package:staka/features/admin/shared/admin_catalog_revision.dart';

part 'product_delete_controller.g.dart';

/// Deletes one product. The API refuses while shoppers hold its tags.
@riverpod
class ProductDeleteController extends _$ProductDeleteController {
  @override
  RequestState<void> build(String productId) => const RequestIdle();

  Future<void> delete() async {
    if (state is RequestSending) return;
    final repository = ref.read(adminProductRepositoryProvider);
    final revision = ref.read(adminCatalogRevisionProvider.notifier);
    state = const RequestSending();
    final result = await repository.deleteProduct(productId);
    if (result is Ok) revision.bump();
    if (!ref.mounted) return;
    state = switch (result) {
      Ok() => const RequestDone(null),
      Err(:final failure) => RequestFailed(failure),
    };
  }

  /// Closing the dialog forgets an error, like the website.
  void reset() {
    if (state is! RequestSending) state = const RequestIdle();
  }
}
