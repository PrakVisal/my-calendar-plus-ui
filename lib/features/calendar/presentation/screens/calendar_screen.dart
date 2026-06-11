import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:test_app/features/calendar/domain/calendar_event.dart';
import 'package:test_app/features/calendar/presentation/providers/calendar_notifier.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _focused = DateTime.now();
  DateTime? _selected;

  @override
  Widget build(BuildContext context) {
    final asyncEvents = ref.watch(calendarNotifierProvider);
    final isOffline = ref.watch(calendarOfflineProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Calendar')),
      body: asyncEvents.when(
        data: (events) {
          final eventsByDay = <DateTime, List<Event>>{};
          for (final e in events) {
            final day = DateTime(e.startDate.year, e.startDate.month, e.startDate.day);
            eventsByDay.putIfAbsent(day, () => []).add(e);
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isOffline) ...[
                  MaterialBanner(
                    content: const Text('Showing offline sample data because the backend is unavailable.'),
                    actions: [
                      TextButton(
                        onPressed: () => ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
                        child: const Text('Dismiss'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TableCalendar<Event>(
                      firstDay: DateTime.utc(2000, 1, 1),
                      lastDay: DateTime.utc(2100, 12, 31),
                      focusedDay: _focused,
                      selectedDayPredicate: (d) => isSameDay(_selected, d),
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selected = selectedDay;
                          _focused = focusedDay;
                        });
                      },
                      eventLoader: (day) => eventsByDay[DateTime(day.year, day.month, day.day)] ?? [],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Events',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                if (_selected == null)
                  const Text('Select a day to see events')
                else
                  ...((eventsByDay[DateTime(_selected!.year, _selected!.month, _selected!.day)] ?? [])
                      .map((e) => ListTile(
                            leading: CircleAvatar(backgroundColor: e.color),
                            title: Text(e.title),
                            subtitle: Text(_timeRange(e)),
                            onTap: () {},
                          ))),
              ],
            ),
          );
        },
        error: (e, st) => Center(child: Text('Error: $e')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Open add event screen (not implemented fully here)
          final now = DateTime.now();
          final newEvent = Event(
            title: 'New event',
            description: null,
            startDate: now,
            endDate: now.add(const Duration(hours: 1)),
            color: Theme.of(context).colorScheme.primary,
          );
          await ref.read(calendarNotifierProvider.notifier).createEvent(newEvent);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  String _timeRange(Event e) {
    final f = DateFormat.jm();
    if (e.allDay) return 'All day';
    final start = f.format(e.startDate.toLocal());
    final end = e.endDate != null ? ' - ${f.format(e.endDate!.toLocal())}' : '';
    return '$start$end';
  }
}
