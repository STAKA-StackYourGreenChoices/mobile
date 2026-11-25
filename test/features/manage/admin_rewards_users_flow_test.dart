import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/auth/auth_tokens.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/network/dio_client.dart';
import 'package:staka/core/rewards/points.dart';
import 'package:staka/features/manage/rewards/data/admin_rewards_repository.dart';
import 'package:staka/features/manage/users/data/admin_users_repository.dart';

import '../../helpers/admin_rewards_fakes.dart';
import '../../helpers/auth_fakes.dart';
import '../../helpers/brand_rewards_fakes.dart';
import '../../helpers/fake_http_adapter.dart';
import '../../helpers/points_fakes.dart';
import '../../helpers/pump_app.dart';
import '../../helpers/pump_full_app.dart';

const _tokens = AuthTokens(accessToken: 'a0', refreshToken: 'r0');

Finder _field(String label) => find.descendant(
  of: find.ancestor(of: find.text(label), matching: find.byType(Column)).first,
  matching: find.byType(EditableText),
);

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

/// Signs in as an admin and opens the hub tile described by [tile].
Future<void> _openAdmin(
  WidgetTester tester,
  String tile, {
  FakeAdminRewardsRepository? rewards,
  FakeAdminUsersRepository? users,
}) async {
  usePhoneScreen(tester, height: 2400);
  await pumpApp(
    tester,
    tokens: _tokens,
    replies: [json(200, userJson(role: 'ADMIN'))],
    adminRewards: rewards,
    adminUsers: users,
    clock: () => rewardsNow,
  );
  await _tap(
    tester,
    find.descendant(
      of: find.byType(NavigationBar),
      matching: find.text('Admin'),
    ),
  );
  await _tap(tester, find.text(tile));
}

T _api<T>(FakeHttpAdapter adapter, T Function(ProviderContainer) read) {
  final container = ProviderContainer(
    overrides: [
      dioProvider.overrideWithValue(
        Dio(BaseOptions(baseUrl: 'http://api.test'))
          ..httpClientAdapter = adapter,
      ),
    ],
  );
  addTearDown(container.dispose);
  return read(container);
}

