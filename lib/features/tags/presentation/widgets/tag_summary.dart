import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/models/digital_card.dart';
import 'package:staka/shared/formatters/date_format.dart';

/// Brand, name, when it was added, and the description — the text beside
/// the tag on the website's tag page.
class TagSummary extends StatelessWidget {
  const new({required this.card, super.key});

  final DigitalCard card;

  @override
  Widget build(BuildContext context) {
    final product = card.product;
    final muted = context.colors.inkMuted;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.xxs,
      children: [
        Text(
          product.brand.name,
          style: context.text.label.copyWith(color: muted),
        ),
        Semantics(
          header: true,
          child: Text(product.name, style: context.text.headingLarge),
        ),
        Text(
          context.l10n.addedOn(formatDate(card.createdAt)),
          style: context.text.bodyMedium.copyWith(color: muted),
        ),
        if (product.description case final text?)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.sm),
            child: Text(text, style: context.text.bodyLarge),
          ),
      ],
    );
  }
}
