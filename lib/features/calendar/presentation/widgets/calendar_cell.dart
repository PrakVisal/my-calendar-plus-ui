import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/core/constants/colors.dart';
import 'package:test_app/core/constants/text_styles.dart';
import 'package:test_app/core/widgets/dot_indicator.dart';
import 'package:test_app/features/calendar/data/models/calendar_day.dart';
import 'package:test_app/features/calendar/domain/providers/calendar_provider.dart';

/// Renders a single cell inside the calendar grid representing a day.
class CalendarCell extends ConsumerWidget {
  const CalendarCell({
    super.key,
    required this.day,
  });

  final CalendarDay day;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDay = ref.watch(selectedDayProvider);
    final isSelected = _isSameDay(day.date, selectedDay);
    final isToday = _isSameDay(day.date, DateTime.now());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Background color configuration
    Color? cellBg;
    BoxBorder? cellBorder;

    if (isSelected) {
      cellBg = AppColors.primary;
    } else if (isToday) {
      cellBg = AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.1);
      cellBorder = Border.all(
        color: AppColors.primary.withValues(alpha: 0.5),
        width: 1.5,
      );
    }

    // Weekend styling
    final textStyle = AppTextStyles.dayCell(
      context,
      isSelected: isSelected,
      isCurrentMonth: day.isCurrentMonth,
    ).copyWith(
      color: isSelected
          ? Colors.white
          : isToday
              ? AppColors.primary
              : day.isWeekend && day.isCurrentMonth
                  ? AppColors.accent.withValues(alpha: 0.9)
                  : null,
    );

    return AspectRatio(
      aspectRatio: 1.0,
      child: GestureDetector(
        onTap: () {
          ref.read(selectedDayProvider.notifier).state = day.date;
        },
        child: Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: cellBg,
            borderRadius: BorderRadius.circular(16),
            border: cellBorder,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 4),
              Text(
                day.date.day.toString(),
                style: textStyle,
              ),
              const SizedBox(height: 6),
              // Dot indicator showing events colors
              DotIndicator(
                colors: day.events.map((e) => e.color).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
