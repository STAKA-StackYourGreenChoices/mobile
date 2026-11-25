import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/auth/auth_tokens.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/network/dio_client.dart';
import 'package:staka/features/manage/rewards/data/brand_rewards_repository.dart';
import 'package:staka/features/manage/rewards/domain/brand_reward.dart';

import '../../helpers/brand_portal_fakes.dart';
import '../../helpers/brand_rewards_fakes.dart';
import '../../helpers/fake_http_adapter.dart';
import '../../helpers/import_fakes.dart';
import '../../helpers/pump_app.dart';
import '../../helpers/pump_full_app.dart';

const _tokens = AuthTokens(accessToken: 'a', refreshToken: 'r');

Finder _tab(String label) =>
    find.descendant(of: find.byType(NavigationBar), matching: find.text(label));

Finder _field(String label) => find.descendant(
  of: find.ancestor(of: find.text(label), matching: find.byType(Column)).first,
  matching: find.byType(EditableText),
);

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> _openBrandRewards(
  WidgetTester tester,
  FakeBrandRewardsRepository rewards, {
  FakeImportFileActions? files,
}) async {
  usePhoneScreen(tester, height: 2400);
  await pumpApp(
    tester,
    tokens: _tokens,
    replies: [
      json(200, memberUserJson([membershipJson()])),
    ],
    brandRewards: rewards,
    importFileActions: files,
    clock: () => rewardsNow,
  );
  await _tap(tester, _tab('Brand'));
  await _tap(
    tester,
    find.text(
      'Vouchers shoppers swap their STAKA points for, and the codes '
      'behind them.',
    ),
  );
}

BrandRewardsRepository _api(FakeHttpAdapter adapter) {
  final container = ProviderContainer(
    overrides: [
      dioProvider.overrideWithValue(
        Dio(BaseOptions(baseUrl: 'http://api.test'))
          ..httpClientAdapter = adapter,
      ),
    ],
  );
  addTearDown(container.dispose);
  return container.read(brandRewardsRepositoryProvider);
}

