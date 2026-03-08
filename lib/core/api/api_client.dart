import 'package:bodh_flutter/core/api/api_endpoints.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: ApiEndpoints.connectionTimeout,
        receiveTimeout: ApiEndpoints.receiveTimeout,
        headers: {
          'Accept': 'application/json',
        },
      ),
    );

    // ✅ Auth interceptor (JWT)
    _dio.interceptors.add(_AuthInterceptor());

    // ✅ Retry on network failures
    _dio.interceptors.add(
      RetryInterceptor(
        dio: _dio,
        retries: 3,
        retryDelays: const [
          Duration(seconds: 1),
          Duration(seconds: 2),
          Duration(seconds: 3),
        ],
        retryEvaluator: (error, attempt) {
          return error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.sendTimeout ||
              error.type == DioExceptionType.receiveTimeout ||
              error.type == DioExceptionType.connectionError;
        },
      ),
    );

    // ✅ Logger (debug only)
    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          error: true,
          compact: true,
        ),
      );
    }
  }

  Dio get dio => _dio;

  // ======================
  // JSON REQUESTS
  // ======================

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  // ======================
  // FILE UPLOAD (IMPORTANT)
  // ======================

Future<Response> uploadFile(
  String path, {
  required FormData formData,
  String method = "POST",
  ProgressCallback? onSendProgress,
}) async {
  const storage = FlutterSecureStorage();
  final token = await storage.read(key: "auth_token");

  return _dio.request(
    path,
    data: formData,
    options: Options(
      method: method,
      contentType: 'multipart/form-data',
      headers: token != null
          ? {
              "Authorization": "Bearer $token",
            }
          : null,
    ),
    onSendProgress: onSendProgress,
  );
}

}

// ======================
// AUTH INTERCEPTOR
// ======================

class _AuthInterceptor extends Interceptor {
  final _storage = const FlutterSecureStorage();
  static const String _tokenKey = "auth_token";

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
final publicEndpoints = {
  ApiEndpoints.login,
  ApiEndpoints.register,
  ApiEndpoints.forgotPassword,
  ApiEndpoints.resetPassword,
};

    if (!publicEndpoints.contains(options.path)) {
      final token = await _storage.read(key: _tokenKey);
      if (token != null && token.isNotEmpty) {
        options.headers["Authorization"] = "Bearer $token";
      }
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      _storage.delete(key: _tokenKey);
    }
    handler.next(err);
  }
}
