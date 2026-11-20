import 'package:staka/core/error/failure.dart';
import 'package:staka/core/models/product.dart';
import 'package:staka/features/admin/claims/domain/models/claim.dart';

/// The claim review page (guide §4.3).
sealed class ClaimReviewState {
  const new();
}

final class ClaimReviewLoading extends ClaimReviewState {
  const new();
}

/// [product] is the full product for its hang tag; null when it could
/// not be loaded (the website then leaves the tag out).
final class ClaimReviewReady extends ClaimReviewState {
  const new(this.detail, {this.product});

  final ClaimDetail detail;
  final Product? product;
}

/// No claim has this id (the website shows its 404 page).
final class ClaimReviewNotFound extends ClaimReviewState {
  const new();
}

final class ClaimReviewFailed extends ClaimReviewState {
  const new(this.failure);

  final Failure failure;
}
