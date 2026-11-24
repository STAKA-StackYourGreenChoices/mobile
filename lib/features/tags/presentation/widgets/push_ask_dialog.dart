import 'package:material_ui/material_ui.dart';

import 'package:staka/core/l10n/l10n.dart';

/// After the first receipt (V2-9): explains why before Android asks. True
/// when the person wants notifications.
Future<bool> showPushAskDialog(BuildContext context) async {
  final yes = await showDialog<bool>(
    context: context,
    builder: (context) {
      final l10n = context.l10n;
      return AlertDialog(
        icon: const Icon(Icons.notifications_active_outlined),
        title: Text(l10n.pushAskTitle),
        content: Text(l10n.pushAskBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.notNow),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.pushAskYes),
          ),
        ],
      );
    },
  );
  return yes ?? false;
}
