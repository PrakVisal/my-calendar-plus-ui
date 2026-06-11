import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/features/calendar/data/models/calendar_day.dart';
import 'package:test_app/features/calendar/data/models/calendar_event.dart';
import 'package:test_app/features/calendar/data/services/calendar_api_service.dart';

/// Provider for [CalendarApiService]
final calendarApiServiceProvider = Provider<CalendarApiService>((ref) {
  return CalendarApiService();
});

/// Tracks if the app is currently running in offline fallback mode.
final isOfflineProvider = StateProvider<bool>((ref) => false);

/// Tracks the currently focused month and year (defaults to current date).
final currentMonthProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, 1);
});

/// Tracks the selected day (defaults to today).
final selectedDayProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

/// Async notifier for loading, caching, and updating calendar day lists.
final calendarDataProvider = AsyncNotifierProvider<CalendarNotifier, List<CalendarDay>>(() {
  return CalendarNotifier();
});

class CalendarNotifier extends AsyncNotifier<List<CalendarDay>> {
  late final CalendarApiService _api;
  final Map<String, List<CalendarDay>> _memoryCache = {};

  @override
  Future<List<CalendarDay>> build() async {
    _api = ref.read(calendarApiServiceProvider);
    
    // Listen to changes in the current month to auto-refresh state
    final currentMonth = ref.watch(currentMonthProvider);
    return fetchMonth(currentMonth.month, currentMonth.year);
  }

  /// Fetches calendar days for the specific month/year.
  /// Uses memory cache as a fallback if offline.
  Future<List<CalendarDay>> fetchMonth(int month, int year) async {
    final cacheKey = '$year-$month';
    
    try {
      final days = await _api.getCalendar(month: month, year: year);
      ref.read(isOfflineProvider.notifier).state = false;
      _memoryCache[cacheKey] = days;
      return days;
    } catch (e) {
      ref.read(isOfflineProvider.notifier).state = true;
      
      // Check cache first
      if (_memoryCache.containsKey(cacheKey)) {
        return _memoryCache[cacheKey]!;
      }
      
      // If cache is empty, generate local fallback data for UX continuity
      final fallbacks = _generateFallbackDays(month: month, year: year);
      _memoryCache[cacheKey] = fallbacks;
      return fallbacks;
    }
  }

  /// Refresh calendar data manually
  Future<void> refresh() async {
    final currentMonth = ref.read(currentMonthProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => fetchMonth(currentMonth.month, currentMonth.year));
  }

  /// Create a calendar event and update local state immediately (optimistic UI)
  Future<void> createEvent(CalendarEvent event) async {
    final currentMonth = ref.read(currentMonthProvider);
    final cacheKey = '${currentMonth.year}-${currentMonth.month}';
    final previousState = state;

    if (state.hasValue) {
      // Find the day matching the event start date
      final updatedList = state.value!.map((day) {
        if (_isSameDay(day.date, event.startDate)) {
          return day.copyWith(events: [...day.events, event]);
        }
        return day;
      }).toList();
      state = AsyncValue.data(updatedList);
    }

    try {
      final created = await _api.createEvent(event);
      // Replace temporary event with server response
      if (state.hasValue) {
        final updatedList = state.value!.map((day) {
          if (_isSameDay(day.date, created.startDate)) {
            final filteredEvents = day.events.where((e) => e.id != event.id).toList();
            return day.copyWith(events: [...filteredEvents, created]);
          }
          return day;
        }).toList();
        state = AsyncValue.data(updatedList);
        _memoryCache[cacheKey] = updatedList;
      }
    } catch (_) {
      // Revert state on network error and notify user
      state = previousState;
      rethrow;
    }
  }

  /// Update an event's details
  Future<void> updateEvent(String id, CalendarEvent event) async {
    final currentMonth = ref.read(currentMonthProvider);
    final cacheKey = '${currentMonth.year}-${currentMonth.month}';
    final previousState = state;

    if (state.hasValue) {
      final updatedList = state.value!.map((day) {
        // If event date changed, we would need to remove from old day and add to new day.
        // For simplicity, update inside matching days.
        final hasEvent = day.events.any((e) => e.id == id);
        final isMatchNewDay = _isSameDay(day.date, event.startDate);

        if (hasEvent || isMatchNewDay) {
          var events = day.events.where((e) => e.id != id).toList();
          if (isMatchNewDay) {
            events.add(event.copyWith(id: id));
          }
          return day.copyWith(events: events);
        }
        return day;
      }).toList();
      state = AsyncValue.data(updatedList);
    }

    try {
      final updated = await _api.updateEvent(id, event);
      if (state.hasValue) {
        final updatedList = state.value!.map((day) {
          final isMatchDay = _isSameDay(day.date, updated.startDate);
          final hasEvent = day.events.any((e) => e.id == id);

          if (hasEvent || isMatchDay) {
            var events = day.events.where((e) => e.id != id).toList();
            if (isMatchDay) {
              events.add(updated);
            }
            return day.copyWith(events: events);
          }
          return day;
        }).toList();
        state = AsyncValue.data(updatedList);
        _memoryCache[cacheKey] = updatedList;
      }
    } catch (_) {
      state = previousState;
      rethrow;
    }
  }

