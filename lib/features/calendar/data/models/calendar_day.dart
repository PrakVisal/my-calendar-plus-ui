import 'calendar_event.dart';

/// Model representing a single day in the calendar grid.
class CalendarDay {
  const CalendarDay({
    required this.date,
    required this.isCurrentMonth,
    required this.isWeekend,
    required this.events,
  });

  final DateTime date;
  final bool isCurrentMonth;
  final bool isWeekend;
  final List<CalendarEvent> events;

  CalendarDay copyWith({
    DateTime? date,
    bool? isCurrentMonth,
    bool? isWeekend,
    List<CalendarEvent>? events,
  }) {
    return CalendarDay(
      date: date ?? this.date,
      isCurrentMonth: isCurrentMonth ?? this.isCurrentMonth,
      isWeekend: isWeekend ?? this.isWeekend,
      events: events ?? this.events,
    );
  }

  factory CalendarDay.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(dynamic val) {
      if (val is String) {
        return DateTime.parse(val).toLocal();
      }
      return DateTime.now();
    }

    final eventsJson = json['events'];
    final List<CalendarEvent> parsedEvents = [];
    if (eventsJson is List) {
      for (final item in eventsJson) {
        if (item is Map<String, dynamic>) {
          parsedEvents.add(CalendarEvent.fromJson(item));
        }
      }
    }

    return CalendarDay(
      date: parseDate(json['date']),
      isCurrentMonth: json['isCurrentMonth'] == true || json['isCurrentMonth'] == 'true',
      isWeekend: json['isWeekend'] == true || json['isWeekend'] == 'true',
      events: parsedEvents,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String().substring(0, 10), // YYYY-MM-DD
      'isCurrentMonth': isCurrentMonth,
      'isWeekend': isWeekend,
      'events': events.map((e) => e.toJson()).toList(),
    };
  }
}
