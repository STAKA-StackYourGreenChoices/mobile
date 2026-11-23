import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/state/request_state.dart';
import 'package:staka/features/manage/products/data/repositories/admin_product_repository_impl.dart';
import 'package:staka/features/manage/products/domain/models/editable_product.dart';
import 'package:staka/features/manage/products/domain/models/product_draft.dart';
import 'package:staka/features/manage/products/presentation/state/product_editor_controller.dart';
import 'package:staka/features/manage/shared/admin_catalog_revision.dart';
import 'package:staka/features/manage/shared/manage_scope.dart';

part 'product_save_controller.g.dart';

/// Adds a product ([productId] null) or saves changes to one.
@riverpod
class ProductSaveController extends _$ProductSaveController {
  @override
  RequestState<EditableProduct> build(ManageScope scope, String? productId) =>
      const RequestIdle();

  Future<void> submit(ProductDraft draft) async {
    if (state is RequestSending) return;
    final id = productId;
    // Read up front: this provider may be disposed while awaiting.
    final repository = ref.read(adminProductRepositoryProvider(scope));
    final revision = ref.read(adminCatalogRevisionProvider(scope).notifier);
    final editor = ref.read(
      productEditorControllerProvider(scope, id).notifier,
    );
    state = const RequestSending();

    final result = id == null
        ? await repository.createProduct(draft)
        : await repository.updateProduct(id, draft);
    if (result case Ok(:final value)) {
      revision.bump();
      if (id != null) editor.applySaved(value);
    }
    if (!ref.mounted) return;
    state = switch (result) {
      Ok(:final value) => RequestDone(value),
      Err(:final failure) => RequestFailed(failure),
    };
  }
}
