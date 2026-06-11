/// Utility class to parse and format durations for events.
class DurationParsers {
  DurationParsers._();

  /// Calculates the difference between [start] and [end] and formats it.
  /// Example outputs: "All Day", "45m", "1h", "2h 15m".
  static String formatDuration(DateTime start, DateTime? end, bool allDay) {
    if (allDay) return 'All Day';
    if (end == null) return '';

    final difference = end.difference(start);
    if (difference.isNegative) return '';

    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;

    if (hours == 0) {
      return '${minutes}m';
    } else if (minutes == 0) {
      return '${hours}h';
    } else {
      return '${hours}h ${minutes}m';
    }
  }

  /// Checks if the event is currently active at [now].
  static bool isActive(DateTime start, DateTime? end, {DateTime? now}) {
    final time = now ?? DateTime.now();
    if (end == null) {
      // If no end time, active for the hour starting from start date
      return time.isAfter(start) && time.isBefore(start.add(const Duration(hours: 1)));
    }
    return time.isAfter(start) && time.isBefore(end);
  }

  /// Returns if the event has already occurred.
  static bool isPast(DateTime? end, DateTime start, {DateTime? now}) {
    final time = now ?? DateTime.now();
    final checkTime = end ?? start.add(const Duration(hours: 1));
    return time.isAfter(checkTime);
  }
}
