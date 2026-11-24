// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The product for one code. [isScan]: opened from the Scan tab, so the
/// lookup's answer is reported as a scan (V2-5); the tag's "Product
/// details" link opens the same screen without it.

@ProviderFor(ProductController)
final productControllerProvider = ProductControllerFamily._();

/// The product for one code. [isScan]: opened from the Scan tab, so the
/// lookup's answer is reported as a scan (V2-5); the tag's "Product
/// details" link opens the same screen without it.
final class ProductControllerProvider
    extends $NotifierProvider<ProductController, ProductState> {
  /// The product for one code. [isScan]: opened from the Scan tab, so the
  /// lookup's answer is reported as a scan (V2-5); the tag's "Product
  /// details" link opens the same screen without it.
  ProductControllerProvider._({
    required ProductControllerFamily super.from,
    required (String, {bool isScan}) super.argument,
  }) : super(
         retry: null,
         name: r'productControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$productControllerHash();

  @override
  String toString() {
    return r'productControllerProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  ProductController create() => ProductController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProductState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProductState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ProductControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$productControllerHash() => r'54fe8b494b1438d60613714bac01410d335a169c';

/// The product for one code. [isScan]: opened from the Scan tab, so the
/// lookup's answer is reported as a scan (V2-5); the tag's "Product
/// details" link opens the same screen without it.

final class ProductControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          ProductController,
          ProductState,
          ProductState,
          ProductState,
          (String, {bool isScan})
        > {
  ProductControllerFamily._()
    : super(
        retry: null,
        name: r'productControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The product for one code. [isScan]: opened from the Scan tab, so the
  /// lookup's answer is reported as a scan (V2-5); the tag's "Product
  /// details" link opens the same screen without it.

  ProductControllerProvider call(String gtin, {bool isScan = false}) =>
      ProductControllerProvider._(argument: (gtin, isScan: isScan), from: this);

  @override
  String toString() => r'productControllerProvider';
}

/// The product for one code. [isScan]: opened from the Scan tab, so the
/// lookup's answer is reported as a scan (V2-5); the tag's "Product
/// details" link opens the same screen without it.

abstract class _$ProductController extends $Notifier<ProductState> {
  late final _$args = ref.$arg as (String, {bool isScan});
  String get gtin => _$args.$1;
  bool get isScan => _$args.isScan;

  ProductState build(String gtin, {bool isScan = false});
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ProductState, ProductState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ProductState, ProductState>,
              ProductState,
              Object?,
              Object?
            >;
    return element.handleCreate(
      ref,
      () => build(_$args.$1, isScan: _$args.isScan),
    );
  }
}
