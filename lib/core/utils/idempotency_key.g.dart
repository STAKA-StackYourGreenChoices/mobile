// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'idempotency_key.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Makes keys; tests swap it for a predictable one.

@ProviderFor(idempotencyKeys)
final idempotencyKeysProvider = IdempotencyKeysProvider._();

/// Makes keys; tests swap it for a predictable one.

final class IdempotencyKeysProvider
    extends
        $FunctionalProvider<
          String Function(),
          String Function(),
          String Function()
        >
    with $Provider<String Function()> {
  /// Makes keys; tests swap it for a predictable one.
  IdempotencyKeysProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'idempotencyKeysProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$idempotencyKeysHash();

  @$internal
  @override
  $ProviderElement<String Function()> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  String Function() create(Ref ref) {
    return idempotencyKeys(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String Function() value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String Function()>(value),
    );
  }
}

String _$idempotencyKeysHash() => r'6f9cc62af582d293c3800b3c8d1d2cb9c309a048';
