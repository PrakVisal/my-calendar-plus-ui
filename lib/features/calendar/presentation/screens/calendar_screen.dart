import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:test_app/core/constants/colors.dart';
import 'package:test_app/core/constants/text_styles.dart';
import 'package:test_app/core/utils/date_formatters.dart';
import 'package:test_app/features/calendar/data/models/calendar_day.dart';
import 'package:test_app/features/calendar/domain/providers/calendar_provider.dart';
import 'package:test_app/features/calendar/presentation/widgets/calendar_grid.dart';
import 'package:test_app/features/calendar/presentation/widgets/event_panel.dart';

/// Main calendar hub displaying month switcher, custom date cells grid, and daily event lists.
class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMonth = ref.watch(currentMonthProvider);
    final selectedDay = ref.watch(selectedDayProvider);
    final isOffline = ref.watch(isOfflineProvider);
    
    final calendarState = ref.watch(calendarDataProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                LucideIcons.calendar,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'CalendarPlus',
              style: AppTextStyles.h2(context).copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              isDark ? LucideIcons.sun : LucideIcons.moon,
              color: AppColors.getTextSecondary(context),
            ),
            onPressed: () {
              // Note: theme switching logic is handled by main.dart theme configuration
              // But we can let it be a placeholder or hook it if wanted
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.read(calendarDataProvider.notifier).refresh(),
          color: AppColors.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Offline banner badge if server is unavailable
                if (isOffline) ...[
                  _buildOfflineBanner(context),
                  const SizedBox(height: 16),
                ],

                // Month Switcher Header
                _buildMonthSwitcher(context, ref, currentMonth),
                const SizedBox(height: 16),

                // Calendar Container
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.getSurface(context),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: AppColors.getBorder(context).withValues(alpha: isDark ? 0.3 : 0.6),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.03),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      )
                    ],
                  ),
                  child: calendarState.when(
                    data: (days) {
                      return CalendarGrid(
                        days: days,
                        isLoading: false,
                      );
                    },
                    loading: () {
                      return const CalendarGrid(
                        days: [],
                        isLoading: true,
                      );
                    },
                    error: (err, stack) {
                      return _buildErrorCard(context, ref, err.toString());
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Events Panel for Selected Day
                calendarState.when(
                  data: (days) {
                    final targetDay = days.firstWhere(
                      (d) => _isSameDay(d.date, selectedDay),
                      orElse: () => CalendarDay(
                        date: selectedDay,
                        isCurrentMonth: selectedDay.month == currentMonth.month,
                        isWeekend: selectedDay.weekday == DateTime.saturday || selectedDay.weekday == DateTime.sunday,
                        events: [],
                      ),
                    );

                    return EventPanel(
                      selectedDate: selectedDay,
                      events: targetDay.events,
                      isLoading: false,
                    );
                  },
                  loading: () {
                    return EventPanel(
                      selectedDate: selectedDay,
                      events: const [],
                      isLoading: true,
                    );
                  },
                  error: (err, stack) {
                    return const SizedBox.shrink(); // Hide panel on error since error card handles UI
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOfflineBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.warning.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            LucideIcons.wifiOff,
            color: AppColors.warning,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Offline Mode Active',
                  style: AppTextStyles.bodyMedium(context).copyWith(
                    color: AppColors.warning,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Displaying cached or fallback calendar data.',
                  style: AppTextStyles.caption(context).copyWith(
                    color: AppColors.warning.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthSwitcher(BuildContext context, WidgetRef ref, DateTime currentMonth) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Month Text Display
        Text(
          DateFormatters.formatMonthYear(currentMonth),
          style: AppTextStyles.h1(context),
        ),

        // Navigation Chevron Actions
        Row(
          children: [
            _buildNavigationButton(
              context,
              icon: LucideIcons.chevronLeft,
              onPressed: () {
                final newMonth = DateTime(currentMonth.year, currentMonth.month - 1, 1);
                ref.read(currentMonthProvider.notifier).state = newMonth;
                ref.read(selectedDayProvider.notifier).state = newMonth;
              },
            ),
            const SizedBox(width: 8),
            _buildNavigationButton(
              context,
              icon: LucideIcons.chevronRight,
              onPressed: () {
                final newMonth = DateTime(currentMonth.year, currentMonth.month + 1, 1);
                ref.read(currentMonthProvider.notifier).state = newMonth;
                ref.read(selectedDayProvider.notifier).state = newMonth;
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNavigationButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.getSurface(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.getBorder(context).withValues(alpha: isDark ? 0.3 : 0.6),
        ),
      ),
      child: IconButton(
        icon: Icon(icon, size: 20),
        color: AppColors.getTextPrimary(context),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildErrorCard(BuildContext context, WidgetRef ref, String errorMsg) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        children: [
          const Icon(
            LucideIcons.alertCircle,
            color: AppColors.error,
            size: 40,
          ),
          const SizedBox(height: 12),
          Text(
            'Failed to Load Calendar',
            style: AppTextStyles.subtitle(context).copyWith(
              color: AppColors.error,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            errorMsg,
            style: AppTextStyles.caption(context),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => ref.read(calendarDataProvider.notifier).refresh(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(LucideIcons.refreshCw, size: 16),
            label: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
