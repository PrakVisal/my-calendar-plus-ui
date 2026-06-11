import 'package:flutter/material.dart';

/// Domain model for a calendar Event.
class Event {
  const Event({
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

  Event copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    Color? color,
    bool? allDay,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      color: color ?? this.color,
      allDay: allDay ?? this.allDay,
    );
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    DateTime parse(String s) => DateTime.parse(s).toUtc();

    Color parseColor(String? hex) {
      if (hex == null || hex.isEmpty) return const Color(0xFF245BFF);
      final cleaned = hex.replaceAll('#', '');
      final value = int.tryParse(cleaned, radix: 16);
      if (value == null) return const Color(0xFF245BFF);
      return Color(0xFF000000 | value);
    }

    return Event(
      id: json['id']?.toString(),
      title: json['title'] ?? '',
      description: json['description'] as String?,
      startDate: json['startDate'] != null ? parse(json['startDate'] as String) : DateTime.now().toUtc(),
      endDate: json['endDate'] != null ? parse(json['endDate'] as String) : null,
      color: parseColor(json['color'] as String?),
      allDay: json['allDay'] == true || json['allDay'] == 'true',
    );
  }

  Map<String, dynamic> toJson() {
    String colorToHex(Color c) => '#${c.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}';

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