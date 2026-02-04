import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../errors/app_exception.dart';

class ApiClient {
  ApiClient(this._dio);

  final Dio _dio;

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _runWithRetry(() async {
      final response = await _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data ?? <String, dynamic>{};
    });
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Object? data,
    Options? options,
  }) async {
    return _runWithRetry(() async {
      final response = await _dio.post<Map<String, dynamic>>(
        path,
        data: data,
        options: options,
      );
      return response.data ?? <String, dynamic>{};
    });
  }

  Future<Map<String, dynamic>> put(
    String path, {
    Object? data,
    Options? options,
  }) async {
    return _runWithRetry(() async {
      final response = await _dio.put<Map<String, dynamic>>(
        path,
        data: data,
        options: options,
      );
      return response.data ?? <String, dynamic>{};
    });
  }

  Future<void> delete(
    String path, {
    Object? data,
    Options? options,
  }) async {
    await _runWithRetry(() async {
      await _dio.delete<Map<String, dynamic>>(path, data: data, options: options);
      return null;
    });
  }

  Future<T> _runWithRetry<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on DioException catch (e) {
      if (kDebugMode) {
        debugPrint(
          '[ApiClient] DioException type=${e.type} uri=${e.requestOptions.uri} error=${e.error}',
        );
      }
      if (_isRetriable(e)) {
        try {
          return await request();
        } on DioException catch (e2) {
          if (kDebugMode) {
            debugPrint(
              '[ApiClient] Retry failed type=${e2.type} uri=${e2.requestOptions.uri} error=${e2.error}',
            );
          }
          throw AppException(_extractErrorMessage(e2));
        }
      }
      throw AppException(_extractErrorMessage(e));
    }
  }

  bool _isRetriable(DioException e) {
    return e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.connectionError;
  }

  String _extractErrorMessage(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return 'Network is slow. Please try again.';
    }
    if (e.type == DioExceptionType.connectionError) {
      return 'Unable to connect. Please check your internet.';
    }

    final responseData = e.response?.data;
    final statusCode = e.response?.statusCode;
    if (responseData is Map<String, dynamic>) {
      final message = responseData['message'];
      if (message is String && message.isNotEmpty) {
        return statusCode == null ? message : '[$statusCode] $message';
      }
    }
    final fallback = e.message ?? 'Unexpected network error';
    return statusCode == null ? fallback : '[$statusCode] $fallback';
  }
}
