import 'dart:io';

import 'package:bodh_flutter/core/api/api_client.dart';
import 'package:bodh_flutter/core/api/api_endpoints.dart';
import 'package:bodh_flutter/core/services/storage/user_sessions_service.dart';
import 'package:bodh_flutter/features/auth/data/datasources/auth_datasource.dart';
import 'package:bodh_flutter/features/auth/data/models/auth_api_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final authRemoteDatasourceProvider = Provider<IAuthRemoteDatasource>((ref) {
  final apiClient = ref.read(apiClientProvider);
  final userSessionService = ref.read(userSessionServiceProvider);

  return AuthRemoteDatasource(
    apiClient: apiClient,
    userSessionService: userSessionService,
  );
});

class AuthRemoteDatasource implements IAuthRemoteDatasource {
  final ApiClient _apiClient;
  final UserSessionService _userSessionService;

  AuthRemoteDatasource({
    required ApiClient apiClient,
    required UserSessionService userSessionService,
  })  : _apiClient = apiClient,
        _userSessionService = userSessionService;

  static const _tokenKey = "auth_token";
  final _secureStorage = const FlutterSecureStorage();

  @override
  Future<AuthApiModel?> getUserById(String authId) async {
    // ✅ Avoid crashing UI (was throwing UnimplementedError)
    return null;
  }

  @override
  Future<AuthApiModel?> login(String email, String password) async {
    final response = await _apiClient.post(
      ApiEndpoints.login,
      data: {
        "email": email,
        "password": password,
      },
    );

    if (response.data["success"] == true) {
      final data = response.data["data"] as Map<String, dynamic>;
      final token = response.data["token"] as String;

      await _secureStorage.write(key: _tokenKey, value: token);

      final user = AuthApiModel.fromJson(data);

      await _userSessionService.saveUserSession(
        userId: user.authId!,
        email: user.email,
        username: user.username,
        fullName: user.fullName,
        phoneNumber: user.phoneNumber,
        profilePicture: user.profilePicture,
      );

      return user;
    }

    return null;
  }

  @override
  Future<AuthApiModel> register(AuthApiModel user) async {
    final response = await _apiClient.post(
      ApiEndpoints.register,
      data: user.toJson(),
    );

    if (response.data["success"] == true) {
      final data = response.data["data"] as Map<String, dynamic>;
      final registered = AuthApiModel.fromJson(data);

      await _userSessionService.saveUserSession(
        userId: registered.authId!,
        email: registered.email,
        username: registered.username,
        fullName: registered.fullName,
        phoneNumber: registered.phoneNumber,
        profilePicture: registered.profilePicture,
      );

      return registered;
    }

    return user;
  }

  @override
  Future<AuthApiModel?> updateAvatar(File image) async {
    final fileName = image.path.split('/').last;

    final formData = FormData.fromMap({
      "avatar": await MultipartFile.fromFile(
        image.path,
        filename: fileName,
      ),
    });

    final response = await _apiClient.uploadFile(
      ApiEndpoints.updateMyAvatar,
      formData: formData,
      method: "PATCH",
    );

    if (response.data["success"] == true) {
      final data = response.data["data"] as Map<String, dynamic>;
      final updatedUser = AuthApiModel.fromJson(data);

      await _userSessionService.saveUserSession(
        userId: updatedUser.authId!,
        email: updatedUser.email,
        username: updatedUser.username,
        fullName: updatedUser.fullName,
        phoneNumber: updatedUser.phoneNumber,
        profilePicture: updatedUser.profilePicture,
      );

      return updatedUser;
    }

    return null;
  }
}
