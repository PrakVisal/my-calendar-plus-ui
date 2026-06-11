import 'package:test_app/core/network/api_client.dart';
import 'package:test_app/features/calendar/domain/calendar_event.dart';

class CalendarApiService {
  CalendarApiService({ApiClient? client}) : _client = client ?? ApiClient.instance;

  final ApiClient _client;

  /// GET [baseUrl]?month=6&year=2026
  /// The backend in this project exposes the calendar collection at the
  /// base URL (Env.baseUrl already points to `/api/v1/calendar`).
  Future<List<Event>> getEvents(int month, int year) async {
    final resp = await _client.get('', queryParameters: {'month': month, 'year': year});
    final data = resp.data;
    // Support both: array response or { data: [...] }
    final list = data is List ? data : (data is Map && data['data'] is List ? data['data'] : null);
    if (list is List) {
      return list.map((e) => Event.fromJson(e as Map<String, dynamic>)).toList();
    }

    return [];
  }

  Future<Event> createEvent(Event event) async {
    final resp = await _client.post('', data: event.toJson());
    return Event.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<Event> updateEvent(String id, Event event) async {
    final resp = await _client.put('/$id', data: event.toJson());
    return Event.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<void> deleteEvent(String id) async {
    await _client.delete('/$id');
  }
}
