import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/shared/widgets/feedback/app_form_alert.dart';
import 'package:staka/shared/widgets/feedback/app_snackbar.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('form alert: icon and message, announced when it appears', (
    tester,
  ) async {
    await pumpThemed(
      tester,
      const AppFormAlert(
        message: "That email and password don't match an account.",
        tone: AlertTone.error,
      ),
    );

    expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);
    final semantics = tester.widget<Semantics>(
      find
          .ancestor(
            of: find.text("That email and password don't match an account."),
            matching: find.byType(Semantics),
          )
          .first,
    );
    expect(semantics.properties.liveRegion, isTrue);
  });

  testWidgets('snackbar shows the message with a tone icon', (tester) async {
    await pumpThemed(
      tester,
      Builder(
        builder: (context) => TextButton(
          onPressed: () =>
              AppSnackbar.show(context, message: 'Sharing turned off.'),
          child: const Text('go'),
        ),
      ),
    );

    await tester.tap(find.text('go'));
    await tester.pump();

    expect(find.text('Sharing turned off.'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle_outline_rounded), findsOneWidget);
  });
}
