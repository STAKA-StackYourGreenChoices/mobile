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
final templateControllerProvider = TemplateControllerFamily._();

/// "Download the template": fetch it with the admin's token, then hand it
/// to the share sheet.
final class TemplateControllerProvider
    extends $NotifierProvider<TemplateController, RequestState<void>> {
  /// "Download the template": fetch it with the admin's token, then hand it
  /// to the share sheet.
  TemplateControllerProvider._({
    required TemplateControllerFamily super.from,
    required ManageScope super.argument,
  }) : super(
         retry: null,
         name: r'templateControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$templateControllerHash();

  @override
  String toString() {
    return r'templateControllerProvider'
        ''
        '($argument)';
  }

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

  @override
  bool operator ==(Object other) {
    return other is TemplateControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$templateControllerHash() =>
    r'2a52c961c5f881f45ebfaa8f31de04009491547b';

/// "Download the template": fetch it with the admin's token, then hand it
/// to the share sheet.

final class TemplateControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          TemplateController,
          RequestState<void>,
          RequestState<void>,
          RequestState<void>,
          ManageScope
        > {
  TemplateControllerFamily._()
    : super(
        retry: null,
        name: r'templateControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// "Download the template": fetch it with the admin's token, then hand it
  /// to the share sheet.

  TemplateControllerProvider call(ManageScope scope) =>
      TemplateControllerProvider._(argument: scope, from: this);

  @override
  String toString() => r'templateControllerProvider';
}

/// "Download the template": fetch it with the admin's token, then hand it
/// to the share sheet.

abstract class _$TemplateController extends $Notifier<RequestState<void>> {
  late final _$args = ref.$arg as ManageScope;
  ManageScope get scope => _$args;

  RequestState<void> build(ManageScope scope);
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
    return element.handleCreate(ref, () => build(_$args));
  }
}
