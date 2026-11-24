// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// One of the shopper's tags, kept up to date as they prove ownership.

@ProviderFor(TagController)
final tagControllerProvider = TagControllerFamily._();

/// One of the shopper's tags, kept up to date as they prove ownership.
final class TagControllerProvider
    extends $NotifierProvider<TagController, TagState> {
  /// One of the shopper's tags, kept up to date as they prove ownership.
  TagControllerProvider._({
    required TagControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'tagControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$tagControllerHash();

  @override
  String toString() {
    return r'tagControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  TagController create() => TagController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TagState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TagState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TagControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$tagControllerHash() => r'59ea4abc23678891d2050e6d833a5fcf16995011';

/// One of the shopper's tags, kept up to date as they prove ownership.

final class TagControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          TagController,
          TagState,
          TagState,
          TagState,
          String
        > {
  TagControllerFamily._()
    : super(
        retry: null,
        name: r'tagControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One of the shopper's tags, kept up to date as they prove ownership.

  TagControllerProvider call(String cardId) =>
      TagControllerProvider._(argument: cardId, from: this);

  @override
  String toString() => r'tagControllerProvider';
}

/// One of the shopper's tags, kept up to date as they prove ownership.

abstract class _$TagController extends $Notifier<TagState> {
  late final _$args = ref.$arg as String;
  String get cardId => _$args;

  TagState build(String cardId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<TagState, TagState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TagState, TagState>,
              TagState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
