@Tags(['golden'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/models/share_link.dart';
import 'package:staka/features/wardrobe/presentation/screens/wardrobe_share_screen.dart';
import 'package:staka/shared/widgets/sharing/share_link_actions.dart';

import '../../helpers/golden.dart';
import '../../helpers/pump_app.dart';

final _callbacks = ShareLinkCallbacks(
  onCopy: () {},
  onShare: (_) {},
  onOpen: () {},
  onStop: () {},
);

void main() {
  setUpAll(loadAppFonts);

  final cases = {
    'not_shared': (null, 'Verify a piece before sharing your wardrobe.'),
    'shared': (
      ShareLink(slug: 'w4rdr0be', createdAt: DateTime.utc(2026, 11, 15)),
      null,
    ),
  };

  for (final MapEntry(key: name, value: (share, error)) in cases.entries) {
    for (final brightness in Brightness.values) {
      testWidgets('wardrobe share $name, ${brightness.name}', (tester) async {
        usePhoneScreen(tester, height: 800);
        await pumpThemed(
          tester,
          SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: WardrobeShareView(
              share: share,
              errorMessage: error,
              onCreatePressed: () {},
              linkActions: _callbacks,
            ),
          ),
          brightness: brightness,
        );
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile(
            'goldens/wardrobe_share_${name}_${brightness.name}.png',
          ),
        );
      });
    }
  }
}
