# HelloFit customer app (Flutter) — see `../claude.md`

**Project instructions live in `../claude.md` (a short index) and `../state/`. Read those.**

Most relevant here: `../state/frontend-state.md`, `../state/frontend-conventions.md`
(conventions + design tokens), `../state/working-order.md`, `../state/commands.md`.

This file deliberately holds no instructions of its own — it used to be a full copy of the
root file and silently went stale. Claude Code loads the *nearest* `claude.md`, so a
session working in this directory was getting that stale text. Keep this file a pointer.

The one rule that matters most here, repeated because this is the directory it governs:

> **Convert the client's designs; never invent a screen.** The designs landed on
> 04-11-2026 — 57 HTML files in `../Customer app screen/`. On 23-11-2026 the client ruled:
> **build bucket A only (38 screens), and write no new backend.** The mapping, the 15
> screens that are not to be built, and the design elements that have no API behind them
> are in `../state/frontend/customer-app-screens.md` — read it before starting a screen.

**This folder is the customer app only** (renamed from `customer_instructor_app/` on
7 Nov 2026); the trainer app is `../trainer_app/`. `lib/app/shells.dart` still holds
the old dual-shell code and the "Continue as" chooser — leftover, not the target.
`pubspec.yaml`, the `.iml` and `README.md` still carry the old package name.

Day-to-day history is in `../worklog/`. Read the latest entry before trusting `../state/`.
