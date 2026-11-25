// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'claim_sort.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The claims list's order for one side (V2-8): newest, or by the
/// automatic check's score. Kept while a claim is open above the list.

@ProviderFor(ClaimSortChoice)
final claimSortChoiceProvider = ClaimSortChoiceFamily._();

/// The claims list's order for one side (V2-8): newest, or by the
/// automatic check's score. Kept while a claim is open above the list.
final class ClaimSortChoiceProvider
    extends $NotifierProvider<ClaimSortChoice, ClaimSort> {
  /// The claims list's order for one side (V2-8): newest, or by the
  /// automatic check's score. Kept while a claim is open above the list.
  ClaimSortChoiceProvider._({
    required ClaimSortChoiceFamily super.from,
    required ManageScope super.argument,
  }) : super(
         retry: null,
         name: r'claimSortChoiceProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$claimSortChoiceHash();

  @override
  String toString() {
    return r'claimSortChoiceProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ClaimSortChoice create() => ClaimSortChoice();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ClaimSort value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ClaimSort>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ClaimSortChoiceProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$claimSortChoiceHash() => r'f6eb881742149a574ba952db245297fefd291f4b';

/// The claims list's order for one side (V2-8): newest, or by the
/// automatic check's score. Kept while a claim is open above the list.

final class ClaimSortChoiceFamily extends $Family
    with
        $ClassFamilyOverride<
          ClaimSortChoice,
          ClaimSort,
          ClaimSort,
          ClaimSort,
          ManageScope
        > {
  ClaimSortChoiceFamily._()
    : super(
        retry: null,
        name: r'claimSortChoiceProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  /// The claims list's order for one side (V2-8): newest, or by the
  /// automatic check's score. Kept while a claim is open above the list.

  ClaimSortChoiceProvider call(ManageScope scope) =>
      ClaimSortChoiceProvider._(argument: scope, from: this);

  @override
  String toString() => r'claimSortChoiceProvider';
}

/// The claims list's order for one side (V2-8): newest, or by the
/// automatic check's score. Kept while a claim is open above the list.

abstract class _$ClaimSortChoice extends $Notifier<ClaimSort> {
  late final _$args = ref.$arg as ManageScope;
  ManageScope get scope => _$args;

  ClaimSort build(ManageScope scope);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ClaimSort, ClaimSort>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ClaimSort, ClaimSort>,
              ClaimSort,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
