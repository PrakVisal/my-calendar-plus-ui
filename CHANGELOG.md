# Changelog

## [v1.1]

### Added
- Added custom `CalendarGrid` and `CalendarCell` grid widgets, replacing the `table_calendar` package for absolute visual control and premium aesthetics.
- Added structured models `CalendarDay` and `CalendarEvent` with JSON serialization to match backend collections.
- Added a Dio-powered `CalendarApiService` that loads the base URL dynamically from a `.env` file via `flutter_dotenv`.
- Added robust Riverpod state management (`calendarDataProvider`, `selectedDayProvider`, `currentMonthProvider`, `isOfflineProvider`) with a persistent in-memory caching fallback layer for offline accessibility.
- Added interactive widget components: `EventCard` displaying category indicators and badges, and an animated `EventPanel` featuring slide-and-fade transitions.
- Added shared widgets: `StatusBadge` for upcoming/in-progress/past events, `DurationBadge` displaying parsed duration strings, and an illustration-led `EmptyState` view.
- Added `AppColors` and `AppTextStyles` constants utilizing the premium Google Fonts `Plus Jakarta Sans` family.
- Consolidated light and dark theme modes inside `main.dart`.
- Rewrote `test/widget_test.dart` to mock `CalendarApiService` and verify screen rendering.

### Fixed
- Fixed calendar API endpoint resource mapping by targeting `/api/v1/calendar` instead of `/api/calendar`.
- Fixed data parsing in `CalendarApiService` to manually decode JSON payloads when server headers incorrectly return a `text/html` mime type.
- Fixed calendar day parsing to extract items nested inside the server's `payload['data']` envelope.
- Fixed event parsing keys to support `startDateTime` and `endDateTime` response fields.

## [v1.0]

### Added
- Added a Clean Architecture-friendly Flutter calendar scaffold with `data`, `domain`, and `presentation` layers.
- Added `Event` domain model with JSON serialization support.
- Added a Dio-based API client and calendar API service for fetching, creating, updating, and deleting events.
- Added Riverpod state management for calendar data.
- Added a monthly calendar UI using `table_calendar`.
- Added a comprehensive project `README.md` with setup, API docs, and folder structure.

### Changed
- Updated the app entry point to use `ProviderScope`.
- Switched the app home screen to the new calendar screen flow.
- Updated the default API base URL to the deployed Nuxt.js backend.
- Bumped `intl` to a version compatible with `table_calendar`.

### Fixed
- Fixed the `table_calendar` / `intl` version solving conflict.
- Fixed presentation widgets to use the new `Event` model fields.
- Improved Dio error handling and logging for network failures.
- Corrected the Dio adapter import to avoid missing URI errors.
- Added offline sample-data fallback so the app keeps working when the backend is unreachable.
- Updated the widget test to use a fake repository and avoid network dependency.

### Notes
- The deployed backend needs CORS enabled for Flutter Web.
- The current API endpoint should return JSON, not HTML, for the calendar collection.

### Updated
- Documented the current API base URL and the browser-side CORS limitation discovered during Flutter Web testing.
- Noted that the calendar endpoint currently responds with HTML headers and must be adjusted to return JSON for the Flutter client.
