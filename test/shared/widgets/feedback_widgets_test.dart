import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/shared/widgets/feedback/app_empty_state.dart';
import 'package:staka/shared/widgets/feedback/app_error_state.dart';
import 'package:staka/shared/widgets/feedback/app_loader.dart';
import 'package:staka/shared/widgets/layout/app_scaffold.dart';

import '../../helpers/pump_app.dart';

AppEmptyState _empty(VoidCallback onPressed) => AppEmptyState(
  icon: Icons.qr_code_scanner_rounded,
  title: 'Your wardrobe is empty',
  message:
      'Point your camera at the barcode on a clothing label, or type the '
      'number under it. Each piece you add gets its own tag.',
  actionLabel: 'Scan your first piece',
  onActionPressed: onPressed,
);

void main() {
  testWidgets('empty state shows its copy and runs its action', (tester) async {
    var taps = 0;
    await pumpThemed(tester, _empty(() => taps++));

    expect(find.text('Your wardrobe is empty'), findsOneWidget);
    await tester.tap(find.text('Scan your first piece'));
    expect(taps, 1);
  });

  testWidgets('empty state survives 200% text scale on a small phone', (
    tester,
  ) async {
    usePhoneScreen(tester, height: 1200);
    await pumpThemed(tester, _empty(() {}), textScale: 2);

    expect(tester.takeException(), isNull);
  });

  testWidgets('offline error: connection copy and a retry', (tester) async {
    var retries = 0;
    await pumpThemed(
      tester,
      AppErrorState(
        failure: const NetworkFailure(),
        onRetryPressed: () => retries++,
      ),
    );

    expect(find.text('No connection'), findsOneWidget);
    expect(
      find.text(
        "STAKA's server isn't reachable right now. Check your connection, "
        'then try again.',
      ),
      findsOneWidget,
    );
    await tester.tap(find.text('Try again'));
    expect(retries, 1);
  });

  testWidgets(
    "API error: shows the API's own message, no retry if none given",
    (tester) async {
      await pumpThemed(
        tester,
        const AppErrorState(
          failure: NotFoundFailure(['This tag was not found']),
        ),
      );

      expect(find.text("This didn't load"), findsOneWidget);
      expect(find.text('This tag was not found'), findsOneWidget);
      expect(find.text('Try again'), findsNothing);
    },
  );

  testWidgets('loader is announced to screen readers', (tester) async {
    await pumpThemed(tester, const AppLoader());

    expect(find.bySemanticsLabel('Loading'), findsOneWidget);
  });

  testWidgets('scaffold: title in the app bar, scrolling body by default', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AppScaffold(title: 'My wardrobe', body: Text('x')),
      ),
    );

    expect(find.widgetWithText(AppBar, 'My wardrobe'), findsOneWidget);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
  });

  testWidgets('scaffold: list screens opt out of the scroll view', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AppScaffold(isScrollable: false, body: Text('x')),
      ),
    );

    expect(find.byType(SingleChildScrollView), findsNothing);
    expect(find.byType(AppBar), findsNothing);
  });
}
