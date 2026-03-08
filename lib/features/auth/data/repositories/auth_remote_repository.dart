import 'package:bodh_flutter/core/api/api_client.dart';
import 'package:bodh_flutter/core/api/api_endpoints.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRemoteRepositoryProvider = Provider<AuthRemoteRepository>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return AuthRemoteRepository(apiClient);
});

class AuthRemoteRepository {
  final ApiClient _apiClient;

  AuthRemoteRepository(this._apiClient);

  // ===============================
  // FORGOT PASSWORD
  // ===============================
  Future<Map<String, dynamic>> forgotPassword({
    required String email,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.forgotPassword,
        data: {
          "email": email,
        },
      );

      final data = response.data;

      if (data is Map<String, dynamic>) {
        return data;
      } else {
        throw Exception("Invalid response format");
      }
    } on DioException catch (e) {
      final message =
          e.response?.data?["message"] ?? "Forgot password request failed";
      throw Exception(message);
    } catch (_) {
      throw Exception("Forgot password request failed");
    }
  }

  // ===============================
  // RESET PASSWORD
  // ===============================
  Future<Map<String, dynamic>> resetPassword({
    required String token,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.resetPassword,
        data: {
          "token": token,
          "password": password,
        },
      );

      final data = response.data;

      if (data is Map<String, dynamic>) {
        return data;
      } else {
        throw Exception("Invalid response format");
      }
    } on DioException catch (e) {
      final message =
          e.response?.data?["message"] ?? "Reset password request failed";
      throw Exception(message);
    } catch (_) {
      throw Exception("Reset password request failed");
    }
  }
}