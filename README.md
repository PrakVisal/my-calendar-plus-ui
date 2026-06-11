## my-calendar-plus-ui — Calendar App (Flutter frontend + Nuxt.js API)

An example Calendar application using Clean Architecture principles in Flutter
that communicates with a Nuxt.js REST API backend. This repository contains
the Flutter UI and scaffold for talking to a backend API (separate Nuxt.js
project expected under a sibling folder or remote server).

Features
- Monthly calendar view using `table_calendar`
- Event list for selected day
- Create / update / delete events via REST API
- Clean Architecture: data / domain / presentation separation
- State management with `flutter_riverpod`
- HTTP client using `dio` with a central `ApiClient`

Tech stack
- Frontend: Flutter (Dart)
- State management: Riverpod
- HTTP: Dio
- Backend (suggested): Nuxt.js 3 + Prisma + PostgreSQL (separate project)

Prerequisites
- Flutter SDK 3.12+ (stable channel)
- Dart SDK compatible with Flutter
- Node.js 18+ (for Nuxt.js backend)
- A running backend REST API (see API docs below)

Installation (Flutter frontend)

1. Install Flutter and verify: `flutter doctor`
2. From this folder run:
	 - `flutter pub get`
3. To run on a device/emulator:
	 - `flutter run`

Running the backend (Nuxt.js)

This repository only contains the Flutter frontend. For the backend, create
a Nuxt.js 3 project with endpoints described below. Run the backend with:

- `npm install`
- `npm run dev`

Environment configuration
- Flutter: you may pass the API base URL at build/run time:
	- `flutter run --dart-define=API_BASE_URL=http://localhost:3000`

API endpoints (expected)

| Method | Endpoint | Body | Description |
|---|---:|---|---|
| GET | /events?month={m}&year={y} | — | Fetch events for a month |
| POST | /events | { title, description, startDate, endDate, color, allDay } | Create event |
| PUT | /events/{id} | { ... } | Update event |
| DELETE | /events/{id} | — | Delete event |

Flutter folder structure

- lib/
	- app/
		- calendar_app.dart
		- theme/
			- app_theme.dart
	- core/
		- config/
			- env.dart
		- network/
			- api_client.dart
	- features/
		- calendar/
			- data/
				- datasources/
					- calendar_api_service.dart
				- repositories/
					- calendar_repository_impl.dart
			- domain/
				- calendar_event.dart
				- repositories/
					- calendar_repository.dart
			- presentation/
				- providers/
					- calendar_notifier.dart
				- screens/
					- calendar_screen.dart
				- widgets/
					- (UI widgets)

Nuxt.js (suggested) folder structure

- nuxt-backend/
	- server/
		- api/
			- events.ts (or .js)
	- prisma/
	- package.json

Environment variables (reference)
- `API_BASE_URL` (Flutter) — Base URL for the Nuxt.js API (example: `http://localhost:3000`)
- Backend: usual database and Prisma env vars (e.g. `DATABASE_URL`)

Screenshots
- Add screenshots in `README.md` by replacing these placeholders with images from `/docs` or your local device.

License
- MIT

Further notes
- The Flutter project includes a small but production-minded scaffold: a
	central `ApiClient`, a `CalendarApiService` that models the REST endpoints,
	a `CalendarRepository` abstraction with an implementation that uses the
	API, and an AsyncNotifier-based Riverpod provider for state and side-effects.
- Use `--dart-define` to change API endpoints between development and
	production builds.

