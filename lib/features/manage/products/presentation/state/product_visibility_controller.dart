import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/error/result.dart';
import 'package:staka/core/state/request_state.dart';
import 'package:staka/features/manage/products/data/repositories/admin_product_repository_impl.dart';
import 'package:staka/features/manage/shared/admin_catalog_revision.dart';
import 'package:staka/features/manage/shared/manage_scope.dart';

part 'product_visibility_controller.g.dart';

/// An admin hides one product from shoppers, or shows it again (V2-12).
/// The admin list reloads afterwards.
@riverpod
class ProductVisibilityController extends _$ProductVisibilityController {
  static const _scope = AdminScope();

  @override
  RequestState<void> build(String productId) => const RequestIdle();

  Future<void> change({required bool hidden}) async {
    if (state is RequestSending) return;
    final repository = ref.read(adminProductRepositoryProvider(_scope));
    final revision = ref.read(adminCatalogRevisionProvider(_scope).notifier);
    state = const RequestSending();
    final result = await repository.setHidden(productId, hidden: hidden);
    if (result is Ok) revision.bump();
    if (!ref.mounted) return;
    state = switch (result) {
      Ok() => const RequestDone(null),
      Err(:final failure) => RequestFailed(failure),
    };
  }

  /// Closing the dialog forgets an error.
  void reset() {
    if (state is! RequestSending) state = const RequestIdle();
  }
}
