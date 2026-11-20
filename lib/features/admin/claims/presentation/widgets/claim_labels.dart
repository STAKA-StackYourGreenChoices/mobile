import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/models/ownership.dart';
import 'package:staka/features/admin/claims/domain/models/claim.dart';

/// The website's short labels for a claim, shared by the list and the
/// review page.
extension ClaimLabels on AppLocalizations {
  /// "Order match" or "Receipt 2 of 5".
  String claimMethodLabel(Claim claim) => claim.method == ClaimMethod.orderMatch
      ? methodOrderMatch
      : receiptAttemptOf(claim.receiptAttempt?.toString() ?? '?');

  String claimTabLabel(ClaimStatus status) => switch (status) {
    ClaimStatus.pending => tabToReview,
    ClaimStatus.approved => tabApproved,
    ClaimStatus.rejected => tabRejected,
  };
}
