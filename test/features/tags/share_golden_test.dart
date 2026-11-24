@Tags(['golden'])
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/sharing/share_channels_controller.dart';
import 'package:staka/core/sharing/share_target.dart';
import 'package:staka/features/tags/presentation/widgets/share_locked.dart';
import 'package:staka/features/tags/presentation/widgets/share_panel.dart';
import 'package:staka/shared/widgets/sharing/qr_code_sheet.dart';
import 'package:staka/shared/widgets/sharing/share_link_actions.dart';

import '../../helpers/golden.dart';
import '../../helpers/pump_app.dart';

final _callbacks = ShareLinkCallbacks(
  onChannel: (_, _) {},
  onImage: (_, _) {},
  onOpen: () {},
  onStop: () {},
);

void main() {
  setUpAll(loadAppFonts);

  for (final brightness in Brightness.values) {
    testWidgets('share states, ${brightness.name}', (tester) async {
      usePhoneScreen(tester, height: 2000);
      await pumpThemed(
        tester,
        SingleChildScrollView(
          padding: AppSpacing.screenH,
          child: Column(
            spacing: AppSpacing.lg,
            children: [
              const SizedBox(),
              const ShareLocked(),
              SharePanel(onCreatePressed: () {}),
              SharePanel(
                onCreatePressed: () {},
                linkSection: ShareLinkActions(
                  url: 'https://staka.example/t/abc123',
                  callbacks: _callbacks,
                  stopTitle: 'Stop sharing this tag?',
                  stopBody: 'The link stops working for everyone.',
                ),
              ),
              SharePanel(
                onCreatePressed: () {},
                linkSection: ShareLinkActions(
                  url: 'https://staka.example/t/abc123',
                  callbacks: _callbacks,
                  stopTitle: 'Stop sharing this tag?',
                  stopBody: 'The link stops working for everyone.',
                  preparing: SharePreparing.instagram,
                ),
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

  for (final brightness in Brightness.values) {
    testWidgets('QR code sheet, ${brightness.name}', (tester) async {
      usePhoneScreen(tester, height: 520);
      await pumpThemed(
        tester,
        const ProviderScope(
          child: Material(
            child: QrCodeSheet(
              target: ShareTarget(
                kind: ShareKind.tag,
                slug: 'abc123',
                webAppUrl: 'https://staka.example',
              ),
            ),
          ),
        ),
        brightness: brightness,
      );
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/qr_sheet_${brightness.name}.png'),
      );
    });
  }
}
