import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/auth/auth_tokens.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/user.dart';
import 'package:staka/features/auth/domain/models/otp_challenge.dart';
import 'package:staka/shared/widgets/inputs/app_otp_field.dart';

import '../../helpers/account_fakes.dart';
import '../../helpers/auth_fakes.dart';
import '../../helpers/fake_http_adapter.dart';
import '../../helpers/pump_full_app.dart';

const _tokens = AuthTokens(accessToken: 'a0', refreshToken: 'r0');
final _start = DateTime.utc(2026, 11, 23, 10);

/// Signed up with a phone number: no email, no password.
Map<String, Object?> _phoneOnlyJson() => {
  ...userJson(),
  'email': null,
  'emailVerified': false,
  'phone': '+919876543210',
  'phoneVerified': true,
  'hasPassword': false,
};

/// Email, password and a phone number.
Map<String, Object?> _allMethodsJson() => {
  ...userJson(),
  'phone': '+919876543210',
  'phoneVerified': true,
  'hasPassword': true,
};

const _challenge = OtpChallenge(
  id: 'c1',
  phone: '+919123456789',
  expiresIn: Duration(minutes: 5),
  resendIn: Duration(seconds: 30),
);

const _emailUserWithPhone = User(
  id: 'u1',
  email: 'ada@example.com',
  name: 'Ada Lovelace',
  role: Role.user,
  emailVerified: true,
  phone: '+919123456789',
  phoneVerified: true,
);

Finder _field(String label) => find.descendant(
  of: find.ancestor(of: find.text(label), matching: find.byType(Column)).first,
  matching: find.byType(EditableText),
);

Finder get _codeField => find.descendant(
  of: find.byType(AppOtpField),
  matching: find.byType(EditableText),
);

