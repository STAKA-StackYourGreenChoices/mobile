# Phase 4 — Backend sync

Date: 2026-11-15. Rule (`files/app_build_prompt.md`): apply only backend
changes the user approved, keep them backward compatible with the website,
and document each one.

## 1. Changes applied

**None.** No backend change was approved, and the app needs none:

- Decision 7: email links keep opening the website, so no web or API change.
- S7: the `/health` fix was declined.
- Phase 1 §e: "none needed for the core flows".

`api/`, `web/`, `infra/` and `files/` were not modified by this work:

- `api/` is on `main` at `5c1c4d6` (2026-11-08), the same as `origin/main`.
- `web/` is on `feat/full-app` at `992cba6` (2026-11-08), the same as origin.

Both are older than the Phase 1 analysis (2026-11-14), so the contract the
app was built against is still current. The website's behaviour is unchanged
because nothing it talks to changed.

Note: `api/package-lock.json` is untracked (14 Nov). The repo uses pnpm. It
was not created by a change of the app's; left untouched for the user.

## 2. Contract check: every call the app makes

Paths and methods come from the API controllers (`api/src/**/*.controller.ts`),
which match `api/openapi.json`. All 25 calls exist, with the same method, path,
body and query. The live tests exercise them against the running API
(16/16 pass).

| App call | API route | Live-tested |
|---|---|---|
| POST `/auth/register`, `/auth/login`, `/auth/refresh`, `/auth/logout` | auth.controller | yes |
| POST `/auth/forgot-password`, `/auth/change-password`, `/auth/resend-verification`; GET `/auth/me` | auth.controller | yes |
| GET `/digital-cards/mine`, `/digital-cards/:id`; POST `/digital-cards` | digital-cards.controller | yes |
| POST `/digital-cards/:cardId/ownership/order-match`, `/ownership/receipt` (multipart `file`) | ownership.controller | yes |
| POST / DELETE `/digital-cards/:cardId/share` | sharing.controller | yes |
| GET `/products`, `/products/:id`, `/products/gtin/:gtin` | products.controller | yes |
| POST `/products`, PATCH / DELETE `/products/:id` | products.controller | yes |
| POST `/products/import?dryRun=` (multipart `file`), GET `/products/import/template` | products.controller | yes |
| GET `/brands`; POST `/brands`; PATCH / DELETE `/brands/:id` | brands.controller | yes |
| GET `/claims`, `/claims/:id`, `/claims/:id/receipt`; POST `/claims/:id/approve`, `/reject` | ownership.controller | yes |

Website endpoints the app does not call, by decision:

- `/auth/reset-password` and `/auth/verify-email` stay on the website
  (decision 7).
- `/public/tags/:slug` stays on the website (decision 8). The live sharing
  test still checks it.

API endpoints neither the website nor the app uses: `/orders*`, `/users*`,
`/products/sku/:sku`, `/digital-cards/user/:userId`, and GET
`/digital-cards/:cardId/ownership`. The app reads ownership from the tag
itself, as the website does.

## 3. Known API quirks the app handles without a backend change

| Quirk | App handling |
|---|---|
| Catalog image URLs are absolute website addresses (`http://localhost:3000/catalog-images/…`), which a phone can't reach | `resolveImageUrl` re-points `/catalog-images/*` at `WEB_APP_URL`. The product form edits the stored address unchanged (S16) |
| `/health` answers 401 (HealthController lacks `@Public()`) | Not used by the app. Declined in S7 |
| The receipt file needs the admin's token, so it can't open in a browser tab | The app fetches the bytes with the token and shows them in-app (S19) |

## 4. Optional backend changes (not applied; each needs the user's OK)

1. **Make `/health` public**: one decorator in `api/src/health/health.controller.ts`.
   It fixes the API Dockerfile healthcheck. No effect on the app or the website.
2. **Push notifications when a claim is approved or rejected**: needs a
   device-token endpoint, Firebase (FCM / APNs) and a send hook in the claim
   decision. A new feature that the website doesn't have. Recommend later, if at all.
3. **Rate limiting on the auth endpoints** (`@nestjs/throttler`): security
   hardening that applies to the website too. The app would show the
   API's 429 text as is ("ThrottlerException: Too Many Requests"). A
   friendlier line for 429 would be a small app change, made alongside it.
