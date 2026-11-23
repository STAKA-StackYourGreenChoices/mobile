# Progress

Tick items as they land. One feature = one vertical slice (guide §4).
Status: `[ ]` todo · `[~]` in progress · `[x]` done and verified against the real API.

## Phase 1 — Analysis
- [x] Stack, feature inventory, API map, auth, backend changes, third parties → `PHASE1_ANALYSIS.md`
- [x] Questions → `DECISIONS.md`
- [x] User answered questions (all 16, see `DECISIONS.md`)

## Phase 2 — Architecture & plan (needs approval)
- [x] Folder structure, packages, networking, storage, routing, env config, theming → `PHASE2_PLAN.md`
- [x] Screen mapping table (web route → Flutter screen → APIs)
- [x] Build order (19 slices)
- [x] User approved plan + answered P2-1..P2-4
- [x] User upgraded Flutter (3.50.0 / Dart 3.14.0)

## Phase 3 — Implementation (order to be confirmed in Phase 2)
- [x] Slice 1 `chore/project-setup`: ids/name, pubspec, very_good_analysis, `core/design`, fonts, l10n, env config, CI, boot screen + tests (router shell = slice 6)
- [x] Slice 2 `feat/core-network`: Failure/Result, error parser + mapper, dio client, request-id/log/retry interceptors, 18 unit tests
- [x] Slice 3 `feat/core-session`: secure token storage, session controller, auth interceptor + single-flight refresh, User model/DTO (22 new tests)
- [x] Slice 4 `feat/shared-foundations`: AppScaffold, AppButton, AppLoader, AppEmptyState, AppErrorState (+ FeedbackMessage), 11 widget tests, 4 goldens (light/dark)
- [x] Slice 5 `feat/shared-inputs`: AppTextField + password toggle, AppFormAlert, AppSnackbar, Validators (web messages), 12 tests, 2 goldens
- [x] Slice 6 `feat/app-shell-router`: go_router, session guards, bottom-nav shell (Admin tab for admins), Welcome, launch + unreachable screens, resume → refreshUser
- [x] Slice 7 `feat/auth-sign-in`: Login + Register (feature layers, web copy/validation), `SignedIn.isNewAccount`, 11 tests + 4 goldens, **live test passes against the real API** (register, 409, 401, login, /auth/me, refresh rotation, logout revoke)
- [x] Slice 8 `feat/auth-password`: Forgot password (web copy + 'link opens the website' note), Account tab (name, email, change password, sign out), Change password (re-signs this phone in; fallback sign-in alert), 15 tests + 6 goldens, live tests pass. Fixed router refresh racing `pop()`
- [x] Slice 9 `feat/shared-hang-tag`: HangTag (shape, hole, stitching, shadow, string, one swing / fade under reduce-motion), TagImage, OwnershipChip, carbon/GTIN formatters, Welcome hero tag (bundled seeded-catalog SVG). EAN-13 drawing skipped: only the website's marketing page uses it. 10 tests + 4 goldens; fixed 200%-text overflow in the photo placeholder and the tag's merged screen-reader label
- [x] Temporary `PendingScreen` routes all replaced; `app/pending/` and `pendingScreenTitle` deleted (slice 19)
- [ ] Follow-up: Linux golden baselines for CI (needs Docker or a CI job)
- [x] Auth: login, register, forgot, logout, session restore, route guards (slices 3, 6–8); reset password + verify email happen on the website (decision 7)
- [x] Slice 10 `feat/wardrobe-list`: core models + DTOs/mappers, Wardrobe tab (welcome header, verify-email banner + resend, Verified / Waiting for proof, empty state, pull-to-refresh, error + retry), RequestState moved to core. 11 tests + 4 goldens + 2 live tests
- [x] Wardrobe refreshes after a tag is added elsewhere (`cardsRevisionProvider`); bump it after ownership/share changes too
- [x] Slice 11 `feat/scan-barcode`: parseScan port, camera (mobile_scanner, EAN-13/8, UPC-A/E, QR; runs only while visible; blocked/unavailable/off states), typed-number form, product route stub, iOS camera text. 14 tests + 4 goldens. **Camera not yet tried on a real phone**
- [x] Product detail + add to wardrobe (slice 12)
- [x] Tag detail: ownership (slice 13)
- [x] Slice 14 `feat/tags-sharing`: share panel (locked until verified; create link, copy, system share sheet, story image via share sheet, see what others see, stop sharing with confirm). 8 tests + 2 goldens. live sharing test passes (admin approval → share → public page → stop)
- [x] Public shared tag: stays on the website by design (decision 8); "See what others see" opens it
- [x] Slice 15 `feat/admin-products-list`: Admin hub (Products / Brands / Import / Claims with the website's page descriptions), products list (search, brand filter sheet, Clear, "Showing 1–n of N", rows with thumbnail + brand, barcode + compact figures badge, infinite scroll 20 at a time, load-more retry, empty/filtered-empty/error states, pull to refresh). Shared `SustainabilityBadge`. 16 tests + 6 goldens + 1 live test (11/11 live)
- [x] Slice 16 `feat/admin-product-form`: add / edit product (website fields, hints, limits and zod messages; brand picker with "Add it on the Brands page"; figures switch that can't remove saved figures; verified + certifier; live hang-tag preview), save errors split like the website (409 code taken / 400 bad check digit on the field), "Product added" opens the new product, "Changes saved" refreshes the heading, delete with confirm dialog that keeps the API's refusal, 404 page. List reloads after any change. 25 tests + 4 goldens + 1 live test (12/12 live)
- [x] Slice 17 `feat/admin-brands`: brands page (name, description, "{n} products" opening the products list filtered to that brand, Edit / Delete), add / edit in a bottom sheet (website fields, rules, 409 → "A brand with this name already exists" on the name), delete dialog (brand with products: "still has products" + See its products; otherwise confirm, API refusal kept), empty / error / pull to refresh. Products list takes `?brand=`; brand filter options and both lists reload after any catalog change. 14 tests + 4 goldens + 2 live tests (14/14 live)
- [x] Slice 18 `feat/admin-import`: CSV import in the website's three steps (choose a .csv with the file picker, check = dry run, review with the four numbers / new brands / rows to skip, import, done summary), the website's file checks before sending (not .csv, over 2 MB, empty), API refusals above the step, template via the share sheet, "What the file needs". Lists reload after a real import. 10 tests + 6 goldens + 1 live test (15/15 live; live barcodes made collision-free across parallel test files)
- [x] Slice 19 `feat/admin-claims`: claims queue (To review / Approved / Rejected tabs with the count, per-tab empty states, infinite scroll 20 at a time), review page (receipt photo with tap for full size, or PDF card; what to check; shopper; hang tag), approve, reject with a typed reason or the website's four common ones, uploads-left / last-upload notes, conflict when already reviewed elsewhere, decided summary + every claim for the piece, order-match claims, 404 page. Full-screen receipt viewer: pinch-zoom photo or in-app PDF (`pdfx`). 16 tests + 6 goldens + 1 live test (16/16 live)
- [x] Admin: CSV import (slice 18)
- [x] Admin: claims queue + detail + receipt + approve/reject (slice 19)

## Phase 4 — Backend sync
- [x] Only approved changes: none approved, none applied; `api/` and `web/` unchanged since 2026-11-08 (report: `PHASE4_BACKEND_SYNC.md`)
- [x] Contract check: all 25 app calls match the API controllers and `openapi.json`; all are live-tested
- [x] Approved and applied: attempt limits on login / change-password / forgot-password / resend-verification (api branch `feat/auth-attempt-limits`), app words 429 itself (PHASE4 §1.1–1.2). `/health` fix and push notifications not requested

## Phase 5 — Verification
- [x] Every flow on an Android 15 phone against the real API + website; checklist table in `PHASE5_VERIFICATION.md`
- [x] Edge cases on the phone: offline (in app + at launch), slow (proxy), 500, revoked/expired session, 429, empty, unknown barcode
- [x] 316 widget/unit tests (64 goldens), 17 live, 2 device scripts (`integration_test/`)
- [x] Fixed on the phone: story image download (webDioProvider), bottom sheets over the tab bar
- [ ] Not done: iOS (needs a Mac), TalkBack, release build (Phase 6)

## Phase 6 — Release readiness
- [x] Scope cut by the user (2026-11-15): no Play / App Store publishing and no iOS for now
- [x] App icon: website hang-tag mark, cream on forest800; legacy + round + adaptive + Android 13 themed (`tool/make_app_icons.py`)
- [x] Splash: Android 12+ system splash and older launch_background, then the Flutter launch screen in the same green (`StakaMark`, tokens `splash`/`onSplash`, 2 goldens)
- [x] Name STAKA, id com.staka.app confirmed (label, applicationId, namespace, Kotlin package, app title, iOS bundle id)
- [x] README rewritten (setup, settings, running against local API, tests, builds, icons, architecture)
- [x] Release APK builds (72.8 MB, debug-signed) and works on the phone against the local API over http
- [ ] Next: talk with the user about hosting so the app works on a friend's phone

## V2 — M1 Identity (plan: `D:\Additional Project\plans\mobile\PLAN.md`)
`[~]` below = built and tested with fakes; not yet run against a real API (the friends' API needs the V2 endpoints).
- [~] `chore/v2-foundation`: version 2.0.0+2, V2 decisions (Account sections landed with the next two slices)
- [~] `feat/phone-otp-sign-in` (V2-1): welcome → phone → code → name; phone-only accounts; `AppOtpField`
- [~] `feat/account-sign-in-methods` (V2-1): Account "How you sign in": add/change/remove phone, add email, set first password
- [~] `feat/account-data` (V2-10): Account "Your data": download (share sheet), delete with password or texted code → welcome
- [ ] M1 check: USB phone run against the local API once it has the V2-1/V2-10 endpoints; V2-11 performance check (200-piece wardrobe, 1,000 products) needs the API's 1,000-product seed
- [x] Arham's go-ahead for M2 (2026-11-23)

## V2 — M2 Brands run themselves
- [x] `refactor/manage-scope` (V2-12): `features/admin` → `features/manage`, `ManageScope` threaded through data sources, providers and screens; no behaviour change, goldens unchanged (only moved)
- [~] `feat/brand-apply` (V2-12): Account → For brands → intro, 3-step application (claim a listed brand, files), status cards, edit and resubmit
- [ ] `feat/brand-portal`, `feat/brand-claims`, `feat/claim-dispute`, `feat/admin-brands-disputes`, `feat/product-variants`, `feat/catalog-variants`, `feat/wardrobe-share`, `feat/share-channels`

## Session log (newest first, one line each)
- 2026-11-23 — `feat/brand-apply`: brand sign-up form + application status. 396 tests pass; Account goldens updated for the new "For brands" section. Fakes only.
- 2026-11-23 — M2 started: `refactor/manage-scope` (admin code → `features/manage/` with `ManageScope`). 377 tests pass, no golden changed.
- 2026-11-23 — M1 slices built: phone sign-in, Account sign-in methods, Your data (export + delete). 372 tests pass. Fixed a V1 bug: after a server error on a field (wrong current password, taken email) the form could not be sent again. Not yet run against a real API.
- 2026-11-15 — Phase 6 (cut-down): icon, splash, name/id, README; 318 tests pass; release APK checked on the phone. Next: hosting talk.
- 2026-11-15 — Phase 5 done on Android: device scripts + hand checks + edge cases; 2 bugs fixed; report `PHASE5_VERIFICATION.md`. Waiting for the go-ahead for Phase 6.
- 2026-11-15 — Phase 4: auth attempt limits in api/ (55/55 e2e) + app 429 copy; 17/17 live tests pass 3× back to back. Phase 5 next.
- 2026-11-15 — Phase 4: no approved backend changes, so none applied; contract audit clean; three optional changes listed for the user.
- 2026-11-15 — Slice 19 done (all 19 slices): 248 tests + 64 goldens + 16 live tests pass, debug APK builds with `pdfx`. Phase 3 complete.
- 2026-11-15 — Slice 18 done: 232 tests + 58 goldens + 15 live tests pass (live suite 3× in a row), debug APK builds.
- 2026-11-15 — Slice 17 done: 222 tests + 52 goldens + 14 live tests pass, debug APK builds.
- 2026-11-15 — Slice 16 done: 208 tests + 48 goldens + 12 live tests pass, debug APK builds. User asked to be asked before slice 17.
- 2026-11-15 — Slice 15 done: 183 tests + 44 goldens + 11 live tests pass. Admin side started; delete moves to slice 16 with the edit page (where the website has it).
- 2026-11-15 — Slice 14 done: 167 tests + 38 goldens pass. Shopper side complete. Sharing live test then passed (10/10 live).
- 2026-11-15 — Slice 13 done: 159 tests + 36 goldens + 9 live tests pass. Live test leaves one tiny PNG receipt in api/uploads per run.
- 2026-11-15 — Slice 12 done: 149 tests + 32 goldens + 7 live tests pass. Tag screen is a stand-in until slice 13.
- 2026-11-14 — Slice 11 done: 136 tests + 28 goldens pass. Added mediaBackdrop colour tokens; dark camera backdrop lifted so the viewfinder has an edge.
- 2026-11-14 — Slice 10 done: 122 tests + 24 goldens + 5 live tests pass; real card JSON from the API maps correctly.
- 2026-11-14 — Slice 9 done: 111 tests + 20 goldens pass. Real shadows in tag goldens via withRealShadows.
- 2026-11-14 — Slice 8 done: 101 tests + 18 goldens + 3 live tests pass. Tests caught the router redrawing an old screen after pop (refresh on every session change); fixed with routingKeyOf.
- 2026-11-14 — Slice 7 done: 87 tests + 12 goldens pass; first live run against the user's local API passes. Field hints now muted (bodySmall), inputs golden re-baselined for that.
- 2026-11-14 — Slice 6 done: 76 tests + 8 goldens pass; first clickable navigation. Tabs not yet built show a temporary PendingScreen (tracked above).
- 2026-11-14 — Slice 5 done: 65 tests + 6 goldens pass. Noted: theme has no `disabledBorder`, so disabled fields use Material's darker default (left as is; user's theme).
- 2026-11-14 — Slice 4 done: 53 tests + 4 goldens pass. Loading buttons keep their colour (only ignore taps). Goldens excluded from CI (Windows baselines).
- 2026-11-14 — Slice 3 done, 42 tests pass. Tests caught a refresh-before-every-request bug for undecodable tokens; fixed + regression test. Local API not running, so no live check yet.
- 2026-11-14 — Slice 2 done: network core + 20 passing tests. Not yet exercised against the running API (first real call comes with sign-in, slice 7).
- 2026-11-14 — Slice 1 done: scaffold regenerated for Flutter 3.50, migrated to material_ui/cupertino_ui, analyze clean, 2 tests pass. `BootScreen` is temporary until slice 6.
- 2026-11-14 — P2 answers recorded, plan approved; waiting on user's `flutter upgrade`.
- 2026-11-14 — Answers recorded; root CLAUDE.md added; Phase 2 plan written; found Flutter 3.35.2 too old for current packages (P2-1).
- 2026-11-14 — Phase 1 analysis done; handoff docs created; 16 questions sent to user. No code yet.
