# HelloFit customer app (Flutter) — see `../claude.md`

**Project instructions live in `../claude.md` (a short index) and `../docs/`. Read those.**

Most relevant here: `../docs/frontend-state.md`, `../docs/frontend-conventions.md`
(conventions + design tokens), `../docs/working-order.md`, `../docs/commands.md`.

This file deliberately holds no instructions of its own — it used to be a full copy of the
root file and silently went stale. Claude Code loads the *nearest* `claude.md`, so a
session working in this directory was getting that stale text. Keep this file a pointer.

The one rule that matters most here, repeated because this is the directory it governs:

> **Do not build or design UI yet.** Don't invent screens, layouts, component libraries or
> visual styling, and don't touch this directory beyond what the backend needs. The client
> is supplying the designs. When they land, build against the API that already exists —
> not the reverse.

**This folder is the customer app only** (renamed from `customer_instructor_app/` on
7 Nov 2026); the instructor app is `../instructor_app/`. `lib/app/shells.dart` still holds
the old dual-shell code and the "Continue as" chooser — leftover, not the target.
`pubspec.yaml`, the `.iml` and `README.md` still carry the old package name.

Day-to-day history is in `../worklog/`. Read the latest entry before trusting `../docs/`.
