// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispute_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Bumped after every resolution, so the lists and the hub count reload.

@ProviderFor(DisputesRevision)
final disputesRevisionProvider = DisputesRevisionProvider._();

/// Bumped after every resolution, so the lists and the hub count reload.
final class DisputesRevisionProvider
    extends $NotifierProvider<DisputesRevision, int> {
  /// Bumped after every resolution, so the lists and the hub count reload.
  DisputesRevisionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'disputesRevisionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$disputesRevisionHash();

  @$internal
  @override
  DisputesRevision create() => DisputesRevision();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$disputesRevisionHash() => r'628c22782dd6b2b353e56c65e451a956597a8f2d';

/// Bumped after every resolution, so the lists and the hub count reload.

abstract class _$DisputesRevision extends $Notifier<int> {
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

@ProviderFor(disputes)
final disputesProvider = DisputesFamily._();

final class DisputesProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<List<AdminDispute>>>,
          Result<List<AdminDispute>>,
          FutureOr<Result<List<AdminDispute>>>
        >
    with
        $FutureModifier<Result<List<AdminDispute>>>,
        $FutureProvider<Result<List<AdminDispute>>> {
  DisputesProvider._({
    required DisputesFamily super.from,
    required DisputeStatus super.argument,
  }) : super(
         retry: null,
         name: r'disputesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$disputesHash();

  @override
  String toString() {
    return r'disputesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Result<List<AdminDispute>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<List<AdminDispute>>> create(Ref ref) {
    final argument = this.argument as DisputeStatus;
    return disputes(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DisputesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$disputesHash() => r'5a605493ac897d13a909316081fee39a55073960';

final class DisputesFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Result<List<AdminDispute>>>,
          DisputeStatus
        > {
  DisputesFamily._()
    : super(
        retry: null,
        name: r'disputesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DisputesProvider call(DisputeStatus status) =>
      DisputesProvider._(argument: status, from: this);

  @override
  String toString() => r'disputesProvider';
}

/// One dispute by id. The API has no detail endpoint, so it is looked up
/// in the open list, then the resolved ones.

@ProviderFor(adminDispute)
final adminDisputeProvider = AdminDisputeFamily._();

/// One dispute by id. The API has no detail endpoint, so it is looked up
/// in the open list, then the resolved ones.

final class AdminDisputeProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<AdminDispute>>,
          Result<AdminDispute>,
          FutureOr<Result<AdminDispute>>
        >
    with
        $FutureModifier<Result<AdminDispute>>,
        $FutureProvider<Result<AdminDispute>> {
  /// One dispute by id. The API has no detail endpoint, so it is looked up
  /// in the open list, then the resolved ones.
  AdminDisputeProvider._({
    required AdminDisputeFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'adminDisputeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$adminDisputeHash();

  @override
  String toString() {
    return r'adminDisputeProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Result<AdminDispute>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<AdminDispute>> create(Ref ref) {
    final argument = this.argument as String;
    return adminDispute(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AdminDisputeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$adminDisputeHash() => r'ba546979d28d0300767e269d98082b80e4c6f29e';

/// One dispute by id. The API has no detail endpoint, so it is looked up
/// in the open list, then the resolved ones.

final class AdminDisputeFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Result<AdminDispute>>, String> {
  AdminDisputeFamily._()
    : super(
        retry: null,
        name: r'adminDisputeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One dispute by id. The API has no detail endpoint, so it is looked up
  /// in the open list, then the resolved ones.

  AdminDisputeProvider call(String id) =>
      AdminDisputeProvider._(argument: id, from: this);

  @override
  String toString() => r'adminDisputeProvider';
}

/// How many disputes wait for a decision; null if unknown.

@ProviderFor(openDisputeCount)
final openDisputeCountProvider = OpenDisputeCountProvider._();

/// How many disputes wait for a decision; null if unknown.

final class OpenDisputeCountProvider
    extends $FunctionalProvider<AsyncValue<int?>, int?, FutureOr<int?>>
    with $FutureModifier<int?>, $FutureProvider<int?> {
  /// How many disputes wait for a decision; null if unknown.
  OpenDisputeCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'openDisputeCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$openDisputeCountHash();

  @$internal
  @override
  $FutureProviderElement<int?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int?> create(Ref ref) {
    return openDisputeCount(ref);
  }
}

String _$openDisputeCountHash() => r'02eaa5452e324aa51e84d9131f0acd358a2dd8aa';

/// Uphold or overturn one dispute, with a note for the shopper.

@ProviderFor(DisputeResolveController)
final disputeResolveControllerProvider = DisputeResolveControllerFamily._();

/// Uphold or overturn one dispute, with a note for the shopper.
final class DisputeResolveControllerProvider
    extends $NotifierProvider<DisputeResolveController, RequestState<void>> {
  /// Uphold or overturn one dispute, with a note for the shopper.
  DisputeResolveControllerProvider._({
    required DisputeResolveControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'disputeResolveControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$disputeResolveControllerHash();

  @override
  String toString() {
    return r'disputeResolveControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  DisputeResolveController create() => DisputeResolveController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RequestState<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RequestState<void>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is DisputeResolveControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$disputeResolveControllerHash() =>
    r'8decef6edafa0ac3e4ab7be713837f6a8e4963d7';

/// Uphold or overturn one dispute, with a note for the shopper.

final class DisputeResolveControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          DisputeResolveController,
          RequestState<void>,
          RequestState<void>,
          RequestState<void>,
          String
        > {
  DisputeResolveControllerFamily._()
    : super(
        retry: null,
        name: r'disputeResolveControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Uphold or overturn one dispute, with a note for the shopper.

  DisputeResolveControllerProvider call(String disputeId) =>
      DisputeResolveControllerProvider._(argument: disputeId, from: this);

  @override
  String toString() => r'disputeResolveControllerProvider';
}

/// Uphold or overturn one dispute, with a note for the shopper.

abstract class _$DisputeResolveController
    extends $Notifier<RequestState<void>> {
  late final _$args = ref.$arg as String;
  String get disputeId => _$args;

  RequestState<void> build(String disputeId);
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
