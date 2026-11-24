import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/error/result.dart';
import 'package:staka/core/state/request_state.dart';
import 'package:staka/features/brand_apply/domain/models/brand_application.dart';
import 'package:staka/features/manage/brand_review/data/brand_review_repository_impl.dart';
import 'package:staka/features/manage/brand_review/domain/models/review_brand.dart';
import 'package:staka/features/manage/brand_review/domain/repositories/brand_review_repository.dart';

part 'brand_review_providers.g.dart';

/// Bumped after every brand decision, so the lists, the detail and the hub
/// count reload.
@Riverpod(keepAlive: true)
class BrandReviewRevision extends _$BrandReviewRevision {
  @override
  int build() => 0;

  void bump() => state++;
}

/// The brands in one status, newest application first.
@riverpod
Future<Result<List<ReviewBrand>>> reviewBrands(
  Ref ref,
  BrandApplicationStatus status,
) {
  ref.watch(brandReviewRevisionProvider);
  return ref.read(brandReviewRepositoryProvider).fetchBrands(status);
}

@riverpod
Future<Result<ReviewBrand>> reviewBrand(Ref ref, String id) {
  ref.watch(brandReviewRevisionProvider);
  return ref.read(brandReviewRepositoryProvider).fetchBrand(id);
}

/// The private business document, fetched with the admin's token.
@riverpod
Future<Result<BrandDocument>> brandDocument(Ref ref, String id) =>
    ref.read(brandReviewRepositoryProvider).fetchDocument(id);

/// How many applications wait for a decision; null if unknown.
@riverpod
Future<int?> pendingBrandCount(Ref ref) async {
  final result = await ref.watch(
    reviewBrandsProvider(BrandApplicationStatus.pending).future,
  );
  return switch (result) {
    Ok(:final value) => value.length,
    Err() => null,
  };
}

/// Approve, reject, suspend or reinstate one brand.
@riverpod
class BrandDecisionController extends _$BrandDecisionController {
  @override
  RequestState<void> build(String brandId) => const RequestIdle();

  Future<void> approve() => _run((brands) => brands.approve(brandId));

  Future<void> reject(String reason) =>
      _run((brands) => brands.reject(brandId, reason));

  Future<void> suspend(String reason) =>
      _run((brands) => brands.suspend(brandId, reason));

  Future<void> reinstate() => _run((brands) => brands.reinstate(brandId));

  /// A closed sheet or dialog forgets its error.
  void reset() {
    if (state is! RequestSending) state = const RequestIdle();
  }

  Future<void> _run(
    Future<Result<void>> Function(BrandReviewRepository brands) call,
  ) async {
    if (state is RequestSending) return;
    final revision = ref.read(brandReviewRevisionProvider.notifier);
    state = const RequestSending();
    final result = await call(ref.read(brandReviewRepositoryProvider));
    if (result is Ok) revision.bump();
    if (!ref.mounted) return;
    state = switch (result) {
      Ok() => const RequestDone(null),
      Err(:final failure) => RequestFailed(failure),
    };
  }
}
