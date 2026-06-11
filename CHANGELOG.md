# Changelog

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
