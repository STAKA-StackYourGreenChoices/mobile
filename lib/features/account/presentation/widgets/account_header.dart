import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';

/// Initial, name and email — what the website's account menu shows.
class AccountHeader extends StatelessWidget {
  const new({required this.name, required this.email, super.key});

  final String name;
  final String email;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final initial = name.trim().isEmpty ? '?' : name.trim()[0].toUpperCase();
    return Row(
      children: [
        ExcludeSemantics(
          child: CircleAvatar(
            radius: AppSizes.iconEmptyState / 2,
            backgroundColor: colors.brandPrimary,
            child: Text(
              initial,
              style: context.text.headingMedium.copyWith(
                color: colors.onBrandPrimary,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: context.text.headingSmall),
              Text(
                email,
                style: context.text.bodyMedium.copyWith(color: colors.inkMuted),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
