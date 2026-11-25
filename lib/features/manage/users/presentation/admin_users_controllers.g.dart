// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_users_controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Admin → Users: one search at a time; an older answer is dropped.

@ProviderFor(UserSearchController)
final userSearchControllerProvider = UserSearchControllerProvider._();

/// Admin → Users: one search at a time; an older answer is dropped.
final class UserSearchControllerProvider
    extends $NotifierProvider<UserSearchController, UserSearchState> {
  /// Admin → Users: one search at a time; an older answer is dropped.
  UserSearchControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userSearchControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userSearchControllerHash();

  @$internal
  @override
  UserSearchController create() => UserSearchController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserSearchState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserSearchState>(value),
    );
  }
}

String _$userSearchControllerHash() =>
    r'2527f34e957190a9172b4b242cd978071079919d';

/// Admin → Users: one search at a time; an older answer is dropped.

abstract class _$UserSearchController extends $Notifier<UserSearchState> {
  UserSearchState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<UserSearchState, UserSearchState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<UserSearchState, UserSearchState>,
              UserSearchState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Bumped after an adjustment so the user and their points reload.

@ProviderFor(AdminUsersRevision)
final adminUsersRevisionProvider = AdminUsersRevisionProvider._();

/// Bumped after an adjustment so the user and their points reload.
final class AdminUsersRevisionProvider
    extends $NotifierProvider<AdminUsersRevision, int> {
  /// Bumped after an adjustment so the user and their points reload.
  AdminUsersRevisionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminUsersRevisionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminUsersRevisionHash();

  @$internal
  @override
  AdminUsersRevision create() => AdminUsersRevision();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$adminUsersRevisionHash() =>
    r'990a687e6070a01131b374cfa33593effebece5b';

/// Bumped after an adjustment so the user and their points reload.

abstract class _$AdminUsersRevision extends $Notifier<int> {
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

@ProviderFor(adminUser)
final adminUserProvider = AdminUserFamily._();

final class AdminUserProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<AdminUser>>,
          Result<AdminUser>,
          FutureOr<Result<AdminUser>>
        >
    with
        $FutureModifier<Result<AdminUser>>,
        $FutureProvider<Result<AdminUser>> {
  AdminUserProvider._({
    required AdminUserFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'adminUserProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$adminUserHash();

  @override
  String toString() {
    return r'adminUserProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Result<AdminUser>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<AdminUser>> create(Ref ref) {
    final argument = this.argument as String;
    return adminUser(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AdminUserProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$adminUserHash() => r'888ff7623752e5a98842ab4e016e3308f7d4ec88';

final class AdminUserFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Result<AdminUser>>, String> {
  AdminUserFamily._()
    : super(
        retry: null,
        name: r'adminUserProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AdminUserProvider call(String id) =>
      AdminUserProvider._(argument: id, from: this);

  @override
  String toString() => r'adminUserProvider';
}

/// The latest 20 entries (enough to answer "where did my points go").

@ProviderFor(adminUserPoints)
final adminUserPointsProvider = AdminUserPointsFamily._();

/// The latest 20 entries (enough to answer "where did my points go").

final class AdminUserPointsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<PointsPage>>,
          Result<PointsPage>,
          FutureOr<Result<PointsPage>>
        >
    with
        $FutureModifier<Result<PointsPage>>,
        $FutureProvider<Result<PointsPage>> {
  /// The latest 20 entries (enough to answer "where did my points go").
  AdminUserPointsProvider._({
    required AdminUserPointsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'adminUserPointsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$adminUserPointsHash();

  @override
  String toString() {
    return r'adminUserPointsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Result<PointsPage>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<PointsPage>> create(Ref ref) {
    final argument = this.argument as String;
    return adminUserPoints(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AdminUserPointsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$adminUserPointsHash() => r'2f87c08a6d38e916ae6466ceddd8519dcdfc7d6d';

/// The latest 20 entries (enough to answer "where did my points go").

final class AdminUserPointsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Result<PointsPage>>, String> {
  AdminUserPointsFamily._()
    : super(
        retry: null,
        name: r'adminUserPointsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The latest 20 entries (enough to answer "where did my points go").

  AdminUserPointsProvider call(String id) =>
      AdminUserPointsProvider._(argument: id, from: this);

  @override
  String toString() => r'adminUserPointsProvider';
}

@ProviderFor(AdjustPointsController)
final adjustPointsControllerProvider = AdjustPointsControllerFamily._();

final class AdjustPointsControllerProvider
    extends $NotifierProvider<AdjustPointsController, RequestState<int>> {
  AdjustPointsControllerProvider._({
    required AdjustPointsControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'adjustPointsControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$adjustPointsControllerHash();

  @override
  String toString() {
    return r'adjustPointsControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  AdjustPointsController create() => AdjustPointsController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RequestState<int> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RequestState<int>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AdjustPointsControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$adjustPointsControllerHash() =>
    r'31b506b737acfacd41742f48bcb800caa6977d6b';

final class AdjustPointsControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          AdjustPointsController,
          RequestState<int>,
          RequestState<int>,
          RequestState<int>,
          String
        > {
  AdjustPointsControllerFamily._()
    : super(
        retry: null,
        name: r'adjustPointsControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AdjustPointsControllerProvider call(String userId) =>
      AdjustPointsControllerProvider._(argument: userId, from: this);

  @override
  String toString() => r'adjustPointsControllerProvider';
}

abstract class _$AdjustPointsController extends $Notifier<RequestState<int>> {
  late final _$args = ref.$arg as String;
  String get userId => _$args;

  RequestState<int> build(String userId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<RequestState<int>, RequestState<int>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RequestState<int>, RequestState<int>>,
              RequestState<int>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
