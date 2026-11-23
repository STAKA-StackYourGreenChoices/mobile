import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/auth/auth_tokens.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/features/auth/domain/models/otp_challenge.dart';
import 'package:staka/shared/widgets/inputs/app_otp_field.dart';

import '../../helpers/account_fakes.dart';
import '../../helpers/auth_fakes.dart';
import '../../helpers/fake_http_adapter.dart';
import '../../helpers/pump_full_app.dart';
import '../../helpers/tag_fakes.dart';

const _tokens = AuthTokens(accessToken: 'a0', refreshToken: 'r0');
final _today = DateTime(2026, 11, 23, 10);

/// Signed up with a phone number: no email, no password.
Map<String, Object?> _phoneOnlyJson() => {
  ...userJson(),
  'email': null,
  'emailVerified': false,
  'phone': '+919876543210',
  'phoneVerified': true,
  'hasPassword': false,
};

Finder _field(String label) => find.descendant(
  of: find.ancestor(of: find.text(label), matching: find.byType(Column)).first,
  matching: find.byType(EditableText),
);

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

/// Signed in as [user], on the Account tab.
Future<InMemoryTokenStore> _openAccount(
  WidgetTester tester, {
  Map<String, Object?>? user,
  FakeAccountRepository? account,
  FakeAuthRepository? auth,
  FakeShareActions? share,
}) async {
  final store = await pumpApp(
    tester,
    tokens: _tokens,
    replies: [json(200, user ?? userJson())],
    account: account,
    auth: auth,
    shareActions: share,
    clock: () => _today,
  );
  await tester.tap(find.text('Account'));
  await tester.pumpAndSettle();
  return store;
}

void main() {
  testWidgets('Download my data hands the API file to the share sheet', (
    tester,
  ) async {
    const body = '{"profile":{"name":"Ada Lovelace"}}';
    final share = FakeShareActions();
    final account = FakeAccountRepository(
      exports: [Ok(Uint8List.fromList(utf8.encode(body)))],
    );
    await _openAccount(tester, account: account, share: share);

    await _tap(tester, find.text('Download my data'));

    expect(share.sharedFiles, [
      (
        fileName: 'staka-data-2026-11-23.json',
        mimeType: 'application/json',
        text: body,
      ),
    ]);
  });

  testWidgets('Download my data offline says so', (tester) async {
    final share = FakeShareActions();
    await _openAccount(
      tester,
      account: FakeAccountRepository(exports: [const Err(NetworkFailure())]),
      share: share,
    );

    await _tap(tester, find.text('Download my data'));

    expect(find.textContaining('connection'), findsOneWidget);
    expect(share.sharedFiles, isEmpty);
  });

  testWidgets('delete with the password: wrong first, then gone to welcome', (
    tester,
  ) async {
    final account = FakeAccountRepository(
      requests: [
        const Err(UnauthorizedFailure(['Invalid password'])),
        const Ok(null),
      ],
    );
    final store = await _openAccount(tester, account: account);

    await _tap(tester, find.text('Delete my account'));
    expect(find.text('Delete your account'), findsOneWidget);
    expect(find.text("You're signed out on every device."), findsOneWidget);

    await tester.enterText(_field('Password'), 'wrong one');
    await _tap(tester, find.widgetWithText(FilledButton, 'Delete my account'));
    expect(
      find.text("That isn't your password. Check it and try again."),
      findsOneWidget,
    );
    // Still signed in: a wrong password is not an expired session.
    expect(store.tokens, isNotNull);

    await tester.enterText(_field('Password'), 'correct horse');
    await _tap(tester, find.widgetWithText(FilledButton, 'Delete my account'));

    expect(find.text('Your account has been deleted.'), findsOneWidget);
    expect(find.text('Continue with phone number'), findsOneWidget);
    expect(store.tokens, isNull);
    expect(account.calls.last, {'call': 'delete', 'password': 'correct horse'});
  });

  testWidgets('a phone-only account confirms with a code, by the button', (
    tester,
  ) async {
    final auth = FakeAuthRepository(
      [],
      codes: [
        const Ok(
          OtpChallenge(
            id: 'c1',
            phone: '+919876543210',
            expiresIn: Duration(minutes: 5),
            resendIn: Duration(seconds: 30),
          ),
        ),
      ],
    );
    final account = FakeAccountRepository(requests: [const Ok(null)]);
    final store = await _openAccount(
      tester,
      user: _phoneOnlyJson(),
      account: account,
      auth: auth,
    );

    await _tap(tester, find.text('Delete my account'));
    expect(
      find.text("We'll text a code to +91 98765 43210 to confirm."),
      findsOneWidget,
    );
    await _tap(tester, find.widgetWithText(FilledButton, 'Send code'));
    expect(auth.calls.single, {'call': 'otpRequest', 'phone': '+919876543210'});

    // Six digits alone don't delete anything.
    await tester.enterText(
      find.descendant(
        of: find.byType(AppOtpField),
        matching: find.byType(EditableText),
      ),
      '123456',
    );
    await tester.pumpAndSettle();
    expect(account.calls, isEmpty);

    await _tap(tester, find.widgetWithText(FilledButton, 'Delete my account'));

    expect(account.calls.single, {
      'call': 'delete',
      'challengeId': 'c1',
      'code': '123456',
    });
    expect(find.text('Your account has been deleted.'), findsOneWidget);
    expect(store.tokens, isNull);
  });
}
