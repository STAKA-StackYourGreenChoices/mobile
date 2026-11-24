// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'points_controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The Rewards tab's balance (first page of `/me/points`). Reloads when
/// points may have changed: tags (verified, shared) or a redeem.

@ProviderFor(pointsOverview)
final pointsOverviewProvider = PointsOverviewProvider._();

/// The Rewards tab's balance (first page of `/me/points`). Reloads when
/// points may have changed: tags (verified, shared) or a redeem.

final class PointsOverviewProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<PointsPage>>,
          Result<PointsPage>,
          FutureOr<Result<PointsPage>>
        >
    with
        $FutureModifier<Result<PointsPage>>,
        $FutureProvider<Result<PointsPage>> {
  /// The Rewards tab's balance (first page of `/me/points`). Reloads when
  /// points may have changed: tags (verified, shared) or a redeem.
  PointsOverviewProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pointsOverviewProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pointsOverviewHash();

  @$internal
  @override
  $FutureProviderElement<Result<PointsPage>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<PointsPage>> create(Ref ref) {
    return pointsOverview(ref);
  }
}

String _$pointsOverviewHash() => r'd8bf26ecb159e7a1eaac68653863343184f1607e';

/// "How to earn"; null when the rules couldn't be loaded (section hidden).

@ProviderFor(earnRules)
final earnRulesProvider = EarnRulesProvider._();

/// "How to earn"; null when the rules couldn't be loaded (section hidden).

final class EarnRulesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<EarnRule>?>,
          List<EarnRule>?,
          FutureOr<List<EarnRule>?>
        >
    with $FutureModifier<List<EarnRule>?>, $FutureProvider<List<EarnRule>?> {
  /// "How to earn"; null when the rules couldn't be loaded (section hidden).
  EarnRulesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'earnRulesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$earnRulesHash();

  @$internal
  @override
  $FutureProviderElement<List<EarnRule>?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<EarnRule>?> create(Ref ref) {
    return earnRules(ref);
  }
}

String _$earnRulesHash() => r'd4bb6b0841da18c96553b0d25edad1320971a572';

/// Every points entry, newest first, 20 at a time as the shopper scrolls.

@ProviderFor(PointsHistoryController)
final pointsHistoryControllerProvider = PointsHistoryControllerProvider._();

/// Every points entry, newest first, 20 at a time as the shopper scrolls.
final class PointsHistoryControllerProvider
    extends $NotifierProvider<PointsHistoryController, PointsHistoryState> {
  /// Every points entry, newest first, 20 at a time as the shopper scrolls.
  PointsHistoryControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pointsHistoryControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pointsHistoryControllerHash();

  @$internal
  @override
  PointsHistoryController create() => PointsHistoryController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PointsHistoryState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PointsHistoryState>(value),
    );
  }
}

String _$pointsHistoryControllerHash() =>
    r'9a83d502f4964ef65857397b019576c706dc57b9';

/// Every points entry, newest first, 20 at a time as the shopper scrolls.

abstract class _$PointsHistoryController extends $Notifier<PointsHistoryState> {
  PointsHistoryState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<PointsHistoryState, PointsHistoryState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PointsHistoryState, PointsHistoryState>,
              PointsHistoryState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
