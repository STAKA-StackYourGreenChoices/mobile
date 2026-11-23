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
final importControllerProvider = ImportControllerFamily._();

/// The website's `ImportFlow`: pick a file, check it (dry run), then
/// import for real or choose another.
final class ImportControllerProvider
    extends $NotifierProvider<ImportController, ImportState> {
  /// The website's `ImportFlow`: pick a file, check it (dry run), then
  /// import for real or choose another.
  ImportControllerProvider._({
    required ImportControllerFamily super.from,
    required ManageScope super.argument,
  }) : super(
         retry: null,
         name: r'importControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$importControllerHash();

  @override
  String toString() {
    return r'importControllerProvider'
        ''
        '($argument)';
  }

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

  @override
  bool operator ==(Object other) {
    return other is ImportControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$importControllerHash() => r'15fa1ad27dc426761eb53b09c3f34c424dc776cd';

/// The website's `ImportFlow`: pick a file, check it (dry run), then
/// import for real or choose another.

final class ImportControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          ImportController,
          ImportState,
          ImportState,
          ImportState,
          ManageScope
        > {
  ImportControllerFamily._()
    : super(
        retry: null,
        name: r'importControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The website's `ImportFlow`: pick a file, check it (dry run), then
  /// import for real or choose another.

  ImportControllerProvider call(ManageScope scope) =>
      ImportControllerProvider._(argument: scope, from: this);

  @override
  String toString() => r'importControllerProvider';
}

/// The website's `ImportFlow`: pick a file, check it (dry run), then
/// import for real or choose another.

abstract class _$ImportController extends $Notifier<ImportState> {
  late final _$args = ref.$arg as ManageScope;
  ManageScope get scope => _$args;

  ImportState build(ManageScope scope);
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
    return element.handleCreate(ref, () => build(_$args));
  }
}
