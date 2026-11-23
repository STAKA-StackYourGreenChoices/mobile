import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/error/error_mapper.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/models/brand_membership.dart';
import 'package:staka/core/state/request_state.dart';
import 'package:staka/features/brand_portal/domain/models/brand_member.dart';
import 'package:staka/features/brand_portal/presentation/state/brand_team_controllers.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';
import 'package:staka/shared/widgets/feedback/app_form_alert.dart';

/// Asks before taking [member] off the team. The dialog stays open to show
/// why the API refused (e.g. the last owner). True once removed.
Future<bool> showRemoveMemberDialog(
  BuildContext context, {
  required BrandMembership brand,
  required BrandMember member,
}) async {
  final container = ProviderScope.containerOf(context);
  final removed = await showDialog<bool>(
    context: context,
    builder: (_) => UncontrolledProviderScope(
      container: container,
      child: _RemoveMemberDialog(brand: brand, member: member),
    ),
  );
  container
      .read(
        brandMemberRemoveControllerProvider(brand.id, member.userId).notifier,
      )
      .reset();
  return removed ?? false;
}

class _RemoveMemberDialog extends ConsumerWidget {
  const new({required this.brand, required this.member});

  final BrandMembership brand;
  final BrandMember member;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final provider = brandMemberRemoveControllerProvider(
      brand.id,
      member.userId,
    );
    final request = ref.watch(provider);
    ref.listen(provider, (_, next) {
      if (next is RequestDone) Navigator.of(context).pop(true);
    });
    final isRemoving = request is RequestSending;
    final failure = request is RequestFailed ? request.failure : null;

    return AlertDialog(
      title: Text(l10n.removeMemberTitle(member.name)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.md,
        children: [
          Text(l10n.removeMemberBody(brand.name)),
          if (failure != null)
            AppFormAlert(
              message: messageForFailure(failure, l10n),
              tone: AlertTone.error,
            ),
        ],
      ),
      actions: [
        AppButton(
          label: l10n.cancel,
          variant: AppButtonVariant.ghost,
          onPressed: isRemoving ? null : () => Navigator.of(context).pop(false),
        ),
        AppButton(
          label: l10n.removeMember,
          loadingLabel: l10n.removingMember,
          variant: AppButtonVariant.destructive,
          isLoading: isRemoving,
          onPressed: failure != null
              ? null
              : ref.read(provider.notifier).remove,
        ),
      ],
    );
  }
}
