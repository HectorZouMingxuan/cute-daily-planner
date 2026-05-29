# Cute Daily Planner

A cute, modern Flutter daily planner with Firebase Auth, Firestore sync, and local Hive persistence.

## Features

- **Calendar** — month view with task/mood/expense indicators, drag-and-drop events
- **Events** — create, edit, delete with reminders, recurrence, color picker
- **Tasks** — daily todo list with priority levels, swipe-to-delete, clear-done
- **Expenses** — income/expense tracking with categories, weekly bar chart
- **Notes** — daily note editor with word count
- **Mood** — 5-level mood tracker with weekly trend
- **Habits** — habit tracker with streak counting and week dots
- **Weekly Overview** — aggregated stats, day-by-day breakdown, spending by category
- **Dark Mode** — theme toggle with per-account Firestore persistence
- **Firebase Auth** — email/password sign-in and registration
- **Cloud Sync** — Firestore write-through for all modules, Hive local fallback
- **Notifications** — SnackBar-based feedback system (success, error, info, confirm)

## Architecture

- **State management:** Riverpod (`AsyncNotifierProvider`, `NotifierProvider`)
- **Auth:** Firebase Authentication
- **Cloud:** Cloud Firestore (`users/{userId}/{collection}`)
- **Local:** Hive
- **UI:** Material 3 with theme-aware design tokens, glassmorphic cards, responsive layout

## Run

```bash
flutter pub get
flutter run
```

For web:

```bash
flutter run -d chrome
flutter build web
```

## Firebase Setup

1. Create a Firebase project
2. Enable Authentication (Email/Password) and Cloud Firestore
3. Run FlutterFire configuration:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

Do not hardcode Firebase secrets in source files.

### Firestore Data Structure

```
users/{userId}/
  events/
  expenses/
  todos/
  notes/
  moods/
  habits/
  habitCheckIns/
```

## Notes

- Web builds use browser storage; desktop builds use JSON files in `data/`
- Windows desktop requires Developer Mode for symlink support
- Native notifications should be verified on a real Android or iOS device
