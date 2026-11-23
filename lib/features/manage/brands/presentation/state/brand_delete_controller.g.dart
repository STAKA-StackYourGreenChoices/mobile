// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_delete_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Deletes one brand. The API refuses while it still has products.

@ProviderFor(BrandDeleteController)
final brandDeleteControllerProvider = BrandDeleteControllerFamily._();

/// Deletes one brand. The API refuses while it still has products.
final class BrandDeleteControllerProvider
    extends $NotifierProvider<BrandDeleteController, RequestState<void>> {
  /// Deletes one brand. The API refuses while it still has products.
  BrandDeleteControllerProvider._({
    required BrandDeleteControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'brandDeleteControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$brandDeleteControllerHash();

  @override
  String toString() {
    return r'brandDeleteControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  BrandDeleteController create() => BrandDeleteController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RequestState<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RequestState<void>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is BrandDeleteControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$brandDeleteControllerHash() =>
    r'e151e58365454f036c9758458628aad917e694b7';

/// Deletes one brand. The API refuses while it still has products.

final class BrandDeleteControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          BrandDeleteController,
          RequestState<void>,
          RequestState<void>,
          RequestState<void>,
          String
        > {
  BrandDeleteControllerFamily._()
    : super(
        retry: null,
        name: r'brandDeleteControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Deletes one brand. The API refuses while it still has products.

  BrandDeleteControllerProvider call(String brandId) =>
      BrandDeleteControllerProvider._(argument: brandId, from: this);

  @override
  String toString() => r'brandDeleteControllerProvider';
}

/// Deletes one brand. The API refuses while it still has products.

abstract class _$BrandDeleteController extends $Notifier<RequestState<void>> {
  late final _$args = ref.$arg as String;
  String get brandId => _$args;

  RequestState<void> build(String brandId);
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
