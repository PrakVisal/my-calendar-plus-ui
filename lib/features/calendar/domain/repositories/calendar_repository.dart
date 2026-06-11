import 'package:test_app/features/calendar/domain/calendar_event.dart';

abstract class CalendarRepository {
  Future<List<Event>> getEvents(int month, int year);

  Future<Event> createEvent(Event event);

  Future<Event> updateEvent(String id, Event event);

  Future<void> deleteEvent(String id);
}
