import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/auth/auth_tokens.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/brand_summary.dart';

import '../../helpers/admin_product_fakes.dart';
import '../../helpers/analytics_fakes.dart';
import '../../helpers/auth_fakes.dart';
import '../../helpers/brand_portal_fakes.dart';
import '../../helpers/fake_http_adapter.dart';
import '../../helpers/pump_app.dart';
import '../../helpers/pump_full_app.dart';

const _tokens = AuthTokens(accessToken: 'a', refreshToken: 'r');
final _today = DateTime(2026, 11, 25, 15, 30);

Finder _tab(String label) =>
    find.descendant(of: find.byType(NavigationBar), matching: find.text(label));

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> _openAdminAnalytics(
  WidgetTester tester,
  FakeAnalyticsRepository analytics, {
  List<BrandSummary> brands = const [],
}) async {
  usePhoneScreen(tester, height: 2400);
  await pumpApp(
    tester,
    tokens: _tokens,
    replies: [json(200, userJson(role: 'ADMIN'))],
    analytics: analytics,
    adminProducts: FakeAdminProductRepository(brands: Ok(brands)),
    clock: () => _today,
  );
  await _tap(tester, _tab('Admin'));
  await _tap(tester, find.text('Analytics'));
}

void main() {
  testWidgets('admin: the last 30 days by default, with every figure', (
    tester,
  ) async {
    final analytics = FakeAnalyticsRepository(
      answers: [const Ok(sampleReport)],
    );
    await _openAdminAnalytics(tester, analytics);

    final request = analytics.requests.single;
    expect(request.from, DateTime(2026, 10, 27));
    expect(request.to, DateTime(2026, 11, 25));
    expect(request.brandId, isNull);

    expect(find.text('From scan to share'), findsOneWidget);
    expect(find.text('1,240'), findsOneWidget);
    // 610 of 1,240 scans were added.
    expect(find.text('49% of the step before'), findsOneWidget);
    expect(find.text('By channel'), findsOneWidget);
    expect(find.text('Top products'), findsOneWidget);
    expect(find.text('Organic Cotton Tee'), findsOneWidget);
    // Admins see whose product it is.
    expect(find.text('Loom & Leaf'), findsOneWidget);
    expect(find.text('420 scans · 150 verified · 61 shared'), findsOneWidget);
  });

  testWidgets('admin: another period and a brand load again', (tester) async {
    final analytics = FakeAnalyticsRepository(
      answers: [const Ok(sampleReport)],
    );
    await _openAdminAnalytics(
      tester,
      analytics,
      brands: [
        BrandSummary(
          id: 'b2',
          name: 'Loom & Leaf',
          productCount: 4,
          createdAt: DateTime.utc(2026),
        ),
      ],
    );

    await _tap(tester, find.text('7 days'));
    expect(analytics.requests.last.from, DateTime(2026, 11, 19));

    await _tap(tester, find.text('All brands'));
    await _tap(tester, find.text('Loom & Leaf').last);

    expect(analytics.requests.last.brandId, 'b2');
    expect(analytics.requests.last.from, DateTime(2026, 11, 19));
    expect(find.widgetWithText(OutlinedButton, 'Loom & Leaf'), findsOneWidget);
  });

  testWidgets('a quiet period says so; a failed load can be retried', (
    tester,
  ) async {
    final analytics = FakeAnalyticsRepository();
    await _openAdminAnalytics(tester, analytics);

    expect(find.text('Try again'), findsOneWidget);
    await _tap(tester, find.text('Try again'));
    expect(analytics.requests, hasLength(2));

    final quiet = FakeAnalyticsRepository(answers: [const Ok(emptyReport)]);
    await _openAdminAnalytics(tester, quiet);
    expect(find.text('Nothing in this period'), findsOneWidget);
  });

  testWidgets('brand: its own figures, no brand filter or brand names', (
    tester,
  ) async {
    final analytics = FakeAnalyticsRepository(
      answers: [const Ok(sampleReport)],
    );
    usePhoneScreen(tester, height: 2400);
    await pumpApp(
      tester,
      tokens: _tokens,
      replies: [
        json(200, memberUserJson([membershipJson()])),
      ],
      analytics: analytics,
      clock: () => _today,
    );
    await _tap(tester, _tab('Brand'));
    await _tap(tester, find.text('Analytics'));

    expect(analytics.requests.single.brandId, isNull);
    expect(find.text('Organic Cotton Tee'), findsOneWidget);
    expect(find.text('Loom & Leaf'), findsNothing);
    expect(find.text('All brands'), findsNothing);
  });
}
