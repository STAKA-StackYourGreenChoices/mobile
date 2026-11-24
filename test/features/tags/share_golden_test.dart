@Tags(['golden'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/features/tags/presentation/widgets/share_locked.dart';
import 'package:staka/features/tags/presentation/widgets/share_panel.dart';
import 'package:staka/shared/widgets/sharing/share_link_actions.dart';

import '../../helpers/golden.dart';
import '../../helpers/pump_app.dart';

final _callbacks = ShareLinkCallbacks(
  onCopy: () {},
  onShare: (_) {},
  onStoryImage: (_) {},
  onOpen: () {},
  onStop: () {},
);

void main() {
  setUpAll(loadAppFonts);

  for (final brightness in Brightness.values) {
    testWidgets('share states, ${brightness.name}', (tester) async {
      usePhoneScreen(tester, height: 1250);
      await pumpThemed(
        tester,
        SingleChildScrollView(
          padding: AppSpacing.screenH,
          child: Column(
            spacing: AppSpacing.lg,
            children: [
              const SizedBox(),
              const ShareLocked(),
              SharePanel(onCreatePressed: () {}, linkActions: _callbacks),
              SharePanel(
                url: 'https://staka.example/t/abc123',
                onCreatePressed: () {},
                linkActions: _callbacks,
              ),
            ],
          ),
        ),
        brightness: brightness,
      );
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/share_${brightness.name}.png'),
      );
    });
  }
}
