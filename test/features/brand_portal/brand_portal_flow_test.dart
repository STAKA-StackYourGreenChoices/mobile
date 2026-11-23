import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/auth/auth_tokens.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/brand_membership.dart';
import 'package:staka/features/brand_apply/domain/models/brand_application.dart';

import '../../helpers/admin_product_fakes.dart';
import '../../helpers/auth_fakes.dart';
import '../../helpers/brand_apply_fakes.dart';
import '../../helpers/brand_portal_fakes.dart';
import '../../helpers/fake_http_adapter.dart';
import '../../helpers/pump_full_app.dart';

const _tokens = AuthTokens(accessToken: 'a0', refreshToken: 'r0');

Finder _tab(String label) =>
    find.descendant(of: find.byType(NavigationBar), matching: find.text(label));

Finder _field(String label) => find.descendant(
  of: find.ancestor(of: find.text(label), matching: find.byType(Column)).first,
  matching: find.byType(EditableText),
);

String _textIn(String label) =>
    (_field(label).evaluate().single.widget as EditableText).controller.text;

Future<void> _tap(WidgetTester tester, Finder finder) async {
  // A focused field keeps scrolling itself back into view.
  FocusManager.instance.primaryFocus?.unfocus();
  await tester.pumpAndSettle();
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

/// Signed in as Ada with [brands] (`brands[]` of `/auth/me`), on the
/// Brand tab. [laterUsers] answer later re-reads of the user.
Future<void> _openBrandTab(
  WidgetTester tester, {
  List<Map<String, Object?>>? brands,
  List<Map<String, Object?>> laterUsers = const [],
  FakeBrandPortalRepository? portal,
  FakeAdminProductRepository? products,
}) async {
  await pumpApp(
    tester,
    tokens: _tokens,
    replies: [
      json(200, memberUserJson(brands ?? [membershipJson()])),
      for (final user in laterUsers) json(200, user),
    ],
    brandPortal: portal,
    adminProducts: products,
  );
  await _tap(tester, _tab('Brand'));
}

void main() {
  testWidgets('an owner sees their brand with Settings', (tester) async {
    await _openBrandTab(tester);

    expect(find.text('Terra Threads'), findsOneWidget);
    expect(find.text('Owner'), findsOneWidget);
    for (final area in ['Products', 'Import', 'Team', 'Settings']) {
      expect(find.text(area), findsOneWidget);
    }
    // One brand: nothing to switch.
    expect(find.text('Switch brand'), findsNothing);
  });

  testWidgets('staff have no Settings, and Team is read-only', (tester) async {
    final portal = FakeBrandPortalRepository(
      members: [
        const Ok([adaOwner, ravi]),
      ],
    );
    await _openBrandTab(
      tester,
      brands: [membershipJson(role: 'STAFF')],
      portal: portal,
    );

    expect(find.text('Staff'), findsOneWidget);
    expect(find.text('Settings'), findsNothing);
    await _tap(tester, find.text('Team'));

    expect(find.text('Only owners can invite or remove people.'), findsOne);
    expect(find.text('Invite someone'), findsNothing);
    expect(find.byIcon(Icons.person_remove_outlined), findsNothing);
    expect(find.text('Ravi Kumar'), findsOneWidget);
  });

  testWidgets('people with only an application have no Brand tab', (
    tester,
  ) async {
    await pumpApp(
      tester,
      tokens: _tokens,
      replies: [
        json(200, memberUserJson([membershipJson(status: 'PENDING')])),
      ],
    );

    expect(_tab('Wardrobe'), findsOneWidget);
    expect(_tab('Brand'), findsNothing);
  });

  testWidgets('someone in two brands switches between them', (tester) async {
    await _openBrandTab(
      tester,
      brands: [
        membershipJson(),
        membershipJson(id: 'b2', name: 'Loom & Leaf', role: 'STAFF'),
      ],
    );

    await _tap(tester, find.text('Switch brand'));
    expect(find.text('Your brands'), findsOneWidget);
    await _tap(tester, find.text('Loom & Leaf'));

    expect(find.text('Loom & Leaf'), findsOneWidget);
    expect(find.text('Terra Threads'), findsNothing);
    expect(find.text('Settings'), findsNothing);
  });

  testWidgets('a paused brand says so and offers nothing to change', (
    tester,
  ) async {
    await _openBrandTab(tester, brands: [membershipJson(status: 'SUSPENDED')]);

    expect(find.textContaining('STAKA has paused Terra Threads.'), findsOne);
    expect(find.text('Products'), findsNothing);

    await _tap(tester, find.text('See why'));
    expect(find.text('Bring your brand to STAKA'), findsWidgets);
  });

  testWidgets('owners invite by phone and remove someone', (tester) async {
    final portal = FakeBrandPortalRepository(
      members: [
        const Ok([adaOwner, ravi]),
        const Ok([adaOwner]),
      ],
      invites: [const Ok(null)],
      removes: [const Ok(null)],
    );
    await _openBrandTab(tester, portal: portal);
    await _tap(tester, find.text('Team'));

    expect(find.text('Ada Lovelace (you)'), findsOneWidget);
    // Owners can't remove themselves here.
    expect(find.byTooltip('Remove Ada Lovelace from the team'), findsNothing);

    await _tap(tester, find.text('Invite someone'));
    await tester.enterText(_field('Email or phone number'), 'not-a-number');
    await _tap(tester, find.text('Send invite'));
    expect(
      find.text('Enter an email address or a mobile number'),
      findsOneWidget,
    );
    await tester.enterText(_field('Email or phone number'), '98123 45678');
    await _tap(tester, find.text('Owner').last);
    await _tap(tester, find.text('Send invite'));

    expect(portal.invited, [('b1', '+919812345678', BrandRole.owner)]);
    expect(find.text('Invite sent to 98123 45678.'), findsOneWidget);

    await _tap(tester, find.byTooltip('Remove Ravi Kumar from the team'));
    expect(find.text('Remove Ravi Kumar?'), findsOneWidget);
    await _tap(tester, find.widgetWithText(FilledButton, 'Remove').last);

    expect(portal.removed, [('b1', 'u7')]);
    expect(find.text('Ravi Kumar is no longer on the team.'), findsOneWidget);
    expect(find.text('Ravi Kumar'), findsNothing);
    expect(portal.memberLoads, ['b1', 'b1']);
  });

  testWidgets('Settings saves the brand and the tab shows the new name', (
    tester,
  ) async {
    final portal = FakeBrandPortalRepository(
      saves: [Ok(brandProfile(name: 'Terra'))],
    );
    await _openBrandTab(
      tester,
      laterUsers: [
        memberUserJson([membershipJson(name: 'Terra')]),
      ],
      portal: portal,
    );
    await _tap(tester, find.text('Settings'));

    expect(_textIn('Brand name'), 'Terra Threads');
    await tester.enterText(_field('Brand name'), 'Terra');
    await _tap(tester, find.text('Save changes'));

    final (brandId, draft) = portal.saved.single;
    expect(brandId, 'b1');
    expect(draft.name, 'Terra');
    expect(draft.contactPhone, '+919876543210');
    expect(draft.logo, isNull);
    expect(find.text('Changes saved'), findsOneWidget);

    await _tap(tester, find.byType(BackButton));
    expect(find.text('Terra'), findsOneWidget);
  });

  testWidgets("a brand's new product is for that brand only", (tester) async {
    await _openBrandTab(
      tester,
      products: FakeAdminProductRepository(
        brands: Ok([
          brandSummary('b1', 'Terra Threads'),
          brandSummary('b2', 'Other Co'),
        ]),
      ),
    );
    await _tap(tester, find.text('Products'));

    expect(find.text('All brands'), findsNothing);
    await _tap(tester, find.text('Add product').first);

    expect(find.text('Terra Threads'), findsWidgets);
    expect(find.text('Other Co'), findsNothing);
    expect(find.text('Missing one?'), findsNothing);
  });

  testWidgets('an approved application opens the Brand tab', (tester) async {
    await pumpApp(
      tester,
      tokens: _tokens,
      replies: [
        json(200, userJson()),
        json(200, memberUserJson([membershipJson()])),
      ],
      brandApplications: FakeBrandApplicationRepository(
        mine: [
          Ok([
            brandApplication(id: 'b1', status: BrandApplicationStatus.approved),
          ]),
        ],
      ),
    );
    expect(_tab('Brand'), findsNothing);
    await _tap(tester, _tab('Account'));
    await _tap(tester, find.text('Bring your brand to STAKA'));

    await _tap(tester, find.text('Open the Brand tab'));

    expect(_tab('Brand'), findsOneWidget);
    expect(find.text('Team'), findsOneWidget);
    expect(find.text('Terra Threads'), findsOneWidget);
  });
}
