// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_settings_controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// [brandId]'s profile for Settings. Loading while the future runs.

@ProviderFor(brandProfile)
final brandProfileProvider = BrandProfileFamily._();

/// [brandId]'s profile for Settings. Loading while the future runs.

final class BrandProfileProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<BrandProfile>>,
          Result<BrandProfile>,
          FutureOr<Result<BrandProfile>>
        >
    with
        $FutureModifier<Result<BrandProfile>>,
        $FutureProvider<Result<BrandProfile>> {
  /// [brandId]'s profile for Settings. Loading while the future runs.
  BrandProfileProvider._({
    required BrandProfileFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'brandProfileProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$brandProfileHash();

  @override
  String toString() {
    return r'brandProfileProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Result<BrandProfile>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<BrandProfile>> create(Ref ref) {
    final argument = this.argument as String;
    return brandProfile(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is BrandProfileProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$brandProfileHash() => r'583e0b717dda813658053a81075d01f7cfdd8127';

/// [brandId]'s profile for Settings. Loading while the future runs.

final class BrandProfileFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Result<BrandProfile>>, String> {
  BrandProfileFamily._()
    : super(
        retry: null,
        name: r'brandProfileProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// [brandId]'s profile for Settings. Loading while the future runs.

  BrandProfileProvider call(String brandId) =>
      BrandProfileProvider._(argument: brandId, from: this);

  @override
  String toString() => r'brandProfileProvider';
}

/// Saves Settings (`PATCH /brand/:brandId`). The brand's name and logo
/// also show in the tab's header and switcher, which come from the
/// session, so the user is re-read after a save.

@ProviderFor(BrandSettingsSaveController)
final brandSettingsSaveControllerProvider =
    BrandSettingsSaveControllerFamily._();

/// Saves Settings (`PATCH /brand/:brandId`). The brand's name and logo
/// also show in the tab's header and switcher, which come from the
/// session, so the user is re-read after a save.
final class BrandSettingsSaveControllerProvider
    extends
        $NotifierProvider<
          BrandSettingsSaveController,
          RequestState<BrandProfile>
        > {
  /// Saves Settings (`PATCH /brand/:brandId`). The brand's name and logo
  /// also show in the tab's header and switcher, which come from the
  /// session, so the user is re-read after a save.
  BrandSettingsSaveControllerProvider._({
    required BrandSettingsSaveControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'brandSettingsSaveControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$brandSettingsSaveControllerHash();

  @override
  String toString() {
    return r'brandSettingsSaveControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  BrandSettingsSaveController create() => BrandSettingsSaveController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RequestState<BrandProfile> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RequestState<BrandProfile>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is BrandSettingsSaveControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$brandSettingsSaveControllerHash() =>
    r'd256112c855afa99a92e2c53daa1eb53d0050d99';

/// Saves Settings (`PATCH /brand/:brandId`). The brand's name and logo
/// also show in the tab's header and switcher, which come from the
/// session, so the user is re-read after a save.

final class BrandSettingsSaveControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          BrandSettingsSaveController,
          RequestState<BrandProfile>,
          RequestState<BrandProfile>,
          RequestState<BrandProfile>,
          String
        > {
  BrandSettingsSaveControllerFamily._()
    : super(
        retry: null,
        name: r'brandSettingsSaveControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Saves Settings (`PATCH /brand/:brandId`). The brand's name and logo
  /// also show in the tab's header and switcher, which come from the
  /// session, so the user is re-read after a save.

  BrandSettingsSaveControllerProvider call(String brandId) =>
      BrandSettingsSaveControllerProvider._(argument: brandId, from: this);

  @override
  String toString() => r'brandSettingsSaveControllerProvider';
}

/// Saves Settings (`PATCH /brand/:brandId`). The brand's name and logo
/// also show in the tab's header and switcher, which come from the
/// session, so the user is re-read after a save.

abstract class _$BrandSettingsSaveController
    extends $Notifier<RequestState<BrandProfile>> {
  late final _$args = ref.$arg as String;
  String get brandId => _$args;

  RequestState<BrandProfile> build(String brandId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<RequestState<BrandProfile>, RequestState<BrandProfile>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                RequestState<BrandProfile>,
                RequestState<BrandProfile>
              >,
              RequestState<BrandProfile>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
