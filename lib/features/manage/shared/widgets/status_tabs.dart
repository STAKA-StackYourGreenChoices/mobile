import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';

/// A row of status tabs, the selected one underlined with its count (the
/// website's status tabs on claims, brands and disputes).
class StatusTabs<T> extends StatelessWidget {
  const new({
    required this.values,
    required this.labelOf,
    required this.selected,
    required this.onSelected,
    required this.semanticsLabel,
    this.count,
    super.key,
  });

  final List<T> values;
  final String Function(T value) labelOf;
  final T selected;
  final ValueChanged<T> onSelected;

  /// What the row is, for screen readers ("Claim status").
  final String semanticsLabel;

  /// How many items the selected tab holds, once known.
  final int? count;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      label: semanticsLabel,
      container: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: colors.border)),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final value in values)
                _Tab(
                  label: labelOf(value),
                  count: value == selected ? count : null,
                  isSelected: value == selected,
                  onPressed: () => onSelected(value),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const new({
    required this.label,
    required this.isSelected,
    required this.onPressed,
    this.count,
  });

  final String label;
  final int? count;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      selected: isSelected,
      button: true,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          constraints: const BoxConstraints(minHeight: AppSizes.minTapTarget),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 2,
                color: isSelected ? colors.brandPrimary : Colors.transparent,
              ),
            ),
          ),
          child: Row(
            spacing: AppSpacing.xs,
            children: [
              Text(
                label,
                style: context.text.label.copyWith(
                  color: isSelected ? colors.ink : colors.inkMuted,
                ),
              ),
              if (count case final value?)
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.surfaceSunken,
                    borderRadius: AppRadius.allFull,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs,
                      vertical: 2,
                    ),
                    child: Text('$value', style: context.text.bodySmall),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
