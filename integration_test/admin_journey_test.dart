import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/config/env.dart';

import 'helpers/device.dart';

/// The admin side on a real phone against the real API, ending with a
/// shopper sharing the tag the admin just verified:
/// products (search, open the hide dialog, cancel), the brands and
/// disputes pages, claims (review the receipt, overrule: approve instead),
/// then share and stop sharing. Since V2-12 (`feat/admin-brands-disputes`)
/// this needs the V2 API (`/admin/brand-applications`, `/admin/disputes`,
/// `/admin/claims/:id/override`).
///
/// Only touches what it creates: a throwaway shopper and their claim.
/// Needs `LIVE_ADMIN_EMAIL` / `LIVE_ADMIN_PASSWORD`.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'admin: catalog, brands, disputes, overrule a receipt; shopper shares',
    (tester) async {
      final stamp = DateTime.now().microsecondsSinceEpoch;
      final shopperName = 'Device Shopper $stamp';
      final shopper = await _shopperWithPendingReceipt(shopperName);

      // Sign in as the admin.
      await launchSignedOut(tester);
      await tapText(tester, 'Sign in');
      await waitFor(tester, field('Email'));
      await fill(tester, 'Email', adminEmail);
      await fill(tester, 'Password', adminPassword);
      await tapButton(tester, 'Sign in');
      await waitFor(tester, find.text('Admin'));

      // Products: search, open one, back.
      await tapText(tester, 'Admin');
      await waitFor(tester, find.text('Products'));
      await tapText(tester, 'Products');
      await waitFor(tester, find.textContaining('Showing 1–'));
      await tester.enterText(find.byType(TextField), 'Organic Cotton');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await waitFor(tester, find.text('Terra Threads, $seededGtin'));
      // Admins don't edit products; a tap offers to hide it. Cancel.
      await tapText(tester, 'Organic Cotton Tee');
      await waitFor(tester, find.text('Hide Organic Cotton Tee?'));
      await tapText(tester, 'Cancel');
      await waitFor(tester, find.text('Terra Threads, $seededGtin'));
      await tester.pageBack();

      // Brands and disputes: the pages load (deciding is left to fakes).
      await waitFor(tester, find.text('Brands'));
      await tapText(tester, 'Brands');
      await waitFor(tester, find.text('To review'));
      await tester.pageBack();
      await waitFor(tester, find.text('Disputes'));
      await tapText(tester, 'Disputes');
      await waitFor(tester, find.text('To decide'));
      await tester.pageBack();

      // Claims: find this run's receipt, look at it, approve it.
      await waitFor(tester, find.text('Claims'));
      await tapText(tester, 'Claims');
      await waitFor(tester, find.text('Ownership claims'));
      final row = find.text('$shopperName (${shopper.email})');
      await scrollTo(tester, row);
      await tapOn(tester, row);
      await waitFor(tester, find.text('$shopperName: Organic Cotton Tee'));
      await waitFor(tester, find.text('Tap the image to open it full size.'));
      await tapText(tester, 'Approve instead');
      await waitFor(tester, find.text('Approve this claim?'));
      await tester.enterText(
        find.byType(EditableText).last,
        'Checked on a phone, for a test.',
      );
      await tapOn(tester, find.widgetWithText(FilledButton, 'Approve').last);
      await waitFor(
        tester,
        find.text('Approved. The shopper is now the verified owner.'),
      );

      // Sign out; the shopper signs in and shares their verified tag.
      await tapText(tester, 'Account');
      await waitFor(tester, find.text('Sign out'));
      await tapText(tester, 'Sign out');
      await waitFor(tester, find.text('Create an account'));
      await tapText(tester, 'Sign in');
      await waitFor(tester, field('Email'));
      await fill(tester, 'Email', shopper.email);
      await fill(tester, 'Password', shopper.password);
      await tapButton(tester, 'Sign in');
      await waitFor(tester, find.text('Verified (1)'));
      await tapText(tester, 'Organic Cotton Tee');
      await waitFor(tester, find.text("You're the verified owner"));
      await tapText(tester, 'Create share link');
      await waitFor(tester, find.text('Copy link'));
      await tapText(tester, 'Stop sharing');
      await waitFor(tester, find.text('Stop sharing this tag?'));
      await tapOn(tester, find.widgetWithText(FilledButton, 'Stop sharing'));
      await waitFor(tester, find.text('Create share link'));
    },
    skip: adminPassword.isEmpty,
  );
}

typedef _Shopper = ({String email, String password});

/// Registers a shopper, adds the seeded product and sends a receipt photo,
/// straight through the API (the app part is the admin's).
Future<_Shopper> _shopperWithPendingReceipt(String name) async {
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
