# STAKA mobile

The STAKA app for Android, built with Flutter. It does what the STAKA
website does, against the same NestJS API:

- **Shoppers:** scan a garment's barcode, see its footprint, keep its tag in
  a wardrobe, prove ownership (order match or receipt), and share a public
  link.
- **Admins:** manage products, brands, CSV import and receipt claims.

| | |
|---|---|
| App name / id | **STAKA** / `com.staka.app` |
| Flutter / Dart | 3.50 / 3.14 |
| Verified on | Android 15 (real phone). iOS is set up in the project but not built or tested (needs a Mac). |
| Talks to | the API (`api/`) and, for catalog images, the story image and public tag links, the website (`web/`) |

The app is online only: every screen needs the API, and shows a "no
connection" state with Try again when it can't reach it.

## 1. Set up

1. Install Flutter 3.50+ and the Android SDK.
2. Run `flutter doctor`; it should show no Android errors.
3. Fetch packages:

```bash
flutter pub get
```

4. Create your local settings file from the example. `env/*.json` is
   gitignored, except the example.

```bash
cp env/example.json env/dev.json
```

### Settings (`env/*.json`)

They are read at build time with `--dart-define-from-file`. Nothing secret
belongs here: they end up inside the app.

| Key | What it is | Example |
|---|---|---|
| `API_BASE_URL` | The STAKA API | `http://localhost:7070` |
| `WEB_APP_URL` | The STAKA website: catalog images, the story image, share links `/t/<slug>` | `http://localhost:3000` |
| `APP_ENV` | `development`, `staging` or `production` | `development` |

Which address to use depends on where the app runs:

| The app runs on | API_BASE_URL / WEB_APP_URL |
|---|---|
| Android emulator | `http://10.0.2.2:7070` / `http://10.0.2.2:3000` (the PC as the emulator sees it) |
| Phone on USB (simplest) | `http://localhost:7070` / `http://localhost:3000`, after `adb reverse` (below) |
| Phone on the same Wi-Fi | `http://<PC's LAN IP>:7070` / `:3000`. Windows Firewall must allow those ports |

## 2. Run against the local API and website

Start the backend from the repo root:
1. Docker Desktop.
2. The database:

```bash
docker compose -f infra/docker-compose.dev.yml up -d
```

3. The API, in `api/`:

```bash
pnpm start:dev
```

4. The website, in `web/`:

```bash
pnpm dev
```

> On Windows, the `postgresql-x64-16` service also uses port 5432. Stop it,
> or Prisma connects to the wrong database.

Then, with a phone on USB (USB debugging allowed):

```bash
adb reverse tcp:7070 tcp:7070
```

```bash
adb reverse tcp:3000 tcp:3000
```

```bash
flutter run --dart-define-from-file=env/dev.json
```

`adb reverse` lasts until the cable is unplugged; run it again after.

## 3. Tests

| What | Command |
|---|---|
| Format + analyse (as CI) | `dart format --output=none --set-exit-if-changed lib test` then `flutter analyze --fatal-infos` |
| Unit + widget tests (as CI) | `flutter test --exclude-tags golden` |
| Everything, including goldens | `flutter test` |
| Golden baselines only | `flutter test --tags golden` |
| Live API tests | `flutter test --tags live --dart-define=LIVE_API_URL=http://localhost:7070` |
| Device journeys (real app on a phone) | `flutter test integration_test/shopper_journey_test.dart -d <device-id> --dart-define-from-file=env/dev.json` |

- **Goldens:** pixel snapshots. The baselines were rendered on Windows, so
  CI skips them. Only refresh them with `--update-goldens` when a visual
  change is intended.
- **Live tests:** they hit a running API and create throwaway
  `mobile-live-*@example.com` users. The admin tests, and the admin device
  journey (`integration_test/admin_journey_test.dart`), also need
  `--dart-define=LIVE_ADMIN_EMAIL=… --dart-define=LIVE_ADMIN_PASSWORD=…` from
  the header of `api/src/prisma/seed.ts`. Never commit or print those.
- **Device journeys:** `flutter test` on a device uninstalls the app when it
  finishes.

## 4. Build

```bash
flutter build apk --debug --dart-define-from-file=env/dev.json
```

