// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dio_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The single HTTP client for the STAKA API, with the session attached.

@ProviderFor(dio)
final dioProvider = DioProvider._();

/// The single HTTP client for the STAKA API, with the session attached.

final class DioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  /// The single HTTP client for the STAKA API, with the session attached.
  DioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dioProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dioHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return dio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$dioHash() => r'4af4c1a52a704648f7bbbd1725042ea6955bd882';

/// A plain client for the STAKA website's public files (the story image):
/// no session, no API base address. Kept alive like the API client, so a
/// short-lived repository can't close it while a download is starting.

@ProviderFor(webDio)
final webDioProvider = WebDioProvider._();

/// A plain client for the STAKA website's public files (the story image):
/// no session, no API base address. Kept alive like the API client, so a
/// short-lived repository can't close it while a download is starting.

final class WebDioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  /// A plain client for the STAKA website's public files (the story image):
  /// no session, no API base address. Kept alive like the API client, so a
  /// short-lived repository can't close it while a download is starting.
  WebDioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'webDioProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$webDioHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return webDio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$webDioHash() => r'6a37f297313358692dd4026d4ba246d89035e343';

/// Refreshes over its own client: no auth interceptor, so a failed refresh
/// can never trigger another refresh. A rejected refresh token signs out.

@ProviderFor(tokenRefresher)
final tokenRefresherProvider = TokenRefresherProvider._();

/// Refreshes over its own client: no auth interceptor, so a failed refresh
/// can never trigger another refresh. A rejected refresh token signs out.

final class TokenRefresherProvider
    extends $FunctionalProvider<TokenRefresher, TokenRefresher, TokenRefresher>
    with $Provider<TokenRefresher> {
  /// Refreshes over its own client: no auth interceptor, so a failed refresh
  /// can never trigger another refresh. A rejected refresh token signs out.
  TokenRefresherProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tokenRefresherProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tokenRefresherHash();

  @$internal
  @override
  $ProviderElement<TokenRefresher> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TokenRefresher create(Ref ref) {
    return tokenRefresher(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TokenRefresher value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TokenRefresher>(value),
    );
  }
}

String _$tokenRefresherHash() => r'77c77ea07fcf0caa4c681d0e5bf1552a3aa78d8f';
