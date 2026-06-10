import 'package:flutter/material.dart';
import 'package:test_app/features/calendar/domain/calendar_event.dart';

class UpcomingEventsPanel extends StatelessWidget {
  const UpcomingEventsPanel({super.key, required this.events});

  final List<CalendarEvent> events;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upcoming',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 12),
        ...events.map(
          (event) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Card(
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                leading: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: event.accentColor,
                    shape: BoxShape.circle,
                  ),
                ),
                title: Text(
                  event.title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(event.time),
                trailing: Text(
                  '${event.date.month}/${event.date.day}',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}