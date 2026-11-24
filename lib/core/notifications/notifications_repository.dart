import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/cards/cards_revision.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/network/dio_client.dart';
import 'package:staka/core/network/guard_api.dart';
import 'package:staka/core/notifications/notification_models.dart';

part 'notifications_repository.g.dart';

/// The notification inbox and settings (V2-9). In core because the
/// wardrobe's bell and the notifications screens both use it.
abstract interface class NotificationsRepository {
  /// [page] starts at 1.
  Future<Result<NotificationPage>> fetchPage(int page);
  Future<Result<void>> markRead(String id);
  Future<Result<void>> markAllRead();
  Future<Result<NotificationSettings>> fetchSettings();

  /// Answers the settings as saved.
  Future<Result<NotificationSettings>> updateSettings({
    bool? push,
    bool? email,
  });
}

@riverpod
NotificationsRepository notificationsRepository(Ref ref) =>
    ApiNotificationsRepository(ref.watch(dioProvider));

class ApiNotificationsRepository implements NotificationsRepository {
  const new(this._dio);

  final Dio _dio;

  static const pageSize = 20;

  @override
  Future<Result<NotificationPage>> fetchPage(int page) => guardApi(() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/me/notifications',
      queryParameters: {'page': page, 'limit': pageSize},
    );
    final body = response.data!;
    final items = [
      for (final item in body['items'] as List<dynamic>)
        AppNotification.fromJson(item as Map<String, dynamic>),
    ];
    return NotificationPage(
      items: items,
      total: (body['total'] as num?)?.toInt() ?? items.length,
      unreadCount: (body['unreadCount'] as num?)?.toInt() ?? 0,
    );
  });

  @override
  Future<Result<void>> markRead(String id) => guardApi(
    () => _dio.post<void>('/me/notifications/${Uri.encodeComponent(id)}/read'),
  );

  @override
  Future<Result<void>> markAllRead() =>
      guardApi(() => _dio.post<void>('/me/notifications/read-all'));

  @override
  Future<Result<NotificationSettings>> fetchSettings() => guardApi(() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/me/notification-settings',
    );
    return _settings(response.data!);
  });

  @override
  Future<Result<NotificationSettings>> updateSettings({
    bool? push,
    bool? email,
  }) => guardApi(() async {
    final response = await _dio.patch<Map<String, dynamic>>(
      '/me/notification-settings',
      data: {'push': ?push, 'email': ?email},
    );
    return _settings(response.data!);
  });

  static NotificationSettings _settings(Map<String, dynamic> json) =>
      NotificationSettings(
        push: json['push'] as bool? ?? true,
        email: json['email'] as bool? ?? true,
      );
}

/// Goes up after a notification is read, so the bell's count reloads.
@Riverpod(keepAlive: true)
class NotificationsRevision extends _$NotificationsRevision {
  @override
  int build() => 0;

  void bump() => state++;
}

/// Unread notifications for the bell. Null when they couldn't be loaded
/// (e.g. an API without them): the bell is then not shown. Reloads after
/// reading and whenever the tags change (a decision may have arrived).
@riverpod
Future<int?> unreadNotificationCount(Ref ref) async {
  ref
    ..watch(notificationsRevisionProvider)
    ..watch(cardsRevisionProvider);
  final result = await ref.read(notificationsRepositoryProvider).fetchPage(1);
  return switch (result) {
    Ok(:final value) => value.unreadCount,
    Err() => null,
  };
}
