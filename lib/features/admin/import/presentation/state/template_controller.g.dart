// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// "Download the template": fetch it with the admin's token, then hand it
/// to the share sheet.

@ProviderFor(TemplateController)
final templateControllerProvider = TemplateControllerProvider._();

/// "Download the template": fetch it with the admin's token, then hand it
/// to the share sheet.
final class TemplateControllerProvider
    extends $NotifierProvider<TemplateController, RequestState<void>> {
  /// "Download the template": fetch it with the admin's token, then hand it
  /// to the share sheet.
  TemplateControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'templateControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$templateControllerHash();

  @$internal
  @override
  TemplateController create() => TemplateController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RequestState<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RequestState<void>>(value),
    );
  }
}

String _$templateControllerHash() =>
    r'92582a4a92e6d30120f8ad60ff6c4b499181c5db';

/// "Download the template": fetch it with the admin's token, then hand it
/// to the share sheet.

abstract class _$TemplateController extends $Notifier<RequestState<void>> {
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
