// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'import_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The website's `ImportFlow`: pick a file, check it (dry run), then
/// import for real or choose another.

@ProviderFor(ImportController)
final importControllerProvider = ImportControllerProvider._();

/// The website's `ImportFlow`: pick a file, check it (dry run), then
/// import for real or choose another.
final class ImportControllerProvider
    extends $NotifierProvider<ImportController, ImportState> {
  /// The website's `ImportFlow`: pick a file, check it (dry run), then
  /// import for real or choose another.
  ImportControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'importControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$importControllerHash();

  @$internal
  @override
  ImportController create() => ImportController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ImportState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ImportState>(value),
    );
  }
}

String _$importControllerHash() => r'136b09e4e2afeb85670d8cf39556a5c35d17c90b';

/// The website's `ImportFlow`: pick a file, check it (dry run), then
/// import for real or choose another.

abstract class _$ImportController extends $Notifier<ImportState> {
  ImportState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ImportState, ImportState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ImportState, ImportState>,
              ImportState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
