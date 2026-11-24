// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_claim_count_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// How many claims wait for a decision in [scope] (the list's `total` for
/// the first pending page). Null when it couldn't be loaded; the hub then
/// shows its usual text. Reloads after each decision.

@ProviderFor(pendingClaimCount)
final pendingClaimCountProvider = PendingClaimCountFamily._();

/// How many claims wait for a decision in [scope] (the list's `total` for
/// the first pending page). Null when it couldn't be loaded; the hub then
/// shows its usual text. Reloads after each decision.

final class PendingClaimCountProvider
    extends $FunctionalProvider<AsyncValue<int?>, int?, FutureOr<int?>>
    with $FutureModifier<int?>, $FutureProvider<int?> {
  /// How many claims wait for a decision in [scope] (the list's `total` for
  /// the first pending page). Null when it couldn't be loaded; the hub then
  /// shows its usual text. Reloads after each decision.
  PendingClaimCountProvider._({
    required PendingClaimCountFamily super.from,
    required ManageScope super.argument,
  }) : super(
         retry: null,
         name: r'pendingClaimCountProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$pendingClaimCountHash();

  @override
  String toString() {
    return r'pendingClaimCountProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<int?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int?> create(Ref ref) {
    final argument = this.argument as ManageScope;
    return pendingClaimCount(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PendingClaimCountProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$pendingClaimCountHash() => r'8d03f93da5be92a9e2d737b214c27255efeb2ab4';

/// How many claims wait for a decision in [scope] (the list's `total` for
/// the first pending page). Null when it couldn't be loaded; the hub then
/// shows its usual text. Reloads after each decision.

final class PendingClaimCountFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<int?>, ManageScope> {
  PendingClaimCountFamily._()
    : super(
        retry: null,
        name: r'pendingClaimCountProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// How many claims wait for a decision in [scope] (the list's `total` for
  /// the first pending page). Null when it couldn't be loaded; the hub then
  /// shows its usual text. Reloads after each decision.

  PendingClaimCountProvider call(ManageScope scope) =>
      PendingClaimCountProvider._(argument: scope, from: this);

  @override
  String toString() => r'pendingClaimCountProvider';
}
