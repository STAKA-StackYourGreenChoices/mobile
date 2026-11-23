// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_save_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Adds a product ([productId] null) or saves changes to one.

@ProviderFor(ProductSaveController)
final productSaveControllerProvider = ProductSaveControllerFamily._();

/// Adds a product ([productId] null) or saves changes to one.
final class ProductSaveControllerProvider
    extends
        $NotifierProvider<
          ProductSaveController,
          RequestState<EditableProduct>
        > {
  /// Adds a product ([productId] null) or saves changes to one.
  ProductSaveControllerProvider._({
    required ProductSaveControllerFamily super.from,
    required (ManageScope, String?) super.argument,
  }) : super(
         retry: null,
         name: r'productSaveControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$productSaveControllerHash();

  @override
  String toString() {
    return r'productSaveControllerProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  ProductSaveController create() => ProductSaveController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RequestState<EditableProduct> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RequestState<EditableProduct>>(
        value,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ProductSaveControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$productSaveControllerHash() =>
    r'4e17a54a6420d23b01dd72e0dab99e1450a5a257';

/// Adds a product ([productId] null) or saves changes to one.

final class ProductSaveControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          ProductSaveController,
          RequestState<EditableProduct>,
          RequestState<EditableProduct>,
          RequestState<EditableProduct>,
          (ManageScope, String?)
        > {
  ProductSaveControllerFamily._()
    : super(
        retry: null,
        name: r'productSaveControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Adds a product ([productId] null) or saves changes to one.

  ProductSaveControllerProvider call(ManageScope scope, String? productId) =>
      ProductSaveControllerProvider._(argument: (scope, productId), from: this);

  @override
  String toString() => r'productSaveControllerProvider';
}

/// Adds a product ([productId] null) or saves changes to one.

abstract class _$ProductSaveController
    extends $Notifier<RequestState<EditableProduct>> {
  late final _$args = ref.$arg as (ManageScope, String?);
  ManageScope get scope => _$args.$1;
  String? get productId => _$args.$2;

  RequestState<EditableProduct> build(ManageScope scope, String? productId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              RequestState<EditableProduct>,
              RequestState<EditableProduct>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                RequestState<EditableProduct>,
                RequestState<EditableProduct>
              >,
              RequestState<EditableProduct>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args.$1, _$args.$2));
  }
}
