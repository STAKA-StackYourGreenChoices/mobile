import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/features/brand_apply/domain/models/brand_application.dart';
import 'package:staka/features/manage/brand_review/presentation/widgets/brand_review_labels.dart';
import 'package:staka/shared/widgets/data_display/status_pill.dart';

/// A brand's status as the Admin tab names it.
class ReviewBrandStatusPill extends StatelessWidget {
  const new({required this.status, super.key});

  final BrandApplicationStatus status;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (icon, color) = switch (status) {
      BrandApplicationStatus.pending => (
        Icons.schedule_rounded,
        colors.brandPrimary,
      ),
      BrandApplicationStatus.approved => (
        Icons.verified_rounded,
        colors.success,
      ),
      BrandApplicationStatus.suspended => (
        Icons.pause_circle_outline_rounded,
        colors.inkMuted,
      ),
      BrandApplicationStatus.rejected => (
        Icons.error_outline_rounded,
        colors.dangerText,
      ),
    };
    return StatusPill(
      icon: icon,
      label: context.l10n.brandReviewTabLabel(status),
      color: color,
    );
  }
}
