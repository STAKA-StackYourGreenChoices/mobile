import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/auth/auth_tokens.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/network/dio_client.dart';
import 'package:staka/core/utils/idempotency_key.dart';
import 'package:staka/features/rewards/data/rewards_repository.dart';
import 'package:staka/features/rewards/domain/reward.dart';

import '../../helpers/auth_fakes.dart';
import '../../helpers/fake_http_adapter.dart';
import '../../helpers/points_fakes.dart';
import '../../helpers/pump_app.dart';
import '../../helpers/pump_full_app.dart';
import '../../helpers/rewards_fakes.dart';
import '../../helpers/tag_fakes.dart';

const _tokens = AuthTokens(accessToken: 'a', refreshToken: 'r');

Finder _tab(String label) =>
    find.descendant(of: find.byType(NavigationBar), matching: find.text(label));

Future<void> _openRewards(
  WidgetTester tester,
  FakeRewardsRepository rewards, {
  FakeShareActions? share,
}) async {
  usePhoneScreen(tester, height: 2400);
  await pumpApp(
    tester,
    tokens: _tokens,
    replies: [json(200, userJson())],
    points: FakePointsRepository(pages: {1: Ok(samplePoints())}),
    rewards: rewards,
    shareActions: share,
  );
  await tester.tap(_tab('Rewards'));
  await tester.pumpAndSettle();
}

Future<void> _openReward(WidgetTester tester, String value) async {
  await tester.tap(find.text(value));
  await tester.pumpAndSettle();
}

