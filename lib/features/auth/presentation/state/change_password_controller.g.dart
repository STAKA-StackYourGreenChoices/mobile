// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_password_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ChangePasswordController)
final changePasswordControllerProvider = ChangePasswordControllerProvider._();

final class ChangePasswordControllerProvider
    extends $NotifierProvider<ChangePasswordController, RequestState> {
  ChangePasswordControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'changePasswordControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$changePasswordControllerHash();

  @$internal
  @override
  ChangePasswordController create() => ChangePasswordController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RequestState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RequestState>(value),
    );
  }
}

String _$changePasswordControllerHash() =>
    r'b2ead4c417e938ee36b8094e8fc050e91bd03d28';

abstract class _$ChangePasswordController extends $Notifier<RequestState> {
  RequestState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<RequestState, RequestState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RequestState, RequestState>,
              RequestState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
