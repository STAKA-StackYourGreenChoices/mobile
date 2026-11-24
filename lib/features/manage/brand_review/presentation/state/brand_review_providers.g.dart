// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_review_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Bumped after every brand decision, so the lists, the detail and the hub
/// count reload.

@ProviderFor(BrandReviewRevision)
final brandReviewRevisionProvider = BrandReviewRevisionProvider._();

/// Bumped after every brand decision, so the lists, the detail and the hub
/// count reload.
final class BrandReviewRevisionProvider
    extends $NotifierProvider<BrandReviewRevision, int> {
  /// Bumped after every brand decision, so the lists, the detail and the hub
  /// count reload.
  BrandReviewRevisionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'brandReviewRevisionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$brandReviewRevisionHash();

  @$internal
  @override
  BrandReviewRevision create() => BrandReviewRevision();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$brandReviewRevisionHash() =>
    r'846c6ec8a0e32feed5520a430bf1584f8267e894';

/// Bumped after every brand decision, so the lists, the detail and the hub
/// count reload.

abstract class _$BrandReviewRevision extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The brands in one status, newest application first.

@ProviderFor(reviewBrands)
final reviewBrandsProvider = ReviewBrandsFamily._();

/// The brands in one status, newest application first.

final class ReviewBrandsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<List<ReviewBrand>>>,
          Result<List<ReviewBrand>>,
          FutureOr<Result<List<ReviewBrand>>>
        >
    with
        $FutureModifier<Result<List<ReviewBrand>>>,
        $FutureProvider<Result<List<ReviewBrand>>> {
  /// The brands in one status, newest application first.
  ReviewBrandsProvider._({
    required ReviewBrandsFamily super.from,
    required BrandApplicationStatus super.argument,
  }) : super(
         retry: null,
         name: r'reviewBrandsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$reviewBrandsHash();

  @override
  String toString() {
    return r'reviewBrandsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Result<List<ReviewBrand>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<List<ReviewBrand>>> create(Ref ref) {
    final argument = this.argument as BrandApplicationStatus;
    return reviewBrands(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ReviewBrandsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$reviewBrandsHash() => r'64025ae10f166b1be7ff3fa35496e62a1a0bd325';

/// The brands in one status, newest application first.

final class ReviewBrandsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Result<List<ReviewBrand>>>,
          BrandApplicationStatus
        > {
  ReviewBrandsFamily._()
    : super(
        retry: null,
        name: r'reviewBrandsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The brands in one status, newest application first.

  ReviewBrandsProvider call(BrandApplicationStatus status) =>
      ReviewBrandsProvider._(argument: status, from: this);

  @override
  String toString() => r'reviewBrandsProvider';
}

@ProviderFor(reviewBrand)
final reviewBrandProvider = ReviewBrandFamily._();

final class ReviewBrandProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<ReviewBrand>>,
          Result<ReviewBrand>,
          FutureOr<Result<ReviewBrand>>
        >
    with
        $FutureModifier<Result<ReviewBrand>>,
        $FutureProvider<Result<ReviewBrand>> {
  ReviewBrandProvider._({
    required ReviewBrandFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'reviewBrandProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$reviewBrandHash();

  @override
  String toString() {
    return r'reviewBrandProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Result<ReviewBrand>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<ReviewBrand>> create(Ref ref) {
    final argument = this.argument as String;
    return reviewBrand(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ReviewBrandProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$reviewBrandHash() => r'd67e87f66ce8b16d5e3444c04851bc24a6367c58';

final class ReviewBrandFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Result<ReviewBrand>>, String> {
  ReviewBrandFamily._()
    : super(
        retry: null,
        name: r'reviewBrandProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ReviewBrandProvider call(String id) =>
      ReviewBrandProvider._(argument: id, from: this);

  @override
  String toString() => r'reviewBrandProvider';
}

/// The private business document, fetched with the admin's token.

@ProviderFor(brandDocument)
final brandDocumentProvider = BrandDocumentFamily._();

/// The private business document, fetched with the admin's token.

final class BrandDocumentProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<BrandDocument>>,
          Result<BrandDocument>,
          FutureOr<Result<BrandDocument>>
        >
    with
        $FutureModifier<Result<BrandDocument>>,
        $FutureProvider<Result<BrandDocument>> {
  /// The private business document, fetched with the admin's token.
  BrandDocumentProvider._({
    required BrandDocumentFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'brandDocumentProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$brandDocumentHash();

  @override
  String toString() {
    return r'brandDocumentProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Result<BrandDocument>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<BrandDocument>> create(Ref ref) {
    final argument = this.argument as String;
    return brandDocument(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is BrandDocumentProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$brandDocumentHash() => r'e62c63b0c684f7dc772f02858ce0632320d7a8dc';

/// The private business document, fetched with the admin's token.

final class BrandDocumentFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Result<BrandDocument>>, String> {
  BrandDocumentFamily._()
    : super(
        retry: null,
        name: r'brandDocumentProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The private business document, fetched with the admin's token.

  BrandDocumentProvider call(String id) =>
      BrandDocumentProvider._(argument: id, from: this);

  @override
  String toString() => r'brandDocumentProvider';
}

/// How many applications wait for a decision; null if unknown.

@ProviderFor(pendingBrandCount)
final pendingBrandCountProvider = PendingBrandCountProvider._();

/// How many applications wait for a decision; null if unknown.

final class PendingBrandCountProvider
    extends $FunctionalProvider<AsyncValue<int?>, int?, FutureOr<int?>>
    with $FutureModifier<int?>, $FutureProvider<int?> {
  /// How many applications wait for a decision; null if unknown.
  PendingBrandCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingBrandCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingBrandCountHash();

  @$internal
  @override
  $FutureProviderElement<int?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int?> create(Ref ref) {
    return pendingBrandCount(ref);
  }
}

String _$pendingBrandCountHash() => r'bb79d4a0d7f28e59b1ebffc02d4fca17d9ae9191';

/// Approve, reject, suspend or reinstate one brand.

@ProviderFor(BrandDecisionController)
final brandDecisionControllerProvider = BrandDecisionControllerFamily._();

/// Approve, reject, suspend or reinstate one brand.
final class BrandDecisionControllerProvider
    extends $NotifierProvider<BrandDecisionController, RequestState<void>> {
  /// Approve, reject, suspend or reinstate one brand.
  BrandDecisionControllerProvider._({
    required BrandDecisionControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'brandDecisionControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$brandDecisionControllerHash();

  @override
  String toString() {
    return r'brandDecisionControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  BrandDecisionController create() => BrandDecisionController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RequestState<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RequestState<void>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is BrandDecisionControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$brandDecisionControllerHash() =>
    r'e865c2bf482e894bcc3c6a7ae33f23646db8487d';

/// Approve, reject, suspend or reinstate one brand.

final class BrandDecisionControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          BrandDecisionController,
          RequestState<void>,
          RequestState<void>,
          RequestState<void>,
          String
        > {
  BrandDecisionControllerFamily._()
    : super(
        retry: null,
        name: r'brandDecisionControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Approve, reject, suspend or reinstate one brand.

  BrandDecisionControllerProvider call(String brandId) =>
      BrandDecisionControllerProvider._(argument: brandId, from: this);

  @override
  String toString() => r'brandDecisionControllerProvider';
}

/// Approve, reject, suspend or reinstate one brand.

abstract class _$BrandDecisionController extends $Notifier<RequestState<void>> {
  late final _$args = ref.$arg as String;
  String get brandId => _$args;

  RequestState<void> build(String brandId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<RequestState<void>, RequestState<void>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RequestState<void>, RequestState<void>>,
              RequestState<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
