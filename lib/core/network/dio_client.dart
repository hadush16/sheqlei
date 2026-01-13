// import 'package:dio/dio.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// final dioProvider = Provider<Dio>((ref) {
//   return Dio(
//     BaseOptions(
//       // Corrected double slash and base path
//       baseUrl: 'http://192.168.0.104:3000/api/v1',
//       connectTimeout: const Duration(seconds: 10),
//       receiveTimeout: const Duration(seconds: 10),
//       headers: {
//         'Content-Type': 'application/json',
//         'Accept': 'application/json',
//       },
//     ),
//   );
// });
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://192.168.0.104:3000/api/v1',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  /// 🔹 GLOBAL ERROR HANDLING
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        // Optional: log request
        return handler.next(options);
      },
      onResponse: (response, handler) {
        // 🔹 Handle incorrect backend response structure
        if (response.data == null) {
          return handler.reject(
            DioException(
              requestOptions: response.requestOptions,
              error: 'Empty response from server',
              type: DioExceptionType.badResponse,
            ),
          );
        }
        return handler.next(response);
      },
      onError: (DioException error, handler) {
        // 🔥 NETWORK / TIMEOUT HANDLING
        String message = _mapDioError(error);

        return handler.reject(
          DioException(
            requestOptions: error.requestOptions,
            error: message,
            type: error.type,
            response: error.response,
          ),
        );
      },
    ),
  );

  return dio;
});

/// 🔹 HUMAN-READABLE ERROR MESSAGES
String _mapDioError(DioException error) {
  if (error.type == DioExceptionType.connectionTimeout ||
      error.type == DioExceptionType.sendTimeout ||
      error.type == DioExceptionType.receiveTimeout) {
    return 'Connection timeout. Please try again.';
  }

  if (error.type == DioExceptionType.connectionError ||
      error.error is SocketException) {
    return 'No internet connection.';
  }

  if (error.type == DioExceptionType.badResponse) {
    final statusCode = error.response?.statusCode ?? 0;

    if (statusCode >= 500) {
      return 'Server error. Please try again later.';
    } else if (statusCode == 404) {
      return 'Requested resource not found.';
    } else if (statusCode == 401) {
      return 'Unauthorized request.';
    } else {
      return 'Something went wrong. Please try again.';
    }
  }

  return 'Unexpected error occurred.';
}
