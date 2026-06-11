/// Environment configuration.
/// Default API base URL points to the deployed Nuxt.js backend.
/// Override at build/run time with `--dart-define=API_BASE_URL=` if needed.
class Env {
  static String get baseUrl => const String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: 'https://my-calendar-plus-nuxt-api.vercel.app/api/v1/calendar',
      );
}
