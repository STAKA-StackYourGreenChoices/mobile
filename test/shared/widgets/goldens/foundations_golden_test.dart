@Tags(['golden'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';
import 'package:staka/shared/widgets/feedback/app_empty_state.dart';
import 'package:staka/shared/widgets/feedback/app_error_state.dart';
import 'package:staka/shared/widgets/feedback/app_loader.dart';

import '../../../helpers/golden.dart';
import '../../../helpers/pump_app.dart';

class _Buttons extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => Padding(
    padding: AppSpacing.card,
    child: Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: [
        AppButton(
          label: 'Add to wardrobe',
          icon: Icons.add_rounded,
          onPressed: () {},
        ),
        AppButton(
          label: 'View your tag',
          variant: AppButtonVariant.secondary,
          onPressed: () {},
        ),
        AppButton(
          label: 'Turn camera off',
          variant: AppButtonVariant.ghost,
          onPressed: () {},
        ),
        AppButton(
          label: 'Delete brand',
          variant: AppButtonVariant.destructive,
          onPressed: () {},
        ),
        AppButton(
          label: 'Sign in',
          loadingLabel: 'Signing in…',
          isLoading: true,
          onPressed: () {},
        ),
        const AppButton(label: 'Send for review', onPressed: null),
      ],
    ),
  );
}

class _States extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: AppSpacing.screenH,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppLoader(),
        AppEmptyState(
          icon: Icons.qr_code_scanner_rounded,
          title: 'Your wardrobe is empty',
          message: 'Point your camera at the barcode on a clothing label.',
          actionLabel: 'Scan your first piece',
          onActionPressed: () {},
        ),
        AppErrorState(failure: const NetworkFailure(), onRetryPressed: () {}),
      ],
    ),
  );
}

void main() {
  setUpAll(loadAppFonts);

  for (final brightness in Brightness.values) {
    testWidgets('buttons, ${brightness.name}', (tester) async {
      usePhoneScreen(tester, height: 300);
      await pumpThemed(tester, const _Buttons(), brightness: brightness);
      // Past the spinner's first frame, so its arc is visible.
      await tester.pump(const Duration(milliseconds: 300));
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('buttons_${brightness.name}.png'),
      );
    });

    testWidgets('feedback states, ${brightness.name}', (tester) async {
      usePhoneScreen(tester, height: 760);
      await pumpThemed(tester, const _States(), brightness: brightness);
      await tester.pump(const Duration(milliseconds: 300));
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('feedback_${brightness.name}.png'),
      );
    });
  }
}
