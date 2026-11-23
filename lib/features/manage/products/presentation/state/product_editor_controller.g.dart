// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_editor_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The brands to choose from and, when editing, the product: what the
/// website's new and `[id]` pages load before showing the form.

@ProviderFor(ProductEditorController)
final productEditorControllerProvider = ProductEditorControllerFamily._();

/// The brands to choose from and, when editing, the product: what the
/// website's new and `[id]` pages load before showing the form.
final class ProductEditorControllerProvider
    extends $NotifierProvider<ProductEditorController, ProductEditorState> {
  /// The brands to choose from and, when editing, the product: what the
  /// website's new and `[id]` pages load before showing the form.
  ProductEditorControllerProvider._({
    required ProductEditorControllerFamily super.from,
    required (ManageScope, String?) super.argument,
  }) : super(
         retry: null,
         name: r'productEditorControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$productEditorControllerHash();

  @override
  String toString() {
    return r'productEditorControllerProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  ProductEditorController create() => ProductEditorController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProductEditorState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProductEditorState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ProductEditorControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$productEditorControllerHash() =>
    r'9bef5614e4fce5b268a6397aa0ef35a07b721e1f';

/// The brands to choose from and, when editing, the product: what the
/// website's new and `[id]` pages load before showing the form.

final class ProductEditorControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          ProductEditorController,
          ProductEditorState,
          ProductEditorState,
          ProductEditorState,
          (ManageScope, String?)
        > {
  ProductEditorControllerFamily._()
    : super(
        retry: null,
        name: r'productEditorControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The brands to choose from and, when editing, the product: what the
  /// website's new and `[id]` pages load before showing the form.

  ProductEditorControllerProvider call(ManageScope scope, String? productId) =>
      ProductEditorControllerProvider._(
        argument: (scope, productId),
        from: this,
      );

  @override
  String toString() => r'productEditorControllerProvider';
}

/// The brands to choose from and, when editing, the product: what the
/// website's new and `[id]` pages load before showing the form.

abstract class _$ProductEditorController extends $Notifier<ProductEditorState> {
  late final _$args = ref.$arg as (ManageScope, String?);
  ManageScope get scope => _$args.$1;
  String? get productId => _$args.$2;

  ProductEditorState build(ManageScope scope, String? productId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ProductEditorState, ProductEditorState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ProductEditorState, ProductEditorState>,
              ProductEditorState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args.$1, _$args.$2));
  }
}
