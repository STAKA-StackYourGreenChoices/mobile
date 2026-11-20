# Phase 2 — Architecture & plan

Status: **approved 2026-11-14.** §11 answers are in `DECISIONS.md` (P2-1..P2-4). Follows `files/FRONTEND_GUIDE.md`
except where `DECISIONS.md` overrides it. Questions marked **P2-n** are listed in §11.

## 1. Folder structure (feature-first, guide §3)

```
lib/
├── main.dart                         # runApp(ProviderScope(child: App()))
├── app/
│   ├── app.dart                      # MaterialApp.router, themes, l10n
│   ├── router.dart                   # all GoRoutes + redirect guard
│   ├── route_names.dart              # name/path constants
│   └── shell/                        # bottom-nav shell widgets
├── core/                             # no feature imports
│   ├── config/env.dart               # API_BASE_URL, WEB_APP_URL, APP_ENV
│   ├── design/                       # copied from files/ (see §7)
│   ├── network/                      # dio_client, interceptors/, api_error_parser
│   ├── auth/                         # token_storage, session_controller, jwt_claims
│   ├── error/                        # failure.dart (sealed), result.dart, error_mapper.dart
│   ├── l10n/                         # arb files + generated
│   └── utils/                        # pure: scan_parser, formatters, ean13, image_url
├── shared/widgets/                   # dumb widgets: buttons, inputs, feedback, layout,
│                                     # data_display (hang_tag, ownership_chip, ...)
└── features/
    ├── auth/        welcome, login, register, forgot password, change password
    ├── wardrobe/    my tags list + verify-email banner
    ├── scan/        camera + typed number
    ├── products/    product by GTIN, add to wardrobe
    ├── tags/        tag detail: ownership + sharing
    ├── account/     account screen, sign out
    └── admin/       products, brands, import, claims (sub-folders per area)
```

Each feature: `domain/{models,repositories}`, `data/{dtos,mappers,datasources,repositories}`,
`presentation/{state,screens,widgets}`. Files stay small: one class per file, `build`
under ~80 lines, extracted widget classes instead of `_buildX()` methods.

Shared domain models used by several features (Product, Brand, SustainabilityInfo,
DigitalCard, Ownership, User) live in `core/models/` with their DTOs/mappers in
`core/api_models/`, so no feature imports another (guide §3 dependency rule).

## 2. Packages

Locked stack (guide §2): `flutter_riverpod`, `riverpod_annotation`, `riverpod_generator`,
`freezed`, `freezed_annotation`, `json_serializable`, `json_annotation`, `build_runner`,
`go_router`, `dio`, `flutter_secure_storage`, `cached_network_image`, `intl`,
`flutter_localizations`, `very_good_analysis`, `mocktail`, `riverpod_lint`.
Approved extras (decision 12): `mobile_scanner`, `image_picker`, `file_picker`,
`share_plus`, `url_launcher`, `flutter_svg`, `path_provider`, PDF viewer **`pdfrx`**
(released 2026-11-13; `pdfx` last release 2026-08 is the alternative).
Not added: `drift` (decision 13), Firebase (11), `patrol` until Phase 5, `google_fonts` (banned).
Icons: Flutter's built-in `Icons.*_rounded` (no extra package).

**Blocker P2-1:** current releases of Riverpod 3.5, go_router 18, freezed 4,
very_good_analysis 11 need Dart ≥ 3.12/3.13. This PC has Flutter 3.35.2 / Dart 3.9.

## 3. Networking

- `dio_client.dart`: base URL from env, timeouts connect 10 s / receive 20 s,
  JSON, `X-Request-Id` correlation id per request.
- Interceptors (one file each): `auth_interceptor` (adds Bearer; on 401 runs refresh
  and retries once), `retry_interceptor` (GET only, 3 tries, backoff + jitter on
  network errors/5xx), `log_interceptor` (debug only, redacts tokens/emails).
- **Single-flight refresh**: one shared `Future` for an in-progress `/auth/refresh`;
  every 401 or near-expiry request awaits it. Required because the API's refresh
  tokens rotate and work once. Refresh failure → clear tokens → session = signed out.
