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
    extends $NotifierProvider<ForgotPasswordController, RequestState> {
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
  Override overrideWithValue(RequestState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RequestState>(value),
    );
  }
}

String _$forgotPasswordControllerHash() =>
    r'1fdf2af0aef27aac4406175ca0867fc0152cbbe6';

abstract class _$ForgotPasswordController extends $Notifier<RequestState> {
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
