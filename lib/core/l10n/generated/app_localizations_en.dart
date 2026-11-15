// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'STAKA';

  @override
  String get appTagline => 'Your clothes, with their footprint attached.';

  @override
  String get errorNetwork =>
      'STAKA\'s server isn\'t reachable right now. Check your connection, then try again.';

  @override
  String get errorGeneric =>
      'Something went wrong on our side. Try again in a moment.';

  @override
  String get errorSessionEnded => 'Your session has ended. Sign in again.';

  @override
  String get errorForbidden => 'Your account doesn\'t have access to this.';

  @override
  String get loading => 'Loading';

  @override
  String get tryAgain => 'Try again';

  @override
  String get errorTitle => 'This didn\'t load';

  @override
  String get errorOfflineTitle => 'No connection';

  @override
  String get validationEmail => 'Enter an email address like name@example.com';

  @override
  String get validationPasswordRequired => 'Enter your password';

  @override
  String get validationPasswordShort => 'Use at least 8 characters';

  @override
  String get validationPasswordLong => 'Use 128 characters or fewer';

  @override
  String get validationNameRequired => 'Enter your name';

  @override
  String get validationPasswordsDiffer => 'The two passwords don\'t match';

  @override
  String validationTooLong(int max) {
    return 'Use $max characters or fewer';
  }

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get welcomeLede =>
      'Scan the barcode on a clothing label to see the piece\'s carbon footprint and recyclability, prove you bought it, and keep its tag in one wardrobe.';

  @override
  String get createAccount => 'Create an account';

  @override
  String get signIn => 'Sign in';

  @override
  String get signOut => 'Sign out';

  @override
  String get howItWorks => 'How it works';

  @override
  String get stepScanTitle => 'Scan the label';

  @override
  String get stepScanBody =>
      'Point your phone\'s camera at the barcode on a clothing label, or type the number under it.';

  @override
  String get stepFootprintTitle => 'See its footprint';

  @override
  String get stepFootprintBody =>
      'The piece\'s tag shows its carbon footprint, how much of it can be recycled, and who checked those figures.';

  @override
  String get stepProveTitle => 'Prove you own it';

  @override
  String get stepProveBody =>
      'Match it to a paid order, or upload a receipt for the STAKA team to check. Proven pieces join your wardrobe.';

  @override
  String get navWardrobe => 'Wardrobe';

  @override
  String get navScan => 'Scan';

  @override
  String get navAdmin => 'Admin';

  @override
  String get navAccount => 'Account';

  @override
  String get pendingScreenTitle => 'This screen is being built';

  @override
  String get loginTitle => 'Sign in to STAKA';

  @override
  String get loginLede => 'Pick up where you left off with your tags.';

  @override
  String get fieldEmail => 'Email';

  @override
  String get fieldPassword => 'Password';

  @override
  String get forgotPassword => 'Forgot your password?';

  @override
  String get signingIn => 'Signing in…';

  @override
  String get newToStaka => 'New to STAKA?';

  @override
  String get loginWrongCredentials =>
      'That email and password don\'t match an account. Check them and try again.';

  @override
  String get registerTitle => 'Create your STAKA account';

  @override
  String get registerLede => 'Start a digital tag for every piece you own.';

  @override
  String get fieldYourName => 'Your name';

  @override
  String get nameHint => 'Shown on tags you share.';

  @override
  String get passwordHint => 'At least 8 characters.';

  @override
  String get createAccountSubmit => 'Create account';

  @override
  String get creatingAccount => 'Creating account…';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get registerEmailTaken =>
      'An account already uses this email. Sign in instead.';

  @override
  String get forgotTitle => 'Reset your password';

  @override
  String get forgotLede =>
      'Enter the email you signed up with and we\'ll send you a link to choose a new password.';

  @override
  String get sendResetLink => 'Send reset link';

  @override
  String get sendAnotherLink => 'Send another link';

  @override
  String get sendingLink => 'Sending link…';

  @override
  String resetLinkSent(String email) {
    return 'If $email has a STAKA account, a reset link is on its way. It works once and expires in 1 hour.';
  }

  @override
  String get resetLinkOpensWebsite =>
      'The link opens the STAKA website: choose your new password there, then sign in here.';

  @override
  String get rememberedIt => 'Remembered it?';

  @override
  String get backToSignIn => 'Back to sign in';

  @override
  String get signingOut => 'Signing out…';

  @override
  String get changePassword => 'Change password';

  @override
  String get changePasswordLede =>
      'You\'ll stay signed in on this phone. Other devices will need to sign in again.';

  @override
  String get fieldCurrentPassword => 'Current password';

  @override
  String get fieldNewPassword => 'New password';

  @override
  String get fieldConfirmPassword => 'Confirm new password';

  @override
  String get validationCurrentPasswordRequired => 'Enter your current password';

  @override
  String get changingPassword => 'Changing password…';

  @override
  String get currentPasswordWrong =>
      'That isn\'t your current password. Check it and try again.';

  @override
  String get passwordChanged =>
      'Password changed. Other devices will need to sign in again.';

  @override
  String get passwordChangedSignIn =>
      'Password changed. Sign in with your new password.';

  @override
  String tagSemantics(String product, String brand) {
    return 'Digital tag for $product by $brand';
  }

  @override
  String get noPhotoYet => 'No photo yet';

  @override
  String get imageUnavailable => 'Image unavailable';

  @override
  String get tagFootprint => 'Footprint';

  @override
  String get tagRecyclable => 'Recyclable';

  @override
  String verifiedBy(String certifier) {
    return 'Verified by $certifier';
  }

  @override
  String get verifiedByThirdParty => 'Verified by a third party';

  @override
  String get statedByBrand => 'Figures stated by the brand';

  @override
  String get noFiguresYet => 'No sustainability figures yet';

  @override
  String keptBy(String name) {
    return 'Kept by $name';
  }

  @override
  String get verifiedOwnerSemantics => 'verified owner';

  @override
  String barcodeNumber(String number) {
    return 'Barcode $number';
  }

  @override
  String get unitGramsCo2e => 'g CO₂e';

  @override
  String get unitKgCo2e => 'kg CO₂e';

  @override
  String get ownershipVerified => 'Verified owner';

  @override
  String get ownershipPending => 'Receipt under review';

  @override
  String get ownershipRejected => 'Receipt turned down';

  @override
  String get ownershipBlocked => 'Can\'t be verified';

  @override
  String get ownershipUnverified => 'Not verified yet';

  @override
  String get sampleTagProduct => 'Organic Cotton Tee';

  @override
  String get sampleTagBrand => 'Terra Threads';

  @override
  String get wardrobeTitle => 'My wardrobe';

  @override
  String welcomeName(String name) {
    return 'Welcome, $name';
  }

  @override
  String get wardrobeEmptyDescription =>
      'Scan the barcode on a garment\'s label to keep its footprint on a digital tag.';

  @override
  String wardrobeCount(int count, int verified) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pieces',
      one: '1 piece',
    );
    return '$_temp0, $verified verified.';
  }

  @override
  String get scanAProduct => 'Scan a product';

  @override
  String get wardrobeEmptyTitle => 'Your wardrobe is empty';

  @override
  String get wardrobeEmptyBody =>
      'Point your camera at the barcode on a clothing label, or type the number under it. Each piece you add gets its own tag.';

  @override
  String get scanFirstPiece => 'Scan your first piece';

  @override
  String get sectionVerified => 'Verified';

  @override
  String get sectionVerifiedBody => 'Pieces you\'ve proven you own.';

  @override
  String get sectionWaiting => 'Waiting for proof';

  @override
  String get sectionWaitingBody =>
      'Open a tag to match it to an order or upload a receipt.';

  @override
  String get confirmYourEmail => 'Confirm your email';

  @override
  String verifyEmailJustJoined(String email) {
    return 'We\'ve sent a confirmation link to $email. Open it to confirm your email.';
  }

  @override
  String verifyEmailReminder(String email) {
    return 'We sent a confirmation link to $email. Open it to confirm your email.';
  }

  @override
  String get sendNewLink => 'Send a new link';

  @override
  String get sending => 'Sending…';

  @override
  String get verificationResent => 'We\'ve sent a new confirmation link.';

  @override
  String get emailAlreadyConfirmed => 'Your email is already confirmed.';

  @override
  String get scanTitle => 'Scan a product';

  @override
  String get scanLede =>
      'Hold the barcode on the clothing label inside the frame. QR codes on tags work too.';

  @override
  String get cameraRegion => 'Camera';

  @override
  String get cameraStarting => 'Starting the camera…';

  @override
  String get cameraLooking => 'Looking for a barcode…';

  @override
  String cameraFound(String gtin) {
    return 'Found $gtin. Opening the product…';
  }

  @override
  String get cameraOff => 'Camera is off.';

  @override
  String get turnCameraOn => 'Turn camera on';

  @override
  String get turnCameraOff => 'Turn camera off';

  @override
  String get cameraBlocked =>
      'Camera access is blocked. Allow it for STAKA in your phone\'s Settings, then try again. Or type the number.';

  @override
  String cameraUnavailable(String reason) {
    return '$reason Type the barcode number instead.';
  }

  @override
  String get cameraNoCamera => 'No camera was found on this device.';

  @override
  String get cameraCouldNotStart => 'The camera couldn\'t start.';

  @override
  String get typeNumberTitle => 'Type the number instead';

  @override
  String get barcodeNumberLabel => 'Barcode number';

  @override
  String get barcodeNumberHint => 'e.g. 8901234500019';

  @override
  String get barcodeNumberHelp => 'The digits printed under the bars.';

  @override
  String get lookUpProduct => 'Look up product';

  @override
  String get scanEmpty => 'Enter the number under the barcode.';

  @override
  String scanWrongLength(int count) {
    return 'That\'s $count digits. Barcode numbers have 8, 12, 13 or 14.';
  }

  @override
  String get scanWebsite =>
      'This QR code links to a website, not a product STAKA knows.';

  @override
  String get scanNotBarcode => 'This code isn\'t a product barcode.';

  @override
  String get productInWardrobe => 'In your wardrobe';

  @override
  String get viewYourTag => 'View your tag';

  @override
  String get addToMyWardrobe => 'Add to my wardrobe';

  @override
  String get adding => 'Adding…';

  @override
  String get figuresTitle => 'What the figures mean';

  @override
  String figureCarbon(String value) {
    return 'Carbon footprint: $value';
  }

  @override
  String get figureCarbonBody =>
      'Estimated greenhouse gases from making this piece, expressed as the same warming effect in carbon dioxide.';

  @override
  String figureRecyclable(int percent) {
    return 'Recyclable: $percent%';
  }

  @override
  String get figureRecyclableBody =>
      'The share of the piece, by weight, that can be recycled at end of life.';

  @override
  String get independentlyVerified => 'Independently verified';

  @override
  String certifierChecked(String certifier) {
    return '$certifier has checked these figures.';
  }

  @override
  String get thirdPartyChecked => 'A third party has checked these figures.';

  @override
  String get statedByBrandTitle => 'Stated by the brand';

  @override
  String get noOneChecked =>
      'No one outside the brand has checked these figures yet.';

  @override
  String brandNoFigures(String brand) {
    return '$brand hasn\'t shared figures for this piece yet.';
  }

  @override
  String aboutBrand(String brand) {
    return 'About $brand';
  }

  @override
  String get barcodeInvalidTitle => 'That barcode didn\'t read correctly';

  @override
  String barcodeInvalidBody(String message) {
    return '$message. Scan it again, or check the digits if you typed them.';
  }

  @override
  String get productUnknownTitle => 'This product isn\'t on STAKA yet';

  @override
  String productUnknownBody(String gtin) {
    return 'No brand has added barcode $gtin yet. Only products from partner brands have tags for now.';
  }

  @override
  String get scanAgain => 'Scan again';

  @override
  String addedBanner(String product) {
    return '$product is in your wardrobe.';
  }

  @override
  String addedOn(String date) {
    return 'Added to your wardrobe on $date.';
  }

  @override
  String get scanAnotherPiece => 'Scan another piece';

  @override
  String get productDetails => 'Product details';

  @override
  String get tagMissingTitle => 'This tag isn\'t in your wardrobe';

  @override
  String get tagMissingBody =>
      'It may have been removed, or the link was copied wrong.';

  @override
  String uploadsLeft(int left) {
    String _temp0 = intl.Intl.pluralLogic(
      left,
      locale: localeName,
      other: '$left of 5 uploads left.',
      one: '1 upload left.',
    );
    return '$_temp0';
  }

  @override
  String get ownershipVerifiedTitle => 'You\'re the verified owner';

  @override
  String verifiedByOrderOn(String date) {
    return 'We matched this piece to a paid order on your account on $date. It counts toward your wardrobe.';
  }

  @override
  String get verifiedByOrder =>
      'We matched this piece to a paid order on your account. It counts toward your wardrobe.';

  @override
  String verifiedByReceiptOn(String date) {
    return 'An admin approved your receipt on $date. It counts toward your wardrobe.';
  }

  @override
  String get verifiedByReceipt =>
      'An admin approved your receipt. It counts toward your wardrobe.';

  @override
  String pendingBody(String date, String uploadsLeft) {
    return 'Sent $date. An admin will check it, and the result shows up here. $uploadsLeft';
  }

  @override
  String pendingBodyUndated(String uploadsLeft) {
    return 'An admin will check it, and the result shows up here. $uploadsLeft';
  }

  @override
  String get blockedTitle => 'This piece can\'t be verified';

  @override
  String get blockedBody =>
      'All 5 receipt uploads for it were used. You can still keep its tag.';

  @override
  String blockedBodyWithReason(String reason) {
    return 'All 5 receipt uploads for it were used. The last one was turned down: $reason. You can still keep its tag.';
  }

  @override
  String get proveTitle => 'Prove you own it';

  @override
  String get proveLede =>
      'Verified pieces count toward your wardrobe. Use whichever way works for you.';

  @override
  String lastReceiptRejected(String reason, String uploadsLeft) {
    return 'Your last receipt was turned down: $reason. $uploadsLeft';
  }

  @override
  String get noReasonGiven => 'no reason given';

  @override
  String get orderTitle => 'Bought it through STAKA\'s partner shop?';

  @override
  String get orderBody =>
      'We\'ll look for it in the paid orders on your account.';

  @override
  String get findInOrders => 'Find it in my orders';

  @override
  String get checkingOrders => 'Checking orders…';

  @override
  String get orderMatched => 'Verified: we found it in your orders.';

  @override
  String get orderNotFound =>
      'No paid order on your account includes this piece. Upload a receipt instead.';

  @override
  String get receiptTitle => 'Upload a receipt';

  @override
  String receiptBody(String uploadsLeft) {
    return 'A clear photo or PDF showing the shop, the date and this piece. An admin checks it. $uploadsLeft';
  }

  @override
  String get choosePhotoOrPdf => 'Choose a photo or PDF';

  @override
  String fileSizeTapToChange(String size) {
    return '$size MB. Tap to change.';
  }

  @override
  String get fileTooLarge =>
      'The file is over 5 MB. Take a smaller photo or crop it.';

  @override
  String get sendForReview => 'Send for review';

  @override
  String get sendingReceipt => 'Sending receipt…';

  @override
  String get receiptSent => 'Receipt sent. We\'ll check it soon.';

  @override
  String get takePhoto => 'Take a photo';

  @override
  String get choosePhoto => 'Choose from your photos';

  @override
  String get choosePdf => 'Choose a PDF';

  @override
  String openTagLabel(String product, String brand) {
    return '$product by $brand, open tag';
  }

  @override
  String get shareLockedTitle => 'Sharing unlocks once you\'re verified';

  @override
  String get shareLockedBody =>
      'Only proven pieces can be shared, so every STAKA tag people see is backed by a real purchase.';

  @override
  String get shareTitle => 'Share this tag';

  @override
  String get shareBody =>
      'Anyone with the link sees the tag, your first name and that you\'re the verified owner. Never your email.';

  @override
  String get createShareLink => 'Create share link';

  @override
  String get creatingLink => 'Creating link…';

  @override
  String get shareLinkLabel => 'Share link';

  @override
  String get copyLink => 'Copy link';

  @override
  String get linkCopied => 'Link copied';

  @override
  String get shareEllipsis => 'Share…';

  @override
  String get storyImage => 'Image for Instagram stories';

  @override
  String get preparingImage => 'Preparing image…';

  @override
  String get seeWhatOthersSee => 'See what others see';

  @override
  String get stopSharing => 'Stop sharing';

  @override
  String get stoppingSharing => 'Stopping…';

  @override
  String get stopSharingTitle => 'Stop sharing this tag?';

  @override
  String get stopSharingBody =>
      'The link stops working for everyone, including posts that already use it. You can share again later with a new link.';

  @override
  String get keepSharing => 'Keep sharing';

  @override
  String get shareLinkReady => 'Share link ready';

  @override
  String get sharingTurnedOff =>
      'Sharing turned off. The old link no longer works.';

  @override
  String get couldNotOpenLink => 'The link couldn\'t be opened.';

  @override
  String shareText(String product) {
    return 'I own this $product, verified on STAKA.';
  }

  @override
  String shareSubject(String product) {
    return '$product on STAKA';
  }

  @override
  String get adminProducts => 'Products';

  @override
  String get adminProductsDescription =>
      'Everything shoppers can scan. A product\'s tag shows exactly what\'s recorded here.';

  @override
  String get adminBrands => 'Brands';

  @override
  String get adminBrandsDescription =>
      'Every product belongs to a brand. Its name appears at the top of each tag.';

  @override
  String get adminImport => 'Import';

  @override
  String get adminImportDescription =>
      'Add or update many products at once from a spreadsheet saved as CSV. Rows are matched on barcode: new barcodes are added, known ones are updated.';

  @override
  String get adminClaims => 'Claims';

  @override
  String get adminClaimsDescription =>
      'Shoppers prove they bought a piece with a receipt. Approving one makes them its verified owner. Order matches are approved automatically.';

  @override
  String get importCsv => 'Import CSV';

  @override
  String get addProduct => 'Add product';

  @override
  String get searchProductsLabel => 'Search products';

  @override
  String get searchProductsHint => 'Search by name, SKU, barcode or brand';

  @override
  String get filterByBrand => 'Filter by brand';

  @override
  String get allBrands => 'All brands';

  @override
  String get clearFilters => 'Clear';

  @override
  String get clearSearch => 'Clear search';

  @override
  String showingProducts(int total, int first, int last) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: 'Showing $first–$last of $total products',
      one: 'Showing $first–$last of $total product',
    );
    return '$_temp0';
  }

  @override
  String get figuresVerified => 'Verified';

  @override
  String get figuresBrandStated => 'Brand-stated';

  @override
  String get figuresMissing => 'Missing';

  @override
  String figuresBadgeLabel(String status) {
    return 'Figures: $status';
  }

  @override
  String get noProductsMatchTitle => 'No products match';

  @override
  String get noProductsMatchBody =>
      'Try a different name, SKU or barcode, or clear the filters.';

  @override
  String get noProductsTitle => 'No products yet';

  @override
  String get noProductsBody =>
      'Add products one at a time, or import a whole catalog from a CSV file.';

  @override
  String get productNewDescription =>
      'Shoppers find this product by scanning its barcode.';

  @override
  String productLastUpdated(String date) {
    return 'Last updated $date.';
  }

  @override
  String get pageNotFound => 'This page could not be found.';

  @override
  String get productSection => 'Product';

  @override
  String get fieldProductName => 'Name';

  @override
  String get productNameHint =>
      'As it\'s printed on the label, e.g. Organic Cotton Tee.';

  @override
  String get fieldBrand => 'Brand';

  @override
  String get chooseBrand => 'Choose a brand';

  @override
  String get brandMissing => 'Missing one?';

  @override
  String get addBrandLink => 'Add it on the Brands page';

  @override
  String get fieldBarcode => 'Barcode number';

  @override
  String get barcodeHint => 'The digits under the barcode (EAN, UPC or GTIN).';

  @override
  String get fieldSku => 'SKU';

  @override
  String get skuHint => 'Your internal product code.';

  @override
  String get fieldDescription => 'Description';

  @override
  String get descriptionHint =>
      'Optional. One or two sentences about materials and making.';

  @override
  String get fieldPhotoLink => 'Photo link';

  @override
  String get photoLinkHint => 'Optional. A square photo works best.';

  @override
  String get photoLinkPlaceholder => 'https://';

  @override
  String get figuresSection => 'Sustainability figures';

  @override
  String get includeFigures => 'Include carbon and recyclability figures';

  @override
  String get fieldCarbon => 'Carbon footprint (grams CO₂e)';

  @override
  String get carbonHint => 'Whole grams, e.g. 2100.';

  @override
  String carbonShownAs(String value) {
    return 'Shown as $value';
  }

  @override
  String get fieldRecyclable => 'Recyclable (%)';

  @override
  String get recyclableHint => '0 to 100.';

  @override
  String get verifiedByThirdPartyHint =>
      'Leave off if the brand states these figures itself. Tags show the difference.';

  @override
  String get fieldCertifier => 'Verified by';

  @override
  String get certifierHint =>
      'The certification or body, e.g. Global Organic Textile Standard.';

  @override
  String get cancel => 'Cancel';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get saving => 'Saving…';

  @override
  String get tagPreviewCaption => 'Shoppers will see this tag';

  @override
  String get previewProductName => 'Product name';

  @override
  String get productAdded => 'Product added';

  @override
  String get changesSaved => 'Changes saved';

  @override
  String get productFormInvalid =>
      'Some details need fixing before this product can be saved.';

  @override
  String get productCodeTaken => 'Another product already uses this code.';

  @override
  String get barcodeInvalid => 'The barcode number isn\'t valid.';

  @override
  String barcodeInvalidField(String message) {
    return '$message. Check the digits under the barcode.';
  }

  @override
  String get validationProductName => 'Enter the product name';

  @override
  String get validationGtin =>
      'Enter the 8, 12, 13 or 14 digits printed under the barcode';

  @override
  String get validationSku => 'Enter the SKU';

  @override
  String validationFieldTooLong(String label, int max) {
    return '$label must be $max characters or fewer';
  }

  @override
  String get validationUrl => 'Enter a full link starting with https://';

  @override
  String get validationFigureRequired => 'Required when figures are included';

  @override
  String validationAtMost(String label, int max) {
    return '$label must be $max or less';
  }

  @override
  String get validationCertifier => 'Name who verified the figures';

  @override
  String get certifierLabel => 'Certifier';

  @override
  String get recyclabilityLabel => 'Recyclability';

  @override
  String get deleteProduct => 'Delete product';

  @override
  String get deletingProduct => 'Deleting…';

  @override
  String deleteProductTitle(String name) {
    return 'Delete $name?';
  }

  @override
  String get deleteProductBody =>
      'Shoppers will no longer find it by scanning. This can\'t be undone.';

  @override
  String get keepProduct => 'Keep product';

  @override
  String productDeleted(String name) {
    return '$name deleted';
  }
}
