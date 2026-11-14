import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';

/// "Verified (2)" with one line of explanation, above a group of tags.
class TagSectionHeader extends StatelessWidget {
  const new({
    required this.title,
    required this.count,
    required this.description,
    super.key,
  });

  final String title;
  final int count;
  final String description;

  @override
  Widget build(BuildContext context) {
    final text = context.text;
    final muted = context.colors.inkMuted;
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xl, bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: title, style: text.headingMedium),
                  TextSpan(
                    text: ' ($count)',
                    style: text.numeric.copyWith(color: muted),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(description, style: text.bodyMedium.copyWith(color: muted)),
        ],
      ),
    );
  }
}
