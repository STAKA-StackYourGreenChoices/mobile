# mobile — Phase 5, not yet scaffolded

This repo is intentionally empty. Phases 0–4 (api, web, infra) are live; mobile
is deliberately last because it is the only part of the pipeline that costs
money (Apple Developer Program, macOS runner minutes) and the only part that
cannot be fully verified without those accounts.

## What Phase 5 involves

```bash
flutter create --org com.yourorg --project-name mobile .
```

Then, in order:

1. **`lib/config.dart`** — compile-time env plumbing:
   ```dart
   class Config {
     static const apiBaseUrl = String.fromEnvironment(
       'API_BASE_URL', defaultValue: 'https://api-staging.yourdomain.com');
     static const environment = String.fromEnvironment('APP_ENV', defaultValue: 'staging');
   }
   ```
   ```bash
   flutter build apk --dart-define=API_BASE_URL=https://api-staging.yourdomain.com \
                     --dart-define=APP_ENV=staging
   ```

2. **Test layout**
   ```
   test/unit/        pure Dart — services, mappers, validators
   test/widget/      single widgets and screens
   test/golden/      pixel baselines
   integration_test/ full app on a real emulator/simulator
   ```

   > Add a stable `Key` to every interactive element a test touches. Locating
   > widgets by visible text breaks the moment a copywriter edits a label or you
   > add localization. This is the single highest-leverage habit for keeping a
   > Flutter suite from rotting.

3. **`ci.yml`** — `dart format --set-exit-if-changed`, `flutter analyze
   --fatal-infos`, `flutter test`, `flutter test --tags golden`.

   Goldens are platform-sensitive and must be generated on Linux to match CI:
   ```bash
   docker run --rm -v "$PWD:/app" -w /app ghcr.io/cirruslabs/flutter:stable \
     flutter test --update-goldens --tags golden
   ```

4. **Android signing** → GitHub secrets → Firebase App Distribution (free,
   unlimited testers).

5. **iOS** — Apple Developer Program ($99/yr), Fastlane `match`, TestFlight lane.
   Watch macOS runner minutes: they bill at 10× the Linux rate.

6. **Dart API client** generated from the committed spec in `api/openapi.json`:
   ```bash
   openapi-generator-cli generate -i openapi.json -g dart-dio
   ```

## Required checks when this lands

Blocking: `analyze`, `test`, `test-golden`, `build-android`.

Deliberately **not** blocking: emulator integration tests (slow and flaky enough
that gating merges on them trains people to click "re-run" reflexively) and iOS
builds. Run them, report them, don't block on them until they've earned trust.
A required check people routinely bypass is worse than no check.
