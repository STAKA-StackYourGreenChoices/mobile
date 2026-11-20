import 'package:cupertino_ui/cupertino_ui.dart';
// Material and Cupertino delegates now come from material_ui / cupertino_ui.
import 'package:flutter_localizations/flutter_localizations.dart'
    show GlobalWidgetsLocalizations;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/app/router/router.dart';
import 'package:staka/app/session_resume_refresher.dart';
import 'package:staka/core/design/app_theme.dart';
import 'package:staka/core/l10n/l10n.dart';

/// Root widget: themes, localisation and the router.
class App extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
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
      routerConfig: ref.watch(routerProvider),
      builder: (_, child) => SessionResumeRefresher(child: child!),
    );
  }
}
