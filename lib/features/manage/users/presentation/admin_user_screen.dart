import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/app/routes.dart';
import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/error/error_mapper.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/rewards/points.dart';
import 'package:staka/core/state/request_state.dart';
import 'package:staka/features/manage/shared/widgets/admin_not_found.dart';
import 'package:staka/features/manage/users/data/admin_users_repository.dart';
import 'package:staka/features/manage/users/presentation/admin_users_controllers.dart';
import 'package:staka/features/manage/users/presentation/admin_users_screen.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';
import 'package:staka/shared/widgets/data_display/points_entry_row.dart';
import 'package:staka/shared/widgets/feedback/app_error_state.dart';
import 'package:staka/shared/widgets/feedback/app_form_alert.dart';
import 'package:staka/shared/widgets/feedback/app_loader.dart';
import 'package:staka/shared/widgets/feedback/app_snackbar.dart';
import 'package:staka/shared/widgets/inputs/app_text_field.dart';
import 'package:staka/shared/widgets/layout/app_scaffold.dart';

/// One shopper: balance, latest points and Adjust points.
class AdminUserScreen extends ConsumerWidget {
  const new({required this.userId, super.key});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final user = ref.watch(adminUserProvider(userId)).value;
    ref.listen(adjustPointsControllerProvider(userId), (_, next) {
      if (next is RequestDone) {
        AppSnackbar.show(context, message: l10n.pointsAdjustedDone);
      }
    });
    return AppScaffold(
      showAppBar: true,
      body: switch (user) {
        null => const Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl),
          child: AppLoader(),
        ),
        Err(failure: NotFoundFailure()) => AdminNotFound(
          backLabel: l10n.adminUsersTitle,
          onBackPressed: () => context.goNamed(AppRoute.adminUsers.name),
        ),
        Err(:final failure) => AppErrorState(
          failure: failure,
          onRetryPressed: () => ref.invalidate(adminUserProvider(userId)),
        ),
        Ok(:final value) => AdminUserView(
          user: value,
          points: ref.watch(adminUserPointsProvider(userId)).value,
          onAdjustPressed: () => showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            showDragHandle: true,
            builder: (_) => AdjustPointsSheet(user: value),
          ),
        ),
      },
    );
  }
}

class AdminUserView extends StatelessWidget {
  const new({
    required this.user,
    required this.points,
    required this.onAdjustPressed,
    super.key,
  });

  final AdminUser user;

  /// Null while loading.
  final Result<PointsPage>? points;
  final VoidCallback onAdjustPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.xs,
      children: [
        Semantics(
          header: true,
          child: Text(user.name, style: context.text.headingLarge),
        ),
        Text(
          userContact(user),
          style: context.text.bodyMedium.copyWith(color: colors.inkMuted),
        ),
        const SizedBox(height: AppSpacing.sm),
        Card(
          child: Padding(
            padding: AppSpacing.card,
            child: MergeSemantics(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.shopperBalanceLabel,
                    style: context.text.label.copyWith(color: colors.inkMuted),
                  ),
                  Text(
                    NumberFormat.decimalPattern().format(user.pointsBalance),
                    style: context.text.numericLarge,
                  ),
                ],
              ),
            ),
          ),
        ),
        AppButton(
          label: l10n.adjustPoints,
          icon: Icons.tune_rounded,
          variant: AppButtonVariant.secondary,
          isExpanded: true,
          onPressed: onAdjustPressed,
        ),
        const SizedBox(height: AppSpacing.md),
        Semantics(
          header: true,
          child: Text(l10n.latestPoints, style: context.text.headingSmall),
        ),
        switch (points) {
          null => const AppLoader(),
          Err(:final failure) => Text(
            messageForFailure(failure, l10n),
            style: context.text.bodyMedium,
          ),
          Ok(value: PointsPage(entries: [])) => Text(
            l10n.pointsHistoryEmptyTitle,
            style: context.text.bodyMedium.copyWith(color: colors.inkMuted),
          ),
          Ok(:final value) => Column(
            children: [
              for (final (index, entry) in value.entries.indexed) ...[
                if (index > 0) const Divider(height: 1),
                PointsEntryRow(entry: entry),
              ],
            ],
          ),
        },
      ],
    );
  }
}

/// Amount (+ or −) and why, then a confirm.
class AdjustPointsSheet extends ConsumerStatefulWidget {
  const new({required this.user, super.key});

  final AdminUser user;

  @override
  ConsumerState<AdjustPointsSheet> createState() => _AdjustPointsSheetState();
}

class _AdjustPointsSheetState extends ConsumerState<AdjustPointsSheet> {
  static const int maxChange = 100000;

  final _formKey = GlobalKey<FormState>();
  final _amount = TextEditingController();
  final _note = TextEditingController();
  bool _isTakingAway = false;

  @override
  void dispose() {
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final l10n = context.l10n;
    final amount = int.parse(_amount.text.trim());
    final delta = _isTakingAway ? -amount : amount;
    final yes = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.adjustPointsConfirmTitle),
        content: Text(
          _isTakingAway
              ? l10n.adjustPointsConfirmRemove(
                  l10n.pointsCount(amount),
                  widget.user.name,
                )
              : l10n.adjustPointsConfirmAdd(
                  l10n.pointsCount(amount),
                  widget.user.name,
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.adjustPoints),
          ),
        ],
      ),
    );
    if (yes != true || !mounted) return;
    await ref
        .read(adjustPointsControllerProvider(widget.user.id).notifier)
        .adjust(delta: delta, note: _note.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final provider = adjustPointsControllerProvider(widget.user.id);
    final adjust = ref.watch(provider);
    ref.listen(provider, (_, next) {
      if (next is RequestDone) Navigator.of(context).pop();
    });
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        bottom: MediaQuery.viewInsetsOf(context).bottom + AppSpacing.lg,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.md,
            children: [
              Text(l10n.adjustPoints, style: context.text.headingMedium),
              if (adjust case RequestFailed(:final failure))
                AppFormAlert(
                  message: messageForFailure(failure, l10n),
                  tone: AlertTone.error,
                ),
              SegmentedButton<bool>(
                segments: [
                  ButtonSegment(
                    value: false,
                    icon: const Icon(Icons.add_rounded),
                    label: Text(l10n.adjustAdd),
                  ),
                  ButtonSegment(
                    value: true,
                    icon: const Icon(Icons.remove_rounded),
                    label: Text(l10n.adjustRemove),
                  ),
                ],
                selected: {_isTakingAway},
                onSelectionChanged: (picked) =>
                    setState(() => _isTakingAway = picked.single),
              ),
              AppTextField(
                label: l10n.adjustAmountLabel,
                controller: _amount,
                validator: (text) =>
                    switch (int.tryParse((text ?? '').trim())) {
                      final n? when n >= 1 && n <= maxChange => null,
                      _ => l10n.pointsCostInvalid,
                    },
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
              ),
              AppTextField(
                label: l10n.adjustNoteLabel,
                controller: _note,
                helperText: l10n.adjustNoteHint,
                validator: (text) {
                  final length = (text ?? '').trim().length;
                  return length >= 3 && length <= 200
                      ? null
                      : l10n.adjustNoteInvalid;
                },
                inputFormatters: [LengthLimitingTextInputFormatter(200)],
                maxLines: 2,
              ),
              AppButton(
                label: l10n.adjustPoints,
                loadingLabel: l10n.saving,
                isLoading: adjust is RequestSending,
                isExpanded: true,
                onPressed: () => unawaited(_submit()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
