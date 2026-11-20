# Phase 1 — Deep analysis (findings)

Source: `api/` @ `main` (5c1c4d6), `web/` @ `origin/feat/full-app` (992cba6).
When building a feature, re-read only the web files listed for it in §2.

## a) Tech stack

**Backend (`api/`)**: NestJS 11, Prisma 6, PostgreSQL 16, class-validator
(`whitelist` + `forbidNonWhitelisted`: unknown JSON fields are rejected with 400),
passport-jwt, bcryptjs, nodemailer (logs emails to console when `SMTP_URL` is
empty), multer (memory) for uploads stored on disk under `UPLOADS_DIR`,
csv-parse, Swagger at `/docs`, optional Sentry. Port 7070. No global prefix,
no API versioning, no rate limiting.

**Web (`web/` feat/full-app)**: Next.js 16 App Router, React 19, Server Actions,
Tailwind 4 + shadcn/radix, zod 4, lucide icons, sonner toasts, @zxing for camera
scanning, `next/og` for share images. All API calls are server-side (`lib/api.ts`);
tokens sit in httpOnly cookies `staka_at` / `staka_rt`; `proxy.ts` refreshes
30 s before expiry and guards routes.

**Product**: STAKA. Shopper scans a garment barcode (GTIN) → sees product +
footprint (carbon g CO₂e, recyclability %, verified-by certifier or brand-stated)
→ adds it to their wardrobe as a digital "tag" (DigitalCard) → proves ownership
(order match or receipt upload, max 5 receipts) → once verified, can share a
public link `/t/<slug>`. Admins manage products, brands, CSV import, and review
receipt claims.

## b) Feature inventory

Roles: `USER` (shopper), `ADMIN` (sees everything a shopper sees + admin nav).
Guest-only: login, register, forgot-password. Public: `/`, reset-password,
verify-email, `/t/<slug>`. Everything else needs a session; `/admin/*` needs ADMIN.

| # | Web route | What it does | Web files to read when building |
|---|---|---|---|
| 1 | `/` | Marketing landing (rail of hang tags, how it works, FAQ, CTA). Signed in → "Open my wardrobe" | `app/page.tsx`, `components/landing/*` |
| 2 | `/login` | Email + password. `?next=` redirect (same-site only). 401 → "That email and password don't match an account…" | `app/(auth)/login/*`, `(auth)/actions.ts` |
| 3 | `/register` | Name (1–100), email, password (8–128). 409 → field error on email. Success → `/wardrobe?welcome=1` | `app/(auth)/register/*` |
| 4 | `/forgot-password` | Email → always same success copy (link works once, expires 1 h) | `app/(auth)/forgot-password/*` |
| 5 | `/reset-password?token=` | New password + confirm (must match). 401 → link expired/used | `app/(auth)/reset-password/*` |
| 6 | `/verify-email?token=` | Confirms email. 401 → link expired/used | `app/(auth)/verify-email/*` |
| 7 | `/wardrobe` | Welcome header, verify-email banner (resend), counts, two grids: Verified / Waiting for proof, empty state → Scan | `app/(shopper)/wardrobe/*` |
| 8 | `/scan` | Camera (EAN-13, EAN-8, UPC-A, UPC-E, QR incl. GS1 Digital Link) + "type the number" form. Parses with `lib/scan.ts` → `/products/<gtin>` | `app/(shopper)/scan/*`, `lib/scan.ts` |
| 9 | `/products/[gtin]` | Hang tag, brand, name, description, "What the figures mean", About brand. States: invalid (400), unknown (404), found; "In your wardrobe → View your tag" or "Add to wardrobe" | `app/(shopper)/products/[gtin]/*` |
| 10 | `/tags/[id]` | Owned tag: `?added=1` banner, ownership panel (VERIFIED / PENDING / BLOCKED / UNVERIFIED+REJECTED → order match or receipt upload ≤5 MB jpeg/png/webp/pdf), share panel (locked until verified; create link, copy, native share, download story image, stop sharing with confirm) | `app/(shopper)/tags/[id]/*` |
| 11 | `/t/[slug]` | Public shared tag (no sign-in). Not shared → "This tag isn't shared any more" | `app/t/[slug]/*`, `lib/tag-image.tsx` |
| 12 | `/admin/products` | Table, search (`q`→`search`), brand filter, pagination (20), delete with confirm | `app/admin/products/*` |
| 13 | `/admin/products/new`, `/[id]` | Product form + live hang-tag preview. Validation in `admin/actions.ts` | `app/admin/products/product-form.tsx` |
| 14 | `/admin/brands` | List with product counts; create/edit dialog; delete | `app/admin/brands/*` |
| 15 | `/admin/import` | 3 steps: choose CSV (≤2 MB, .csv) → dry run report → import. Template download | `app/admin/import/*` |
| 16 | `/admin/claims` | Queue by status (PENDING default / APPROVED / REJECTED), paginated | `app/admin/claims/page.tsx` |
| 17 | `/admin/claims/[id]` | Claim + history + receipt view (image/PDF) + approve / reject (reason 3–500) | `app/admin/claims/[id]/*` |
| 18 | Account menu | Name, sign out (revokes refresh token; failure still signs out) | `components/account-menu.tsx`, `app-header.tsx`, `lib/nav.ts` |

