import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/features/calendar/data/repositories/calendar_repository_impl.dart';
import 'package:test_app/features/calendar/domain/calendar_event.dart';

final calendarRepositoryProvider = Provider<CalendarRepositoryImpl>((ref) {
  return CalendarRepositoryImpl();
});

final calendarOfflineProvider = StateProvider<bool>((ref) => false);

final calendarNotifierProvider = AsyncNotifierProvider<CalendarNotifier, List<Event>>(() => CalendarNotifier());

class CalendarNotifier extends AsyncNotifier<List<Event>> {
  late final CalendarRepositoryImpl _repo;

  @override
  Future<List<Event>> build() async {
    _repo = ref.read(calendarRepositoryProvider);
    // initial load for current month
    final now = DateTime.now();
    return fetchMonth(now.month, now.year);
  }

  Future<List<Event>> fetchMonth(int month, int year) async {
    state = const AsyncValue.loading();
    try {
      final events = await _repo.getEvents(month, year);
      final offline = _repo.lastFetchUsedFallback;
      ref.read(calendarOfflineProvider.notifier).state = offline;
      state = AsyncValue.data(events);
      return events;
    } catch (e, st) {
      ref.read(calendarOfflineProvider.notifier).state = true;
      state = AsyncValue.error(e, st);
      return <Event>[];
    }
  }

  Future<Event> createEvent(Event event) async {
    final created = await _repo.createEvent(event);
    state = AsyncValue.data([...?state.value, created]);
    return created;
  }

  Future<Event> updateEvent(String id, Event event) async {
    final updated = await _repo.updateEvent(id, event);
    state = AsyncValue.data(state.value!.map((e) => e.id == id ? updated : e).toList());
    return updated;
  }

  Future<void> deleteEvent(String id) async {
    await _repo.deleteEvent(id);
    state = AsyncValue.data(state.value!.where((e) => e.id != id).toList());
  }
}
