// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The notification inbox (V2-9), 20 at a time as the person scrolls.
/// Opening one marks it read; "Mark all as read" reads them all. Both
/// update the list at once and tell the bell to reload.

@ProviderFor(NotificationsController)
final notificationsControllerProvider = NotificationsControllerProvider._();

/// The notification inbox (V2-9), 20 at a time as the person scrolls.
/// Opening one marks it read; "Mark all as read" reads them all. Both
/// update the list at once and tell the bell to reload.
final class NotificationsControllerProvider
    extends $NotifierProvider<NotificationsController, NotificationsState> {
  /// The notification inbox (V2-9), 20 at a time as the person scrolls.
  /// Opening one marks it read; "Mark all as read" reads them all. Both
  /// update the list at once and tell the bell to reload.
  NotificationsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationsControllerHash();

  @$internal
  @override
  NotificationsController create() => NotificationsController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotificationsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotificationsState>(value),
    );
  }
}

String _$notificationsControllerHash() =>
    r'ad0deb1d9d4e1935b30665cbcf48e7e16b0e7ed5';

/// The notification inbox (V2-9), 20 at a time as the person scrolls.
/// Opening one marks it read; "Mark all as read" reads them all. Both
/// update the list at once and tell the bell to reload.

abstract class _$NotificationsController extends $Notifier<NotificationsState> {
  NotificationsState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<NotificationsState, NotificationsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<NotificationsState, NotificationsState>,
              NotificationsState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
