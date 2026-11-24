import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/shared/widgets/data_display/status_pill.dart';

/// "Disputed by the shopper": they asked STAKA to look again at this
/// claim and STAKA hasn't answered yet.
class DisputedPill extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) => StatusPill(
    icon: Icons.balance_outlined,
    label: context.l10n.disputedByShopper,
    color: context.colors.warning,
  );
}
