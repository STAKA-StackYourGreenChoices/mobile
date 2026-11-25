import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/error/error_mapper.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/rewards/points.dart';
import 'package:staka/core/state/request_state.dart';
import 'package:staka/features/manage/products/presentation/widgets/form_switch_row.dart';
import 'package:staka/features/manage/rewards/data/admin_rewards_repository.dart';
import 'package:staka/features/manage/rewards/presentation/state/admin_rewards_controllers.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';
import 'package:staka/shared/widgets/data_display/points_entry_row.dart';
import 'package:staka/shared/widgets/data_display/status_pill.dart';
import 'package:staka/shared/widgets/feedback/app_error_state.dart';
import 'package:staka/shared/widgets/feedback/app_form_alert.dart';
import 'package:staka/shared/widgets/feedback/app_loader.dart';
import 'package:staka/shared/widgets/feedback/app_snackbar.dart';
import 'package:staka/shared/widgets/inputs/app_text_field.dart';
import 'package:staka/shared/widgets/layout/app_scaffold.dart';

/// Admin → Reward rules (V2-6): points per action and daily caps; each
/// edited in a sheet.
class RewardRulesScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppScaffold(
      title: context.l10n.rewardRulesTitle,
      isScrollable: false,
      body: RewardRulesView(
        rules: ref.watch(rewardRulesProvider).value,
        onRetry: () => ref.invalidate(rewardRulesProvider),
        onRulePressed: (rule) => showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          showDragHandle: true,
          builder: (_) => RuleEditSheet(rule: rule),
        ),
      ),
    );
  }
}

/// A rule's name: the shopper's wording for the known ones.
String ruleLabel(RewardRule rule, AppLocalizations l10n) =>
    rule.reason == PointsReason.other
    ? rule.key
    : earnRuleText(rule.reason, l10n);

class RewardRulesView extends StatelessWidget {
  const new({
    required this.rules,
    required this.onRetry,
    required this.onRulePressed,
    super.key,
  });

  final Result<List<RewardRule>>? rules;
  final VoidCallback onRetry;
  final ValueChanged<RewardRule> onRulePressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return ListView(
      children: [
        Text(
          l10n.rewardRulesDescription,
          style: context.text.bodyLarge.copyWith(color: colors.inkMuted),
        ),
        const SizedBox(height: AppSpacing.md),
        switch (rules) {
          null => const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl),
            child: AppLoader(),
          ),
          Err(:final failure) => AppErrorState(
            failure: failure,
            onRetryPressed: onRetry,
          ),
          Ok(:final value) => Column(
            children: [
              for (final (index, rule) in value.indexed) ...[
                if (index > 0) const Divider(height: 1),
                InkWell(
                  onTap: () => onRulePressed(rule),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 64),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.sm,
                      ),
                      child: Row(
                        spacing: AppSpacing.sm,
                        children: [
                          Icon(pointsIcon(rule.reason), color: colors.inkMuted),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: AppSpacing.xxs,
                              children: [
                                Text(
                                  ruleLabel(rule, l10n),
                                  style: context.text.bodyLarge,
                                ),
                                Text(
                                  [
                                    '+${l10n.pointsCount(rule.points)}',
                                    if (rule.dailyCap case final cap?)
                                      l10n.earnDailyCap(cap),
                                  ].join(' · '),
                                  style: context.text.bodySmall.copyWith(
                                    color: colors.inkMuted,
                                  ),
                                ),
                                if (!rule.isActive)
                                  StatusPill(
                                    icon: Icons.pause_circle_outline_rounded,
                                    label: l10n.rewardStatusOff,
                                    color: colors.inkMuted,
                                  ),
                              ],
                            ),
                          ),
                          Icon(Icons.edit_outlined, color: colors.inkMuted),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        },
      ],
    );
  }
}

/// Points, daily cap and on/off for one rule.
class RuleEditSheet extends ConsumerStatefulWidget {
  const new({required this.rule, super.key});

  final RewardRule rule;

  @override
  ConsumerState<RuleEditSheet> createState() => _RuleEditSheetState();
}

class _RuleEditSheetState extends ConsumerState<RuleEditSheet> {
  final _formKey = GlobalKey<FormState>();
  late final _points = TextEditingController(
    text: widget.rule.points.toString(),
  );
  late final _cap = TextEditingController(
    text: widget.rule.dailyCap?.toString(),
  );
  late bool _isActive = widget.rule.isActive;

  @override
  void dispose() {
    _points.dispose();
    _cap.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await ref
        .read(ruleSaveControllerProvider(widget.rule.key).notifier)
        .save(
          RewardRule(
            key: widget.rule.key,
            points: int.parse(_points.text.trim()),
            dailyCap: int.tryParse(_cap.text.trim()),
            isActive: _isActive,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final provider = ruleSaveControllerProvider(widget.rule.key);
    final save = ref.watch(provider);
    ref.listen(provider, (_, next) {
      if (next is! RequestDone<RewardRule>) return;
      // While the sheet's context is still mounted.
      AppSnackbar.show(context, message: l10n.changesSaved);
      Navigator.of(context).pop();
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
              Text(
                ruleLabel(widget.rule, l10n),
                style: context.text.headingMedium,
              ),
              if (save case RequestFailed(:final failure))
                AppFormAlert(
                  message: messageForFailure(failure, l10n),
                  tone: AlertTone.error,
                ),
              AppTextField(
                label: l10n.rulePointsLabel,
                controller: _points,
                validator: (text) =>
                    switch (int.tryParse((text ?? '').trim())) {
                      final points? when points >= 0 && points <= 1000 => null,
                      _ => l10n.rulePointsInvalid,
                    },
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
              ),
              AppTextField(
                label: l10n.ruleDailyCapLabel,
                controller: _cap,
                helperText: l10n.ruleDailyCapHint,
                validator: (text) {
                  final value = (text ?? '').trim();
                  if (value.isEmpty) return null;
                  final cap = int.tryParse(value);
                  return cap != null && cap >= 1 ? null : l10n.ruleCapInvalid;
                },
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(5),
                ],
              ),
              FormSwitchRow(
                label: l10n.ruleActiveLabel,
                value: _isActive,
                onChanged: (value) => setState(() => _isActive = value),
              ),
              AppButton(
                label: l10n.saveChanges,
                loadingLabel: l10n.saving,
                isLoading: save is RequestSending,
                isExpanded: true,
                onPressed: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
