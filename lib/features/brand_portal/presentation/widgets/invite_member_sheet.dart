import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/error/error_mapper.dart';
import 'package:staka/core/forms/validators.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/models/brand_membership.dart';
import 'package:staka/core/state/request_state.dart';
import 'package:staka/core/utils/phone_number.dart';
import 'package:staka/features/brand_portal/presentation/state/brand_team_controllers.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';
import 'package:staka/shared/widgets/feedback/app_form_alert.dart';
import 'package:staka/shared/widgets/inputs/app_text_field.dart';

/// Owners invite someone to [brand] by email or mobile number, as staff or
/// owner. Returns who was invited (as typed), or null if closed.
Future<String?> showInviteMemberSheet(
  BuildContext context, {
  required BrandMembership brand,
}) async {
  final container = ProviderScope.containerOf(context);
  final invited = await showModalBottomSheet<String>(
    context: context,
    // Over the whole app, like dialogs: the tab bar is covered too.
    useRootNavigator: true,
    isScrollControlled: true,
    builder: (_) => UncontrolledProviderScope(
      container: container,
      child: _InviteMemberSheet(brand: brand),
    ),
  );
  container.read(brandInviteControllerProvider(brand.id).notifier).reset();
  return invited;
}

class _InviteMemberSheet extends ConsumerStatefulWidget {
  const new({required this.brand});

  final BrandMembership brand;

  @override
  ConsumerState<_InviteMemberSheet> createState() => _InviteMemberSheetState();
}

class _InviteMemberSheetState extends ConsumerState<_InviteMemberSheet> {
  final _formKey = GlobalKey<FormState>();
  final _who = TextEditingController();
  BrandRole _role = BrandRole.staff;

  @override
  void dispose() {
    _who.dispose();
    super.dispose();
  }

  /// An email as typed (trimmed), or a number in E.164; null for neither.
  static String? _emailOrPhone(String input, Validators rules) {
    final text = input.trim();
    if (rules.email(text) == null) return text;
    return PhoneNumber.toE164(text);
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final who = _emailOrPhone(_who.text, Validators(context.l10n));
    if (who == null) return;
    await ref
        .read(brandInviteControllerProvider(widget.brand.id).notifier)
        .invite(emailOrPhone: who, role: _role);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final rules = Validators(l10n);
    final provider = brandInviteControllerProvider(widget.brand.id);
    final request = ref.watch(provider);
    ref.listen(provider, (_, next) {
      if (next is RequestDone) Navigator.of(context).pop(_who.text.trim());
    });
    final failure = request is RequestFailed ? request.failure : null;
    final muted = context.text.bodySmall.copyWith(
      color: context.colors.inkMuted,
    );

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
                    l10n.inviteTitle(widget.brand.name),
                    style: context.text.headingMedium,
                  ),
                ),
                Text(l10n.inviteBody, style: muted),
                if (failure != null)
                  AppFormAlert(
                    message: messageForFailure(failure, l10n),
                    tone: AlertTone.error,
                  ),
                AppTextField(
                  label: l10n.fieldEmailOrPhone,
                  controller: _who,
                  validator: (value) =>
                      _emailOrPhone(value ?? '', rules) == null
                      ? l10n.validationEmailOrPhone
                      : null,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _submit(),
                ),
                Text(l10n.inviteRole, style: context.text.label),
                RadioGroup<BrandRole>(
                  groupValue: _role,
                  onChanged: (role) {
                    if (role != null) setState(() => _role = role);
                  },
                  child: Column(
                    children: [
                      for (final (role, label, hint) in [
                        (
                          BrandRole.staff,
                          l10n.brandRoleStaff,
                          l10n.roleStaffHint,
                        ),
                        (
                          BrandRole.owner,
                          l10n.brandRoleOwner,
                          l10n.roleOwnerHint,
                        ),
                      ])
                        RadioListTile<BrandRole>(
                          value: role,
                          contentPadding: EdgeInsets.zero,
                          title: Text(label),
                          subtitle: Text(hint, style: muted),
                        ),
                    ],
                  ),
                ),
                AppButton(
                  label: l10n.sendInvite,
                  loadingLabel: l10n.sendingInvite,
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
                      : () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
