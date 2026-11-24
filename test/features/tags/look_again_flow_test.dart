import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/auth/auth_tokens.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/digital_card.dart';
import 'package:staka/core/models/ownership.dart';
import 'package:staka/core/models/ownership_status.dart';

import '../../helpers/auth_fakes.dart';
import '../../helpers/fake_http_adapter.dart';
import '../../helpers/pump_app.dart';
import '../../helpers/pump_full_app.dart';
import '../../helpers/tag_fakes.dart';
import '../../helpers/wardrobe_fakes.dart';

const _name = 'Organic Cotton Tee';

/// A receipt Terra Threads (or STAKA) decided, as the V2-12 API sends it.
Ownership _decided(
  OwnershipStatus status, {
  ClaimDecider decidedBy = ClaimDecider.brand,
  int left = 4,
  String? reason = 'Wrong shop',
  OwnershipDispute? dispute,
  DateTime? at,
}) => Ownership(
  status: status,
  receiptAttemptsUsed: 5 - left,
  receiptAttemptsLeft: left,
  method: ClaimMethod.receipt,
  verifiedAt: status == OwnershipStatus.verified ? at : null,
  pendingSince: status == OwnershipStatus.pending ? at : null,
  lastRejectionReason: status == OwnershipStatus.verified ? null : reason,
  decidedBy: decidedBy,
  brandName: 'Terra Threads',
  dispute: dispute,
);

DigitalCard _card(Ownership ownership) =>
    cardFor(id: 'c1', name: _name, ownership: ownership);

/// Opens the wardrobe and taps the tag, like a shopper would.
Future<FakeTagRepository> _openTag(
  WidgetTester tester,
  Ownership ownership, {
  List<Result<void>> lookAgains = const [],
}) async {
  usePhoneScreen(tester, height: 2600);
  final card = _card(ownership);
  final tags = FakeTagRepository(cards: [card], lookAgains: lookAgains);
  await pumpApp(
    tester,
    tokens: const AuthTokens(accessToken: 'a', refreshToken: 'r'),
    replies: [json(200, userJson())],
    wardrobe: FakeWardrobeRepository(
      cards: [
        Ok([card]),
      ],
    ),
    tags: tags,
  );
  await tester.tap(find.text(_name).first);
  await tester.pumpAndSettle();
  return tags;
}

