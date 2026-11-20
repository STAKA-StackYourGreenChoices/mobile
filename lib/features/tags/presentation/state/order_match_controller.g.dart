// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_match_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// "Find it in my orders" for one tag.

@ProviderFor(OrderMatchController)
final orderMatchControllerProvider = OrderMatchControllerFamily._();

/// "Find it in my orders" for one tag.
final class OrderMatchControllerProvider
    extends $NotifierProvider<OrderMatchController, RequestState<Ownership>> {
  /// "Find it in my orders" for one tag.
  OrderMatchControllerProvider._({
    required OrderMatchControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'orderMatchControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$orderMatchControllerHash();

  @override
  String toString() {
    return r'orderMatchControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  OrderMatchController create() => OrderMatchController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RequestState<Ownership> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RequestState<Ownership>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is OrderMatchControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$orderMatchControllerHash() =>
    r'9fb5af94b1b46e518a3bea1e1ad648ea901af7e3';

/// "Find it in my orders" for one tag.

final class OrderMatchControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          OrderMatchController,
          RequestState<Ownership>,
          RequestState<Ownership>,
          RequestState<Ownership>,
          String
        > {
  OrderMatchControllerFamily._()
    : super(
        retry: null,
        name: r'orderMatchControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// "Find it in my orders" for one tag.

  OrderMatchControllerProvider call(String cardId) =>
      OrderMatchControllerProvider._(argument: cardId, from: this);

  @override
  String toString() => r'orderMatchControllerProvider';
}

/// "Find it in my orders" for one tag.

abstract class _$OrderMatchController
    extends $Notifier<RequestState<Ownership>> {
  late final _$args = ref.$arg as String;
  String get cardId => _$args;

  RequestState<Ownership> build(String cardId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<RequestState<Ownership>, RequestState<Ownership>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RequestState<Ownership>, RequestState<Ownership>>,
              RequestState<Ownership>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
