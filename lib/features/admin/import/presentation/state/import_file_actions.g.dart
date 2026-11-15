// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'import_file_actions.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(importFileActions)
final importFileActionsProvider = ImportFileActionsProvider._();

final class ImportFileActionsProvider
    extends
        $FunctionalProvider<
          ImportFileActions,
          ImportFileActions,
          ImportFileActions
        >
    with $Provider<ImportFileActions> {
  ImportFileActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'importFileActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$importFileActionsHash();

  @$internal
  @override
  $ProviderElement<ImportFileActions> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ImportFileActions create(Ref ref) {
    return importFileActions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ImportFileActions value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ImportFileActions>(value),
    );
  }
}

String _$importFileActionsHash() => r'46389bd87ba029786a66edc5ecc007abd0a2540d';
