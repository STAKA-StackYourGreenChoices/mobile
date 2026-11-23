// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_brand.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The brand chosen in the Brand tab's switcher; null until one is chosen.
/// Kept while the app runs, so the tab reopens on the same brand.

@ProviderFor(SelectedBrandId)
final selectedBrandIdProvider = SelectedBrandIdProvider._();

/// The brand chosen in the Brand tab's switcher; null until one is chosen.
/// Kept while the app runs, so the tab reopens on the same brand.
final class SelectedBrandIdProvider
    extends $NotifierProvider<SelectedBrandId, String?> {
  /// The brand chosen in the Brand tab's switcher; null until one is chosen.
  /// Kept while the app runs, so the tab reopens on the same brand.
  SelectedBrandIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedBrandIdProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedBrandIdHash();

  @$internal
  @override
  SelectedBrandId create() => SelectedBrandId();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$selectedBrandIdHash() => r'7fe59c7cc6045eea9358d64cc8057c63e0d25d73';

/// The brand chosen in the Brand tab's switcher; null until one is chosen.
/// Kept while the app runs, so the tab reopens on the same brand.

abstract class _$SelectedBrandId extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The brands in the Brand tab (approved or paused), from the session.

@ProviderFor(portalBrands)
final portalBrandsProvider = PortalBrandsProvider._();

/// The brands in the Brand tab (approved or paused), from the session.

final class PortalBrandsProvider
    extends
        $FunctionalProvider<
          List<BrandMembership>,
          List<BrandMembership>,
          List<BrandMembership>
        >
    with $Provider<List<BrandMembership>> {
  /// The brands in the Brand tab (approved or paused), from the session.
  PortalBrandsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'portalBrandsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$portalBrandsHash();

  @$internal
  @override
  $ProviderElement<List<BrandMembership>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<BrandMembership> create(Ref ref) {
    return portalBrands(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<BrandMembership> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<BrandMembership>>(value),
    );
  }
}

String _$portalBrandsHash() => r'9d3990d1d7913604b929b2ea4d2088f5b8f23709';

/// The brand the Brand tab shows: the chosen one while the person still
/// belongs to it, otherwise the first. Null without any (the router keeps
/// such people out of the tab).

@ProviderFor(currentBrand)
final currentBrandProvider = CurrentBrandProvider._();

/// The brand the Brand tab shows: the chosen one while the person still
/// belongs to it, otherwise the first. Null without any (the router keeps
/// such people out of the tab).

final class CurrentBrandProvider
    extends
        $FunctionalProvider<
          BrandMembership?,
          BrandMembership?,
          BrandMembership?
        >
    with $Provider<BrandMembership?> {
  /// The brand the Brand tab shows: the chosen one while the person still
  /// belongs to it, otherwise the first. Null without any (the router keeps
  /// such people out of the tab).
  CurrentBrandProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentBrandProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentBrandHash();

  @$internal
  @override
  $ProviderElement<BrandMembership?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BrandMembership? create(Ref ref) {
    return currentBrand(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BrandMembership? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BrandMembership?>(value),
    );
  }
}

String _$currentBrandHash() => r'ab8647430d79caf9ca49d556538f6e0c698b3586';

/// The current brand's scope for the shared management screens.

@ProviderFor(currentBrandScope)
final currentBrandScopeProvider = CurrentBrandScopeProvider._();

/// The current brand's scope for the shared management screens.

final class CurrentBrandScopeProvider
    extends $FunctionalProvider<BrandScope?, BrandScope?, BrandScope?>
    with $Provider<BrandScope?> {
  /// The current brand's scope for the shared management screens.
  CurrentBrandScopeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentBrandScopeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentBrandScopeHash();

  @$internal
  @override
  $ProviderElement<BrandScope?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BrandScope? create(Ref ref) {
    return currentBrandScope(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BrandScope? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BrandScope?>(value),
    );
  }
}

String _$currentBrandScopeHash() => r'4bd05a07105569cb870eb2beae3cd3a66753a959';
