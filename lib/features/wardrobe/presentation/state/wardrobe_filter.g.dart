// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wardrobe_filter.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The kind of piece the wardrobe shows; null shows everything (V2-2).

@ProviderFor(WardrobeCategoryFilter)
final wardrobeCategoryFilterProvider = WardrobeCategoryFilterProvider._();

/// The kind of piece the wardrobe shows; null shows everything (V2-2).
final class WardrobeCategoryFilterProvider
    extends $NotifierProvider<WardrobeCategoryFilter, ProductCategory?> {
  /// The kind of piece the wardrobe shows; null shows everything (V2-2).
  WardrobeCategoryFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'wardrobeCategoryFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$wardrobeCategoryFilterHash();

  @$internal
  @override
  WardrobeCategoryFilter create() => WardrobeCategoryFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProductCategory? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProductCategory?>(value),
    );
  }
}

String _$wardrobeCategoryFilterHash() =>
    r'b076ea8ad34ae79093f7f796088d72b48ec81c98';

/// The kind of piece the wardrobe shows; null shows everything (V2-2).

abstract class _$WardrobeCategoryFilter extends $Notifier<ProductCategory?> {
  ProductCategory? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ProductCategory?, ProductCategory?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ProductCategory?, ProductCategory?>,
              ProductCategory?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
