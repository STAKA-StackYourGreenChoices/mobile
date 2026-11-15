import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/brand_summary.dart';
import 'package:staka/core/state/request_state.dart';
import 'package:staka/features/admin/brands/data/repositories/admin_brand_repository_impl.dart';
import 'package:staka/features/admin/brands/domain/models/brand_draft.dart';
import 'package:staka/features/admin/shared/admin_catalog_revision.dart';

part 'brand_save_controller.g.dart';

/// Adds a brand ([brandId] null) or saves changes to one.
@riverpod
class BrandSaveController extends _$BrandSaveController {
  @override
  RequestState<BrandSummary> build(String? brandId) => const RequestIdle();

  Future<void> submit(BrandDraft draft) async {
    if (state is RequestSending) return;
    final id = brandId;
    final repository = ref.read(adminBrandRepositoryProvider);
    final revision = ref.read(adminCatalogRevisionProvider.notifier);
    state = const RequestSending();
    final result = id == null
        ? await repository.createBrand(draft)
        : await repository.updateBrand(id, draft);
    if (result is Ok) revision.bump();
    if (!ref.mounted) return;
    state = switch (result) {
      Ok(:final value) => RequestDone(value),
      Err(:final failure) => RequestFailed(failure),
    };
  }
}
