// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_claim_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(adminClaimRepository)
final adminClaimRepositoryProvider = AdminClaimRepositoryProvider._();

final class AdminClaimRepositoryProvider
    extends
        $FunctionalProvider<
          AdminClaimRepository,
          AdminClaimRepository,
          AdminClaimRepository
        >
    with $Provider<AdminClaimRepository> {
  AdminClaimRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminClaimRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminClaimRepositoryHash();

  @$internal
  @override
  $ProviderElement<AdminClaimRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AdminClaimRepository create(Ref ref) {
    return adminClaimRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AdminClaimRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AdminClaimRepository>(value),
    );
  }
}

String _$adminClaimRepositoryHash() =>
    r'ab8fb74164650c26c0207fac1d01dcdeb458422b';
