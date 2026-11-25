import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/features/manage/claims/domain/models/claim.dart';
import 'package:staka/shared/formatters/date_format.dart';
import 'package:staka/shared/widgets/data_display/status_pill.dart';

/// The receipt check (V2-8) above the decision: what was read, whether
/// brand, piece and date fit, the score, and a reused file. Admins get a
/// way to the earlier claim ([onEarlierClaimPressed]); brands only the
/// flag.
class AutomaticCheckCard extends StatelessWidget {
  const new({required this.analysis, this.onEarlierClaimPressed, super.key});

  final ReceiptAnalysis analysis;
  final ValueChanged<String>? onEarlierClaimPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final muted = context.text.bodySmall.copyWith(color: colors.inkMuted);
    return Card(
      child: Padding(
        padding: AppSpacing.card,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.sm,
          children: [
            Row(
              spacing: AppSpacing.xs,
              children: [
                Icon(Icons.document_scanner_outlined, color: colors.inkMuted),
                Expanded(
                  child: Semantics(
                    header: true,
                    child: Text(
                      l10n.automaticCheckTitle,
                      style: context.text.headingSmall,
                    ),
                  ),
                ),
              ],
            ),
            Text(l10n.automaticCheckBody, style: muted),
            ...switch (analysis.status) {
              AnalysisStatus.pending => [
                _Notice(
                  icon: Icons.hourglass_top_rounded,
                  color: colors.inkMuted,
                  text: l10n.automaticCheckPending,
                ),
              ],
              AnalysisStatus.failed => [
                _Notice(
                  icon: Icons.help_outline_rounded,
                  color: colors.warning,
                  text: l10n.automaticCheckFailed,
                ),
              ],
              AnalysisStatus.done => _done(context),
            },
            if (analysis.duplicateOfClaimId case final earlier?) ...[
              _Notice(
                icon: Icons.content_copy_rounded,
                color: colors.dangerText,
                text: l10n.receiptUsedBefore,
              ),
              if (onEarlierClaimPressed case final open?)
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: TextButton(
                    onPressed: () => open(earlier),
                    child: Text(l10n.openEarlierClaim),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  List<Widget> _done(BuildContext context) {
    final l10n = context.l10n;
    final notFound = l10n.analysisNotFound;
    return [
      _Fact(label: l10n.analysisShop, value: analysis.merchant ?? notFound),
      _Fact(
        label: l10n.analysisBoughtOn,
        value: switch (analysis.purchaseDate) {
          final date? => formatDate(date),
          null => notFound,
        },
      ),
      _Fact(
        label: l10n.analysisTotal,
        value: switch (analysis.total) {
          // Receipts on STAKA are Indian shops' (DECISIONS V2-8).
          final total? => NumberFormat.currency(
            locale: 'en_IN',
            symbol: '₹',
          ).format(total),
          null => notFound,
        },
      ),
      const Divider(height: 1),
      _Check(label: l10n.analysisBrand, value: analysis.brandMatched),
      _Check(label: l10n.analysisProduct, value: analysis.productMatched),
      _Check(label: l10n.analysisDateFits, value: analysis.dateOk),
      if (analysis.score case final score?)
        Text(
          l10n.analysisScore(score),
          style: context.text.label.copyWith(color: context.colors.ink),
        ),
    ];
  }
}

class _Fact extends StatelessWidget {
  const new({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => MergeSemantics(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.sm,
      children: [
        SizedBox(
          width: 96,
          child: Text(
            label,
            style: context.text.bodySmall.copyWith(
              color: context.colors.inkMuted,
            ),
          ),
        ),
        Expanded(child: Text(value, style: context.text.bodyMedium)),
      ],
    ),
  );
}

/// ✓ yes, ✗ no, ? not sure: icon and word, never colour alone.
class _Check extends StatelessWidget {
  const new({required this.label, required this.value});

  final String label;
  final bool? value;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final (icon, word, color) = switch (value) {
      true => (Icons.check_circle_rounded, l10n.analysisYes, colors.success),
      false => (Icons.cancel_rounded, l10n.analysisNo, colors.dangerText),
      null => (
        Icons.help_outline_rounded,
        l10n.analysisUnsure,
        colors.inkMuted,
      ),
    };
    return MergeSemantics(
      child: Row(
        spacing: AppSpacing.xs,
        children: [
          Icon(icon, size: AppSizes.iconDefault, color: color),
          Expanded(child: Text(label, style: context.text.bodyMedium)),
          Text(word, style: context.text.label.copyWith(color: color)),
        ],
      ),
    );
  }
}

class _Notice extends StatelessWidget {
  const new({required this.icon, required this.color, required this.text});

  final IconData icon;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: AppSpacing.xs,
    children: [
      Icon(icon, size: AppSizes.iconDefault, color: color),
      Expanded(child: Text(text, style: context.text.bodyMedium)),
    ],
  );
}

/// "Reused receipt" on a claim in the list.
class ReusedReceiptPill extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) => StatusPill(
    icon: Icons.content_copy_rounded,
    label: context.l10n.reusedReceipt,
    color: context.colors.dangerText,
  );
}

/// "Score 82" on a claim in the list.
class ClaimScorePill extends StatelessWidget {
  const new({required this.score, super.key});

  final int score;

  @override
  Widget build(BuildContext context) => StatusPill(
    icon: Icons.speed_rounded,
    label: context.l10n.claimScoreShort(score),
    color: context.colors.inkMuted,
  );
}