void main() {
  group('rewards', () {
    testWidgets('every brand, and a live one can be switched off', (
      tester,
    ) async {
      final rewards = FakeAdminRewardsRepository(rewards: sampleAdminRewards);
      await _openAdmin(
        tester,
        "See every brand's rewards and switch one off.",
        rewards: rewards,
      );

      expect(find.text('Loom & Co'), findsNWidgets(2));
      expect(find.text('Switch off'), findsNWidgets(2)); // r1 and r2 run
      await _tap(tester, find.text('Switch off').first);
      expect(find.text('Switch this reward off?'), findsOneWidget);
      await _tap(tester, find.widgetWithText(FilledButton, 'Switch off'));

      expect(rewards.switchedOff, ['r1']);
      expect(find.text('Reward switched off'), findsOneWidget);
      expect(find.text('Switch off'), findsOneWidget);
    });
  });

  group('reward rules', () {
    testWidgets('a rule is edited in its sheet', (tester) async {
      final rewards = FakeAdminRewardsRepository(rules: sampleRewardRules);
      await _openAdmin(
        tester,
        'Points for each action and daily limits.',
        rewards: rewards,
      );

      expect(find.text('+5 points · Up to 50 points a day'), findsOneWidget);
      expect(find.text('Off'), findsOneWidget);
      await _tap(tester, find.text('Every 10 views of a shared tag'));

      await tester.enterText(_field('Points'), '8');
      await tester.enterText(_field('Daily limit'), '');
      await _tap(tester, find.text('Save changes'));

      final saved = rewards.savedRules.single;
      expect(saved.key, 'VIEWS_10');
      expect(saved.points, 8);
      expect(saved.dailyCap, isNull);
      expect(find.text('Changes saved'), findsOneWidget);
      expect(find.text('+8 points'), findsOneWidget);
    });
  });

  group('users', () {
    testWidgets('find a shopper and adjust their points', (tester) async {
      final users = FakeAdminUsersRepository(
        users: [...sampleAdminUsers],
        points: {'u1': samplePoints()},
      );
      await _openAdmin(
        tester,
        'Find a shopper to see and adjust their points.',
        users: users,
      );

      expect(find.text('Find a shopper'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'ada');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();

      expect(users.queries, ['ada']);
      expect(find.text('ada@example.com · +91 98765 43210'), findsOneWidget);
      await _tap(tester, find.text('Ada Lovelace'));

      expect(find.text('1,240'), findsOneWidget);
      expect(find.text('Organic Cotton Tee was verified'), findsOneWidget);

      await _tap(tester, find.text('Adjust points'));
      await _tap(tester, find.text('Take away'));
      await tester.enterText(_field('How many points'), '25');
      await tester.enterText(_field('Note'), 'Shared twice by mistake.');
      await _tap(tester, find.widgetWithText(FilledButton, 'Adjust points'));
      expect(
        find.text(
          'Take 25 points from Ada Lovelace? They see your note in their '
          'history.',
        ),
        findsOneWidget,
      );
      await _tap(
        tester,
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.text('Adjust points'),
        ),
      );

      expect(users.adjustments, [('u1', -25, 'Shared twice by mistake.')]);
      expect(find.text('Points adjusted'), findsOneWidget);
      expect(find.text('1,215'), findsOneWidget);
    });

    testWidgets('a note is needed', (tester) async {
      final users = FakeAdminUsersRepository(users: [...sampleAdminUsers]);
      await _openAdmin(
        tester,
        'Find a shopper to see and adjust their points.',
        users: users,
      );
      await tester.enterText(find.byType(TextField), 'grace');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();
      await _tap(tester, find.text('Grace Hopper'));
      await _tap(tester, find.text('Adjust points'));

      await tester.enterText(_field('How many points'), '10');
      await _tap(tester, find.widgetWithText(FilledButton, 'Adjust points'));

      expect(find.text('Write a note of 3 to 200 characters.'), findsOneWidget);
      expect(users.adjustments, isEmpty);
    });

    testWidgets('nobody found', (tester) async {
      await _openAdmin(
        tester,
        'Find a shopper to see and adjust their points.',
        users: FakeAdminUsersRepository(users: [...sampleAdminUsers]),
      );
      await tester.enterText(find.byType(TextField), 'zed');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();

      expect(find.text('No one found'), findsOneWidget);
    });
  });

  group('API', () {
    test('rewards, switch off and rules', () async {
      final adapter = FakeHttpAdapter([
        json(200, [
          {
            'id': 'r1',
            'title': 'T',
            'valueText': 'V',
            'pointsCost': 5,
            'startsAt': '2026-11-01T00:00:00.000Z',
            'active': true,
            'brand': {'id': 'b1', 'name': 'Terra Threads'},
          },
        ]),
        json(201, null),
        json(200, [
          {'key': 'VIEWS_10', 'points': 5, 'dailyCap': 50, 'active': true},
        ]),
        json(200, {'key': 'VIEWS_10', 'points': 8, 'dailyCap': null}),
      ]);
      final api = _api(adapter, (c) => c.read(adminRewardsRepositoryProvider));

      final rewards = (await api.fetchRewards() as Ok<List<AdminReward>>).value;
      await api.switchOff('r1');
      final rules = (await api.fetchRules() as Ok<List<RewardRule>>).value;
      final saved = (await api.updateRule(
        const RewardRule(key: 'VIEWS_10', points: 8),
      ) as Ok<RewardRule>).value;

      final [list, off, getRules, patch] = adapter.requests;
      expect(list.uri.path, '/admin/rewards');
      expect(rewards.single.brandName, 'Terra Threads');
      expect(
        (off.method, off.uri.path),
        ('POST', '/admin/rewards/r1/deactivate'),
      );
      expect(getRules.uri.path, '/admin/reward-rules');
      expect(rules.single.dailyCap, 50);
      expect((patch.method, patch.uri.path), ('PATCH', '/admin/reward-rules'));
      expect(patch.data, {
        'key': 'VIEWS_10',
        'points': 8,
        'dailyCap': null,
        'active': true,
      });
      expect(saved.points, 8);
    });

    test('users: search, one user, points and adjust', () async {
      final user = {
        'id': 'u1',
        'name': 'Ada',
        'email': 'ada@example.com',
        'phone': null,
        'pointsBalance': 1240,
      };
      final adapter = FakeHttpAdapter([
        json(200, {
          'items': [user],
          'total': 31,
        }),
        json(200, user),
        json(200, {
          'balance': 1240,
          'expiringSoon': null,
          'entries': {'items': <Object>[], 'total': 0},
        }),
        json(201, null),
      ]);
      final api = _api(adapter, (c) => c.read(adminUsersRepositoryProvider));

      final page = (await api.search('ada') as Ok<AdminUserPage>).value;
      await api.fetchUser('u1');
      final points = (await api.fetchPoints('u1', 1) as Ok<PointsPage>).value;
      await api.adjustPoints('u1', delta: -25, note: 'Oops');

      final [search, one, history, adjust] = adapter.requests;
      expect(search.uri.path, '/admin/users');
      expect(search.uri.queryParameters, {
        'q': 'ada',
        'page': '1',
        'limit': '20',
      });
      expect(page.total, 31);
      expect(page.items.single.pointsBalance, 1240);
      expect(one.uri.path, '/admin/users/u1');
      expect(history.uri.path, '/admin/users/u1/points');
      expect(points.balance, 1240);
      expect(
        (adjust.method, adjust.uri.path),
        ('POST', '/admin/users/u1/points'),
      );
      expect(adjust.data, {'delta': -25, 'note': 'Oops'});
    });
  });
}