- `api_error_parser.dart`: Nest `{message: string|string[]}` → `ApiFailure(status, messages)`.
- Repositories return `Result<T, Failure>`; `Failure` sealed: Network, Unauthorized,
  Forbidden, NotFound, Conflict, Validation(messages), Server(code), Unknown.
- `error_mapper.dart`: Failure → localised copy. Where the website shows a
  specific message for a status (e.g. login 401, register 409), the feature maps it.
- Multipart uploads (receipt, CSV) with client-side size/type checks copied from web.

## 4. Storage & session

- `flutter_secure_storage`: access + refresh token only.
- `session_controller` (Riverpod): `unknown → signedOut | signedIn(User)`.
  Launch: read tokens → `/auth/me` → signedIn, else signedOut.
- Role from `/auth/me` drives admin UI; API stays the authority (403 handled).
- App resume → refresh `/auth/me` (so a verify-email done on the website shows up).
- Online only (decision 13): no-connection state + retry on every screen.

## 5. Routing (go_router, named routes only)

| Name | Path | Guard |
|---|---|---|
| welcome | `/welcome` | guest only |
| login · register · forgotPassword | `/login` `/register` `/forgot-password` | guest only |
| wardrobe | `/wardrobe` | signed in (home) |
| scan | `/scan` | signed in |
| product | `/products/:gtin` | signed in |
| tag | `/tags/:id` | signed in |
| account · changePassword | `/account` `/account/change-password` | signed in |
| adminHome | `/admin` | admin |
| adminProducts · adminProductNew · adminProductEdit | `/admin/products` `/new` `/:id` | admin |
| adminBrands · adminImport | `/admin/brands` `/admin/import` | admin |
| adminClaims · adminClaim | `/admin/claims` `/admin/claims/:id` | admin |

