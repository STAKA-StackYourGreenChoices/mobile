import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';

/// The website's three numbered circles: Choose a file, Review, Import.
/// Like the website on phones, only the numbers show; screen readers hear
/// each step's name and whether it is done.
class ImportStepper extends StatelessWidget {
  const new({required this.current, required this.isFinished, super.key});

  /// 0, 1 or 2.
  final int current;

  /// Everything is done (the file was imported).
  final bool isFinished;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final names = [l10n.stepChooseFile, l10n.stepReview, l10n.stepImport];
    return Semantics(
      label: l10n.importProgressLabel,
      container: true,
      child: Row(
        children: [
          for (var i = 0; i < names.length; i++) ...[
            _StepCircle(
              number: i + 1,
              isDone: i < current || isFinished,
              isActive: i == current && !isFinished,
              label:
                  '${l10n.stepLabel(i + 1, names.length, names[i])}'
                  '${i < current || isFinished ? ' ${l10n.stepDone}' : ''}',
            ),
            if (i < names.length - 1)
              Container(
                width: AppSpacing.lg,
                height: 1,
                margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                color: context.colors.borderStrong,
              ),
          ],
        ],
      ),
    );
  }
}

class _StepCircle extends StatelessWidget {
  const new({
    required this.number,
    required this.isDone,
    required this.isActive,
    required this.label,
  });

  final int number;
  final bool isDone;
  final bool isActive;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final edge = isDone || isActive ? colors.brandPrimary : colors.borderStrong;
    return Semantics(
      label: label,
      selected: isActive,
      excludeSemantics: true,
      child: Container(
        width: 28,
        height: 28,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDone ? colors.brandPrimary : null,
          border: Border.all(color: edge),
        ),
        child: isDone
            ? Icon(Icons.check_rounded, size: 14, color: colors.onBrandPrimary)
            : Text(
                '$number',
                style: context.text.bodySmall.copyWith(
                  fontWeight: context.text.label.fontWeight,
                  color: isActive ? colors.brandPrimary : colors.inkMuted,
                ),
              ),
      ),
    );
  }
}
