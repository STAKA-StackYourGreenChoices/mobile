import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';

/// Brand, product name and description at the top of the product page.
class ProductHeading extends StatelessWidget {
  const new({
    required this.brandName,
    required this.productName,
    this.description,
    super.key,
  });

  final String brandName;
  final String productName;
  final String? description;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        brandName,
        style: context.text.label.copyWith(color: context.colors.inkMuted),
      ),
      const SizedBox(height: AppSpacing.xxs),
      Semantics(
        header: true,
        child: Text(productName, style: context.text.headingLarge),
      ),
      if (description case final text?) ...[
        const SizedBox(height: AppSpacing.sm),
        Text(text, style: context.text.bodyLarge),
      ],
    ],
  );
}
