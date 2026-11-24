# Decisions

The user's answers here override every other doc, including `files/FRONTEND_GUIDE.md`.
New question → add under "Open"; when answered, move it to "Decided".

## Open

_None._

## Decided (2026-11-14)

| # | Topic | Decision |
|---|---|---|
| 1 | Website source | Match `web` branch `origin/feat/full-app` |
| 2 | Features | Only real STAKA features. API names in code (Product, Brand, DigitalCard, Ownership, Claim, ShareLink); website wording on screen ("tag", "piece", "wardrobe"). Drop guide §1 GreenTag vocab, wallet, tiers, tokens, wallet gradient |
| 3 | Design | Colours / fonts / spacing from `files/app_*.dart`; layouts, copy and hang-tag component from the website, restyled with those tokens |
| 4 | Fonts | Download Plus Jakarta Sans + Manrope .ttf from the official Google Fonts GitHub repo (OFL) into `mobile/assets/fonts/` |
| 5 | Admin | Include all admin screens (products, brands, CSV import, claims + receipt viewing) |
| 6 | Signed-out launch | Short welcome screen (what STAKA does, hang tag, Create account, Sign in) |
| 7 | Email links | Keep opening the website. No App Links. No web/api change |
| 8 | Shared tag links | Open the website. App creates / copies / shares / stops links only. No in-app public tag screen |
| 9 | Identity | Name **STAKA**, id **com.staka.app** (Android + iOS). Icon/splash in Phase 6 |
| 10 | Environments | Local dev only for now: emulator `http://10.0.2.2:7070`, physical phone = PC LAN IP. URLs via `--dart-define`; staging/prod later |
| 11 | Analytics | Skip for v1. Keep event-name constants so adding later is small |
| 12 | Extra packages | Approved: `mobile_scanner`, `image_picker`, `file_picker`, `share_plus`, `url_launcher`, a PDF viewer, `flutter_svg`, `path_provider` |
| 13 | Offline | Online only first, with no-connection states + retry. Drift wardrobe cache = later slice |
| 14 | Extras | Add **change password** (existing `POST /auth/change-password`). No profile edit |
| 15 | Git | Create branches in `mobile/`, commit per slice (Conventional Commits), **push** to origin |
| 16 | Root pointer | Added `D:\Additional Project\CLAUDE.md` → this handoff folder |
| P2-1 | Flutter SDK | **User runs `flutter upgrade` themself** and says when done. Do not start slice 1 before that; then confirm `flutter --version` shows Dart ≥ 3.13 |
| P2-2 | Design tokens | Drop tier colours + wallet gradient from the `lib/core/design` copy. `files/` untouched |
| P2-3 | PRs | Only push branches (stacked, one per slice). User opens/merges PRs. Do not run `gh pr create` |
| P2-4 | CI | Add GitHub Actions in `mobile/` (format, analyze, test) in slice 1 |
| S1 | Flutter 3.50 split | `package:flutter/material.dart` is deprecated in 3.50 → use **`material_ui`** and **`cupertino_ui`** (official, publisher flutter.dev). Import those, never `flutter/material.dart`. `GlobalWidgetsLocalizations` still comes from `flutter_localizations` (`show` only that) |
| S1 | Dart 3.14 syntax | Constructors are written `const new(...)` / `factory standard()` (lint `unnecessary_type_name_in_constructor`). `dart fix --apply` does it |
| S1 | Platform folders | `android/` + `ios/` regenerated from the Flutter 3.50 template (old ones needed Gradle 8.12; 3.50 needs ≥ 9.3.1). Desktop/web runners removed |
| S1 | Fonts | Static TTFs from the official Google Fonts API (fonts.gstatic.com), same files Google Fonts serves; OFL texts from github.com/google/fonts. Weights: Jakarta 400/600/700/800, Manrope 600/800; `tnum` present |
| S1 | Dart package name | `staka` (imports are `package:staka/...`) |
| S7 | API `/health` 401 | API bug (HealthController lacks `@Public()`; breaks the API Dockerfile healthcheck). User declined fixing it for now. Not needed by the app |
| S9 | EAN-13 drawing | Not built: the website draws barcodes only on its marketing landing page, which the app replaces (decision 6). Tags show "Barcode 890…" as text, like the website's tags. Ask before adding |
| S9 | Tag swing | 1.4 s (website keyframes), outside the motion tokens on purpose as the app's one signature moment (guide §6.3) |
| S11 | Colour tokens | Added `mediaBackdrop` (light `forest900`, dark `#1C271F`) + `onMediaBackdrop` (cream; 11.88 / 12.67) to the app copy of app_colors for the camera viewfinder; the original tokens had no dark-in-both-themes surface |
| S11 | Camera blocked copy | Website says "browser's site settings"; app says "Allow it for STAKA in your phone's Settings". No "open Settings" button (would need an extra package) |
| S13 | Receipt photos | Scaled to max 2400 px at JPEG quality 85 before upload (readable, well under 5 MB, and iOS returns JPEG not HEIC, which the API rejects). Source chooser sheet: Take a photo / Choose from your photos / Choose a PDF (web has one file input) |
| S14 | Share buttons | The phone's share sheet replaces the website's WhatsApp/X/Facebook/LinkedIn buttons (it lists every installed app). "Image for Instagram stories" downloads the website's story image and opens the share sheet with it |
| S15 | Admin tab | Opens a hub listing Products / Brands / Import / Claims with each page's website description (the website's `/admin` just redirects to products; a phone has no top nav for the other three) |
| S15 | Product pages | Infinite scroll, 20 per request, next page asked for when about five rows remain, replaces the website's Previous / Next. Count line reads "Showing 1–n of N products" |
| S15 | Brand filter | Bottom sheet instead of the website's select. If `/brands` fails the filter is hidden and the list still works |
| S15 | "Missing" figures badge | Uses the `warning` token: the app's design tokens have no ochre. Icon is an empty circle (Material has no dashed circle) |
| S15 | Folder | (V2: moved to `features/manage/<area>/`, see V2-12 Manage scope) Admin code lives in `features/admin/<area>/` (`hub`, `products`, later `brands`, `import`, `claims`), per PHASE2_PLAN §1 |
| S16 | Product form layout | Phone order like the website below `lg`: heading (+ Delete product on edit), tag preview, form; Save and Cancel full width at the bottom. Brand is a dropdown |
| S16 | Photo link on edit | The form edits the address exactly as stored (`EditableProduct.storedImageUrl`), not the phone-loadable one, so saving never rewrites seeded `localhost` catalog links |
| S16 | Unknown product id | Website shows the Next.js 404 ("This page could not be found."); the app shows that line and a "Products" button (the website's back link) |
| S16 | Build | `kotlin.incremental=false` in `android/gradle.properties` (Windows cross-drive Kotlin cache failure) |
| S17 | Brand add / edit | Bottom sheet instead of the website's dialog (keyboard-friendly on phones); same fields, copy and rules |
| S17 | Brand product count | Opens the products list filtered to the brand (`/admin/products?brand=<id>`, like the website's link). Back returns to the Admin hub |
| S18 | CSV file | Picked with the file picker (no drag and drop on a phone); checked by name, size and emptiness before sending, as the website does |
| S18 | Template download | Fetched with the admin's token, then handed to the share sheet (Save to Files / Drive / email) as `staka-products-template.csv`; failure shows the website's template message |
| S18 | Import layout | Stepper shows numbers only (as the website on phones); the skipped-rows table becomes stacked cards (Line, Barcode, What to fix) |
| S19 | PDF viewer | `pdfx` (the phone's own PDF renderer) instead of `pdfrx`: pdfrx's `pdfium_dart` build hook needs a C compiler and broke every `flutter test` run on this PC |
| S19 | Receipt viewer | Opens in the app (pinch-zoom photo, scrollable PDF) instead of the website's new browser tab; the receipt is fetched with the admin's token |
| S19 | Claims list | Infinite scroll, 20 per request, replaces the website's Previous / Next (same as the products list) |
| S19 | Common reject reasons | The website's four reasons are wrapping pills that fill the reason box (a chip cut long reasons off on a 360 dp phone) |
| P4 | Backend change | User approved only auth rate limiting (2026-11-15). Built as attempt limits keyed on address + email or user (the website calls the API from one server address); sign-in counts wrong passwords only. App always words 429 itself. Website gets the API's readable message with no web change |
| P4 | api branch | `feat/auth-attempt-limits` stays **local** (not pushed); the user pushes/merges it themself |
| P6 | Scope | Not publishing to Google Play / App Store for now: no store listings, signing key, data-safety forms or privacy policy work. Release builds use the debug key |
| P6 | iOS | Parked: no Mac available. iOS project settings stay as they are; no iOS icons or builds |
| P6 | Icon / splash | The website's hang-tag glyph, cream (#F2E8CF) on forest800 (#24422A); same splash in light and dark; generated by `tool/make_app_icons.py` |
| P6 | Account deletion | Both stores would require self-service account deletion (API only lets admins delete users). Not needed while not publishing; revisit before any store release |
| V2 | Plans | V2/V3 plans in `D:\Additional Project\plans\{mobile,web,api}\PLAN.md` (2026-11-20). Arham builds the app; friends build web + api; the API plan is the contract. **No implementation until Arham says so** |
| V2 | Phone sign-in | Phone-only accounts allowed (email optional). No real SMS in V2: the API prints OTP codes in its log |
| V2 | Push | Firebase project, FCM only. `google-services.json` kept out of git, shared privately |
| V2 | Hosting | Decided later; V2 built and checked over USB (`env/dev.json`) |
| V2 | Admin in app | New admin features (analytics, rewards + voucher codes, reward rules, users/points) also in the app. Analytics bars drawn with own widgets, no chart package |
| V2 | Rewards | New bottom tab (Wardrobe, Scan, Rewards, Account, + Admin). Points as proposed in API plan V2-6, expire after 12 months. Brands supply voucher codes; admins upload CSV |
| V2 | Links | No App Links; `/t` and `/w` links keep opening the website |
| V2 | Packages | Approved: `qr_flutter`, `firebase_core`, `firebase_messaging`, `flutter_local_notifications`, an SMS code reader (pick in the V2-1 slice) |
| V2 | Brands run themselves (V2-12) | Brands register; a STAKA admin approves each brand once; then the brand runs its catalog, **checks its own products' proofs of purchase**, and runs its rewards + voucher codes. Admins: approve/suspend brands, disputes, overrule, rules, users, analytics. Brand portal in the website **and** the app (Brand tab). App plan: move `features/admin/` to `features/manage/` with `ManageScope` first |
| V2-12 | Manage scope | Admin code moved to `features/manage/` (tests to `test/features/manage/`). One sealed `ManageScope` (`AdminScope` / `BrandScope(brandId)`) is passed explicitly: data sources prefix paths with it, providers are keyed by it so the admin and brand sides never share a list or cache. Required everywhere (no default) so a brand screen cannot fall back to admin endpoints by mistake. Brand CRUD stays admin-only. Class names (`AdminProductsScreen` …) kept for now to keep the move a pure refactor |
| V2-12 | Brand sign-up (app) | Account gets a "For brands" section with **Bring your brand to STAKA** (`/account/brand`). No application yet: an intro (what brands get, what to have ready) and Start. Then each application as a card: Being checked / Approved / Not approved (reason + **Edit and resubmit**) / Paused (reason); pull to refresh. The form is 3 steps: brand ("My brand is already on STAKA" switch → pick from `GET /brands`, which fills the name; brand name, legal name, about, website, GSTIN), contact (email and phone, filled from the account for a new application), logo + business document (both optional as in the API; logo from photos at 1024 px, document as photo or PDF via the receipt picker; 2 MB / 5 MB checked on the phone). GSTIN optional, checked against the GST format, sent upper case without spaces. Approved has no "open Brand tab" button yet (comes with `feat/brand-portal`) |
| V2-12 | Brand sign-up contract assumptions | (1) `GET /me/brand-applications` returns brand objects with at least `id`, `name`, `status`; the app also reads `legalName`, `statusReason`, `description`, `websiteUrl`, `gstin`, `contactEmail`, `contactPhone`, `logoUrl`, `existingBrandId`, `appliedAt` when present. (2) On `PATCH /brand-applications/:id` the app leaves out empty optional fields and unpicked files, meaning "keep"; so a resubmit can't clear the website or GSTIN. **Tell the API friends** both, so the answers match or they say how to clear a field |
| V2-12 | Brand tab (app) | Shown to members of an approved **or paused** brand, between Scan and Admin. Hub: brand name, role, Switch brand (several brands; the choice is kept while the app runs), then Products, Import, Team, Settings (owners only). Paused brand: a banner and See why (the reason is on the application in Account); nothing else, as the API refuses its portal calls. Products/Import are the admin screens with `BrandScope`: no brand filter, the product's brand is fixed to this brand (body still carries `brandId`, the same as the path). Team: owners first; owners invite by email or mobile number as Staff or Owner and remove anyone but themselves. Settings (owners): name, about, website, contact email/phone, logo; the user is re-read after saving so the tab shows the new name. Approved application card gets **Open the Brand tab** (re-reads the user once if the brand isn't listed yet). Claims come with `feat/brand-claims` |
| V2-12 | Brand claims (app) | Claims is the first row of the brand hub and says how many wait ("3 proofs of purchase are waiting for you."; the usual text if the count can't load; no count for a paused brand). The list, review, receipt, approve and reject are the admin screens with `BrandScope` (`/brand/claims…`; the brand is the one chosen in the tab), with brand wording under the heading. The claim score / reused-receipt hints are M4 (`feat/claim-analysis`); "Disputed by the shopper" comes with the dispute slices |
| V2-12 | Brand portal contract gaps | (1) No endpoint to change a member's role (plan's Team says "change role"): not offered. (2) No endpoint to list pending invites: not shown. (3) `GET /brand/:id/members` person fields unspecified: the app reads `name/email/phone` flat or under `user`. (4) `PATCH /brand/:id` sent as multipart (logo file), like the application. (5) Brand product create/update still sends `brandId` (= the path brand). (6) The pause reason isn't in `/auth/me`; the app points to the application card. **Tell the API friends** |
| V2 | Goldens | Update a golden only when the slice deliberately changes that screen; look at the new image first, and list every updated golden in the slice summary (Arham, 2026-11-23) |
| V2-1 | Phone sign-in screens | Welcome: "Continue with phone number" primary, "Use email instead" second (register is reached from email sign-in). Routes `/phone`, `/phone/code`, `/phone/name`. Six digits submit on their own; Resend after 30 s on the app clock (`clockProvider`); a new number gets a name step that resends the same code with the name |
| V2-1 | SMS code reader | Not added yet: V2 sends no real SMS (codes are in the API log), so there is nothing to read. The keyboard's one-time-code autofill hint is in place; add the reader package when the API sends real texts |
| V2-1 | Account sign-in methods | Account gets a "How you sign in" section: Phone number, Email, and Change password / Set a password. The number can be removed only when email + password remain (the API also refuses). Email can be added to a phone-only account but not changed (not in the API). After each change the session's user is updated in place (`SessionController.updateUser`); no reload |
| V2-10 | Your data | Download = `GET /me/export` bytes, unchanged, handed to the share sheet as `staka-data-YYYY-MM-DD.json` (no storage permission). Delete confirms with the password; an account without one gets a texted code and must press the button (six digits never delete on their own). Afterwards: snackbar "Your account has been deleted." and sign-out to **welcome** (new `SignedOutReason.accountDeleted`) |
| V2-10 | Delete-code contract gap | The API plan lets `DELETE /me` take `{challengeId, code}` but names no signed-in endpoint that issues that code. The app uses `POST /auth/otp/request` with the account's own number. **Tell the API friends** so `DELETE /me` accepts that challenge (or they add e.g. `POST /me/delete/code` and the app switches) |
| V2 | Server errors on fields | `AppTextField` drops a server error (`errorText`) once the field is edited; a pinned `forceErrorText` made `validate()` fail, so V1's change password and register could not be re-sent after a wrong password / taken email |
| V2 | OCR / test data | Receipt OCR self-hosted (Tesseract) on the API; test catalog images are generated placeholders |
| — | Test accounts | From `api/src/prisma/seed.ts` header (demo user + admin). Never copy passwords into docs/chat |
