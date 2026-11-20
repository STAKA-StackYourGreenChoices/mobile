import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/utils/scan_parser.dart';
import 'package:staka/features/scan/presentation/scan_messages.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';
import 'package:staka/shared/widgets/inputs/app_text_field.dart';

/// "Type the number instead": the same parsing and messages as the camera,
/// for when it can't read a label or isn't allowed — the website's form.
class TypeNumberForm extends StatefulWidget {
  const new({required this.onGtinFound, super.key});

  final ValueChanged<String> onGtinFound;

  @override
  State<TypeNumberForm> createState() => _TypeNumberFormState();
}

class _TypeNumberFormState extends State<TypeNumberForm> {
  final _code = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  void _submit() {
    switch (parseScan(_code.text)) {
      case ScanGtin(:final gtin):
        setState(() => _error = null);
        widget.onGtinFound(gtin);
      case final ScanRejected rejected:
        setState(() => _error = scanRejectionMessage(rejected, context.l10n));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Card(
      child: Padding(
        padding: AppSpacing.card,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.md,
          children: [
            Semantics(
              header: true,
              child: Row(
                spacing: AppSpacing.xs,
                children: [
                  Icon(
                    Icons.keyboard_outlined,
                    size: AppSizes.iconInline,
                    color: context.colors.inkMuted,
                  ),
                  Expanded(
                    child: Text(
                      l10n.typeNumberTitle,
                      style: context.text.headingSmall,
                    ),
                  ),
                ],
              ),
            ),
            AppTextField(
              label: l10n.barcodeNumberLabel,
              hint: l10n.barcodeNumberHint,
              helperText: _error == null ? l10n.barcodeNumberHelp : null,
              errorText: _error,
              controller: _code,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _submit(),
            ),
            AppButton(
              label: l10n.lookUpProduct,
              isExpanded: true,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
