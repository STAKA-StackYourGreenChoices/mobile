import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/error/result.dart';
import 'package:staka/features/manage/brands/data/repositories/admin_brand_repository_impl.dart';
import 'package:staka/features/manage/brands/presentation/state/admin_brands_state.dart';
import 'package:staka/features/manage/shared/admin_catalog_revision.dart';
import 'package:staka/features/manage/shared/manage_scope.dart';

part 'admin_brands_controller.g.dart';

/// Every brand with its product count (`GET /brands`).
@riverpod
class AdminBrandsController extends _$AdminBrandsController {
  @override
  AdminBrandsState build() {
    // Brands or products changed: names and counts may have too.
    ref.listen(
      adminCatalogRevisionProvider(const AdminScope()),
      (_, _) => unawaited(refresh()),
    );
    unawaited(Future.microtask(_load));
    return const BrandsLoading();
  }

  Future<void> retry() async {
    state = const BrandsLoading();
    await _load();
  }

  /// Pull to refresh: the list stays while it reloads.
  Future<void> refresh() => _load(keepShowing: true);

  Future<void> _load({bool keepShowing = false}) async {
    final result = await ref.read(adminBrandRepositoryProvider).fetchBrands();
    if (!ref.mounted) return;
    state = switch ((result, state)) {
      (Ok(value: []), _) => const BrandsEmpty(),
      (Ok(:final value), _) => BrandsLoaded(value),
      (Err(:final failure), BrandsLoaded(:final brands)) when keepShowing =>
        BrandsLoaded(brands, refreshFailure: failure),
      (Err(:final failure), _) => BrandsFailed(failure),
    };
  }
}
