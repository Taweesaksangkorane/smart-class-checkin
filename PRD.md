# Product Requirement Document (PRD)

## Smart Class Check-in & Learning Reflection App

## 1. Problem Statement

In many university classes, attendance is taken manually, which can be inefficient and unreliable. Students may check in on behalf of others or leave the classroom early.

This application aims to provide a simple mobile workflow that verifies class attendance and encourages learning reflection by combining GPS location, QR code scanning, and short feedback input.

## 2. Target Users

### Primary Users

- University students attending class

### Secondary Users

- Instructors who want to verify attendance and review student learning feedback

## 3. Core Features

### 3.1 Class Check-in

Students must:

- Press the `Check-in` button
- Scan a QR code provided in the classroom
- Fill in required short-form inputs

The system records:

- GPS location
- Timestamp

Student inputs required:

- Topic covered in the previous class
- Expected topic for today
- Mood before class (1-5 scale)

### 3.2 Class Completion

After class ends, students must:

- Press `Finish Class`
- Scan the QR code again
- Record GPS location
- Submit reflection inputs

Student inputs required:

- What they learned today
- Feedback about the class or instructor

## 4. User Flow

1. Student opens the application.
2. Home screen shows two actions: `Check-in` and `Finish Class`.
3. Student selects `Check-in`.
4. App captures GPS and scans QR code.
5. Student fills in required check-in form fields.
6. Data is saved locally.
7. At the end of class, student selects `Finish Class`.
8. App scans QR code again and records GPS.
9. Student submits learning reflection.

## 5. Data Fields

### 5.1 Check-in Data

| Field | Type | Description |
|---|---|---|
| `studentId` | String | Student identifier |
| `timestamp` | DateTime | Check-in time |
| `latitude` | Double | GPS latitude at check-in |
| `longitude` | Double | GPS longitude at check-in |
| `qrCodeData` | String | Scanned QR payload |
| `previousTopic` | String | Topic from previous class |
| `expectedTopic` | String | Expected topic for current class |
| `mood` | Integer (1-5) | Mood before class |

### 5.2 Finish Class Data

| Field | Type | Description |
|---|---|---|
| `studentId` | String | Student identifier |
| `timestamp` | DateTime | Finish-class submission time |
| `latitude` | Double | GPS latitude at class completion |
| `longitude` | Double | GPS longitude at class completion |
| `qrCodeData` | String | Scanned QR payload |
| `learnedToday` | String | Student reflection on what they learned |
| `feedback` | String | Feedback about class or instructor |

## 6. Tech Stack

### Frontend

- Flutter

### Libraries

- `geolocator` (GPS location)
- `mobile_scanner` (QR code scanning)

### Data Storage

- SQLite or SharedPreferences (local storage)

### Backend / Deployment

- Firebase Hosting (for deployment demo)