```bash
flutter build apk --release --dart-define-from-file=env/dev.json
```

The APK lands in `build/app/outputs/flutter-apk/`. Install it on a
connected phone:

```bash
adb install -r build/app/outputs/flutter-apk/app-release.apk
```

- **Signing:** a release APK is still signed with Flutter's debug key
  (no release signing is set up; the app isn't going to the stores yet).
- **Sharing it:** an APK only works on another phone if that phone can reach
  the API and website addresses it was built with. `localhost` only works
  with the cable and `adb reverse` on your PC.
- **First build:** about 13 minutes while Gradle downloads.
  `android/gradle.properties` sets `kotlin.incremental=false`, which works
  around a Windows cross-drive Kotlin cache error.

### Code generation

After changing a provider, model or DTO (Riverpod, freezed,
json_serializable):

```bash
dart run build_runner build --delete-conflicting-outputs
```

After changing copy in `lib/core/l10n/arb/app_en.arb`:

```bash
flutter gen-l10n
```

The generated files are committed.

### App icon and splash

Both are drawn by `tool/make_app_icons.py`: the hang-tag mark from the
website's wordmark, cream on the header's forest green `#24422A`. After
changing the script, regenerate (needs Pillow):

```bash
python tool/make_app_icons.py
```

| Writes | Purpose |
|---|---|
| `android/app/src/main/res/mipmap-*` | Launcher icons: a legacy square and a round icon, plus the Android 8+ adaptive layers and the Android 13 themed-icon layer |
| `res/drawable-*/splash_logo.png` | The splash logo |
| `docs/branding/staka-icon-1024.png` | A full-size copy of the icon |

The splash is plain Android resources, the same in light and dark mode:
- **Android 12+:** `res/values-v31/styles.xml`.
- **Older versions:** `res/drawable/launch_background.xml`.

The app's own first screen (`lib/app/launch/launch_screen.dart`) carries the
same green and mark on while the saved session is checked. iOS icons are not
generated yet.

## 5. How the code is organised

```
lib/
  main.dart            ProviderScope + App
  app/                 router (go_router), the tab shell, launch / unreachable screens
  core/                shared by every feature
    network/           one Dio client for the API (auth, retry, logging), one for the website
    auth/              tokens (secure storage), single-flight refresh, session state
    error/             Failure types, Result (Ok / Err), messageForFailure
    design/            colours, type, spacing (light + dark)
    l10n/              all copy (ARB), same wording as the website
    models/, api_models/  domain models and API DTOs + mappers
  features/<area>/     auth, wardrobe, scan, products, tags, account, admin/*
    domain/            models + repository interfaces
    data/              datasources (Dio), DTO mappers, repository implementations
    presentation/      state (Riverpod controllers), widgets, screens
  shared/widgets/      buttons, inputs, feedback, hang tag, layout
```

Rules the code follows:
- **Repositories never throw.** They return `Result<T>` with a sealed
  `Failure` (network, 401, 403, 404, 409, 429, 5xx…). Screens turn a
  failure into copy with `messageForFailure`. The API's own message wins,
  as on the website, except for 429, which the app words itself.
- **Sessions:** the access token goes in every request. A 401 triggers one
  shared refresh. A rejected refresh signs the user out with "Your session
  has ended".
- **Screens are thin:** state lives in Riverpod controllers, and widgets get
  data and callbacks.
- **Text is never hardcoded:** it comes from the ARB file.
- **Every API call** the app makes is listed in
  `docs/handoff/PHASE4_BACKEND_SYNC.md`.

## 6. Project notes

`docs/handoff/` is the project's memory. Start with `HANDOFF.md`:

| File | What it covers |
|---|---|
| `HANDOFF.md` | Where things stand, and the conventions |
| `DECISIONS.md` | Every decision taken with the product owner |
| `PROGRESS.md` | What's done |
| `PHASE1_ANALYSIS.md` | The website, feature by feature |
| `PHASE2_PLAN.md` | The build plan |
| `PHASE4_BACKEND_SYNC.md` | The API contract and backend changes |
| `PHASE5_VERIFICATION.md` | What was tested on a phone, and what isn't done |
