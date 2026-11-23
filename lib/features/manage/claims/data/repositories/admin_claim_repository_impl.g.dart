// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_claim_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The claims [scope] decides on: every brand's for an admin, one brand's
/// for its team.

@ProviderFor(adminClaimRepository)
final adminClaimRepositoryProvider = AdminClaimRepositoryFamily._();

/// The claims [scope] decides on: every brand's for an admin, one brand's
/// for its team.

final class AdminClaimRepositoryProvider
    extends
        $FunctionalProvider<
          AdminClaimRepository,
          AdminClaimRepository,
          AdminClaimRepository
        >
    with $Provider<AdminClaimRepository> {
  /// The claims [scope] decides on: every brand's for an admin, one brand's
  /// for its team.
  AdminClaimRepositoryProvider._({
    required AdminClaimRepositoryFamily super.from,
    required ManageScope super.argument,
  }) : super(
         retry: null,
         name: r'adminClaimRepositoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$adminClaimRepositoryHash();

  @override
  String toString() {
    return r'adminClaimRepositoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<AdminClaimRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AdminClaimRepository create(Ref ref) {
    final argument = this.argument as ManageScope;
    return adminClaimRepository(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AdminClaimRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AdminClaimRepository>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AdminClaimRepositoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$adminClaimRepositoryHash() =>
    r'9c2f55008c09c8b6927f31de02d85fa47e1d58f5';

/// The claims [scope] decides on: every brand's for an admin, one brand's
/// for its team.

final class AdminClaimRepositoryFamily extends $Family
    with $FunctionalFamilyOverride<AdminClaimRepository, ManageScope> {
  AdminClaimRepositoryFamily._()
    : super(
        retry: null,
        name: r'adminClaimRepositoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The claims [scope] decides on: every brand's for an admin, one brand's
  /// for its team.

  AdminClaimRepositoryProvider call(ManageScope scope) =>
      AdminClaimRepositoryProvider._(argument: scope, from: this);

  @override
  String toString() => r'adminClaimRepositoryProvider';
}
