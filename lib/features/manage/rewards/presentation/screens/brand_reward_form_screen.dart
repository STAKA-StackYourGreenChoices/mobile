import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/app/routes.dart';
import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/error/error_mapper.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/state/request_state.dart';
import 'package:staka/core/time/clock.dart';
import 'package:staka/features/manage/products/presentation/widgets/form_switch_row.dart';
import 'package:staka/features/manage/rewards/domain/brand_reward.dart';
import 'package:staka/features/manage/rewards/presentation/state/brand_rewards_controllers.dart';
import 'package:staka/features/manage/shared/widgets/admin_not_found.dart';
import 'package:staka/shared/formatters/date_format.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';
import 'package:staka/shared/widgets/feedback/app_error_state.dart';
import 'package:staka/shared/widgets/feedback/app_form_alert.dart';
import 'package:staka/shared/widgets/feedback/app_loader.dart';
import 'package:staka/shared/widgets/feedback/app_snackbar.dart';
import 'package:staka/shared/widgets/inputs/app_text_field.dart';
import 'package:staka/shared/widgets/layout/app_scaffold.dart';

/// New reward (no [rewardId]) or Edit reward.
class BrandRewardFormScreen extends ConsumerWidget {
  const new({required this.brandId, this.rewardId, super.key});

  final String brandId;
  final String? rewardId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final id = rewardId;
    return AppScaffold(
      title: id == null ? l10n.newReward : l10n.editReward,
      body: switch (id) {
        null => BrandRewardForm(brandId: brandId),
        final id => switch (ref.watch(brandRewardProvider(brandId, id)).value) {
          null => const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl),
            child: AppLoader(),
          ),
          Err(failure: NotFoundFailure()) => AdminNotFound(
            backLabel: l10n.brandRewardsTitle,
            onBackPressed: () => context.goNamed(AppRoute.brandRewards.name),
          ),
          Err(:final failure) => AppErrorState(
            failure: failure,
            onRetryPressed: () =>
                ref.invalidate(brandRewardProvider(brandId, id)),
          ),
          Ok(:final value) => BrandRewardForm(brandId: brandId, reward: value),
        },
      },
    );
  }
}

/// The reward's fields; empty for a new one, filled from [reward] to edit.
class BrandRewardForm extends ConsumerStatefulWidget {
  const new({required this.brandId, this.reward, super.key});

  final String brandId;
  final BrandReward? reward;

  @override
  ConsumerState<BrandRewardForm> createState() => _BrandRewardFormState();
}

class _BrandRewardFormState extends ConsumerState<BrandRewardForm> {
  static const int maxPoints = 100000;

  final _formKey = GlobalKey<FormState>();
  late final _title = TextEditingController(text: widget.reward?.title);
  late final _value = TextEditingController(text: widget.reward?.valueText);
  late final _points = TextEditingController(
    text: widget.reward?.pointsCost.toString(),
  );
  late final _description = TextEditingController(
    text: widget.reward?.description,
  );
  late final _terms = TextEditingController(text: widget.reward?.terms);
  late DateTime _startsOn = _day(
    widget.reward?.startsAt ?? ref.read(clockProvider)(),
  );
  late DateTime? _endsOn = switch (widget.reward?.endsAt) {
    final ends? => _day(ends),
    null => null,
  };
  late bool _isActive = widget.reward?.isActive ?? true;
  String? _datesError;

  static DateTime _day(DateTime at) {
    final local = at.toLocal();
    return DateTime(local.year, local.month, local.day);
  }

  @override
  void dispose() {
    for (final controller in [_title, _value, _points, _description, _terms]) {
      controller.dispose();
    }
    super.dispose();
  }

  String? _optional(TextEditingController field) =>
      field.text.trim().isEmpty ? null : field.text.trim();

