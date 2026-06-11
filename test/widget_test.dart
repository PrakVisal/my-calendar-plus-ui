import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:test_app/features/calendar/data/repositories/calendar_repository_impl.dart';
import 'package:test_app/features/calendar/domain/calendar_event.dart';
import 'package:test_app/features/calendar/presentation/providers/calendar_notifier.dart';

import 'package:test_app/app/calendar_app.dart';

class _FakeCalendarRepository extends CalendarRepositoryImpl {
  _FakeCalendarRepository()
      : super();

  @override
  Future<List<Event>> getEvents(int month, int year) async {
    return <Event>[
      Event(
        id: '1',
        title: 'Sample event',
        description: 'Fake repo event',
        startDate: DateTime(year, month, 12, 10),
        endDate: DateTime(year, month, 12, 11),
        color: Colors.blue,
      ),
    ];
  }
}

void main() {
  testWidgets('calendar app renders the main sections', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          calendarRepositoryProvider.overrideWithValue(_FakeCalendarRepository()),
        ],
        child: const CalendarApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Calendar'), findsOneWidget);
    expect(find.text('Events'), findsOneWidget);
    expect(find.text('Select a day to see events'), findsOneWidget);
    expect(find.byType(TableCalendar<Event>), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}
