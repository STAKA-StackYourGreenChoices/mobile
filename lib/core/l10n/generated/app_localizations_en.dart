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
  String errorTooManyAttempts(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'Too many attempts. Please wait $minutes minutes and try again.',
      one: 'Too many attempts. Please wait 1 minute and try again.',
    );
    return '$_temp0';
  }

  @override
  String get errorTooManyAttemptsSoon =>
      'Too many attempts. Please wait a few minutes and try again.';

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
  String get deleting => 'Deleting…';

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

  @override
  String get addBrand => 'Add brand';

  @override
  String get noBrandsTitle => 'No brands yet';

  @override
  String get noBrandsBody =>
      'Add a brand before adding its products. Importing a CSV also creates any brands it names.';

  @override
  String brandProductCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count products',
      one: '1 product',
    );
    return '$_temp0';
  }

  @override
  String get edit => 'Edit';

  @override
  String editBrandLabel(String name) {
    return 'Edit $name';
  }

  @override
  String get delete => 'Delete';

  @override
  String deleteBrandLabel(String name) {
    return 'Delete $name';
  }

  @override
  String get editBrandDescription =>
      'Changes show on every tag for this brand\'s products.';

  @override
  String get addBrandDescription =>
      'You can add its products once the brand exists.';

  @override
  String get fieldBrandName => 'Brand name';

  @override
  String get fieldAboutBrand => 'About the brand';

  @override
  String get aboutBrandHint =>
      'Optional. One sentence on what they make and how.';

  @override
  String get fieldLogoLink => 'Logo link';

  @override
  String get optionalHint => 'Optional.';

  @override
  String get validationBrandName => 'Enter the brand name';

  @override
  String get brandNameTaken => 'A brand with this name already exists';

  @override
  String get brandAdded => 'Brand added';

  @override
  String get brandUpdated => 'Brand updated';

  @override
  String brandHasProductsTitle(String name) {
    return '$name still has products';
  }

  @override
  String brandHasProductsBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Delete its $count products or move them to another brand first.',
      one: 'Delete its 1 product or move them to another brand first.',
    );
    return '$_temp0';
  }

  @override
  String deleteBrandTitle(String name) {
    return 'Delete $name?';
  }

  @override
  String get cantBeUndone => 'This can\'t be undone.';

  @override
  String get close => 'Close';

  @override
  String get seeItsProducts => 'See its products';

  @override
  String get keepBrand => 'Keep brand';

  @override
  String get deleteBrand => 'Delete brand';

  @override
  String brandDeleted(String name) {
    return '$name deleted';
  }

  @override
  String get importTitle => 'Import products';

  @override
  String get importProgressLabel => 'Import progress';

  @override
  String get stepChooseFile => 'Choose a file';

  @override
  String get stepReview => 'Review';

  @override
  String get stepImport => 'Import';

  @override
  String stepLabel(int number, int total, String name) {
    return 'Step $number of $total: $name';
  }

  @override
  String get stepDone => '(done)';

  @override
  String get chooseCsvFile => 'Choose a CSV file';

  @override
  String get csvLimits => 'Up to 2 MB and 5,000 rows.';

  @override
  String chosenFileSize(String size) {
    return '$size KB. Choose another file to replace it.';
  }

  @override
  String get downloadTemplate => 'Download the template';

  @override
  String get checkFile => 'Check file';

  @override
  String get checkingFile => 'Checking file…';

  @override
  String get fileNeedsTitle => 'What the file needs';

  @override
  String get fileNeedsColumnsLabel => 'Required columns:';

  @override
  String get fileNeedsColumns => 'gtin, sku, name, brandName';

  @override
  String get fileNeedsBarcodes =>
      'Barcodes can be 8, 12, 13 or 14 digits. Keep leading zeros by formatting the column as text.';

  @override
  String get fileNeedsFigures =>
      'For figures, fill both carbonScoreGrams and recyclabilityPercent, and set verified to true or false.';

  @override
  String get fileNeedsBrands =>
      'Brands that don\'t exist yet are created for you.';

  @override
  String get fileNeedsReview =>
      'Nothing is saved until you\'ve reviewed the check.';

  @override
  String get chooseCsvFirst => 'Choose a CSV file to import.';

  @override
  String notCsvFile(String name) {
    return '$name isn\'t a CSV file. Save the sheet as .csv and try again.';
  }

  @override
  String get csvTooLarge =>
      'The file is larger than 2 MB. Split it into smaller files.';

  @override
  String get templateUnavailable =>
      'The template isn\'t available right now. Try again in a moment.';

  @override
  String readyToImport(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ready to import $count products',
      one: 'Ready to import 1 product',
    );
    return '$_temp0';
  }

  @override
  String get nothingToImport => 'Nothing in this file can be imported';

  @override
  String checkedRows(int count, String file) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Checked $count rows in $file. Nothing has been saved yet.',
      one: 'Checked 1 row in $file. Nothing has been saved yet.',
    );
    return '$_temp0';
  }

  @override
  String get statNewProducts => 'New products';

  @override
  String get statUpdates => 'Updates';

  @override
  String get statNewBrands => 'New brands';

  @override
  String get statRowsToFix => 'Rows to fix';

  @override
  String newBrandsList(String names) {
    return 'New brands: $names';
  }

  @override
  String rowsSkipped(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rows will be skipped',
      one: '1 row will be skipped',
    );
    return '$_temp0';
  }

  @override
  String get rowsSkippedHint =>
      'Fix these lines in your spreadsheet and import the file again; rows already imported are just updated.';

  @override
  String get columnLine => 'Line';

  @override
  String get columnBarcode => 'Barcode';

  @override
  String get columnFix => 'What to fix';

  @override
  String get barcodeMissing => 'Missing';

  @override
  String get chooseDifferentFile => 'Choose a different file';

  @override
  String importProductCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Import $count products',
      one: 'Import 1 product',
    );
    return '$_temp0';
  }

  @override
  String get importing => 'Importing…';

  @override
  String importedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Imported $count products',
      one: 'Imported 1 product',
    );
    return '$_temp0';
  }

  @override
  String importSummary(
    String added,
    String updated,
    String brands,
    String skipped,
  ) {
    return '$added, $updated$brands.$skipped';
  }

  @override
  String importAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count new products',
      one: '1 new product',
    );
    return '$_temp0 added';
  }

  @override
  String importUpdated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count products',
      one: '1 product',
    );
    return '$_temp0 updated';
  }

  @override
  String importBrandsCreated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ', $count new brands created',
      one: ', 1 new brand created',
    );
    return '$_temp0';
  }

  @override
  String importSkipped(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' $count rows with problems were skipped.',
      one: ' 1 row with problems was skipped.',
    );
    return '$_temp0';
  }

  @override
  String get viewProducts => 'View products';

  @override
  String get importAnotherFile => 'Import another file';

  @override
  String get claimsTitle => 'Ownership claims';

  @override
  String get claimStatusLabel => 'Claim status';

  @override
  String get tabToReview => 'To review';

  @override
  String get tabApproved => 'Approved';

  @override
  String get tabRejected => 'Rejected';

  @override
  String get nothingToReview => 'Nothing to review';

  @override
  String get nothingToReviewBody =>
      'Receipts shoppers upload appear here, oldest first.';

  @override
  String get noApprovedClaims => 'No approved claims yet';

  @override
  String get noRejectedClaims => 'No rejected claims yet';

  @override
  String get decidedClaimsBody => 'Decisions you make will be listed here.';

  @override
  String claimUserLine(String name, String email) {
    return '$name ($email)';
  }

  @override
  String get methodOrderMatch => 'Order match';

  @override
  String receiptAttemptOf(String attempt) {
    return 'Receipt $attempt of 5';
  }

  @override
  String showingClaims(int total, int last) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: 'Showing 1–$last of $total claims',
      one: 'Showing 1–$last of $total claim',
    );
    return '$_temp0';
  }

  @override
  String claimTitle(String name, String product) {
    return '$name: $product';
  }

  @override
  String claimOrderMatched(String date) {
    return 'Matched automatically to a paid order on $date.';
  }

  @override
  String claimReceiptSent(String attempt, String date) {
    return 'Receipt $attempt of 5, sent $date.';
  }

  @override
  String get openPdfReceipt => 'Open the PDF receipt';

  @override
  String get tapReceiptFullSize => 'Tap the image to open it full size.';

  @override
  String receiptImageLabel(String name) {
    return 'Receipt uploaded by $name';
  }

  @override
  String noReceiptOrder(String order) {
    return 'No receipt: this claim was verified from order $order.';
  }

  @override
  String get orderOnRecord => 'on record';

  @override
  String get receiptUnavailable => 'This receipt isn\'t available.';

  @override
  String get receiptViewerTitle => 'Receipt';

  @override
  String get yourDecision => 'Your decision';

  @override
  String get approve => 'Approve';

  @override
  String get approving => 'Approving…';

  @override
  String get reject => 'Reject';

  @override
  String get rejectReasonLabel => 'Reason the shopper will see';

  @override
  String get commonReasonsLabel => 'Common reasons';

  @override
  String get reasonBlurry => 'The receipt is too blurry to read';

  @override
  String get reasonProductMissing => 'This product isn\'t on the receipt';

  @override
  String get reasonWrongShop =>
      'The receipt is from a shop that doesn\'t sell this brand';

  @override
  String get reasonCutOff => 'Part of the receipt is cut off';

  @override
  String get lastUpload =>
      'This was their last upload: rejecting it means they can\'t verify this piece.';

  @override
  String rejectUploadsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'They\'ll have $count uploads left.',
      one: 'They\'ll have 1 upload left.',
    );
    return '$_temp0';
  }

  @override
  String get back => 'Back';

  @override
  String get rejectReceipt => 'Reject receipt';

  @override
  String get rejecting => 'Rejecting…';

  @override
  String get claimApproved =>
      'Approved. The shopper is now the verified owner.';

  @override
  String get claimRejected => 'Rejected. The shopper will see your reason.';

  @override
  String get reasonTooShort =>
      'Tell the shopper what was wrong so they can fix it';

  @override
  String get reasonTooLong => 'Keep the reason under 500 characters';

  @override
  String claimDecidedApproved(String date) {
    return 'Approved $date';
  }

  @override
  String claimDecidedRejected(String date) {
    return 'Rejected $date';
  }

  @override
  String reviewedBy(String name) {
    return ' by $name';
  }

  @override
  String reasonGiven(String reason) {
    return 'Reason given: “$reason”';
  }

  @override
  String get whatToCheck => 'What to check';

  @override
  String checkShop(String brand) {
    return 'The shop or brand is $brand or a stockist.';
  }

  @override
  String checkLine(String product, String sku) {
    return 'A line on the receipt matches $product (SKU $sku).';
  }

  @override
  String get checkReal => 'It looks like a real, unedited receipt.';

  @override
  String get shopperHeading => 'Shopper';

  @override
  String get allClaimsForPiece => 'All claims for this piece';

  @override
  String historyReceipt(String attempt) {
    return 'Receipt $attempt';
  }

  @override
  String get thisOne => ' (this one)';

  @override
  String waitingSince(String date) {
    return 'Waiting since $date';
  }

  @override
  String quotedText(String text) {
    return '“$text”';
  }

  @override
  String get continueWithPhone => 'Continue with phone number';

  @override
  String get useEmailInstead => 'Use email instead';

  @override
  String get phoneTitle => 'Your phone number';

  @override
  String get phoneLede =>
      'We\'ll text you a 6-digit code. New to STAKA? The same code creates your account.';

  @override
  String get fieldPhone => 'Mobile number';

  @override
  String get phoneHelper =>
      'A 10-digit Indian number, or start with + and the country code.';

  @override
  String get phoneInvalid =>
      'Enter a 10-digit mobile number, or a number that starts with + and the country code.';

  @override
  String get sendCode => 'Send code';

  @override
  String get sendingCode => 'Sending code…';

  @override
  String get codeTitle => 'Enter the code';

  @override
  String codeLede(String phone, int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutes',
      one: '1 minute',
    );
    return 'We sent a 6-digit code to $phone. It works for $_temp0.';
  }

  @override
  String get fieldCode => '6-digit code';

  @override
  String get checkCode => 'Continue';

  @override
  String get checkingCode => 'Checking…';

  @override
  String get resendCode => 'Resend code';

  @override
  String resendCodeIn(String time) {
    return 'Resend code in $time';
  }

  @override
  String get resendingCode => 'Sending a new code…';

  @override
  String get codeResent => 'We sent a new code.';

  @override
  String get changeNumber => 'Change number';

  @override
  String get codeWrong =>
      'That code isn\'t right. Check the message and try again.';

  @override
  String get codeExpired => 'This code has expired. Ask for a new one.';

  @override
  String get nameTitle => 'What should we call you?';

  @override
  String get nameLede =>
      'This is the name on your account. You can add an email later in Account.';

  @override
  String get startAgain => 'Start again';

  @override
  String get signInWithEmailPrompt => 'Signed up with email?';

  @override
  String get signInWithPhonePrompt => 'No email on your account?';

  @override
  String get signInWithPhone => 'Use your phone number';

  @override
  String get accountSectionSignIn => 'How you sign in';

  @override
  String get accountPhoneRow => 'Phone number';

  @override
  String get accountEmailRow => 'Email';

  @override
  String get accountNotAdded => 'Not added';

  @override
  String accountEmailUnconfirmed(String email) {
    return '$email · not confirmed yet';
  }

  @override
  String accountPhoneLede(String phone) {
    return 'You sign in with $phone and a 6-digit code we text you.';
  }

  @override
  String get accountPhoneAddLede =>
      'Add a number to sign in with a 6-digit code we text you.';

  @override
  String get accountPhoneChange => 'Change number';

  @override
  String get accountPhoneRemove => 'Remove number';

  @override
  String get accountPhoneOnlyWay =>
      'This number is how you sign in. To remove it, first add an email and set a password.';

  @override
  String accountPhoneRemoveTitle(String phone) {
    return 'Remove $phone?';
  }

  @override
  String get accountPhoneRemoveBody =>
      'You won\'t be able to sign in with this number any more. You can add it again later.';

  @override
  String get keepNumber => 'Keep number';

  @override
  String get removing => 'Removing…';

  @override
  String get accountPhoneSaved => 'Phone number saved.';

  @override
  String get accountPhoneRemoved => 'Phone number removed.';

  @override
  String get phoneTaken => 'That number is on another STAKA account.';

  @override
  String get addEmailTitle => 'Add an email';

  @override
  String get addEmailLede =>
      'We\'ll send a link to confirm it. Then you can also sign in with your email and a password.';

  @override
  String get addEmail => 'Add email';

  @override
  String get addingEmail => 'Adding email…';

  @override
  String get emailTaken => 'An account already uses this email.';

  @override
  String emailAdded(String email) {
    return 'Check your inbox: we sent a confirmation link to $email.';
  }

  @override
  String get setPasswordTitle => 'Set a password';

  @override
  String get setPasswordLede =>
      'Sign in with your email and this password, as well as with your phone.';

  @override
  String get setPasswordLedeNoEmail =>
      'You\'ll need an email too, to sign in with a password. You can add one in Account.';

  @override
  String get setPassword => 'Set password';

  @override
  String get settingPassword => 'Setting password…';

  @override
  String get passwordSet => 'Password set.';

  @override
  String get accountSectionData => 'Your data';

  @override
  String get downloadData => 'Download my data';

  @override
  String get downloadDataDetail => 'Your profile, tags and claims as a file';

  @override
  String get deleteAccount => 'Delete my account';

  @override
  String get deleteAccountTitle => 'Delete your account';

  @override
  String get deleteAccountLede =>
      'This can\'t be undone. Download your data first if you want a copy.';

  @override
  String get deleteAccountRemovesProfile =>
      'Your name, email and phone number are removed from STAKA.';

  @override
  String get deleteAccountStopsShares =>
      'Your tags and share links stop working.';

  @override
  String get deleteAccountDeletesReceipts =>
      'Your receipts are deleted once we no longer have to keep them.';

  @override
  String get deleteAccountSignsOut => 'You\'re signed out on every device.';

  @override
  String get deleteAccountConfirmPassword => 'Enter your password to confirm.';

  @override
  String deleteAccountConfirmCode(String phone) {
    return 'We\'ll text a code to $phone to confirm.';
  }

  @override
  String get deletingAccount => 'Deleting account…';

  @override
  String get deleteAccountWrongPassword =>
      'That isn\'t your password. Check it and try again.';

  @override
  String get accountDeleted => 'Your account has been deleted.';

  @override
  String get accountSectionBrands => 'For brands';

  @override
  String get bringYourBrand => 'Bring your brand to STAKA';

  @override
  String get bringYourBrandDetail =>
      'Apply, or see how your application is going';

  @override
  String get brandApplyIntroBody =>
      'Once STAKA has checked your details, your team runs your brand here: no waiting on us.';

  @override
  String get brandApplyBenefitCatalog =>
      'Add your products and their sustainability figures.';

  @override
  String get brandApplyBenefitClaims =>
      'Check your shoppers\' proofs of purchase yourself.';

  @override
  String get brandApplyBenefitRewards =>
      'Reward the people who buy and keep your clothes.';

  @override
  String get brandApplyNeedsTitle => 'What we need';

  @override
  String get brandApplyNeedsBody =>
      'Your brand\'s legal name and a contact email. A business document, such as your GST certificate, helps us check faster.';

  @override
  String get brandApplyStart => 'Start your application';

  @override
  String get brandApplyAnother => 'Apply for another brand';

  @override
  String get brandStatusPending => 'Being checked';

  @override
  String get brandStatusApproved => 'Approved';

  @override
  String get brandStatusRejected => 'Not approved';

  @override
  String get brandStatusSuspended => 'Paused';

  @override
  String get brandStatusPendingBody =>
      'We\'re checking your details and will let you know.';

  @override
  String brandStatusApprovedBody(String brand) {
    return '$brand is on STAKA. Your team can now run it.';
  }

  @override
  String get brandStatusRejectedBody =>
      'STAKA couldn\'t approve this application. Fix what\'s needed and send it again.';

  @override
  String brandStatusSuspendedBody(String brand) {
    return 'STAKA has paused $brand. Its products stay visible to shoppers.';
  }

  @override
  String brandStatusReason(String reason) {
    return 'Reason: $reason';
  }

  @override
  String brandAppliedOn(String date) {
    return 'Applied $date';
  }

  @override
  String get brandEditAndResubmit => 'Edit and resubmit';

  @override
  String get brandApplyTitle => 'Apply for your brand';

  @override
  String get brandEditTitle => 'Edit your application';

  @override
  String brandApplyStepOf(int step, int total) {
    return 'Step $step of $total';
  }

  @override
  String get brandStepBrand => 'Your brand';

  @override
  String get brandStepContact => 'How we reach you';

  @override
  String get brandStepContactBody => 'STAKA uses these only about your brand.';

  @override
  String get brandStepFiles => 'Logo and documents';

  @override
  String get brandAlreadyListed => 'My brand is already on STAKA';

  @override
  String get brandAlreadyListedHint =>
      'Pick it to take it over with its products.';

  @override
  String get chooseYourBrand => 'Choose your brand';

  @override
  String get listedBrandsFailed => 'Couldn\'t load the brands on STAKA.';

  @override
  String get fieldLegalName => 'Legal name';

  @override
  String get legalNameHint => 'As on your business registration.';

  @override
  String get validationLegalName => 'Enter your brand\'s legal name';

  @override
  String get fieldWebsite => 'Website';

  @override
  String get websitePlaceholder => 'https://yourbrand.com';

  @override
  String get fieldGstin => 'GSTIN';

  @override
  String get gstinHint => 'Optional. 15 characters, e.g. 22AAAAA0000A1Z5.';

  @override
  String get validationGstin => 'Enter a valid 15-character GSTIN';

  @override
  String get fieldContactEmail => 'Contact email';

  @override
  String get fieldContactPhone => 'Contact phone';

  @override
  String get brandLogo => 'Logo';

  @override
  String get brandLogoHint => 'A square image, up to 2 MB. Optional.';

  @override
  String get chooseLogo => 'Choose logo';

  @override
  String get logoTooLarge =>
      'That image is larger than 2 MB. Choose a smaller one.';

  @override
  String get logoKept => 'Leave this to keep the logo you sent.';

  @override
  String get businessDocument => 'Business document';

  @override
  String get businessDocumentHint =>
      'GST certificate or company registration, as a PDF or photo, up to 5 MB. Optional, but it helps us check faster.';

  @override
  String get addDocument => 'Add document';

  @override
  String get documentTooLarge =>
      'That file is larger than 5 MB. Choose a smaller one.';

  @override
  String get documentKept =>
      'Leave this to keep the document you sent, if any.';

  @override
  String get replaceFile => 'Replace';

  @override
  String get removeFile => 'Remove';

  @override
  String get continueStep => 'Continue';

  @override
  String get sendApplication => 'Send application';

  @override
  String get sendingApplication => 'Sending application…';

  @override
  String get applicationSent =>
      'Application sent. We\'ll let you know when STAKA has checked it.';

  @override
  String get brandNameOnStaka =>
      'A brand with this name already runs itself on STAKA.';

  @override
  String get applicationNotFound => 'We couldn\'t find that application.';

  @override
  String get applicationNotFoundBody =>
      'It may have been withdrawn. Go back to see your applications.';

  @override
  String get aboutYourBrandHint =>
      'Optional. One sentence on what you make and how.';

  @override
  String get navBrand => 'Brand';

  @override
  String get brandRoleOwner => 'Owner';

  @override
  String get brandRoleStaff => 'Staff';

  @override
  String get switchBrand => 'Switch brand';

  @override
  String get yourBrands => 'Your brands';

  @override
  String brandSuspendedBanner(String brand) {
    return 'STAKA has paused $brand. Its products stay visible to shoppers, but your team can\'t make changes until STAKA reinstates it.';
  }

  @override
  String get seeWhy => 'See why';

  @override
  String get brandProductsDescription =>
      'Your products and their sustainability figures. A product\'s tag shows exactly what\'s recorded here.';

  @override
  String get brandImportDescription =>
      'Add or update many of your products at once from a spreadsheet saved as CSV.';

  @override
  String get brandTeam => 'Team';

  @override
  String brandTeamDescription(String brand) {
    return 'Who runs $brand with you.';
  }

  @override
  String get brandSettings => 'Settings';

  @override
  String get brandSettingsDescription =>
      'Name, logo, description, website and contacts.';

  @override
  String get inviteSomeone => 'Invite someone';

  @override
  String inviteTitle(String brand) {
    return 'Invite to $brand';
  }

  @override
  String get inviteBody =>
      'We\'ll send them a link to join. They sign in to STAKA, or make an account, to accept it.';

  @override
  String get fieldEmailOrPhone => 'Email or phone number';

  @override
  String get validationEmailOrPhone =>
      'Enter an email address or a mobile number';

  @override
  String get inviteRole => 'Role';

  @override
  String get roleOwnerHint => 'Also runs the team and settings.';

  @override
  String get roleStaffHint => 'Works on products, import and claims.';

  @override
  String get sendInvite => 'Send invite';

  @override
  String get sendingInvite => 'Sending invite…';

  @override
  String inviteSent(String who) {
    return 'Invite sent to $who.';
  }

  @override
  String memberYou(String name) {
    return '$name (you)';
  }

  @override
  String removeFromTeam(String name) {
    return 'Remove $name from the team';
  }

  @override
  String removeMemberTitle(String name) {
    return 'Remove $name?';
  }

  @override
  String removeMemberBody(String brand) {
    return 'They can no longer work on $brand. You can invite them again later.';
  }

  @override
  String get removeMember => 'Remove';

  @override
  String get removingMember => 'Removing…';

  @override
  String memberRemoved(String name) {
    return '$name is no longer on the team.';
  }

  @override
  String get teamStaffNote => 'Only owners can invite or remove people.';

  @override
  String get openBrandTab => 'Open the Brand tab';

  @override
  String get brandNotReadyYet =>
      'Your brand isn\'t ready yet. Try again in a moment.';

  @override
  String get brandClaimsDescription =>
      'Shoppers who bought your products send a receipt. Approve it when it shows they bought this product: they become its verified owner. Order matches are approved automatically.';

  @override
  String get brandClaimsHubDescription =>
      'Check the proofs of purchase for your products.';

  @override
  String brandClaimsWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count proofs of purchase are waiting for you.',
      one: '1 proof of purchase is waiting for you.',
      zero:
          'Nothing waiting. Proofs of purchase for your products show up here.',
    );
    return '$_temp0';
  }

  @override
  String verifiedByDeciderOn(String decider, String date) {
    return '$decider approved your receipt on $date. It counts toward your wardrobe.';
  }

  @override
  String verifiedByDecider(String decider) {
    return '$decider approved your receipt. It counts toward your wardrobe.';
  }

  @override
  String get verifiedAfterLookAgain =>
      'STAKA looked again and approved your receipt. It counts toward your wardrobe.';

  @override
  String pendingForBrand(String date, String brand, String uploadsLeft) {
    return 'Sent $date. Waiting for $brand to check it; the result shows up here. $uploadsLeft';
  }

  @override
  String pendingForBrandUndated(String brand, String uploadsLeft) {
    return 'Waiting for $brand to check it; the result shows up here. $uploadsLeft';
  }

  @override
  String receiptRejectedBy(String decider, String reason, String uploadsLeft) {
    return '$decider couldn\'t accept this receipt: $reason. $uploadsLeft';
  }

  @override
  String blockedBodyBy(String decider, String reason) {
    return 'All 5 receipt uploads for it were used. $decider couldn\'t accept the last one: $reason. You can still keep its tag.';
  }

  @override
  String get theBrand => 'the brand';

  @override
  String lookAgainLede(String brand) {
    return 'Think $brand got it wrong? STAKA can check the receipt again.';
  }

  @override
  String get askStakaToLookAgain => 'Ask STAKA to look again';

  @override
  String get lookAgainOpenTitle => 'STAKA is looking at this';

  @override
  String lookAgainOpenBody(String brand) {
    return 'We\'ll check your receipt and the reason $brand gave. The result shows up here.';
  }

  @override
  String get lookAgainUpheldTitle => 'STAKA looked again';

  @override
  String lookAgainUpheld(String brand, String note) {
    return 'STAKA agrees with $brand: $note';
  }

  @override
  String lookAgainUpheldNoNote(String brand) {
    return 'STAKA agrees with $brand.';
  }

  @override
  String lookAgainSheetBody(String product, String brand) {
    return 'Tell us why this receipt shows you bought $product. STAKA reads your message with the receipt and the reason $brand gave, then decides. You can ask once.';
  }

  @override
  String get fieldLookAgainMessage => 'Your message';

  @override
  String get lookAgainHelper => '10 to 1,000 characters.';

  @override
  String get validationLookAgainShort => 'Write at least 10 characters.';

  @override
  String get validationLookAgainLong => 'Keep it to 1,000 characters.';

  @override
  String get sendToStaka => 'Send to STAKA';

  @override
  String get sendingToStaka => 'Sending…';

  @override
  String get lookAgainSent => 'Sent. STAKA is looking at this.';

  @override
  String receiptBodyForBrand(String brand, String uploadsLeft) {
    return 'A clear photo or PDF showing the shop, the date and this piece. $brand checks it. $uploadsLeft';
  }

  @override
  String get adminProductsReadOnlyDescription =>
      'Every brand\'s products. Brands add and edit their own; tap one to hide it from shoppers or show it again.';

  @override
  String get noProductsAdminBody =>
      'Brands add their products from their Brand tab. They show up here.';

  @override
  String get hiddenFromShoppers => 'Hidden';

  @override
  String hideProductTitle(String name) {
    return 'Hide $name?';
  }

  @override
  String hideProductBody(String brand) {
    return 'Shoppers won\'t see it on STAKA until you show it again. $brand still sees it in its Brand tab.';
  }

  @override
  String get hideProduct => 'Hide product';

  @override
  String showProductTitle(String name) {
    return 'Show $name again?';
  }

  @override
  String get showProductBody => 'Shoppers can find it on STAKA again.';

  @override
  String get showProduct => 'Show product';

  @override
  String productHidden(String name) {
    return '$name is hidden from shoppers.';
  }

  @override
  String productShown(String name) {
    return 'Shoppers can see $name again.';
  }

  @override
  String get noteTooShort => 'Write at least 3 characters.';

  @override
  String get noteTooLong => 'Keep it to 500 characters.';

  @override
  String get adminBrandsReviewDescription =>
      'Brands apply to run themselves on STAKA. Check each application and its business document, then approve it or turn it down. Pause a brand that breaks the rules.';

  @override
  String get brandReviewPending => 'To review';

  @override
  String get brandReviewActive => 'Active';

  @override
  String get brandReviewSuspended => 'Paused';

  @override
  String get brandReviewRejected => 'Turned down';

  @override
  String get brandStatusLabel => 'Brand status';

  @override
  String noBrandsInStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'pending': 'No applications are waiting.',
      'approved': 'No active brands yet.',
      'suspended': 'No paused brands.',
      'other': 'No turned-down applications.',
    });
    return '$_temp0';
  }

  @override
  String appliedOn(String date) {
    return 'Applied $date';
  }

  @override
  String brandMembers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count people',
      one: '1 person',
      zero: 'No team yet',
    );
    return '$_temp0';
  }

  @override
  String get aboutTheBrand => 'About';

  @override
  String get appliedHeading => 'Applied';

  @override
  String get teamHeading => 'Team';

  @override
  String get listedBrandHeading => 'Already on STAKA';

  @override
  String get claimsListedBrand =>
      'Says it owns a brand STAKA already lists. Approving gives its team that brand and its products.';

  @override
  String get viewBusinessDocument => 'View business document';

  @override
  String get noBusinessDocument => 'No business document was sent.';

  @override
  String get businessDocumentTitle => 'Business document';

  @override
  String get documentUnavailable => 'The document couldn\'t be loaded.';

  @override
  String get approveBrand => 'Approve brand';

  @override
  String get rejectBrand => 'Turn down';

  @override
  String rejectBrandTitle(String brand) {
    return 'Turn down $brand?';
  }

  @override
  String get rejectBrandBody =>
      'Its owners see your reason and can fix the application and send it again.';

  @override
  String get suspendBrand => 'Pause brand';

  @override
  String suspendBrandTitle(String brand) {
    return 'Pause $brand?';
  }

  @override
  String get suspendBrandBody =>
      'Its team can\'t use the Brand tab until you make it active again, and sees your reason. Its products stay visible to shoppers.';

  @override
  String get reinstateBrand => 'Make active again';

  @override
  String get reasonForBrand => 'Reason the brand will see';

  @override
  String get rejectedBrandWaits =>
      'Waiting for the brand to fix its application and send it again.';

  @override
  String brandApproved(String brand) {
    return '$brand is approved. Its team can now run it.';
  }

  @override
  String brandRejected(String brand) {
    return '$brand was turned down. Its owners see your reason.';
  }

  @override
  String brandSuspended(String brand) {
    return '$brand is paused.';
  }

  @override
  String brandReinstated(String brand) {
    return '$brand is active again.';
  }

  @override
  String get adminDisputes => 'Disputes';

  @override
  String get adminDisputesDescription =>
      'Shoppers who think a brand wrongly turned their receipt down. Read their message and the receipt, then keep the decision or approve it.';

  @override
  String get disputeOpen => 'To decide';

  @override
  String get disputeUpheld => 'Kept';

  @override
  String get disputeOverturned => 'Approved';

  @override
  String get disputeStatusLabel => 'Dispute status';

  @override
  String noDisputesInStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'open': 'No disputes are waiting.',
      'upheld': 'No kept decisions yet.',
      'other': 'No approved disputes yet.',
    });
    return '$_temp0';
  }

  @override
  String disputeRowTitle(String product, String brand) {
    return '$product · $brand';
  }

  @override
  String get disputeRowUntitled => 'Receipt turned down by a brand';

  @override
  String get aShopper => 'A shopper';

  @override
  String disputeAsked(String name, String date) {
    return '$name asked $date';
  }

  @override
  String get shopperWrote => 'What the shopper wrote';

  @override
  String brandReasonHeading(String brand) {
    return 'Why $brand turned it down';
  }

  @override
  String get overturn => 'Approve the receipt';

  @override
  String get uphold => 'Keep the decision';

  @override
  String get overturnTitle => 'Approve this receipt?';

  @override
  String overturnBody(String brand) {
    return 'The shopper becomes the verified owner and gets the points. $brand and the shopper see your note.';
  }

  @override
  String upholdTitle(String brand) {
    return 'Keep $brand\'s decision?';
  }

  @override
  String get upholdBody =>
      'The receipt stays turned down and the shopper can\'t ask again. They see your note.';

  @override
  String get noteForShopper => 'Note the shopper will see';

  @override
  String get disputeOverturnedDone =>
      'Approved. The shopper is now the verified owner.';

  @override
  String get disputeUpheldDone => 'Decision kept. The shopper sees your note.';

  @override
  String overturnedOn(String date) {
    return 'You approved the receipt on $date.';
  }

  @override
  String get overturnedUndated => 'The receipt was approved.';

  @override
  String upheldOn(String date) {
    return 'The brand\'s decision was kept on $date.';
  }

  @override
  String get upheldUndated => 'The brand\'s decision was kept.';

  @override
  String noteSaid(String note) {
    return 'Note: $note';
  }

  @override
  String get disputedByShopper => 'Disputed by the shopper';

  @override
  String overruleHeading(String brand) {
    return 'Overrule $brand';
  }

  @override
  String overrulePendingHint(String brand) {
    return '$brand checks this claim. Decide here only when it is stuck, for example a paused brand or one with no team.';
  }

  @override
  String overruleDecidedHint(String brand) {
    return 'Change what $brand decided only when it was clearly wrong. Your reason is recorded.';
  }

  @override
  String get overruleApprove => 'Approve instead';

  @override
  String get overruleReject => 'Reject instead';

  @override
  String get overruleApproveTitle => 'Approve this claim?';

  @override
  String get overruleRejectTitle => 'Reject this claim?';

  @override
  String overruleBody(String brand) {
    return '$brand and the shopper see your reason. It is recorded with your name.';
  }

  @override
  String get overruleReason => 'Reason';

  @override
  String get adminClaimsReadOnlyDescription =>
      'Every brand\'s claims. Brands approve or reject their own; overrule one only when it is stuck or clearly wrong.';

  @override
  String adminBrandsWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count applications are waiting.',
      one: '1 application is waiting.',
      zero: 'No applications waiting.',
    );
    return '$_temp0';
  }

  @override
  String adminDisputesWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count disputes are waiting.',
      one: '1 dispute is waiting.',
      zero: 'No disputes waiting.',
    );
    return '$_temp0';
  }

  @override
  String get categoryTops => 'Tops';

  @override
  String get categoryBottoms => 'Bottoms';

  @override
  String get categoryDresses => 'Dresses';

  @override
  String get categoryOuterwear => 'Outerwear';

  @override
  String get categoryFootwear => 'Footwear';

  @override
  String get categoryAccessories => 'Accessories';

  @override
  String get categoryOther => 'Other';

  @override
  String variantSize(String size) {
    return 'Size $size';
  }

  @override
  String variantDetails(String first, String second) {
    return '$first · $second';
  }

  @override
  String categoryLabel(String category) {
    return 'Type: $category';
  }

  @override
  String get wardrobeFilterAll => 'All';

  @override
  String get wardrobeFilterLabel => 'Show pieces by type';

  @override
  String wardrobeFilterEmpty(String category) {
    return 'No $category in your wardrobe yet.';
  }

  @override
  String get fieldCategory => 'Type of piece';

  @override
  String get categoryHint => 'Shoppers can sort their wardrobe by it.';

  @override
  String get fieldStyleCode => 'Style code';

  @override
  String get styleCodeHint =>
      'Optional. Your code for the style; each size and colour has its own SKU.';

  @override
  String get variantsSection => 'Sizes and colours';

  @override
  String get variantsHint =>
      'Each size or colour has its own barcode and SKU. Add at least one.';

  @override
  String variantHeading(int number) {
    return 'Size or colour $number';
  }

  @override
  String get fieldSize => 'Size';

  @override
  String get sizeHint => 'Optional, e.g. M or 32/34.';

  @override
  String get fieldColour => 'Colour';

  @override
  String get colourHint => 'Optional, e.g. Navy.';

  @override
  String get addVariant => 'Add a size or colour';

  @override
  String get removeVariant => 'Remove';

  @override
  String removeVariantLabel(int number) {
    return 'Remove size or colour $number';
  }

  @override
  String get validationDuplicateBarcode =>
      'Another size or colour already uses this barcode.';

  @override
  String get validationDuplicateSku =>
      'Another size or colour already uses this SKU.';

  @override
  String otherShopCodes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Other shop codes ($count)',
      zero: 'Other shop codes',
    );
    return '$_temp0';
  }

  @override
  String get otherShopCodesSaveFirst =>
      'Save the product first to add codes other shops use.';

  @override
  String get otherShopCodesTitle => 'Other shop codes';

  @override
  String otherShopCodesBody(String variant) {
    return 'Codes other shops use for $variant, so their orders and receipts match it.';
  }

  @override
  String get thisVariant => 'this size or colour';

  @override
  String get aliasSource => 'Shop';

  @override
  String get aliasSourceHint => 'e.g. Myntra';

  @override
  String get aliasCode => 'Their code';

  @override
  String get addAlias => 'Add code';

  @override
  String get addingAlias => 'Adding…';

  @override
  String removeAliasLabel(String source, String code) {
    return 'Remove the $source code $code';
  }

  @override
  String get noAliases => 'No other shop codes yet.';

  @override
  String get validationAliasSource => 'Enter the shop name';

  @override
  String get validationAliasCode => 'Enter the code';

  @override
  String get fileNeedsVariants =>
      'Optional columns: style_code, size, colour, category. Rows with the same style_code become sizes or colours of one product.';

  @override
  String get fileNeedsCategories =>
      'category is one of TOPS, BOTTOMS, DRESSES, OUTERWEAR, FOOTWEAR, ACCESSORIES or OTHER (the default).';

  @override
  String get wardrobeShareCardTitle => 'Share your wardrobe';

  @override
  String get wardrobeShareCardBody =>
      'One link to every verified piece you own.';

  @override
  String get wardrobeShareTitle => 'Share your wardrobe';

  @override
  String get wardrobeShareBody =>
      'Anyone with the link sees your verified pieces and your first name. Never your email. Pieces still waiting for proof stay private.';

  @override
  String get wardrobeShareHideHint =>
      'To leave a piece out, open its tag and turn off Show in my public wardrobe.';

  @override
  String get createWardrobeLink => 'Create wardrobe link';

  @override
  String sharedSince(String date) {
    return 'Shared since $date';
  }

  @override
  String get wardrobeShareText => 'My verified wardrobe on STAKA.';

  @override
  String get wardrobeShareSubject => 'My wardrobe on STAKA';

  @override
  String get stopSharingWardrobeTitle => 'Stop sharing your wardrobe?';

  @override
  String get stopSharingWardrobeBody =>
      'The link stops working for everyone, including posts that already use it. Your tag links keep working. You can share again later with a new link.';

  @override
  String get wardrobeLinkReady => 'Wardrobe link ready';

  @override
  String get showInWardrobe => 'Show in my public wardrobe';

  @override
  String get showInWardrobeBody =>
      'When you share your wardrobe, this piece is on it.';

  @override
  String get channelWhatsApp => 'WhatsApp';

  @override
  String get channelInstagram => 'Instagram';

  @override
  String get channelQr => 'QR code';

  @override
  String get channelMore => 'More';

  @override
  String get shareImagesTitle => 'Images to post';

  @override
  String get storyImageFormat => 'Story (9:16)';

  @override
  String get postImageFormat => 'Post (1:1)';

  @override
  String get qrCodeLabel => 'QR code for this link';

  @override
  String get qrCodeHint =>
      'Let someone scan this with their phone camera to open the link.';

  @override
  String get saveQrImage => 'Save or send image';

  @override
  String get channelInstagramStory => 'Instagram story';

  @override
  String get impactTitle => 'Your impact';

  @override
  String get impactPieces => 'Pieces';

  @override
  String get impactVerified => 'Verified';

  @override
  String get impactShared => 'Shared';

  @override
  String get impactViews => 'Views';

  @override
  String get impactFootprint => 'Footprint owned';

  @override
  String get impactPoints => 'Points';

  @override
  String get seeYourActivity => 'See your activity';

  @override
  String get activityTitle => 'Activity';

  @override
  String get activityBody => 'What happened with your pieces, newest first.';

  @override
  String get activityEmptyTitle => 'Nothing here yet';

  @override
  String get activityEmptyBody =>
      'Scan, add and share pieces, and it all shows up here.';

  @override
  String get aPiece => 'a piece';

  @override
  String activityScan(String product) {
    return 'Scanned $product';
  }

  @override
  String get activityScanUnknown => 'Scanned a product STAKA doesn\'t know yet';

  @override
  String activityCardAdded(String product) {
    return 'Added $product to your wardrobe';
  }

  @override
  String activityVerified(String product) {
    return '$product was verified as yours';
  }

  @override
  String activityRejected(String product) {
    return 'Proof for $product wasn\'t accepted';
  }

  @override
  String activityShared(String product) {
    return 'Shared $product';
  }

  @override
  String get activityWardrobeShared => 'Shared your wardrobe';

  @override
  String activityShareStopped(String product) {
    return 'Stopped sharing $product';
  }

  @override
  String get activityWardrobeShareStopped => 'Stopped sharing your wardrobe';

  @override
  String activityLinkSent(String product) {
    return 'Sent the link to $product';
  }

  @override
  String get activityWardrobeLinkSent => 'Sent your wardrobe link';

  @override
  String activityTagViewed(String product) {
    return 'Someone viewed $product';
  }

  @override
  String get activityWardrobeViewed => 'Someone viewed your wardrobe';

  @override
  String activityEmbedViewed(String product) {
    return '$product was viewed on another website';
  }

  @override
  String activityBrandLinkClicked(String product) {
    return 'Someone visited the brand from $product';
  }

  @override
  String get activityPointsEarned => 'Earned points';

  @override
  String get activityVoucherRedeemed => 'Redeemed a voucher';

  @override
  String get activityOther => 'Account activity';

  @override
  String activityVia(String channel) {
    return 'via $channel';
  }

  @override
  String pointsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count points',
      one: '1 point',
    );
    return '$_temp0';
  }

  @override
  String get channelFacebook => 'Facebook';

  @override
  String get channelX => 'X';

  @override
  String get channelLinkedIn => 'LinkedIn';

  @override
  String get channelCopiedLink => 'Copied link';

  @override
  String get channelEmbed => 'Website embed';

  @override
  String get channelOther => 'Other';

  @override
  String get tagStatsTitle => 'How your link is doing';

  @override
  String get tagStatsViews => 'Views';

  @override
  String get tagStatsClicks => 'Visits to the brand';

  @override
  String get tagStatsByChannel => 'Views by where you shared it';

  @override
  String get tagStatsNoViews =>
      'No views yet. They show here once people open your link.';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String notificationsUnread(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count unread notifications',
      one: '1 unread notification',
    );
    return '$_temp0';
  }

  @override
  String get notificationsBody =>
      'Decisions about your pieces, shares and rewards.';

  @override
  String get notificationsEmptyTitle => 'Nothing yet';

  @override
  String get notificationsEmptyBody =>
      'We\'ll let you know here when a receipt is checked or something happens with your tags.';

  @override
  String get markAllRead => 'Mark all as read';

  @override
  String get notificationUnreadLabel => 'Unread';

  @override
  String get notificationSettingsTitle => 'Notifications';

  @override
  String get notificationSettingsDetail => 'Push and email';

  @override
  String get notificationSettingsBody =>
      'Choose how STAKA tells you about decisions, shares and rewards.';

  @override
  String get pushNotifications => 'Push notifications';

  @override
  String get pushNotificationsBody =>
      'On this phone, when something needs you.';

  @override
  String get emailNotifications => 'Emails';

  @override
  String get emailNotificationsBody =>
      'Decisions and reward news to your inbox.';

  @override
  String get accountSectionNotifications => 'Notifications';

  @override
  String get notificationSettingsTooltip => 'Notification settings';

  @override
  String get accountNotificationsDetail => 'Choose what STAKA sends you';
}
