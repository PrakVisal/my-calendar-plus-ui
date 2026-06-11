import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:test_app/core/config/env.dart';

/// Lightweight Dio wrapper for HTTP requests with logging and improved errors.
class ApiClient {
  ApiClient._internal()
      : _dio = Dio(BaseOptions(
          baseUrl: Env.baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          responseType: ResponseType.json,
        )) {
    // Add a basic logger for requests/responses
    _dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

    // Workaround for certain SSL setups in desktop/test environments.
    // In production mobile apps this is typically unnecessary.
    try {
      if (_dio.httpClientAdapter is IOHttpClientAdapter) {
        (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
          final client = HttpClient();
          client.badCertificateCallback = (cert, host, port) => false;
          return client;
        };
      }
    } catch (_) {}
  }

  static final ApiClient instance = ApiClient._internal();

  final Dio _dio;

  Future<Response<T>> get<T>(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get<T>(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw _wrapDioError(e);
    }
  }

  Future<Response<T>> post<T>(String path, {Object? data}) async {
    try {
      return await _dio.post<T>(path, data: data);
    } on DioException catch (e) {
      throw _wrapDioError(e);
    }
  }

  Future<Response<T>> put<T>(String path, {Object? data}) async {
    try {
      return await _dio.put<T>(path, data: data);
    } on DioException catch (e) {
      throw _wrapDioError(e);
    }
  }

  Future<Response<T>> delete<T>(String path) async {
    try {
      return await _dio.delete<T>(path);
    } on DioException catch (e) {
      throw _wrapDioError(e);
    }
  }

  Exception _wrapDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.sendTimeout || e.type == DioExceptionType.receiveTimeout) {
      return Exception('Connection timed out. Are you online? ${e.message}');
    }

    if (e.type == DioExceptionType.badCertificate) {
      return Exception('Bad SSL certificate when connecting to ${Env.baseUrl}');
    }

    if (e.type == DioExceptionType.unknown && e.error is SocketException) {
      return Exception('Network error: ${e.error}');
    }

    final status = e.response?.statusCode;
    if (status != null) {
      return Exception('HTTP $status: ${e.response?.statusMessage}');
    }

    return Exception('Network error: ${e.message}');
  }
}
