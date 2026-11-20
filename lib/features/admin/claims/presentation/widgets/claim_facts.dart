import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/features/admin/claims/domain/models/claim.dart';

/// "What to check" against the receipt, and who the shopper is.
class ClaimFacts extends StatelessWidget {
  const new({required this.claim, super.key});

  final Claim claim;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final muted = context.text.bodyMedium.copyWith(
      color: context.colors.inkMuted,
    );
    final product = claim.product;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.xl,
      children: [
        _Section(
          title: l10n.whatToCheck,
          children: [
            for (final point in [
              l10n.checkShop(product.brandName),
              l10n.checkLine(product.name, product.sku),
              l10n.checkReal,
            ])
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('•  ', style: muted),
                  Expanded(child: Text(point, style: muted)),
                ],
              ),
          ],
        ),
        _Section(
          title: l10n.shopperHeading,
          children: [
            Text(claim.user.name, style: context.text.bodyLarge),
            Text(claim.user.email, style: muted),
          ],
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const new({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: AppSpacing.xxs,
    children: [
      Semantics(
        header: true,
        child: Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.xxs),
          child: Text(title, style: context.text.label),
        ),
      ),
      ...children,
    ],
  );
}
