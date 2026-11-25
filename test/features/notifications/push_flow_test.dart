import 'package:flutter_test/flutter_test.dart';
import 'package:staka/core/auth/auth_tokens.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/digital_card.dart';
import 'package:staka/core/models/ownership.dart';
import 'package:staka/core/models/ownership_status.dart';
import 'package:staka/core/notifications/notification_models.dart';
import 'package:staka/core/push/push_messaging.dart';

import '../../helpers/auth_fakes.dart';
import '../../helpers/fake_http_adapter.dart';
import '../../helpers/notification_fakes.dart';
import '../../helpers/pump_app.dart';
import '../../helpers/pump_full_app.dart';
import '../../helpers/push_fakes.dart';
import '../../helpers/tag_fakes.dart';
import '../../helpers/wardrobe_fakes.dart';

const _tokens = AuthTokens(accessToken: 'a', refreshToken: 'r');
const _name = 'Organic Cotton Tee';

final DigitalCard _tee = cardFor(id: 'c1', name: _name);

const _tagMessage = PushMessage(
  title: 'Your receipt was approved',
  body: '$_name is now verified as yours.',
  data: {'target': 'tag', 'id': 'c1'},
);

Future<FakeTagRepository> _openApp(
  WidgetTester tester, {
  required FakePushMessaging push,
  FakeDeviceRepository? devices,
  FakeNotificationsRepository? notifications,
  List<Result<Ownership>> uploads = const [],
  List<FakeReply> laterReplies = const [],
}) async {
  usePhoneScreen(tester, height: 2600);
  final tags = FakeTagRepository(cards: [_tee], uploads: uploads);
  await pumpApp(
    tester,
    tokens: _tokens,
    replies: [json(200, userJson()), ...laterReplies],
    wardrobe: FakeWardrobeRepository(
      cards: [
        Ok([_tee]),
      ],
    ),
    tags: tags,
    receiptPicker: FakeReceiptPicker(receiptOf(1024)),
    push: push,
    devices: devices,
    notifications: notifications,
  );
  return tags;
}

Future<void> _sendReceipt(WidgetTester tester) async {
  await tester.tap(find.text(_name).first);
  await tester.pumpAndSettle();
  await tester.tap(find.text('Choose a photo or PDF'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Take a photo'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Send for review'));
  await tester.pumpAndSettle();
}

Ownership get _pending => Ownership(
  status: OwnershipStatus.pending,
  receiptAttemptsUsed: 1,
  receiptAttemptsLeft: 4,
  pendingSince: DateTime(2026, 11, 25),
);

