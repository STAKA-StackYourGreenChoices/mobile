import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:staka/app/app.dart';
import 'package:staka/core/auth/auth_tokens.dart';
import 'package:staka/core/auth/session_repository.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/network/dio_client.dart';
import 'package:staka/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:staka/features/auth/domain/models/auth_session.dart';
import 'package:staka/features/auth/domain/repositories/auth_repository.dart';
import 'package:staka/features/products/data/repositories/product_repository_impl.dart';
import 'package:staka/features/products/domain/repositories/product_repository.dart';
import 'package:staka/features/scan/presentation/state/scan_camera_provider.dart';
import 'package:staka/features/tags/data/repositories/tag_repository_impl.dart';
import 'package:staka/features/tags/domain/repositories/tag_repository.dart';
import 'package:staka/features/tags/presentation/state/receipt_picker.dart';
import 'package:staka/features/tags/presentation/state/share_actions.dart';
import 'package:staka/features/wardrobe/data/repositories/wardrobe_repository_impl.dart';
import 'package:staka/features/wardrobe/domain/repositories/wardrobe_repository.dart';

import 'auth_fakes.dart';
import 'fake_http_adapter.dart';
import 'product_fakes.dart';
import 'scan_fakes.dart';
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
  ProductRepository? products,
  TagRepository? tags,
  ReceiptPicker? receiptPicker,
  ShareActions? shareActions,
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
        // The real camera needs a device.
        scanCameraProvider.overrideWithValue(
          ({required onGtinFound}) => FakeScanCamera(onGtinFound: onGtinFound),
        ),
        if (auth != null) authRepositoryProvider.overrideWithValue(auth),
      ],
      child: const App(),
    ),
  );
  await tester.pumpAndSettle();
  return store;
}

/// Answers from scripts and records what it was asked: `results` for
/// login/register, `requests` for reset-link and change-password.
class FakeAuthRepository implements AuthRepository {
  new(
    List<Result<AuthSession>> results, {
    List<Result<void>> requests = const [],
  }) : _results = [...results],
       _requests = [...requests];

  final List<Result<AuthSession>> _results;
  final List<Result<void>> _requests;
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
}
