# HANDOFF — start here

Single entry point for any new session. Read this file fully, then only the
files it points to. Update it at the end of every session (see "Before you stop").

## 1. The job in one paragraph

Build a Flutter app (Android + iOS) in `mobile/` that does everything the STAKA
website does, against the same NestJS backend, with no mocks, dead buttons or
TODOs. Work in the 6 phases of `files/app_build_prompt.md`, and stop for the
user's "go ahead" after each phase. Never invent endpoints. Never change `api/`,
`web/`, `infra/` or `files/` without asking first.

## 2. Where we are

| Item | Value |
|---|---|
| Current phase | **3 — Implementation. Slices 1–14 done (shopper side complete)** |
| Next action | Slice 15 `feat/admin-products-list` (branch from `feat/tags-sharing`): Admin tab hub (Products / Brands / Import / Claims, web `lib/nav.ts`), admin products list per web `admin/products/page.tsx` (search `q`→`search`, brand filter, pagination 20, delete with confirm). Replace `_pending(AppRoute.adminHome)` |
| Local API | Runs on this PC (user starts it): Docker Postgres `startup-dev-postgres-1` + `pnpm start:dev` in `api/`. The Windows service `postgresql-x64-16` also uses :5432 and must be stopped or Prisma hits it (P1000). `/health` returns 401 (API bug: no `@Public()`; user declined fixing for now). Live check: `flutter test test/live --dart-define=LIVE_API_URL=http://localhost:7070` (+ `LIVE_ADMIN_EMAIL`/`LIVE_ADMIN_PASSWORD` from the seed header for the sharing test; never print them). User starts the API with: Docker Desktop → `docker compose -f infra/docker-compose.dev.yml up -d` → `pnpm start:dev` in api/ |
| Toolchain | Flutter 3.50.0 / Dart 3.14.0. No emulator/phone attached. `flutter build apk --debug` works (first build ~13 min while Gradle 9.5 downloads). `flutter doctor` still warns about unaccepted Android licences (user's call) |
| Branches | `docs/mobile-handoff` → `chore/project-setup` → `feat/core-network` → `feat/core-session` → `feat/shared-foundations` → `feat/shared-inputs` → `feat/app-shell-router` → `feat/auth-sign-in` → `feat/auth-password` → `feat/shared-hang-tag` → `feat/wardrobe-list` → `feat/scan-barcode` → `feat/products-detail` → `feat/tags-ownership` → `feat/tags-sharing` (stacked, all pushed, nothing merged) |

## 2a. Code conventions already in place (reuse, don't reinvent)

- Errors: `core/error/failure.dart` (sealed `Failure`, `ApiFailure` subtypes by status), `result.dart` (`Ok`/`Err`, `fold`), `error_mapper.dart` (`messageForFailure(failure, l10n)`; API message wins, like the web).
- Network: `dioProvider` in `core/network/dio_client.dart`; wrap every datasource call in `guardApi(() => ...)` from `guard_api.dart`. Interceptors in `core/network/interceptors/`. Logging only via `AppLogger.debug`.
- Session: `sessionControllerProvider` (`core/auth/session_controller.dart`) → `SessionState` = `SessionRestoring | SignedIn(user) | SignedOut(sessionExpired) | SessionUnreachable`. Login/register call `.signIn(tokens:, user:)` with `AuthTokens.fromResponse(AuthResponseDto)`; account calls `.signOut()`; app resume calls `.refreshUser()`.
- Auth: `AuthInterceptor` adds Bearer; endpoints without a session pass `options: publicRequest()` (login, register, forgot/reset password, logout). Refresh is single-flight in `TokenRefresher`; never call `/auth/refresh` anywhere else.
- Shared models: `core/models/` (freezed: User, Brand, Product, SustainabilityInfo, Ownership + ClaimMethod, OwnershipStatus, DigitalCard, ShareLink), DTOs + mappers in `core/api_models/` (json_serializable, `createToJson: false` unless sending). `ProductDto.toDomain()` re-points `/catalog-images/*` at `Env.webAppUrl` (`core/utils/image_url.dart`).
- Tags shared across features: `core/cards/cards_api.dart` (`fetchMine`, `create`) and `core/cards/cards_revision.dart` (`cardsRevisionProvider.notifier.bump()` after any tag change; the wardrobe reloads on it).
- Cross-tab routes: product = `/scan/product/:gtin` (Scan tab), tag = `/wardrobe/tag/:id` (Wardrobe tab). `goNamed` to one from the other switches tab, like the website's back links (/scan, /wardrobe).
- Tags feature: `TagController(cardId).applyOwnership(o)` after any claim (updates screen + bumps revision). Receipt picking behind `receiptPickerProvider` (`DeviceReceiptPicker`: photos scaled to 2400 px @ q85 → JPEG; PDFs via file_picker). Tests: `test/helpers/tag_fakes.dart` (`FakeTagRepository`, `FakeReceiptPicker`, `receiptOf(bytes)`); `pumpApp(..., tags:, receiptPicker:)`.
- Sharing: `ShareController(cardId)` (create / stop / story image) → `TagController.applyShare`. Phone actions (clipboard, share sheet, browser) behind `shareActionsProvider` (tests: `FakeShareActions`). Public link = `publicTagUrl(slug)` (`core/utils/public_tag_url.dart`, `Env.webAppUrl/t/<slug>`); the story image is fetched from the website, so it needs the web server running.
- `dart fix` gotcha: a `const String.fromEnvironment` passed as an argument whose default is `''` gets deleted by `avoid_redundant_argument_values`. Build the URL in the path instead (see sharing_live_test).
- Dates: `formatDate` in `shared/formatters/date_format.dart` ("14 Nov 2026").
- One-shot requests: `core/state/request_state.dart` `RequestState<T>` = Idle | Sending | Done(value) | Failed(failure).
- Shared widgets (`lib/shared/widgets/`): `AppScaffold` (title, actions, `isScrollable: false` for list screens), `AppButton` (primary/secondary/ghost/destructive, `isLoading` + `loadingLabel`, `isExpanded`), `AppLoader`, `AppEmptyState`, `AppErrorState(failure, onRetryPressed)`, `AppTextField` (label above; `errorText` = server error, wins over `validator`; `isPassword` adds show/hide), `AppFormAlert(message, tone)` above forms, `AppSnackbar.show(context, message:, tone:)`. Form rules: `Validators(context.l10n)` in `core/forms/validators.dart` (web's zod messages). `context.colors` / `context.text` come from `core/design/app_typography.dart`.
- Routing: names/paths in `app/routes.dart` (`AppRoute` enum; navigate with `context.goNamed(AppRoute.x.name)`), guards in `app/router/session_redirect.dart` (pure, unit-tested), table in `app/router/app_route_table.dart`. A new screen = add an `AppRoute` value if needed + replace its `_pending(...)` entry. Sub-routes of a tab go inside that tab's `StatefulShellBranch`. Tabs: `app/shell/shell_tab.dart`.
- Feature pattern (copy `features/auth/`): `domain/models` + `domain/repositories` (interface) → `data/datasources` (Dio, `publicRequest()` if no session) + `data/mappers` + `data/repositories/*_impl.dart` (provider + `guardApi`) → `presentation/state` (sealed form/UI state + `@riverpod` controller, `ref.mounted` after awaits) → dumb `widgets` (props + callbacks; own only text controllers) → `screens` (ConsumerWidget maps state/Failure to copy) → route in `app_route_table.dart`.
- Sign-out reasons: `SignedOut(reason: SignedOutReason.sessionExpired | passwordChanged)` → router sends to /login, which shows the matching alert. Router refreshes only on `routingKeyOf(session)` changes (a refresh on every session change raced with `pop()`).
- Interceptor options: `publicRequest()` (no token) and `passwordCheckRequest()` (token sent, but a 401 is returned as is — use for any endpoint whose 401 means wrong password).
- Screens inside a tab: add an `AppRoute` with the full path and register it with `_child(parentRoute, route, builder)` under the tab's route.
- Scan: `parseScan` in `core/utils/scan_parser.dart` (returns `ScanGtin | ScanRejected(reason)`; copy via `scanRejectionMessage`). The camera is behind `scanCameraProvider` (tests use `FakeScanCamera` from `test/helpers/scan_fakes.dart`, a "Simulate scan" button). `BarcodeCamera` runs only while visible (TickerMode + route is current). Camera needs a physical phone to verify.
- Colour tokens added to the app copy of app_colors: `mediaBackdrop` / `onMediaBackdrop` (camera/photo viewers).
- Navigation: from welcome use `pushNamed` (Android back returns); between sibling auth screens `pushReplacementNamed`.
- Whole-app tests: `test/helpers/pump_full_app.dart` `pumpApp(tester, tokens:, replies:, auth:, wardrobe:, products:)` + `FakeAuthRepository`; `test/helpers/wardrobe_fakes.dart` (`FakeWardrobeRepository`, `cardFor(...)`), `product_fakes.dart` (`FakeProductRepository`, `productNamed(...)`). `pumpApp` points `dioProvider` at an adapter that fails on any unscripted request — override each new feature repository there too. Live API tests in `test/live/` (tag `live`, skipped without `LIVE_API_URL`; `LiveClient` in `test/live/live_client.dart` = real stack; each run registers throwaway `mobile-live-*@example.com` users). Tap targets under the bottom bar: `tester.ensureVisible` first.
- Tag visuals (`lib/shared/widgets/data_display/`): `HangTag(productName, brandName, sustainability, image: TagImage(url), gtin, ownerName, isOwnerVerified, size: sm|md|lg, hasString, hasSwing, hasPhotoArea)`, `TagImage(url)` (svg or raster, cached, placeholder/error), `OwnershipChip(status)`. Formatters in `lib/shared/formatters/` (`carbonParts`, `formatCarbon`, `displayGtin`). `SustainabilityInfo` + `OwnershipStatus` in `core/models`.
- Goldens: tag `golden`, run `flutter test --tags golden` (`--update-goldens` only with the user's OK, guide §14). Baselines are Windows-rendered; CI runs `--exclude-tags golden`. Helpers: `test/helpers/pump_app.dart` (`pumpThemed`, `usePhoneScreen`), `golden.dart` (`loadAppFonts`, `withRealShadows` — tests draw shadows as solid outlines otherwise). `pumpAndSettle` before snapshotting anything with a swinging tag.
- Generated files (`*.g.dart`, `*.freezed.dart`, l10n) are committed. After changing providers run build_runner; after ARB edits run `flutter gen-l10n`.
- Tests: `test/helpers/fake_http_adapter.dart` scripts Dio replies (`json(status, body)`, `connectionError()`). No `Future.delayed` in tests: inject waits.

## 2b. Commands

```bash
cp env/example.json env/dev.json          # once; edit URLs for a physical phone
flutter run --dart-define-from-file=env/dev.json
dart format lib test && flutter analyze --fatal-infos && flutter test   # before every commit
dart run build_runner build -d            # once freezed/riverpod_generator are added
```
| Last updated | 2026-11-14 |

Full checklist and session log: `PROGRESS.md`.

## 3. Repo map (all under `D:\Additional Project\`)

| Folder | What it is | Notes |
|---|---|---|
| `api/` | NestJS 11 + Prisma 6 + Postgres. Branch `main` is current. | Source of truth for endpoints. `api/openapi.json` matches the controllers. Test accounts are listed in the header of `api/src/prisma/seed.ts` (do not copy passwords into docs or chat). |
| `web/` | Next.js 16. **`main` is only a starter page.** The real site is on remote branch **`origin/feat/full-app`** (not merged). | Read it without checking out: `git -C web show origin/feat/full-app:<path>` or `git archive origin/feat/full-app \| tar -x -C <scratch>` |
| `mobile/` | `flutter create` output (untracked), default ids `com.example.mobile`. Flutter 3.35.2 / Dart 3.9 on this machine. | `README.md` there is the old "not scaffolded" note; rewrite it in Phase 6. |
| `infra/` | docker-compose (dev = Postgres only on :5432). | API runs on :7070 locally. |
| `files/` | User's design tokens (`app_*.dart`), `FRONTEND_GUIDE.md` (binding rules), `app_build_prompt.md` (the phase plan). | Design source of truth = these files, per the user. |

## 4. Rules that must never be forgotten

From the user:
- Use the attached design (`files/app_*.dart`), the guide's structure/rules, and the build prompt's phases.
- Small files, split for readability. No giant files.
- Ask before changing anything outside `mobile/`. Ask when anything is ambiguous.

From `files/FRONTEND_GUIDE.md` (the ones that shape code most):
- Feature-first: `lib/app`, `lib/core`, `lib/shared`, `lib/features/<f>/{domain,data,presentation}`. `features → shared → core`, never reverse, no feature imports another feature.
- Slice order: types → contract → data → state → UI → screen → wire. Every screen state is a sealed union: loading / empty / data / error.
- Riverpod (+generator), freezed, go_router (named routes), dio, flutter_secure_storage. Any extra package needs a written justification (list in `DECISIONS.md`).
- No raw hex / TextStyle / magic numbers outside `core/design/`. Use `context.colors`, `context.text`, `AppSpacing`.
- No hardcoded user strings (ARB l10n). Sentence case. 48dp tap targets. 200% text scale. Light + dark together.
- Repositories return `Result<T, Failure>`; never leak `DioException`. Error copy lives in one mapper.

## 5. Read next (only what you need)

| File | Open it when |
|---|---|
| `PROGRESS.md` | Always — what's done, what's next |
| `DECISIONS.md` | Always — open questions and the user's answers. Answers override everything else |
| `PHASE1_ANALYSIS.md` | Building any feature: stack, feature inventory, full API map, auth, validations, copy |
| `PHASE2_PLAN.md` | Always during Phase 3: folder layout, packages, routes, screen mapping, slice order |

## 6. Before you stop (every session)

1. Tick items in `PROGRESS.md` and add one line to its session log.
2. Move answered questions in `DECISIONS.md` from "Open" to "Decided".
3. Update the table in section 2 above (phase, next action, date).
Keep entries short: these files exist to save tokens next time.
