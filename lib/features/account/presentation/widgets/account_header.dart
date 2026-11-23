import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';

/// Initial, name and email — what the website's account menu shows. An
/// account without an email shows its phone number as [detail] instead.
class AccountHeader extends StatelessWidget {
  const new({required this.name, required this.detail, super.key});

  final String name;
  final String? detail;

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
              if (detail case final detail?)
                Text(
                  detail,
                  style: context.text.bodyMedium.copyWith(
                    color: colors.inkMuted,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
