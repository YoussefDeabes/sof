# StackOverflow Users App

A Flutter application that displays StackOverflow users using the StackExchange API.
The app demonstrates a clean, scalable architecture with BLoC state management.

## Features

- StackOverflow users infinite scrolling with pagination
- Bookmark / unbookmark users with persistence across app restarts
- Filter users to show only bookmarked users
- View user reputation history (not generic user details)
- Reputation history pagination (page size = 30)
- Pull-to-refresh support (works even when list is empty)
- Full-screen No Internet Connection handling
- Automatic offline to online recovery
- Localization support (English / Arabic)
- Light & Dark theme support with instant switching
- Language switching via UI controls
- Theme switching via UI controls

## Connectivity Handling

The app implements centralized internet connectivity handling at the application root level:

- Single source of truth for connectivity state via `InternetConnectionBloc`
- Full-screen blocking UI when offline (replaces entire app)
- Automatic dismissal when connection is restored
- No per-screen connectivity checks or overlays
- Stream-based connectivity monitoring with periodic fallback checks
- Offline screen respects current language and theme settings

## Localization & Theme

- Language switching via `LanguageCubit` with persistence
- Theme switching via `ThemeCubit` with persistence
- Supported languages: English, Arabic (RTL support)
- Light and Dark theme modes
- Offline screen automatically uses current language and theme
- All UI strings are localized using JSON-based translations

## Architecture

The project follows a **feature-based Clean Architecture**:

- **Data layer**: API managers, models, repositories
- **Domain layer**: Repository interfaces
- **Presentation layer**: BLoC + UI

State management is implemented using **flutter_bloc** and **hydrated_bloc**.
Dependency injection is handled via **GetIt**.

Key architectural patterns:
- Centralized app-level state management (BLoC)
- Single source of truth for connectivity state
- Repository returns UI states (Project A pattern)
- Base widgets for consistent UI structure (`BaseStatefulWidget`, `BaseStatelessWidget`)
- Custom text widget (`TextWidget`) for consistent styling
- Shimmer loaders for loading states

## Tech Stack

- Flutter
- BLoC / HydratedBloc (state persistence)
- Dio (HTTP client)
- GetIt (dependency injection)
- SharedPreferences (local storage)
- connectivity_plus (network connectivity monitoring)
- intl (date formatting and localization)
- flutter_localizations (localization support)
- flutter_screenutil (responsive UI)
- shimmer (loading placeholders)

## API

Data is fetched from the StackExchange API:
https://api.stackexchange.com/docs

### Endpoints Used

- **Users list**: `GET /2.2/users`
  - Supports pagination (page size = 20)
  - Infinite scrolling implementation

- **Reputation history**: `GET /2.2/users/{userId}/reputation-history`
  - Supports pagination (page size = 30)
  - Returns reputation change events with:
    - `reputation_history_type`: Type of reputation change
    - `reputation_change`: Change value (can be positive or negative)
    - `creation_date`: Unix timestamp
    - `post_id`: Associated post ID (may be null)

## Getting Started

```bash
flutter pub get
flutter run
```
