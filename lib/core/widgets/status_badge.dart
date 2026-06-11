import 'package:flutter/material.dart';
import 'package:test_app/core/constants/colors.dart';
import 'package:test_app/core/constants/text_styles.dart';
import 'package:test_app/core/utils/duration_parsers.dart';

/// A premium capsule badge displaying the status of an event based on its dates.
class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.startDate,
    this.endDate,
    this.allDay = false,
  });

  final DateTime startDate;
  final DateTime? endDate;
  final bool allDay;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    String label;
    Color color;

    if (DurationParsers.isPast(endDate, startDate, now: now)) {
      label = 'Past';
      color = AppColors.getTextMuted(context);
    } else if (DurationParsers.isActive(startDate, endDate, now: now)) {
      label = 'In Progress';
      color = AppColors.success;
    } else {
      label = 'Upcoming';
      color = AppColors.primary;
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.15 : 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: isDark ? 0.3 : 0.15),
          width: 1,
        ),
      ),
      child: Text(
        label.toUpperCase(),
        style: AppTextStyles.badge(context, color: color),
      ),
    );
  }
}
