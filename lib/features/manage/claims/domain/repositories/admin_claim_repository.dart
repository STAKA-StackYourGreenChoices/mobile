import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/product.dart';
import 'package:staka/features/manage/claims/domain/models/claim.dart';

/// The ownership claims review queue.
abstract interface class AdminClaimRepository {
  /// [page] starts at 1; 20 per page.
  Future<Result<ClaimPage>> fetchClaims(
    ClaimStatus status,
    int page, {
    ClaimSort sort = ClaimSort.newest,
  });

  Future<Result<ClaimDetail>> fetchClaim(String id);

  Future<Result<ClaimReceipt>> fetchReceipt(String claimId);

  /// The claimed product in full, for its hang tag.
  Future<Result<Product>> fetchProduct(String productId);

  /// Refused with a conflict when the claim was already reviewed.
  Future<Result<ClaimDetail>> approve(String id);

  /// [reason] (3 to 500 characters) is shown to the shopper.
  Future<Result<ClaimDetail>> reject(String id, String reason);

  /// Admins only (V2-12): approve or reject whatever the brand decided,
  /// with a [reason] (3 to 500) that is recorded.
  Future<Result<ClaimDetail>> overrule(
    String id, {
    required ClaimStatus decision,
    required String reason,
  });
}