  /// Delete an event from calendar
  Future<void> deleteEvent(String id) async {
    final currentMonth = ref.read(currentMonthProvider);
    final cacheKey = '${currentMonth.year}-${currentMonth.month}';
    final previousState = state;

    if (state.hasValue) {
      final updatedList = state.value!.map((day) {
        final hasEvent = day.events.any((e) => e.id == id);
        if (hasEvent) {
          return day.copyWith(
            events: day.events.where((e) => e.id != id).toList(),
          );
        }
        return day;
      }).toList();
      state = AsyncValue.data(updatedList);
    }

    try {
      await _api.deleteEvent(id);
      if (state.hasValue) {
        _memoryCache[cacheKey] = state.value!;
      }
    } catch (_) {
      state = previousState;
      rethrow;
    }
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Generates visual skeleton mockup data when backend is unreachable.
  List<CalendarDay> _generateFallbackDays({required int month, required int year}) {
    final List<CalendarDay> list = [];
    final firstDayOfMonth = DateTime(year, month, 1);
    
    // Find the starting weekday of the month (Monday = 1, Sunday = 7)
    // We want the grid to start from Monday.
    final int startWeekday = firstDayOfMonth.weekday;
    final int leadingDaysCount = startWeekday - 1; // Days from previous month to show
    
    final startDate = firstDayOfMonth.subtract(Duration(days: leadingDaysCount));
    
    // A standard calendar grid is 42 cells (6 rows of 7 days)
    for (int i = 0; i < 42; i++) {
      final currentDate = startDate.add(Duration(days: i));
      final isCurrent = currentDate.month == month;
      final isWeekend = currentDate.weekday == DateTime.saturday || currentDate.weekday == DateTime.sunday;
      
      final List<CalendarEvent> events = [];
      
      // Let's populate some offline mock events for UX demo
      if (isCurrent && currentDate.day == 5) {
        events.add(CalendarEvent(
          id: 'mock-1',
          title: 'Design Team Sync',
          description: 'Weekly review of the design system components, typography styles, and responsive screens.',
          startDate: DateTime(year, month, 5, 10, 0),
          endDate: DateTime(year, month, 5, 11, 30),
          color: const Color(0xFF6366F1), // Indigo
        ));
      } else if (isCurrent && currentDate.day == 12) {
        events.add(CalendarEvent(
          id: 'mock-2',
          title: 'Flutter Sprint Planning',
          description: 'Kickoff meeting for the v1.1 calendar features including custom cell grid and animated event panels.',
          startDate: DateTime(year, month, 12, 13, 0),
          endDate: DateTime(year, month, 12, 14, 0),
          color: const Color(0xFF10B981), // Emerald
        ));
        events.add(CalendarEvent(
          id: 'mock-3',
          title: 'Doctor Appointment',
          description: 'Routine healthcare checkup. Remember to bring documents.',
          startDate: DateTime(year, month, 12, 16, 0),
          endDate: DateTime(year, month, 12, 17, 0),
          color: const Color(0xFFEC4899), // Pink
        ));
      } else if (isCurrent && currentDate.day == 18) {
        events.add(CalendarEvent(
          id: 'mock-4',
          title: 'Project Presentation',
          description: 'Present the new calendar interface to the client and collect feedback on animations.',
          startDate: DateTime(year, month, 18, 14, 30),
          endDate: DateTime(year, month, 18, 15, 30),
          color: const Color(0xFFF59E0B), // Amber
        ));
      } else if (isCurrent && currentDate.day == 25) {
        events.add(CalendarEvent(
          id: 'mock-5',
          title: 'Personal Development',
          description: 'Read articles and write notes on Riverpod async state management best practices.',
          startDate: DateTime(year, month, 25, 9, 0),
          endDate: DateTime(year, month, 25, 17, 0),
          color: const Color(0xFF8B5CF6), // Purple
          allDay: true,
        ));
      }

      list.add(CalendarDay(
        date: currentDate,
        isCurrentMonth: isCurrent,
        isWeekend: isWeekend,
        events: events,
      ));
    }

    return list;
  }
}
