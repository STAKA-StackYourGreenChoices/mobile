import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';

/// An on/off choice in a bordered box, with an optional line under the
/// label: the website's `Field` + `Switch` rows in the product form.
class FormSwitchRow extends StatelessWidget {
  const new({
    required this.label,
    required this.value,
    required this.onChanged,
    this.description,
    super.key,
  });

  final String label;
  final String? description;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => Material(
    color: context.colors.surfaceRaised,
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
      side: BorderSide(color: context.colors.border),
      borderRadius: AppRadius.allSm,
    ),
    child: SwitchListTile(
      value: value,
      onChanged: onChanged,
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      title: Text(label, style: context.text.bodyLarge),
      subtitle: switch (description) {
        final text? => Text(
          text,
          style: context.text.bodySmall.copyWith(
            color: context.colors.inkMuted,
          ),
        ),
        null => null,
      },
    ),
  );
}
