import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';

/// A titled group of Account rows ("How you sign in"). Later V2 slices add
/// Notifications and Your data the same way.
class AccountSection extends StatelessWidget {
  const new({required this.title, required this.children, super.key});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: AppSpacing.sm,
    children: [
      Semantics(
        header: true,
        child: Text(title, style: context.text.headingSmall),
      ),
      ...children,
    ],
  );
}
