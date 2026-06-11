import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/features/calendar/data/models/calendar_day.dart';
import 'package:test_app/features/calendar/data/models/calendar_event.dart';
import 'package:test_app/features/calendar/data/services/calendar_api_service.dart';
import 'package:test_app/features/calendar/domain/providers/calendar_provider.dart';
import 'package:test_app/features/calendar/presentation/widgets/calendar_grid.dart';
import 'package:test_app/main.dart';

class _MockCalendarApiService implements CalendarApiService {
  @override
  Future<List<CalendarDay>> getCalendar({required int month, required int year}) async {
    return List.generate(42, (index) {
      final date = DateTime(year, month, 1).add(Duration(days: index - 2));
      return CalendarDay(
        date: date,
        isCurrentMonth: date.month == month,
        isWeekend: date.weekday == DateTime.saturday || date.weekday == DateTime.sunday,
        events: index == 5
            ? [
                CalendarEvent(
                  id: 'test-1',
                  title: 'Mock Test Event',
                  description: 'A test event description',
                  startDate: DateTime(year, month, date.day, 10, 0),
                  endDate: DateTime(year, month, date.day, 11, 0),
                  color: Colors.blue,
                ),
              ]
            : [],
      );
    });
  }

  @override
  Future<CalendarEvent> createEvent(CalendarEvent event) async {
    return event.copyWith(id: 'new-id');
  }

  @override
  Future<CalendarEvent> updateEvent(String id, CalendarEvent event) async {
    return event;
  }

  @override
  Future<void> deleteEvent(String id) async {}

  @override
  Exception _handleDioError(dynamic e) {
    return Exception(e.toString());
  }
}

void main() {
  testWidgets('calendar app renders the main components successfully', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          calendarApiServiceProvider.overrideWithValue(_MockCalendarApiService()),
        ],
        child: const CalendarApp(),
      ),
    );

    // Let the loading transition settle
    await tester.pumpAndSettle();

    // Verify application header and components exist
    expect(find.text('CalendarPlus'), findsOneWidget);
    expect(find.byType(CalendarGrid), findsOneWidget);
    
    // Check if weekday header text is visible
    expect(find.text('MON'), findsOneWidget);
    expect(find.text('FRI'), findsOneWidget);
  });
}
