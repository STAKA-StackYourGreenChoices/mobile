import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';

/// Shared layout of the empty and error states: icon, optional title,
/// message, optional action, start-aligned like the website on phones.
/// Wraps naturally, so it survives 200 % text scale (guide §6.2).
class FeedbackMessage extends StatelessWidget {
  const new({
    required this.icon,
    required this.iconColor,
    required this.message,
    this.title,
    this.action,
    super.key,
  });

  final IconData icon;
  final Color iconColor;
  final Widget? title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    // Where the parent limits the height (a fixed area, a page that
    // doesn't scroll), large text scrolls instead of overflowing. Inside a
    // list the height is open and nothing changes.
    return LayoutBuilder(
      builder: (context, constraints) => constraints.hasBoundedHeight
          ? SingleChildScrollView(child: _content(context))
          : _content(context),
    );
  }

  Widget _content(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ExcludeSemantics(
            child: Icon(icon, size: AppSizes.iconEmptyState, color: iconColor),
          ),
          const SizedBox(height: AppSpacing.md),
          if (title case final title?) ...[
            title,
            const SizedBox(height: AppSpacing.xs),
          ],
          Text(
            message,
            style: context.text.bodyLarge.copyWith(
              color: context.colors.inkMuted,
            ),
          ),
          if (action case final action?) ...[
            const SizedBox(height: AppSpacing.lg),
            action,
          ],
        ],
      ),
    );
  }
}
