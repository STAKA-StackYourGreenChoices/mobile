import 'package:material_ui/material_ui.dart';

import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/features/rewards/domain/reward.dart';

/// "Use 500 points for ₹200 off at Terra Threads?" True to go ahead.
Future<bool> showRedeemConfirmDialog(
  BuildContext context,
  Reward reward,
) async {
  final yes = await showDialog<bool>(
    context: context,
    builder: (context) => RedeemConfirmDialog(reward: reward),
  );
  return yes ?? false;
}

class RedeemConfirmDialog extends StatelessWidget {
  const new({required this.reward, super.key});

  final Reward reward;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      icon: const Icon(Icons.redeem_rounded),
      title: Text(l10n.rewardConfirmTitle),
      content: Text(
        l10n.rewardConfirmBody(
          l10n.pointsCount(reward.pointsCost),
          reward.valueText,
          reward.brandName,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.rewardConfirmYes),
        ),
      ],
    );
  }
}
