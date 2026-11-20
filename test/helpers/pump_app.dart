import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_localizations/flutter_localizations.dart'
    show GlobalWidgetsLocalizations;
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/design/app_theme.dart';
import 'package:staka/core/l10n/l10n.dart';

/// Pumps [child] inside the real themes and localisations.
Future<void> pumpThemed(
  WidgetTester tester,
  Widget child, {
  Brightness brightness = Brightness.light,
  double textScale = 1,
}) {
  return tester.pumpWidget(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: brightness == Brightness.light ? AppTheme.light : AppTheme.dark,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, app) => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: TextScaler.linear(textScale)),
        child: app!,
      ),
      home: Scaffold(body: child),
    ),
  );
}

/// Sets a phone-sized logical screen for the rest of the test.
void usePhoneScreen(
  WidgetTester tester, {
  double width = 360,
  double height = 640,
}) {
  tester.view
    ..physicalSize = Size(width, height)
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}
