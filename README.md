# StackOverflow Users App

A Flutter application that displays StackOverflow users using the StackExchange API.
The app demonstrates a clean, scalable architecture with BLoC state management.

## Features
- View a list of StackOverflow users
- Bookmark / unbookmark users
- Persist bookmarks across app restarts
- Filter users by bookmarked only
- View user reputation details
- Pull-to-refresh support
- Robust error handling

## Architecture
The project follows a **feature-based Clean Architecture**:

- **Data layer**: API managers, models, repositories
- **Domain layer**: Repository interfaces
- **Presentation layer**: BLoC + UI

State management is implemented using **flutter_bloc** and **hydrated_bloc**.
Dependency injection is handled via **GetIt**.

## Tech Stack
- Flutter
- BLoC / HydratedBloc
- Dio
- GetIt
- SharedPreferences

## API
Data is fetched from the StackExchange API:
https://api.stackexchange.com/docs

## Getting Started
```bash
flutter pub get
flutter run
