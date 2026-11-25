import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/app/routes.dart';
import 'package:staka/core/auth/auth_tokens.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/digital_card.dart';
import 'package:staka/core/models/ownership_status.dart';
import 'package:staka/core/notifications/notification_models.dart';
import 'package:staka/features/notifications/presentation/notification_destination.dart';

import '../../helpers/auth_fakes.dart';
import '../../helpers/fake_http_adapter.dart';
import '../../helpers/notification_fakes.dart';
import '../../helpers/pump_app.dart';
import '../../helpers/pump_full_app.dart';
import '../../helpers/tag_fakes.dart';
import '../../helpers/wardrobe_fakes.dart';

const _tokens = AuthTokens(accessToken: 'a', refreshToken: 'r');
final DigitalCard _tee = cardFor(
  id: 'c1',
  name: 'Organic Cotton Tee',
  status: OwnershipStatus.verified,
);

Future<void> _openWardrobe(
  WidgetTester tester,
  FakeNotificationsRepository notifications, {
  double height = 3000,
}) async {
  usePhoneScreen(tester, height: height);
  await pumpApp(
    tester,
    tokens: _tokens,
    replies: [json(200, userJson())],
    wardrobe: FakeWardrobeRepository(
      cards: [
        Ok([_tee]),
      ],
    ),
    tags: FakeTagRepository(cards: [_tee]),
    notifications: notifications,
  );
}

Future<void> _openInbox(WidgetTester tester, String bellLabel) async {
  await tester.tap(find.byTooltip(bellLabel));
  await tester.pumpAndSettle();
}

