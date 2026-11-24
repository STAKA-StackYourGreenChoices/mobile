import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/auth/auth_tokens.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/network/dio_client.dart';
import 'package:staka/features/rewards/data/points_repository.dart';
import 'package:staka/features/rewards/domain/points.dart';

import '../../helpers/auth_fakes.dart';
import '../../helpers/brand_portal_fakes.dart';
import '../../helpers/fake_http_adapter.dart';
import '../../helpers/points_fakes.dart';
import '../../helpers/pump_app.dart';
import '../../helpers/pump_full_app.dart';

const _tokens = AuthTokens(accessToken: 'a', refreshToken: 'r');

Finder _tab(String label) =>
    find.descendant(of: find.byType(NavigationBar), matching: find.text(label));

Future<void> _openRewards(
  WidgetTester tester,
  FakePointsRepository points, {
  double height = 2400,
}) async {
  usePhoneScreen(tester, height: height);
  await pumpApp(
    tester,
    tokens: _tokens,
    replies: [json(200, userJson())],
    points: points,
  );
  await tester.tap(_tab('Rewards'));
  await tester.pumpAndSettle();
}

PointsRepository _api(FakeHttpAdapter adapter) {
  final container = ProviderContainer(
    overrides: [
      dioProvider.overrideWithValue(
        Dio(BaseOptions(baseUrl: 'http://api.test'))
          ..httpClientAdapter = adapter,
      ),
    ],
  );
  addTearDown(container.dispose);
  return container.read(pointsRepositoryProvider);
}

