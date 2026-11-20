// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_email_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// "Send a new link" on the confirm-your-email banner.

@ProviderFor(VerifyEmailController)
final verifyEmailControllerProvider = VerifyEmailControllerProvider._();

/// "Send a new link" on the confirm-your-email banner.
final class VerifyEmailControllerProvider
    extends
        $NotifierProvider<VerifyEmailController, RequestState<ResendOutcome>> {
  /// "Send a new link" on the confirm-your-email banner.
  VerifyEmailControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'verifyEmailControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$verifyEmailControllerHash();

  @$internal
  @override
  VerifyEmailController create() => VerifyEmailController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RequestState<ResendOutcome> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RequestState<ResendOutcome>>(value),
    );
  }
}

String _$verifyEmailControllerHash() =>
    r'a1d0319843c5495eff172bb398df02dc0dbfbe38';

/// "Send a new link" on the confirm-your-email banner.

abstract class _$VerifyEmailController
    extends $Notifier<RequestState<ResendOutcome>> {
  RequestState<ResendOutcome> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<RequestState<ResendOutcome>, RequestState<ResendOutcome>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                RequestState<ResendOutcome>,
                RequestState<ResendOutcome>
              >,
              RequestState<ResendOutcome>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
