# Pangea Extensions Demo

A small Flutter + Firebase test harness with one button per kind of Firebase event: a Storage upload, an Auth sign-up and a Firestore write. It was built to try out backend reactions to those events (Firebase Extensions / Cloud Functions triggers and a [Rowy](https://www.rowy.io) table setup) without needing a real app to generate traffic.

## Features

The single `DemoPage` (`lib/ui/demo_page.dart`) has three buttons:

- **Upload File**: pick any file with `file_picker` and upload it to the root of Firebase Storage under its file name.
- **Create User**: create a Firebase Auth account with a random noun as the email (`<word>@gmail.com`) and the password `password`.
- **Create Custom Event**: add a random sentence to the Firestore `audit` collection.

Each action shows a snackbar with the result or the error.

## Project structure

```
lib/
├── main.dart
├── configs/firebase_options.dart   # FlutterFire config
├── ui/demo_page.dart
└── services/                       # auth, storage and firestore wrappers
functions/                          # Cloud Functions scaffold (Node 16; no functions defined yet)
firestore.rules                     # includes Rowy rules; currently allows all reads/writes
firestore.indexes.json
public/index.html                   # Firebase Hosting placeholder
```

## Tech stack

- Flutter with Dart `>=2.18.6 <3.0.0` (pre-Dart 3)
- `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_storage`
- `file_picker`, `word_generator`
- Firebase Cloud Functions (`firebase-functions` 4, Node 16)

## Getting started

1. Point the app at your Firebase project: `flutterfire configure` regenerates `lib/configs/firebase_options.dart`.
2. Enable Email/Password auth, Firestore and Storage in that project.
3. Run:

```sh
flutter pub get
flutter run
```

Functions (optional):

```sh
cd functions
npm install
npm run serve     # Firebase emulators
```

## Caution

`firestore.rules` contains `allow read, write: if true;`, so the database is open to anyone. Tighten it before using this project with real data.