void main() {
  group('bell', () {
    testWidgets('shows the unread count and opens the inbox', (tester) async {
      final notifications = FakeNotificationsRepository(
        pages: {
          1: Ok(
            notificationPage([
              notificationFor('n1'),
              notificationFor('n2', title: 'Your tag was viewed 10 times'),
              notificationFor('n3', title: 'Welcome to STAKA', isRead: true),
            ]),
          ),
        },
      );
      await _openWardrobe(tester, notifications);

      expect(find.byTooltip('2 unread notifications'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);

      await _openInbox(tester, '2 unread notifications');

      expect(find.text('Your receipt was approved'), findsOneWidget);
      expect(find.text('Welcome to STAKA'), findsOneWidget);
      expect(find.text('Mark all as read'), findsOneWidget);
    });

    testWidgets('is not shown when the inbox cannot load', (tester) async {
      await _openWardrobe(tester, FakeNotificationsRepository());

      expect(find.text('Organic Cotton Tee'), findsWidgets);
      expect(find.byIcon(Icons.notifications_rounded), findsNothing);
      expect(find.byIcon(Icons.notifications_none_rounded), findsNothing);
    });

    testWidgets('with nothing unread it shows no count', (tester) async {
      await _openWardrobe(
        tester,
        FakeNotificationsRepository(
          pages: {
            1: Ok(notificationPage([notificationFor('n1', isRead: true)])),
          },
        ),
      );

      expect(find.byTooltip('Notifications'), findsOneWidget);
      expect(find.byIcon(Icons.notifications_none_rounded), findsOneWidget);
    });
  });

  group('inbox', () {
    testWidgets('a tap marks it read and opens the tag', (tester) async {
      final notifications = FakeNotificationsRepository(
        pages: {
          1: Ok(notificationPage([notificationFor('n1')])),
        },
      );
      await _openWardrobe(tester, notifications);
      await _openInbox(tester, '1 unread notification');

      await tester.tap(find.text('Your receipt was approved'));
      await tester.pumpAndSettle();

      expect(notifications.markedRead, ['n1']);
      expect(find.text('Share this tag'), findsOneWidget);
    });

    testWidgets('one already read is not marked again', (tester) async {
      final notifications = FakeNotificationsRepository(
        pages: {
          1: Ok(
            notificationPage([
              notificationFor(
                'n1',
                isRead: true,
                target: NotificationTarget.none,
              ),
            ]),
          ),
        },
      );
      await _openWardrobe(tester, notifications);
      await _openInbox(tester, 'Notifications');

      await tester.tap(find.text('Your receipt was approved'));
      await tester.pumpAndSettle();

      expect(notifications.markedRead, isEmpty);
      expect(find.text('Your receipt was approved'), findsOneWidget);
    });

    testWidgets('mark all as read clears the count', (tester) async {
      final notifications = FakeNotificationsRepository(
        pages: {
          1: Ok(
            notificationPage([notificationFor('n1'), notificationFor('n2')]),
          ),
        },
      );
      await _openWardrobe(tester, notifications);
      await _openInbox(tester, '2 unread notifications');
      expect(find.text('2 unread notifications'), findsOneWidget);

      await tester.tap(find.text('Mark all as read'));
      await tester.pumpAndSettle();

      expect(notifications.markAllCalls, 1);
      expect(find.text('Mark all as read'), findsNothing);
      expect(
        find.text('Decisions about your pieces, shares and rewards.'),
        findsOneWidget,
      );
    });

    testWidgets('mark all as read failing says so and keeps them', (
      tester,
    ) async {
      final notifications = FakeNotificationsRepository(
        pages: {
          1: Ok(notificationPage([notificationFor('n1')])),
        },
        markAllResult: const Err(NetworkFailure()),
      );
      await _openWardrobe(tester, notifications);
      await _openInbox(tester, '1 unread notification');

      await tester.tap(find.text('Mark all as read'));
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Mark all as read'), findsOneWidget);
    });

    testWidgets('loads more as you scroll', (tester) async {
      final first = [
        for (var n = 1; n <= 20; n++)
          notificationFor('n$n', title: 'Note $n', isRead: true),
      ];
      final notifications = FakeNotificationsRepository(
        pages: {
          1: Ok(notificationPage(first, total: 22, unread: 1)),
          2: Ok(
            notificationPage([
              notificationFor('n21', title: 'Note 21', isRead: true),
              notificationFor('n22', title: 'Note 22'),
            ], total: 22),
          ),
        },
      );
      await _openWardrobe(tester, notifications, height: 800);
      await _openInbox(tester, '1 unread notification');
      // The bell's own count read page 1 too.
      expect(notifications.fetchedPages, [1, 1]);

      await tester.fling(
        find.byType(CustomScrollView),
        const Offset(0, -4000),
        3000,
      );
      await tester.pumpAndSettle();

      expect(notifications.fetchedPages, [1, 1, 2]);
      expect(find.text('Note 22'), findsOneWidget);
    });
  });

  group('settings', () {
    Future<void> openSettings(
      WidgetTester tester,
      FakeNotificationsRepository notifications,
    ) async {
      await _openWardrobe(tester, notifications);
      await tester.tap(find.text('Account'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Push and email'));
      await tester.pumpAndSettle();
    }

    testWidgets('turning push off saves it', (tester) async {
      final notifications = FakeNotificationsRepository(
        settings: const Ok(NotificationSettings(push: true, email: true)),
      );
      await openSettings(tester, notifications);

      await tester.tap(find.text('Push notifications'));
      await tester.pumpAndSettle();

      expect(notifications.updates, [(push: false, email: null)]);
      final push = tester.widget<SwitchListTile>(
        find.widgetWithText(SwitchListTile, 'Push notifications'),
      );
      expect(push.value, isFalse);
    });

    testWidgets('a failed change goes back and says so', (tester) async {
      final notifications = FakeNotificationsRepository(
        settings: const Ok(NotificationSettings(push: true, email: true)),
        updateFailure: const NetworkFailure(),
      );
      await openSettings(tester, notifications);

      await tester.tap(find.text('Emails'));
      await tester.pumpAndSettle();

      expect(notifications.updates, [(push: null, email: false)]);
      final email = tester.widget<SwitchListTile>(
        find.widgetWithText(SwitchListTile, 'Emails'),
      );
      expect(email.value, isTrue);
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('a failed load can be retried', (tester) async {
      await openSettings(tester, FakeNotificationsRepository());

      expect(find.text('Try again'), findsOneWidget);
    });
  });

  group('destination', () {
    test('tags and activity stay in the wardrobe', () {
      final tag = notificationDestination(notificationFor('n1'))!;
      expect(tag.route, AppRoute.tag);
      expect(tag.pathParameters, {'id': 'c1'});
      expect(tag.isInWardrobe, isTrue);

      final activity = notificationDestination(
        notificationFor(
          'n2',
          target: NotificationTarget.activity,
          targetId: null,
        ),
      )!;
      expect(activity.route, AppRoute.activity);
    });

    test('a brand claim selects its brand', () {
      final claim = notificationDestination(
        notificationFor(
          'n1',
          target: NotificationTarget.brandClaim,
          targetId: 'cl9',
          brandId: 'b1',
        ),
      )!;
      expect(claim.route, AppRoute.brandClaim);
      expect(claim.pathParameters, {'id': 'cl9'});
      expect(claim.brandId, 'b1');
      expect(claim.isInWardrobe, isFalse);
    });

    test('admin reviews open the claim or dispute', () {
      expect(
        notificationDestination(
          notificationFor('n1', target: NotificationTarget.claim),
        )!.route,
        AppRoute.adminClaim,
      );
      expect(
        notificationDestination(
          notificationFor('n1', target: NotificationTarget.dispute),
        )!.route,
        AppRoute.adminDispute,
      );
    });

    test('rewards open the Rewards tab', () {
      final rewards = notificationDestination(
        notificationFor('n1', target: NotificationTarget.rewards),
      )!;
      expect(rewards.route, AppRoute.rewards);
      expect(rewards.isInWardrobe, isFalse);
    });

    test('vouchers open My vouchers in the Rewards tab', () {
      final vouchers = notificationDestination(
        notificationFor('n1', target: NotificationTarget.voucher),
      )!;
      expect(vouchers.route, AppRoute.rewardVouchers);
      expect(vouchers.isInWardrobe, isFalse);
    });

    test('unknown targets and missing ids go nowhere', () {
      for (final n in [
        notificationFor('n3', target: NotificationTarget.none),
        notificationFor('n4', targetId: null),
        notificationFor('n5', target: NotificationTarget.brandClaim),
      ]) {
        expect(notificationDestination(n), isNull, reason: n.id);
      }
    });
  });
}
