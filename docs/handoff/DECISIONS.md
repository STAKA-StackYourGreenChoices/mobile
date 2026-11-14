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
| — | Test accounts | From `api/src/prisma/seed.ts` header (demo user + admin). Never copy passwords into docs/chat |
