// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_request_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Sends (and resends) the sign-in code. Lives while the phone sign-in
/// screens are on the stack.

@ProviderFor(OtpRequestController)
final otpRequestControllerProvider = OtpRequestControllerProvider._();

/// Sends (and resends) the sign-in code. Lives while the phone sign-in
/// screens are on the stack.
final class OtpRequestControllerProvider
    extends $NotifierProvider<OtpRequestController, OtpRequestState> {
  /// Sends (and resends) the sign-in code. Lives while the phone sign-in
  /// screens are on the stack.
  OtpRequestControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'otpRequestControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$otpRequestControllerHash();

  @$internal
  @override
  OtpRequestController create() => OtpRequestController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OtpRequestState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OtpRequestState>(value),
    );
  }
}

String _$otpRequestControllerHash() =>
    r'6aee1e9dcb4ab10e8e5e61a154e2d5a2845a7c02';

/// Sends (and resends) the sign-in code. Lives while the phone sign-in
/// screens are on the stack.

abstract class _$OtpRequestController extends $Notifier<OtpRequestState> {
  OtpRequestState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<OtpRequestState, OtpRequestState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<OtpRequestState, OtpRequestState>,
              OtpRequestState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
