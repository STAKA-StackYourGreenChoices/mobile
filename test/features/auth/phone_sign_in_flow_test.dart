import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/auth/auth_tokens.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/user.dart';
import 'package:staka/features/auth/domain/models/auth_session.dart';
import 'package:staka/features/auth/domain/models/otp_challenge.dart';
import 'package:staka/features/auth/domain/models/otp_verification.dart';
import 'package:staka/shared/widgets/inputs/app_otp_field.dart';

import '../../helpers/pump_full_app.dart';

const _phoneUser = User(
  id: 'u1',
  email: null,
  name: 'Ada Lovelace',
  role: Role.user,
  emailVerified: false,
  phone: '+919876543210',
  phoneVerified: true,
  hasPassword: false,
);

const _session = AuthSession(
  tokens: AuthTokens(accessToken: 'a1', refreshToken: 'r1'),
  user: _phoneUser,
);

const _challenge = OtpChallenge(
  id: 'c1',
  phone: '+919876543210',
  expiresIn: Duration(minutes: 5),
  resendIn: Duration(seconds: 30),
);

Finder get _phoneField => find.descendant(
  of: find
      .ancestor(of: find.text('Mobile number'), matching: find.byType(Column))
      .first,
  matching: find.byType(EditableText),
);

Finder get _codeField => find.descendant(
  of: find.byType(AppOtpField),
  matching: find.byType(EditableText),
);

/// Welcome → phone → "Send code" with [typed].
Future<void> _sendCode(WidgetTester tester, String typed) async {
  await tester.tap(find.text('Continue with phone number'));
  await tester.pumpAndSettle();
  await tester.enterText(_phoneField, typed);
  await tester.tap(find.widgetWithText(FilledButton, 'Send code'));
  await tester.pumpAndSettle();
}

