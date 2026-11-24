import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/auth/auth_tokens.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/sustainability_info.dart';
import 'package:staka/features/manage/products/domain/models/product_page.dart';

import '../../helpers/admin_product_fakes.dart';
import '../../helpers/auth_fakes.dart';
import '../../helpers/brand_portal_fakes.dart';
import '../../helpers/fake_http_adapter.dart';
import '../../helpers/product_fakes.dart';
import '../../helpers/pump_app.dart';
import '../../helpers/pump_full_app.dart';

const _tokens = AuthTokens(accessToken: 'a', refreshToken: 'r');

/// [productNamed]'s id for the tee (from its barcode).
const _teeId = 'p-08901234500019';

/// Signs in as an admin and opens Admin → Products on a 360 × 800 phone.
Future<void> _openProducts(
  WidgetTester tester,
  FakeAdminProductRepository repository,
) async {
  usePhoneScreen(tester, height: 800);
  await pumpApp(
    tester,
    tokens: _tokens,
    replies: [json(200, userJson(role: 'ADMIN'))],
    adminProducts: repository,
  );
  await tester.tap(find.text('Admin'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Products'));
  await tester.pumpAndSettle();
}

/// Terra Threads' owner opens Brand → Products: the same list, editable.
Future<void> _openBrandProducts(
  WidgetTester tester,
  FakeAdminProductRepository repository,
) async {
  usePhoneScreen(tester, height: 800);
  await pumpApp(
    tester,
    tokens: _tokens,
    replies: [
      json(200, memberUserJson([membershipJson()])),
    ],
    adminProducts: repository,
  );
  await tester.tap(
    find.descendant(
      of: find.byType(NavigationBar),
      matching: find.text('Brand'),
    ),
  );
  await tester.pumpAndSettle();
  await tester.tap(find.text('Products'));
  await tester.pumpAndSettle();
}

Future<void> _search(WidgetTester tester, String text) async {
  await tester.enterText(find.byType(TextField), text);
  await tester.testTextInput.receiveAction(TextInputAction.search);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('lists products: name, brand and barcode, figures badge', (
    tester,
  ) async {
    final repository = FakeAdminProductRepository(
      pages: (_) => Ok(
        pageOf([
          productNamed('Organic Cotton Tee'),
          productNamed(
            'Recycled Denim Jeans',
            gtin: '08901234500026',
            info: null,
          ),
        ]),
      ),
    );
    await _openProducts(tester, repository);

    expect(
      find.text(
        "Every brand's products. Brands add and edit their own; tap one to "
        'hide it from shoppers or show it again.',
      ),
      findsOneWidget,
    );
    // Read-only for admins (V2-12).
    expect(find.text('Add product'), findsNothing);
    expect(find.text('Import CSV'), findsNothing);
    expect(find.text('Showing 1–2 of 2 products'), findsOneWidget);
    expect(find.text('Organic Cotton Tee'), findsOneWidget);
    expect(find.text('Terra Threads, 8901234500019'), findsOneWidget);
    expect(find.bySemanticsLabel(RegExp('Figures: Verified')), findsOneWidget);
    expect(find.bySemanticsLabel(RegExp('Figures: Missing')), findsOneWidget);
    expect(repository.requests.single, (
      filter: const ProductFilter(),
      page: 1,
    ));
  });

  testWidgets('brand-stated figures get their own badge', (tester) async {
    await _openProducts(
      tester,
      FakeAdminProductRepository(
        pages: (_) => Ok(
          pageOf([
            productNamed(
              'Linen Shirt',
              info: const SustainabilityInfo(
                carbonScoreGrams: 1200,
                recyclabilityPercent: 60,
                isVerified: false,
              ),
            ),
          ]),
        ),
      ),
    );

    expect(find.text('Showing 1–1 of 1 product'), findsOneWidget);
    expect(
      find.bySemanticsLabel(RegExp('Figures: Brand-stated')),
      findsOneWidget,
    );
  });

  testWidgets('search: nothing matches, then Clear shows everything again', (
    tester,
  ) async {
    final repository = FakeAdminProductRepository(
      pages: (request) => Ok(
        request.filter.isFiltered
            ? pageOf(const [])
            : pageOf([productNamed('Organic Cotton Tee')]),
      ),
    );
    await _openProducts(tester, repository);

    await _search(tester, '  wool ');
    expect(
      repository.requests.last.filter,
      const ProductFilter(search: 'wool'),
    );
    expect(find.text('No products match'), findsOneWidget);
    expect(
      find.text('Try a different name, SKU or barcode, or clear the filters.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Clear'));
    await tester.pumpAndSettle();
    expect(repository.requests.last.filter, const ProductFilter());
    expect(find.text('Organic Cotton Tee'), findsOneWidget);
    expect(find.text('wool'), findsNothing);
  });

  testWidgets('the x in the search box clears the search', (tester) async {
    final repository = FakeAdminProductRepository(
      pages: (_) => Ok(pageOf([productNamed('Organic Cotton Tee')])),
    );
    await _openProducts(tester, repository);
    await _search(tester, 'tee');

    await tester.tap(find.byTooltip('Clear search'));
    await tester.pumpAndSettle();
    expect(repository.requests.last.filter, const ProductFilter());
  });

  testWidgets('filter by brand from the sheet, then back to all brands', (
    tester,
  ) async {
    final repository = FakeAdminProductRepository(
      pages: (_) => Ok(pageOf([productNamed('Organic Cotton Tee')])),
      brands: Ok([
        brandSummary('b1', 'Terra Threads'),
        brandSummary('b2', 'Nordic Loom'),
      ]),
    );
    await _openProducts(tester, repository);

    await tester.tap(find.text('All brands'));
    await tester.pumpAndSettle();
    expect(find.text('Filter by brand'), findsOneWidget);
    await tester.tap(find.text('Nordic Loom'));
    await tester.pumpAndSettle();
    expect(repository.requests.last.filter, const ProductFilter(brandId: 'b2'));
    expect(find.text('Nordic Loom'), findsOneWidget);

    await tester.tap(find.text('Nordic Loom'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('All brands'));
    await tester.pumpAndSettle();
    expect(repository.requests.last.filter, const ProductFilter());
  });

  testWidgets('brands that fail to load hide the brand filter', (tester) async {
    await _openProducts(
      tester,
      FakeAdminProductRepository(
        pages: (_) => Ok(pageOf([productNamed('Organic Cotton Tee')])),
        brands: const Err(NetworkFailure()),
      ),
    );

    expect(find.text('All brands'), findsNothing);
    expect(find.text('Organic Cotton Tee'), findsOneWidget);
  });

  testWidgets('more load while scrolling; a failed page offers Try again', (
    tester,
  ) async {
    var failNext = true;
    final repository = FakeAdminProductRepository(
      pages: (request) {
        if (request.page == 2 && failNext) {
          failNext = false;
          return const Err(NetworkFailure());
        }
        final from = (request.page - 1) * 20 + 1;
        return Ok(
          pageOf(
            numberedProducts(request.page == 3 ? 5 : 20, from: from),
            total: 45,
            page: request.page,
          ),
        );
      },
    );
    await _openProducts(tester, repository);
    expect(find.text('Showing 1–20 of 45 products'), findsOneWidget);

    await tester.fling(
      find.byType(CustomScrollView),
      const Offset(0, -4000),
      4000,
    );
    await tester.pumpAndSettle();
    expect(repository.requests.map((r) => r.page), [1, 2]);
    expect(find.text('Try again'), findsOneWidget);

    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    expect(find.text('Product 21'), findsOneWidget);

    await tester.fling(
      find.byType(CustomScrollView),
      const Offset(0, -6000),
      6000,
    );
    await tester.pumpAndSettle();
    expect(find.text('Product 45'), findsOneWidget);
    expect(repository.requests.map((r) => r.page), [1, 2, 2, 3]);
    await tester.fling(
      find.byType(CustomScrollView),
      const Offset(0, 8000),
      8000,
    );
    await tester.pumpAndSettle();
    expect(find.text('Showing 1–45 of 45 products'), findsOneWidget);

    // Everything is shown: no more requests.
    await tester.fling(
      find.byType(CustomScrollView),
      const Offset(0, -2000),
      2000,
    );
    await tester.pumpAndSettle();
    expect(repository.requests, hasLength(4));
  });

  testWidgets('empty catalog, admin: brands add their own', (tester) async {
    await _openProducts(tester, FakeAdminProductRepository());

    expect(find.text('No products yet'), findsOneWidget);
    expect(
      find.text(
        'Brands add their products from their Brand tab. They show up here.',
      ),
      findsOneWidget,
    );
    expect(find.text('Add product'), findsNothing);
  });

  testWidgets('empty catalog, brand: invited to add or import products', (
    tester,
  ) async {
    await _openBrandProducts(tester, FakeAdminProductRepository());

    expect(find.text('No products yet'), findsOneWidget);
    expect(
      find.text(
        'Add products one at a time, or import a whole catalog from a CSV '
        'file.',
      ),
      findsOneWidget,
    );
    // Header and empty state both offer Add product and Import CSV.
    expect(find.text('Add product'), findsNWidgets(2));
    expect(find.text('Import CSV'), findsNWidgets(2));
  });

  testWidgets('brand: Add product, Import CSV and a row open their pages', (
    tester,
  ) async {
    await _openBrandProducts(
      tester,
      FakeAdminProductRepository(
        pages: (_) => Ok(pageOf([productNamed('Organic Cotton Tee')])),
      ),
    );

    await tester.tap(find.text('Add product'));
    await tester.pumpAndSettle();
    expect(
      find.text('Shoppers find this product by scanning its barcode.'),
      findsOneWidget,
    );
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    // Unknown to the fake repository: the edit page says so.
    await tester.tap(find.text('Organic Cotton Tee'));
    await tester.pumpAndSettle();
    expect(find.text('This page could not be found.'), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Import CSV'));
    await tester.pumpAndSettle();
    expect(find.text('Up to 2 MB and 5,000 rows.'), findsOneWidget);
  });

  testWidgets('admin hides a product, then shows it again', (tester) async {
    var hidden = false;
    final repository = FakeAdminProductRepository(
      pages: (_) => Ok(
        pageOf([productNamed('Organic Cotton Tee').copyWith(isHidden: hidden)]),
      ),
      visibility: [const Ok(null), const Ok(null)],
    );
    await _openProducts(tester, repository);

    await tester.tap(find.text('Organic Cotton Tee'));
    await tester.pumpAndSettle();
    expect(find.text('Hide Organic Cotton Tee?'), findsOneWidget);
    expect(
      find.text(
        "Shoppers won't see it on STAKA until you show it again. "
        'Terra Threads still sees it in its Brand tab.',
      ),
      findsOneWidget,
    );
    hidden = true;
    await tester.tap(find.text('Hide product'));
    await tester.pumpAndSettle();

    expect(repository.visibilityChanges, [(_teeId, true)]);
    expect(
      find.text('Organic Cotton Tee is hidden from shoppers.'),
      findsOneWidget,
    );
    expect(find.text('Hidden'), findsOneWidget);
    expect(repository.requests, hasLength(2));

    hidden = false;
    await tester.tap(find.text('Organic Cotton Tee'));
    await tester.pumpAndSettle();
    expect(find.text('Show Organic Cotton Tee again?'), findsOneWidget);
    await tester.tap(find.text('Show product'));
    await tester.pumpAndSettle();

    expect(repository.visibilityChanges, [(_teeId, true), (_teeId, false)]);
    expect(find.text('Hidden'), findsNothing);
  });

  testWidgets("hiding refused: the API's reason stays in the dialog", (
    tester,
  ) async {
    final repository = FakeAdminProductRepository(
      pages: (_) => Ok(pageOf([productNamed('Organic Cotton Tee')])),
      visibility: [
        const Err(ForbiddenFailure(['Only admins can hide products'])),
      ],
    );
    await _openProducts(tester, repository);
    await tester.tap(find.text('Organic Cotton Tee'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hide product'));
    await tester.pumpAndSettle();

    expect(find.text('Only admins can hide products'), findsOneWidget);
    expect(find.text('Hide Organic Cotton Tee?'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Hidden'), findsNothing);
  });

  testWidgets('the list fails to load: the reason and Try again', (
    tester,
  ) async {
    var fail = true;
    final repository = FakeAdminProductRepository(
      pages: (_) {
        if (fail) {
          fail = false;
          return const Err(NetworkFailure());
        }
        return Ok(pageOf([productNamed('Organic Cotton Tee')]));
      },
    );
    await _openProducts(tester, repository);

    expect(find.text('No connection'), findsOneWidget);
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -300));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    expect(find.text('Organic Cotton Tee'), findsOneWidget);
  });

  testWidgets('pull to refresh asks for the first page again', (tester) async {
    final repository = FakeAdminProductRepository(
      pages: (_) => Ok(pageOf([productNamed('Organic Cotton Tee')])),
    );
    await _openProducts(tester, repository);

    await tester.fling(
      find.text('Organic Cotton Tee'),
      const Offset(0, 400),
      1000,
    );
    await tester.pumpAndSettle();
    expect(repository.requests.map((r) => r.page), [1, 1]);
    expect(find.text('Organic Cotton Tee'), findsOneWidget);
  });
}