void main() {
  group('list', () {
    testWidgets('active ones first, ended and switched off apart', (
      tester,
    ) async {
      final rewards = FakeBrandRewardsRepository(rewards: sampleBrandRewards);
      await _openBrandRewards(tester, rewards);

      expect(rewards.brandIds, ['b1']);
      expect(find.text('₹200 off your next order'), findsOneWidget);
      expect(find.text('Live'), findsOneWidget);
      expect(find.text('Starts 1 Dec 2026'), findsOneWidget);
      expect(find.text('Monsoon sale voucher'), findsNothing);

      await _tap(tester, find.text('Ended or off'));

      expect(find.text('Monsoon sale voucher'), findsOneWidget);
      expect(find.text('Ended'), findsOneWidget);
      expect(find.text('Off'), findsOneWidget);
      expect(find.text('₹200 off your next order'), findsNothing);
    });

    testWidgets('none yet', (tester) async {
      await _openBrandRewards(tester, FakeBrandRewardsRepository());

      expect(find.text('No active rewards'), findsOneWidget);
    });
  });

  group('one reward', () {
    testWidgets('its codes, and an upload says what it added', (tester) async {
      final rewards = FakeBrandRewardsRepository(rewards: sampleBrandRewards);
      final files = FakeImportFileActions(
        picks: [csvFile('codes.csv', text: 'code\nTERRA-1\n')],
      );
      await _openBrandRewards(tester, rewards, files: files);
      await _tap(tester, find.text('₹200 off your next order'));

      expect(find.text('158'), findsOneWidget);
      expect(find.text('200'), findsOneWidget);
      expect(find.text('42'), findsOneWidget);
      expect(
        find.text('One per order. Not with other offers. Online only.'),
        findsOneWidget,
      );

      await _tap(tester, find.text('Choose a CSV file'));

      expect(rewards.uploaded.single.name, 'codes.csv');
      expect(
        find.text('120 codes added. 3 duplicates skipped.'),
        findsOneWidget,
      );
    });

    testWidgets('a file that is not a CSV is not sent', (tester) async {
      final rewards = FakeBrandRewardsRepository(rewards: sampleBrandRewards);
      await _openBrandRewards(
        tester,
        rewards,
        files: FakeImportFileActions(picks: [csvFile('codes.xlsx')]),
      );
      await _tap(tester, find.text('₹200 off your next order'));
      await _tap(tester, find.text('Choose a CSV file'));

      expect(rewards.uploaded, isEmpty);
      expect(
        find.text(
          "codes.xlsx isn't a CSV file. Save the sheet as .csv and try again.",
        ),
        findsOneWidget,
      );
    });

    testWidgets('no codes left warns the brand', (tester) async {
      await _openBrandRewards(
        tester,
        FakeBrandRewardsRepository(
          rewards: sampleBrandRewards,
          stats: const Ok(
            RewardStats(codesTotal: 50, codesLeft: 0, redeemed: 50),
          ),
        ),
      );
      await _tap(tester, find.text('₹200 off your next order'));

      expect(find.textContaining('No codes left'), findsOneWidget);
    });
  });

  group('form', () {
    testWidgets('a new reward needs its title, value and cost', (tester) async {
      final rewards = FakeBrandRewardsRepository();
      await _openBrandRewards(tester, rewards);
      await _tap(tester, find.widgetWithText(FilledButton, 'New reward'));

      await _tap(tester, find.widgetWithText(FilledButton, 'New reward'));

      expect(find.text('Enter a title.'), findsOneWidget);
      expect(find.text("Enter what it's worth."), findsOneWidget);
      expect(
        find.text('Enter a whole number from 1 to 100,000.'),
        findsOneWidget,
      );
      expect(rewards.created, isEmpty);
    });

    testWidgets('a new reward is saved and opened', (tester) async {
      final rewards = FakeBrandRewardsRepository();
      await _openBrandRewards(tester, rewards);
      await _tap(tester, find.widgetWithText(FilledButton, 'New reward'));

      await tester.enterText(_field('Title'), ' Free tote with any order ');
      await tester.enterText(_field('Value'), 'Free tote');
      await tester.enterText(_field('Points it costs'), '250');
      await _tap(tester, find.widgetWithText(FilledButton, 'New reward'));

      final draft = rewards.created.single;
      expect(draft.title, 'Free tote with any order');
      expect(draft.pointsCost, 250);
      expect(draft.startsAt, DateTime(2026, 11, 25));
      expect(draft.endsAt, isNull);
      expect(draft.isActive, isTrue);
      expect(draft.description, isNull);
      expect(find.text('Reward added. Upload its codes next.'), findsOneWidget);
      expect(find.text('Upload codes'), findsOneWidget);
    });

    testWidgets('editing keeps what is there and can drop the end date', (
      tester,
    ) async {
      final rewards = FakeBrandRewardsRepository(rewards: sampleBrandRewards);
      await _openBrandRewards(tester, rewards);
      await _tap(tester, find.text('₹200 off your next order'));
      await _tap(tester, find.byTooltip('Edit reward'));

      expect(find.text('31 Mar 2027'), findsOneWidget);
      await tester.enterText(_field('Points it costs'), '600');
      await _tap(tester, find.byTooltip('Remove end date'));
      await _tap(tester, find.byType(Switch));
      await _tap(tester, find.text('Save changes'));

      final (id, draft) = rewards.updated.single;
      expect(id, 'r1');
      expect(draft.pointsCost, 600);
      expect(draft.endsAt, isNull);
      expect(draft.isActive, isFalse);
      expect(draft.terms, 'One per order. Not with other offers. Online only.');
      expect(find.text('Changes saved'), findsOneWidget);
    });
  });

  group('BrandRewardsRepository', () {
    test('reads the list and one reward under the brand', () async {
      final reward = {
        'id': 'r1',
        'title': '₹200 off your next order',
        'valueText': '₹200 off',
        'pointsCost': 500,
        'startsAt': '2026-11-01T00:00:00.000Z',
        'endsAt': null,
        'active': false,
      };
      final adapter = FakeHttpAdapter([
        json(200, {
          'items': [reward],
        }),
        json(200, reward),
      ]);
      final api = _api(adapter);

      final list =
          (await api.fetchRewards('b1') as Ok<List<BrandReward>>).value;
      final one = (await api.fetchReward('b1', 'r1') as Ok<BrandReward>).value;

      expect(adapter.requests.first.uri.path, '/brand/b1/rewards');
      expect(adapter.requests.last.uri.path, '/brand/b1/rewards/r1');
      expect(list.single.isActive, isFalse);
      expect(one.startsAt, DateTime.utc(2026, 11));
      expect(one.endsAt, isNull);
    });

    test('creates, updates, reads stats and uploads codes', () async {
      final saved = {
        'id': 'r9',
        'title': 'T',
        'valueText': 'V',
        'pointsCost': 100,
        'startsAt': '2026-11-25T00:00:00.000Z',
        'active': true,
      };
      final adapter = FakeHttpAdapter([
        json(201, saved),
        json(200, saved),
        json(200, {'codesTotal': 10, 'codesLeft': 4, 'redeemed': 6}),
        json(201, {'added': 9, 'duplicates': 1}),
      ]);
      final api = _api(adapter);
      final draft = BrandRewardDraft(
        title: 'T',
        valueText: 'V',
        pointsCost: 100,
        startsAt: DateTime.utc(2026, 11, 25),
      );

      await api.createReward('b1', draft);
      await api.updateReward('b1', 'r9', draft);
      final stats = (await api.fetchStats('b1', 'r9') as Ok<RewardStats>).value;
      final report = (await api.uploadCodes(
        'b1',
        'r9',
        csvFile('c.csv'),
      ) as Ok<CodesUploadReport>).value;

      final [create, update, statsCall, upload] = adapter.requests;
      expect((create.method, create.uri.path), ('POST', '/brand/b1/rewards'));
      expect(create.data, containsPair('pointsCost', 100));
      expect(create.data, containsPair('endsAt', null));
      expect(
        (update.method, update.uri.path),
        ('PATCH', '/brand/b1/rewards/r9'),
      );
      expect(statsCall.uri.path, '/brand/b1/rewards/r9/stats');
      expect(upload.uri.path, '/brand/b1/rewards/r9/codes');
      expect(upload.data, isA<FormData>());
      expect(stats.codesLeft, 4);
      expect((report.added, report.duplicates), (9, 1));
    });
  });
}