Guards live in one `redirect` driven by `session_controller`. Pass ids, never objects.
Shell: bottom nav **Wardrobe · Scan · Admin (admins only) · Account**. Admin tab opens
a hub listing Products / Brands / Import / Claims (the web's admin nav).
Deep links: none in v1 (decisions 7, 8). Email and share links open the website.

## 6. Environment config

`--dart-define-from-file=env/dev.json` → `core/config/env.dart`
(`API_BASE_URL`, `WEB_APP_URL`, `APP_ENV`). `env/*.json` gitignored;
`env/example.json` committed. Dev defaults: emulator `http://10.0.2.2:7070` /
`:3000`; physical phone = PC LAN IP. Cleartext HTTP allowed **only in debug**
(Android debug `network_security_config`, iOS debug ATS local-networking).
`WEB_APP_URL` is needed to build share links and to rewrite `/catalog-images/*` URLs.

## 7. Theming

- Copy `files/app_colors.dart`, `app_spacing.dart`, `app_typography.dart`,
  `app_theme.dart` into `lib/core/design/` unchanged, except **P2-2**: remove the
  unused tier tokens and wallet gradient (dead code per guide §8.2).
  `files/` itself is never edited.
- Fonts: Plus Jakarta Sans (UI) + Manrope (numbers: carbon, %, counts, GTIN) in
  `assets/fonts/`, declared in pubspec.
- Website elements restyled with these tokens:

| Web element | Mobile |
|---|---|
| Hang tag (chamfered corners, punched hole, stitch line, only shadow, swing once) | `HangTag` widget, `CustomPainter` shape, `lifted` shadow, one swing on add/scan, cross-fade under reduce-motion |
| EAN-13 barcode on tag | `Ean13Barcode` painter from ported `ean13.dart` |
| Ownership chip | `OwnershipChip`: icon + label + colour (VERIFIED success, REJECTED dangerText, PENDING/UNVERIFIED inkMuted, BLOCKED inkSubtle) |
| "Verified" vs "Stated by the brand" figures | Always different icon + text, never colour alone |
| shadcn dialogs / toasts | Bottom sheets / `AppSnackbar` |
| Admin table | List rows (web already collapses to rows on phones) |

## 8. Screen mapping

| Web route | Flutter screen | APIs |
|---|---|---|
| `/` (signed out) | `WelcomeScreen` | — |
| `/login` | `LoginScreen` | POST /auth/login |
| `/register` | `RegisterScreen` | POST /auth/register |
| `/forgot-password` | `ForgotPasswordScreen` | POST /auth/forgot-password |
| `/reset-password`, `/verify-email` | Website (decision 7) | — |
| — (new, decision 14) | `ChangePasswordScreen` | POST /auth/change-password |
| `/wardrobe` | `WardrobeScreen` | GET /auth/me, GET /digital-cards/mine, POST /auth/resend-verification |
| `/scan` | `ScanScreen` | — (navigates to product) |
| `/products/[gtin]` | `ProductScreen` | GET /products/gtin/:gtin, GET /digital-cards/mine, POST /digital-cards |
| `/tags/[id]` | `TagScreen` | GET /digital-cards/:id, POST …/ownership/order-match, POST …/ownership/receipt, POST/DELETE …/share; story image from `WEB_APP_URL/t/<slug>/story` |
| `/t/[slug]` | Website (decision 8) | — |
| account menu | `AccountScreen` | POST /auth/logout |
| `/admin/products` | `AdminProductsScreen` | GET /products, GET /brands, DELETE /products/:id |
| `/admin/products/new`, `/[id]` | `AdminProductFormScreen` | GET /products/:id, GET /brands, POST/PATCH /products |
| `/admin/brands` | `AdminBrandsScreen` (+ form sheet) | GET/POST/PATCH/DELETE /brands |
| `/admin/import` | `AdminImportScreen` | POST /products/import?dryRun=, GET /products/import/template |
| `/admin/claims` | `AdminClaimsScreen` | GET /claims |
| `/admin/claims/[id]` | `AdminClaimScreen` | GET /claims/:id, GET /products/:id, GET /claims/:id/receipt, POST approve/reject |

## 9. Build order (one branch + commit per slice, pushed; ≤15 files / ≤400 lines each)

| # | Branch | Slice |
|---|---|---|
| 1 | `chore/project-setup` | ids `com.staka.app`, name STAKA, pubspec, lints, env, fonts, design tokens, l10n, blank app boots |
| 2 | `feat/core-network` | Result/Failure, dio client, error parser + mapper, interceptors, tests |
| 3 | `feat/core-session` | token storage, session controller, single-flight refresh, tests |
| 4 | `feat/shared-foundations` | AppScaffold, AppButton, AppLoader, AppEmptyState, AppErrorState |
| 5 | `feat/shared-inputs` | AppTextField, AppSnackbar, form helpers |
| 6 | `feat/app-shell-router` | router, guards, bottom-nav shell, Welcome screen |
| 7 | `feat/auth-sign-in` | Login + Register |
| 8 | `feat/auth-password` | Forgot password + Change password + Account/sign out |
| 9 | `feat/shared-hang-tag` | HangTag, Ean13Barcode, OwnershipChip (+ goldens) |
| 10 | `feat/wardrobe-list` | Wardrobe + verify-email banner |
| 11 | `feat/scan-barcode` | Scan (camera + typed) |
| 12 | `feat/products-detail` | Product by GTIN + add to wardrobe |
| 13 | `feat/tags-ownership` | Tag screen + ownership panel |
| 14 | `feat/tags-sharing` | Share panel |
| 15–19 | `feat/admin-*` | products list → product form → brands → import → claims |

Each slice: types → contract → data → state → widgets → screen → route; four
UI states; light + dark; l10n strings; unit tests (mapper, notifier) + widget test.

## 10. What I cannot verify myself

Physical-device runs (camera, file pickers, share sheet) and iOS builds (needs a Mac).
I will run `flutter analyze`, `dart format`, tests, and an Android emulator build if
one is available here, and list each device check for you to do.

## 11. Questions for approval

- **P2-1 Flutter version.** Upgrade this PC to the current Flutter stable (`flutter upgrade`, changes your global SDK; you'd run it or approve me running it) so the latest packages work? Or stay on 3.35.2 and pin older package versions (some then fall foul of the guide's "no release in 12 months" rule)? *Recommended: upgrade.*
- **P2-2 Unused tokens.** OK to drop the tier colours and wallet gradient from the `lib/core/design` copy?
- **P2-3 Branch flow.** Nobody merges between my slices, so I'll branch each slice from the previous one (stacked) and push. Do you also want me to open a GitHub PR per slice (`gh`), or only push branches?
- **P2-4 CI.** Add a GitHub Actions workflow in `mobile/` (format, analyze, test) in slice 1? *Recommended: yes.*