void main() {
  group('Rewards tab', () {
    testWidgets('balance, what expires next and how to earn', (tester) async {
      await _openRewards(
        tester,
        FakePointsRepository(
          pages: {1: Ok(samplePoints())},
          rules: const Ok(sampleRules),
        ),
      );

      expect(find.text('1,240 points', findRichText: true), findsOneWidget);
      expect(find.text('120 points expire on 12 Jan 2027'), findsOneWidget);
      expect(find.text('How to earn'), findsOneWidget);
      expect(find.text('Prove a piece is yours'), findsOneWidget);
      expect(find.text('Up to 50 points a day'), findsOneWidget);
    });

    testWidgets('no "How to earn" when the rules cannot load', (tester) async {
      await _openRewards(
        tester,
        FakePointsRepository(pages: {1: Ok(samplePoints())}),
      );

      expect(find.text('1,240 points', findRichText: true), findsOneWidget);
      expect(find.text('How to earn'), findsNothing);
    });

    testWidgets('a failed balance can be retried', (tester) async {
      final points = FakePointsRepository(
        pages: {1: const Err(NetworkFailure())},
      );
      await _openRewards(tester, points);

      expect(find.text('Try again'), findsOneWidget);
      await tester.tap(find.text('Try again'));
      await tester.pumpAndSettle();

      expect(points.fetchedPages, [1, 1]);
    });
  });

  group('history', () {
    testWidgets('each entry says what happened', (tester) async {
      await _openRewards(
        tester,
        FakePointsRepository(pages: {1: Ok(samplePoints())}),
      );
      await tester.tap(find.text('See your points history'));
      await tester.pumpAndSettle();

      expect(find.text('Organic Cotton Tee was verified'), findsOneWidget);
      expect(find.text('+50 points'), findsOneWidget);
      expect(find.text('20 Nov 2026 · expires 20 Nov 2027'), findsOneWidget);
      expect(find.text('Used for ₹200 off at Terra Threads'), findsOneWidget);
      expect(find.text('−500 points'), findsOneWidget);
      expect(find.text('Sorry for the late check.'), findsOneWidget);
      expect(find.text('Points expired'), findsOneWidget);
    });

    testWidgets('loads more as you scroll', (tester) async {
      final first = [
        for (var n = 1; n <= 20; n++)
          PointsEntry(
            delta: 5,
            reason: PointsReason.views,
            at: DateTime.utc(2026, 11, 20),
            productName: 'Piece $n',
          ),
      ];
      final points = FakePointsRepository(
        pages: {
          1: Ok(samplePoints(entries: first, total: 21)),
          2: Ok(
            samplePoints(
              entries: [
                PointsEntry(
                  delta: 10,
                  reason: PointsReason.phoneVerified,
                  at: DateTime.utc(2026, 11, 2),
                ),
              ],
              total: 21,
            ),
          ),
        },
      );
      await _openRewards(tester, points, height: 800);
      await tester.tap(find.text('See your points history'));
      await tester.pumpAndSettle();

      await tester.fling(
        find.byType(CustomScrollView),
        const Offset(0, -4000),
        3000,
      );
      await tester.pumpAndSettle();

      expect(points.fetchedPages.last, 2);
      expect(find.text('You verified your phone number'), findsOneWidget);
    });

    testWidgets('no points yet', (tester) async {
      await _openRewards(tester, FakePointsRepository());
      await tester.tap(find.text('See your points history'));
      await tester.pumpAndSettle();

      expect(find.text('No points yet'), findsOneWidget);
    });
  });

  testWidgets('an admin in a brand opens it from the Admin hub', (
    tester,
  ) async {
    usePhoneScreen(tester, height: 2400);
    await pumpApp(
      tester,
      tokens: _tokens,
      replies: [
        json(200, {
          ...memberUserJson([membershipJson()]),
          'role': 'ADMIN',
        }),
      ],
    );

    expect(_tab('Brand'), findsNothing);
    await tester.tap(_tab('Admin'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Your brand'));
    await tester.tap(find.text('Your brand'));
    await tester.pumpAndSettle();

    expect(find.text('Terra Threads'), findsWidgets);
    final bar = tester.widget<NavigationBar>(find.byType(NavigationBar));
    // Admin stays lit: Wardrobe, Scan, Rewards, Admin, Account.
    expect(bar.selectedIndex, 3);
  });

  group('PointsRepository', () {
    test('reads the balance, what expires and a page of entries', () async {
      final adapter = FakeHttpAdapter([
        json(200, {
          'balance': 1240,
          'expiringSoon': {'points': 120, 'on': '2027-01-12T00:00:00.000Z'},
          'entries': {
            'items': [
              {
                'delta': 50,
                'reason': 'PIECE_VERIFIED',
                'createdAt': '2026-11-20T10:00:00.000Z',
                'expiresAt': '2027-11-20T10:00:00.000Z',
                'card': {
                  'id': 'c1',
                  'product': {'name': 'Organic Cotton Tee'},
                },
              },
              {
                'delta': -500,
                'reason': 'REDEEMED',
                'createdAt': '2026-11-12T10:00:00.000Z',
                'reward': {'title': '₹200 off'},
              },
              {
                'delta': 3,
                'reason': 'SOMETHING_NEW',
                'createdAt': '2026-11-11T10:00:00.000Z',
              },
            ],
            'total': 42,
          },
        }),
      ]);

      final page = (await _api(adapter).fetchPoints(2) as Ok<PointsPage>).value;

      expect(adapter.requests.single.uri.path, '/me/points');
      expect(adapter.requests.single.uri.queryParameters, {
        'page': '2',
        'limit': '20',
      });
      expect(page.balance, 1240);
      expect(page.expiringPoints, 120);
      expect(page.expiringOn, DateTime.utc(2027, 1, 12));
      expect(page.total, 42);
      final [verified, redeemed, other] = page.entries;
      expect(verified.reason, PointsReason.pieceVerified);
      expect(verified.productName, 'Organic Cotton Tee');
      expect(redeemed.rewardTitle, '₹200 off');
      expect(other.reason, PointsReason.other);
    });

    test('nothing expiring soon; the earn rules skip unknown ones', () async {
      final adapter = FakeHttpAdapter([
        json(200, {
          'balance': 0,
          'expiringSoon': null,
          'entries': {'items': <Object>[], 'total': 0},
        }),
        json(200, [
          {'key': 'PIECE_VERIFIED', 'points': 50, 'dailyCap': null},
          {'key': 'VIEWS_10', 'points': 5, 'dailyCap': 50},
          {'key': 'PHONE_VERIFIED', 'points': 10, 'active': false},
          {'key': 'NEW_RULE', 'points': 1},
        ]),
      ]);
      final api = _api(adapter);

      final page = (await api.fetchPoints(1) as Ok<PointsPage>).value;
      final rules = (await api.fetchEarnRules() as Ok<List<EarnRule>>).value;

      expect(page.expiringOn, isNull);
      expect(adapter.requests.last.uri.path, '/rewards/rules');
      expect(rules.map((r) => r.reason), [
        PointsReason.pieceVerified,
        PointsReason.views,
      ]);
      expect(rules.last.dailyCap, 50);
    });
  });
}
