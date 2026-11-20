# Phase 5: Verification

Date: 2026-11-15.

## Test setup

- **Phone:** OnePlus CPH2467, Android 15, debug build.
- **API:** the local API (`api/` on branch `feat/auth-attempt-limits`).
- **Website:** the local website (`web/` on `feat/full-app`, run with
  `pnpm dev`, source unchanged).
- **Connection:** the phone reached both over USB (`adb reverse`).
- **Accounts:** throwaway shoppers. The seeded admin was used for admin
  screens; its password was read from the seed file and never printed.

**Kinds of test, as named in the "Tested?" column of the table below:**

- **Device script:** `integration_test/` driving the real app on the phone
  against the real API.
- **By hand:** on the phone over adb, with screenshots.
- **Live:** `test/live/`, the app's real network stack against the API.
- **Widget:** `test/` with fakes, including goldens.

**Totals:**

- 316 widget and unit tests pass, including 64 goldens.
- 17 live tests pass, three times back to back.
- 2 device scripts pass on the phone.
- API: 55 end-to-end and 20 integration tests pass.

## Checklist

| # | Feature | Website behaviour | Mobile status | Tested? | Notes |
|---|---|---|---|---|---|
| 1 | Landing / welcome | Marketing page, signed-in "Open my wardrobe" | Welcome screen (what STAKA does, hang tag, Create account, Sign in) | Device script, by hand | Decision 6: a short welcome instead of the full marketing page |
| 2 | Sign in | Email + password, 401 alert | Same copy; 401 alert; "Signing in…" while waiting | Device script, by hand, live | Slow network checked (4 s delay) |
| 2a | Too many attempts | (new) 429 message from the API | App words it itself with the wait in minutes | Widget, live, website by hand | Website shows the API's message unchanged |
| 3 | Register | Name / email / password rules, 409 on email | Same rules and copy; new account lands in the wardrobe | Device script, widget, live | |
| 4 | Forgot password | Same answer whoever asks | Same | Device script, live | The email link opens the website (decision 7) |
| 5 | Reset password | Website page | Not in app: opens the website | n/a | Decision 7 |
| 6 | Verify email | Website page | Banner + "Send a new link"; the link itself opens the website | Device script, by hand | Decision 7 |
| 7 | Wardrobe | Counts, Verified / Waiting for proof, empty state | Same; pull to refresh | Device script, by hand | Offline refresh keeps the tags and says why |
| 8 | Scan | Camera (EAN-13/8, UPC, QR) + typed number | Same; keyboard search key submits | By hand: real barcode scanned with the camera; unknown real-world barcode | Camera only tested on Android |
| 9 | Product | Tag, figures explained, brand, add / view tag; 400 / 404 states | Same | Device script, by hand, widget | Verified and brand-stated figures both seen |
| 10 | Tag: ownership | Order match; receipt ≤5 MB jpeg/png/webp/pdf; pending, rejected (reason), blocked, verified | Same; take a photo, choose from photos, choose a PDF | By hand: system photo picker, PDF picker, camera open + cancel; rejection reason shown | |
| 10a | Tag: sharing | Create link, copy, share, story image, stop with confirm | Same, through the phone's share sheet | Device script, by hand | Story image bug found and fixed (see below) |
| 11 | Public shared tag | `/t/<slug>` | "See what others see" opens the website in the browser | By hand (Chrome on the phone) | Decision 8; 404 after stopping, checked |
| 12 | Admin products | Search, brand filter, pages of 20, delete | Search, filter sheet, infinite scroll, delete with confirm | Device script, widget, live | |
| 13 | Admin product form | Fields, rules, live tag preview | Same | Widget, live | Not driven on the device: the form is the same widget the tests cover |
| 14 | Admin brands | List, add/edit dialog, delete | Same (sheet instead of dialog) | Device script: add, edit, delete | |
| 15 | Admin import | Choose CSV, dry run, import, template | Same; file picker; template via share sheet | Widget, live; page opened on the device | Picking a CSV on the phone not done by hand (same picker as the PDF one) |
| 16 | Admin claims list | Tabs by status, pages | Tabs with count, infinite scroll | Device script, by hand | 17 pending claims are leftovers from live tests |
| 17 | Admin claim review | Receipt (image / PDF), approve, reject with reason, history | Same; in-app photo and PDF viewer | Device script, by hand (PDF viewer, approve) | |
| 18 | Account / sign out | Name, sign out | Name, email, change password, sign out | Device script | Change password is a mobile extra (decision 14) |

## Edge cases (on the phone)

| Case | Result |
|---|---|
| No connection, in the app | Pull to refresh keeps the tags and shows "STAKA's server isn't reachable right now…" |
| No connection, at launch | "No connection" screen with Try again and Sign out; Try again recovers once the API is back |
| Slow network (4 s per request) | Buttons show their busy label with a spinner, then the screen loads normally |
| Server error (500) | "This didn't load" with the server's message and Try again; recovers |
| Expired / revoked session | Password changed elsewhere, then the access token expired: Try again signed out with "Your session has ended. Sign in again." |
| Too many sign-ins | 429: "Too many attempts. Please wait 15 minutes and try again." (app and website) |
| Invalid input | Website rules and messages on every form (widget tests); empty sign-in sends nothing |
| Empty data | Empty wardrobe, empty claim tabs, empty brand / product lists |
| Unknown barcode | "This product isn't on STAKA yet" (a real barcode from the room) |

## Found and fixed in this phase

1. **Story image always failed on a real phone.**
   - Cause: the tag repository provider closed its own website client as
     soon as it was disposed.
   - Fix: the client is now a long-lived `webDioProvider`. A regression
     test was added and the fix was confirmed on the phone.
2. **Bottom sheets opened under the tab bar.** The receipt source, brand
   form and brand filter sheets now cover the whole app, as dialogs do.
   Confirmed on the phone.
3. **Test helpers only:** device scripts now scroll before tapping (long
   pages only build what's near the screen) and close the keyboard first.

## The website after the backend change

- **Changed:** only the four auth routes (Phase 4). No route, body or
  success answer changed.
- **Checked by hand:**
  - the landing page (with its barcode);
  - sign-in (401 message, then the new 429 message);
  - the public tag page (from the phone), and its story image;
  - catalog images.
- **Not run:** the website's own test suites (`web/e2e` Playwright, Vitest),
  since its source didn't change.

## Not done or incomplete (honest list)

- **iOS:** not built or run (no Mac here). Everything above is Android
  only. iOS needs a Mac for `flutter build ios` and a device check
  (camera, pickers, share sheet, permission texts).
- **Release build:** not tried yet (Phase 6: signing, icon, splash).
- **Accessibility:** large text (200%) is covered by widget tests.
  TalkBack was not tried on the phone.
- **Admin import on the phone:** choosing a CSV by hand and the product
  form were not driven on the device. Both are covered by widget and live
  tests.
- **Offline cache:** none (decision 13). Every screen needs the API, and
  shows a no-connection state and retry.
- **Test data left in the local database:** throwaway shoppers, and 17
  pending claims from live-test runs (their tests don't decide them).
  These are harmless locally. A cleanup script, or live tests that reject
  what they create, would keep the queue clean.
- **Lockout trade-off:**
  - The website's sign-in limit is per email, because the website calls
    the API from one address.
  - So someone can lock another person out for 15 minutes.
  - Fixing it needs the website to forward the visitor's address (a web
    change, not made).
- **"0.0 MB" for tiny files:** shown the same way on the website.
  Possible improvement, not changed.
- **Branches:** the API change is on a local branch only (user's choice).
  The mobile branches are pushed, not merged.
