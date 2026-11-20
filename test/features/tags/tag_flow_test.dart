import 'package:flutter_test/flutter_test.dart';
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

Ownership _ownership(
  OwnershipStatus status, {
  int left = 5,
  ClaimMethod? method,
  DateTime? at,
  String? reason,
}) => Ownership(
  status: status,
  receiptAttemptsUsed: 5 - left,
  receiptAttemptsLeft: left,
  method: method,
  verifiedAt: status == OwnershipStatus.verified ? at : null,
  pendingSince: status == OwnershipStatus.pending ? at : null,
  lastRejectionReason: reason,
);

DigitalCard _card(Ownership ownership) =>
    cardFor(id: 'c1', name: _name, ownership: ownership);

/// Opens the wardrobe and taps the tag, like a shopper would.
Future<(FakeTagRepository, FakeWardrobeRepository)> _openTag(
  WidgetTester tester,
  DigitalCard card, {
  List<Result<Ownership>> matches = const [],
  List<Result<Ownership>> uploads = const [],
  FakeReceiptPicker? picker,
}) async {
  usePhoneScreen(tester, height: 2600);
  final tags = FakeTagRepository(
    cards: [card],
    matches: matches,
    uploads: uploads,
  );
  final wardrobe = FakeWardrobeRepository(
    cards: [
      Ok([card]),
    ],
  );
  await pumpApp(
    tester,
    tokens: const AuthTokens(accessToken: 'a', refreshToken: 'r'),
    replies: [json(200, userJson())],
    wardrobe: wardrobe,
    tags: tags,
    receiptPicker: picker,
  );
  await tester.tap(find.text(_name).first);
  await tester.pumpAndSettle();
  return (tags, wardrobe);
}

void main() {
  final nov10 = DateTime(2026, 11, 10, 12);

  testWidgets('verified by an order: the date and how', (tester) async {
    await _openTag(
      tester,
      _card(
        _ownership(
          OwnershipStatus.verified,
          method: ClaimMethod.orderMatch,
          at: nov10,
        ),
      ),
    );

    expect(find.text("You're the verified owner"), findsOneWidget);
    expect(
      find.text(
        'We matched this piece to a paid order on your account on '
        '10 Nov 2026. It counts toward your wardrobe.',
      ),
      findsOneWidget,
    );
    expect(find.text('Prove you own it'), findsNothing);
  });

  testWidgets('pending: when it was sent and uploads left', (tester) async {
    await _openTag(
      tester,
      _card(_ownership(OwnershipStatus.pending, left: 4, at: nov10)),
    );

    expect(find.text('Receipt under review'), findsWidgets);
    expect(
      find.text(
        'Sent 10 Nov 2026. An admin will check it, and the result shows up '
        'here. 4 of 5 uploads left.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('blocked: all uploads used, with the last reason', (
    tester,
  ) async {
    await _openTag(
      tester,
      _card(
        _ownership(OwnershipStatus.blocked, left: 0, reason: 'Blurry photo'),
      ),
    );

    expect(find.text("This piece can't be verified"), findsOneWidget);
    expect(
      find.text(
        'All 5 receipt uploads for it were used. The last one was turned '
        'down: Blurry photo. You can still keep its tag.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('rejected: the reason above both ways to prove it', (
    tester,
  ) async {
    await _openTag(
      tester,
      _card(
        _ownership(OwnershipStatus.rejected, left: 1, reason: 'Wrong shop'),
      ),
    );

    expect(
      find.text(
        'Your last receipt was turned down: Wrong shop. 1 upload left.',
      ),
      findsOneWidget,
    );
    expect(find.text('Find it in my orders'), findsOneWidget);
    expect(find.text('Upload a receipt'), findsOneWidget);
  });

  testWidgets('found in orders: verified at once, wardrobe reloads', (
    tester,
  ) async {
    final (_, wardrobe) = await _openTag(
      tester,
      _card(_ownership(OwnershipStatus.unverified)),
      matches: [
        Ok(
          _ownership(
            OwnershipStatus.verified,
            method: ClaimMethod.orderMatch,
            at: nov10,
          ),
        ),
      ],
    );
    final before = wardrobe.fetches;

    await tester.tap(find.text('Find it in my orders'));
    await tester.pumpAndSettle();

    expect(find.text("You're the verified owner"), findsOneWidget);
    expect(find.text('Verified: we found it in your orders.'), findsOneWidget);
    expect(wardrobe.fetches, greaterThan(before));
  });

  testWidgets('no paid order: says so and points to a receipt', (tester) async {
    await _openTag(
      tester,
      _card(_ownership(OwnershipStatus.unverified)),
      matches: [
        const Err(NotFoundFailure(['not found'])),
      ],
    );

    await tester.tap(find.text('Find it in my orders'));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'No paid order on your account includes this piece. Upload a '
        'receipt instead.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('receipt: choose a photo, send it, now under review', (
    tester,
  ) async {
    final picker = FakeReceiptPicker(receiptOf(1024 * 1024));
    final (tags, _) = await _openTag(
      tester,
      _card(_ownership(OwnershipStatus.unverified)),
      picker: picker,
      uploads: [Ok(_ownership(OwnershipStatus.pending, left: 4, at: nov10))],
    );

    expect(find.text('Send for review'), findsOneWidget);
    await tester.tap(find.text('Choose a photo or PDF'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Take a photo'));
    await tester.pumpAndSettle();

    expect(find.text('receipt.jpg'), findsOneWidget);
    expect(find.text('1.0 MB. Tap to change.'), findsOneWidget);
    await tester.tap(find.text('Send for review'));
    await tester.pumpAndSettle();

    expect(tags.uploaded, hasLength(1));
    expect(find.text("Receipt sent. We'll check it soon."), findsOneWidget);
    expect(find.text('Upload a receipt'), findsNothing);
  });

  testWidgets('a file over 5 MB is refused before sending', (tester) async {
    final (tags, _) = await _openTag(
      tester,
      _card(_ownership(OwnershipStatus.unverified)),
      picker: FakeReceiptPicker(receiptOf(6 * 1024 * 1024, name: 'big.pdf')),
    );

    await tester.tap(find.text('Choose a photo or PDF'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Choose a PDF'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Send for review'));
    await tester.pumpAndSettle();

    expect(
      find.text('The file is over 5 MB. Take a smaller photo or crop it.'),
      findsOneWidget,
    );
    expect(tags.uploaded, isEmpty);
  });

  testWidgets("the API's reason for a refused file shows on the file", (
    tester,
  ) async {
    await _openTag(
      tester,
      _card(_ownership(OwnershipStatus.unverified)),
      picker: FakeReceiptPicker(receiptOf(2048, name: 'receipt.heic')),
      uploads: [
        const Err(
          BadRequestFailure(400, [
            'Upload a photo (JPG, PNG or WebP) or a PDF of the receipt',
          ]),
        ),
      ],
    );

    await tester.tap(find.text('Choose a photo or PDF'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Choose from your photos'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Send for review'));
    await tester.pumpAndSettle();

    expect(
      find.text('Upload a photo (JPG, PNG or WebP) or a PDF of the receipt'),
      findsOneWidget,
    );
  });

  testWidgets('Product details and Scan another piece', (tester) async {
    await _openTag(
      tester,
      _card(_ownership(OwnershipStatus.verified, method: ClaimMethod.receipt)),
    );

    expect(
      find.text(
        'An admin approved your receipt. It counts toward your wardrobe.',
      ),
      findsOneWidget,
    );
    await tester.tap(find.text('Scan another piece'));
    await tester.pumpAndSettle();
    expect(find.text('Scan a product'), findsOneWidget);
  });
}
