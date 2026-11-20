/// Compile-time configuration, passed with
/// `--dart-define-from-file=env/dev.json` (see `env/example.json`).
///
/// Nothing secret belongs here: these values are readable in the app binary.
abstract final class Env {
  /// The STAKA API, e.g. `http://10.0.2.2:7070` from an Android emulator.
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:7070',
  );

  /// The STAKA website. Used to build share links (`/t/<slug>`) and to load
  /// catalog images the website hosts (`/catalog-images/...`).
  static const webAppUrl = String.fromEnvironment(
    'WEB_APP_URL',
    defaultValue: 'http://10.0.2.2:3000',
  );

  /// `development`, `staging` or `production`.
  static const appEnv = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'development',
  );
}