/// Signed in as [user], on the Account tab.
Future<void> _openAccount(
  WidgetTester tester, {
  required Map<String, Object?> user,
  FakeAccountRepository? account,
}) async {
  await pumpApp(
    tester,
    tokens: _tokens,
    replies: [json(200, user)],
    account: account,
    clock: () => _start,
  );
  await tester.tap(find.text('Account'));
  await tester.pumpAndSettle();
}

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Account shows how a phone-only account signs in', (
    tester,
  ) async {
    await _openAccount(tester, user: _phoneOnlyJson());

    expect(find.text('How you sign in'), findsOneWidget);
    // The header and the phone row both show the number.
    expect(find.text('+91 98765 43210'), findsNWidgets(2));
    expect(find.text('Not added'), findsOneWidget);
    expect(find.text('Set a password'), findsOneWidget);
    expect(find.text('Change password'), findsNothing);
  });

  testWidgets('add a phone number: number, code, back to Account', (
    tester,
  ) async {
    final account = FakeAccountRepository(
      codes: [const Ok(_challenge)],
      verified: [const Ok(_emailUserWithPhone)],
    );
    await _openAccount(tester, user: userJson(), account: account);

    await _tap(tester, find.text('Phone number'));
    expect(
      find.text('Add a number to sign in with a 6-digit code we text you.'),
      findsOneWidget,
    );
    await tester.enterText(_field('Mobile number'), '91234 56789');
    await _tap(tester, find.widgetWithText(FilledButton, 'Send code'));
    expect(find.text('Enter the code'), findsOneWidget);

    await tester.enterText(_codeField, '123456');
    await tester.pumpAndSettle();

    expect(find.text('Phone number saved.'), findsOneWidget);
    expect(find.text('How you sign in'), findsOneWidget);
    expect(find.text('+91 91234 56789'), findsOneWidget);
    expect(account.calls, [
      {'call': 'phoneCode', 'phone': '+919123456789'},
      {'call': 'verifyPhone', 'challengeId': 'c1', 'code': '123456'},
    ]);
  });

  testWidgets('a number on another account, then a wrong code', (tester) async {
    await _openAccount(
      tester,
      user: userJson(),
      account: FakeAccountRepository(
        codes: [
          const Err(ConflictFailure(['Phone number already in use'])),
          const Ok(_challenge),
        ],
        verified: [
          const Err(UnauthorizedFailure(['Invalid code'])),
        ],
      ),
    );
    await _tap(tester, find.text('Phone number'));

    await tester.enterText(_field('Mobile number'), '9123456789');
    await _tap(tester, find.widgetWithText(FilledButton, 'Send code'));
    expect(
      find.text('That number is on another STAKA account.'),
      findsOneWidget,
    );

    await _tap(tester, find.widgetWithText(FilledButton, 'Send code'));
    await tester.enterText(_codeField, '111111');
    await tester.pumpAndSettle();
    expect(
      find.text("That code isn't right. Check the message and try again."),
      findsOneWidget,
    );
    // Still signed in: a wrong code is not an expired session.
    expect(find.text('Enter the code'), findsOneWidget);
  });

  testWidgets('remove the number when email + password remain', (tester) async {
    final account = FakeAccountRepository(requests: [const Ok(null)]);
    await _openAccount(tester, user: _allMethodsJson(), account: account);

    await _tap(tester, find.text('Phone number'));
    await _tap(tester, find.text('Remove number'));
    expect(find.text('Remove +91 98765 43210?'), findsOneWidget);
    await _tap(tester, find.widgetWithText(FilledButton, 'Remove number'));

    expect(find.text('Phone number removed.'), findsOneWidget);
    expect(find.text('How you sign in'), findsOneWidget);
    expect(find.text('Not added'), findsOneWidget);
    expect(account.calls, [
      {'call': 'removePhone'},
    ]);
  });

  testWidgets('the only way to sign in cannot be removed', (tester) async {
    await _openAccount(tester, user: _phoneOnlyJson());

    await _tap(tester, find.text('Phone number'));

    expect(find.text('Remove number'), findsNothing);
    expect(
      find.text(
        'This number is how you sign in. To remove it, first add an email '
        'and set a password.',
      ),
      findsOneWidget,
    );
    expect(find.text('Change number'), findsOneWidget);
  });

  testWidgets('add an email to a phone-only account', (tester) async {
    final account = FakeAccountRepository(
      requests: [
        const Err(ConflictFailure(['Email already in use'])),
        const Ok(null),
      ],
    );
    await _openAccount(tester, user: _phoneOnlyJson(), account: account);

    await _tap(tester, find.text('Email'));
    expect(find.text('Add an email'), findsOneWidget);

    await tester.enterText(_field('Email'), 'taken@example.com');
    await _tap(tester, find.widgetWithText(FilledButton, 'Add email'));
    expect(find.text('An account already uses this email.'), findsOneWidget);

    await tester.enterText(_field('Email'), ' ada@example.com ');
    await _tap(tester, find.widgetWithText(FilledButton, 'Add email'));

    expect(
      find.text(
        'Check your inbox: we sent a confirmation link to ada@example.com.',
      ),
      findsOneWidget,
    );
    expect(find.text('ada@example.com · not confirmed yet'), findsOneWidget);
    expect(account.calls.last, {
      'call': 'addEmail',
      'email': 'ada@example.com',
    });
  });

  testWidgets('set a first password; Account then offers to change it', (
    tester,
  ) async {
    final account = FakeAccountRepository(requests: [const Ok(null)]);
    await _openAccount(tester, user: _phoneOnlyJson(), account: account);

    await _tap(tester, find.text('Set a password'));
    await tester.enterText(_field('New password'), 'correct horse');
    await tester.enterText(_field('Confirm new password'), 'correct horse');
    await _tap(tester, find.widgetWithText(FilledButton, 'Set password'));

    expect(find.text('Password set.'), findsOneWidget);
    expect(find.text('Change password'), findsOneWidget);
    expect(account.calls.single, {
      'call': 'setPassword',
      'newPassword': 'correct horse',
    });
  });

  testWidgets('a short or mismatched password is caught before sending', (
    tester,
  ) async {
    final account = FakeAccountRepository();
    await _openAccount(tester, user: _phoneOnlyJson(), account: account);

    await _tap(tester, find.text('Set a password'));
    await tester.enterText(_field('New password'), 'short');
    await tester.enterText(_field('Confirm new password'), 'other');
    await _tap(tester, find.widgetWithText(FilledButton, 'Set password'));

    expect(find.text('Use at least 8 characters'), findsOneWidget);
    expect(account.calls, isEmpty);
  });
}
