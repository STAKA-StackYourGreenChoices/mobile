import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/error/result.dart';
import 'package:staka/core/state/request_state.dart';
import 'package:staka/features/manage/brands/data/repositories/admin_brand_repository_impl.dart';
import 'package:staka/features/manage/shared/admin_catalog_revision.dart';
import 'package:staka/features/manage/shared/manage_scope.dart';

part 'brand_delete_controller.g.dart';

/// Deletes one brand. The API refuses while it still has products.
@riverpod
class BrandDeleteController extends _$BrandDeleteController {
  @override
  RequestState<void> build(String brandId) => const RequestIdle();

  Future<void> delete() async {
    if (state is RequestSending) return;
    final repository = ref.read(adminBrandRepositoryProvider);
    final revision = ref.read(
      adminCatalogRevisionProvider(const AdminScope()).notifier,
    );
    state = const RequestSending();
    final result = await repository.deleteBrand(brandId);
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
