import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_app/features/calendar/domain/calendar_event.dart';

class UpcomingEventsPanel extends StatelessWidget {
  const UpcomingEventsPanel({super.key, required this.events});

  final List<Event> events;

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
        ...events.map((event) {
          final time = event.allDay ? 'All day' : DateFormat.jm().format(event.startDate.toLocal());
          return Padding(
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
                    color: event.color,
                    shape: BoxShape.circle,
                  ),
                ),
                title: Text(
                  event.title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(time),
                trailing: Text(
                  '${event.startDate.month}/${event.startDate.day}',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}