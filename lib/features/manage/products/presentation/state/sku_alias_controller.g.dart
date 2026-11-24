// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sku_alias_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Adds or removes another shop's code on one saved size/colour (V2-2).
/// The sheet keeps the list; each call says whether it went through.

@ProviderFor(SkuAliasController)
final skuAliasControllerProvider = SkuAliasControllerFamily._();

/// Adds or removes another shop's code on one saved size/colour (V2-2).
/// The sheet keeps the list; each call says whether it went through.
final class SkuAliasControllerProvider
    extends $NotifierProvider<SkuAliasController, RequestState<void>> {
  /// Adds or removes another shop's code on one saved size/colour (V2-2).
  /// The sheet keeps the list; each call says whether it went through.
  SkuAliasControllerProvider._({
    required SkuAliasControllerFamily super.from,
    required (ManageScope, String, String) super.argument,
  }) : super(
         retry: null,
         name: r'skuAliasControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$skuAliasControllerHash();

  @override
  String toString() {
    return r'skuAliasControllerProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  SkuAliasController create() => SkuAliasController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RequestState<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RequestState<void>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SkuAliasControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$skuAliasControllerHash() =>
    r'ace4fba7a47e46c346ac326f7431c2a879d37e7c';

/// Adds or removes another shop's code on one saved size/colour (V2-2).
/// The sheet keeps the list; each call says whether it went through.

final class SkuAliasControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          SkuAliasController,
          RequestState<void>,
          RequestState<void>,
          RequestState<void>,
          (ManageScope, String, String)
        > {
  SkuAliasControllerFamily._()
    : super(
        retry: null,
        name: r'skuAliasControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Adds or removes another shop's code on one saved size/colour (V2-2).
  /// The sheet keeps the list; each call says whether it went through.

  SkuAliasControllerProvider call(
    ManageScope scope,
    String productId,
    String variantId,
  ) => SkuAliasControllerProvider._(
    argument: (scope, productId, variantId),
    from: this,
  );

  @override
  String toString() => r'skuAliasControllerProvider';
}

/// Adds or removes another shop's code on one saved size/colour (V2-2).
/// The sheet keeps the list; each call says whether it went through.

abstract class _$SkuAliasController extends $Notifier<RequestState<void>> {
  late final _$args = ref.$arg as (ManageScope, String, String);
  ManageScope get scope => _$args.$1;
  String get productId => _$args.$2;
  String get variantId => _$args.$3;

  RequestState<void> build(
    ManageScope scope,
    String productId,
    String variantId,
  );
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
    return element.handleCreate(
      ref,
      () => build(_$args.$1, _$args.$2, _$args.$3),
    );
  }
}
