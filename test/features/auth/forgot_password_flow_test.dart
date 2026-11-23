import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';

import '../../helpers/pump_full_app.dart';

Future<void> _openForgot(WidgetTester tester) async {
  await tester.tap(find.text('Use email instead'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Forgot your password?'));
  await tester.pumpAndSettle();
}

Future<void> _send(WidgetTester tester, String email) async {
  await tester.enterText(find.byType(EditableText), email);
  await tester.tap(find.byType(FilledButton));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets("sends the link and says so in the website's words", (
    tester,
  ) async {
    final auth = FakeAuthRepository([], requests: [const Ok(null)]);
    await pumpApp(tester, auth: auth);
    await _openForgot(tester);
    expect(find.text('Reset your password'), findsOneWidget);

    await _send(tester, ' ada@example.com ');

    expect(auth.calls.single, {'call': 'reset', 'email': 'ada@example.com'});
    expect(
      find.textContaining(
        'If ada@example.com has a STAKA account, a reset link is on its way.',
      ),
      findsOneWidget,
    );
    expect(find.text('Send another link'), findsOneWidget);
  });

  testWidgets('an invalid email is caught before sending', (tester) async {
    final auth = FakeAuthRepository([]);
    await pumpApp(tester, auth: auth);
    await _openForgot(tester);

    await _send(tester, 'not an email');

    expect(
      find.text('Enter an email address like name@example.com'),
      findsOneWidget,
    );
    expect(auth.calls, isEmpty);
  });

  testWidgets('offline: the connection message, form kept', (tester) async {
    await pumpApp(
      tester,
      auth: FakeAuthRepository([], requests: [const Err(NetworkFailure())]),
    );
    await _openForgot(tester);

    await _send(tester, 'ada@example.com');

    expect(
      find.textContaining("STAKA's server isn't reachable"),
      findsOneWidget,
    );
    expect(find.text('Send reset link'), findsOneWidget);
  });

  testWidgets('"Back to sign in" returns to sign-in', (tester) async {
    await pumpApp(tester, auth: FakeAuthRepository([]));
    await _openForgot(tester);

    await tester.tap(find.text('Back to sign in'));
    await tester.pumpAndSettle();

    expect(find.text('Sign in to STAKA'), findsOneWidget);
  });
}
