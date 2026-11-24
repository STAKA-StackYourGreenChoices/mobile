import 'package:staka/app/routes.dart';
import 'package:staka/core/notifications/notification_models.dart';

/// Where tapping a notification goes (V2-9). Routes in the wardrobe are
/// pushed on top of the inbox; the others open in their own tab. A brand
/// id is selected in the Brand tab first.
typedef NotificationDestination = ({
  AppRoute route,
  Map<String, String> pathParameters,
  bool isInWardrobe,
  String? brandId,
});

/// Null when the notification leads nowhere the app has yet (rewards and
/// vouchers arrive with M4) or its link is incomplete: it is then only
/// marked read.
NotificationDestination? notificationDestination(AppNotification n) {
  final id = n.targetId;
  return switch (n.target) {
    NotificationTarget.tag when id != null => (
      route: AppRoute.tag,
      pathParameters: {'id': id},
      isInWardrobe: true,
      brandId: null,
    ),
    NotificationTarget.activity => (
      route: AppRoute.activity,
      pathParameters: const {},
      isInWardrobe: true,
      brandId: null,
    ),
    NotificationTarget.claim when id != null => (
      route: AppRoute.adminClaim,
      pathParameters: {'id': id},
      isInWardrobe: false,
      brandId: null,
    ),
    NotificationTarget.dispute when id != null => (
      route: AppRoute.adminDispute,
      pathParameters: {'id': id},
      isInWardrobe: false,
      brandId: null,
    ),
    NotificationTarget.brandClaim when id != null && n.brandId != null => (
      route: AppRoute.brandClaim,
      pathParameters: {'id': id},
      isInWardrobe: false,
      brandId: n.brandId,
    ),
    NotificationTarget.brandApplication => (
      route: AppRoute.brandApplications,
      pathParameters: const {},
      isInWardrobe: false,
      brandId: null,
    ),
    _ => null,
  };
}
