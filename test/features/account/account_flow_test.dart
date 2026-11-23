import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/auth/auth_tokens.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/user.dart';
import 'package:staka/features/auth/domain/models/auth_session.dart';

import '../../helpers/auth_fakes.dart';
import '../../helpers/fake_http_adapter.dart';
import '../../helpers/pump_full_app.dart';

const _saved = AuthTokens(accessToken: 'a0', refreshToken: 'r0');
const _fresh = AuthSession(
  tokens: AuthTokens(accessToken: 'a1', refreshToken: 'r1'),
  user: User(
    id: 'u1',
    email: 'ada@example.com',
    name: 'Ada Lovelace',
    role: Role.user,
    emailVerified: true,
  ),
);

Finder _field(String label) => find.descendant(
  of: find.ancestor(of: find.text(label), matching: find.byType(Column)).first,
  matching: find.byType(EditableText),
);

Future<void> _openChangePassword(WidgetTester tester) async {
  await tester.tap(find.text('Account'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Change password'));
  await tester.pumpAndSettle();
}

Future<void> _fillAndSubmit(
  WidgetTester tester, {
  String current = 'old password',
  String next = 'brand new password',
  String? confirm,
}) async {
  await tester.enterText(_field('Current password'), current);
  await tester.enterText(_field('New password'), next);
  await tester.enterText(_field('Confirm new password'), confirm ?? next);
  // Below the bottom bar on the test screen: scroll to it like a user would.
  final submit = find.widgetWithText(FilledButton, 'Change password');
  await tester.ensureVisible(submit);
  await tester.pumpAndSettle();
  await tester.tap(submit);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('account shows who is signed in and signs out', (tester) async {
    await pumpApp(
      tester,
      tokens: _saved,
      replies: [json(200, userJson()), json(201, {})],
    );
    await tester.tap(find.text('Account'));
    await tester.pumpAndSettle();

    expect(find.text('Ada Lovelace'), findsOneWidget);
    // In the header and on the Email row.
    expect(find.text('ada@example.com'), findsNWidgets(2));

    await tester.ensureVisible(find.text('Sign out'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sign out'));
    await tester.pumpAndSettle();
    expect(find.text('Continue with phone number'), findsOneWidget);
  });

  testWidgets('wrong current password is shown on that field', (tester) async {
    final auth = FakeAuthRepository(
      [],
      requests: [const Err(UnauthorizedFailure([]))],
    );
    await pumpApp(
      tester,
      tokens: _saved,
      replies: [json(200, userJson())],
      auth: auth,
    );
    await _openChangePassword(tester);

    await _fillAndSubmit(tester);

    expect(
      find.text("That isn't your current password. Check it and try again."),
      findsOneWidget,
    );
  });

  testWidgets('mismatched confirmation is caught before sending', (
    tester,
  ) async {
    final auth = FakeAuthRepository([]);
    await pumpApp(
      tester,
      tokens: _saved,
      replies: [json(200, userJson())],
      auth: auth,
    );
    await _openChangePassword(tester);

    await _fillAndSubmit(tester, confirm: 'something else');

    expect(find.text("The two passwords don't match"), findsOneWidget);
    expect(auth.calls, isEmpty);
  });

  testWidgets('success: signs this phone back in, confirms, returns', (
    tester,
  ) async {
    final auth = FakeAuthRepository(
      [const Ok(_fresh)],
      requests: [const Ok(null)],
    );
    final store = await pumpApp(
      tester,
      tokens: _saved,
      replies: [json(200, userJson())],
      auth: auth,
    );
    await _openChangePassword(tester);

    await _fillAndSubmit(tester);

    expect(auth.calls.last, {
      'email': 'ada@example.com',
      'password': 'brand new password',
    });
    expect(store.tokens, _fresh.tokens);
    expect(
      find.text('Password changed. Other devices will need to sign in again.'),
      findsOneWidget,
    );
    // In the header and on the Email row.
    expect(find.text('ada@example.com'), findsNWidgets(2));
  });

  testWidgets('if signing back in fails, sign-in asks for the new password', (
    tester,
  ) async {
    final auth = FakeAuthRepository(
      [const Err(NetworkFailure())],
      requests: [const Ok(null)],
    );
    final store = await pumpApp(
      tester,
      tokens: _saved,
      replies: [json(200, userJson())],
      auth: auth,
    );
    await _openChangePassword(tester);

    await _fillAndSubmit(tester);

    expect(find.text('Sign in to STAKA'), findsOneWidget);
    expect(
      find.text('Password changed. Sign in with your new password.'),
      findsOneWidget,
    );
    expect(store.tokens, isNull);
  });
}
