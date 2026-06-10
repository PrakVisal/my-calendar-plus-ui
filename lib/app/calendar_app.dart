import 'package:flutter/material.dart';
import 'package:test_app/app/theme/app_theme.dart';
import 'package:test_app/features/calendar/presentation/screens/calendar_home_screen.dart';

class CalendarApp extends StatelessWidget {
  const CalendarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calendar',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const CalendarHomeScreen(),
    );
  }
}