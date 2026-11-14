import 'package:cupertino_ui/cupertino_ui.dart';
// Material and Cupertino delegates now come from material_ui / cupertino_ui.
import 'package:flutter_localizations/flutter_localizations.dart'
    show GlobalWidgetsLocalizations;
import 'package:material_ui/material_ui.dart';
import 'package:staka/app/boot_screen.dart';
import 'package:staka/core/design/app_theme.dart';
import 'package:staka/core/l10n/l10n.dart';

/// Root widget: themes and localisation. Routing arrives with the router slice.
class App extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => context.l10n.appName,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const BootScreen(),
    );
  }
}
