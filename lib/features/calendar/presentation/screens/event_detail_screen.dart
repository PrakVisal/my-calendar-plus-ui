import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:test_app/core/constants/colors.dart';
import 'package:test_app/core/constants/text_styles.dart';
import 'package:test_app/core/utils/date_formatters.dart';
import 'package:test_app/core/widgets/duration_badge.dart';
import 'package:test_app/core/widgets/status_badge.dart';
import 'package:test_app/features/calendar/data/models/calendar_event.dart';

/// Immersive, premium fullscreen page showing complete information about a selected calendar event.
class EventDetailScreen extends StatelessWidget {
  const EventDetailScreen({
    super.key,
    required this.event,
  });

  final CalendarEvent event;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      body: CustomScrollView(
        slivers: [
          // Dynamic colored header bar with custom background representing the event color
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: event.color,
            elevation: 0,
            leading: CircleAvatar(
              backgroundColor: Colors.black.withValues(alpha: 0.25),
              child: IconButton(
                icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      event.color,
                      event.color.withValues(alpha: 0.6),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: const Stack(
                  children: [
                    // A subtle geometric pattern overlay could go here
                  ],
                ),
              ),
            ),
          ),

          // Content body
          SliverToBoxAdapter(
            child: Container(
              transform: Matrix4.translationValues(0, -20, 0),
              decoration: BoxDecoration(
                color: AppColors.getBackground(context),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and status badge
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          event.title,
                          style: AppTextStyles.h1(context).copyWith(
                            fontSize: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      StatusBadge(
                        startDate: event.startDate,
                        endDate: event.endDate,
                        allDay: event.allDay,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  const Divider(height: 1),
                  const SizedBox(height: 24),

                  // Event Schedule/Time Section
                  Text(
                    'SCHEDULE',
                    style: AppTextStyles.caption(context).copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildScheduleItem(
                    context,
                    icon: LucideIcons.calendar,
                    label: DateFormatters.formatFullDate(event.startDate),
                  ),
                  const SizedBox(height: 12),
                  if (!event.allDay) ...[
                    _buildScheduleItem(
                      context,
                      icon: LucideIcons.clock,
                      label: '${DateFormatters.formatTime(event.startDate)}'
                          '${event.endDate != null ? " - ${DateFormatters.formatTime(event.endDate!)}" : ""}',
                    ),
                    const SizedBox(height: 12),
                  ],
                  _buildScheduleItem(
                    context,
                    icon: LucideIcons.hourglass,
                    widgetLabel: DurationBadge(
                      startDate: event.startDate,
                      endDate: event.endDate,
                      allDay: event.allDay,
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Divider(height: 1),
                  const SizedBox(height: 24),

                  // Event Description Section
                  if (event.description != null && event.description!.isNotEmpty) ...[
                    Text(
                      'DESCRIPTION',
                      style: AppTextStyles.caption(context).copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.getSurface(context),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.getBorder(context).withValues(alpha: isDark ? 0.3 : 0.6),
                        ),
                      ),
                      child: Text(
                        event.description!,
                        style: AppTextStyles.bodySecondary(context).copyWith(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleItem(
    BuildContext context, {
    required IconData icon,
    String? label,
    Widget? widgetLabel,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: AppColors.getTextSecondary(context),
        ),
        const SizedBox(width: 12),
        if (label != null)
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.body(context).copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        if (widgetLabel != null) widgetLabel,
      ],
    );
  }
}
