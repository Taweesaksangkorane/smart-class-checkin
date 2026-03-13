# Smart Class Check-in & Learning Reflection App

Mobile Application Development midterm lab project.

## Project Description

This project is a Flutter MVP for class attendance and learning reflection.
Students can:

- Check in before class
- Scan classroom QR code
- Capture GPS location and timestamp
- Submit short pre-class form fields
- Finish class after session
- Scan QR again and submit learning reflection

The app stores records locally using SharedPreferences.

## Features Implemented

- Home screen with 2 main actions: `Check-in` and `Finish Class`
- Check-in flow:
	- Student ID input
	- Previous topic input
	- Expected topic input
	- Mood selection (1-5)
	- QR scan (`mobile_scanner`)
	- GPS capture (`geolocator`)
	- Save data to local storage
- Finish class flow:
	- Student ID input
	- Learned today input
	- Feedback input
	- QR scan
	- GPS capture
	- Save data to local storage
- Form validation for required fields

## Tech Stack

- Framework: Flutter
- Language: Dart
- Packages:
	- `mobile_scanner`
	- `geolocator`
	- `shared_preferences`
- Storage: SharedPreferences (local MVP storage)

## Data Model

### Check-in Record

- `studentId`
- `timestamp`
- `latitude`
- `longitude`
- `qrCodeData`
- `previousTopic`
- `expectedTopic`
- `mood`

### Finish Class Record

- `studentId`
- `timestamp`
- `latitude`
- `longitude`
- `qrCodeData`
- `learnedToday`
- `feedback`

## Setup Instructions

1. Install Flutter SDK and device emulator/simulator.
2. Clone repository.
3. Install dependencies:

```bash
flutter pub get
```

4. Run analyzer and tests:

```bash
flutter analyze
flutter test
```

## How To Run

Run on mobile/emulator:

```bash
flutter run
```

Run on web:

```bash
flutter run -d chrome
```

## Firebase Configuration Notes

Current version uses local storage for MVP and does not push records to Firestore yet.
Firebase is used in deployment stage via Firebase Hosting.

### Firebase Hosting Setup

1. Install Firebase CLI:

```bash
npm install -g firebase-tools
```

2. Login:

```bash
firebase login
```

3. Build Flutter web:

```bash
flutter build web
```

4. Initialize hosting in this repo (first time):

```bash
firebase init hosting
```

Suggested answers:
- Public directory: `build/web`
- Single-page app rewrite: `yes`
- Overwrite `index.html`: `no`

5. Deploy:

```bash
firebase deploy
```

## Firebase Deployment URL

- Hosting URL: `TBD (add your Firebase Hosting URL after deploy)`

## Deliverables Mapping

- PRD: `PRD.md`
- Source code: this repository
- Firebase URL: section above
- README: this file
- AI usage report: `AI_USAGE_REPORT.md`

## Notes for Instructor

- This is an MVP prototype focused on attendance flow and reflection capture.
- Presence is validated by collecting GPS + QR evidence at check-in and finish-class.
- Local persistence is used for speed and simplicity in the exam timeline.