void main() {
  group('registration', () {
    testWidgets('a phone that allows push is registered after sign-in', (
      tester,
    ) async {
      final push = FakePushMessaging(
        isAvailable: true,
        permissionNow: PushPermission.granted,
      );
      final devices = FakeDeviceRepository();
      await _openApp(tester, push: push, devices: devices);

      expect(devices.registered, ['token-1']);
      expect(push.permissionRequests, 0);

      push.refreshToken('token-2');
      await tester.pumpAndSettle();

      expect(devices.registered, ['token-1', 'token-2']);
    });

    testWidgets('nothing is registered or asked without permission', (
      tester,
    ) async {
      final push = FakePushMessaging(isAvailable: true);
      final devices = FakeDeviceRepository();
      await _openApp(tester, push: push, devices: devices);

      expect(devices.registered, isEmpty);
      expect(push.permissionRequests, 0);
    });

    testWidgets('signing out removes this phone', (tester) async {
      final push = FakePushMessaging(
        isAvailable: true,
        permissionNow: PushPermission.granted,
      );
      final devices = FakeDeviceRepository();
      await _openApp(
        tester,
        push: push,
        devices: devices,
        laterReplies: [json(204, null)],
      );

      await tester.tap(find.text('Account'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Sign out'));
      await tester.tap(find.text('Sign out'));
      await tester.pumpAndSettle();

      expect(devices.unregistered, ['token-1']);
      expect(push.tokenDeletes, 1);
    });
  });

  group('asking after the first receipt', () {
    testWidgets('yes asks the phone and registers it', (tester) async {
      final push = FakePushMessaging(isAvailable: true);
      final devices = FakeDeviceRepository();
      await _openApp(
        tester,
        push: push,
        devices: devices,
        uploads: [Ok(_pending)],
      );

      await _sendReceipt(tester);

      expect(find.text('Get a notification?'), findsOneWidget);
      await tester.tap(find.text('Yes, notify me'));
      await tester.pumpAndSettle();

      expect(push.permissionRequests, 1);
      expect(devices.registered, ['token-1']);
    });

    testWidgets('not now leaves the phone alone', (tester) async {
      final push = FakePushMessaging(isAvailable: true);
      await _openApp(tester, push: push, uploads: [Ok(_pending)]);

      await _sendReceipt(tester);
      await tester.tap(find.text('Not now'));
      await tester.pumpAndSettle();

      expect(push.permissionRequests, 0);
      expect(find.text('Get a notification?'), findsNothing);
    });

    testWidgets('not asked when the phone already answered', (tester) async {
      await _openApp(
        tester,
        push: FakePushMessaging(
          isAvailable: true,
          permissionNow: PushPermission.denied,
        ),
        uploads: [Ok(_pending)],
      );
      await _sendReceipt(tester);

      expect(find.text('Get a notification?'), findsNothing);
    });

    testWidgets('not asked without push', (tester) async {
      await _openApp(
        tester,
        push: FakePushMessaging(),
        uploads: [Ok(_pending)],
      );
      await _sendReceipt(tester);

      expect(find.text('Get a notification?'), findsNothing);
    });
  });

  group('messages', () {
    testWidgets('tapping one opens what it is about', (tester) async {
      final push = FakePushMessaging(
        isAvailable: true,
        permissionNow: PushPermission.granted,
      );
      await _openApp(tester, push: push);

      push.tap(_tagMessage);
      await tester.pumpAndSettle();

      expect(find.text('Share this tag'), findsNothing);
      expect(find.text('Upload a receipt'), findsOneWidget);
    });

    testWidgets('the one that started the app opens once signed in', (
      tester,
    ) async {
      final push = FakePushMessaging(
        isAvailable: true,
        permissionNow: PushPermission.granted,
        initial: _tagMessage,
      );
      await _openApp(tester, push: push);

      expect(find.text('Upload a receipt'), findsOneWidget);
    });

    testWidgets('one arriving in the app shows a banner that opens it', (
      tester,
    ) async {
      final push = FakePushMessaging(
        isAvailable: true,
        permissionNow: PushPermission.granted,
      );
      await _openApp(tester, push: push);

      push.receive(_tagMessage);
      await tester.pumpAndSettle();

      expect(find.textContaining('Your receipt was approved'), findsOneWidget);
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Upload a receipt'), findsOneWidget);
    });

    testWidgets('one leading nowhere shows no Open', (tester) async {
      final push = FakePushMessaging(
        isAvailable: true,
        permissionNow: PushPermission.granted,
      );
      await _openApp(tester, push: push);

      push.receive(
        const PushMessage(
          title: 'Something new',
          data: {'target': 'somethingNew'},
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Something new'), findsOneWidget);
      expect(find.text('Open'), findsNothing);
    });

    test('a message reads like an inbox entry', () {
      final notification = const PushMessage(
        title: 'A receipt to check',
        data: {'target': 'brandClaim', 'id': 'cl9', 'brandId': 'b1'},
      ).asNotification;

      expect(notification.target, NotificationTarget.brandClaim);
      expect(notification.targetId, 'cl9');
      expect(notification.brandId, 'b1');
    });
  });

  group('settings', () {
    Future<void> openSettings(
      WidgetTester tester,
      FakePushMessaging push,
    ) async {
      await _openApp(
        tester,
        push: push,
        notifications: FakeNotificationsRepository(
          settings: const Ok(NotificationSettings(push: true, email: true)),
        ),
      );
      await tester.tap(find.text('Account'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Push and email'));
      await tester.pumpAndSettle();
    }

    testWidgets('the phone not asked yet: Allow asks it', (tester) async {
      final push = FakePushMessaging(isAvailable: true);
      await openSettings(tester, push);

      expect(find.text('Notifications are off on this phone'), findsOneWidget);
      await tester.tap(find.text('Allow notifications'));
      await tester.pumpAndSettle();

      expect(push.permissionRequests, 1);
      expect(find.text('Notifications are off on this phone'), findsNothing);
    });

    testWidgets("refused: points to the phone's settings", (tester) async {
      await openSettings(
        tester,
        FakePushMessaging(
          isAvailable: true,
          permissionNow: PushPermission.denied,
        ),
      );

      expect(
        find.text(
          "To get them, turn on notifications for STAKA in your phone's "
          'settings.',
        ),
        findsOneWidget,
      );
      expect(find.text('Allow notifications'), findsNothing);
    });

    testWidgets('no notice when push is allowed', (tester) async {
      await openSettings(
        tester,
        FakePushMessaging(
          isAvailable: true,
          permissionNow: PushPermission.granted,
        ),
      );

      expect(find.text('Push notifications'), findsOneWidget);
      expect(find.text('Notifications are off on this phone'), findsNothing);
    });

    testWidgets('no notice without push', (tester) async {
      await openSettings(tester, FakePushMessaging());

      expect(find.text('Push notifications'), findsOneWidget);
      expect(find.text('Notifications are off on this phone'), findsNothing);
    });
  });
}
