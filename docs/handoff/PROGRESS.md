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
- [ ] User approved plan + answered P2-1..P2-4

## Phase 3 — Implementation (order to be confirmed in Phase 2)
- [ ] Foundation: pubspec, lints, `core/design` (from `files/`), fonts, l10n, env config, router shell
- [ ] Core: dio client, auth interceptor + single-flight refresh, Failure/Result, error mapper, secure storage
- [ ] Shared widgets (guide §7.2 waves)
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
- 2026-11-14 — Answers recorded; root CLAUDE.md added; Phase 2 plan written; found Flutter 3.35.2 too old for current packages (P2-1).
- 2026-11-14 — Phase 1 analysis done; handoff docs created; 16 questions sent to user. No code yet.
