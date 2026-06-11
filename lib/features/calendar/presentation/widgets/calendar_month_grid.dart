import 'package:flutter/material.dart';
import 'package:test_app/features/calendar/domain/calendar_event.dart';

class CalendarMonthGrid extends StatelessWidget {
  const CalendarMonthGrid({
    super.key,
    required this.month,
    required this.highlightedDate,
    required this.events,
  });

  final DateTime month;
  final DateTime highlightedDate;
  final List<Event> events;

  @override
  Widget build(BuildContext context) {
    final firstOfMonth = DateTime(month.year, month.month, 1);
    final leadingDays = firstOfMonth.weekday - DateTime.monday;
    final firstGridDate = firstOfMonth.subtract(Duration(days: leadingDays));
    final visibleDays = List.generate(
      42,
      (index) => firstGridDate.add(Duration(days: index)),
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                _WeekdayLabel('M'),
                _WeekdayLabel('T'),
                _WeekdayLabel('W'),
                _WeekdayLabel('T'),
                _WeekdayLabel('F'),
                _WeekdayLabel('S'),
                _WeekdayLabel('S'),
              ],
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: visibleDays.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 0.86,
              ),
              itemBuilder: (context, index) {
                final day = visibleDays[index];
                final isCurrentMonth = day.month == month.month;
                final isToday = _isSameDay(day, highlightedDate);
                final eventCount = events.where((event) => _isSameDay(event.startDate, day)).length;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isToday
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isToday
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${day.day}',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: isToday
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : isCurrentMonth
                                      ? Theme.of(context).colorScheme.onSurface
                                      : Theme.of(context).colorScheme.outline,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const Spacer(),
                      if (eventCount > 0)
                        Wrap(
                          spacing: 3,
                          runSpacing: 3,
                          children: List.generate(
                            eventCount.clamp(1, 3),
                            (dotIndex) => Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: isToday
                                    ? Theme.of(context).colorScheme.onPrimary
                                    : Theme.of(context).colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  bool _isSameDay(DateTime left, DateTime right) {
    return left.year == right.year &&
        left.month == right.month &&
        left.day == right.day;
  }
}

class _WeekdayLabel extends StatelessWidget {
  const _WeekdayLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
    );
  }
}