import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/api_models/product_mapper.dart';
import 'package:staka/core/catalog/brands_api.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/brand_summary.dart';
import 'package:staka/core/network/dio_client.dart';
import 'package:staka/core/network/guard_api.dart';
import 'package:staka/features/admin/products/data/datasources/admin_product_remote_data_source.dart';
import 'package:staka/features/admin/products/domain/models/product_page.dart';
import 'package:staka/features/admin/products/domain/repositories/admin_product_repository.dart';

part 'admin_product_repository_impl.g.dart';

@riverpod
AdminProductRepository adminProductRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  return AdminProductRepositoryImpl(
    AdminProductRemoteDataSource(dio),
    BrandsApi(dio),
  );
}

class AdminProductRepositoryImpl implements AdminProductRepository {
  const new(this._products, this._brands);

  final AdminProductRemoteDataSource _products;
  final BrandsApi _brands;

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
  Future<Result<List<BrandSummary>>> fetchBrands() => guardApi(() async {
    final brands = await _brands.fetchAll();
    return [for (final brand in brands) brand.toDomain()];
  });
}
