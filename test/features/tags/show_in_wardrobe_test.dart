import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/auth/auth_tokens.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/digital_card.dart';
import 'package:staka/core/models/ownership_status.dart';

import '../../helpers/auth_fakes.dart';
import '../../helpers/fake_http_adapter.dart';
import '../../helpers/pump_app.dart';
import '../../helpers/pump_full_app.dart';
import '../../helpers/tag_fakes.dart';
import '../../helpers/wardrobe_fakes.dart';

const _name = 'Organic Cotton Tee';

Future<void> _openTag(
  WidgetTester tester,
  DigitalCard card,
  FakeTagRepository tags,
) async {
  usePhoneScreen(tester, height: 3000);
  await pumpApp(
    tester,
    tokens: const AuthTokens(accessToken: 'a', refreshToken: 'r'),
    replies: [json(200, userJson())],
    wardrobe: FakeWardrobeRepository(
      cards: [
        Ok([card]),
      ],
    ),
    tags: tags,
  );
  await tester.tap(find.text(_name).first);
  await tester.pumpAndSettle();
}

final Finder _switch = find.widgetWithText(
  SwitchListTile,
  'Show in my public wardrobe',
);

void main() {
  final verified = cardFor(
    id: 'c1',
    name: _name,
    status: OwnershipStatus.verified,
  );

  testWidgets('a verified piece can be left out of the public wardrobe', (
    tester,
  ) async {
    final tags = FakeTagRepository(cards: [verified]);
    await _openTag(tester, verified, tags);

    expect(tester.widget<SwitchListTile>(_switch).value, isTrue);
    await tester.tap(_switch);
    await tester.pumpAndSettle();

    expect(tags.wardrobeToggles, [false]);
    expect(tester.widget<SwitchListTile>(_switch).value, isFalse);

    await tester.tap(_switch);
    await tester.pumpAndSettle();
    expect(tags.wardrobeToggles, [false, true]);
    expect(tester.widget<SwitchListTile>(_switch).value, isTrue);
  });

  testWidgets('a refused change says why and keeps the switch', (tester) async {
    final tags = FakeTagRepository(
      cards: [verified],
      wardrobeToggleFailures: [
        const ForbiddenFailure(['Not your tag.']),
      ],
    );
    await _openTag(tester, verified, tags);

    await tester.tap(_switch);
    await tester.pumpAndSettle();

    expect(find.text('Not your tag.'), findsOneWidget);
    expect(tester.widget<SwitchListTile>(_switch).value, isTrue);
  });

  testWidgets('a piece waiting for proof has no switch', (tester) async {
    final waiting = cardFor(id: 'c1', name: _name);
    await _openTag(tester, waiting, FakeTagRepository(cards: [waiting]));

    expect(_switch, findsNothing);
  });
}
