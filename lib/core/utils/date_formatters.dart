import 'package:intl/intl.dart';

/// Helper methods for formatting dates and times throughout the calendar application.
class DateFormatters {
  DateFormatters._();

  /// Formats a month and year for headers (e.g., "June 2026").
  static String formatMonthYear(DateTime date) {
    return DateFormat.yMMMM().format(date);
  }

  /// Formats event times (e.g., "10:00 AM" or "02:30 PM").
  static String formatTime(DateTime time) {
    return DateFormat.jm().format(time.toLocal());
  }

  /// Formats full dates (e.g., "Friday, June 12, 2026").
  static String formatFullDate(DateTime date) {
    return DateFormat.yMMMMEEEEd().format(date.toLocal());
  }

  /// Formats short weekday headers (e.g., "M", "T", "W", "T", "F", "S", "S").
  static String formatWeekdayInitial(DateTime date) {
    return DateFormat.E().format(date).substring(0, 1);
  }

  /// Formats normal short weekdays (e.g., "Mon", "Tue", "Wed").
  static String formatWeekdayShort(DateTime date) {
    return DateFormat.E().format(date);
  }
}
