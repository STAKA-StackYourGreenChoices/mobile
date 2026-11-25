// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_users_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(adminUsersRepository)
final adminUsersRepositoryProvider = AdminUsersRepositoryProvider._();

final class AdminUsersRepositoryProvider
    extends
        $FunctionalProvider<
          AdminUsersRepository,
          AdminUsersRepository,
          AdminUsersRepository
        >
    with $Provider<AdminUsersRepository> {
  AdminUsersRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminUsersRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminUsersRepositoryHash();

  @$internal
  @override
  $ProviderElement<AdminUsersRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AdminUsersRepository create(Ref ref) {
    return adminUsersRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AdminUsersRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AdminUsersRepository>(value),
    );
  }
}

String _$adminUsersRepositoryHash() =>
    r'd1773ef8b1921266cb8f4f855488296093db7408';
