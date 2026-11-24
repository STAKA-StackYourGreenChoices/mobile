import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/error/error_mapper.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/models/digital_card.dart';
import 'package:staka/core/state/request_state.dart';
import 'package:staka/features/tags/presentation/state/look_again_controller.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';
import 'package:staka/shared/widgets/feedback/app_form_alert.dart';
import 'package:staka/shared/widgets/inputs/app_text_field.dart';

/// "Ask STAKA to look again" at the brand's rejection of [card]'s receipt.
/// True once the request was sent.
Future<bool> showLookAgainSheet(
  BuildContext context, {
  required DigitalCard card,
}) async {
  final container = ProviderScope.containerOf(context);
  final sent = await showModalBottomSheet<bool>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    builder: (_) => UncontrolledProviderScope(
      container: container,
      child: _LookAgainSheet(card: card),
    ),
  );
  container.read(lookAgainControllerProvider(card.id).notifier).reset();
  return sent ?? false;
}

class _LookAgainSheet extends ConsumerStatefulWidget {
  const new({required this.card});

  final DigitalCard card;

  @override
  ConsumerState<_LookAgainSheet> createState() => _LookAgainSheetState();
}

class _LookAgainSheetState extends ConsumerState<_LookAgainSheet> {
  final _formKey = GlobalKey<FormState>();
  final _message = TextEditingController();

  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await ref
        .read(lookAgainControllerProvider(widget.card.id).notifier)
        .send(_message.text);
  }

  String? _validate(String? value) {
    final l10n = context.l10n;
    final length = (value ?? '').trim().length;
    if (length < LookAgainController.minLength) {
      return l10n.validationLookAgainShort;
    }
    if (length > LookAgainController.maxLength) {
      return l10n.validationLookAgainLong;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final provider = lookAgainControllerProvider(widget.card.id);
    final request = ref.watch(provider);
    ref.listen(provider, (_, next) {
      if (next is RequestDone) Navigator.of(context).pop(true);
    });
    final failure = request is RequestFailed ? request.failure : null;
    final ownership = widget.card.ownership;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: AppSpacing.md,
              children: [
                Semantics(
                  header: true,
                  child: Text(
                    l10n.askStakaToLookAgain,
                    style: context.text.headingMedium,
                  ),
                ),
                Text(
                  l10n.lookAgainSheetBody(
                    widget.card.product.name,
                    ownership.brandName ?? l10n.theBrand,
                  ),
                  style: context.text.bodySmall.copyWith(
                    color: context.colors.inkMuted,
                  ),
                ),
                if (failure != null)
                  AppFormAlert(
                    message: messageForFailure(failure, l10n),
                    tone: AlertTone.error,
                  ),
                AppTextField(
                  label: l10n.fieldLookAgainMessage,
                  controller: _message,
                  helperText: l10n.lookAgainHelper,
                  validator: _validate,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  maxLines: 5,
                ),
                AppButton(
                  label: l10n.sendToStaka,
                  loadingLabel: l10n.sendingToStaka,
                  isLoading: request is RequestSending,
                  isExpanded: true,
                  onPressed: _submit,
                ),
                AppButton(
                  label: l10n.cancel,
                  variant: AppButtonVariant.ghost,
                  isExpanded: true,
                  onPressed: request is RequestSending
                      ? null
                      : () => Navigator.of(context).pop(false),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
