import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:staka/app/app.dart';
import 'package:staka/core/analytics/event_tracker.dart';
import 'package:staka/core/auth/auth_tokens.dart';
import 'package:staka/core/auth/session_repository.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/network/dio_client.dart';
import 'package:staka/core/sharing/qr_png.dart';
import 'package:staka/core/sharing/share_actions.dart';
import 'package:staka/core/sharing/share_image_api.dart';
import 'package:staka/core/time/clock.dart';
import 'package:staka/features/account/data/repositories/account_repository_impl.dart';
import 'package:staka/features/account/domain/repositories/account_repository.dart';
import 'package:staka/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:staka/features/auth/domain/models/auth_session.dart';
import 'package:staka/features/auth/domain/models/otp_challenge.dart';
import 'package:staka/features/auth/domain/models/otp_verification.dart';
import 'package:staka/features/auth/domain/repositories/auth_repository.dart';
import 'package:staka/features/brand_apply/data/repositories/brand_application_repository_impl.dart';
import 'package:staka/features/brand_apply/domain/repositories/brand_application_repository.dart';
import 'package:staka/features/brand_apply/presentation/state/brand_file_picker.dart';
import 'package:staka/features/brand_portal/data/repositories/brand_portal_repository_impl.dart';
import 'package:staka/features/brand_portal/domain/repositories/brand_portal_repository.dart';
import 'package:staka/features/manage/brand_review/data/brand_review_repository_impl.dart';
import 'package:staka/features/manage/brand_review/domain/repositories/brand_review_repository.dart';
import 'package:staka/features/manage/claims/data/repositories/admin_claim_repository_impl.dart';
import 'package:staka/features/manage/claims/domain/repositories/admin_claim_repository.dart';
import 'package:staka/features/manage/disputes/data/dispute_repository_impl.dart';
import 'package:staka/features/manage/disputes/domain/admin_dispute.dart';
import 'package:staka/features/manage/import/data/repositories/import_repository_impl.dart';
import 'package:staka/features/manage/import/domain/repositories/import_repository.dart';
import 'package:staka/features/manage/import/presentation/state/import_file_actions.dart';
import 'package:staka/features/manage/products/data/repositories/admin_product_repository_impl.dart';
import 'package:staka/features/manage/products/domain/repositories/admin_product_repository.dart';
import 'package:staka/features/products/data/repositories/product_repository_impl.dart';
import 'package:staka/features/products/domain/repositories/product_repository.dart';
import 'package:staka/features/scan/presentation/state/scan_camera_provider.dart';
import 'package:staka/features/tags/data/repositories/tag_repository_impl.dart';
import 'package:staka/features/tags/domain/repositories/tag_repository.dart';
import 'package:staka/features/tags/presentation/state/receipt_picker.dart';
import 'package:staka/features/wardrobe/data/repositories/wardrobe_repository_impl.dart';
import 'package:staka/features/wardrobe/data/repositories/wardrobe_share_repository_impl.dart';
import 'package:staka/features/wardrobe/domain/repositories/wardrobe_repository.dart';
import 'package:staka/features/wardrobe/domain/repositories/wardrobe_share_repository.dart';

import 'admin_claim_fakes.dart';
import 'admin_product_fakes.dart';
import 'admin_review_fakes.dart';
import 'auth_fakes.dart';
import 'brand_apply_fakes.dart';
import 'brand_portal_fakes.dart';
import 'fake_http_adapter.dart';
import 'import_fakes.dart';
import 'product_fakes.dart';
import 'scan_fakes.dart';
import 'sharing_fakes.dart';
import 'tag_fakes.dart';
import 'wardrobe_fakes.dart';

