import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/api_models/product_dto.dart';
import 'package:staka/core/api_models/product_mapper.dart';
import 'package:staka/core/api_models/product_variant_dto.dart';
import 'package:staka/core/api_models/sku_alias_dto.dart';
import 'package:staka/core/catalog/brands_api.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/brand_summary.dart';
import 'package:staka/core/network/dio_client.dart';
import 'package:staka/core/network/guard_api.dart';
import 'package:staka/features/manage/products/data/datasources/admin_product_remote_data_source.dart';
import 'package:staka/features/manage/products/data/datasources/product_editor_remote_data_source.dart';
import 'package:staka/features/manage/products/domain/models/editable_product.dart';
import 'package:staka/features/manage/products/domain/models/product_draft.dart';
import 'package:staka/features/manage/products/domain/models/product_page.dart';
import 'package:staka/features/manage/products/domain/models/sku_alias.dart';
import 'package:staka/features/manage/products/domain/repositories/admin_product_repository.dart';
import 'package:staka/features/manage/shared/manage_scope.dart';

part 'admin_product_repository_impl.g.dart';

/// The catalog as [scope] sees it: every brand's for an admin, one brand's
/// for its team.
@riverpod
AdminProductRepository adminProductRepository(Ref ref, ManageScope scope) {
  final dio = ref.watch(dioProvider);
  return AdminProductRepositoryImpl(
    AdminProductRemoteDataSource(dio, scope),
    BrandsApi(dio),
    ProductEditorRemoteDataSource(dio, scope),
  );
}

class AdminProductRepositoryImpl implements AdminProductRepository {
  const new(this._products, this._brands, this._editor);

  final AdminProductRemoteDataSource _products;
  final BrandsApi _brands;
  final ProductEditorRemoteDataSource _editor;

  @override
  Future<Result<ProductPage>> fetchProducts(ProductFilter filter, int page) =>
      guardApi(() async {
        final body = await _products.fetch(
          page: page,
          search: filter.search,
          brandId: filter.brandId,
        );
        return ProductPage(
          items: [for (final dto in body.items) dto.toDomain()],
          total: body.total,
          page: body.page,
          limit: body.limit,
        );
      });

  @override
  Future<Result<void>> setHidden(String id, {required bool hidden}) =>
      guardApi(() => _editor.setHidden(id, hidden: hidden));

  @override
  Future<Result<List<BrandSummary>>> fetchBrands() => guardApi(() async {
    final brands = await _brands.fetchAll();
    return [for (final brand in brands) brand.toDomain()];
  });

  @override
  Future<Result<EditableProduct>> fetchProduct(String id) =>
      guardApi(() async => (await _editor.fetch(id)).toEditable());

  @override
  Future<Result<EditableProduct>> createProduct(ProductDraft draft) =>
      guardApi(() async => (await _editor.create(draft)).toEditable());

  @override
  Future<Result<EditableProduct>> updateProduct(
    String id,
    ProductDraft draft,
  ) => guardApi(() async => (await _editor.update(id, draft)).toEditable());

  @override
  Future<Result<void>> deleteProduct(String id) =>
      guardApi(() => _editor.delete(id));

  @override
  Future<Result<void>> addAlias(
    String productId,
    String variantId,
    SkuAlias alias,
  ) => guardApi(() => _editor.addAlias(productId, variantId, alias));

  @override
  Future<Result<void>> removeAlias(
    String productId,
    String variantId,
    SkuAlias alias,
  ) => guardApi(() => _editor.removeAlias(productId, variantId, alias));
}

extension on ProductDto {
  EditableProduct toEditable() => EditableProduct(
    product: toDomain(),
    storedImageUrl: imageUrl,
    aliases: {
      for (final variant in variants ?? const <ProductVariantDto>[])
        variant.id: [
          for (final alias in variant.aliases ?? const <SkuAliasDto>[])
            SkuAlias(source: alias.source, code: alias.code),
        ],
    },
  );
}
