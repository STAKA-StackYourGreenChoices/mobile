import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/product.dart';
import 'package:staka/features/admin/claims/domain/models/claim.dart';

/// The ownership claims review queue.
abstract interface class AdminClaimRepository {
  /// [page] starts at 1; 20 per page.
  Future<Result<ClaimPage>> fetchClaims(ClaimStatus status, int page);

  Future<Result<ClaimDetail>> fetchClaim(String id);

  Future<Result<ClaimReceipt>> fetchReceipt(String claimId);

  /// The claimed product in full, for its hang tag.
  Future<Result<Product>> fetchProduct(String productId);

  /// Refused with a conflict when the claim was already reviewed.
  Future<Result<ClaimDetail>> approve(String id);

  /// [reason] (3 to 500 characters) is shown to the shopper.
  Future<Result<ClaimDetail>> reject(String id, String reason);
}
