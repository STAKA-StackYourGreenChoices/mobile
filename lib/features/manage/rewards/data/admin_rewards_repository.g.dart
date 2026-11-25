// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_rewards_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(adminRewardsRepository)
final adminRewardsRepositoryProvider = AdminRewardsRepositoryProvider._();

final class AdminRewardsRepositoryProvider
    extends
        $FunctionalProvider<
          AdminRewardsRepository,
          AdminRewardsRepository,
          AdminRewardsRepository
        >
    with $Provider<AdminRewardsRepository> {
  AdminRewardsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminRewardsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminRewardsRepositoryHash();

  @$internal
  @override
  $ProviderElement<AdminRewardsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AdminRewardsRepository create(Ref ref) {
    return adminRewardsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AdminRewardsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AdminRewardsRepository>(value),
    );
  }
}

String _$adminRewardsRepositoryHash() =>
    r'd387902017d2bd49ed427fcbdf8ac98aa75ba5e7';
