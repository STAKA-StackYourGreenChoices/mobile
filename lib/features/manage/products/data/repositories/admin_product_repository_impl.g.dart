// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_product_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The catalog as [scope] sees it: every brand's for an admin, one brand's
/// for its team.

@ProviderFor(adminProductRepository)
final adminProductRepositoryProvider = AdminProductRepositoryFamily._();

/// The catalog as [scope] sees it: every brand's for an admin, one brand's
/// for its team.

final class AdminProductRepositoryProvider
    extends
        $FunctionalProvider<
          AdminProductRepository,
          AdminProductRepository,
          AdminProductRepository
        >
    with $Provider<AdminProductRepository> {
  /// The catalog as [scope] sees it: every brand's for an admin, one brand's
  /// for its team.
  AdminProductRepositoryProvider._({
    required AdminProductRepositoryFamily super.from,
    required ManageScope super.argument,
  }) : super(
         retry: null,
         name: r'adminProductRepositoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$adminProductRepositoryHash();

  @override
  String toString() {
    return r'adminProductRepositoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<AdminProductRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AdminProductRepository create(Ref ref) {
    final argument = this.argument as ManageScope;
    return adminProductRepository(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AdminProductRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AdminProductRepository>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AdminProductRepositoryProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$adminProductRepositoryHash() =>
    r'ba6c598f9a29780c85ec0e76e57d763f561915f5';

/// The catalog as [scope] sees it: every brand's for an admin, one brand's
/// for its team.

final class AdminProductRepositoryFamily extends $Family
    with $FunctionalFamilyOverride<AdminProductRepository, ManageScope> {
  AdminProductRepositoryFamily._()
    : super(
        retry: null,
        name: r'adminProductRepositoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The catalog as [scope] sees it: every brand's for an admin, one brand's
  /// for its team.

  AdminProductRepositoryProvider call(ManageScope scope) =>
      AdminProductRepositoryProvider._(argument: scope, from: this);

  @override
  String toString() => r'adminProductRepositoryProvider';
}
