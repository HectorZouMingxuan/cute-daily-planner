# Cute Daily Planner

A clean, cute, simple Flutter daily planner with an English-first UI.

## Features

- Month calendar view
- Today button and month navigation
- Selected date event list
- Add, edit, and delete events
- Local persistence with Hive
- Project-folder JSON persistence for file-system builds at `data/calendar_events.json`
- Reminder picker with native notification scheduling where supported
- Recurring events: daily, weekly, monthly, yearly
- Drag and drop events to another date
- Offline-first sync structure
- Firebase Auth and Firestore API structure
- Planner Firestore API structure for expenses, todos, notes, moods, habits, and habit check-ins
- Sync status display and retry action
- Daily dashboard tabs: Plan, Money, Tasks, Notes
- Daily expense tracking
- Daily todo list
- Daily notes
- Mood tracking
- Habit tracker

## Run

```bash
flutter pub get
flutter run
```

For web:

```bash
flutter run -d chrome
```

Build web:

```bash
flutter build web
```

## Firebase Setup

Cloud sync is scaffolded but not configured with project credentials.

To enable Firebase:

1. Create a Firebase project.
2. Enable Firebase Auth.
3. Enable Cloud Firestore.
4. Run FlutterFire configuration:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

5. Import and initialize the generated `firebase_options.dart` in `lib/main.dart`:

```dart
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

Do not hardcode Firebase secrets in source files.

Planned Firestore paths:

```txt
users/{userId}/events
users/{userId}/expenses
users/{userId}/todos
users/{userId}/notes
users/{userId}/moods
users/{userId}/habits
users/{userId}/habitCheckIns
```

## Notes

- Web browsers cannot directly write into the project folder. Web builds keep using browser storage. File-system builds use JSON files in `data/`.
- Windows desktop was removed from this generated project because this machine does not have Windows Developer Mode symlink support enabled for Flutter plugins.
- Web builds are verified.
- Native notification behavior should be verified on a real Android or iOS device.
