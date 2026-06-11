import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:test_app/core/constants/colors.dart';
import 'package:test_app/core/constants/text_styles.dart';
import 'package:test_app/core/utils/date_formatters.dart';
import 'package:test_app/features/calendar/data/models/calendar_day.dart';
import 'package:test_app/features/calendar/presentation/widgets/calendar_cell.dart';

/// Renders the calendar weekday headers and the 6-row grid of days.
/// Includes support for a beautiful shimmering skeleton loading state.
class CalendarGrid extends StatelessWidget {
  const CalendarGrid({
    super.key,
    required this.days,
    required this.isLoading,
  });

  final List<CalendarDay> days;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    // Weekday names header row starting from Monday
    final baseDate = DateTime(2026, 6, 1); // Monday
    final List<String> weekdays = List.generate(
      7,
      (i) => DateFormatters.formatWeekdayShort(baseDate.add(Duration(days: i))),
    );

    return Column(
      children: [
        // Weekday Headers
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: weekdays.map((dayName) {
              final isWeekend = dayName == 'Sat' || dayName == 'Sun';
              return Expanded(
                child: Center(
                  child: Text(
                    dayName.toUpperCase(),
                    style: AppTextStyles.captionMedium(context).copyWith(
                      fontWeight: FontWeight.bold,
                      color: isWeekend
                          ? AppColors.accent.withValues(alpha: 0.6)
                          : AppColors.getTextMuted(context),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 4),

        // Grid Content
        isLoading ? _buildShimmerGrid(context) : _buildRealGrid(),
      ],
    );
  }

  Widget _buildRealGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1.0,
      ),
      itemCount: days.length,
      itemBuilder: (context, index) {
        return CalendarCell(day: days[index]);
      },
    );
  }

  Widget _buildShimmerGrid(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Shimmer.fromColors(
      baseColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
      highlightColor: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          childAspectRatio: 1.0,
        ),
        itemCount: 42, // Standard grid length
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          );
        },
      ),
    );
  }
}
