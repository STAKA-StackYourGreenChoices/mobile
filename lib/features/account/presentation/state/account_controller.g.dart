// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The Account tab's one action. State is "signing out right now", so the
/// button can show it while the API revokes the refresh token.

@ProviderFor(AccountController)
final accountControllerProvider = AccountControllerProvider._();

/// The Account tab's one action. State is "signing out right now", so the
/// button can show it while the API revokes the refresh token.
final class AccountControllerProvider
    extends $NotifierProvider<AccountController, bool> {
  /// The Account tab's one action. State is "signing out right now", so the
  /// button can show it while the API revokes the refresh token.
  AccountControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accountControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accountControllerHash();

  @$internal
  @override
  AccountController create() => AccountController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$accountControllerHash() => r'219ed19b99597c759db3279de660d03e5eecc420';

/// The Account tab's one action. State is "signing out right now", so the
/// button can show it while the API revokes the refresh token.

abstract class _$AccountController extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
