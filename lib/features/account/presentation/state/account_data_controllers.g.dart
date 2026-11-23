// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_data_controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Account → Download my data: the API's JSON file, handed to the share
/// sheet (Save to Files, Drive, email).

@ProviderFor(ExportDataController)
final exportDataControllerProvider = ExportDataControllerProvider._();

/// Account → Download my data: the API's JSON file, handed to the share
/// sheet (Save to Files, Drive, email).
final class ExportDataControllerProvider
    extends $NotifierProvider<ExportDataController, RequestState<void>> {
  /// Account → Download my data: the API's JSON file, handed to the share
  /// sheet (Save to Files, Drive, email).
  ExportDataControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exportDataControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exportDataControllerHash();

  @$internal
  @override
  ExportDataController create() => ExportDataController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RequestState<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RequestState<void>>(value),
    );
  }
}

String _$exportDataControllerHash() =>
    r'3408237b8ba5a7fd0d405f2ef4c43319745c798f';

/// Account → Download my data: the API's JSON file, handed to the share
/// sheet (Save to Files, Drive, email).

abstract class _$ExportDataController extends $Notifier<RequestState<void>> {
  RequestState<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<RequestState<void>, RequestState<void>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RequestState<void>, RequestState<void>>,
              RequestState<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Account → Delete my account. The screen signs out once it is done.

@ProviderFor(DeleteAccountController)
final deleteAccountControllerProvider = DeleteAccountControllerProvider._();

/// Account → Delete my account. The screen signs out once it is done.
final class DeleteAccountControllerProvider
    extends $NotifierProvider<DeleteAccountController, DeleteAccountState> {
  /// Account → Delete my account. The screen signs out once it is done.
  DeleteAccountControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deleteAccountControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deleteAccountControllerHash();

  @$internal
  @override
  DeleteAccountController create() => DeleteAccountController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeleteAccountState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeleteAccountState>(value),
    );
  }
}

String _$deleteAccountControllerHash() =>
    r'cc3a341bc72aaf6e929d83e1788f76d83a5dfa19';

/// Account → Delete my account. The screen signs out once it is done.

abstract class _$DeleteAccountController extends $Notifier<DeleteAccountState> {
  DeleteAccountState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<DeleteAccountState, DeleteAccountState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DeleteAccountState, DeleteAccountState>,
              DeleteAccountState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
