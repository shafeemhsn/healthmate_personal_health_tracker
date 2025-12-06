# HealthMate – Personal Health Tracker

HealthMate helps you log and review your daily activity in one place. Track steps, calories burned, and water intake, see a quick snapshot of today’s progress on the dashboard, and manage your history with an easy add/edit workflow.

## Features
- Daily dashboard that sums today’s steps, calories, water, and shows total records.
- Health record list with date search/filter, edit, and delete actions.
- Add or update entries with form validation for steps, calories, and water intake.
- Local persistence using `sqflite`; works offline and keeps your data on-device.
- Light/dark themes and a bottom navigation layout for Home and Records tabs.

## Tech Stack
- Flutter (Dart)
- State management: Riverpod
- Local storage: sqflite (SQLite)
- Formatting: intl, google_fonts

## Getting Started
1. **Prerequisites**: Flutter SDK (3.9.x or newer), Android Studio/Xcode tooling for device/emulator.
2. **Install dependencies**
   ```bash
   flutter pub get
   ```
3. **Run the app**
   ```bash
   flutter run
   ```
   Choose a simulator/emulator or connected device when prompted.
4. **Run tests**
   ```bash
   flutter test
   ```

## How to Use
- Tap `+` to add a health record; pick a date and enter steps, calories (kcal), and water (ml).
- Tap the edit/delete icons on a record card to modify or remove it.
- Use the date filter on the Records tab to quickly find entries (supports partial matches like `12/`).
- Pull to refresh the dashboard or record list after changes.

## Project Structure
- `lib/main.dart` – App entry with Riverpod scope.
- `lib/app.dart` – MaterialApp setup with theming and root navigation.
- `lib/feature/health_records/` – Health record domain (screens, widgets, state, data models, repository, DAO).
- `lib/core/` – Shared theming, constants, database bootstrap, and utilities (date formatting).

## Notes
- Data is stored locally in `health_mate_db.db` via `sqflite`; removing the app clears stored records.
- The app targets mobile (Android/iOS); web/desktop builds are untested.
