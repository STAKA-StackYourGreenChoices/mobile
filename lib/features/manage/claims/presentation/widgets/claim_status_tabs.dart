import 'package:material_ui/material_ui.dart';

import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/features/manage/claims/domain/models/claim.dart';
import 'package:staka/features/manage/claims/presentation/widgets/claim_labels.dart';
import 'package:staka/features/manage/shared/widgets/status_tabs.dart';

/// To review · Approved · Rejected, the selected one with its count (the
/// website's claim status tabs).
class ClaimStatusTabs extends StatelessWidget {
  const new({
    required this.selected,
    required this.onSelected,
    this.count,
    super.key,
  });

  final ClaimStatus selected;
  final ValueChanged<ClaimStatus> onSelected;

  /// How many claims the selected tab holds, once known.
  final int? count;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return StatusTabs<ClaimStatus>(
      values: ClaimStatus.values,
      labelOf: l10n.claimTabLabel,
      selected: selected,
      onSelected: onSelected,
      semanticsLabel: l10n.claimStatusLabel,
      count: count,
    );
  }
}
