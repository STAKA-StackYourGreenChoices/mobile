import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/features/manage/brand_review/domain/models/review_brand.dart';
import 'package:staka/shared/formatters/date_format.dart';

/// One brand in the Admin tab's list: name, legal name, and when it applied
/// or how many people run it.
class ReviewBrandRow extends StatelessWidget {
  const new({required this.brand, required this.onPressed, super.key});

  final ReviewBrand brand;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final application = brand.application;
    final muted = context.text.bodyMedium.copyWith(
      color: context.colors.inkMuted,
    );
    final detail = [
      if (application.legalName != application.name) application.legalName,
      if (application.appliedAt case final at?) l10n.appliedOn(formatDate(at)),
      if (brand.memberCount case final count?) l10n.brandMembers(count),
    ].join(' · ');
    return MergeSemantics(
      child: InkWell(
        onTap: onPressed,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 64),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              spacing: AppSpacing.sm,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(application.name, style: context.text.label),
                      if (detail.isNotEmpty) Text(detail, style: muted),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: context.colors.inkMuted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
