# customer_app

The HelloFit **customer** Flutter app — browse services, book a home session, track
bookings and progress, review the teacher.

Renamed from `customer_instructor_app` on 7 Nov 2026 when the instructor side was split
into its own project, `../instructor_app/`.

## Current state

Phase 1 structure only — theme tokens, API client with rotating-refresh, secure token
store, OTP auth, and an app shell whose tab bodies are `Awaiting design` placeholders.
**No screens are being built until the client supplies designs.**
`lib/app/shells.dart` still holds the old dual-shell code and the "Continue as" chooser;
that is leftover from the single-app design, not the target.

## Commands

```bash
flutter pub get
flutter run
flutter analyze
flutter test
```

Project instructions: `../claude.md` (index) and `../state/`. History: `../worklog/`.
