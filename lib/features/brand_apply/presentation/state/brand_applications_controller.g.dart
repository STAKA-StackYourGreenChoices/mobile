// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_applications_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The signed-in person's brand applications (`GET /me/brand-applications`).

@ProviderFor(BrandApplicationsController)
final brandApplicationsControllerProvider =
    BrandApplicationsControllerProvider._();

/// The signed-in person's brand applications (`GET /me/brand-applications`).
final class BrandApplicationsControllerProvider
    extends
        $NotifierProvider<BrandApplicationsController, BrandApplicationsState> {
  /// The signed-in person's brand applications (`GET /me/brand-applications`).
  BrandApplicationsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'brandApplicationsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$brandApplicationsControllerHash();

  @$internal
  @override
  BrandApplicationsController create() => BrandApplicationsController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BrandApplicationsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BrandApplicationsState>(value),
    );
  }
}

String _$brandApplicationsControllerHash() =>
    r'1cb2a93f0e2854733c695f9c90b42c46e15da0f1';

/// The signed-in person's brand applications (`GET /me/brand-applications`).

abstract class _$BrandApplicationsController
    extends $Notifier<BrandApplicationsState> {
  BrandApplicationsState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<BrandApplicationsState, BrandApplicationsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BrandApplicationsState, BrandApplicationsState>,
              BrandApplicationsState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The brands STAKA already lists, for "My brand is already on STAKA".
/// Loading while the future runs; a failed `Result` shows a retry.

@ProviderFor(listedBrands)
final listedBrandsProvider = ListedBrandsProvider._();

/// The brands STAKA already lists, for "My brand is already on STAKA".
/// Loading while the future runs; a failed `Result` shows a retry.

final class ListedBrandsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<List<BrandSummary>>>,
          Result<List<BrandSummary>>,
          FutureOr<Result<List<BrandSummary>>>
        >
    with
        $FutureModifier<Result<List<BrandSummary>>>,
        $FutureProvider<Result<List<BrandSummary>>> {
  /// The brands STAKA already lists, for "My brand is already on STAKA".
  /// Loading while the future runs; a failed `Result` shows a retry.
  ListedBrandsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'listedBrandsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$listedBrandsHash();

  @$internal
  @override
  $FutureProviderElement<Result<List<BrandSummary>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<List<BrandSummary>>> create(Ref ref) {
    return listedBrands(ref);
  }
}

String _$listedBrandsHash() => r'ff0612c084e3cff3f8f4d52848bbe860c76dc563';