Future<void> _redeemAndConfirm(WidgetTester tester) async {
  await tester.tap(find.text('Redeem'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Use points'));
  await tester.pumpAndSettle();
}

RewardsRepository _api(FakeHttpAdapter adapter) {
  final container = ProviderContainer(
    overrides: [
      dioProvider.overrideWithValue(
        Dio(BaseOptions(baseUrl: 'http://api.test'))
          ..httpClientAdapter = adapter,
      ),
    ],
  );
  addTearDown(container.dispose);
  return container.read(rewardsRepositoryProvider);
}

void main() {
  group('catalog', () {
    testWidgets('each voucher with its cost and whether you can have it', (
      tester,
    ) async {
      await _openRewards(
        tester,
        FakeRewardsRepository(catalog: Ok(sampleRewards)),
      );

      expect(find.text('Swap your points'), findsOneWidget);
      expect(find.text('₹200 off'), findsOneWidget);
      expect(find.text('500 points'), findsOneWidget);
      // 1,500 against a balance of 1,240.
      expect(find.text('260 more points'), findsOneWidget);
      expect(find.text('Out of stock'), findsOneWidget);
    });

    testWidgets('no vouchers yet', (tester) async {
      await _openRewards(tester, FakeRewardsRepository());

      expect(find.text('No vouchers right now'), findsOneWidget);
    });
  });

  group('redeem', () {
    testWidgets('confirm, then the code to copy', (tester) async {
      final rewards = FakeRewardsRepository(catalog: Ok(sampleRewards));
      final share = FakeShareActions();
      await _openRewards(tester, rewards, share: share);
      await _openReward(tester, '₹200 off');

      expect(find.text('At Terra Threads'), findsOneWidget);
      expect(
        find.text('One per order. Not with other offers. Online only.'),
        findsOneWidget,
      );
      await tester.tap(find.text('Redeem'));
      await tester.pumpAndSettle();
      expect(
        find.text(
          "Use 500 points for ₹200 off at Terra Threads? You can't undo this.",
        ),
        findsOneWidget,
      );
      await tester.tap(find.text('Use points'));
      await tester.pumpAndSettle();

      expect(rewards.redeemKeys, hasLength(1));
      expect(find.text('Your voucher is ready'), findsOneWidget);
      expect(find.text('TERRA-7KQ2-M9XA'), findsOneWidget);
      expect(find.text('Use by 24 Feb 2027'), findsOneWidget);

      await tester.tap(find.text('Copy code'));
      await tester.pumpAndSettle();
      expect(share.copied, ['TERRA-7KQ2-M9XA']);
      expect(find.text('Code copied'), findsOneWidget);
    });

    testWidgets('cancel sends nothing', (tester) async {
      final rewards = FakeRewardsRepository(catalog: Ok(sampleRewards));
      await _openRewards(tester, rewards);
      await _openReward(tester, '₹200 off');

      await tester.tap(find.text('Redeem'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(rewards.redeemKeys, isEmpty);
    });

    testWidgets('a retry after a lost answer sends the same key', (
      tester,
    ) async {
      final rewards = FakeRewardsRepository(
        catalog: Ok(sampleRewards),
        redeemResults: [const Err(NetworkFailure()), Ok(sampleVoucher)],
      );
      await _openRewards(tester, rewards);
      await _openReward(tester, '₹200 off');

      await _redeemAndConfirm(tester);
      expect(find.textContaining('connection'), findsWidgets);
      await _redeemAndConfirm(tester);

      expect(rewards.redeemKeys, hasLength(2));
      expect(rewards.redeemKeys.toSet(), hasLength(1));
      expect(find.text('TERRA-7KQ2-M9XA'), findsOneWidget);
    });

    testWidgets('a clear no lets the next tap send a new key', (tester) async {
      final rewards = FakeRewardsRepository(
        catalog: Ok(sampleRewards),
        redeemResults: [
          const Err(BadRequestFailure(422, [])),
          Ok(sampleVoucher),
        ],
      );
      await _openRewards(tester, rewards);
      await _openReward(tester, '₹200 off');

      await _redeemAndConfirm(tester);
      expect(
        find.text("You don't have enough points for this one yet."),
        findsOneWidget,
      );
      await _redeemAndConfirm(tester);

      expect(rewards.redeemKeys.toSet(), hasLength(2));
    });

    testWidgets('out of stock says so and reloads the voucher', (tester) async {
      final rewards = FakeRewardsRepository(
        catalog: Ok(sampleRewards),
        redeemResults: [const Err(ConflictFailure([]))],
      );
      await _openRewards(tester, rewards);
      await _openReward(tester, '₹200 off');
      final before = rewards.detailFetches;

      await _redeemAndConfirm(tester);

      expect(
        find.text('This one just ran out. Pick another voucher.'),
        findsOneWidget,
      );
      expect(rewards.detailFetches, greaterThan(before));
    });

    testWidgets('Redeem is off when you are short or it is out of stock', (
      tester,
    ) async {
      await _openRewards(
        tester,
        FakeRewardsRepository(catalog: Ok(sampleRewards)),
      );
      await _openReward(tester, 'Free shipping');

      final button = tester.widget<FilledButton>(
        find.ancestor(
          of: find.text('Redeem'),
          matching: find.byType(FilledButton),
        ),
      );
      expect(button.onPressed, isNull);
      expect(find.text('260 more points'), findsOneWidget);
    });

    testWidgets('an ended voucher says so', (tester) async {
      await _openRewards(
        tester,
        FakeRewardsRepository(
          catalog: Ok(sampleRewards),
          details: {'r1': const Err(NotFoundFailure([]))},
        ),
      );
      await _openReward(tester, '₹200 off');

      expect(find.text('Voucher ended'), findsOneWidget);
    });
  });

  group('My vouchers', () {
    testWidgets('each code with Copy', (tester) async {
      final share = FakeShareActions();
      await _openRewards(
        tester,
        FakeRewardsRepository(
          voucherPages: {1: Ok(VoucherPage(items: sampleVouchers, total: 2))},
        ),
        share: share,
      );
      await tester.tap(find.text('See your points history'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('My vouchers'));
      await tester.pumpAndSettle();

      expect(find.text('₹200 off · Terra Threads'), findsOneWidget);
      expect(find.text('LOOM-SHIP-22'), findsOneWidget);
      expect(find.text('Got on 2 Oct 2026'), findsOneWidget);

      await tester.tap(find.byTooltip('Copy code').first);
      await tester.pumpAndSettle();
      expect(share.copied, ['TERRA-7KQ2-M9XA']);
    });

    testWidgets('none yet', (tester) async {
      await _openRewards(tester, FakeRewardsRepository());
      await tester.tap(find.text('See your points history'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('My vouchers'));
      await tester.pumpAndSettle();

      expect(find.text('No vouchers yet'), findsOneWidget);
    });
  });

  group('RewardsRepository', () {
    test('reads the catalog as a list or as items', () async {
      final reward = {
        'id': 'r1',
        'title': '₹200 off at Terra Threads',
        'valueText': '₹200 off',
        'pointsCost': 500,
        'endsAt': '2027-03-31T00:00:00.000Z',
        'brand': {'id': 'b1', 'name': 'Terra Threads', 'logoUrl': null},
        'inStock': true,
        'canAfford': false,
      };
      final adapter = FakeHttpAdapter([
        json(200, [reward]),
        json(200, {
          'items': [reward],
        }),
      ]);
      final api = _api(adapter);

      final list = (await api.fetchRewards() as Ok<List<Reward>>).value;
      final items = (await api.fetchRewards() as Ok<List<Reward>>).value;

      expect(adapter.requests.first.uri.path, '/rewards');
      expect(list.single.brandName, 'Terra Threads');
      expect(list.single.pointsCost, 500);
      expect(list.single.endsAt, DateTime.utc(2027, 3, 31));
      expect(items.single.id, 'r1');
    });

    test('redeems with the Idempotency-Key header', () async {
      final adapter = FakeHttpAdapter([
        json(201, {
          'redemption': {
            'id': 'rd1',
            'points': 500,
            'createdAt': '2026-11-24T10:00:00.000Z',
          },
          'code': 'TERRA-7KQ2-M9XA',
          'expiresAt': '2027-02-24T00:00:00.000Z',
        }),
      ]);

      final voucher = (await _api(
        adapter,
      ).redeem(sampleRewards.first, idempotencyKey: 'k1') as Ok<Voucher>).value;

      final request = adapter.requests.single;
      expect(request.method, 'POST');
      expect(request.uri.path, '/rewards/r1/redeem');
      expect(request.headers['Idempotency-Key'], 'k1');
      expect(voucher.code, 'TERRA-7KQ2-M9XA');
      expect(voucher.brandName, 'Terra Threads');
      expect(voucher.expiresAt, DateTime.utc(2027, 2, 24));
    });

    test('reads a page of my vouchers', () async {
      final adapter = FakeHttpAdapter([
        json(200, {
          'items': [
            {
              'id': 'rd1',
              'code': 'LOOM-SHIP-22',
              'points': 1500,
              'createdAt': '2026-10-02T10:00:00.000Z',
              'reward': {
                'title': 'Free shipping for a year',
                'valueText': 'Free shipping',
                'brand': {'name': 'Loom & Co'},
              },
            },
          ],
          'total': 21,
        }),
      ]);

      final page =
          (await _api(adapter).fetchVouchers(2) as Ok<VoucherPage>).value;

      expect(adapter.requests.single.uri.path, '/me/redemptions');
      expect(adapter.requests.single.uri.queryParameters, {
        'page': '2',
        'limit': '20',
      });
      expect(page.total, 21);
      expect(page.items.single.brandName, 'Loom & Co');
      expect(page.items.single.expiresAt, isNull);
    });
  });

  test('keys look like UUID v4 and differ', () {
    final a = newIdempotencyKey();
    final b = newIdempotencyKey();
    expect(
      a,
      matches(
        RegExp(
          '^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-'
          r'[0-9a-f]{12}$',
        ),
      ),
    );
    expect(a, isNot(b));
  });
}