Future<void> _tap(WidgetTester tester, Finder finder) async {
  FocusManager.instance.primaryFocus?.unfocus();
  await tester.pumpAndSettle();
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

final Finder _ask = find.text('Ask STAKA to look again');
final Finder _send = find.text('Send to STAKA');
final Finder _message = find.byType(TextFormField);

void main() {
  final nov10 = DateTime(2026, 11, 10, 12);

  testWidgets('a brand rejection names the brand and offers to ask STAKA', (
    tester,
  ) async {
    await _openTag(tester, _decided(OwnershipStatus.rejected));

    expect(
      find.text(
        "Terra Threads couldn't accept this receipt: Wrong shop. "
        '4 of 5 uploads left.',
      ),
      findsOneWidget,
    );
    expect(
      find.text(
        'Think Terra Threads got it wrong? STAKA can check the receipt again.',
      ),
      findsOneWidget,
    );
    expect(_ask, findsOneWidget);
    // Another receipt can still be sent, and the brand checks it.
    expect(find.text('Upload a receipt'), findsOneWidget);
    expect(
      find.textContaining('this piece. Terra Threads checks it.'),
      findsOneWidget,
    );
  });

  testWidgets('ask STAKA: a short message is refused, then it is sent', (
    tester,
  ) async {
    final tags = await _openTag(
      tester,
      _decided(OwnershipStatus.rejected),
      lookAgains: [const Ok(null)],
    );
    await _tap(tester, _ask);

    expect(find.text('10 to 1,000 characters.'), findsOneWidget);
    await tester.enterText(_message, '  too short  ');
    await _tap(tester, _send);
    expect(find.text('Write at least 10 characters.'), findsOneWidget);
    expect(tags.lookAgainMessages, isEmpty);

    await tester.enterText(_message, ' Right shop, right tee. ');
    await _tap(tester, _send);
    expect(tags.lookAgainMessages, ['Right shop, right tee.']);
  });

  testWidgets('once sent, the tag says STAKA is looking', (tester) async {
    final tags = await _openTag(
      tester,
      _decided(OwnershipStatus.rejected),
      lookAgains: [const Ok(null)],
    );
    await _tap(tester, _ask);
    await tester.enterText(
      _message,
      '  The receipt is from the Terra Threads shop in Pune.  ',
    );
    await _tap(tester, _send);

    expect(tags.lookAgainMessages, [
      'The receipt is from the Terra Threads shop in Pune.',
    ]);
    expect(find.text('Sent. STAKA is looking at this.'), findsOneWidget);
    expect(find.text('STAKA is looking at this'), findsOneWidget);
    expect(
      find.text(
        "We'll check your receipt and the reason Terra Threads gave. "
        'The result shows up here.',
      ),
      findsOneWidget,
    );
    expect(_ask, findsNothing);
  });

  testWidgets("asked already: the API's reason shows in the sheet", (
    tester,
  ) async {
    await _openTag(
      tester,
      _decided(OwnershipStatus.rejected),
      lookAgains: [
        const Err(ConflictFailure(['This claim was already disputed'])),
      ],
    );
    await _tap(tester, _ask);
    await tester.enterText(_message, 'It is the right shop, honestly.');
    await _tap(tester, _send);

    expect(find.text('This claim was already disputed'), findsOneWidget);
    expect(_send, findsOneWidget);
  });

  testWidgets('blocked by a brand rejection can still ask STAKA', (
    tester,
  ) async {
    await _openTag(tester, _decided(OwnershipStatus.blocked, left: 0));

    expect(
      find.text(
        "All 5 receipt uploads for it were used. Terra Threads couldn't "
        'accept the last one: Wrong shop. You can still keep its tag.',
      ),
      findsOneWidget,
    );
    expect(_ask, findsOneWidget);
  });

  testWidgets('STAKA kept the brand decision: its note, no second ask', (
    tester,
  ) async {
    await _openTag(
      tester,
      _decided(
        OwnershipStatus.rejected,
        dispute: const OwnershipDispute(
          status: DisputeStatus.upheld,
          resolution: 'The receipt is for a different product.',
        ),
      ),
    );

    expect(find.text('STAKA looked again'), findsOneWidget);
    expect(
      find.text(
        'STAKA agrees with Terra Threads: The receipt is for a different '
        'product.',
      ),
      findsOneWidget,
    );
    expect(_ask, findsNothing);
  });

  testWidgets('STAKA approved it after looking again', (tester) async {
    await _openTag(
      tester,
      _decided(
        OwnershipStatus.verified,
        at: nov10,
        dispute: const OwnershipDispute(status: DisputeStatus.overturned),
      ),
    );

    expect(
      find.text(
        'STAKA looked again and approved your receipt. It counts toward '
        'your wardrobe.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('the brand approved: named with the date', (tester) async {
    await _openTag(tester, _decided(OwnershipStatus.verified, at: nov10));
    expect(
      find.text(
        'Terra Threads approved your receipt on 10 Nov 2026. It counts '
        'toward your wardrobe.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('STAKA rejected: named, nobody to ask', (tester) async {
    await _openTag(
      tester,
      _decided(OwnershipStatus.rejected, decidedBy: ClaimDecider.admin),
    );

    expect(
      find.text(
        "STAKA couldn't accept this receipt: Wrong shop. 4 of 5 uploads left.",
      ),
      findsOneWidget,
    );
    expect(_ask, findsNothing);
  });

  testWidgets('under review: waiting for the brand', (tester) async {
    await _openTag(tester, _decided(OwnershipStatus.pending, at: nov10));

    expect(
      find.text(
        'Sent 10 Nov 2026. Waiting for Terra Threads to check it; the '
        'result shows up here. 4 of 5 uploads left.',
      ),
      findsOneWidget,
    );
  });
}
