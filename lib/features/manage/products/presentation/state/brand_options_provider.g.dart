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
final brandOptionsProvider = BrandOptionsFamily._();

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
  BrandOptionsProvider._({
    required BrandOptionsFamily super.from,
    required ManageScope super.argument,
  }) : super(
         retry: null,
         name: r'brandOptionsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$brandOptionsHash();

  @override
  String toString() {
    return r'brandOptionsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Result<List<BrandSummary>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<List<BrandSummary>>> create(Ref ref) {
    final argument = this.argument as ManageScope;
    return brandOptions(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is BrandOptionsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$brandOptionsHash() => r'80dde7dd37a7eae245fcff174ad060c579a2fff9';

/// The brands to filter products by (and, later, to pick in the product
/// form). Loading while the future runs; a failed `Result` hides the filter.

final class BrandOptionsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Result<List<BrandSummary>>>,
          ManageScope
        > {
  BrandOptionsFamily._()
    : super(
        retry: null,
        name: r'brandOptionsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The brands to filter products by (and, later, to pick in the product
  /// form). Loading while the future runs; a failed `Result` hides the filter.

  BrandOptionsProvider call(ManageScope scope) =>
      BrandOptionsProvider._(argument: scope, from: this);

  @override
  String toString() => r'brandOptionsProvider';
}
