// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_save_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Adds a brand ([brandId] null) or saves changes to one.

@ProviderFor(BrandSaveController)
final brandSaveControllerProvider = BrandSaveControllerFamily._();

/// Adds a brand ([brandId] null) or saves changes to one.
final class BrandSaveControllerProvider
    extends $NotifierProvider<BrandSaveController, RequestState<BrandSummary>> {
  /// Adds a brand ([brandId] null) or saves changes to one.
  BrandSaveControllerProvider._({
    required BrandSaveControllerFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'brandSaveControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$brandSaveControllerHash();

  @override
  String toString() {
    return r'brandSaveControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  BrandSaveController create() => BrandSaveController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RequestState<BrandSummary> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RequestState<BrandSummary>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is BrandSaveControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$brandSaveControllerHash() =>
    r'cd4654c4db586ba15c338ec3d2b51bc80cba376e';

/// Adds a brand ([brandId] null) or saves changes to one.

final class BrandSaveControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          BrandSaveController,
          RequestState<BrandSummary>,
          RequestState<BrandSummary>,
          RequestState<BrandSummary>,
          String?
        > {
  BrandSaveControllerFamily._()
    : super(
        retry: null,
        name: r'brandSaveControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Adds a brand ([brandId] null) or saves changes to one.

  BrandSaveControllerProvider call(String? brandId) =>
      BrandSaveControllerProvider._(argument: brandId, from: this);

  @override
  String toString() => r'brandSaveControllerProvider';
}

/// Adds a brand ([brandId] null) or saves changes to one.

abstract class _$BrandSaveController
    extends $Notifier<RequestState<BrandSummary>> {
  late final _$args = ref.$arg as String?;
  String? get brandId => _$args;

  RequestState<BrandSummary> build(String? brandId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<RequestState<BrandSummary>, RequestState<BrandSummary>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                RequestState<BrandSummary>,
                RequestState<BrandSummary>
              >,
              RequestState<BrandSummary>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
