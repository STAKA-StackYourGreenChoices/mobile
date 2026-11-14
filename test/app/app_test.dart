import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/app/app.dart';
import 'package:staka/core/design/app_colors.dart';
import 'package:staka/core/design/app_typography.dart';

void main() {
  testWidgets('boots with localised copy and both theme extensions', (
    tester,
  ) async {
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    expect(find.text('STAKA'), findsOneWidget);
    expect(
      find.text('Your clothes, with their footprint attached.'),
      findsOneWidget,
    );

    final theme = Theme.of(tester.element(find.text('STAKA')));
    expect(theme.extension<AppColors>(), isNotNull);
    expect(theme.extension<AppTypography>(), isNotNull);
  });

  testWidgets('uses the dark tokens when the platform is dark', (tester) async {
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);

    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    final theme = Theme.of(tester.element(find.text('STAKA')));
    expect(
      theme.extension<AppColors>()!.surfaceBase,
      AppColors.dark.surfaceBase,
    );
  });
}
