import 'package:flutter/material.dart';

class CalendarEvent {
  const CalendarEvent({
    required this.title,
    required this.time,
    required this.date,
    required this.accentColor,
  });

  final String title;
  final String time;
  final DateTime date;
  final Color accentColor;
}