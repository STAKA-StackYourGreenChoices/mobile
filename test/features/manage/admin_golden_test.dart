@Tags(['golden'])
library;

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/auth/session_repository.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/ownership.dart';
import 'package:staka/core/models/product_variant.dart';
import 'package:staka/core/models/sustainability_info.dart';
import 'package:staka/features/brand_apply/domain/models/brand_application.dart';
import 'package:staka/features/manage/brand_review/data/brand_review_repository_impl.dart';
import 'package:staka/features/manage/brand_review/presentation/screens/admin_brand_screen.dart';
import 'package:staka/features/manage/brand_review/presentation/screens/admin_brands_screen.dart';
import 'package:staka/features/manage/claims/data/repositories/admin_claim_repository_impl.dart';
import 'package:staka/features/manage/claims/domain/models/claim.dart';
import 'package:staka/features/manage/disputes/data/dispute_repository_impl.dart';
import 'package:staka/features/manage/disputes/presentation/screens/admin_dispute_screen.dart';
import 'package:staka/features/manage/disputes/presentation/screens/admin_disputes_screen.dart';
import 'package:staka/features/manage/hub/presentation/screens/admin_home_screen.dart';
import 'package:staka/features/manage/products/data/repositories/admin_product_repository_impl.dart';
import 'package:staka/features/manage/products/domain/models/editable_product.dart';
import 'package:staka/features/manage/products/domain/models/sku_alias.dart';
import 'package:staka/features/manage/products/presentation/screens/admin_product_form_screen.dart';
import 'package:staka/features/manage/products/presentation/screens/admin_products_screen.dart';
import 'package:staka/features/manage/shared/manage_scope.dart';

import '../../helpers/admin_claim_fakes.dart';
import '../../helpers/admin_product_fakes.dart';
import '../../helpers/admin_review_fakes.dart';
import '../../helpers/auth_fakes.dart';
import '../../helpers/fake_http_adapter.dart';
import '../../helpers/golden.dart';
import '../../helpers/product_fakes.dart';
import '../../helpers/pump_app.dart';

const _id = '11111111-2222-4333-8444-555555555555';

final Claim _claim = claimFor(
  1,
  status: ClaimStatus.rejected,
  rejectionReason: 'The receipt is from another shop.',
);

final _brands = FakeBrandReviewRepository(
  lists: {
    BrandApplicationStatus.pending: Ok([
      reviewBrand(),
      reviewBrand(id: 'b2', name: 'Nordic Loom', memberCount: null),
    ]),
  },
);

final _disputes = FakeDisputeRepository(
  lists: {
    DisputeStatus.open: Ok([disputeOf(_claim)]),
  },
);

final _claims = FakeAdminClaimRepository(
  details: {_claim.id: detailOf(_claim)},
  receipts: {
    _claim.id: Ok(ClaimReceipt(bytes: onePixelPng, mimeType: 'image/png')),
  },
);

Widget _scoped(Widget screen, {FakeAdminProductRepository? products}) =>
    ProviderScope(
      overrides: [
        // The hub reads the session (an admin's own brand); signed out here.
        sessionRepositoryProvider.overrideWithValue(
          SessionRepository(
            Dio()..httpClientAdapter = FakeHttpAdapter([]),
            InMemoryTokenStore(),
          ),
        ),
        adminProductRepositoryProvider.overrideWith(
          (_, _) => products ?? FakeAdminProductRepository(),
        ),
        brandReviewRepositoryProvider.overrideWithValue(_brands),
        disputeRepositoryProvider.overrideWithValue(_disputes),
        adminClaimRepositoryProvider.overrideWith((_, _) => _claims),
      ],
      child: screen,
    );

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
        ).copyWith(isHidden: true),
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
      _id: Ok(
        EditableProduct(
          product: productNamed('Organic Cotton Tee').copyWith(
            id: _id,
            category: ProductCategory.tops,
            styleCode: 'TT-TEE',
            variants: const [
              ProductVariant(
                id: 'v1',
                gtin: '08901234500019',
                sku: 'TT-TEE-S',
                size: 'S',
                colour: 'Navy',
              ),
              ProductVariant(
                id: 'v2',
                gtin: '08901234500057',
                sku: 'TT-TEE-M',
                size: 'M',
                colour: 'Navy',
              ),
            ],
          ),
          aliases: const {
            'v2': [SkuAlias(source: 'Myntra', code: 'MY-2')],
          },
        ),
      ),
    },
  );
  final adding = FakeAdminProductRepository(
    brands: Ok([brandSummary('b1', 'Terra Threads')]),
  );

  final cases = <String, (Widget Function(), double)>{
    'admin_hub': (() => _scoped(const AdminHomeScreen()), 760),
    'admin_products': (
      () => _scoped(
        const AdminProductsScreen(scope: AdminScope()),
        products: list,
      ),
      760,
    ),
    'admin_products_empty': (
      () => _scoped(const AdminProductsScreen(scope: AdminScope())),
      760,
    ),
    'admin_brands': (() => _scoped(const AdminBrandsScreen()), 760),
    'admin_brand_pending': (
      () => _scoped(const AdminBrandScreen(brandId: 'b1')),
      1300,
    ),
    'admin_disputes': (() => _scoped(const AdminDisputesScreen()), 760),
    'admin_dispute': (
      () => _scoped(const AdminDisputeScreen(disputeId: 'd1')),
      1300,
    ),
    'brand_product_new': (
      () => _scoped(
        const AdminProductFormScreen(scope: BrandScope('b1')),
        products: adding,
      ),
      3000,
    ),
    'brand_product_edit': (
      () => _scoped(
        const AdminProductFormScreen(scope: BrandScope('b1'), productId: _id),
        products: editing,
      ),
      3900,
    ),
  };

  for (final MapEntry(key: name, value: (build, height)) in cases.entries) {
    for (final brightness in Brightness.values) {
      testWidgets(
        '$name, ${brightness.name}',
        (tester) => withRealShadows(() async {
          usePhoneScreen(tester, height: height);
          await pumpThemed(tester, build(), brightness: brightness);
          await tester.pumpAndSettle();
          if (name == 'admin_dispute') await _decodeImages(tester);
          await expectLater(
            find.byType(MaterialApp),
            matchesGoldenFile('goldens/${name}_${brightness.name}.png'),
          );
        }),
      );
    }
  }
}

/// Decodes the receipt photo for real (the fake clock never does), so the
/// image has its size in every run, not only when an earlier test cached it.
Future<void> _decodeImages(WidgetTester tester) async {
  for (final element in find.byType(Image).evaluate()) {
    final image = element.widget as Image;
    await tester.runAsync(() => precacheImage(image.image, element));
  }
  await tester.pumpAndSettle();
}
