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
| Current phase | **2 — Plan approved. Waiting for the user to run `flutter upgrade`** |
| Next action | When user says upgrade is done: check `flutter --version` (Dart ≥ 3.13), then Phase 3 slice 1 `chore/project-setup` per `PHASE2_PLAN.md` §9, branched from `docs/mobile-handoff` |
| Code written so far | None. Docs + `mobile/CLAUDE.md` + root `CLAUDE.md` |
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
