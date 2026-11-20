// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_products_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The admin product list: search, brand filter, and pages loaded as the
/// admin scrolls (guide §11: 20 at a time).

@ProviderFor(AdminProductsController)
final adminProductsControllerProvider = AdminProductsControllerFamily._();

/// The admin product list: search, brand filter, and pages loaded as the
/// admin scrolls (guide §11: 20 at a time).
final class AdminProductsControllerProvider
    extends $NotifierProvider<AdminProductsController, AdminProductsState> {
  /// The admin product list: search, brand filter, and pages loaded as the
  /// admin scrolls (guide §11: 20 at a time).
  AdminProductsControllerProvider._({
    required AdminProductsControllerFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'adminProductsControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$adminProductsControllerHash();

  @override
  String toString() {
    return r'adminProductsControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  AdminProductsController create() => AdminProductsController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AdminProductsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AdminProductsState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AdminProductsControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$adminProductsControllerHash() =>
    r'06467ee4de03bd284a7754406a1f6df91c02f97a';

/// The admin product list: search, brand filter, and pages loaded as the
/// admin scrolls (guide §11: 20 at a time).

final class AdminProductsControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          AdminProductsController,
          AdminProductsState,
          AdminProductsState,
          AdminProductsState,
          String?
        > {
  AdminProductsControllerFamily._()
    : super(
        retry: null,
        name: r'adminProductsControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The admin product list: search, brand filter, and pages loaded as the
  /// admin scrolls (guide §11: 20 at a time).

  AdminProductsControllerProvider call({String? brandId}) =>
      AdminProductsControllerProvider._(argument: brandId, from: this);

  @override
  String toString() => r'adminProductsControllerProvider';
}

/// The admin product list: search, brand filter, and pages loaded as the
/// admin scrolls (guide §11: 20 at a time).

abstract class _$AdminProductsController extends $Notifier<AdminProductsState> {
  late final _$args = ref.$arg as String?;
  String? get brandId => _$args;

  AdminProductsState build({String? brandId});
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AdminProductsState, AdminProductsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AdminProductsState, AdminProductsState>,
              AdminProductsState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(brandId: _$args));
  }
}
