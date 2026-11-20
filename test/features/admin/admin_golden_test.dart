@Tags(['golden'])
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/sustainability_info.dart';
import 'package:staka/features/admin/brands/data/repositories/admin_brand_repository_impl.dart';
import 'package:staka/features/admin/brands/presentation/screens/admin_brands_screen.dart';
import 'package:staka/features/admin/hub/presentation/screens/admin_home_screen.dart';
import 'package:staka/features/admin/products/data/repositories/admin_product_repository_impl.dart';
import 'package:staka/features/admin/products/presentation/screens/admin_product_form_screen.dart';
import 'package:staka/features/admin/products/presentation/screens/admin_products_screen.dart';

import '../../helpers/admin_brand_fakes.dart';
import '../../helpers/admin_product_fakes.dart';
import '../../helpers/golden.dart';
import '../../helpers/product_fakes.dart';
import '../../helpers/pump_app.dart';

Widget _scoped(FakeAdminProductRepository repository, Widget screen) =>
    ProviderScope(
      overrides: [adminProductRepositoryProvider.overrideWithValue(repository)],
      child: screen,
    );

Widget _products(FakeAdminProductRepository repository) =>
    _scoped(repository, const AdminProductsScreen());

Widget _brands(FakeAdminBrandRepository repository) => ProviderScope(
  overrides: [adminBrandRepositoryProvider.overrideWithValue(repository)],
  child: const AdminBrandsScreen(),
);

const _id = '11111111-2222-4333-8444-555555555555';

void main() {
  setUpAll(loadAppFonts);

  final list = FakeAdminProductRepository(
    pages: (_) => Ok(
      pageOf([
        productNamed('Organic Cotton Tee'),
        productNamed(
          'Linen Overshirt',
          gtin: '08901234500026',
          info: const SustainabilityInfo(
            carbonScoreGrams: 3400,
            recyclabilityPercent: 55,
            isVerified: false,
          ),
        ),
        productNamed(
          'Recycled Denim Jeans with a name long enough to be cut short',
          gtin: '08901234500033',
          info: null,
        ),
      ], total: 3),
    ),
    brands: Ok([brandSummary('b1', 'Terra Threads')]),
  );

  final editing = FakeAdminProductRepository(
    brands: Ok([brandSummary('b1', 'Terra Threads')]),
    products: {
      _id: editable(productNamed('Organic Cotton Tee').copyWith(id: _id)),
    },
  );
  final adding = FakeAdminProductRepository(
    brands: Ok([brandSummary('b1', 'Terra Threads')]),
  );

  final brandList = FakeAdminBrandRepository(
    lists: [
      Ok([
        brandSummary(
          'b1',
          'Terra Threads',
        ).copyWith(description: 'Organic cotton basics, made in Portugal.'),
        brandSummary('b2', 'Nordic Loom').copyWith(productCount: 1),
        brandSummary('b3', 'Field & Fold').copyWith(productCount: 0),
      ]),
    ],
  );

  final cases = <String, (Widget Function(), double)>{
    'brands': (() => _brands(brandList), 900),
    'brands_empty': (() => _brands(FakeAdminBrandRepository()), 760),
    'hub': (() => const AdminHomeScreen(), 760),
    'products': (() => _products(list), 760),
    'products_empty': (() => _products(FakeAdminProductRepository()), 760),
    'product_new': (
      () => _scoped(adding, const AdminProductFormScreen()),
      2300,
    ),
    'product_edit': (
      () => _scoped(editing, const AdminProductFormScreen(productId: _id)),
      2500,
    ),
  };

  for (final MapEntry(key: name, value: (build, height)) in cases.entries) {
    for (final brightness in Brightness.values) {
      testWidgets(
        'admin $name, ${brightness.name}',
        (tester) => withRealShadows(() async {
          usePhoneScreen(tester, height: height);
          await pumpThemed(tester, build(), brightness: brightness);
          await tester.pumpAndSettle();
          await expectLater(
            find.byType(MaterialApp),
            matchesGoldenFile('goldens/admin_${name}_${brightness.name}.png'),
          );
        }),
      );
    }
  }
}
