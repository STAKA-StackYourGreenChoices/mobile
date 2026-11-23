import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/auth/auth_tokens.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/user.dart';
import 'package:staka/features/auth/domain/models/auth_session.dart';

import '../../helpers/pump_full_app.dart';

const _session = AuthSession(
  tokens: AuthTokens(accessToken: 'a1', refreshToken: 'r1'),
  user: User(
    id: 'u1',
    email: 'ada@example.com',
    name: 'Ada Lovelace',
    role: Role.user,
    emailVerified: false,
  ),
);

Finder _field(String label) => find.descendant(
  of: find.ancestor(of: find.text(label), matching: find.byType(Column)).first,
  matching: find.byType(EditableText),
);

Future<void> _openSignIn(WidgetTester tester) async {
  await tester.tap(find.text('Use email instead'));
  await tester.pumpAndSettle();
}

/// Register is one step further now: welcome, email sign-in, then its link.
Future<void> _openRegister(WidgetTester tester) async {
  await _openSignIn(tester);
  await tester.tap(find.text('Create an account'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('sign in, then land in the wardrobe with tokens saved', (
    tester,
  ) async {
    final auth = FakeAuthRepository([const Ok(_session)]);
    final store = await pumpApp(tester, auth: auth);
    await _openSignIn(tester);

    await tester.enterText(_field('Email'), 'ada@example.com');
    await tester.enterText(_field('Password'), 'correct horse');
    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pumpAndSettle();

    expect(find.text('My wardrobe'), findsOneWidget);
    expect(store.tokens, _session.tokens);
    expect(auth.calls.single, {
      'email': 'ada@example.com',
      'password': 'correct horse',
    });
  });

  testWidgets('empty sign-in shows the website messages, sends nothing', (
    tester,
  ) async {
    final auth = FakeAuthRepository([]);
    await pumpApp(tester, auth: auth);
    await _openSignIn(tester);

    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pumpAndSettle();

    expect(
      find.text('Enter an email address like name@example.com'),
      findsOneWidget,
    );
    expect(find.text('Enter your password'), findsOneWidget);
    expect(auth.calls, isEmpty);
  });

  testWidgets('wrong password: the website alert, still on sign-in', (
    tester,
  ) async {
    await pumpApp(
      tester,
      auth: FakeAuthRepository([const Err(UnauthorizedFailure([]))]),
    );
    await _openSignIn(tester);

    await tester.enterText(_field('Email'), 'ada@example.com');
    await tester.enterText(_field('Password'), 'wrong one');
    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pumpAndSettle();

    expect(
      find.text(
        "That email and password don't match an account. "
        'Check them and try again.',
      ),
      findsOneWidget,
    );
    expect(find.text('Sign in to STAKA'), findsOneWidget);
  });

  testWidgets('too many wrong passwords: how long to wait, still on sign-in', (
    tester,
  ) async {
    await pumpApp(
      tester,
      auth: FakeAuthRepository([
        const Err(
          TooManyRequestsFailure([
            'ThrottlerException: Too Many Requests',
          ], retryAfter: Duration(seconds: 899)),
        ),
      ]),
    );
    await _openSignIn(tester);

    await tester.enterText(_field('Email'), 'ada@example.com');
    await tester.enterText(_field('Password'), 'correct horse');
    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pumpAndSettle();

    expect(
      find.text('Too many attempts. Please wait 15 minutes and try again.'),
      findsOneWidget,
    );
    expect(find.textContaining('Throttler'), findsNothing);
    expect(find.text('Sign in to STAKA'), findsOneWidget);
  });

  testWidgets('back from sign-in returns to welcome', (tester) async {
    await pumpApp(tester, auth: FakeAuthRepository([]));
    await _openSignIn(tester);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    expect(find.text('Continue with phone number'), findsOneWidget);
  });

  testWidgets('register: a taken email is shown on the email field', (
    tester,
  ) async {
    await pumpApp(
      tester,
      auth: FakeAuthRepository([
        const Err(ConflictFailure(['taken'])),
      ]),
    );
    await _openRegister(tester);

    await tester.enterText(_field('Your name'), 'Ada Lovelace');
    await tester.enterText(_field('Email'), 'ada@example.com');
    await tester.enterText(_field('Password'), 'correct horse');
    await tester.tap(find.widgetWithText(FilledButton, 'Create account'));
    await tester.pumpAndSettle();

    expect(
      find.text('An account already uses this email. Sign in instead.'),
      findsOneWidget,
    );
  });

  testWidgets('register: a short password is caught before sending', (
    tester,
  ) async {
    final auth = FakeAuthRepository([]);
    await pumpApp(tester, auth: auth);
    await _openRegister(tester);

    await tester.enterText(_field('Your name'), 'Ada');
    await tester.enterText(_field('Email'), 'ada@example.com');
    await tester.enterText(_field('Password'), 'short');
    await tester.tap(find.widgetWithText(FilledButton, 'Create account'));
    await tester.pumpAndSettle();

    expect(find.text('Use at least 8 characters'), findsOneWidget);
    expect(auth.calls, isEmpty);
  });

  testWidgets('register success signs in as a new account', (tester) async {
    final auth = FakeAuthRepository([const Ok(_session)]);
    await pumpApp(tester, auth: auth);
    await _openRegister(tester);

    await tester.enterText(_field('Your name'), 'Ada Lovelace');
    await tester.enterText(_field('Email'), 'ada@example.com');
    await tester.enterText(_field('Password'), 'correct horse');
    await tester.tap(find.widgetWithText(FilledButton, 'Create account'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome, Ada'), findsOneWidget);
  });
}
