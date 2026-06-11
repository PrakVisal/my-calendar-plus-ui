import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:test_app/core/constants/colors.dart';
import 'package:test_app/core/constants/text_styles.dart';
import 'package:test_app/core/utils/duration_parsers.dart';

/// A custom shared badge displaying event duration with a Lucide clock icon.
class DurationBadge extends StatelessWidget {
  const DurationBadge({
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
    final durationStr = DurationParsers.formatDuration(startDate, endDate, allDay);
    if (durationStr.isEmpty) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.getBorder(context).withValues(alpha: isDark ? 0.3 : 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            LucideIcons.clock,
            size: 12,
            color: AppColors.getTextSecondary(context),
          ),
          const SizedBox(width: 4),
          Text(
            durationStr,
            style: AppTextStyles.captionMedium(context).copyWith(
              color: AppColors.getTextSecondary(context),
            ),
          ),
        ],
      ),
    );
  }
}
