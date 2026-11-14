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
- [ ] **Temporary `PendingScreen` routes still to replace** (delete `app/pending/` + `pendingScreenTitle` ARB key when empty): adminHome (15+)
- [ ] Follow-up: Linux golden baselines for CI (needs Docker or a CI job)
- [ ] Auth: login, register, forgot, reset, verify email, logout, session restore, route guards
- [x] Slice 10 `feat/wardrobe-list`: core models + DTOs/mappers, Wardrobe tab (welcome header, verify-email banner + resend, Verified / Waiting for proof, empty state, pull-to-refresh, error + retry), RequestState moved to core. 11 tests + 4 goldens + 2 live tests
- [x] Wardrobe refreshes after a tag is added elsewhere (`cardsRevisionProvider`); bump it after ownership/share changes too
- [x] Slice 11 `feat/scan-barcode`: parseScan port, camera (mobile_scanner, EAN-13/8, UPC-A/E, QR; runs only while visible; blocked/unavailable/off states), typed-number form, product route stub, iOS camera text. 14 tests + 4 goldens. **Camera not yet tried on a real phone**
- [ ] Product detail + add to wardrobe
- [ ] Tag detail: ownership (order match, receipt upload)
- [ ] Tag detail: sharing
- [ ] Public shared tag
- [ ] Admin: products list/filter/delete
- [ ] Admin: product create/edit + preview
- [ ] Admin: brands
- [ ] Admin: CSV import
- [ ] Admin: claims queue + detail + receipt + approve/reject

## Phase 4 — Backend sync
- [ ] Only approved changes (none required so far)

## Phase 5 — Verification
- [ ] Every flow end-to-end on device against real API; checklist table
- [ ] Edge cases: offline, slow, expired session, invalid input, empty, 5xx
- [ ] Unit + widget tests; goldens for shared widgets

## Phase 6 — Release readiness
- [ ] Icon, splash, name, ids, permissions text, signing, release steps, README

## Session log (newest first, one line each)
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
