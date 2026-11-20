@Tags(['golden'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/shared/widgets/feedback/app_form_alert.dart';
import 'package:staka/shared/widgets/inputs/app_text_field.dart';

import '../../../helpers/golden.dart';
import '../../../helpers/pump_app.dart';

class _Form extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => const Padding(
    padding: AppSpacing.screenH,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.md,
      children: [
        SizedBox(height: AppSpacing.xs),
        AppFormAlert(
          message:
              "That email and password don't match an account. "
              'Check them and try again.',
          tone: AlertTone.error,
        ),
        AppFormAlert(
          message: 'Password changed. Sign in with your new password.',
          tone: AlertTone.success,
        ),
        AppTextField(label: 'Email', hint: 'name@example.com'),
        AppTextField(label: 'Password', isPassword: true),
        AppTextField(label: 'Name', errorText: 'Enter your name'),
        AppTextField(
          label: 'Barcode number',
          hint: 'e.g. 8901234500019',
          helperText: 'The digits printed under the bars.',
          isEnabled: false,
        ),
      ],
    ),
  );
}

void main() {
  setUpAll(loadAppFonts);

  for (final brightness in Brightness.values) {
    testWidgets('form inputs, ${brightness.name}', (tester) async {
      usePhoneScreen(tester, height: 720);
      await pumpThemed(tester, const _Form(), brightness: brightness);
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('inputs_${brightness.name}.png'),
      );
    });
  }
}
