import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/error/error_mapper.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/state/request_state.dart';
import 'package:staka/core/utils/phone_number.dart';
import 'package:staka/features/account/presentation/state/sign_in_method_controllers.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';
import 'package:staka/shared/widgets/feedback/app_form_alert.dart';

/// Asks before removing [phone]. Stays open to show why the API refused.
/// True once the number is removed.
Future<bool> showRemovePhoneDialog(
  BuildContext context, {
  required String phone,
}) async {
  final container = ProviderScope.containerOf(context);
  final removed = await showDialog<bool>(
    context: context,
    builder: (_) => UncontrolledProviderScope(
      container: container,
      child: _RemovePhoneDialog(phone: phone),
    ),
  );
  return removed ?? false;
}

class _RemovePhoneDialog extends ConsumerWidget {
  const new({required this.phone});

  final String phone;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final request = ref.watch(removePhoneControllerProvider);
    ref.listen(removePhoneControllerProvider, (_, next) {
      if (next is RequestDone) Navigator.of(context).pop(true);
    });
    final isRemoving = request is RequestSending;
    final failure = request is RequestFailed ? request.failure : null;

    return AlertDialog(
      title: Text(l10n.accountPhoneRemoveTitle(PhoneNumber.display(phone))),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.md,
        children: [
          Text(l10n.accountPhoneRemoveBody),
          if (failure != null)
            AppFormAlert(
              message: messageForFailure(failure, l10n),
              tone: AlertTone.error,
            ),
        ],
      ),
      actions: [
        AppButton(
          label: l10n.keepNumber,
          variant: AppButtonVariant.ghost,
          onPressed: isRemoving ? null : () => Navigator.of(context).pop(false),
        ),
        AppButton(
          label: l10n.accountPhoneRemove,
          loadingLabel: l10n.removing,
          variant: AppButtonVariant.destructive,
          isLoading: isRemoving,
          onPressed: failure != null
              ? null
              : ref.read(removePhoneControllerProvider.notifier).submit,
        ),
      ],
    );
  }
}
