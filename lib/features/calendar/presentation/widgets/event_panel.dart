import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:test_app/core/constants/colors.dart';
import 'package:test_app/core/constants/text_styles.dart';
import 'package:test_app/core/utils/date_formatters.dart';
import 'package:test_app/core/widgets/empty_state.dart';
import 'package:test_app/features/calendar/data/models/calendar_event.dart';
import 'package:test_app/features/calendar/presentation/widgets/event_card.dart';

/// Renders a list of events scheduled for the selected day.
/// Animates content changes using [AnimatedSwitcher] for smooth UX transitions.
class EventPanel extends StatelessWidget {
  const EventPanel({
    super.key,
    required this.selectedDate,
    required this.events,
    required this.isLoading,
  });

  final DateTime selectedDate;
  final List<CalendarEvent> events;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Panel header showing selected date string
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Text(
            DateFormatters.formatFullDate(selectedDate),
            style: AppTextStyles.h2(context).copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Animated Switcher to swap lists, empty states, and shimmer states smoothly
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          switchInCurve: Curves.easeInOutCubic,
          switchOutCurve: Curves.easeInOutCubic,
          transitionBuilder: (Widget child, Animation<double> animation) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 0.1),
                end: Offset.zero,
              ).animate(animation),
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
          child: _buildPanelContent(context),
        ),
      ],
    );
  }

  Widget _buildPanelContent(BuildContext context) {
    if (isLoading) {
      return _buildShimmerList(context, key: const ValueKey('panel-loading'));
    }

    if (events.isEmpty) {
      return EmptyState(
        key: ValueKey('panel-empty-${selectedDate.toIso8601String()}'),
      );
    }

    return ListView.builder(
      key: ValueKey('panel-list-${selectedDate.toIso8601String()}'),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: events.length,
      itemBuilder: (context, index) {
        return EventCard(event: events[index]);
      },
    );
  }

  Widget _buildShimmerList(BuildContext context, {required Key key}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      key: key,
      baseColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
      highlightColor: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
      child: Column(
        children: List.generate(2, (index) {
          return Container(
            height: 100,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          );
        }),
      ),
    );
  }
}
