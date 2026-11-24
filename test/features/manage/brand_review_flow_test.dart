import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/auth/auth_tokens.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/features/brand_apply/domain/models/brand_application.dart';
import 'package:staka/features/manage/brand_review/domain/models/review_brand.dart';

import '../../helpers/admin_claim_fakes.dart';
import '../../helpers/admin_review_fakes.dart';
import '../../helpers/auth_fakes.dart';
import '../../helpers/fake_http_adapter.dart';
import '../../helpers/pump_app.dart';
import '../../helpers/pump_full_app.dart';

const _tokens = AuthTokens(accessToken: 'a', refreshToken: 'r');

/// Signs in as an admin and opens Admin → Brands on a 360 × 800 phone.
Future<void> _openBrands(
  WidgetTester tester,
  FakeBrandReviewRepository brands,
) async {
  usePhoneScreen(tester, height: 800);
  await pumpApp(
    tester,
    tokens: _tokens,
    replies: [json(200, userJson(role: 'ADMIN'))],
    brandReview: brands,
  );
  await tester.tap(
    find.descendant(
      of: find.byType(NavigationBar),
      matching: find.text('Admin'),
    ),
  );
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

Future<void> _openBrand(WidgetTester tester, String name) =>
    _tap(tester, find.text(name).first);

void main() {
  testWidgets('the hub counts applications waiting', (tester) async {
    usePhoneScreen(tester, height: 800);
    await pumpApp(
      tester,
      tokens: _tokens,
      replies: [json(200, userJson(role: 'ADMIN'))],
      brandReview: FakeBrandReviewRepository(
        lists: {
          BrandApplicationStatus.pending: Ok([
            reviewBrand(),
            reviewBrand(id: 'b2', name: 'Nordic Loom'),
          ]),
        },
      ),
    );
    await tester.tap(find.text('Admin'));
    await tester.pumpAndSettle();

    expect(find.text('2 applications are waiting.'), findsOneWidget);
  });

  testWidgets('tabs: waiting applications, then each status', (tester) async {
    await _openBrands(
      tester,
      FakeBrandReviewRepository(
        lists: {
          BrandApplicationStatus.pending: Ok([reviewBrand()]),
          BrandApplicationStatus.approved: Ok([
            reviewBrand(
              id: 'b2',
              name: 'Nordic Loom',
              status: BrandApplicationStatus.approved,
            ),
          ]),
        },
      ),
    );

    expect(find.text('Terra Threads'), findsOneWidget);
    for (final tab in ['To review', 'Active', 'Paused', 'Turned down']) {
      expect(find.text(tab), findsWidgets);
    }

    await _tap(tester, find.text('Active').first);
    expect(find.text('Nordic Loom'), findsOneWidget);
    expect(find.text('Terra Threads'), findsNothing);

    await _tap(tester, find.text('Paused').first);
    expect(find.text('No paused brands.'), findsOneWidget);
  });

  testWidgets('approve an application: the snackbar, no reason asked', (
    tester,
  ) async {
    final brands = FakeBrandReviewRepository(
      lists: {
        BrandApplicationStatus.pending: Ok([reviewBrand()]),
      },
      decisions: [const Ok(null)],
    );
    await _openBrands(tester, brands);
    await _openBrand(tester, 'Terra Threads');

    expect(find.text('Your decision'), findsOneWidget);
    await _tap(tester, find.text('Approve brand'));

    expect(brands.decided, [('approve', 'b1', null)]);
    expect(
      find.text('Terra Threads is approved. Its team can now run it.'),
      findsOneWidget,
    );
  });

  testWidgets('turn down an application: a reason is needed', (tester) async {
    final brands = FakeBrandReviewRepository(
      lists: {
        BrandApplicationStatus.pending: Ok([reviewBrand()]),
      },
      decisions: [const Ok(null)],
    );
    await _openBrands(tester, brands);
    await _openBrand(tester, 'Terra Threads');

    await _tap(tester, find.text('Turn down'));
    expect(find.text('Turn down Terra Threads?'), findsOneWidget);
    await _tap(tester, find.widgetWithText(FilledButton, 'Turn down'));
    expect(find.text('Write at least 3 characters.'), findsOneWidget);
    expect(brands.decided, isEmpty);

    await tester.enterText(
      find.byType(TextFormField),
      '  The GSTIN does not match the document.  ',
    );
    await _tap(tester, find.widgetWithText(FilledButton, 'Turn down'));

    expect(brands.decided, [
      ('reject', 'b1', 'The GSTIN does not match the document.'),
    ]);
    expect(
      find.text('Terra Threads was turned down. Its owners see your reason.'),
      findsOneWidget,
    );
  });

  testWidgets('pause an active brand with a reason', (tester) async {
    final brands = FakeBrandReviewRepository(
      lists: {
        BrandApplicationStatus.approved: Ok([
          reviewBrand(status: BrandApplicationStatus.approved),
        ]),
      },
      decisions: [const Ok(null)],
    );
    await _openBrands(tester, brands);
    await _tap(tester, find.text('Active').first);
    await _openBrand(tester, 'Terra Threads');

    expect(find.text('Approve brand'), findsNothing);
    await _tap(tester, find.text('Pause brand'));
    expect(find.text('Pause Terra Threads?'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField), 'Fake receipts.');
    await _tap(tester, find.widgetWithText(FilledButton, 'Pause brand'));

    expect(brands.decided, [('suspend', 'b1', 'Fake receipts.')]);
    expect(find.text('Terra Threads is paused.'), findsOneWidget);
  });

  testWidgets('make a paused brand active again; its reason is shown', (
    tester,
  ) async {
    final brands = FakeBrandReviewRepository(
      lists: {
        BrandApplicationStatus.suspended: Ok([
          reviewBrand(
            status: BrandApplicationStatus.suspended,
            statusReason: 'Fake receipts.',
          ),
        ]),
      },
      decisions: [const Ok(null)],
    );
    await _openBrands(tester, brands);
    await _tap(tester, find.text('Paused').first);
    await _openBrand(tester, 'Terra Threads');

    expect(find.text('Reason: Fake receipts.'), findsOneWidget);
    await _tap(tester, find.text('Make active again'));

    expect(brands.decided, [('reinstate', 'b1', null)]);
    expect(find.text('Terra Threads is active again.'), findsOneWidget);
  });

  testWidgets("approve refused: the API's reason on the page", (tester) async {
    final brands = FakeBrandReviewRepository(
      lists: {
        BrandApplicationStatus.pending: Ok([reviewBrand()]),
      },
      decisions: [
        const Err(ConflictFailure(['Brand is not pending'])),
      ],
    );
    await _openBrands(tester, brands);
    await _openBrand(tester, 'Terra Threads');
    await _tap(tester, find.text('Approve brand'));

    expect(find.text('Brand is not pending'), findsOneWidget);
    expect(find.textContaining('is approved'), findsNothing);
  });

  testWidgets('a turned-down application waits; no document is said', (
    tester,
  ) async {
    await _openBrands(
      tester,
      FakeBrandReviewRepository(
        lists: {
          BrandApplicationStatus.rejected: Ok([
            reviewBrand(
              status: BrandApplicationStatus.rejected,
              hasDocument: false,
            ),
          ]),
        },
      ),
    );
    await _tap(tester, find.text('Turned down').first);
    await _openBrand(tester, 'Terra Threads');

    expect(find.text('No business document was sent.'), findsOneWidget);
    expect(
      find.text(
        'Waiting for the brand to fix its application and send it again.',
      ),
      findsOneWidget,
    );
    expect(find.byType(FilledButton), findsNothing);
  });

  testWidgets('the business document opens; a missing one says so', (
    tester,
  ) async {
    await _openBrands(
      tester,
      FakeBrandReviewRepository(
        lists: {
          BrandApplicationStatus.pending: Ok([
            reviewBrand(),
            reviewBrand(id: 'b2', name: 'Nordic Loom'),
          ]),
        },
        documents: {
          'b1': Ok(BrandDocument(bytes: onePixelPng, mimeType: 'image/png')),
        },
      ),
    );
    await _openBrand(tester, 'Terra Threads');
    await _tap(tester, find.text('View business document'));

    expect(find.text('Business document'), findsOneWidget);
    expect(find.bySemanticsLabel('Business document'), findsWidgets);

    await _tap(tester, find.byType(BackButton));
    await _tap(tester, find.byType(BackButton));
    await _openBrand(tester, 'Nordic Loom');
    await _tap(tester, find.text('View business document'));
    expect(find.text("The document couldn't be loaded."), findsOneWidget);
  });

  testWidgets('a brand that is gone: not found, back to Brands', (
    tester,
  ) async {
    await _openBrands(
      tester,
      FakeBrandReviewRepository(
        lists: {
          BrandApplicationStatus.pending: Ok([reviewBrand()]),
        },
        details: {
          'b1': const Err(NotFoundFailure(['Brand not found'])),
        },
      ),
    );
    await _openBrand(tester, 'Terra Threads');

    expect(find.text('This page could not be found.'), findsOneWidget);
  });
}
