import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';

/// Heading and one line of context at the top of sign-in and register,
/// as on the website.
class AuthPageHeading extends StatelessWidget {
  const new({required this.title, required this.lede, super.key});

  final String title;
  final String lede;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Semantics(
        header: true,
        child: Text(title, style: context.text.headingLarge),
      ),
      const SizedBox(height: AppSpacing.xs),
      Text(
        lede,
        style: context.text.bodyLarge.copyWith(color: context.colors.inkMuted),
      ),
      const SizedBox(height: AppSpacing.lg),
    ],
  );
}
