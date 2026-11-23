// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'phone_link_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PhoneLinkController)
final phoneLinkControllerProvider = PhoneLinkControllerProvider._();

final class PhoneLinkControllerProvider
    extends $NotifierProvider<PhoneLinkController, PhoneLinkState> {
  PhoneLinkControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'phoneLinkControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$phoneLinkControllerHash();

  @$internal
  @override
  PhoneLinkController create() => PhoneLinkController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PhoneLinkState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PhoneLinkState>(value),
    );
  }
}

String _$phoneLinkControllerHash() =>
    r'bfba636a65c016ce3f0eac5c66ffffcbb87cd2da';

abstract class _$PhoneLinkController extends $Notifier<PhoneLinkState> {
  PhoneLinkState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<PhoneLinkState, PhoneLinkState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PhoneLinkState, PhoneLinkState>,
              PhoneLinkState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
