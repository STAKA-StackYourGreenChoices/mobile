// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(analyticsRepository)
final analyticsRepositoryProvider = AnalyticsRepositoryFamily._();

final class AnalyticsRepositoryProvider
    extends
        $FunctionalProvider<
          AnalyticsRepository,
          AnalyticsRepository,
          AnalyticsRepository
        >
    with $Provider<AnalyticsRepository> {
  AnalyticsRepositoryProvider._({
    required AnalyticsRepositoryFamily super.from,
    required ManageScope super.argument,
  }) : super(
         retry: null,
         name: r'analyticsRepositoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$analyticsRepositoryHash();

  @override
  String toString() {
    return r'analyticsRepositoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<AnalyticsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AnalyticsRepository create(Ref ref) {
    final argument = this.argument as ManageScope;
    return analyticsRepository(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AnalyticsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AnalyticsRepository>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AnalyticsRepositoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$analyticsRepositoryHash() =>
    r'53aab476baf2469ddddd5eabf09517717e044e75';

final class AnalyticsRepositoryFamily extends $Family
    with $FunctionalFamilyOverride<AnalyticsRepository, ManageScope> {
  AnalyticsRepositoryFamily._()
    : super(
        retry: null,
        name: r'analyticsRepositoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AnalyticsRepositoryProvider call(ManageScope scope) =>
      AnalyticsRepositoryProvider._(argument: scope, from: this);

  @override
  String toString() => r'analyticsRepositoryProvider';
}
