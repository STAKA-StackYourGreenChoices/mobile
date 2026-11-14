// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forgot_password_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ForgotPasswordController)
final forgotPasswordControllerProvider = ForgotPasswordControllerProvider._();

final class ForgotPasswordControllerProvider
    extends $NotifierProvider<ForgotPasswordController, RequestState<String>> {
  ForgotPasswordControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'forgotPasswordControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$forgotPasswordControllerHash();

  @$internal
  @override
  ForgotPasswordController create() => ForgotPasswordController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RequestState<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RequestState<String>>(value),
    );
  }
}

String _$forgotPasswordControllerHash() =>
    r'09357c4cc119c3c37acba68c5a7032f35352f54d';

abstract class _$ForgotPasswordController
    extends $Notifier<RequestState<String>> {
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
