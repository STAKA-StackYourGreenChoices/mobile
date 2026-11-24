// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_settings_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Account → Notifications (V2-9): push and email on or off. A switch
/// moves at once and goes back if the API says no.

@ProviderFor(NotificationSettingsController)
final notificationSettingsControllerProvider =
    NotificationSettingsControllerProvider._();

/// Account → Notifications (V2-9): push and email on or off. A switch
/// moves at once and goes back if the API says no.
final class NotificationSettingsControllerProvider
    extends
        $NotifierProvider<
          NotificationSettingsController,
          NotificationSettingsState
        > {
  /// Account → Notifications (V2-9): push and email on or off. A switch
  /// moves at once and goes back if the API says no.
  NotificationSettingsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationSettingsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationSettingsControllerHash();

  @$internal
  @override
  NotificationSettingsController create() => NotificationSettingsController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotificationSettingsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotificationSettingsState>(value),
    );
  }
}

String _$notificationSettingsControllerHash() =>
    r'5c6ea75738881a63737ee2cc0bcded9e7fef177a';

/// Account → Notifications (V2-9): push and email on or off. A switch
/// moves at once and goes back if the API says no.

abstract class _$NotificationSettingsController
    extends $Notifier<NotificationSettingsState> {
  NotificationSettingsState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<NotificationSettingsState, NotificationSettingsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<NotificationSettingsState, NotificationSettingsState>,
              NotificationSettingsState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