/// Pumps the whole app with a fake API for the session (`replies`), an
/// in-memory token store, and scripted feature repositories. The app's own
/// API client fails the test on any request nobody scripted, so nothing
/// silently reaches the network.
Future<InMemoryTokenStore> pumpApp(
  WidgetTester tester, {
  AuthTokens? tokens,
  List<FakeReply> replies = const [],
  AuthRepository? auth,
  WardrobeRepository? wardrobe,
  WardrobeShareRepository? wardrobeShare,
  ProductRepository? products,
  TagRepository? tags,
  ReceiptPicker? receiptPicker,
  ShareActions? shareActions,
  EventTracker? eventTracker,
  ShareImageApi? shareImages,
  FakeQrPng? qrPng,
  AdminProductRepository? adminProducts,
  BrandReviewRepository? brandReview,
  DisputeRepository? disputes,
  ImportRepository? importRepository,
  ImportFileActions? importFileActions,
  AdminClaimRepository? adminClaims,
  DateTime Function()? clock,
  AccountRepository? account,
  BrandApplicationRepository? brandApplications,
  BrandFilePicker? brandFilePicker,
  BrandPortalRepository? brandPortal,
}) async {
  final store = InMemoryTokenStore(tokens);
  final dio = Dio(BaseOptions(baseUrl: 'http://api.test'))
    ..httpClientAdapter = FakeHttpAdapter(replies);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sessionRepositoryProvider.overrideWithValue(
          SessionRepository(dio, store),
        ),
        dioProvider.overrideWithValue(
          Dio(BaseOptions(baseUrl: 'http://unscripted.test'))
            ..httpClientAdapter = FakeHttpAdapter([]),
        ),
        wardrobeRepositoryProvider.overrideWithValue(
          wardrobe ?? FakeWardrobeRepository(),
        ),
        wardrobeShareRepositoryProvider.overrideWithValue(
          wardrobeShare ?? FakeWardrobeShareRepository(),
        ),
        productRepositoryProvider.overrideWithValue(
          products ?? FakeProductRepository(),
        ),
        tagRepositoryProvider.overrideWithValue(tags ?? FakeTagRepository()),
        receiptPickerProvider.overrideWithValue(
          receiptPicker ?? FakeReceiptPicker(),
        ),
        shareActionsProvider.overrideWithValue(
          shareActions ?? FakeShareActions(),
        ),
        eventTrackerProvider.overrideWithValue(
          eventTracker ?? FakeEventTracker(),
        ),
        shareImageApiProvider.overrideWithValue(
          shareImages ?? FakeShareImageApi(),
        ),
        qrPngRendererProvider.overrideWithValue((qrPng ?? FakeQrPng()).call),
        adminProductRepositoryProvider.overrideWith(
          (_, _) => adminProducts ?? FakeAdminProductRepository(),
        ),
        brandReviewRepositoryProvider.overrideWithValue(
          brandReview ?? FakeBrandReviewRepository(),
        ),
        disputeRepositoryProvider.overrideWithValue(
          disputes ?? FakeDisputeRepository(),
        ),
        importRepositoryProvider.overrideWith(
          (_, _) => importRepository ?? FakeImportRepository(),
        ),
        importFileActionsProvider.overrideWithValue(
          importFileActions ?? FakeImportFileActions(),
        ),
        adminClaimRepositoryProvider.overrideWith(
          (_, _) => adminClaims ?? FakeAdminClaimRepository(),
        ),
        // The real camera needs a device.
        scanCameraProvider.overrideWithValue(
          ({required onGtinFound}) => FakeScanCamera(onGtinFound: onGtinFound),
        ),
        if (auth != null) authRepositoryProvider.overrideWithValue(auth),
        if (clock != null) clockProvider.overrideWithValue(clock),
        if (account != null)
          accountRepositoryProvider.overrideWithValue(account),
        brandApplicationRepositoryProvider.overrideWithValue(
          brandApplications ?? FakeBrandApplicationRepository(),
        ),
        brandFilePickerProvider.overrideWithValue(
          brandFilePicker ?? FakeBrandFilePicker(),
        ),
        brandPortalRepositoryProvider.overrideWithValue(
          brandPortal ?? FakeBrandPortalRepository(),
        ),
      ],
      child: const App(),
    ),
  );
  await tester.pumpAndSettle();
  return store;
}

/// Answers from scripts and records what it was asked: `results` for
/// login/register, `requests` for reset-link and change-password, `codes`
/// and `checks` for phone sign-in.
class FakeAuthRepository implements AuthRepository {
  new(
    List<Result<AuthSession>> results, {
    List<Result<void>> requests = const [],
    List<Result<OtpChallenge>> codes = const [],
    List<Result<OtpVerification>> checks = const [],
  }) : _results = [...results],
       _requests = [...requests],
       _codes = [...codes],
       _checks = [...checks];

  final List<Result<AuthSession>> _results;
  final List<Result<void>> _requests;
  final List<Result<OtpChallenge>> _codes;
  final List<Result<OtpVerification>> _checks;
  final List<Map<String, String>> calls = [];

  @override
  Future<Result<void>> requestPasswordReset({required String email}) async {
    calls.add({'call': 'reset', 'email': email});
    return _requests.removeAt(0);
  }

  @override
  Future<Result<void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    calls.add({
      'call': 'change',
      'current': currentPassword,
      'new': newPassword,
    });
    return _requests.removeAt(0);
  }

  @override
  Future<Result<AuthSession>> login({
    required String email,
    required String password,
  }) async {
    calls.add({'email': email, 'password': password});
    return _results.removeAt(0);
  }

  @override
  Future<Result<AuthSession>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    calls.add({'name': name, 'email': email, 'password': password});
    return _results.removeAt(0);
  }

  @override
  Future<Result<OtpChallenge>> requestOtp({required String phone}) async {
    calls.add({'call': 'otpRequest', 'phone': phone});
    return _codes.removeAt(0);
  }

  @override
  Future<Result<OtpVerification>> verifyOtp({
    required String challengeId,
    required String code,
    String? name,
  }) async {
    calls.add({
      'call': 'otpVerify',
      'challengeId': challengeId,
      'code': code,
      'name': ?name,
    });
    return _checks.removeAt(0);
  }
}
