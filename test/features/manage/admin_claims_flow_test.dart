import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/auth/auth_tokens.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/ownership.dart';
import 'package:staka/features/manage/claims/domain/models/claim.dart';

import '../../helpers/admin_claim_fakes.dart';
import '../../helpers/auth_fakes.dart';
import '../../helpers/brand_portal_fakes.dart';
import '../../helpers/fake_http_adapter.dart';
import '../../helpers/product_fakes.dart';
import '../../helpers/pump_app.dart';
import '../../helpers/pump_full_app.dart';

const _tokens = AuthTokens(accessToken: 'a', refreshToken: 'r');

/// Signs in as an admin and opens Admin → Claims on a 360 × 800 phone;
/// [asBrand]: as Terra Threads' owner, Brand → Claims (brands approve and
/// reject their own claims since V2-12; admins overrule).
Future<void> _openClaims(
  WidgetTester tester,
  FakeAdminClaimRepository claims, {
  bool asBrand = false,
}) async {
  usePhoneScreen(tester, height: 800);
  await pumpApp(
    tester,
    tokens: _tokens,
    replies: [
      json(
        200,
        asBrand ? memberUserJson([membershipJson()]) : userJson(role: 'ADMIN'),
      ),
    ],
    adminClaims: claims,
  );
  await tester.tap(
    find.descendant(
      of: find.byType(NavigationBar),
      matching: find.text(asBrand ? 'Brand' : 'Admin'),
    ),
  );
  await tester.pumpAndSettle();
  await tester.ensureVisible(find.text('Claims'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Claims'));
  await tester.pumpAndSettle();
}

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

/// The list holds [claim] while pending; the review page shows it.
FakeAdminClaimRepository _queueWith(
  Claim claim, {
  List<Claim>? history,
  List<Result<ClaimDetail>> decisions = const [],
}) => FakeAdminClaimRepository(
  pages: (request) => Ok(
    request.status == claim.status
        ? ClaimPage(items: [claim], total: 1)
        : const ClaimPage(items: [], total: 0),
  ),
  details: {claim.id: detailOf(claim, history: history)},
  receipts: {
    claim.id: Ok(ClaimReceipt(bytes: onePixelPng, mimeType: 'image/png')),
  },
  products: {'p1': Ok(productNamed('Organic Cotton Tee'))},
  decisions: decisions,
);

Future<void> _openClaim(WidgetTester tester, Claim claim) async {
  if (claim.status != ClaimStatus.pending) {
    await _tap(
      tester,
      find.text(claim.status == ClaimStatus.approved ? 'Approved' : 'Rejected'),
    );
  }
  await tester.tap(find.text(claim.product.name));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('to review: who claims what, how and when', (tester) async {
    await _openClaims(tester, _queueWith(claimFor(1)));

    expect(find.text('Ownership claims'), findsOneWidget);
    expect(find.text('Organic Cotton Tee'), findsOneWidget);
    expect(find.text('Ada Lovelace (ada@example.com)'), findsOneWidget);
    expect(find.text('Receipt 2 of 5'), findsOneWidget);
    expect(find.text('12 Nov 2026'), findsOneWidget);
    expect(find.text('1'), findsOneWidget); // the tab count
  });

  testWidgets('tabs: each status has its own list and empty state', (
    tester,
  ) async {
    final repository = FakeAdminClaimRepository();
    await _openClaims(tester, repository);
    expect(find.text('Nothing to review'), findsOneWidget);
    expect(
      find.text('Receipts shoppers upload appear here, oldest first.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Approved'));
    await tester.pumpAndSettle();
    expect(find.text('No approved claims yet'), findsOneWidget);
    expect(
      find.text('Decisions you make will be listed here.'),
      findsOneWidget,
    );
    expect(repository.requests.map((request) => request.status), [
      ClaimStatus.pending,
      ClaimStatus.approved,
    ]);
  });

  testWidgets('review: the receipt, what to check, the shopper, the tag', (
    tester,
  ) async {
    await _openClaims(tester, _queueWith(claimFor(1)));
    await _openClaim(tester, claimFor(1));

    expect(find.text('Ada Lovelace: Organic Cotton Tee'), findsOneWidget);
    expect(find.text('Receipt 2 of 5, sent 12 Nov 2026.'), findsOneWidget);
    expect(
      find.bySemanticsLabel('Receipt uploaded by Ada Lovelace'),
      findsOneWidget,
    );
    expect(find.text('Tap the image to open it full size.'), findsOneWidget);
    expect(
      find.text('The shop or brand is Terra Threads or a stockist.'),
      findsOneWidget,
    );
    expect(
      find.text(
        'A line on the receipt matches Organic Cotton Tee (SKU TT-TEE-01).',
      ),
      findsOneWidget,
    );
    expect(find.text('All claims for this piece'), findsNothing);

    // Under the fake clock the photo is never decoded, so it lays out with
    // no height and a tap lands on nothing; decode it for real first.
    final photo = find.byType(Image).first;
    await tester.runAsync(
      () => precacheImage(
        tester.widget<Image>(photo).image,
        tester.element(photo),
      ),
    );
    await _tap(tester, photo);

    expect(find.text('Receipt'), findsOneWidget);
    expect(find.byType(InteractiveViewer), findsOneWidget);
  });

  testWidgets('approve: the website message, back to the queue', (
    tester,
  ) async {
    final claim = claimFor(1);
    final repository = _queueWith(
      claim,
      decisions: [detailOf(claimFor(1, status: ClaimStatus.approved))],
    );
    await _openClaims(tester, repository, asBrand: true);
    await _openClaim(tester, claim);

    await _tap(tester, find.text('Approve'));

    expect(repository.approved, [claim.id]);
    expect(
      find.text('Approved. The shopper is now the verified owner.'),
      findsOneWidget,
    );
    expect(find.text('Ownership claims'), findsOneWidget);
    expect(repository.requests.length, greaterThan(1)); // reloaded
  });

  testWidgets('reject: a reason is needed; the common ones fill it in', (
    tester,
  ) async {
    final claim = claimFor(1);
    final repository = _queueWith(
      claim,
      decisions: [detailOf(claimFor(1, status: ClaimStatus.rejected))],
    );
    await _openClaims(tester, repository, asBrand: true);
    await _openClaim(tester, claim);

    await _tap(tester, find.text('Reject'));
    expect(find.text("They'll have 3 uploads left."), findsOneWidget);
    await _tap(tester, find.text('Reject receipt'));
    expect(
      find.text('Tell the shopper what was wrong so they can fix it'),
      findsOneWidget,
    );

    await _tap(tester, find.text('Part of the receipt is cut off'));
    await _tap(tester, find.text('Reject receipt'));

    expect(repository.rejected, [(claim.id, 'Part of the receipt is cut off')]);
    expect(
      find.text('Rejected. The shopper will see your reason.'),
      findsOneWidget,
    );
  });

  testWidgets('the last upload is called out before rejecting', (tester) async {
    final claim = claimFor(1, receiptAttempt: 5);
    await _openClaims(tester, _queueWith(claim), asBrand: true);
    await _openClaim(tester, claim);

    await _tap(tester, find.text('Reject'));

    expect(
      find.text(
        "This was their last upload: rejecting it means they can't verify "
        'this piece.',
      ),
      findsOneWidget,
    );
    await _tap(tester, find.text('Back'));
    expect(find.text('Approve'), findsOneWidget);
  });

  testWidgets('already reviewed elsewhere: the API reason, no change', (
    tester,
  ) async {
    const reason = 'This claim has already been reviewed';
    final claim = claimFor(1);
    await _openClaims(
      tester,
      _queueWith(
        claim,
        decisions: [
          const Err(ConflictFailure([reason])),
        ],
      ),
      asBrand: true,
    );
    await _openClaim(tester, claim);

    await _tap(tester, find.text('Approve'));

    expect(find.text(reason), findsOneWidget);
    expect(find.text('Your decision'), findsOneWidget);
  });

  testWidgets('a decided claim shows the outcome and every claim for it', (
    tester,
  ) async {
    final earlier = claimFor(
      2,
      status: ClaimStatus.rejected,
      receiptAttempt: 1,
      rejectionReason: 'The receipt is too blurry to read',
    );
    final claim = claimFor(1, status: ClaimStatus.approved);
    await _openClaims(tester, _queueWith(claim, history: [earlier, claim]));
    await _openClaim(tester, claim);

    expect(find.text('Approved 14 Nov 2026 by Sam Admin'), findsNWidgets(2));
    expect(find.text('Your decision'), findsNothing);
    expect(find.text('All claims for this piece'), findsOneWidget);
    expect(find.text('Receipt 2 (this one)'), findsOneWidget);
    expect(find.text('Rejected 14 Nov 2026 by Sam Admin'), findsOneWidget);
    expect(find.text('“The receipt is too blurry to read”'), findsOneWidget);
  });

  testWidgets('an order match has no receipt to see', (tester) async {
    final claim = claimFor(
      1,
      method: ClaimMethod.orderMatch,
      status: ClaimStatus.approved,
    );
    await _openClaims(tester, _queueWith(claim));
    await _openClaim(tester, claim);

    expect(
      find.text('Matched automatically to a paid order on 12 Nov 2026.'),
      findsOneWidget,
    );
    expect(
      find.text('No receipt: this claim was verified from order ORD-1042.'),
      findsOneWidget,
    );
  });

  testWidgets('a PDF receipt is offered to open', (tester) async {
    final claim = claimFor(1, mimeType: 'application/pdf');
    await _openClaims(tester, _queueWith(claim));
    await _openClaim(tester, claim);

    expect(find.text('Open the PDF receipt'), findsOneWidget);
    expect(find.text('Tap the image to open it full size.'), findsNothing);
  });

  testWidgets('a claim that does not exist', (tester) async {
    await _openClaims(
      tester,
      FakeAdminClaimRepository(
        pages: (_) => Ok(ClaimPage(items: [claimFor(1)], total: 1)),
      ),
    );
    await _openClaim(tester, claimFor(1));

    expect(find.text('This page could not be found.'), findsOneWidget);
    await _tap(tester, find.widgetWithText(OutlinedButton, 'Claims'));
    expect(find.text('Ownership claims'), findsOneWidget);
  });

  testWidgets('more claims load as the list scrolls', (tester) async {
    final repository = FakeAdminClaimRepository(
      pages: (request) => Ok(
        ClaimPage(
          items: [
            for (var n = 1; n <= (request.page == 1 ? 20 : 5); n++)
              claimFor(
                (request.page - 1) * 20 + n,
                productName: 'Piece ${(request.page - 1) * 20 + n}',
              ),
          ],
          total: 25,
        ),
      ),
    );
    await _openClaims(tester, repository);

    await tester.fling(
      find.byType(CustomScrollView),
      const Offset(0, -4000),
      4000,
    );
    await tester.pumpAndSettle();

    expect(repository.requests.map((request) => request.page), [1, 2]);
    expect(find.text('Piece 25'), findsOneWidget);
  });

  group('admin overrule (V2-12)', () {
    testWidgets('a pending claim: no Approve, but Approve instead or Reject '
        'instead, with a reason', (tester) async {
      final claim = claimFor(1);
      final repository = _queueWith(
        claim,
        decisions: [detailOf(claimFor(1, status: ClaimStatus.approved))],
      );
      await _openClaims(tester, repository);
      await _openClaim(tester, claim);

      expect(find.text('Overrule Terra Threads'), findsOneWidget);
      expect(find.text('Approve'), findsNothing);
      expect(find.text('Reject instead'), findsOneWidget);
      await _tap(tester, find.text('Approve instead'));
      expect(find.text('Approve this claim?'), findsOneWidget);

      await _tap(tester, find.widgetWithText(FilledButton, 'Approve'));
      expect(find.text('Write at least 3 characters.'), findsOneWidget);
      expect(repository.overruled, isEmpty);

      await tester.enterText(
        find.byType(TextFormField),
        '  Brand has no team yet; the receipt is clear.  ',
      );
      await _tap(tester, find.widgetWithText(FilledButton, 'Approve'));

      expect(repository.overruled, [
        (
          claim.id,
          ClaimStatus.approved,
          'Brand has no team yet; the receipt is clear.',
        ),
      ]);
      expect(
        find.text('Approved. The shopper is now the verified owner.'),
        findsOneWidget,
      );
      expect(find.text('Ownership claims'), findsOneWidget);
    });

    testWidgets('an approved claim can only be rejected instead', (
      tester,
    ) async {
      final claim = claimFor(1, status: ClaimStatus.approved);
      await _openClaims(tester, _queueWith(claim));
      await _openClaim(tester, claim);

      expect(find.text('Reject instead'), findsOneWidget);
      expect(find.text('Approve instead'), findsNothing);
    });

    testWidgets("refused: the API's reason stays in the sheet", (tester) async {
      final claim = claimFor(1, status: ClaimStatus.rejected);
      final repository = _queueWith(
        claim,
        decisions: [
          const Err(ConflictFailure(['A dispute is open for this claim'])),
        ],
      );
      await _openClaims(tester, repository);
      await _openClaim(tester, claim);
      await _tap(tester, find.text('Approve instead'));
      await tester.enterText(find.byType(TextFormField), 'Clear receipt.');
      await _tap(tester, find.widgetWithText(FilledButton, 'Approve'));

      expect(find.text('A dispute is open for this claim'), findsOneWidget);
      expect(find.text('Approve this claim?'), findsOneWidget);
    });
  });
}
