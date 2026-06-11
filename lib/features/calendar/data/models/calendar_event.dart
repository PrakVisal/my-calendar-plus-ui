import 'package:flutter/material.dart';

/// Data and Domain model for a calendar event.
class CalendarEvent {
  const CalendarEvent({
    this.id,
    required this.title,
    this.description,
    required this.startDate,
    this.endDate,
    required this.color,
    this.allDay = false,
  });

  final String? id;
  final String title;
  final String? description;
  final DateTime startDate;
  final DateTime? endDate;
  final Color color;
  final bool allDay;

  CalendarEvent copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    Color? color,
    bool? allDay,
  }) {
    return CalendarEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      color: color ?? this.color,
      allDay: allDay ?? this.allDay,
    );
  }

  factory CalendarEvent.fromJson(Map<String, dynamic> json) {
    DateTime parse(dynamic val) {
      if (val is String) {
        return DateTime.parse(val).toLocal();
      }
      return DateTime.now();
    }

    Color parseColor(String? hex) {
      if (hex == null || hex.isEmpty) return const Color(0xFF6366F1);
      final cleaned = hex.replaceAll('#', '');
      final value = int.tryParse(cleaned, radix: 16);
      if (value == null) return const Color(0xFF6366F1);
      // Support formats like AARRGGBB or RRGGBB
      if (cleaned.length <= 6) {
        return Color(0xFF000000 | value);
      }
      return Color(value);
    }

    return CalendarEvent(
      id: json['id']?.toString(),
      title: json['title'] ?? '',
      description: json['description'] as String?,
      startDate: parse(json['startDateTime'] ?? json['startDate']),
      endDate: (json['endDateTime'] ?? json['endDate']) != null 
          ? parse(json['endDateTime'] ?? json['endDate']) 
          : null,
      color: parseColor(json['color'] as String?),
      allDay: json['allDay'] == true || json['allDay'] == 'true',
    );
  }

  Map<String, dynamic> toJson() {
    String colorToHex(Color c) {
      return '#${c.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}';
    }

    return {
      if (id != null) 'id': id,
      'title': title,
      'description': description,
      'startDate': startDate.toUtc().toIso8601String(),
      'endDate': endDate?.toUtc().toIso8601String(),
      'color': colorToHex(color),
      'allDay': allDay,
    };
  }
}
