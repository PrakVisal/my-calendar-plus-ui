import 'package:flutter/material.dart';
import 'package:test_app/features/calendar/data/datasources/calendar_api_service.dart';
import 'package:test_app/features/calendar/domain/calendar_event.dart';
import 'package:test_app/features/calendar/domain/repositories/calendar_repository.dart';

class CalendarRepositoryImpl implements CalendarRepository {
  CalendarRepositoryImpl({CalendarApiService? api}) : _api = api ?? CalendarApiService();

  final CalendarApiService _api;
  final List<Event> _cachedEvents = <Event>[];

  bool _lastFetchUsedFallback = false;

  bool get lastFetchUsedFallback => _lastFetchUsedFallback;

  @override
  Future<Event> createEvent(Event event) async {
    _cachedEvents.add(event);
    try {
      final created = await _api.createEvent(event);
      _replaceCachedEvent(created);
      _lastFetchUsedFallback = false;
      return created;
    } catch (_) {
      _lastFetchUsedFallback = true;
      return event;
    }
  }

  @override
  Future<void> deleteEvent(String id) async {
    _cachedEvents.removeWhere((event) => event.id == id);
    try {
      await _api.deleteEvent(id);
      _lastFetchUsedFallback = false;
    } catch (_) {
      _lastFetchUsedFallback = true;
    }
  }

  @override
  Future<List<Event>> getEvents(int month, int year) async {
    try {
      final events = await _api.getEvents(month, year);
      _lastFetchUsedFallback = false;
      _syncCache(events);
      return events;
    } catch (_) {
      _lastFetchUsedFallback = true;
      if (_cachedEvents.isNotEmpty) {
        return _cachedEvents.where((event) => event.startDate.year == year && event.startDate.month == month).toList();
      }

      final fallbackEvents = _buildFallbackEvents(month: month, year: year);
      _syncCache(fallbackEvents);
      return fallbackEvents;
    }
  }

  @override
  Future<Event> updateEvent(String id, Event event) async {
    _replaceCachedEvent(event.copyWith(id: id));
    try {
      final updated = await _api.updateEvent(id, event);
      _replaceCachedEvent(updated);
      _lastFetchUsedFallback = false;
      return updated;
    } catch (_) {
      _lastFetchUsedFallback = true;
      return event.copyWith(id: id);
    }
  }

  void _syncCache(List<Event> events) {
    _cachedEvents
      ..clear()
      ..addAll(events);
  }

  void _replaceCachedEvent(Event event) {
    final index = _cachedEvents.indexWhere((cached) => cached.id == event.id);
    if (index == -1) {
      _cachedEvents.add(event);
      return;
    }

    _cachedEvents[index] = event;
  }

  List<Event> _buildFallbackEvents({required int month, required int year}) {
    final monthStart = DateTime(year, month, 1);

    return <Event>[
      Event(
        id: 'fallback-1',
        title: 'Design sync',
        description: 'Offline sample event',
        startDate: monthStart.add(const Duration(days: 2, hours: 9)),
        endDate: monthStart.add(const Duration(days: 2, hours: 10)),
        color: const Color(0xFF245BFF),
      ),
      Event(
        id: 'fallback-2',
        title: 'Sprint review',
        description: 'Offline sample event',
        startDate: monthStart.add(const Duration(days: 6, hours: 13, minutes: 30)),
        endDate: monthStart.add(const Duration(days: 6, hours: 14, minutes: 30)),
        color: const Color(0xFFFF8A00),
      ),
      Event(
        id: 'fallback-3',
        title: 'Family dinner',
        description: 'Offline sample event',
        startDate: monthStart.add(const Duration(days: 11, hours: 19)),
        endDate: monthStart.add(const Duration(days: 11, hours: 21)),
        color: const Color(0xFF11A36A),
      ),
      Event(
        id: 'fallback-4',
        title: 'Weekly planning',
        description: 'Offline sample event',
        startDate: monthStart.add(const Duration(days: 18, hours: 10, minutes: 15)),
        endDate: monthStart.add(const Duration(days: 18, hours: 11, minutes: 15)),
        color: const Color(0xFF8A5CFF),
      ),
    ];
  }
}
