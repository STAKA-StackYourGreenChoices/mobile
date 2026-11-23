import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/auth/auth_tokens.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/brand_summary.dart';
import 'package:staka/features/manage/products/domain/models/product_page.dart';

import '../../helpers/admin_brand_fakes.dart';
import '../../helpers/admin_product_fakes.dart';
import '../../helpers/auth_fakes.dart';
import '../../helpers/fake_http_adapter.dart';
import '../../helpers/pump_app.dart';
import '../../helpers/pump_full_app.dart';

const _tokens = AuthTokens(accessToken: 'a', refreshToken: 'r');

final BrandSummary _terra = brandSummary(
  'b1',
  'Terra Threads',
).copyWith(description: 'Organic cotton basics, made in Portugal.');
final BrandSummary _empty = brandSummary(
  'b2',
  'Nordic Loom',
).copyWith(productCount: 0);

/// Signs in as an admin and opens Admin → Brands on a 360 × 800 phone.
Future<void> _openBrands(
  WidgetTester tester,
  FakeAdminBrandRepository brands, {
  FakeAdminProductRepository? products,
}) async {
  usePhoneScreen(tester, height: 800);
  await pumpApp(
    tester,
    tokens: _tokens,
    replies: [json(200, userJson(role: 'ADMIN'))],
    adminBrands: brands,
    adminProducts: products,
  );
  await tester.tap(find.text('Admin'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Brands'));
  await tester.pumpAndSettle();
}

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> _type(WidgetTester tester, String label, String text) async {
  final field = find.descendant(
    of: find.ancestor(of: find.text(label), matching: find.byType(Column)),
    matching: find.byType(TextField),
  );
  await tester.enterText(field.first, text);
  await tester.pump();
}

final Finder _submitAdd = find.widgetWithText(FilledButton, 'Add brand').last;

void main() {
  testWidgets('lists brands: name, what they make, product count', (
    tester,
  ) async {
    await _openBrands(
      tester,
      FakeAdminBrandRepository(
        lists: [
          Ok([_terra, _empty]),
        ],
      ),
    );

    expect(
      find.text(
        'Every product belongs to a brand. Its name appears at the top of '
        'each tag.',
      ),
      findsOneWidget,
    );
    expect(find.text('Terra Threads'), findsOneWidget);
    expect(
      find.text('Organic cotton basics, made in Portugal.'),
      findsOneWidget,
    );
    expect(find.text('3 products'), findsOneWidget);
    expect(find.text('0 products'), findsOneWidget);
    expect(find.bySemanticsLabel('Edit Terra Threads'), findsOneWidget);
    expect(find.bySemanticsLabel('Delete Nordic Loom'), findsOneWidget);
  });

  testWidgets('the product count opens the products of that brand', (
    tester,
  ) async {
    final products = FakeAdminProductRepository(brands: Ok([_terra]));
    await _openBrands(
      tester,
      FakeAdminBrandRepository(
        lists: [
          Ok([_terra]),
        ],
      ),
      products: products,
    );

    await tester.tap(find.text('3 products'));
    await tester.pumpAndSettle();

    expect(products.requests.single.filter, const ProductFilter(brandId: 'b1'));
    expect(find.text('Terra Threads'), findsOneWidget); // the brand filter
  });

  testWidgets('no brands yet: invited to add one', (tester) async {
    await _openBrands(tester, FakeAdminBrandRepository());

    expect(find.text('No brands yet'), findsOneWidget);
    expect(
      find.text(
        'Add a brand before adding its products. Importing a CSV also '
        'creates any brands it names.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('add: website rules, then saved and the list reloads', (
    tester,
  ) async {
    final repository = FakeAdminBrandRepository(
      lists: [
        const Ok([]),
        Ok([_empty]),
      ],
      saves: [Ok(_empty)],
    );
    await _openBrands(tester, repository);

    await tester.tap(find.text('Add brand').first);
    await tester.pumpAndSettle();
    expect(
      find.text('You can add its products once the brand exists.'),
      findsOneWidget,
    );
    await _type(tester, 'Logo link', 'nordicloom.example/logo.png');
    await _tap(tester, _submitAdd);
    expect(find.text('Enter the brand name'), findsOneWidget);
    expect(
      find.text('Enter a full link starting with https://'),
      findsOneWidget,
    );
    expect(repository.saved, isEmpty);

    await _type(tester, 'Brand name', ' Nordic Loom ');
    await _type(tester, 'Logo link', '');
    await _tap(tester, _submitAdd);

    final (id, draft) = repository.saved.single;
    expect(id, isNull);
    expect(
      (draft.name, draft.description, draft.logoUrl),
      ('Nordic Loom', null, null),
    );
    expect(find.text('Brand added'), findsOneWidget);
    expect(find.text('Nordic Loom'), findsOneWidget);
    expect(repository.fetches, 2);
  });

  testWidgets('a taken name is shown on the name field', (tester) async {
    await _openBrands(
      tester,
      FakeAdminBrandRepository(
        saves: [
          const Err(ConflictFailure(['A brand with this name already exists'])),
        ],
      ),
    );

    await tester.tap(find.text('Add brand').first);
    await tester.pumpAndSettle();
    await _type(tester, 'Brand name', 'Terra Threads');
    await _tap(tester, _submitAdd);

    expect(find.text('A brand with this name already exists'), findsOneWidget);
    expect(find.byType(BottomSheet), findsOneWidget);
  });

  testWidgets('edit: filled in; an emptied description is cleared', (
    tester,
  ) async {
    final repository = FakeAdminBrandRepository(
      lists: [
        Ok([_terra]),
      ],
      saves: [Ok(_terra.copyWith(description: null))],
    );
    await _openBrands(tester, repository);

    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();
    expect(find.text('Edit Terra Threads'), findsOneWidget);
    expect(
      find.text("Changes show on every tag for this brand's products."),
      findsOneWidget,
    );
    await _type(tester, 'About the brand', '');
    await _tap(tester, find.widgetWithText(FilledButton, 'Save changes'));

    final (id, draft) = repository.saved.single;
    expect((id, draft.name, draft.description), ('b1', 'Terra Threads', null));
    expect(find.text('Brand updated'), findsOneWidget);
  });

  testWidgets('a brand with products: offered its products instead', (
    tester,
  ) async {
    final products = FakeAdminProductRepository(brands: Ok([_terra]));
    await _openBrands(
      tester,
      FakeAdminBrandRepository(
        lists: [
          Ok([_terra]),
        ],
      ),
      products: products,
    );

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    expect(find.text('Terra Threads still has products'), findsOneWidget);
    expect(
      find.text('Delete its 3 products or move them to another brand first.'),
      findsOneWidget,
    );
    await tester.tap(find.text('See its products'));
    await tester.pumpAndSettle();

    expect(products.requests.single.filter, const ProductFilter(brandId: 'b1'));
  });

  testWidgets('delete an empty brand', (tester) async {
    final repository = FakeAdminBrandRepository(
      lists: [
        Ok([_empty]),
        const Ok([]),
      ],
      deletes: [const Ok(null)],
    );
    await _openBrands(tester, repository);

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    expect(find.text('Delete Nordic Loom?'), findsOneWidget);
    expect(find.text("This can't be undone."), findsOneWidget);
    await tester.tap(find.text('Delete brand'));
    await tester.pumpAndSettle();

    expect(repository.deleted, ['b2']);
    expect(find.text('Nordic Loom deleted'), findsOneWidget);
    expect(find.text('No brands yet'), findsOneWidget);
  });

  testWidgets('delete refused: the API reason stays in the dialog', (
    tester,
  ) async {
    const reason = 'Brand still has 1 product(s); delete or move them first';
    await _openBrands(
      tester,
      FakeAdminBrandRepository(
        lists: [
          Ok([_empty]),
        ],
        deletes: [
          const Err(ConflictFailure([reason])),
        ],
      ),
    );

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete brand'));
    await tester.pumpAndSettle();

    expect(find.text(reason), findsOneWidget);
    await tester.tap(find.text('Keep brand'));
    await tester.pumpAndSettle();
    expect(find.text(reason), findsNothing);
  });

  testWidgets('brands fail to load: the reason and Try again', (tester) async {
    await _openBrands(
      tester,
      FakeAdminBrandRepository(
        lists: [
          const Err(NetworkFailure()),
          Ok([_terra]),
        ],
      ),
    );

    expect(find.text('No connection'), findsOneWidget);
    await _tap(tester, find.text('Try again'));
    expect(find.text('Terra Threads'), findsOneWidget);
  });
}
