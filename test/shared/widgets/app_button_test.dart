import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('calls onPressed when tapped', (tester) async {
    var taps = 0;
    await pumpThemed(
      tester,
      AppButton(label: 'Sign in', onPressed: () => taps++),
    );

    await tester.tap(find.text('Sign in'));

    expect(taps, 1);
  });

  testWidgets('while loading: shows the loading label and ignores taps', (
    tester,
  ) async {
    var taps = 0;
    await pumpThemed(
      tester,
      AppButton(
        label: 'Sign in',
        loadingLabel: 'Signing in…',
        isLoading: true,
        onPressed: () => taps++,
      ),
    );

    expect(find.text('Signing in…'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.tap(find.text('Signing in…'));
    expect(taps, 0);
  });

  testWidgets('every variant meets the 48 dp tap target', (tester) async {
    await pumpThemed(
      tester,
      Column(
        children: [
          for (final variant in AppButtonVariant.values)
            AppButton(label: variant.name, variant: variant, onPressed: () {}),
        ],
      ),
    );

    for (final variant in AppButtonVariant.values) {
      final button = tester.getSize(
        find.ancestor(
          of: find.text(variant.name),
          matching: find.byWidgetPredicate((w) => w is ButtonStyleButton),
        ),
      );
      expect(button.height, greaterThanOrEqualTo(48), reason: variant.name);
    }
  });

  testWidgets('isExpanded fills the width', (tester) async {
    usePhoneScreen(tester);
    await pumpThemed(
      tester,
      AppButton(label: 'Look up product', isExpanded: true, onPressed: () {}),
    );

    expect(tester.getSize(find.byType(FilledButton)).width, 360);
  });
}
