import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/auth/auth_tokens.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/features/manage/claims/domain/models/claim.dart';

import '../../helpers/admin_claim_fakes.dart';
import '../../helpers/brand_portal_fakes.dart';
import '../../helpers/fake_http_adapter.dart';
import '../../helpers/product_fakes.dart';
import '../../helpers/pump_full_app.dart';

const _tokens = AuthTokens(accessToken: 'a0', refreshToken: 'r0');

Finder _tab(String label) =>
    find.descendant(of: find.byType(NavigationBar), matching: find.text(label));

Future<void> _tap(WidgetTester tester, Finder finder) async {
  FocusManager.instance.primaryFocus?.unfocus();
  await tester.pumpAndSettle();
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

/// A brand's queue holding [claim] while pending.
FakeAdminClaimRepository _queueWith(
  Claim claim, {
  List<Result<ClaimDetail>> decisions = const [],
}) => FakeAdminClaimRepository(
  pages: (request) => Ok(
    request.status == claim.status
        ? ClaimPage(items: [claim], total: 1)
        : const ClaimPage(items: [], total: 0),
  ),
  details: {claim.id: detailOf(claim)},
  receipts: {
    claim.id: Ok(ClaimReceipt(bytes: onePixelPng, mimeType: 'image/png')),
  },
  products: {'p1': Ok(productNamed('Organic Cotton Tee'))},
  decisions: decisions,
);

/// Ada, owner of Terra Threads, on the Brand tab.
Future<void> _openBrandTab(
  WidgetTester tester,
  FakeAdminClaimRepository claims,
) async {
  await pumpApp(
    tester,
    tokens: _tokens,
    replies: [
      json(200, memberUserJson([membershipJson()])),
    ],
    adminClaims: claims,
  );
  await _tap(tester, _tab('Brand'));
}

void main() {
  testWidgets('the hub says how many proofs of purchase wait', (tester) async {
    await _openBrandTab(tester, _queueWith(claimFor(1)));

    expect(find.text('1 proof of purchase is waiting for you.'), findsOne);
  });

  testWidgets('a brand approves a claim and lands back on its queue', (
    tester,
  ) async {
    final claim = claimFor(1);
    final claims = _queueWith(
      claim,
      decisions: [detailOf(claimFor(1, status: ClaimStatus.approved))],
    );
    await _openBrandTab(tester, claims);
    await _tap(tester, find.text('Claims'));

    expect(
      find.textContaining('Shoppers who bought your products'),
      findsOneWidget,
    );
    await _tap(tester, find.text(claim.product.name));
    await _tap(tester, find.text('Approve'));

    expect(claims.approved, [claim.id]);
    expect(
      find.text('Approved. The shopper is now the verified owner.'),
      findsOneWidget,
    );
    // Back on the brand's own queue, not the admin one.
    expect(find.textContaining('Shoppers who bought your products'), findsOne);
  });

  testWidgets('a brand rejects with a reason and opens the receipt', (
    tester,
  ) async {
    final claim = claimFor(1);
    final claims = _queueWith(
      claim,
      decisions: [detailOf(claimFor(1, status: ClaimStatus.rejected))],
    );
    await _openBrandTab(tester, claims);
    await _tap(tester, find.text('Claims'));
    await _tap(tester, find.text(claim.product.name));

    final photo = find.byType(Image).first;
    await tester.runAsync(
      () => precacheImage(
        tester.widget<Image>(photo).image,
        tester.element(photo),
      ),
    );
    await _tap(tester, photo);
    expect(find.byType(InteractiveViewer), findsOneWidget);
    await _tap(tester, find.byType(BackButton));

    await _tap(tester, find.text('Reject'));
    await _tap(tester, find.text('Part of the receipt is cut off'));
    await _tap(tester, find.text('Reject receipt'));

    expect(claims.rejected, [(claim.id, 'Part of the receipt is cut off')]);
    expect(
      find.text('Rejected. The shopper will see your reason.'),
      findsOneWidget,
    );
  });

  testWidgets('a claim another reviewer decided shows the API reason', (
    tester,
  ) async {
    final claim = claimFor(1);
    final claims = _queueWith(
      claim,
      decisions: [
        const Err(ConflictFailure(['This claim has already been reviewed'])),
      ],
    );
    await _openBrandTab(tester, claims);
    await _tap(tester, find.text('Claims'));
    await _tap(tester, find.text(claim.product.name));
    await _tap(tester, find.text('Approve'));

    expect(find.text('This claim has already been reviewed'), findsOneWidget);
  });
}
