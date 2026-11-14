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
- [ ] Slice 5 `feat/shared-inputs`: AppTextField, AppSnackbar, form validators
- [ ] Follow-up: Linux golden baselines for CI (needs Docker or a CI job)
- [ ] Auth: login, register, forgot, reset, verify email, logout, session restore, route guards
- [ ] Wardrobe (+ verify-email banner)
- [ ] Scan (camera + typed number)
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
- 2026-11-14 — Slice 4 done: 53 tests + 4 goldens pass. Loading buttons keep their colour (only ignore taps). Goldens excluded from CI (Windows baselines).
- 2026-11-14 — Slice 3 done, 42 tests pass. Tests caught a refresh-before-every-request bug for undecodable tokens; fixed + regression test. Local API not running, so no live check yet.
- 2026-11-14 — Slice 2 done: network core + 20 passing tests. Not yet exercised against the running API (first real call comes with sign-in, slice 7).
- 2026-11-14 — Slice 1 done: scaffold regenerated for Flutter 3.50, migrated to material_ui/cupertino_ui, analyze clean, 2 tests pass. `BootScreen` is temporary until slice 6.
- 2026-11-14 — P2 answers recorded, plan approved; waiting on user's `flutter upgrade`.
- 2026-11-14 — Answers recorded; root CLAUDE.md added; Phase 2 plan written; found Flutter 3.35.2 too old for current packages (P2-1).
- 2026-11-14 — Phase 1 analysis done; handoff docs created; 16 questions sent to user. No code yet.
