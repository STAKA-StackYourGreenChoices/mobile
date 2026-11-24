import 'package:flutter/foundation.dart';

/// Where a notification leads (`data.target`, V2-9). The API's names are
/// fixed: keep [apiName] as is; anything else is [none].
enum NotificationTarget {
  tag('tag'),
  claim('claim'),
  dispute('dispute'),
  rewards('rewards'),
  voucher('voucher'),
  activity('activity'),
  brandClaim('brandClaim'),
  brandApplication('brandApplication'),
  none('');

  new(this.apiName);

  final String apiName;

  static NotificationTarget fromApi(String? name) =>
      values.firstWhere((t) => t.apiName == name, orElse: () => none);
}

/// One notification in the inbox.
@immutable
class AppNotification {
  const new({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.createdAt,
    this.readAt,
    this.target = NotificationTarget.none,
    this.targetId,
    this.brandId,
  });

  /// `{id, type, title, body, data: {target, id?, brandId?}, readAt?,
  /// createdAt}`.
  factory fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? const {};
    final readAt = json['readAt'] as String?;
    return AppNotification(
      id: json['id'] as String,
      type: json['type'] as String? ?? '',
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
      readAt: readAt == null ? null : DateTime.parse(readAt),
      target: NotificationTarget.fromApi(data['target'] as String?),
      targetId: data['id'] as String?,
      brandId: data['brandId'] as String?,
    );
  }

  final String id;

  /// The API's type, e.g. `CLAIM_APPROVED`; picks the icon.
  final String type;
  final String title;
  final String body;
  final DateTime createdAt;
  final DateTime? readAt;
  final NotificationTarget target;
  final String? targetId;
  final String? brandId;

  bool get isRead => readAt != null;

  AppNotification markedRead(DateTime at) => AppNotification(
    id: id,
    type: type,
    title: title,
    body: body,
    createdAt: createdAt,
    readAt: readAt ?? at,
    target: target,
    targetId: targetId,
    brandId: brandId,
  );
}

/// One page of `GET /me/notifications`, with the unread count of all.
@immutable
class NotificationPage {
  const new({
    required this.items,
    required this.total,
    required this.unreadCount,
  });

  final List<AppNotification> items;
  final int total;
  final int unreadCount;
}

/// `GET/PATCH /me/notification-settings`.
@immutable
class NotificationSettings {
  const new({required this.push, required this.email});

  final bool push;
  final bool email;
}
