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
| Current phase | **3 — Implementation. Slices 1–4 done** |
| Next action | Slice 5 `feat/shared-inputs` (branch from `feat/shared-foundations`): AppTextField (label, hint, error, prefix/suffix, password toggle), AppSnackbar, form helpers matching the web's zod rules |
| Local API | Not running on this PC as of slice 3; nothing tested against the real backend yet. Ask the user to start it (infra Postgres + `api` dev server) before slice 7 |
| Toolchain | Flutter 3.50.0 / Dart 3.14.0. No emulator/phone attached. `flutter build apk --debug` works (first build ~13 min while Gradle 9.5 downloads). `flutter doctor` still warns about unaccepted Android licences (user's call) |
| Branches | `docs/mobile-handoff` → `chore/project-setup` → `feat/core-network` → `feat/core-session` → `feat/shared-foundations` (stacked, all pushed, nothing merged) |

## 2a. Code conventions already in place (reuse, don't reinvent)

- Errors: `core/error/failure.dart` (sealed `Failure`, `ApiFailure` subtypes by status), `result.dart` (`Ok`/`Err`, `fold`), `error_mapper.dart` (`messageForFailure(failure, l10n)`; API message wins, like the web).
- Network: `dioProvider` in `core/network/dio_client.dart`; wrap every datasource call in `guardApi(() => ...)` from `guard_api.dart`. Interceptors in `core/network/interceptors/`. Logging only via `AppLogger.debug`.
- Session: `sessionControllerProvider` (`core/auth/session_controller.dart`) → `SessionState` = `SessionRestoring | SignedIn(user) | SignedOut(sessionExpired) | SessionUnreachable`. Login/register call `.signIn(tokens:, user:)` with `AuthTokens.fromResponse(AuthResponseDto)`; account calls `.signOut()`; app resume calls `.refreshUser()`.
- Auth: `AuthInterceptor` adds Bearer; endpoints without a session pass `options: publicRequest()` (login, register, forgot/reset password, logout). Refresh is single-flight in `TokenRefresher`; never call `/auth/refresh` anywhere else.
- Shared models: `core/models/` (freezed), DTOs + mappers in `core/api_models/` (json_serializable, `createToJson: false` unless sending).
- Shared widgets (`lib/shared/widgets/`): `AppScaffold` (title, actions, `isScrollable: false` for list screens), `AppButton` (primary/secondary/ghost/destructive, `isLoading` + `loadingLabel`, `isExpanded`), `AppLoader`, `AppEmptyState`, `AppErrorState(failure, onRetryPressed)`. `context.colors` / `context.text` come from `core/design/app_typography.dart`.
- Goldens: tag `golden`, run `flutter test --tags golden` (`--update-goldens` only with the user's OK, guide §14). Baselines are Windows-rendered; CI runs `--exclude-tags golden`. Helpers: `test/helpers/pump_app.dart` (`pumpThemed`, `usePhoneScreen`), `golden.dart` (`loadAppFonts`).
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
