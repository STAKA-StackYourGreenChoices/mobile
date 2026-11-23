// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_in_method_controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Account → Phone → "Remove number".

@ProviderFor(RemovePhoneController)
final removePhoneControllerProvider = RemovePhoneControllerProvider._();

/// Account → Phone → "Remove number".
final class RemovePhoneControllerProvider
    extends $NotifierProvider<RemovePhoneController, RequestState<void>> {
  /// Account → Phone → "Remove number".
  RemovePhoneControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'removePhoneControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$removePhoneControllerHash();

  @$internal
  @override
  RemovePhoneController create() => RemovePhoneController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RequestState<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RequestState<void>>(value),
    );
  }
}

String _$removePhoneControllerHash() =>
    r'806eeffb5e63984ae2307520b921b39cef7f594d';

/// Account → Phone → "Remove number".

abstract class _$RemovePhoneController extends $Notifier<RequestState<void>> {
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

/// Account → Email, for an account without one.

@ProviderFor(AddEmailController)
final addEmailControllerProvider = AddEmailControllerProvider._();

/// Account → Email, for an account without one.
final class AddEmailControllerProvider
    extends $NotifierProvider<AddEmailController, RequestState<String>> {
  /// Account → Email, for an account without one.
  AddEmailControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addEmailControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addEmailControllerHash();

  @$internal
  @override
  AddEmailController create() => AddEmailController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RequestState<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RequestState<String>>(value),
    );
  }
}

String _$addEmailControllerHash() =>
    r'25bc68789911d2875a68658ea945fa7ddaefbd7d';

/// Account → Email, for an account without one.

abstract class _$AddEmailController extends $Notifier<RequestState<String>> {
  RequestState<String> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<RequestState<String>, RequestState<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RequestState<String>, RequestState<String>>,
              RequestState<String>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Account → Password, for an account without one.

@ProviderFor(SetPasswordController)
final setPasswordControllerProvider = SetPasswordControllerProvider._();

/// Account → Password, for an account without one.
final class SetPasswordControllerProvider
    extends $NotifierProvider<SetPasswordController, RequestState<void>> {
  /// Account → Password, for an account without one.
  SetPasswordControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'setPasswordControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$setPasswordControllerHash();

  @$internal
  @override
  SetPasswordController create() => SetPasswordController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RequestState<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RequestState<void>>(value),
    );
  }
}

String _$setPasswordControllerHash() =>
    r'5db9f5eeec10b5f60a02dbd6dd9175b768c7ecec';

/// Account → Password, for an account without one.

abstract class _$SetPasswordController extends $Notifier<RequestState<void>> {
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
