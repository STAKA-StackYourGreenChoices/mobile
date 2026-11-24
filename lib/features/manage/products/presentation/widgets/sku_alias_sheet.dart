import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/error/error_mapper.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/state/request_state.dart';
import 'package:staka/features/manage/products/domain/models/sku_alias.dart';
import 'package:staka/features/manage/products/presentation/state/sku_alias_controller.dart';
import 'package:staka/features/manage/shared/manage_scope.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';
import 'package:staka/shared/widgets/feedback/app_form_alert.dart';
import 'package:staka/shared/widgets/inputs/app_text_field.dart';

/// "Other shop codes" for one saved size/colour (V2-2): the codes other
/// shops use for it, each removable, and a shop + code pair to add. Each
/// change is saved at once; [onChanged] gets the list after each one.
Future<void> showSkuAliasSheet(
  BuildContext context, {
  required ManageScope scope,
  required String productId,
  required String variantId,
  required String variantName,
  required List<SkuAlias> aliases,
  required ValueChanged<List<SkuAlias>> onChanged,
}) {
  final container = ProviderScope.containerOf(context);
  return showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    builder: (_) => UncontrolledProviderScope(
      container: container,
      child: _SkuAliasSheet(
        scope: scope,
        productId: productId,
        variantId: variantId,
        variantName: variantName,
        aliases: aliases,
        onChanged: onChanged,
      ),
    ),
  );
}

class _SkuAliasSheet extends ConsumerStatefulWidget {
  const new({
    required this.scope,
    required this.productId,
    required this.variantId,
    required this.variantName,
    required this.aliases,
    required this.onChanged,
  });

  final ManageScope scope;
  final String productId;
  final String variantId;
  final String variantName;
  final List<SkuAlias> aliases;
  final ValueChanged<List<SkuAlias>> onChanged;

  @override
  ConsumerState<_SkuAliasSheet> createState() => _SkuAliasSheetState();
}

class _SkuAliasSheetState extends ConsumerState<_SkuAliasSheet> {
  final _formKey = GlobalKey<FormState>();
  final _source = TextEditingController();
  final _code = TextEditingController();
  late List<SkuAlias> _aliases = [...widget.aliases];

  SkuAliasControllerProvider get _provider => skuAliasControllerProvider(
    widget.scope,
    widget.productId,
    widget.variantId,
  );

  @override
  void dispose() {
    _source.dispose();
    _code.dispose();
    super.dispose();
  }

  void _changed(List<SkuAlias> aliases) {
    setState(() => _aliases = aliases);
    widget.onChanged(aliases);
  }

  Future<void> _add() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final alias = SkuAlias(
      source: _source.text.trim(),
      code: _code.text.trim(),
    );
    final added = await ref.read(_provider.notifier).add(alias);
    if (!added || !mounted) return;
    _source.clear();
    _code.clear();
    _changed([..._aliases, alias]);
  }

  Future<void> _remove(SkuAlias alias) async {
    final removed = await ref.read(_provider.notifier).remove(alias);
    if (!removed || !mounted) return;
    _changed([..._aliases]..remove(alias));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final request = ref.watch(_provider);
    final isSending = request is RequestSending;
    final muted = context.text.bodyMedium.copyWith(
      color: context.colors.inkMuted,
    );
    String? required(String? value, String message) =>
        (value ?? '').trim().isEmpty ? message : null;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.md,
            children: [
              Semantics(
                header: true,
                child: Text(
                  l10n.otherShopCodesTitle,
                  style: context.text.headingMedium,
                ),
              ),
              Text(l10n.otherShopCodesBody(widget.variantName), style: muted),
              if (request case RequestFailed(:final failure))
                AppFormAlert(
                  message: messageForFailure(failure, l10n),
                  tone: AlertTone.error,
                ),
              // Read out when a code is added or removed.
              Semantics(
                liveRegion: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_aliases.isEmpty)
                      Text(l10n.noAliases, style: muted)
                    else
                      for (final alias in _aliases)
                        _AliasRow(
                          alias: alias,
                          onRemovePressed: isSending
                              ? null
                              : () => _remove(alias),
                        ),
                  ],
                ),
              ),
              const Divider(),
              AppTextField(
                label: l10n.aliasSource,
                controller: _source,
                hint: l10n.aliasSourceHint,
                validator: (value) =>
                    required(value, l10n.validationAliasSource),
                inputFormatters: [LengthLimitingTextInputFormatter(100)],
                textInputAction: TextInputAction.next,
              ),
              AppTextField(
                label: l10n.aliasCode,
                controller: _code,
                validator: (value) => required(value, l10n.validationAliasCode),
                inputFormatters: [LengthLimitingTextInputFormatter(64)],
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _add(),
              ),
              AppButton(
                label: l10n.addAlias,
                loadingLabel: l10n.addingAlias,
                icon: Icons.add_rounded,
                isLoading: isSending,
                isExpanded: true,
                onPressed: _add,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AliasRow extends StatelessWidget {
  const new({required this.alias, required this.onRemovePressed});

  final SkuAlias alias;
  final VoidCallback? onRemovePressed;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(alias.code, style: context.text.bodyLarge),
            Text(
              alias.source,
              style: context.text.bodySmall.copyWith(
                color: context.colors.inkMuted,
              ),
            ),
          ],
        ),
      ),
      IconButton(
        tooltip: context.l10n.removeAliasLabel(alias.source, alias.code),
        onPressed: onRemovePressed,
        icon: const Icon(Icons.close_rounded),
      ),
    ],
  );
}
