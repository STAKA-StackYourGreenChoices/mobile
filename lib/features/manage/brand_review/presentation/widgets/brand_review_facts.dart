import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/features/manage/brand_review/domain/models/review_brand.dart';
import 'package:staka/shared/formatters/date_format.dart';

/// What the brand told STAKA, one labelled line each; empty ones are left
/// out.
class BrandReviewFacts extends StatelessWidget {
  const new({required this.brand, super.key});

  final ReviewBrand brand;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final application = brand.application;
    final facts = [
      (l10n.fieldLegalName, application.legalName),
      (l10n.fieldGstin, application.gstin),
      (l10n.fieldWebsite, application.websiteUrl),
      (l10n.fieldContactEmail, application.contactEmail),
      (l10n.fieldContactPhone, application.contactPhone),
      (l10n.aboutTheBrand, application.description),
      (
        l10n.appliedHeading,
        switch (application.appliedAt) {
          final at? => formatDate(at),
          null => null,
        },
      ),
      (
        l10n.teamHeading,
        switch (brand.memberCount) {
          final count? => l10n.brandMembers(count),
          null => null,
        },
      ),
      if (application.existingBrandId != null)
        (l10n.listedBrandHeading, l10n.claimsListedBrand),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.md,
      children: [
        for (final (label, value) in facts)
          if (value != null && value.trim().isNotEmpty)
            MergeSemantics(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.xxs,
                children: [
                  Text(label, style: context.text.label),
                  SelectableText(
                    value,
                    style: context.text.bodyLarge.copyWith(
                      color: context.colors.inkMuted,
                    ),
                  ),
                ],
              ),
            ),
      ],
    );
  }
}
