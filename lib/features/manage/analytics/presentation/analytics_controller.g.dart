// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The Analytics screen (V2-5): 30 days by default; another period or
/// brand loads again, keeping the old figures out of sight meanwhile.

@ProviderFor(AnalyticsController)
final analyticsControllerProvider = AnalyticsControllerFamily._();

/// The Analytics screen (V2-5): 30 days by default; another period or
/// brand loads again, keeping the old figures out of sight meanwhile.
final class AnalyticsControllerProvider
    extends $NotifierProvider<AnalyticsController, AnalyticsState> {
  /// The Analytics screen (V2-5): 30 days by default; another period or
  /// brand loads again, keeping the old figures out of sight meanwhile.
  AnalyticsControllerProvider._({
    required AnalyticsControllerFamily super.from,
    required ManageScope super.argument,
  }) : super(
         retry: null,
         name: r'analyticsControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$analyticsControllerHash();

  @override
  String toString() {
    return r'analyticsControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  AnalyticsController create() => AnalyticsController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AnalyticsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AnalyticsState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AnalyticsControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$analyticsControllerHash() =>
    r'8db40a909e49e94e69e44ce441b8afa6e65a5970';

/// The Analytics screen (V2-5): 30 days by default; another period or
/// brand loads again, keeping the old figures out of sight meanwhile.

final class AnalyticsControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          AnalyticsController,
          AnalyticsState,
          AnalyticsState,
          AnalyticsState,
          ManageScope
        > {
  AnalyticsControllerFamily._()
    : super(
        retry: null,
        name: r'analyticsControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The Analytics screen (V2-5): 30 days by default; another period or
  /// brand loads again, keeping the old figures out of sight meanwhile.

  AnalyticsControllerProvider call(ManageScope scope) =>
      AnalyticsControllerProvider._(argument: scope, from: this);

  @override
  String toString() => r'analyticsControllerProvider';
}

/// The Analytics screen (V2-5): 30 days by default; another period or
/// brand loads again, keeping the old figures out of sight meanwhile.

abstract class _$AnalyticsController extends $Notifier<AnalyticsState> {
  late final _$args = ref.$arg as ManageScope;
  ManageScope get scope => _$args;

  AnalyticsState build(ManageScope scope);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AnalyticsState, AnalyticsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AnalyticsState, AnalyticsState>,
              AnalyticsState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
