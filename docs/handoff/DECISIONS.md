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
| — | Test accounts | From `api/src/prisma/seed.ts` header (demo user + admin). Never copy passwords into docs/chat |
