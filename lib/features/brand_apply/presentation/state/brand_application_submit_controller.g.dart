// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_application_submit_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Sends the application form: a new application ([applicationId] null)
/// or a rejected one again. The list shows the answer straight away.

@ProviderFor(BrandApplicationSubmitController)
final brandApplicationSubmitControllerProvider =
    BrandApplicationSubmitControllerFamily._();

/// Sends the application form: a new application ([applicationId] null)
/// or a rejected one again. The list shows the answer straight away.
final class BrandApplicationSubmitControllerProvider
    extends
        $NotifierProvider<
          BrandApplicationSubmitController,
          RequestState<BrandApplication>
        > {
  /// Sends the application form: a new application ([applicationId] null)
  /// or a rejected one again. The list shows the answer straight away.
  BrandApplicationSubmitControllerProvider._({
    required BrandApplicationSubmitControllerFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'brandApplicationSubmitControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$brandApplicationSubmitControllerHash();

  @override
  String toString() {
    return r'brandApplicationSubmitControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  BrandApplicationSubmitController create() =>
      BrandApplicationSubmitController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RequestState<BrandApplication> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RequestState<BrandApplication>>(
        value,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is BrandApplicationSubmitControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$brandApplicationSubmitControllerHash() =>
    r'b8bfd12fc280112006708912f3a7b4cc0aea731e';

/// Sends the application form: a new application ([applicationId] null)
/// or a rejected one again. The list shows the answer straight away.

final class BrandApplicationSubmitControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          BrandApplicationSubmitController,
          RequestState<BrandApplication>,
          RequestState<BrandApplication>,
          RequestState<BrandApplication>,
          String?
        > {
  BrandApplicationSubmitControllerFamily._()
    : super(
        retry: null,
        name: r'brandApplicationSubmitControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Sends the application form: a new application ([applicationId] null)
  /// or a rejected one again. The list shows the answer straight away.

  BrandApplicationSubmitControllerProvider call(String? applicationId) =>
      BrandApplicationSubmitControllerProvider._(
        argument: applicationId,
        from: this,
      );

  @override
  String toString() => r'brandApplicationSubmitControllerProvider';
}

/// Sends the application form: a new application ([applicationId] null)
/// or a rejected one again. The list shows the answer straight away.

abstract class _$BrandApplicationSubmitController
    extends $Notifier<RequestState<BrandApplication>> {
  late final _$args = ref.$arg as String?;
  String? get applicationId => _$args;

  RequestState<BrandApplication> build(String? applicationId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              RequestState<BrandApplication>,
              RequestState<BrandApplication>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                RequestState<BrandApplication>,
                RequestState<BrandApplication>
              >,
              RequestState<BrandApplication>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
