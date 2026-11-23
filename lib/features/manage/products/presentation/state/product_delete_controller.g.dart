// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_delete_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Deletes one product. The API refuses while shoppers hold its tags.

@ProviderFor(ProductDeleteController)
final productDeleteControllerProvider = ProductDeleteControllerFamily._();

/// Deletes one product. The API refuses while shoppers hold its tags.
final class ProductDeleteControllerProvider
    extends $NotifierProvider<ProductDeleteController, RequestState<void>> {
  /// Deletes one product. The API refuses while shoppers hold its tags.
  ProductDeleteControllerProvider._({
    required ProductDeleteControllerFamily super.from,
    required (ManageScope, String) super.argument,
  }) : super(
         retry: null,
         name: r'productDeleteControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$productDeleteControllerHash();

  @override
  String toString() {
    return r'productDeleteControllerProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  ProductDeleteController create() => ProductDeleteController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RequestState<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RequestState<void>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ProductDeleteControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$productDeleteControllerHash() =>
    r'31236132be9f75a16fcd5df69283b2cf83577cc6';

/// Deletes one product. The API refuses while shoppers hold its tags.

final class ProductDeleteControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          ProductDeleteController,
          RequestState<void>,
          RequestState<void>,
          RequestState<void>,
          (ManageScope, String)
        > {
  ProductDeleteControllerFamily._()
    : super(
        retry: null,
        name: r'productDeleteControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Deletes one product. The API refuses while shoppers hold its tags.

  ProductDeleteControllerProvider call(ManageScope scope, String productId) =>
      ProductDeleteControllerProvider._(
        argument: (scope, productId),
        from: this,
      );

  @override
  String toString() => r'productDeleteControllerProvider';
}

/// Deletes one product. The API refuses while shoppers hold its tags.

abstract class _$ProductDeleteController extends $Notifier<RequestState<void>> {
  late final _$args = ref.$arg as (ManageScope, String);
  ManageScope get scope => _$args.$1;
  String get productId => _$args.$2;

  RequestState<void> build(ManageScope scope, String productId);
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
    return element.handleCreate(ref, () => build(_$args.$1, _$args.$2));
  }
}