void main() {
  final start = DateTime.utc(2026, 11, 23, 10);

  testWidgets('a known number: number, code, straight into the wardrobe', (
    tester,
  ) async {
    final auth = FakeAuthRepository(
      [],
      codes: [const Ok(_challenge)],
      checks: [const Ok(OtpSignedIn(_session, isNewUser: false))],
    );
    final store = await pumpApp(tester, auth: auth, clock: () => start);

    await _sendCode(tester, '98765 43210');
    expect(find.text('Enter the code'), findsOneWidget);
    expect(
      find.text(
        'We sent a 6-digit code to +91\u00A098765\u00A043210. '
        'It works for 5 minutes.',
      ),
      findsOneWidget,
    );

    // Six digits submit on their own.
    await tester.enterText(_codeField, '123456');
    await tester.pumpAndSettle();

    expect(find.text('My wardrobe'), findsOneWidget);
    expect(store.tokens, _session.tokens);
    expect(auth.calls, [
      {'call': 'otpRequest', 'phone': '+919876543210'},
      {'call': 'otpVerify', 'challengeId': 'c1', 'code': '123456'},
    ]);
  });

  testWidgets('a new number: asks for a name, then creates the account', (
    tester,
  ) async {
    final auth = FakeAuthRepository(
      [],
      codes: [const Ok(_challenge)],
      checks: [
        const Ok(OtpNameRequired()),
        const Ok(OtpSignedIn(_session, isNewUser: true)),
      ],
    );
    await pumpApp(tester, auth: auth, clock: () => start);

    await _sendCode(tester, '9876543210');
    await tester.enterText(_codeField, '123456');
    await tester.pumpAndSettle();
    expect(find.text('What should we call you?'), findsOneWidget);

    // An empty name is caught before sending.
    await tester.tap(find.widgetWithText(FilledButton, 'Create account'));
    await tester.pumpAndSettle();
    expect(auth.calls, hasLength(2));

    await tester.enterText(find.byType(EditableText), 'Ada Lovelace');
    await tester.tap(find.widgetWithText(FilledButton, 'Create account'));
    await tester.pumpAndSettle();

    // New accounts get the same welcome as email sign-up.
    expect(find.text('Welcome, Ada'), findsOneWidget);
    expect(auth.calls.last, {
      'call': 'otpVerify',
      'challengeId': 'c1',
      'code': '123456',
      'name': 'Ada Lovelace',
    });
  });

  testWidgets('wrong, then expired code: says which, stays on the code', (
    tester,
  ) async {
    await pumpApp(
      tester,
      auth: FakeAuthRepository(
        [],
        codes: [const Ok(_challenge)],
        checks: [
          const Err(UnauthorizedFailure(['Invalid code'])),
          const Err(BadRequestFailure(410, ['Code expired'])),
        ],
      ),
      clock: () => start,
    );
    await _sendCode(tester, '9876543210');

    await tester.enterText(_codeField, '111111');
    await tester.pumpAndSettle();
    expect(
      find.text("That code isn't right. Check the message and try again."),
      findsOneWidget,
    );

    await tester.enterText(_codeField, '222222');
    await tester.pumpAndSettle();
    expect(
      find.text('This code has expired. Ask for a new one.'),
      findsOneWidget,
    );
    expect(find.text('Enter the code'), findsOneWidget);
  });

  testWidgets('a number we cannot text is caught before sending', (
    tester,
  ) async {
    final auth = FakeAuthRepository([]);
    await pumpApp(tester, auth: auth, clock: () => start);

    await _sendCode(tester, '12345');

    expect(
      find.text(
        'Enter a 10-digit mobile number, or a number that starts with + '
        'and the country code.',
      ),
      findsOneWidget,
    );
    expect(auth.calls, isEmpty);
  });

  testWidgets('too many codes: how long to wait, still on the number', (
    tester,
  ) async {
    await pumpApp(
      tester,
      auth: FakeAuthRepository(
        [],
        codes: [
          const Err(
            TooManyRequestsFailure([], retryAfter: Duration(minutes: 10)),
          ),
        ],
      ),
      clock: () => start,
    );

    await _sendCode(tester, '9876543210');

    expect(
      find.text('Too many attempts. Please wait 10 minutes and try again.'),
      findsOneWidget,
    );
    expect(find.text('Your phone number'), findsOneWidget);
  });

  testWidgets('resend waits 30 seconds, then sends a new code', (tester) async {
    var now = start;
    final auth = FakeAuthRepository(
      [],
      codes: [
        const Ok(_challenge),
        const Ok(
          OtpChallenge(
            id: 'c2',
            phone: '+919876543210',
            expiresIn: Duration(minutes: 5),
            resendIn: Duration(seconds: 30),
          ),
        ),
      ],
      checks: [const Ok(OtpSignedIn(_session, isNewUser: false))],
    );
    await pumpApp(tester, auth: auth, clock: () => now);
    await _sendCode(tester, '9876543210');

    expect(find.text('Resend code in 0:30'), findsOneWidget);
    now = start.add(const Duration(seconds: 6));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Resend code in 0:24'), findsOneWidget);

    await tester.tap(find.text('Resend code in 0:24'));
    await tester.pump();
    expect(auth.calls, hasLength(1));

    now = start.add(const Duration(seconds: 30));
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.text('Resend code'));
    await tester.pumpAndSettle();

    expect(find.text('We sent a new code.'), findsOneWidget);
    expect(auth.calls, hasLength(2));

    // The new code goes with the new challenge.
    await tester.enterText(_codeField, '654321');
    await tester.pumpAndSettle();
    expect(auth.calls.last['challengeId'], 'c2');
  });

  testWidgets('Change number goes back with the number kept', (tester) async {
    await pumpApp(
      tester,
      auth: FakeAuthRepository([], codes: [const Ok(_challenge)]),
      clock: () => start,
    );
    await _sendCode(tester, '9876543210');

    await tester.tap(find.text('Change number'));
    await tester.pumpAndSettle();

    expect(find.text('Your phone number'), findsOneWidget);
    expect(find.text('9876543210'), findsOneWidget);
  });

  testWidgets('email sign-in links to phone sign-in and back', (tester) async {
    await pumpApp(tester, auth: FakeAuthRepository([]));

    await tester.tap(find.text('Use email instead'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Use your phone number'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Use your phone number'));
    await tester.pumpAndSettle();
    expect(find.text('Your phone number'), findsOneWidget);

    await tester.tap(find.text('Use email instead'));
    await tester.pumpAndSettle();
    expect(find.text('Sign in to STAKA'), findsOneWidget);
  });
}
