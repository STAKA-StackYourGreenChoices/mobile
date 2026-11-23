// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_team_controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// [brandId]'s team, owners first. Loading while the future runs.

@ProviderFor(brandMembers)
final brandMembersProvider = BrandMembersFamily._();

/// [brandId]'s team, owners first. Loading while the future runs.

final class BrandMembersProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<List<BrandMember>>>,
          Result<List<BrandMember>>,
          FutureOr<Result<List<BrandMember>>>
        >
    with
        $FutureModifier<Result<List<BrandMember>>>,
        $FutureProvider<Result<List<BrandMember>>> {
  /// [brandId]'s team, owners first. Loading while the future runs.
  BrandMembersProvider._({
    required BrandMembersFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'brandMembersProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$brandMembersHash();

  @override
  String toString() {
    return r'brandMembersProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Result<List<BrandMember>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<List<BrandMember>>> create(Ref ref) {
    final argument = this.argument as String;
    return brandMembers(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is BrandMembersProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$brandMembersHash() => r'39cf8accf5d61c816ca3825266e8bf9bd4bc4d46';

/// [brandId]'s team, owners first. Loading while the future runs.

final class BrandMembersFamily extends $Family
    with
        $FunctionalFamilyOverride<FutureOr<Result<List<BrandMember>>>, String> {
  BrandMembersFamily._()
    : super(
        retry: null,
        name: r'brandMembersProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// [brandId]'s team, owners first. Loading while the future runs.

  BrandMembersProvider call(String brandId) =>
      BrandMembersProvider._(argument: brandId, from: this);

  @override
  String toString() => r'brandMembersProvider';
}

/// Owners invite someone by email or number (`POST …/members`).

@ProviderFor(BrandInviteController)
final brandInviteControllerProvider = BrandInviteControllerFamily._();

/// Owners invite someone by email or number (`POST …/members`).
final class BrandInviteControllerProvider
    extends $NotifierProvider<BrandInviteController, RequestState<void>> {
  /// Owners invite someone by email or number (`POST …/members`).
  BrandInviteControllerProvider._({
    required BrandInviteControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'brandInviteControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$brandInviteControllerHash();

  @override
  String toString() {
    return r'brandInviteControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  BrandInviteController create() => BrandInviteController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RequestState<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RequestState<void>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is BrandInviteControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$brandInviteControllerHash() =>
    r'3adac84b19c16c33a446b30b05642af785091209';

/// Owners invite someone by email or number (`POST …/members`).

final class BrandInviteControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          BrandInviteController,
          RequestState<void>,
          RequestState<void>,
          RequestState<void>,
          String
        > {
  BrandInviteControllerFamily._()
    : super(
        retry: null,
        name: r'brandInviteControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Owners invite someone by email or number (`POST …/members`).

  BrandInviteControllerProvider call(String brandId) =>
      BrandInviteControllerProvider._(argument: brandId, from: this);

  @override
  String toString() => r'brandInviteControllerProvider';
}

/// Owners invite someone by email or number (`POST …/members`).

abstract class _$BrandInviteController extends $Notifier<RequestState<void>> {
  late final _$args = ref.$arg as String;
  String get brandId => _$args;

  RequestState<void> build(String brandId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<RequestState<void>, RequestState<void>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RequestState<void>, RequestState<void>>,
              RequestState<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

/// Owners take someone off the team; the list reloads afterwards.

@ProviderFor(BrandMemberRemoveController)
final brandMemberRemoveControllerProvider =
    BrandMemberRemoveControllerFamily._();

/// Owners take someone off the team; the list reloads afterwards.
final class BrandMemberRemoveControllerProvider
    extends $NotifierProvider<BrandMemberRemoveController, RequestState<void>> {
  /// Owners take someone off the team; the list reloads afterwards.
  BrandMemberRemoveControllerProvider._({
    required BrandMemberRemoveControllerFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'brandMemberRemoveControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$brandMemberRemoveControllerHash();

  @override
  String toString() {
    return r'brandMemberRemoveControllerProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  BrandMemberRemoveController create() => BrandMemberRemoveController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RequestState<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RequestState<void>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is BrandMemberRemoveControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$brandMemberRemoveControllerHash() =>
    r'0446d6c100cf34319d4d3c0f5207dfbc93062d29';

/// Owners take someone off the team; the list reloads afterwards.

final class BrandMemberRemoveControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          BrandMemberRemoveController,
          RequestState<void>,
          RequestState<void>,
          RequestState<void>,
          (String, String)
        > {
  BrandMemberRemoveControllerFamily._()
    : super(
        retry: null,
        name: r'brandMemberRemoveControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Owners take someone off the team; the list reloads afterwards.

  BrandMemberRemoveControllerProvider call(String brandId, String userId) =>
      BrandMemberRemoveControllerProvider._(
        argument: (brandId, userId),
        from: this,
      );

  @override
  String toString() => r'brandMemberRemoveControllerProvider';
}

/// Owners take someone off the team; the list reloads afterwards.

abstract class _$BrandMemberRemoveController
    extends $Notifier<RequestState<void>> {
  late final _$args = ref.$arg as (String, String);
  String get brandId => _$args.$1;
  String get userId => _$args.$2;

  RequestState<void> build(String brandId, String userId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<RequestState<void>, RequestState<void>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RequestState<void>, RequestState<void>>,
              RequestState<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args.$1, _$args.$2));
  }
}
