// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_options_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The brands to filter products by (and, later, to pick in the product
/// form). Loading while the future runs; a failed `Result` hides the filter.

@ProviderFor(brandOptions)
final brandOptionsProvider = BrandOptionsProvider._();

/// The brands to filter products by (and, later, to pick in the product
/// form). Loading while the future runs; a failed `Result` hides the filter.

final class BrandOptionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<List<BrandSummary>>>,
          Result<List<BrandSummary>>,
          FutureOr<Result<List<BrandSummary>>>
        >
    with
        $FutureModifier<Result<List<BrandSummary>>>,
        $FutureProvider<Result<List<BrandSummary>>> {
  /// The brands to filter products by (and, later, to pick in the product
  /// form). Loading while the future runs; a failed `Result` hides the filter.
  BrandOptionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'brandOptionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$brandOptionsHash();

  @$internal
  @override
  $FutureProviderElement<Result<List<BrandSummary>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<List<BrandSummary>>> create(Ref ref) {
    return brandOptions(ref);
  }
}

String _$brandOptionsHash() => r'd3926365f0dfe4937de33f586dc082ad42dc2df9';
