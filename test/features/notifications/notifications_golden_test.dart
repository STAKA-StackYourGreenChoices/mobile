@Tags(['golden'])
library;

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/auth/session_repository.dart';
import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/notifications/notification_models.dart';
import 'package:staka/core/notifications/notifications_repository.dart';
import 'package:staka/core/push/push_messaging.dart';
import 'package:staka/features/notifications/presentation/screens/notification_settings_screen.dart';
import 'package:staka/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:staka/features/notifications/presentation/state/notifications_controller.dart';

import '../../helpers/auth_fakes.dart';
import '../../helpers/fake_http_adapter.dart';
import '../../helpers/golden.dart';
import '../../helpers/notification_fakes.dart';
import '../../helpers/pump_app.dart';
import '../../helpers/push_fakes.dart';

final List<AppNotification> _items = [
  notificationFor('n1', at: DateTime.utc(2026, 11, 24)),
  notificationFor(
    'n2',
    title: 'A receipt to check',
    body: 'Someone sent a receipt for Recycled Denim Jeans.',
    target: NotificationTarget.brandClaim,
    brandId: 'b1',
    at: DateTime.utc(2026, 11, 23),
  ),
  notificationFor(
    'n3',
    title: 'Your tag was viewed 10 times',
    body: 'People are looking at your Organic Cotton Tee.',
    target: NotificationTarget.activity,
    isRead: true,
    at: DateTime.utc(2026, 11, 20),
  ),
  notificationFor(
    'n4',
    title: "We couldn't verify your receipt",
    body: 'The date on the receipt is not readable. You can send another.',
    isRead: true,
    at: DateTime.utc(2026, 11, 18),
  ),
];

void main() {
  setUpAll(loadAppFonts);

  for (final brightness in Brightness.values) {
    testWidgets('notifications, ${brightness.name}', (tester) async {
      usePhoneScreen(tester, height: 760);
      await pumpThemed(
        tester,
        Padding(
          padding: AppSpacing.screenH,
          child: NotificationsScrollView(
            state: NotificationsLoaded(
              items: _items,
              total: _items.length,
              unreadCount: 2,
              loadedPages: 1,
            ),
            onRefresh: () async {},
            onRetry: () {},
            onLoadMore: () {},
            onPressed: (_) {},
            onMarkAllRead: () {},
          ),
        ),
        brightness: brightness,
      );
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/notifications_${brightness.name}.png'),
      );
    });

    testWidgets('phone push off, ${brightness.name}', (tester) async {
      usePhoneScreen(tester, height: 360);
      await pumpThemed(
        tester,
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            spacing: AppSpacing.md,
            children: [
              PhonePushOffNotice(canAsk: true, onAllowPressed: () {}),
              PhonePushOffNotice(canAsk: false, onAllowPressed: () {}),
            ],
          ),
        ),
        brightness: brightness,
      );
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/phone_push_off_${brightness.name}.png'),
      );
    });

    testWidgets('notification settings, ${brightness.name}', (tester) async {
      usePhoneScreen(tester, height: 600);
      await pumpThemed(
        tester,
        ProviderScope(
          overrides: [
            // Push reads the session; signed out here, push unavailable.
            sessionRepositoryProvider.overrideWithValue(
              SessionRepository(
                Dio()..httpClientAdapter = FakeHttpAdapter([]),
                InMemoryTokenStore(),
              ),
            ),
            pushMessagingProvider.overrideWithValue(FakePushMessaging()),
            notificationsRepositoryProvider.overrideWithValue(
              FakeNotificationsRepository(
                settings: const Ok(
                  NotificationSettings(push: true, email: false),
                ),
              ),
            ),
          ],
          child: const NotificationSettingsScreen(),
        ),
        brightness: brightness,
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile(
          'goldens/notification_settings_${brightness.name}.png',
        ),
      );
    });
  }
}
