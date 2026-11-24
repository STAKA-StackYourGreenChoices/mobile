import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/auth/auth_tokens.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/ownership.dart';
import 'package:staka/features/manage/claims/domain/models/claim.dart';
import 'package:staka/features/manage/disputes/domain/admin_dispute.dart';

import '../../helpers/admin_claim_fakes.dart';
import '../../helpers/admin_review_fakes.dart';
import '../../helpers/auth_fakes.dart';
import '../../helpers/fake_http_adapter.dart';
import '../../helpers/pump_app.dart';
import '../../helpers/pump_full_app.dart';

const _tokens = AuthTokens(accessToken: 'a', refreshToken: 'r');

final Claim _claim = claimFor(
  1,
  status: ClaimStatus.rejected,
  rejectionReason: 'The receipt is from another shop.',
);

FakeAdminClaimRepository _claims() => FakeAdminClaimRepository(
  details: {_claim.id: detailOf(_claim)},
  receipts: {
    _claim.id: Ok(ClaimReceipt(bytes: onePixelPng, mimeType: 'image/png')),
  },
);

Future<void> _pump(WidgetTester tester, FakeDisputeRepository disputes) async {
  usePhoneScreen(tester, height: 800);
  await pumpApp(
    tester,
    tokens: _tokens,
    replies: [json(200, userJson(role: 'ADMIN'))],
    disputes: disputes,
    adminClaims: _claims(),
  );
  await tester.tap(
    find.descendant(
      of: find.byType(NavigationBar),
      matching: find.text('Admin'),
    ),
  );
  await tester.pumpAndSettle();
}

/// Signs in as an admin and opens Admin → Disputes on a 360 × 800 phone.
Future<void> _openDisputes(
  WidgetTester tester,
  FakeDisputeRepository disputes,
) async {
  await _pump(tester, disputes);
  await _tap(tester, find.text('Disputes'));
}

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> _openDispute(WidgetTester tester) =>
    _tap(tester, find.textContaining('Organic Cotton Tee').first);

FakeDisputeRepository _open({List<Result<void>> resolutions = const []}) =>
    FakeDisputeRepository(
      lists: {
        DisputeStatus.open: Ok([disputeOf(_claim)]),
      },
      resolutions: resolutions,
    );

void main() {
  testWidgets('the hub counts disputes waiting', (tester) async {
    await _pump(tester, _open());

    expect(find.text('1 dispute is waiting.'), findsOneWidget);
  });

  testWidgets('a dispute: what the shopper wrote and why the brand said no', (
    tester,
  ) async {
    await _openDisputes(tester, _open());
    for (final tab in ['To decide', 'Kept', 'Approved']) {
      expect(find.text(tab), findsWidgets);
    }

    await _openDispute(tester);

    expect(find.text('Organic Cotton Tee'), findsWidgets);
    expect(find.text('What the shopper wrote'), findsOneWidget);
    expect(
      find.text('This is the Terra Threads shop in Pune; the tee is line 2.'),
      findsOneWidget,
    );
    expect(find.text('Why Terra Threads turned it down'), findsOneWidget);
    expect(find.text('The receipt is from another shop.'), findsOneWidget);
    expect(find.text('Approve the receipt'), findsOneWidget);
    expect(find.text('Keep the decision'), findsOneWidget);
  });

  testWidgets('approve the receipt: a note is needed, then the snackbar', (
    tester,
  ) async {
    final disputes = _open(resolutions: [const Ok(null)]);
    await _openDisputes(tester, disputes);
    await _openDispute(tester);

    await _tap(tester, find.text('Approve the receipt'));
    expect(find.text('Approve this receipt?'), findsOneWidget);
    await _tap(
      tester,
      find.widgetWithText(FilledButton, 'Approve the receipt').last,
    );
    expect(find.text('Write at least 3 characters.'), findsOneWidget);
    expect(disputes.resolved, isEmpty);

    await tester.enterText(
      find.byType(TextFormField),
      '  The shop is a Terra Threads outlet.  ',
    );
    await _tap(
      tester,
      find.widgetWithText(FilledButton, 'Approve the receipt').last,
    );

    expect(disputes.resolved, [
      ('d1', DisputeOutcome.overturn, 'The shop is a Terra Threads outlet.'),
    ]);
    expect(
      find.text('Approved. The shopper is now the verified owner.'),
      findsOneWidget,
    );
  });

  testWidgets("keep the brand's decision with a note", (tester) async {
    final disputes = _open(resolutions: [const Ok(null)]);
    await _openDisputes(tester, disputes);
    await _openDispute(tester);

    await _tap(tester, find.text('Keep the decision'));
    expect(find.text("Keep Terra Threads's decision?"), findsOneWidget);
    await tester.enterText(find.byType(TextFormField), 'Wrong product.');
    await _tap(tester, find.widgetWithText(FilledButton, 'Keep the decision'));

    expect(disputes.resolved, [
      ('d1', DisputeOutcome.uphold, 'Wrong product.'),
    ]);
    expect(
      find.text('Decision kept. The shopper sees your note.'),
      findsOneWidget,
    );
  });

  testWidgets("refused: the API's reason stays in the sheet", (tester) async {
    final disputes = _open(
      resolutions: [
        const Err(ConflictFailure(['Dispute is already resolved'])),
      ],
    );
    await _openDisputes(tester, disputes);
    await _openDispute(tester);

    await _tap(tester, find.text('Keep the decision'));
    await tester.enterText(find.byType(TextFormField), 'Wrong product.');
    await _tap(tester, find.widgetWithText(FilledButton, 'Keep the decision'));

    expect(find.text('Dispute is already resolved'), findsOneWidget);
    expect(find.text("Keep Terra Threads's decision?"), findsOneWidget);
  });

  testWidgets('a settled dispute says how, when, and the note', (tester) async {
    await _openDisputes(
      tester,
      FakeDisputeRepository(
        lists: {
          DisputeStatus.upheld: Ok([
            disputeOf(
              _claim,
              status: DisputeStatus.upheld,
              resolution: 'Wrong product.',
              resolvedAt: DateTime(2026, 11, 23, 12),
            ),
          ]),
        },
      ),
    );
    expect(find.text('No disputes are waiting.'), findsOneWidget);

    await _tap(tester, find.text('Kept').first);
    await _openDispute(tester);

    expect(
      find.text("The brand's decision was kept on 23 Nov 2026."),
      findsOneWidget,
    );
    expect(find.text('Note: Wrong product.'), findsOneWidget);
    expect(find.text('Keep the decision'), findsNothing);
  });
}
