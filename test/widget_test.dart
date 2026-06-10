import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:test_app/app/calendar_app.dart';

void main() {
  testWidgets('calendar home screen renders the main sections', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CalendarApp());

    expect(find.text('Calendar'), findsWidgets);
    expect(find.text('Upcoming'), findsOneWidget);
    expect(find.byType(GridView), findsOneWidget);
  });
}
