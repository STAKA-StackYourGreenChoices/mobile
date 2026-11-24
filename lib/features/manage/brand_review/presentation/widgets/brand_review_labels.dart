import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/features/brand_apply/domain/models/brand_application.dart';

/// How the Admin tab names a brand's status (an admin's words, not the
/// applicant's).
extension BrandReviewLabels on AppLocalizations {
  String brandReviewTabLabel(BrandApplicationStatus status) => switch (status) {
    BrandApplicationStatus.pending => brandReviewPending,
    BrandApplicationStatus.approved => brandReviewActive,
    BrandApplicationStatus.suspended => brandReviewSuspended,
    BrandApplicationStatus.rejected => brandReviewRejected,
  };
}
