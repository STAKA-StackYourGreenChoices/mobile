// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(notificationsRepository)
final notificationsRepositoryProvider = NotificationsRepositoryProvider._();

final class NotificationsRepositoryProvider
    extends
        $FunctionalProvider<
          NotificationsRepository,
          NotificationsRepository,
          NotificationsRepository
        >
    with $Provider<NotificationsRepository> {
  NotificationsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationsRepositoryHash();

  @$internal
  @override
  $ProviderElement<NotificationsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  NotificationsRepository create(Ref ref) {
    return notificationsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotificationsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotificationsRepository>(value),
    );
  }
}

String _$notificationsRepositoryHash() =>
    r'b55c05cc7984f7dcf6005b2cbabb768e1e32ea19';

/// Goes up after a notification is read, so the bell's count reloads.

@ProviderFor(NotificationsRevision)
final notificationsRevisionProvider = NotificationsRevisionProvider._();

/// Goes up after a notification is read, so the bell's count reloads.
final class NotificationsRevisionProvider
    extends $NotifierProvider<NotificationsRevision, int> {
  /// Goes up after a notification is read, so the bell's count reloads.
  NotificationsRevisionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationsRevisionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationsRevisionHash();

  @$internal
  @override
  NotificationsRevision create() => NotificationsRevision();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$notificationsRevisionHash() =>
    r'fded09ac391590cfdfaba1d5f7c395546376126c';

/// Goes up after a notification is read, so the bell's count reloads.

abstract class _$NotificationsRevision extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Unread notifications for the bell. Null when they couldn't be loaded
/// (e.g. an API without them): the bell is then not shown. Reloads after
/// reading and whenever the tags change (a decision may have arrived).

@ProviderFor(unreadNotificationCount)
final unreadNotificationCountProvider = UnreadNotificationCountProvider._();

/// Unread notifications for the bell. Null when they couldn't be loaded
/// (e.g. an API without them): the bell is then not shown. Reloads after
/// reading and whenever the tags change (a decision may have arrived).

final class UnreadNotificationCountProvider
    extends $FunctionalProvider<AsyncValue<int?>, int?, FutureOr<int?>>
    with $FutureModifier<int?>, $FutureProvider<int?> {
  /// Unread notifications for the bell. Null when they couldn't be loaded
  /// (e.g. an API without them): the bell is then not shown. Reloads after
  /// reading and whenever the tags change (a decision may have arrived).
  UnreadNotificationCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'unreadNotificationCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$unreadNotificationCountHash();

  @$internal
  @override
  $FutureProviderElement<int?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int?> create(Ref ref) {
    return unreadNotificationCount(ref);
  }
}

String _$unreadNotificationCountHash() =>
    r'fdbcef7af06e1da7f5ec951f3823c8499d01a314';