  Future<void> _pickDate({required bool isEnd}) async {
    final initial = isEnd ? (_endsOn ?? _startsOn) : _startsOn;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked == null || !mounted) return;
    setState(() {
      if (isEnd) {
        _endsOn = picked;
      } else {
        _startsOn = picked;
      }
      _datesError = null;
    });
  }

  Future<void> _save() async {
    final l10n = context.l10n;
    final fieldsOk = _formKey.currentState?.validate() ?? false;
    final ends = _endsOn;
    final datesOk = ends == null || ends.isAfter(_startsOn);
    setState(() => _datesError = datesOk ? null : l10n.endBeforeStart);
    if (!fieldsOk || !datesOk) return;
    await ref
        .read(
          brandRewardSaveControllerProvider(
            widget.brandId,
            widget.reward?.id,
          ).notifier,
        )
        .save(
          BrandRewardDraft(
            title: _title.text.trim(),
            valueText: _value.text.trim(),
            pointsCost: int.parse(_points.text.trim()),
            description: _optional(_description),
            terms: _optional(_terms),
            startsAt: _startsOn,
            // The whole last day counts.
            endsAt: switch (ends) {
              final ends? => DateTime(ends.year, ends.month, ends.day, 23, 59),
              null => null,
            },
            isActive: _isActive,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final provider = brandRewardSaveControllerProvider(
      widget.brandId,
      widget.reward?.id,
    );
    final save = ref.watch(provider);
    ref.listen(provider, (_, next) {
      if (next is! RequestDone<BrandReward>) return;
      AppSnackbar.show(
        context,
        message: widget.reward == null ? l10n.rewardCreated : l10n.changesSaved,
      );
      context.goNamed(
        AppRoute.brandReward.name,
        pathParameters: {'id': next.value.id},
      );
    });
    final failure = switch (save) {
      RequestFailed(:final failure) => failure,
      _ => null,
    };

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.lg - AppSpacing.xxs,
        children: [
          if (failure != null)
            AppFormAlert(
              message: messageForFailure(failure, l10n),
              tone: AlertTone.error,
            ),
          AppTextField(
            label: l10n.fieldRewardTitle,
            controller: _title,
            helperText: l10n.rewardTitleHint,
            validator: (text) =>
                (text ?? '').trim().isEmpty ? l10n.rewardTitleRequired : null,
            inputFormatters: [LengthLimitingTextInputFormatter(80)],
            textInputAction: TextInputAction.next,
          ),
          AppTextField(
            label: l10n.fieldRewardValue,
            controller: _value,
            helperText: l10n.rewardValueHint,
            validator: (text) =>
                (text ?? '').trim().isEmpty ? l10n.rewardValueRequired : null,
            inputFormatters: [LengthLimitingTextInputFormatter(40)],
            textInputAction: TextInputAction.next,
          ),
          AppTextField(
            label: l10n.fieldPointsCost,
            controller: _points,
            validator: (text) => switch (int.tryParse((text ?? '').trim())) {
              final points? when points >= 1 && points <= maxPoints => null,
              _ => l10n.pointsCostInvalid,
            },
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
            textInputAction: TextInputAction.next,
          ),
          AppTextField(
            label: l10n.fieldRewardDescription,
            controller: _description,
            helperText: l10n.optionalHint,
            inputFormatters: [LengthLimitingTextInputFormatter(500)],
            keyboardType: TextInputType.multiline,
            maxLines: 3,
          ),
          AppTextField(
            label: l10n.fieldRewardTerms,
            controller: _terms,
            helperText: l10n.rewardTermsHint,
            inputFormatters: [LengthLimitingTextInputFormatter(1000)],
            keyboardType: TextInputType.multiline,
            maxLines: 4,
          ),
          _DateField(
            label: l10n.fieldStartsOn,
            value: formatDate(_startsOn),
            onPressed: () => _pickDate(isEnd: false),
          ),
          _DateField(
            label: l10n.fieldEndsOn,
            value: switch (_endsOn) {
              final ends? => formatDate(ends),
              null => l10n.noEndDate,
            },
            errorText: _datesError,
            onPressed: () => _pickDate(isEnd: true),
            onClearPressed: _endsOn == null
                ? null
                : () => setState(() {
                    _endsOn = null;
                    _datesError = null;
                  }),
          ),
          FormSwitchRow(
            label: l10n.rewardActiveLabel,
            description: l10n.rewardActiveDescription,
            value: _isActive,
            onChanged: (value) => setState(() => _isActive = value),
          ),
          const SizedBox(height: AppSpacing.xs),
          AppButton(
            label: widget.reward == null ? l10n.newReward : l10n.saveChanges,
            loadingLabel: l10n.saving,
            isLoading: save is RequestSending,
            isExpanded: true,
            onPressed: _save,
          ),
        ],
      ),
    );
  }
}

/// A date shown like a text field; tapping opens the calendar.
class _DateField extends StatelessWidget {
  const new({
    required this.label,
    required this.value,
    required this.onPressed,
    this.errorText,
    this.onClearPressed,
  });

  final String label;
  final String value;
  final String? errorText;
  final VoidCallback onPressed;
  final VoidCallback? onClearPressed;

  @override
  Widget build(BuildContext context) {
    // Label above the box, like `AppTextField`.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.xs,
      children: [
        Text(label, style: context.text.label),
        Semantics(
          button: true,
          label: label,
          child: InkWell(
            onTap: onPressed,
            borderRadius: AppRadius.allSm,
            child: InputDecorator(
              decoration: InputDecoration(
                errorText: errorText,
                errorMaxLines: 3,
                prefixIcon: const Icon(Icons.calendar_today_outlined),
                suffixIcon: switch (onClearPressed) {
                  final clear? => IconButton(
                    tooltip: context.l10n.clearEndDate,
                    icon: const Icon(Icons.close_rounded),
                    onPressed: clear,
                  ),
                  null => null,
                },
              ),
              child: Text(value, style: context.text.bodyLarge),
            ),
          ),
        ),
      ],
    );
  }
}
