import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/auth/auth_tokens.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/features/brand_apply/domain/models/brand_application.dart';
import 'package:staka/features/brand_apply/domain/models/brand_file.dart';
import 'package:staka/features/tags/presentation/state/receipt_picker.dart';

import '../../helpers/admin_product_fakes.dart';
import '../../helpers/auth_fakes.dart';
import '../../helpers/brand_apply_fakes.dart';
import '../../helpers/fake_http_adapter.dart';
import '../../helpers/pump_full_app.dart';

const _tokens = AuthTokens(accessToken: 'a0', refreshToken: 'r0');

Finder _field(String label) => find.descendant(
  of: find.ancestor(of: find.text(label), matching: find.byType(Column)).first,
  matching: find.byType(EditableText),
);

String _textIn(String label) =>
    (_field(label).evaluate().single.widget as EditableText).controller.text;

Future<void> _tap(WidgetTester tester, Finder finder) async {
  // A focused field keeps scrolling itself back into view.
  FocusManager.instance.primaryFocus?.unfocus();
  await tester.pumpAndSettle();
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> _type(WidgetTester tester, String label, String text) async {
  await tester.ensureVisible(_field(label));
  await tester.enterText(_field(label), text);
}

/// Signed in as Ada (email, no phone), on "Bring your brand to STAKA".
Future<void> _openBrandApplications(
  WidgetTester tester, {
  FakeBrandApplicationRepository? repository,
  FakeBrandFilePicker? picker,
}) async {
  await pumpApp(
    tester,
    tokens: _tokens,
    replies: [json(200, userJson())],
    brandApplications: repository,
    brandFilePicker: picker,
  );
  await tester.tap(find.text('Account'));
  await tester.pumpAndSettle();
  await _tap(tester, find.text('Bring your brand to STAKA'));
}

/// Step 1 with the two required fields, then on to step 2.
Future<void> _fillBrandStep(WidgetTester tester) async {
  await _type(tester, 'Brand name', 'Terra Threads');
  await _type(tester, 'Legal name', 'Terra Threads Private Limited');
  await _tap(tester, find.text('Continue'));
}

void main() {
  testWidgets('a first application: intro, three steps, then Being checked', (
    tester,
  ) async {
    final repository = FakeBrandApplicationRepository(
      sends: [Ok(brandApplication())],
    );
    final picker = FakeBrandFilePicker(
      logos: [logoFile()],
      documents: [bigFile('gst-certificate.pdf', 2048)],
    );
    await _openBrandApplications(
      tester,
      repository: repository,
      picker: picker,
    );

    expect(find.text('What we need'), findsOneWidget);
    await _tap(tester, find.text('Start your application'));

    // Step 1 checks its own fields before moving on.
    expect(find.text('Step 1 of 3'), findsOneWidget);
    await _tap(tester, find.text('Continue'));
    expect(find.text('Enter the brand name'), findsOneWidget);
    expect(find.text("Enter your brand's legal name"), findsOneWidget);

    await _type(tester, 'GSTIN', '33aaact 1234f1z5');
    await _fillBrandStep(tester);

    // Step 2 starts with Ada's own email.
    expect(find.text('How we reach you'), findsOneWidget);
    expect(_textIn('Contact email'), 'ada@example.com');
    await _tap(tester, find.text('Continue'));

    expect(find.text('Logo and documents'), findsOneWidget);
    await _tap(tester, find.text('Choose logo'));
    expect(find.text('logo.png'), findsOneWidget);
    await _tap(tester, find.text('Add document'));
    await _tap(tester, find.text('Choose a PDF'));
    expect(picker.documentSources, [ReceiptSource.pdf]);
    expect(find.text('gst-certificate.pdf'), findsOneWidget);

    await _tap(tester, find.text('Send application'));

    final (id, draft) = repository.sent.single;
    expect(id, isNull);
    expect(draft.name, 'Terra Threads');
    expect(draft.legalName, 'Terra Threads Private Limited');
    expect(draft.gstin, '33AAACT1234F1Z5');
    expect(draft.contactEmail, 'ada@example.com');
    expect(draft.contactPhone, isNull);
    expect(draft.websiteUrl, isNull);
    expect(draft.existingBrandId, isNull);
    expect(draft.logo?.name, 'logo.png');
    expect(draft.document?.name, 'gst-certificate.pdf');

    // Back on the list, without asking the API again.
    expect(
      find.text(
        "Application sent. We'll let you know when STAKA has checked it.",
      ),
      findsOneWidget,
    );
    expect(find.text('Being checked'), findsOneWidget);
    expect(
      find.text("We're checking your details and will let you know."),
      findsOneWidget,
    );
    expect(repository.loads, 1);
  });

  testWidgets('claiming a listed brand sends its id and fills its name', (
    tester,
  ) async {
    final repository = FakeBrandApplicationRepository(
      listed: Ok([brandSummary('b7', 'Terra Threads')]),
      sends: [Ok(brandApplication(existingBrandId: 'b7'))],
    );
    await _openBrandApplications(tester, repository: repository);
    await _tap(tester, find.text('Start your application'));

    await _tap(tester, find.text('My brand is already on STAKA'));
    await _tap(tester, find.text('Continue'));
    // The hint and the error.
    expect(find.text('Choose your brand'), findsNWidgets(2));

    await _tap(tester, find.byType(DropdownButtonFormField<String>));
    await _tap(tester, find.text('Terra Threads').last);
    expect(_textIn('Brand name'), 'Terra Threads');

    await _type(tester, 'Legal name', 'Terra Threads Private Limited');
    await _tap(tester, find.text('Continue'));
    await _tap(tester, find.text('Continue'));
    await _tap(tester, find.text('Send application'));

    final (_, draft) = repository.sent.single;
    expect(draft.existingBrandId, 'b7');
    expect(draft.name, 'Terra Threads');
  });

  testWidgets('a taken name goes back to step 1 and says so', (tester) async {
    final repository = FakeBrandApplicationRepository(
      sends: [
        const Err(ConflictFailure(['A brand with this name is on STAKA'])),
      ],
    );
    await _openBrandApplications(tester, repository: repository);
    await _tap(tester, find.text('Start your application'));
    await _fillBrandStep(tester);
    await _tap(tester, find.text('Continue'));
    await _tap(tester, find.text('Send application'));

    expect(find.text('Step 1 of 3'), findsOneWidget);
    expect(
      find.text('A brand with this name already runs itself on STAKA.'),
      findsOneWidget,
    );
    expect(_textIn('Brand name'), 'Terra Threads');
  });

  testWidgets('offline, the last step says so and keeps everything', (
    tester,
  ) async {
    final repository = FakeBrandApplicationRepository(
      sends: [const Err(NetworkFailure()), Ok(brandApplication())],
    );
    await _openBrandApplications(tester, repository: repository);
    await _tap(tester, find.text('Start your application'));
    await _fillBrandStep(tester);
    await _tap(tester, find.text('Continue'));
    await _tap(tester, find.text('Send application'));

    expect(find.text('Logo and documents'), findsOneWidget);
    expect(find.textContaining('connection'), findsWidgets);

    await _tap(tester, find.text('Send application'));
    expect(repository.sent, hasLength(2));
    expect(find.text('Being checked'), findsOneWidget);
  });

  testWidgets('a logo over 2 MB is refused', (tester) async {
    await _openBrandApplications(
      tester,
      picker: FakeBrandFilePicker(
        logos: [bigFile('huge.jpg', BrandFile.logoMaxBytes + 1)],
      ),
    );
    await _tap(tester, find.text('Start your application'));
    await _fillBrandStep(tester);
    await _tap(tester, find.text('Continue'));

    await _tap(tester, find.text('Choose logo'));

    expect(
      find.text('That image is larger than 2 MB. Choose a smaller one.'),
      findsOneWidget,
    );
    expect(find.text('huge.jpg'), findsNothing);
    expect(find.text('Choose logo'), findsOneWidget);
  });

  testWidgets('the back arrow goes back a step, keeping what was typed', (
    tester,
  ) async {
    await _openBrandApplications(tester);
    await _tap(tester, find.text('Start your application'));
    await _fillBrandStep(tester);
    expect(find.text('Step 2 of 3'), findsOneWidget);

    await _tap(tester, find.byType(BackButton));

    expect(find.text('Step 1 of 3'), findsOneWidget);
    expect(_textIn('Legal name'), 'Terra Threads Private Limited');

    await _tap(tester, find.byType(BackButton));
    expect(find.text('Start your application'), findsOneWidget);
  });

  testWidgets('a rejected application shows why and can be sent again', (
    tester,
  ) async {
    final rejected = brandApplication(
      status: BrandApplicationStatus.rejected,
      statusReason: 'The GST certificate is unreadable',
    );
    final repository = FakeBrandApplicationRepository(
      mine: [
        Ok([rejected]),
      ],
      sends: [Ok(brandApplication())],
    );
    await _openBrandApplications(tester, repository: repository);

    expect(find.text('Not approved'), findsOneWidget);
    expect(
      find.text('Reason: The GST certificate is unreadable'),
      findsOneWidget,
    );
    await _tap(tester, find.text('Edit and resubmit'));

    expect(find.text('Edit your application'), findsOneWidget);
    expect(_textIn('Brand name'), 'Terra Threads');
    expect(_textIn('GSTIN'), '33AAACT1234F1Z5');
    await _tap(tester, find.text('Continue'));
    expect(_textIn('Contact email'), 'hello@terrathreads.example');
    expect(_textIn('Contact phone'), isNotEmpty);
    await _tap(tester, find.text('Continue'));
    expect(
      find.text('Leave this to keep the document you sent, if any.'),
      findsOneWidget,
    );
    await _tap(tester, find.text('Send application'));

    final (id, draft) = repository.sent.single;
    expect(id, 'ba1');
    expect(draft.contactPhone, '+919876543210');
    expect(draft.description, 'Organic cotton basics, made in Tiruppur.');
    expect(draft.document, isNull);
    expect(find.text('Not approved'), findsNothing);
    expect(find.text('Being checked'), findsOneWidget);
  });

  testWidgets('applications that fail to load can be tried again', (
    tester,
  ) async {
    final repository = FakeBrandApplicationRepository(
      mine: [const Err(NetworkFailure()), const Ok([])],
    );
    await _openBrandApplications(tester, repository: repository);

    expect(find.text('No connection'), findsOneWidget);
    await _tap(tester, find.text('Try again'));

    expect(find.text('Start your application'), findsOneWidget);
  });
}