Nav: Wardrobe, Scan; ADMIN adds Products, Brands, Import, Claims.
Not in web (exists in API only): change password, profile edit (`PATCH /users/:id`),
orders (`/orders`), users admin, `GET /digital-cards/user/:userId`.

## c) API map (every call the web makes)

Auth header: `Authorization: Bearer <accessToken>` unless marked public.
Errors: Nest shape `{ statusCode, message: string | string[], error }`.

| Method & path | Auth | Body / query | Returns | Used by |
|---|---|---|---|---|
| POST `/auth/register` | public | `{name,email,password}` | `AuthTokens` | 3 |
| POST `/auth/login` | public | `{email,password}` | `AuthTokens` | 2 |
| POST `/auth/refresh` | public | `{refreshToken}` | `AuthTokens` (refresh token **rotates, single use**) | proxy |
| POST `/auth/logout` | public | `{refreshToken}` | — | 18 |
| POST `/auth/forgot-password` | public | `{email}` | 200 same either way | 4 |
| POST `/auth/reset-password` | public | `{token,newPassword}` | — / 401 | 5 |
| POST `/auth/verify-email` | public | `{token}` | — / 401 | 6 |
| POST `/auth/resend-verification` | user | — | `{message}` ("Email is already verified" special-cased) | 7 |
| GET `/auth/me` | user | — | `User` | 7, layouts |
| GET `/products/gtin/:gtin` | user | — | `Product` / 400 bad check digit / 404 | 9 |
| GET `/digital-cards/mine` | user | — | `DigitalCard[]` | 7, 9 |
| POST `/digital-cards` | user | `{gtin}` | `DigitalCard` (existing one if already owned) | 9 |
| GET `/digital-cards/:id` | user | — | `DigitalCard` / 404 | 10 |
| POST `/digital-cards/:id/ownership/order-match` | user | — | `Ownership` / 404 no paid order | 10 |
| POST `/digital-cards/:id/ownership/receipt` | user | multipart `file` (≤5 MB; jpeg/png/webp/pdf) | `Ownership` / 400 / 403 (5 used) / 409 | 10 |
| POST `/digital-cards/:id/share` | user | — | `{slug,createdAt}` | 10 |
| DELETE `/digital-cards/:id/share` | user | — | 204 | 10 |
| GET `/public/tags/:slug` | public | — | `PublicTag` / 404 | 11 |
| GET `/products` | user | `search, brandId, page=1, limit=20` | `ProductPage` | 12 |
| GET `/products/:id` | user | — | `Product` | 13, 17 |
| POST `/products` · PATCH `/products/:id` | admin | product body (see below) | `Product` / 409 dup gtin/sku / 400 gtin | 13 |
| DELETE `/products/:id` | admin | — | 204 | 12 |
| GET `/brands` | user | — | `BrandSummary[]` | 12–14 |
| POST `/brands` · PATCH `/brands/:id` | admin | `{name, description?, logoUrl?}` (null clears on edit) | `BrandSummary` / 409 | 14 |
| DELETE `/brands/:id` | admin | — | 204 | 14 |
| POST `/products/import?dryRun=` | admin | multipart `file` CSV | `ImportReport` | 15 |
| GET `/products/import/template` | admin | — | CSV file | 15 |
| GET `/claims` | admin | `status, page, limit(≤100)` | `ClaimPage` | 16 |
| GET `/claims/:id` | admin | — | `ClaimDetail` | 17 |
| GET `/claims/:id/receipt` | admin or uploader | — | file bytes | 17 |
| POST `/claims/:id/approve` | admin | — | — | 17 |
| POST `/claims/:id/reject` | admin | `{reason}` 3–500 | — | 17 |

