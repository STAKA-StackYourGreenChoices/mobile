// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_verify_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Checks the code, and creates the account when the number is new.

@ProviderFor(OtpVerifyController)
final otpVerifyControllerProvider = OtpVerifyControllerProvider._();

/// Checks the code, and creates the account when the number is new.
final class OtpVerifyControllerProvider
    extends $NotifierProvider<OtpVerifyController, OtpVerifyState> {
  /// Checks the code, and creates the account when the number is new.
  OtpVerifyControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'otpVerifyControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$otpVerifyControllerHash();

  @$internal
  @override
  OtpVerifyController create() => OtpVerifyController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OtpVerifyState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OtpVerifyState>(value),
    );
  }
}

String _$otpVerifyControllerHash() =>
    r'62bb7ab9d2c75edcc93004aa700c94cb2d7f701b';

/// Checks the code, and creates the account when the number is new.

abstract class _$OtpVerifyController extends $Notifier<OtpVerifyState> {
  OtpVerifyState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<OtpVerifyState, OtpVerifyState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<OtpVerifyState, OtpVerifyState>,
              OtpVerifyState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
