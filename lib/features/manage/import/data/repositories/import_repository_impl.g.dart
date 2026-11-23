// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'import_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// CSV import into [scope]'s catalog.

@ProviderFor(importRepository)
final importRepositoryProvider = ImportRepositoryFamily._();

/// CSV import into [scope]'s catalog.

final class ImportRepositoryProvider
    extends
        $FunctionalProvider<
          ImportRepository,
          ImportRepository,
          ImportRepository
        >
    with $Provider<ImportRepository> {
  /// CSV import into [scope]'s catalog.
  ImportRepositoryProvider._({
    required ImportRepositoryFamily super.from,
    required ManageScope super.argument,
  }) : super(
         retry: null,
         name: r'importRepositoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$importRepositoryHash();

  @override
  String toString() {
    return r'importRepositoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<ImportRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ImportRepository create(Ref ref) {
    final argument = this.argument as ManageScope;
    return importRepository(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ImportRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ImportRepository>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ImportRepositoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$importRepositoryHash() => r'2c359965dd4655d6cff63db508b02bb6e0ee4bcb';

/// CSV import into [scope]'s catalog.

final class ImportRepositoryFamily extends $Family
    with $FunctionalFamilyOverride<ImportRepository, ManageScope> {
  ImportRepositoryFamily._()
    : super(
        retry: null,
        name: r'importRepositoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// CSV import into [scope]'s catalog.

  ImportRepositoryProvider call(ManageScope scope) =>
      ImportRepositoryProvider._(argument: scope, from: this);

  @override
  String toString() => r'importRepositoryProvider';
}
