// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rewards_controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The catalog on the Rewards tab. Reloads after a redeem (stock and what
/// the shopper can afford change).

@ProviderFor(rewardsCatalog)
final rewardsCatalogProvider = RewardsCatalogProvider._();

/// The catalog on the Rewards tab. Reloads after a redeem (stock and what
/// the shopper can afford change).

final class RewardsCatalogProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<List<Reward>>>,
          Result<List<Reward>>,
          FutureOr<Result<List<Reward>>>
        >
    with
        $FutureModifier<Result<List<Reward>>>,
        $FutureProvider<Result<List<Reward>>> {
  /// The catalog on the Rewards tab. Reloads after a redeem (stock and what
  /// the shopper can afford change).
  RewardsCatalogProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rewardsCatalogProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rewardsCatalogHash();

  @$internal
  @override
  $FutureProviderElement<Result<List<Reward>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<List<Reward>>> create(Ref ref) {
    return rewardsCatalog(ref);
  }
}

String _$rewardsCatalogHash() => r'dde4cd607dd1c7665bc4fc8238012216337bebfe';

@ProviderFor(rewardDetail)
final rewardDetailProvider = RewardDetailFamily._();

final class RewardDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<Reward>>,
          Result<Reward>,
          FutureOr<Result<Reward>>
        >
    with $FutureModifier<Result<Reward>>, $FutureProvider<Result<Reward>> {
  RewardDetailProvider._({
    required RewardDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'rewardDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$rewardDetailHash();

  @override
  String toString() {
    return r'rewardDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Result<Reward>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<Reward>> create(Ref ref) {
    final argument = this.argument as String;
    return rewardDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RewardDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$rewardDetailHash() => r'bad5c5c860351bb24c644f65c172ea01e5f6d74f';

final class RewardDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Result<Reward>>, String> {
  RewardDetailFamily._()
    : super(
        retry: null,
        name: r'rewardDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RewardDetailProvider call(String id) =>
      RewardDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'rewardDetailProvider';
}

/// Redeeming one reward. Every tap sends a new `Idempotency-Key`, except
/// a retry after an answer that never came (network, server error): that
/// one sends the same key, so the API answers the first redeem instead of
/// taking points twice.

@ProviderFor(RedeemController)
final redeemControllerProvider = RedeemControllerFamily._();

/// Redeeming one reward. Every tap sends a new `Idempotency-Key`, except
/// a retry after an answer that never came (network, server error): that
/// one sends the same key, so the API answers the first redeem instead of
/// taking points twice.
final class RedeemControllerProvider
    extends $NotifierProvider<RedeemController, RedeemState> {
  /// Redeeming one reward. Every tap sends a new `Idempotency-Key`, except
  /// a retry after an answer that never came (network, server error): that
  /// one sends the same key, so the API answers the first redeem instead of
  /// taking points twice.
  RedeemControllerProvider._({
    required RedeemControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'redeemControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$redeemControllerHash();

  @override
  String toString() {
    return r'redeemControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  RedeemController create() => RedeemController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RedeemState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RedeemState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RedeemControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$redeemControllerHash() => r'c22ebd39ba2a85adf73dcd1c87b08adb9f399bbe';

/// Redeeming one reward. Every tap sends a new `Idempotency-Key`, except
/// a retry after an answer that never came (network, server error): that
/// one sends the same key, so the API answers the first redeem instead of
/// taking points twice.

final class RedeemControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          RedeemController,
          RedeemState,
          RedeemState,
          RedeemState,
          String
        > {
  RedeemControllerFamily._()
    : super(
        retry: null,
        name: r'redeemControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Redeeming one reward. Every tap sends a new `Idempotency-Key`, except
  /// a retry after an answer that never came (network, server error): that
  /// one sends the same key, so the API answers the first redeem instead of
  /// taking points twice.

  RedeemControllerProvider call(String rewardId) =>
      RedeemControllerProvider._(argument: rewardId, from: this);

  @override
  String toString() => r'redeemControllerProvider';
}

/// Redeeming one reward. Every tap sends a new `Idempotency-Key`, except
/// a retry after an answer that never came (network, server error): that
/// one sends the same key, so the API answers the first redeem instead of
/// taking points twice.

abstract class _$RedeemController extends $Notifier<RedeemState> {
  late final _$args = ref.$arg as String;
  String get rewardId => _$args;

  RedeemState build(String rewardId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<RedeemState, RedeemState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RedeemState, RedeemState>,
              RedeemState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

/// My vouchers, newest first, 20 at a time. Reloads after a redeem.

@ProviderFor(VouchersController)
final vouchersControllerProvider = VouchersControllerProvider._();

/// My vouchers, newest first, 20 at a time. Reloads after a redeem.
final class VouchersControllerProvider
    extends $NotifierProvider<VouchersController, VouchersState> {
  /// My vouchers, newest first, 20 at a time. Reloads after a redeem.
  VouchersControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vouchersControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vouchersControllerHash();

  @$internal
  @override
  VouchersController create() => VouchersController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VouchersState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VouchersState>(value),
    );
  }
}

String _$vouchersControllerHash() =>
    r'9b9ed870e2d0f4cf5bdd015aea461c5a80b06783';

/// My vouchers, newest first, 20 at a time. Reloads after a redeem.

abstract class _$VouchersController extends $Notifier<VouchersState> {
  VouchersState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<VouchersState, VouchersState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<VouchersState, VouchersState>,
              VouchersState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
