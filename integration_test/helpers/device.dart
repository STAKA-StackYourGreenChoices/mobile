import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/app/app.dart';
import 'package:staka/core/config/env.dart';

/// Seeded product every journey uses (Organic Cotton Tee, Terra Threads).
const seededGtin = '8901234500019';

/// The seeded admin, passed with `--dart-define` (see HANDOFF; never commit).
const adminEmail = String.fromEnvironment('LIVE_ADMIN_EMAIL');
const adminPassword = String.fromEnvironment('LIVE_ADMIN_PASSWORD');

/// A member of Terra Threads' team in the V2 seed (brand journey only).
const brandEmail = String.fromEnvironment('LIVE_BRAND_EMAIL');
const brandPassword = String.fromEnvironment('LIVE_BRAND_PASSWORD');

/// A 10-digit mobile number on no account, for the phone journey. Only
/// with the API's console SMS driver: the code is printed, never texted.
const testPhone = String.fromEnvironment('LIVE_TEST_PHONE');

/// Starts the real app (real API, real secure storage) signed out.
Future<void> launchSignedOut(WidgetTester tester) async {
  await const FlutterSecureStorage().deleteAll();
  await tester.pumpWidget(const ProviderScope(child: App()));
  await waitFor(tester, find.text('Continue with phone number'));
}

/// From the welcome screen: Use email instead, then sign in.
Future<void> signInWithEmail(
  WidgetTester tester,
  String email,
  String password,
) async {
  await tapText(tester, 'Use email instead');
  await waitFor(tester, field('Email'));
  await fill(tester, 'Email', email);
  await fill(tester, 'Password', password);
  await tapButton(tester, 'Sign in');
}

/// Account → Sign out, back on the welcome screen.
Future<void> signOut(WidgetTester tester) async {
  await tapOn(tester, navTab('Account'));
  await waitFor(tester, find.text('Sign out'));
  await tapText(tester, 'Sign out');
  await waitFor(tester, find.text('Continue with phone number'));
}

/// The bottom bar's [label] tab (the same word can be a page title).
Finder navTab(String label) =>
    find.descendant(of: find.byType(NavigationBar), matching: find.text(label));

/// Pumps until [finder] matches: real requests don't schedule frames, so
/// `pumpAndSettle` alone can return before the answer arrives.
Future<void> waitFor(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 20),
}) async {
  final end = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(end)) {
    await tester.pump(const Duration(milliseconds: 200));
    if (finder.evaluate().isNotEmpty) {
      await tester.pumpAndSettle();
      return;
    }
  }
  throw TestFailure(
    'Timed out waiting for $finder. On screen: ${visibleTexts().join(' | ')}',
  );
}

/// Every text on screen, for failure messages.
List<String> visibleTexts() => [
  for (final element in find.byType(Text).evaluate())
    if ((element.widget as Text).data case final String text) text,
];

/// Scrolls the page down until [finder] is built and visible (long pages
/// only build what is near the screen).
Future<void> scrollTo(WidgetTester tester, Finder finder) async {
  if (finder.evaluate().isEmpty) {
    await tester.scrollUntilVisible(
      finder,
      300,
      scrollable: find.byType(Scrollable).first,
      maxScrolls: 30,
    );
  }
  await tester.ensureVisible(finder.first);
  await tester.pumpAndSettle();
}

/// Scrolls [finder] into view and taps it.
Future<void> tapOn(WidgetTester tester, Finder finder) async {
  await closeKeyboard(tester);
  await scrollTo(tester, finder);
  await tester.tap(finder.first);
  await tester.pump();
}

/// Closes the on-screen keyboard and waits for the page to grow back, so
/// buttons near the bottom aren't half under it.
Future<void> closeKeyboard(WidgetTester tester) async {
  if (FocusManager.instance.primaryFocus?.hasPrimaryFocus != true) return;
  FocusManager.instance.primaryFocus?.unfocus();
  for (var frame = 0; frame < 10; frame++) {
    await tester.pump(const Duration(milliseconds: 60));
  }
  await tester.pumpAndSettle();
}

Future<void> tapText(WidgetTester tester, String text) =>
    tapOn(tester, find.text(text));

Future<void> tapButton(WidgetTester tester, String label) =>
    tapOn(tester, find.widgetWithText(FilledButton, label));

/// The text field under the label [label].
Finder field(String label) => find.descendant(
  of: find.ancestor(of: find.text(label), matching: find.byType(Column)).first,
  matching: find.byType(EditableText),
);

Future<void> fill(WidgetTester tester, String label, String value) async {
  await tester.ensureVisible(field(label));
  await tester.enterText(field(label), value);
  await tester.pump();
}

/// A fresh shopper address per run.
String throwawayEmail() =>
    'mobile-device-${DateTime.now().microsecondsSinceEpoch}@example.com';

typedef DeviceShopper = ({String email, String password});

/// Registers [name], adds the seeded tee and sends a receipt photo,
/// straight through the API (the app part belongs to the reviewer).
Future<DeviceShopper> shopperWithPendingReceipt(String name) async {
  final dio = Dio(BaseOptions(baseUrl: Env.apiBaseUrl));
  final email = throwawayEmail();
  final password = randomPassword();
  final tokens = await dio.post<Map<String, dynamic>>(
    '/auth/register',
    data: {'name': name, 'email': email, 'password': password},
  );
  dio.options.headers['authorization'] =
      'Bearer ${tokens.data!['accessToken']}';
  final card = await dio.post<Map<String, dynamic>>(
    '/digital-cards',
    data: {'gtin': seededGtin},
  );
  await dio.post<Object?>(
    '/digital-cards/${card.data!['id']}/ownership/receipt',
    data: FormData.fromMap({
      'file': MultipartFile.fromBytes(
        base64Decode(
          'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk'
          'YPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==',
        ),
        filename: 'receipt.png',
        contentType: DioMediaType('image', 'png'),
      ),
    }),
  );
  return (email: email, password: password);
}

String randomPassword() {
  final random = Random.secure();
  return List.generate(
    20,
    (_) => 'abcdefghijkmnpqrstuvwxyz23456789'[random.nextInt(32)],
  ).join();
}
