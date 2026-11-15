@Tags(['live'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/brand_summary.dart';
import 'package:staka/features/admin/products/domain/models/product_page.dart';

import 'live_client.dart';

/// The admin product list against a running API, as the seeded admin (see
/// `liveAdminSkip`). Reads only; works with the seeded catalog.
void main() {
  test('list, search and filter by brand', () async {
    final admin = await signedInAdmin();

    final all = await admin.adminProducts.fetchProducts(
      const ProductFilter(),
      1,
    );
    final first = (all as Ok<ProductPage>).value;
    expect(first.total, greaterThan(0));
    expect(first.items.length, lessThanOrEqualTo(20));

    final tees = await admin.adminProducts.fetchProducts(
      const ProductFilter(search: 'tee'),
      1,
    );
    final teePage = (tees as Ok<ProductPage>).value;
    expect(teePage.total, inInclusiveRange(1, first.total));

    final brands = await admin.adminProducts.fetchBrands();
    final brand = (brands as Ok<List<BrandSummary>>).value.firstWhere(
      (brand) => brand.productCount > 0,
    );
    final byBrand = await admin.adminProducts.fetchProducts(
      ProductFilter(brandId: brand.id),
      1,
    );
    final brandPage = (byBrand as Ok<ProductPage>).value;
    expect(brandPage.total, brand.productCount);
    expect(brandPage.items.every((p) => p.brand.id == brand.id), isTrue);
  }, skip: liveAdminSkip);
}
