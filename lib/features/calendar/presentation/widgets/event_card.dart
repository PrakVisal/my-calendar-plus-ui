import 'package:flutter/material.dart';
import 'package:test_app/core/constants/colors.dart';
import 'package:test_app/core/constants/text_styles.dart';
import 'package:test_app/core/widgets/duration_badge.dart';
import 'package:test_app/core/widgets/status_badge.dart';
import 'package:test_app/features/calendar/data/models/calendar_event.dart';
import 'package:test_app/features/calendar/presentation/screens/event_detail_screen.dart';

/// Interactive card showcasing event details like title, badges, and colored border strips.
class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.event,
  });

  final CalendarEvent event;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: AppColors.getBorder(context).withValues(alpha: isDark ? 0.3 : 0.6),
          width: 1,
        ),
      ),
      color: AppColors.getSurface(context),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => EventDetailScreen(event: event),
            ),
          );
        },
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Event category color indicator strip
              Container(
                width: 6,
                color: event.color,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header: Title & Badges
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              event.title,
                              style: AppTextStyles.bodyMedium(context).copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          StatusBadge(
                            startDate: event.startDate,
                            endDate: event.endDate,
                            allDay: event.allDay,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Description
                      if (event.description != null && event.description!.isNotEmpty) ...[
                        Text(
                          event.description!,
                          style: AppTextStyles.bodySecondary(context).copyWith(
                            fontSize: 13,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                      ],

                      // Duration Badge
                      DurationBadge(
                        startDate: event.startDate,
                        endDate: event.endDate,
                        allDay: event.allDay,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
