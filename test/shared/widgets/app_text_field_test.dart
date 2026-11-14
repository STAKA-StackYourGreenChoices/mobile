import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/shared/widgets/inputs/app_text_field.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('shows label, hint and helper text', (tester) async {
    await pumpThemed(
      tester,
      const AppTextField(
        label: 'Barcode number',
        hint: 'e.g. 8901234500019',
        helperText: 'The digits printed under the bars.',
      ),
    );

    expect(find.text('Barcode number'), findsOneWidget);
    expect(find.text('e.g. 8901234500019'), findsOneWidget);
    expect(find.text('The digits printed under the bars.'), findsOneWidget);
  });

  testWidgets('screen readers announce the field by its label', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpThemed(tester, const AppTextField(label: 'Email'));

    expect(
      tester.getSemantics(find.bySemanticsLabel('Email')),
      isSemantics(label: 'Email', isTextField: true),
    );
    handle.dispose();
  });

  testWidgets('validator errors appear after the form validates', (
    tester,
  ) async {
    final form = GlobalKey<FormState>();
    await pumpThemed(
      tester,
      Form(
        key: form,
        child: AppTextField(
          label: 'Email',
          validator: (value) => value!.isEmpty ? 'Enter an email' : null,
        ),
      ),
    );

    expect(find.text('Enter an email'), findsNothing);
    form.currentState!.validate();
    await tester.pump();
    expect(find.text('Enter an email'), findsOneWidget);
  });

  testWidgets('a server error is shown without validating', (tester) async {
    await pumpThemed(
      tester,
      const AppTextField(
        label: 'Email',
        errorText: 'An account already uses this email. Sign in instead.',
      ),
    );

    expect(
      find.text('An account already uses this email. Sign in instead.'),
      findsOneWidget,
    );
  });

  testWidgets('password fields hide the text until toggled', (tester) async {
    await pumpThemed(
      tester,
      const AppTextField(label: 'Password', isPassword: true),
    );

    bool obscured() =>
        tester.widget<EditableText>(find.byType(EditableText)).obscureText;

    expect(obscured(), isTrue);
    await tester.tap(find.byTooltip('Show password'));
    await tester.pump();
    expect(obscured(), isFalse);
    expect(find.byTooltip('Hide password'), findsOneWidget);
  });
}
