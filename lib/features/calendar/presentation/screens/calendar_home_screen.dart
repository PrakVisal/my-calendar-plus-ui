import 'package:flutter/material.dart';
import 'package:test_app/features/calendar/domain/calendar_event.dart';
import 'package:test_app/features/calendar/presentation/widgets/calendar_month_grid.dart';
import 'package:test_app/features/calendar/presentation/widgets/upcoming_events_panel.dart';

class CalendarHomeScreen extends StatelessWidget {
  const CalendarHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final currentMonthLabel = _monthLabel(now.month, now.year);
    final sampleEvents = <Event>[
      Event(
        id: null,
        title: 'Design sync',
        description: 'Design team sync',
        startDate: monthStart.add(const Duration(days: 2, hours: 9)),
        endDate: monthStart.add(const Duration(days: 2, hours: 10)),
        color: const Color(0xFF245BFF),
        allDay: false,
      ),
      Event(
        id: null,
        title: 'Sprint review',
        description: 'Review sprint work',
        startDate: monthStart.add(const Duration(days: 6, hours: 13, minutes: 30)),
        endDate: monthStart.add(const Duration(days: 6, hours: 14, minutes: 30)),
        color: const Color(0xFFFF8A00),
      ),
      Event(
        id: null,
        title: 'Family dinner',
        description: null,
        startDate: monthStart.add(const Duration(days: 11, hours: 19)),
        endDate: monthStart.add(const Duration(days: 11, hours: 21)),
        color: const Color(0xFF11A36A),
      ),
      Event(
        id: null,
        title: 'Weekly planning',
        description: 'Plan next week',
        startDate: monthStart.add(const Duration(days: 18, hours: 10, minutes: 15)),
        endDate: monthStart.add(const Duration(days: 18, hours: 11, minutes: 15)),
        color: const Color(0xFF8A5CFF),
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CalendarHeader(monthLabel: currentMonthLabel),
              const SizedBox(height: 20),
              CalendarMonthGrid(
                month: monthStart,
                highlightedDate: now,
                events: sampleEvents,
              ),
              const SizedBox(height: 20),
              UpcomingEventsPanel(events: sampleEvents),
            ],
          ),
        ),
      ),
    );
  }

  static String _monthLabel(int month, int year) {
    const monthNames = <String>[
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${monthNames[month - 1]} $year';
  }
}

class _CalendarHeader extends StatelessWidget {
  const _CalendarHeader({required this.monthLabel});

  final String monthLabel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary,
            colorScheme.primaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Calendar',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            monthLabel,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: colorScheme.onPrimary.withValues(alpha: 0.88),
                ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _HeaderStat(
                label: 'Today',
                value: '1 view',
                color: colorScheme.onPrimary,
              ),
              const SizedBox(width: 12),
              _HeaderStat(
                label: 'Focus',
                value: '4 events',
                color: colorScheme.onPrimary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderStat extends StatelessWidget {
  const _HeaderStat({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: color.withValues(alpha: 0.82),
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}