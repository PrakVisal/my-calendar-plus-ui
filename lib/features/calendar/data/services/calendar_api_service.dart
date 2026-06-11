import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:test_app/core/constants/api_endpoints.dart';
import 'package:test_app/features/calendar/data/models/calendar_day.dart';
import 'package:test_app/features/calendar/data/models/calendar_event.dart';

/// Service responsible for handling HTTP communication using Dio.
/// Loads the base URL from the dotenv configuration dynamically.
class CalendarApiService {
  CalendarApiService({Dio? dio}) : _dio = dio ?? _createDefaultDio();

  final Dio _dio;

  static Dio _createDefaultDio() {
    final baseUrl = dotenv.env['API_BASE_URL'] ?? 'https://my-calendar-plus-nuxt-api.vercel.app';
    
    final options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 8),
      receiveTimeout: const Duration(seconds: 8),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    final dio = Dio(options);
    
    // Add logging interceptor for debugging
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => print('Dio: $obj'),
    ));

    return dio;
  }

  /// GET /api/calendar?month=X&year=Y
  /// Fetches the list of CalendarDay items for the given month and year.
  Future<List<CalendarDay>> getCalendar({required int month, required int year}) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.calendar,
        queryParameters: {
          'month': month,
          'year': year,
        },
      );

      var data = response.data;
      if (data is String) {
        data = jsonDecode(data);
      }
      dynamic list;
      if (data is List) {
        list = data;
      } else if (data is Map) {
        if (data['payload'] is Map && data['payload']['data'] is List) {
          list = data['payload']['data'];
        } else if (data['data'] is List) {
          list = data['data'];
        }
      }

      if (list is List) {
        return list.map((e) => CalendarDay.fromJson(e as Map<String, dynamic>)).toList();
      }
      return [];
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// POST /api/calendar
  /// Creates a new calendar event.
  Future<CalendarEvent> createEvent(CalendarEvent event) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.calendar,
        data: event.toJson(),
      );
      var data = response.data;
      if (data is String) {
        data = jsonDecode(data);
      }
      return CalendarEvent.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// PUT /api/calendar/:id
  /// Updates an existing calendar event.
  Future<CalendarEvent> updateEvent(String id, CalendarEvent event) async {
    try {
      final response = await _dio.put(
        '${ApiEndpoints.calendar}/$id',
        data: event.toJson(),
      );
      var data = response.data;
      if (data is String) {
        data = jsonDecode(data);
      }
      return CalendarEvent.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// DELETE /api/calendar/:id
  /// Deletes a calendar event.
  Future<void> deleteEvent(String id) async {
    try {
      await _dio.delete('${ApiEndpoints.calendar}/$id');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException e) {
    String message = 'An error occurred while communicating with the server.';
    
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      message = 'Connection timed out. Please check your internet connection.';
    } else if (e.response != null) {
      final status = e.response?.statusCode;
      final statusMsg = e.response?.statusMessage;
      message = 'Server error ($status): ${statusMsg ?? "Unknown error"}';
    } else if (e.type == DioExceptionType.cancel) {
      message = 'Request to the server was cancelled.';
    } else {
      message = 'Network error: ${e.message}';
    }
    
    return Exception(message);
  }
}
