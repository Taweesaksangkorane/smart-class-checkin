# AI Usage Report

## AI Tools Used

- GitHub Copilot (GPT-5.3-Codex)

## What AI Helped Generate

- Flutter UI scaffolding for home/check-in/finish screens
- QR scanner screen integration using `mobile_scanner`
- GPS location capture flow using `geolocator`
- Local storage helper using `shared_preferences`
- README and documentation structure

## What I Implemented or Modified Myself

- Requirement interpretation from exam prompt and PRD
- Form fields and validation rules for check-in and finish-class
- Data field mapping to required rubric fields
- Submission flow and local record structure
- Platform permission updates (Android/iOS)
- Testing and analysis verification (`flutter analyze`, `flutter test`)

## Engineering Decisions

- Chose SharedPreferences for MVP speed and lower complexity in exam timeframe
- Separated check-in and finish-class records for clear workflow traceability
- Added reusable QR scan screen to simplify both form flows

## Limitations and Future Improvements

- Current MVP stores data locally only
- Next step: integrate Firebase Firestore for cloud sync and instructor dashboard
- Next step: complete Firebase Hosting deployment URL in README after deploy
