import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/notifications/notification_models.dart';
import 'package:staka/core/notifications/notifications_repository.dart';

/// The notification inbox (V2-9). With no script the inbox can't be loaded,
/// so the wardrobe shows no bell (as with an older API). Pages are answered
/// by page number; read requests and setting changes are recorded.
class FakeNotificationsRepository implements NotificationsRepository {
  new({
    Map<int, Result<NotificationPage>> pages = const {},
    this.settings = const Err(NotFoundFailure([])),
    this.markReadResult = const Ok(null),
    this.markAllResult = const Ok(null),
    this.updateFailure,
  }) : _pages = {...pages};

  final Map<int, Result<NotificationPage>> _pages;
  Result<NotificationSettings> settings;
  Result<void> markReadResult;
  Result<void> markAllResult;

  /// When set, every settings change fails with it.
  Failure? updateFailure;

  final List<int> fetchedPages = [];
  final List<String> markedRead = [];
  int markAllCalls = 0;
  final List<({bool? push, bool? email})> updates = [];

  @override
  Future<Result<NotificationPage>> fetchPage(int page) async {
    fetchedPages.add(page);
    return _pages[page] ?? const Err(NotFoundFailure([]));
  }

  @override
  Future<Result<void>> markRead(String id) async {
    markedRead.add(id);
    return markReadResult;
  }

  @override
  Future<Result<void>> markAllRead() async {
    markAllCalls++;
    return markAllResult;
  }

  @override
  Future<Result<NotificationSettings>> fetchSettings() async => settings;

  @override
  Future<Result<NotificationSettings>> updateSettings({
    bool? push,
    bool? email,
  }) async {
    updates.add((push: push, email: email));
    if (updateFailure case final failure?) return Err(failure);
    final current = switch (settings) {
      Ok(:final value) => value,
      Err() => const NotificationSettings(push: true, email: true),
    };
    final saved = NotificationSettings(
      push: push ?? current.push,
      email: email ?? current.email,
    );
    settings = Ok(saved);
    return Ok(saved);
  }
}

AppNotification notificationFor(
  String id, {
  String title = 'Your receipt was approved',
  String body = 'Organic Cotton Tee is now verified as yours.',
  NotificationTarget target = NotificationTarget.tag,
  String? targetId = 'c1',
  String? brandId,
  bool isRead = false,
  DateTime? at,
}) => AppNotification(
  id: id,
  type: 'CLAIM_APPROVED',
  title: title,
  body: body,
  createdAt: at ?? DateTime.utc(2026, 11, 22),
  readAt: isRead ? DateTime.utc(2026, 11, 23) : null,
  target: target,
  targetId: targetId,
  brandId: brandId,
);

NotificationPage notificationPage(
  List<AppNotification> items, {
  int? total,
  int? unread,
}) => NotificationPage(
  items: items,
  total: total ?? items.length,
  unreadCount: unread ?? items.where((n) => !n.isRead).length,
);
