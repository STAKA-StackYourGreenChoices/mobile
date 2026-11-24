// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_visibility_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// An admin hides one product from shoppers, or shows it again (V2-12).
/// The admin list reloads afterwards.

@ProviderFor(ProductVisibilityController)
final productVisibilityControllerProvider =
    ProductVisibilityControllerFamily._();

/// An admin hides one product from shoppers, or shows it again (V2-12).
/// The admin list reloads afterwards.
final class ProductVisibilityControllerProvider
    extends $NotifierProvider<ProductVisibilityController, RequestState<void>> {
  /// An admin hides one product from shoppers, or shows it again (V2-12).
  /// The admin list reloads afterwards.
  ProductVisibilityControllerProvider._({
    required ProductVisibilityControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'productVisibilityControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$productVisibilityControllerHash();

  @override
  String toString() {
    return r'productVisibilityControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ProductVisibilityController create() => ProductVisibilityController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RequestState<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RequestState<void>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ProductVisibilityControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$productVisibilityControllerHash() =>
    r'9a0bda5771b969934d0874a0f5438491c7524341';

/// An admin hides one product from shoppers, or shows it again (V2-12).
/// The admin list reloads afterwards.

final class ProductVisibilityControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          ProductVisibilityController,
          RequestState<void>,
          RequestState<void>,
          RequestState<void>,
          String
        > {
  ProductVisibilityControllerFamily._()
    : super(
        retry: null,
        name: r'productVisibilityControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// An admin hides one product from shoppers, or shows it again (V2-12).
  /// The admin list reloads afterwards.

  ProductVisibilityControllerProvider call(String productId) =>
      ProductVisibilityControllerProvider._(argument: productId, from: this);

  @override
  String toString() => r'productVisibilityControllerProvider';
}

/// An admin hides one product from shoppers, or shows it again (V2-12).
/// The admin list reloads afterwards.

abstract class _$ProductVisibilityController
    extends $Notifier<RequestState<void>> {
  late final _$args = ref.$arg as String;
  String get productId => _$args;

  RequestState<void> build(String productId);
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