Product body: `{name(1–200), brandId(uuid), gtin(8|12–14 digits), sku(1–64),
description?(≤2000|null), imageUrl?(http(s)|null), sustainabilityInfo?{carbonScoreGrams int≥0,
recyclabilityPercent 0–100, verified bool, certifierName? (required if verified, ≤200)}}`.

Response types: copy from `web/lib/types.ts` on feat/full-app (User, Brand,
BrandSummary, SustainabilityInfo, Product, ProductPage, Ownership, DigitalCard,
ShareLink, PublicTag, Claim, ClaimPage, ClaimDetail, ImportReport, AuthTokens).
Enums: Role USER|ADMIN; OwnershipStatus UNVERIFIED|PENDING|REJECTED|BLOCKED|VERIFIED;
ClaimMethod ORDER_MATCH|RECEIPT; ClaimStatus PENDING|APPROVED|REJECTED.

Client helpers to port: `lib/scan.ts` (parseScan), `lib/format.ts` (formatCarbon,
carbonParts, formatDate en-GB "14 Nov 2026", displayGtin strips leading 0),
`lib/ean13.ts` (barcode bars), `lib/images.ts` (`/catalog-images/*` URLs are
served by the **web** host → rewrite to `WEB_APP_URL` on mobile).

## d) Authentication

- Access JWT (`JWT_EXPIRATION` 15m), payload `{sub, role, exp}`. Refresh token is an
  opaque 96-hex string, 7 days, stored in DB, **rotated on every refresh and valid
  once**. Change/reset password deletes all refresh tokens.
- Login fails with 401 for wrong password **or** non-ACTIVE user.
- Mobile needs: tokens in `flutter_secure_storage`; dio interceptor adds Bearer;
  on 401 (or `exp` within 30 s) do **one shared in-flight refresh** (concurrent
  requests must await the same refresh, otherwise rotation logs the user out);
  refresh failure → clear storage → login. Logout: POST `/auth/logout`, ignore errors, clear.
- Already mobile-friendly: Bearer header + refresh in JSON body. No cookie work needed.

## e) Backend changes for mobile

| Change | Status | Why |
|---|---|---|
| None needed for the core flows | — | Bearer + body refresh tokens already work for a native client; CORS is irrelevant |
| Email links (`/verify-email`, `/reset-password`) point at `WEB_APP_URL` | OPTIONAL | Either let them open in the browser (zero change) or add App Links / Universal Links, which needs `/.well-known/assetlinks.json` + `apple-app-site-association` served by **web** (web change) |
| Push notifications (claim approved/rejected) | OPTIONAL | Not in web; would need a device-token endpoint + FCM |
| Rate limiting on auth endpoints | OPTIONAL | Security hardening, applies to web too |

## f) Third-party services

| Service | Web/API usage | Mobile needs |
|---|---|---|
| SMTP (nodemailer) | API sends verify/reset emails | Nothing |
| Sentry | API, optional | Optional `sentry_flutter` + DSN if wanted |
| Google Fonts | Web heading font at runtime | Mobile fonts must be vendored (guide §6.2) → need .ttf files |
| Camera barcode (@zxing) | Web scan | Native scanner package + camera permission strings |
| Firebase Analytics/Crashlytics | **Not used anywhere** | Guide §2 mandates it → needs a Firebase project (user decision) |
| Payments, maps, social login, SMS | None | None |

## g) Questions

See `DECISIONS.md` → "Open".
