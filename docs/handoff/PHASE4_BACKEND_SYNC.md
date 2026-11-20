# Phase 4 — Backend sync

Date: 2026-11-15. Rule (`files/app_build_prompt.md`): apply only backend
changes the user approved, keep them backward compatible with the website,
and document each one.

## 1. Changes applied

The app itself needed no backend change. The user approved one optional
change (§4 item 3, 2026-11-15), which is applied:

### 1.1 Attempt limits on the auth routes (`api/`, branch `feat/auth-attempt-limits`)

**Why:** stop password guessing and email bombing. This protects the website
and the app alike.

**What:** a 429 once a limit is used up, with a readable message and a
`Retry-After` header (seconds):

| Route | Counted | Keyed on | Limit |
|---|---|---|---|
| POST `/auth/login` | wrong passwords only; a successful sign-in clears the count | caller address + email | 10 per 15 min |
| POST `/auth/change-password` | wrong current passwords only | signed-in user | 5 per 15 min |
| POST `/auth/forgot-password` | every request (each one sends an email) | caller address + email | 3 per 15 min |
| POST `/auth/resend-verification` | every request (each one sends an email) | signed-in user | 3 per 15 min |

The 429 body has Nest's usual shape: `{"statusCode":429,"message":"Too many
attempts. Please wait 15 minutes and try again.","error":"Too Many
Requests"}`. The wait is rounded up to whole minutes.

**Design notes:**

- **Not keyed on the address alone:** the website calls the API from its own
  server (`web/lib/api.ts` is `server-only`), so every website visitor has
  the same address. An address-only limit would let one visitor's mistakes
  block everyone.
- **Lockout trade-off:** because of that, someone using the website can lock
  another person's sign-in for 15 minutes by entering their email with wrong
  passwords. Called directly, the API locks only the caller's own address.
  Fixing this fully needs the website to pass on the visitor's address
  (a web change; not done).
- **Login counts failures only:** seeded-admin sign-ins in the live tests,
  and real users, never add up to a lockout.
- **Counts live in memory:** they are per API process and reset on restart.
  With several instances, move them to Redis.
- **Not limited:** `register` (a per-email key adds nothing there, and a
  per-address one would cap the whole website); `reset-password` and
  `verify-email` (their tokens are 32 random bytes and can't be guessed);
  `refresh` and `logout` (the tokens can't be guessed, and limiting refresh
  could sign people out).
- **No new dependency:** `@nestjs/throttler` counts every request and can't
  count only failures.

**Files** (all new except the last three):

- `src/auth/attempts/attempt-limiter.ts`: an in-memory fixed-window counter
  with a sweep.
- `src/auth/attempts/attempt-limit.ts`: the rule type and `AUTH_LIMITS`.
- `src/auth/attempts/attempt-limit.interceptor.ts`: applies a route's rule,
  sets `Retry-After`, and counts 401s or every request.
- `src/auth/attempts/limit-attempts.decorator.ts`: `@LimitAttempts(rule)`,
  plus the 429 in the OpenAPI spec.
- `src/auth/attempts/too-many-attempts.exception.ts`: the 429 and its
  message.
- `src/auth/attempts/attempt-limiter.spec.ts` and
  `test/auth-attempt-limits.e2e-spec.ts`: the tests.
- `src/auth/auth.controller.ts`: the four routes are decorated (changed).
- `src/auth/auth.module.ts`: `AttemptLimiter` is a provider (changed).
- `openapi.json`: regenerated; it gained only four `429` responses
  (changed).

**Backward compatibility:**

- No route, body or success response changed.
- The website needs no change: it shows the API's message for any error
  except a 401, so visitors see the 429 text as is.
- Legitimate use stays under the limits.

**Tests:**

- API e2e: 55/55 pass, 5 of them new (lockout with a 429 body and
  `Retry-After`, other emails unaffected, a success resets the count,
  reset-email limit, change-password, verification email).
- API unit: 3 new tests. One existing failure,
  `receipt-storage.service.spec.ts`, fails on `main` too: Windows path
  separators.
- The running local API was checked with `curl`: 10 × 401, then 429 and
  `Retry-After: 897`.

### 1.2 App side (`mobile/`)

- **429 is worded by the app:** it becomes `TooManyRequestsFailure` with
  `retryAfter`, and the app always uses its own copy, so a proxy's raw "Too
  Many Requests" never shows.
  - With a `Retry-After`: "Too many attempts. Please wait N minutes and try
    again.", the API's own words.
  - Without one: "Too many attempts. Please wait a few minutes and try
    again."
- **Affected screens:** sign-in, forgot password, change password and resend
  verification already go through `messageForFailure`, so they pick it up.
- **Never retried:** the retry interceptor retries only GETs on 502–504.
- **Tests:** parser, mapper and sign-in flow tests, plus a live test
  (`attempt_limits_live_test.dart`: a throwaway account, 10 wrong passwords,
  then a 429 with a 14–15 minute wait). The live suite passes 3 times back
  to back with no admin lockout.

### 1.3 Repos

- `web/`, `infra/` and `files/` were not modified.
- `api/` changed only on branch `feat/auth-attempt-limits`, cut from `main`
  at `5c1c4d6` (2026-11-08, the same as `origin/main`).
- `web/` is on `feat/full-app` at `992cba6` (2026-11-08), the same as origin.

Both are older than the Phase 1 analysis (2026-11-14), so apart from §1.1
the contract the app was built against is still current.

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
3. **Rate limiting on the auth endpoints**: **approved and applied
   2026-11-15** (see §1.1–1.2). Built as attempt limits, not
   `@nestjs/throttler`, so that sign-in counts wrong passwords only.
