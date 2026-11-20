import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/catalog/brands_api.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/brand_summary.dart';
import 'package:staka/core/network/dio_client.dart';
import 'package:staka/core/network/guard_api.dart';
import 'package:staka/features/admin/brands/data/datasources/brand_editor_remote_data_source.dart';
import 'package:staka/features/admin/brands/domain/models/brand_draft.dart';
import 'package:staka/features/admin/brands/domain/repositories/admin_brand_repository.dart';

part 'admin_brand_repository_impl.g.dart';

@riverpod
AdminBrandRepository adminBrandRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  return AdminBrandRepositoryImpl(
    BrandsApi(dio),
    BrandEditorRemoteDataSource(dio),
  );
}

class AdminBrandRepositoryImpl implements AdminBrandRepository {
  const new(this._brands, this._editor);

  final BrandsApi _brands;
  final BrandEditorRemoteDataSource _editor;

  @override
  Future<Result<List<BrandSummary>>> fetchBrands() => guardApi(() async {
    final brands = await _brands.fetchAll();
    return [for (final brand in brands) brand.toDomain()];
  });

  @override
  Future<Result<BrandSummary>> createBrand(BrandDraft draft) =>
      guardApi(() async => (await _editor.create(draft)).toDomain());

  @override
  Future<Result<BrandSummary>> updateBrand(String id, BrandDraft draft) =>
      guardApi(() async => (await _editor.update(id, draft)).toDomain());

  @override
  Future<Result<void>> deleteBrand(String id) =>
      guardApi(() => _editor.delete(id));
}
